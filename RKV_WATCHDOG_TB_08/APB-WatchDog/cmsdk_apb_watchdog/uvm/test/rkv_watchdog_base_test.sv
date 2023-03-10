`ifndef RKV_WATCHDOG_BASE_TEST_SV
`define RKV_WATCHDOG_BASE_TEST_SV

virtual class rkv_watchdog_base_test extends uvm_test;

  rkv_watchdog_config cfg;
  rkv_watchdog_env env;
  rkv_watchdog_rgm rgm;

  function new (string name = "rkv_watchdog_base_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rgm = rkv_watchdog_rgm::type_id::create("rgm");
    rgm.build();
    uvm_config_db#(rkv_watchdog_rgm)::set(this, "env", "rgm", rgm);
    cfg = rkv_watchdog_config::type_id::create("cfg");
    cfg.rgm = rgm;
    if(!uvm_config_db#(virtual rkv_watchdog_if)::get(this,"","vif", cfg.vif))
      `uvm_fatal("GETCFG","cannot get virtual interface from config DB")
    uvm_config_db#(rkv_watchdog_config)::set(this, "env", "cfg", cfg);
    env = rkv_watchdog_env::type_id::create("env", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.phase_done.set_drain_time(this, 1us);
    phase.raise_objection(this);
    do_init_clks();
    do_init_regs();
    phase.drop_objection(this);
  endtask

  virtual task do_init_clks();
    // TODO in sub-class
  endtask

  virtual task do_init_regs();
    // wait reset release
    repeat(10) @(posedge cfg.vif.apb_clk);

    // TODO in sub-class
  endtask
endclass

`endif
