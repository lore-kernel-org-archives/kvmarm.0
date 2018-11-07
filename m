From: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Subject: [RFC QEMU 0/2] arm/virt: Account for guest pause time
Date: Tue,  6 Nov 2018 16:32:27 -0800
Message-ID: <1541550749-62397-1-git-send-email-bijan.mottahedeh@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07F6D4A30E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Nov 2018 19:32:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SGna7Wd1XB16 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Nov 2018 19:32:45 -0500 (EST)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B0F904A31C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Nov 2018 19:32:45 -0500 (EST)
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
 by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA70SdYY007056
 for <kvmarm@lists.cs.columbia.edu>; Wed, 7 Nov 2018 00:32:44 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
 by userp2120.oracle.com with ESMTP id 2nh4aqrhdu-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
 for <kvmarm@lists.cs.columbia.edu>; Wed, 07 Nov 2018 00:32:44 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
 by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wA70WhvZ003456
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
 for <kvmarm@lists.cs.columbia.edu>; Wed, 7 Nov 2018 00:32:44 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
 by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wA70WhQg018377
 for <kvmarm@lists.cs.columbia.edu>; Wed, 7 Nov 2018 00:32:43 GMT
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

This patch series address two Qemu issues:

  - improper system clock frequency initialization
  - lack of pause (virtsh suspend) time accounting

A simple test to reproduce the problem executes one or more instances
of the following command in the guest:

dd if=/dev/zero of=/dev/null &

and then pauses and resumes the guest after a certain delay:

virsh suspend <guest>        # pauses the guest
sleep 120
virsh resume <guest>

After the guest is resumed, there are soft lockup warning messages
displayed on the console.

A comparison with x86 shows that hwclock and date values diverge after
the above pause and resume sequence for x86 but remain the same for Arm.

Patch 1 intializes the system clock frequency in Qemu similar to the
kernel.

Patch 2 accumulates the total guest pause time in QEMU and adjusts the
virtual offset counter accordingly before the guest is resumed.

The patches have been tested on an Ampere system.  With the patches the
time behavior is the same as x86 and the soft lockup messages go away.


Clock Frequency Initialization
==============================

Arm v8 provides the virtual counter (cntvct), virtual counter offset
(cntvoff), and counter frequency (cntfrq) registers for guest time
management.

Linux Arm platform code initializes the system clock frequency from
cntrfq_el0 register and sets the value into a statically created device
tree (DT) node.  It is not clear why the timer device node is created
with TIMER_OF_DECLARE().  The DT passed from Qemu to the kernel does not
contain a timer node.

drivers/clocksource/arm_arch_timer.c:

static inline u32 arch_timer_get_cntfrq(void)
{
        return read_sysreg(cntfrq_el0);
}

rate = arch_timer_get_cntfrq();
arch_timer_of_configure_rate(rate, np);

/*
 * For historical reasons, when probing with DT we use whichever (non-zero)
 * rate was probed first, and don't verify that others match. If the first node
 * probed has a clock-frequency property, this overrides the HW register.
 */
static void arch_timer_of_configure_rate(u32 rate, struct device_node *np)
{
...
   if (of_property_read_u32(np, "clock-frequency", &arch_timer_rate)) {
          arch_timer_rate = rate;
...
}

TIMER_OF_DECLARE(armv7_arch_timer, "arm,armv7-timer", arch_timer_of_init);
TIMER_OF_DECLARE(armv8_arch_timer, "arm,armv8-timer", arch_timer_of_init);


Linux then initializes the clock frequency to 50MHZ.

Qemu however hard codes the clock frequency to 62.5MHZ.

target/arm/cpu.h:

/* Scale factor for generic timers, ie number of ns per tick.
 * This gives a 62.5MHz timer.
 */
#define GTIMER_SCALE 16

The suggested fix is to follow the kernel's arch_timer_get_cntfrq()
approach in order to set system_clock_scale to match the kernel's idea
of clock-frequency, rather than using a hard-coded value.

Ultimately, it seems that Qemu should construct the timer DT node and
pass the actual clock frequency value to the kernel that way but that
brings up an interface and backward compatibility considerations.
Furthermore, the implications for ACPI method of probing is not clear.


Pause Time Accounting
=====================

Linux registers two clock sources, a platform-independent jiffies
clocksource and a Arm-specific arch_sys_counter; the read interface
for the latter reads the virtual counter register:

static struct clocksource clocksource_jiffies = {
        .name           = "jiffies",
        .rating         = 1, /* lowest valid rating*/
        .read           = jiffies_read,
        .mask           = CLOCKSOURCE_MASK(32),
        .mult           = TICK_NSEC << JIFFIES_SHIFT, /* details above */
        .shift          = JIFFIES_SHIFT,
        .max_cycles     = 10,
};

static struct clocksource clocksource_counter = {
        .name   = "arch_sys_counter",
        .rating = 400,
        .read   = arch_counter_read,
        .mask   = CLOCKSOURCE_MASK(56),
        .flags  = CLOCK_SOURCE_IS_CONTINUOUS,
};

arch_counter_read()
-> arch_timer_read_counter()
   -> arch_counter_get_cntvct()
      -> arch_timer_reg_read_stable(cntvct_el0)

The virtual counter offset register is set from:

kvm_timer_vcpu_load()
-> set_cntvoff()

The counter is zeroed from:

kvm_timer_vcpu_put()
-> set_cntvoff()

        /*
         * The kernel may decide to run userspace after calling vcpu_put, so
         * we reset cntvoff to 0 to ensure a consistent read between user
         * accesses to the virtual counter and kernel access to the physical
         * counter of non-VHE case. For VHE, the virtual counter uses a fixed
         * virtual offset of zero, so no need to zero CNTVOFF_EL2 register.
         */
        if (!has_vhe())
                set_cntvoff(0);

The virtual counter offset is not modified anywhere however to account
for pause time.  The suggested fix is to add pause time accounting to
Qemu.

One potential issue is whether modifying the virtual counter offset
breaks any assumptions, e.g., see the kvm_timer_vcpu_put() comment above.


hwclock vs. date
================

The hwclock on the ends up in drivers/rtc/rtc-pl031.c

Real Time Clock interface for ARM AMBA PrimeCell 031 RTC

ioctl("/dev/rtc", RTC_RD_TIME, ...)
-> rtc_dev_ioctl()
   -> rtc_read_time()
      -> __rtc_read_time()
         -> pl031_read_time()


The date command reads time from from a vdso page updated as follows:

irq_enter()
-> tick_irq_enter()
   -> tick_nohz_irq_enter()
      -> tick_nohz_update_jiffies()
         -> tick_do_update_jiffies64()
            -> tick_do_update_jiffies64()
               -> update_wall_time()
                  -> timekeeping_advance()
                     -> timekeeping_update()
                        -> update_vsyscall(struct timekeepr *tk)

The struct timekeeper uses the Arm platform clocksource_counter noted above:

(gdb) p tk->tkr_mono
$4 = {clock = 0xffff0000097ddad0 <clocksource_counter>,
  mask = 72057594037927935, cycle_last = 271809294296, mult = 335544320,
  shift = 24, xtime_nsec = 3456106496000000, base = 5435795172160,
  base_real = 1539126455000000000}

This would explain why without any pause time accounting, the both
hwclock and date command show the same time after the guest is resume
from a pause, e.g. with the following sequence:

virsh suspend <guest>
sleep <seconds>
virsh resume <guest>

Bijan Mottahedeh (2):
  arm/virt: Initialize generic timer scale factor dynamically
  arm/virt: Account for guest pause time

 hw/arm/virt.c           | 15 +++++++++++++++
 hw/intc/arm_gicv3_kvm.c | 39 +++++++++++++++++++++++++++++++++++++++
 target/arm/cpu.h        |  3 +++
 target/arm/helper.c     | 19 ++++++++++++++++---
 target/arm/internals.h  |  8 ++++++--
 target/arm/kvm64.c      |  1 +
 6 files changed, 80 insertions(+), 5 deletions(-)

-- 
1.8.3.1
