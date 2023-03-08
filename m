Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C845479DA
	for <kvmarm@lists.linux.dev>; Wed,  8 Mar 2023 16:15:26 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-536d63d17dbso176141167b3.22
        for <kvmarm@lists.linux.dev>; Wed, 08 Mar 2023 08:15:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678292125;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VX0arJfywVqX35g0k9tTR96olhe6Rkzh63HEalsQBTw=;
        b=aPIOdJt1pRbjHSKwY3bsDGW706qA4XO7N4boM4lbWxK/PBtA403Fu/YqwfRqcYvv2n
         kq6jNmJLvSU5VespFOiix83xyP/407O41I7oIka7d6Mb+Jf43Wcwoy9SY7H+NLzpzNhX
         IVm/j0rghG7cBIW3fw4KQrMwV5FkD1IGVM9HUQAv8/qHRFe3Ev0HfvKe6MtzsUn8nujz
         ifbuoFe4Wb/h3+yTKYa1uF1SIaLvM9DyLUW9NNF9qi61wMvp3JskFcXqicGtCWxzmhCU
         N3jyuSPJesCD5FjipZbFa4RD7uFXmi5utkwlJkeD3RD4sVuY3vd8ZnJ0vKKIvtvc25N0
         NAkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678292125;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VX0arJfywVqX35g0k9tTR96olhe6Rkzh63HEalsQBTw=;
        b=eJI7IHOQ29bjWzaFeBX/KDUvNbk0dv3+zYgvKWZo+DrFfr7w+WR5/XrLra30gove/J
         EW16KPGExkYAijmJZaEVwSGcn31P2h2qELpb4lYne3VoI1jMaiZwed+ShfMDg2W+SaEX
         eR40ebwbt8zheDdUwClAqLq87Q5TDOsRvGLtZRGin4T5uHEtoJZ/EcyXF1+uTRWrPBhM
         SNEbJEHg79wZA6ctdJPMDc46xSmU/jxgmikzJkc3qyRwFrPcdMCKei4Og7ywgC3MMcVM
         6sG3intbTRbwoZ7oktluMt/kKMtKQvXxInKdPpmlNmOdjSwUyD+sdICWmL5sBwJaCZ5u
         Dvow==
X-Gm-Message-State: AO0yUKUb3lSJZ06G6ihS47VYG8IuKZLnqqdY6mno4uqbazdL2pK/uxH2
	7Ma5iOFktnDlVX+tHkaE2YpNaM8Ez68=
X-Google-Smtp-Source: AK7set9UJuVbluBf/SIC/ORw1wCMPIiECgOe6v4cF0q4qKiigQ1h9x3MzmAdArjQ38PeP5zmQYwjniK1pqQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:524:b0:9f1:7c28:4925 with SMTP id
 y4-20020a056902052400b009f17c284925mr9235518ybs.9.1678292125779; Wed, 08 Mar
 2023 08:15:25 -0800 (PST)
Date: Wed, 8 Mar 2023 08:15:24 -0800
In-Reply-To: <20230308083947.3760066-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230308083947.3760066-1-oliver.upton@linux.dev>
Message-ID: <ZAi0nAHRLWa/Tqjx@google.com>
Subject: Re: [PATCH] KVM: arm64: Avoid inverted vcpu->mutex v. kvm->lock ordering
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	Jeremy Linton <jeremy.linton@arm.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Mar 08, 2023, Oliver Upton wrote:
> I'm somewhat annoyed with the fix here, but annoyance alone isn't enough
> to justify significantly reworking our locking scheme, and especially
> not to address an existing bug.
> 
> I believe all of the required mutual exclusion is preserved, but another
> set of eyes looking at this would be greatly appreciated. Note that the
> issues in arch_timer were separately addressed by a patch from Marc [*].
> With both patches applied I no longer see any lock inversion warnings w/
> selftests nor kvmtool.

Oof.  Would it make sense to split this into ~3 patches, one for each logical
area? E.g. PMU, PSCI, and vGIC?  That would help reviewers and would give you
the opportunity to elaborate on the safety of the change.  Or maye even go a step
further and add multiple locks?  The PMU mess in particular would benefit from
a dedicated lock.
 
> [*] https://lore.kernel.org/kvmarm/20230224191640.3396734-1-maz@kernel.org/
> 
>  arch/arm64/include/asm/kvm_host.h  |  3 +++
>  arch/arm64/kvm/arm.c               |  6 ++++--
>  arch/arm64/kvm/hypercalls.c        |  4 ++--
>  arch/arm64/kvm/pmu-emul.c          | 18 +++++++++---------
>  arch/arm64/kvm/psci.c              |  8 ++++----
>  arch/arm64/kvm/reset.c             |  6 +++---
>  arch/arm64/kvm/vgic/vgic-init.c    | 20 ++++++++++----------
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c |  5 +++--
>  arch/arm64/kvm/vgic/vgic-mmio.c    | 12 ++++++------
>  9 files changed, 44 insertions(+), 38 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index a1892a8f6032..2b1070a526de 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -16,6 +16,7 @@
>  #include <linux/types.h>
>  #include <linux/jump_label.h>
>  #include <linux/kvm_types.h>
> +#include <linux/mutex.h>
>  #include <linux/percpu.h>
>  #include <linux/psci.h>
>  #include <asm/arch_gicv3.h>
> @@ -185,6 +186,8 @@ struct kvm_protected_vm {
>  };
>  
>  struct kvm_arch {
> +	struct mutex lock;

A comment explaining exactly what this protects would be very helpful for folks
that aren't familiar with KVM ARM.

> @@ -961,17 +961,17 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  		     filter.action != KVM_PMU_EVENT_DENY))
>  			return -EINVAL;
>  
> -		mutex_lock(&kvm->lock);
> +		mutex_lock(&kvm->arch.lock);
>  
>  		if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags)) {
> -			mutex_unlock(&kvm->lock);
> +			mutex_unlock(&kvm->arch.lock);
>  			return -EBUSY;
>  		}
>  
>  		if (!kvm->arch.pmu_filter) {
>  			kvm->arch.pmu_filter = bitmap_alloc(nr_events, GFP_KERNEL_ACCOUNT);

I believe there's an existing bug here.  nr_events is grabbed from kvm_pmu_event_mask(),
i.e. which depends on kvm->arch.arm_pmu->pmuver, outside of the lock. 

kvm_arm_pmu_v3_set_pmu() disallows changing the PMU type after a filter has been
set, but the ordering means nr_events can be computed on a stale PMU.  E.g. if
userspace does KVM_ARM_VCPU_PMU_V3_SET_PMU and KVM_ARM_VCPU_PMU_V3_FILTER
concurrently on two different tasks.

KVM_ARM_VCPU_PMU_V3_IRQ is similarly sketchy.  pmu_irq_is_valid() iterates over
all vCPUs without holding any locks, which in and of itself is safe, but then it
it checks vcpu->arch.pmu.irq_num for every vCPU.  I believe concurrent calls to
KVM_ARM_VCPU_PMU_V3_IRQ would potentially result in pmu_irq_is_valid() returning
a false postive.

I don't see anything that would break by holding a lock for the entire function,
e.g. ending up with something like this

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 07444fa22888..2394c598e429 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -957,7 +957,9 @@ int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
 
        switch (attr->group) {
        case KVM_ARM_VCPU_PMU_V3_CTRL:
+               mutex_lock(&vcpu->kvm->arch.pmu_lock);
                ret = kvm_arm_pmu_v3_set_attr(vcpu, attr);
+               mutex_unlock(&vcpu->kvm->arch.pmu_lock);
                break;
        case KVM_ARM_VCPU_TIMER_CTRL:
                ret = kvm_arm_timer_set_attr(vcpu, attr);

>  			if (!kvm->arch.pmu_filter) {
> -				mutex_unlock(&kvm->lock);
> +				mutex_unlock(&kvm->arch.lock);
>  				return -ENOMEM;
>  			}
>  
> @@ -373,7 +373,7 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
>  	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
>  }
>  
> -/* To be called with kvm->lock held */
> +/* To be called with kvm->arch.lock held */

Opportunistically convert to lockdep?

>  static void __kvm_vgic_destroy(struct kvm *kvm)
>  {
>  	struct kvm_vcpu *vcpu;

...

> @@ -441,7 +441,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
>  	if (likely(vgic_ready(kvm)))
>  		return 0;
>  
> -	mutex_lock(&kvm->lock);
> +	mutex_lock(&kvm->arch.lock);
>  	if (vgic_ready(kvm))
>  		goto out;

This is buggy.  KVM_CREATE_IRQCHIP and KVM_CREATE_DEVICE protect vGIC creation
with kvm->lock, whereas this (obviously) now takes only kvm->arch.lock.
kvm_vgic_create() sets

	kvm->arch.vgic.in_kernel = true;

before it has fully initialized "vgic", and so all of these flows that are being
converted can race with the final setup of the vGIC.
