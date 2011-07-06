using System;
using System.Collections.Generic;
using System.Text;

namespace OpenFlashChart
{
    public  abstract class ChartBase
    {
        public abstract Double GetMinValue();
        public abstract Double GetMaxValue();
        public abstract int GetValueCount();
       
    }
}
