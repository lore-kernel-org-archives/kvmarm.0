From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [RFC] arm/cpu: fix soft lockup panic after resuming from stop
Date: Tue, 12 Mar 2019 10:08:47 +0000
Message-ID: <CAFEAcA-29Q-sTg2wLre0GJJCr2gfu89rg0vuTOf7cW5drE4d7Q@mail.gmail.com>
References: <1552370960-2061-1-git-send-email-guoheyi@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A5D34A408
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Mar 2019 06:09:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vSfMB9N-CATH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Mar 2019 06:08:59 -0400 (EDT)
Received: from mail-io1-f66.google.com (mail-io1-f66.google.com
 [209.85.166.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 533774A2E5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Mar 2019 06:08:59 -0400 (EDT)
Received: by mail-io1-f66.google.com with SMTP id f6so1582475iop.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Mar 2019 03:08:59 -0700 (PDT)
In-Reply-To: <1552370960-2061-1-git-send-email-guoheyi@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Heyi Guo <guoheyi@huawei.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, QEMU Developers <qemu-devel@nongnu.org>, qemu-arm <qemu-arm@nongnu.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 12 Mar 2019 at 06:10, Heyi Guo <guoheyi@huawei.com> wrote:
>
> When we stop a VM for more than 30 seconds and then resume it, by qemu
> monitor command "stop" and "cont", Linux on VM will complain of "soft
> lockup - CPU#x stuck for xxs!" as below:
>
> [ 2783.809517] watchdog: BUG: soft lockup - CPU#3 stuck for 2395s!
> [ 2783.809559] watchdog: BUG: soft lockup - CPU#2 stuck for 2395s!
> [ 2783.809561] watchdog: BUG: soft lockup - CPU#1 stuck for 2395s!
> [ 2783.809563] Modules linked in...
>
> This is because Guest Linux uses generic timer virtual counter as
> a software watchdog, and CNTVCT_EL0 does not stop when VM is stopped
> by qemu.
>
> This patch is to fix this issue by saving the value of CNTVCT_EL0 when
> stopping and restoring it when resuming.

Hi -- I know we have issues with the passage of time in Arm VMs
running under KVM when the VM is suspended, but the topic is
a tricky one, and it's not clear to me that this is the correct
way to fix it. I would prefer to see us start with a discussion
on the kvm-arm mailing list about the best approach to the problem.

I've cc'd that list and a couple of the Arm KVM maintainers
for their opinion.

QEMU patch left below for context -- the brief summary is that
it uses KVM_GET_ONE_REG/KVM_SET_ONE_REG on the timer CNT register
to save it on VM pause and write that value back on VM resume.

thanks
-- PMM



> Cc: Peter Maydell <peter.maydell@linaro.org>
> Signed-off-by: Heyi Guo <guoheyi@huawei.com>
> ---
>  target/arm/cpu.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 65 insertions(+)
>
> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
> index 96f0ff0..7bbba3d 100644
> --- a/target/arm/cpu.c
> +++ b/target/arm/cpu.c
> @@ -896,6 +896,60 @@ static void arm_cpu_finalizefn(Object *obj)
>  #endif
>  }
>
> +static int get_vcpu_timer_tick(CPUState *cs, uint64_t *tick_at_pause)
> +{
> +    int err;
> +    struct kvm_one_reg reg;
> +
> +    reg.id = KVM_REG_ARM_TIMER_CNT;
> +    reg.addr = (uintptr_t) tick_at_pause;
> +
> +    err = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
> +    return err;
> +}
> +
> +static int set_vcpu_timer_tick(CPUState *cs, uint64_t tick_at_pause)
> +{
> +    int err;
> +    struct kvm_one_reg reg;
> +
> +    reg.id = KVM_REG_ARM_TIMER_CNT;
> +    reg.addr = (uintptr_t) &tick_at_pause;
> +
> +    err = kvm_vcpu_ioctl(cs, KVM_SET_ONE_REG, &reg);
> +    return err;
> +}
> +
> +static void arch_timer_change_state_handler(void *opaque, int running,
> +                                            RunState state)
> +{
> +    static uint64_t hw_ticks_at_paused;
> +    static RunState pre_state = RUN_STATE__MAX;
> +    int err;
> +    CPUState *cs = (CPUState *)opaque;
> +
> +    switch (state) {
> +    case RUN_STATE_PAUSED:
> +        err = get_vcpu_timer_tick(cs, &hw_ticks_at_paused);
> +        if (err) {
> +            error_report("Get vcpu timer tick failed: %d", err);
> +        }
> +        break;
> +    case RUN_STATE_RUNNING:
> +        if (pre_state == RUN_STATE_PAUSED) {
> +            err = set_vcpu_timer_tick(cs, hw_ticks_at_paused);
> +            if (err) {
> +                error_report("Resume vcpu timer tick failed: %d", err);
> +            }
> +        }
> +        break;
> +    default:
> +        break;
> +    }
> +
> +    pre_state = state;
> +}
> +
>  static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
>  {
>      CPUState *cs = CPU(dev);
> @@ -906,6 +960,12 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
>      Error *local_err = NULL;
>      bool no_aa32 = false;
>
> +    /*
> +     * Only add change state handler for arch timer once, for KVM will help to
> +     * synchronize virtual timer of all VCPUs.
> +     */
> +    static bool arch_timer_change_state_handler_added;
> +
>      /* If we needed to query the host kernel for the CPU features
>       * then it's possible that might have failed in the initfn, but
>       * this is the first point where we can report it.
> @@ -1181,6 +1241,11 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
>
>      init_cpreg_list(cpu);
>
> +    if (!arch_timer_change_state_handler_added && kvm_enabled()) {
> +        qemu_add_vm_change_state_handler(arch_timer_change_state_handler, cs);
> +        arch_timer_change_state_handler_added = true;
> +    }
> +
>  #ifndef CONFIG_USER_ONLY
>      if (cpu->has_el3 || arm_feature(env, ARM_FEATURE_M_SECURITY)) {
>          cs->num_ases = 2;
> --
> 1.8.3.1
