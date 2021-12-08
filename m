Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D137C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  8 Dec 2021 03:13:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E743A4B121;
	Tue,  7 Dec 2021 22:13:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b9nqN-ionpih; Tue,  7 Dec 2021 22:13:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31C6A4B118;
	Tue,  7 Dec 2021 22:13:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E4714B105
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Dec 2021 22:13:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FZgxhK5dghdD for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Dec 2021 22:13:34 -0500 (EST)
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com
 [209.85.215.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B70E4B0B6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Dec 2021 22:13:34 -0500 (EST)
Received: by mail-pg1-f169.google.com with SMTP id 71so871135pgb.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Dec 2021 19:13:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Swy8/OuY7eZOly6ocPZ9mxgHEtZmK1UEOXACc87S3gY=;
 b=XtymyX9zlNlYl7LXmZuaKgWM7mdZvjNOU8vG1s2rQyB+ZkD7UoDdnLCp0Vs65MWuph
 4Bh57TrlweA0WKR2x2oxOdIlzziIHyIXo/Ui6RXcNmGSMi985VPxO9U8pQqoEYablifi
 l+RqCDzgdhOrmKcE1Da1Jo5PHAT9rclIAvgEBb5vZkVYdwbQlCu7O/ugECQo+GZ2SE7r
 GwxlFD4dW8IrUVmhbCsSTU9zGv1r7JMwPY4ZvaMBYQqXEzbuxdE1qCKpWBLmGf8QuiIK
 /PcgoU6NfYrQiO/E7ffgNM5FH9H+Br3u7o+CwoijjtKIv1h4TGLGMlc3gJao6B+1AMOP
 qg9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Swy8/OuY7eZOly6ocPZ9mxgHEtZmK1UEOXACc87S3gY=;
 b=ikpBaqsHJIt2KECarky3EQt5uMFj+gPhC5W62242/VtnzrTeArGcZG7ne9q2bZ08wg
 lYVucOBwK8dVFnvJLqq4fDX2WjcZzgS5hVHRPYUMBRNMeY6i/VttJyMamu33/9b+4CgN
 VXKC2jTvmYZ0xlfWz77QmniNU8HaFL0zc9EZc72Di19r6SY4X4arwo0tCDwgJlRadt26
 254w0u66eg+GkgSGB6RK0sUtG07QwZEKfgNuhzx7U1TNuAYQ/8PQhGxby7kstY09qduS
 5Q+QgoZ5U+ddbe24cik3zcAjj4AyDc8vvwKmBkkbdyL6MzmqD2/qI2di6kfRHsRT/T2Y
 CLVg==
X-Gm-Message-State: AOAM530ZYGMNBANeCtF96h5T5PzM7VrzDOUkfR9rG73QZWUY/S1FwDUj
 gx7PfQI0lM2fmdLZne2AJmITXeSvREP8ogoFiE73WQ==
X-Google-Smtp-Source: ABdhPJzPs5Wt30lI4lHUYFgQ5DfLuPSZWnOItp8U2prWfZUA9E+L6SiQkYvdiLR0vjaFi76tNa04qx+EAZ9aZToArWE=
X-Received: by 2002:a62:874b:0:b0:4a8:2df0:1804 with SMTP id
 i72-20020a62874b000000b004a82df01804mr3077494pfe.39.1638933213252; Tue, 07
 Dec 2021 19:13:33 -0800 (PST)
MIME-Version: 1.0
References: <20211206170223.309789-1-alexandru.elisei@arm.com>
 <20211206170223.309789-4-alexandru.elisei@arm.com>
In-Reply-To: <20211206170223.309789-4-alexandru.elisei@arm.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 7 Dec 2021 19:13:17 -0800
Message-ID: <CAAeT=Fxeu7vRHyt1P8c1YKZ2sKyUjo6W9tqXeUAGHKn=y09AEg@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_SET_PMU
 attribute
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, mingo@redhat.com, tglx@linutronix.de, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Alex,

On Mon, Dec 6, 2021 at 9:02 AM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> When KVM creates an event and there are more than one PMUs present on the
> system, perf_init_event() will go through the list of available PMUs and
> will choose the first one that can create the event. The order of the PMUs
> in the PMU list depends on the probe order, which can change under various
> circumstances, for example if the order of the PMU nodes change in the DTB
> or if asynchronous driver probing is enabled on the kernel command line
> (with the driver_async_probe=armv8-pmu option).
>
> Another consequence of this approach is that, on heteregeneous systems,
> all virtual machines that KVM creates will use the same PMU. This might
> cause unexpected behaviour for userspace: when a VCPU is executing on
> the physical CPU that uses this PMU, PMU events in the guest work
> correctly; but when the same VCPU executes on another CPU, PMU events in
> the guest will suddenly stop counting.
>
> Fortunately, perf core allows user to specify on which PMU to create an
> event by using the perf_event_attr->type field, which is used by
> perf_init_event() as an index in the radix tree of available PMUs.
>
> Add the KVM_ARM_VCPU_PMU_V3_CTRL(KVM_ARM_VCPU_PMU_V3_SET_PMU) VCPU
> attribute to allow userspace to specify the arm_pmu that KVM will use when
> creating events for that VCPU. KVM will make no attempt to run the VCPU on
> the physical CPUs that share this PMU, leaving it up to userspace to
> manage the VCPU threads' affinity accordingly.
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  Documentation/virt/kvm/devices/vcpu.rst | 25 +++++++++++++++++
>  arch/arm64/include/uapi/asm/kvm.h       |  1 +
>  arch/arm64/kvm/pmu-emul.c               | 37 +++++++++++++++++++++++--
>  include/kvm/arm_pmu.h                   |  1 +
>  tools/arch/arm64/include/uapi/asm/kvm.h |  1 +
>  5 files changed, 63 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> index 60a29972d3f1..c82be5cbc268 100644
> --- a/Documentation/virt/kvm/devices/vcpu.rst
> +++ b/Documentation/virt/kvm/devices/vcpu.rst
> @@ -104,6 +104,31 @@ hardware event. Filtering event 0x1E (CHAIN) has no effect either, as it
>  isn't strictly speaking an event. Filtering the cycle counter is possible
>  using event 0x11 (CPU_CYCLES).
>
> +1.4 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_SET_PMU
> +------------------------------------------
> +
> +:Parameters: in kvm_device_attr.addr the address to an int representing the PMU
> +             identifier.
> +
> +:Returns:
> +
> +        =======  ===============================================
> +        -EBUSY   PMUv3 already initialized
> +        -EFAULT  Error accessing the PMU identifier
> +        -ENXIO   PMU not found
> +        -ENODEV  PMUv3 not supported or GIC not initialized
> +        -ENOMEM  Could not allocate memory
> +        =======  ===============================================
> +
> +Request that the VCPU uses the specified hardware PMU when creating guest events
> +for the purpose of PMU emulation. The PMU identifier can be read from the "type"
> +file for the desired PMU instance under /sys/devices (or, equivalent,
> +/sys/bus/even_source). This attribute is particularly useful on heterogeneous
> +systems where there are at least two CPU PMUs on the system.
> +
> +Note that KVM will not make any attempts to run the VCPU on the physical CPUs
> +associated with the PMU specified by this attribute. This is entirely left to
> +userspace.
>
>  2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
>  =================================
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index b3edde68bc3e..1d0a0a2a9711 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -362,6 +362,7 @@ struct kvm_arm_copy_mte_tags {
>  #define   KVM_ARM_VCPU_PMU_V3_IRQ      0
>  #define   KVM_ARM_VCPU_PMU_V3_INIT     1
>  #define   KVM_ARM_VCPU_PMU_V3_FILTER   2
> +#define   KVM_ARM_VCPU_PMU_V3_SET_PMU  3
>  #define KVM_ARM_VCPU_TIMER_CTRL                1
>  #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER                0
>  #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER                1
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index eaaad4c06561..618138c5f792 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -603,6 +603,7 @@ static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
>  static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>  {
>         struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +       struct arm_pmu *arm_pmu = pmu->arm_pmu;
>         struct kvm_pmc *pmc;
>         struct perf_event *event;
>         struct perf_event_attr attr;
> @@ -638,8 +639,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>                 return;
>
>         memset(&attr, 0, sizeof(struct perf_event_attr));
> -       attr.type = PERF_TYPE_RAW;
> -       attr.size = sizeof(attr);
> +       attr.type = arm_pmu ? arm_pmu->pmu.type : PERF_TYPE_RAW;
>         attr.pinned = 1;
>         attr.disabled = !kvm_pmu_counter_is_enabled(vcpu, pmc->idx);
>         attr.exclude_user = data & ARMV8_PMU_EXCLUDE_EL0 ? 1 : 0;
> @@ -941,6 +941,29 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
>         return true;
>  }
>
> +static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
> +{
> +       struct kvm_pmu *kvm_pmu = &vcpu->arch.pmu;
> +       struct arm_pmu_entry *entry;
> +       struct arm_pmu *arm_pmu;
> +       int ret = -ENXIO;
> +
> +       mutex_lock(&arm_pmus_lock);
> +
> +       list_for_each_entry(entry, &arm_pmus, entry) {
> +               arm_pmu = entry->arm_pmu;
> +               if (arm_pmu->pmu.type == pmu_id) {
> +                       kvm_pmu->arm_pmu = arm_pmu;

Shouldn't kvm->arch.pmuver be updated based on the pmu that
is used for the guest ?

Thanks,
Reiji


> +                       ret = 0;
> +                       goto out_unlock;
> +               }
> +       }
> +
> +out_unlock:
> +       mutex_unlock(&arm_pmus_lock);
> +       return ret;
> +}
> +
>  int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  {
>         if (!kvm_vcpu_has_pmu(vcpu))
> @@ -1027,6 +1050,15 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>
>                 return 0;
>         }
> +       case KVM_ARM_VCPU_PMU_V3_SET_PMU: {
> +               int __user *uaddr = (int __user *)(long)attr->addr;
> +               int pmu_id;
> +
> +               if (get_user(pmu_id, uaddr))
> +                       return -EFAULT;
> +
> +               return kvm_arm_pmu_v3_set_pmu(vcpu, pmu_id);
> +       }
>         case KVM_ARM_VCPU_PMU_V3_INIT:
>                 return kvm_arm_pmu_v3_init(vcpu);
>         }
> @@ -1064,6 +1096,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>         case KVM_ARM_VCPU_PMU_V3_IRQ:
>         case KVM_ARM_VCPU_PMU_V3_INIT:
>         case KVM_ARM_VCPU_PMU_V3_FILTER:
> +       case KVM_ARM_VCPU_PMU_V3_SET_PMU:
>                 if (kvm_vcpu_has_pmu(vcpu))
>                         return 0;
>         }
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index e249c5f172aa..ab3046a8f9bb 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -34,6 +34,7 @@ struct kvm_pmu {
>         bool created;
>         bool irq_level;
>         struct irq_work overflow_work;
> +       struct arm_pmu *arm_pmu;
>  };
>
>  struct arm_pmu_entry {
> diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/include/uapi/asm/kvm.h
> index b3edde68bc3e..1d0a0a2a9711 100644
> --- a/tools/arch/arm64/include/uapi/asm/kvm.h
> +++ b/tools/arch/arm64/include/uapi/asm/kvm.h
> @@ -362,6 +362,7 @@ struct kvm_arm_copy_mte_tags {
>  #define   KVM_ARM_VCPU_PMU_V3_IRQ      0
>  #define   KVM_ARM_VCPU_PMU_V3_INIT     1
>  #define   KVM_ARM_VCPU_PMU_V3_FILTER   2
> +#define   KVM_ARM_VCPU_PMU_V3_SET_PMU  3
>  #define KVM_ARM_VCPU_TIMER_CTRL                1
>  #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER                0
>  #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER                1
> --
> 2.34.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
