Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68268C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 16:40:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DCDF8611EE
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 16:40:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DCDF8611EE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55AB94B10C;
	Wed, 22 Sep 2021 12:40:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b2EraB8V9eTa; Wed, 22 Sep 2021 12:39:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A790A4B099;
	Wed, 22 Sep 2021 12:39:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55BFC49DE3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 12:39:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ITQiidtEDIpO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Sep 2021 12:39:56 -0400 (EDT)
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com
 [209.85.216.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AD120407ED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 12:39:56 -0400 (EDT)
Received: by mail-pj1-f48.google.com with SMTP id v19so2483737pjh.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 09:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=PW23i0GIZpYOKEzTqk+0cWYUuyP87m/dxg4zLRnBdeE=;
 b=OHK/38foGKQMIzX+tMw54pe3+we6z+GqAb7EYV48FrolmOZA5ZXs75Vz7ptO5O5QCc
 3ObsP0ezCd98tkelKfylwWr94LLC7Lp5ZoJ8vsQOzxaiw14PVfhxIPD6gSETeTcVr8WC
 RwMAUHFBjrWwdaHOUOLvz2oc8qgwfCSadjUSe6iSExZvCsUwbrX3gaBxA51eCqTFM8cc
 HFO0j3TDOH2XPK5GYrGt1Arj75+JoD3Ucgop5nTuYgoZK136P1tdtFT4e84393IFiBtq
 6Qjwf5UaaLoP7YQWfaDisTvjiWRmaVF85t3igVA4eoy/KYk6zwPrYlIqBrtwL1UlL8J7
 GAug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=PW23i0GIZpYOKEzTqk+0cWYUuyP87m/dxg4zLRnBdeE=;
 b=NjfgMhGcEANo00cuCPAwqY5ti+LuthFlLaaVpyJc4s++RzOfZigyeywqsuviuAo0ns
 LYorDflY4H7Ny/HfcJXEEm9wuOQ+fJ1In+JSuzlRPGmxPn/3FEm4Ta8HmIXywYQqkzHI
 iJ4Zq9wSyWVVrXIUypM9hvUSyzUCfV6R9S24JjZY+UcC+mPfgldo5P0AHCGWUCLxPy8J
 u2bgNpE0kNSq2n+M0VKto/Ujkwt1K27yzjxBeGF1+FDRpREnVhGCyHrZBxDOa+l4YhKG
 L35ZXFIgjr4FQo/u3GFKu1XcpHlWStGAOXfgWW6OOa8KvO0zvrPsN2vEmAikKFp3L6mZ
 gnnA==
X-Gm-Message-State: AOAM532C4n+Upci6qlu1qY0FF+PzFOhleRU66P1rEEhfsUm2ka5Zzh5Z
 BHo0VzJEBZazw7zhWNCcjdTsHklpm/35RulTevvZag==
X-Google-Smtp-Source: ABdhPJz8H/RAL1dI93d737TYTOWsckzgACsNdTYWFWDVvnwdX9XiTvZdEh3MxX8nyFxDYqhzGhMLSHvHBonLNgpfCKs=
X-Received: by 2002:a17:90b:3702:: with SMTP id
 mg2mr52409pjb.110.1632328795320; 
 Wed, 22 Sep 2021 09:39:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210916181510.963449-1-oupton@google.com>
 <20210916181510.963449-7-oupton@google.com>
In-Reply-To: <20210916181510.963449-7-oupton@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 22 Sep 2021 09:39:39 -0700
Message-ID: <CAAeT=Fwrh5L8FNKVJipOH6a8MohRsPOgmJDhojRw8DkAS4Kk2Q@mail.gmail.com>
Subject: Re: [PATCH v8 6/8] KVM: arm64: Allow userspace to configure a guest's
 counter-timer offset
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Sean Christopherson <seanjc@google.com>, Peter Shier <pshier@google.com>,
 Marc Zyngier <maz@kernel.org>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Oliver,

On Thu, Sep 16, 2021 at 11:15 AM Oliver Upton <oupton@google.com> wrote:
>
> Presently, KVM provides no facilities for correctly migrating a guest
> that depends on the physical counter-timer. While most guests (barring
> NV, of course) should not depend on the physical counter-timer, an
> operator may wish to provide a consistent view of the physical
> counter-timer across migrations.
>
> Provide userspace with a new vCPU attribute to modify the guest
> counter-timer offset. Unlike KVM_REG_ARM_TIMER_OFFSET, this attribute is
> hidden from the guest's architectural state. The value offsets *both*
> the virtual and physical counter-timer views for the guest. Only support
> this attribute on ECV systems as ECV is required for hardware offsetting
> of the physical counter-timer.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> ---
>  Documentation/arm64/booting.rst         |  7 ++
>  Documentation/virt/kvm/devices/vcpu.rst | 28 ++++++++
>  arch/arm64/include/asm/sysreg.h         |  2 +
>  arch/arm64/include/uapi/asm/kvm.h       |  1 +
>  arch/arm64/kvm/arch_timer.c             | 96 ++++++++++++++++++++++++-
>  include/clocksource/arm_arch_timer.h    |  1 +
>  include/kvm/arm_arch_timer.h            |  5 ++
>  7 files changed, 138 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/arm64/booting.rst b/Documentation/arm64/booting.rst
> index 3f9d86557c5e..b0e012da9b3b 100644
> --- a/Documentation/arm64/booting.rst
> +++ b/Documentation/arm64/booting.rst
> @@ -340,6 +340,13 @@ Before jumping into the kernel, the following conditions must be met:
>      - SMCR_EL2.LEN must be initialised to the same value for all CPUs the
>        kernel will execute on.
>
> +  For CPUs with the Enhanced Counter Virtualization (FEAT_ECV) extension
> +  present with ID_AA64MMFR0_EL1.ECV >= 0x2:
> +
> +  - if EL3 is present and the kernel is entered at EL2:
> +
> +    - SCR_EL3.ECVEn (bit 28) must be initialized to 0b1.
> +
>  The requirements described above for CPU mode, caches, MMUs, architected
>  timers, coherency and system registers apply to all CPUs.  All CPUs must
>  enter the kernel in the same exception level.  Where the values documented
> diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> index 2acec3b9ef65..f240ecc174ef 100644
> --- a/Documentation/virt/kvm/devices/vcpu.rst
> +++ b/Documentation/virt/kvm/devices/vcpu.rst
> @@ -139,6 +139,34 @@ configured values on other VCPUs.  Userspace should configure the interrupt
>  numbers on at least one VCPU after creating all VCPUs and before running any
>  VCPUs.
>
> +2.2. ATTRIBUTE: KVM_ARM_VCPU_TIMER_PHYS_OFFSET
> +-----------------------------------------
> +
> +:Parameters: in kvm_device_attr.addr the address for the timer offset is a
> +             pointer to a __u64
> +
> +Returns:
> +
> +        ======= ==================================
> +        -EFAULT Error reading/writing the provided
> +                parameter address
> +        -ENXIO  Timer offsetting not implemented
> +        ======= ==================================
> +
> +Specifies the guest's counter-timer offset from the host's virtual counter.
> +The guest's physical counter value is then derived by the following
> +equation:
> +
> +  guest_cntpct = host_cntvct - KVM_ARM_VCPU_TIMER_PHYS_OFFSET
> +
> +The guest's virtual counter value is derived by the following equation:
> +
> +  guest_cntvct = host_cntvct - KVM_REG_ARM_TIMER_OFFSET
> +                       - KVM_ARM_VCPU_TIMER_PHYS_OFFSET
> +
> +KVM does not allow the use of varying offset values for different vCPUs;
> +the last written offset value will be broadcasted to all vCPUs in a VM.
> +
>  3. GROUP: KVM_ARM_VCPU_PVTIME_CTRL
>  ==================================
>
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 3fa6b091384d..d5a686dff57e 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -587,6 +587,8 @@
>  #define SYS_ICH_LR14_EL2               __SYS__LR8_EL2(6)
>  #define SYS_ICH_LR15_EL2               __SYS__LR8_EL2(7)
>
> +#define SYS_CNTPOFF_EL2                        sys_reg(3, 4, 14, 0, 6)
> +
>  /* VHE encodings for architectural EL0/1 system registers */
>  #define SYS_SCTLR_EL12                 sys_reg(3, 5, 1, 0, 0)
>  #define SYS_CPACR_EL12                 sys_reg(3, 5, 1, 0, 2)
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 949a31bc10f0..70e2893c1749 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -366,6 +366,7 @@ struct kvm_arm_copy_mte_tags {
>  #define KVM_ARM_VCPU_TIMER_CTRL                1
>  #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER                0
>  #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER                1
> +#define   KVM_ARM_VCPU_TIMER_PHYS_OFFSET       2
>  #define KVM_ARM_VCPU_PVTIME_CTRL       2
>  #define   KVM_ARM_VCPU_PVTIME_IPA      0
>
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 9d9bac3ec40e..4bba149d140c 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -86,8 +86,11 @@ static u64 timer_get_offset(struct arch_timer_context *ctxt)
>  {
>         switch(arch_timer_ctx_index(ctxt)) {
>         case TIMER_VTIMER:
> +       case TIMER_PTIMER:
>                 return ctxt->host_offset;
>         default:
> +               WARN_ONCE(1, "unrecognized timer %ld\n",
> +                         arch_timer_ctx_index(ctxt));
>                 return 0;
>         }
>  }
> @@ -140,6 +143,7 @@ static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
>  {
>         switch(arch_timer_ctx_index(ctxt)) {
>         case TIMER_VTIMER:
> +       case TIMER_PTIMER:
>                 ctxt->host_offset = offset;
>                 break;
>         default:
> @@ -568,6 +572,11 @@ static void set_cntvoff(u64 cntvoff)
>         kvm_call_hyp(__kvm_timer_set_cntvoff, cntvoff);
>  }
>
> +static void set_cntpoff(u64 cntpoff)
> +{
> +       write_sysreg_s(cntpoff, SYS_CNTPOFF_EL2);
> +}
> +
>  static inline void set_timer_irq_phys_active(struct arch_timer_context *ctx, bool active)
>  {
>         int r;
> @@ -643,6 +652,8 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
>         }
>
>         set_cntvoff(timer_get_offset(map.direct_vtimer));
> +       if (kvm_timer_physical_offset_allowed())
> +               set_cntpoff(timer_get_offset(map.direct_ptimer));
>
>         kvm_timer_unblocking(vcpu);
>
> @@ -810,6 +821,22 @@ static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
>         mutex_unlock(&kvm->lock);
>  }
>
> +static void update_ptimer_cntpoff(struct kvm_vcpu *vcpu, u64 cntpoff)
> +{
> +       struct kvm *kvm = vcpu->kvm;
> +       u64 cntvoff;
> +
> +       mutex_lock(&kvm->lock);
> +
> +       /* adjustments to the physical offset also affect vtimer */
> +       cntvoff = timer_get_offset(vcpu_vtimer(vcpu));
> +       cntvoff += cntpoff - timer_get_offset(vcpu_ptimer(vcpu));
> +
> +       update_timer_offset(vcpu, TIMER_PTIMER, cntpoff, false);
> +       update_timer_offset(vcpu, TIMER_VTIMER, cntvoff, false);
> +       mutex_unlock(&kvm->lock);
> +}
> +
>  void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>  {
>         struct arch_timer_cpu *timer = vcpu_timer(vcpu);
> @@ -1346,6 +1373,9 @@ void kvm_timer_init_vhe(void)
>         val = read_sysreg(cnthctl_el2);
>         val |= (CNTHCTL_EL1PCEN << cnthctl_shift);
>         val |= (CNTHCTL_EL1PCTEN << cnthctl_shift);
> +
> +       if (cpus_have_final_cap(ARM64_HAS_ECV2))
> +               val |= CNTHCTL_ECV;
>         write_sysreg(val, cnthctl_el2);
>  }
>
> @@ -1360,7 +1390,8 @@ static void set_timer_irqs(struct kvm *kvm, int vtimer_irq, int ptimer_irq)
>         }
>  }
>
> -int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> +static int kvm_arm_timer_set_attr_irq(struct kvm_vcpu *vcpu,
> +                                     struct kvm_device_attr *attr)
>  {
>         int __user *uaddr = (int __user *)(long)attr->addr;
>         struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> @@ -1393,7 +1424,37 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>         return 0;
>  }
>
> -int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> +static int kvm_arm_timer_set_attr_offset(struct kvm_vcpu *vcpu,
> +                                        struct kvm_device_attr *attr)
> +{
> +       u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> +       u64 offset;
> +
> +       if (!kvm_timer_physical_offset_allowed())
> +               return -ENXIO;
> +
> +       if (get_user(offset, uaddr))
> +               return -EFAULT;
> +
> +       update_ptimer_cntpoff(vcpu, offset);
> +       return 0;
> +}
> +
> +int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> +{
> +       switch (attr->attr) {
> +       case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
> +       case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
> +               return kvm_arm_timer_set_attr_irq(vcpu, attr);
> +       case KVM_ARM_VCPU_TIMER_PHYS_OFFSET:
> +               return kvm_arm_timer_set_attr_offset(vcpu, attr);
> +       default:
> +               return -ENXIO;
> +       }
> +}
> +
> +static int kvm_arm_timer_get_attr_irq(struct kvm_vcpu *vcpu,
> +                                     struct kvm_device_attr *attr)
>  {
>         int __user *uaddr = (int __user *)(long)attr->addr;
>         struct arch_timer_context *timer;
> @@ -1414,12 +1475,43 @@ int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>         return put_user(irq, uaddr);
>  }
>
> +static int kvm_arm_timer_get_attr_offset(struct kvm_vcpu *vcpu,
> +                                        struct kvm_device_attr *attr)
> +{
> +       u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> +       u64 offset;
> +
> +       if (!kvm_timer_physical_offset_allowed())
> +               return -ENXIO;
> +
> +       offset = timer_get_offset(vcpu_ptimer(vcpu));
> +       return put_user(offset, uaddr);
> +}
> +
> +int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu,
> +                          struct kvm_device_attr *attr)
> +{
> +       switch (attr->attr) {
> +       case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
> +       case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
> +               return kvm_arm_timer_get_attr_irq(vcpu, attr);
> +       case KVM_ARM_VCPU_TIMER_PHYS_OFFSET:
> +               return kvm_arm_timer_get_attr_offset(vcpu, attr);
> +       default:
> +               return -ENXIO;
> +       }
> +}
> +
>  int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  {
>         switch (attr->attr) {
>         case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
>         case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
>                 return 0;
> +       case KVM_ARM_VCPU_TIMER_PHYS_OFFSET:
> +               if (kvm_timer_physical_offset_allowed())
> +                       return 0;
> +               break;
>         }
>
>         return -ENXIO;
> diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
> index 73c7139c866f..7252ffa3d675 100644
> --- a/include/clocksource/arm_arch_timer.h
> +++ b/include/clocksource/arm_arch_timer.h
> @@ -21,6 +21,7 @@
>  #define CNTHCTL_EVNTEN                 (1 << 2)
>  #define CNTHCTL_EVNTDIR                        (1 << 3)
>  #define CNTHCTL_EVNTI                  (0xF << 4)
> +#define CNTHCTL_ECV                    (1 << 12)
>
>  enum arch_timer_reg {
>         ARCH_TIMER_REG_CTRL,
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index 615f9314f6a5..aa666373f603 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -110,4 +110,9 @@ void kvm_arm_timer_write_sysreg(struct kvm_vcpu *vcpu,
>  u32 timer_get_ctl(struct arch_timer_context *ctxt);
>  u64 timer_get_cval(struct arch_timer_context *ctxt);
>
> +static inline bool kvm_timer_physical_offset_allowed(void)
> +{
> +       return cpus_have_final_cap(ARM64_HAS_ECV2) && has_vhe();
> +}
> +
>  #endif


In my understanding, the offset that the code below specifies
to call update_vtimer_cntvoff() is (guest's virtual counter) offset
from the host's counter, which is always same as guest's virtual
counter offset from the guest's physical counter-timer before this patch.

int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
{
        struct arch_timer_context *timer;

        switch (regid) {
        <...>
        case KVM_REG_ARM_TIMER_CNT:
                timer = vcpu_vtimer(vcpu);
                update_vtimer_cntvoff(vcpu, kvm_phys_timer_read() - value);
                break;
        <...>

With this patch, since the guest's counter-timer offset from the host's
counter can be set by userspace, doesn't the code need to specify
guest's virtual counter offset (from guest's physical counter-timer) ?

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
