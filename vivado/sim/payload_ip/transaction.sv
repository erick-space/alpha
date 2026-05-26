class tranasaction 
  
  axis_if trans_axis_if;
  
  function new(data, valid);
    this.trans_axis_if.tvalid = valid;
    this.trans_axis_if.tdata = data;
  endfunction //new()


endclass //className extends superClass