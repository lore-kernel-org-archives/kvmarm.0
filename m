Received: from mta0.migadu.com (out-12.mta0.migadu.com [91.218.175.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1260E2F7EE9
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 13:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790688180; cv=none; b=ZLMjh0KU/vlWIlCh+OFyNDIr6p6FV2biDtg9IVe7oQbRcgVCRuaAkF6F9e3gM+ecbUBoZLnE4sk6f7aJ/8ASs56kjRIH0HGjCIzKLeYFJDalj56oAhxV3Mv4jS4pxSX4+KRh1DPr0r+kzGZtTloFwOO7aIO25dIPcUJSNnTPkBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790688180; c=relaxed/simple;
	bh=A/v7LPhRkH6ascBEThHb/vODFW80MSZ8BAktCxFOPL4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M2wktPdQgjna/9br6J1Iz1zNt8ZxFgU38+R6aYK3mEQ0odmsoV9TVGSAc0GE/ZypzDGsyU/WDHobRzB/uyrWD2WuYsCwVMe9FeqLEc0ktww7ImikuyubV4/s2oDvzao0+1svAKUcX02rMoMAgIrIhMQbiu3ZWUv4MfTOvJsGKrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xGRPHOC4; arc=none smtp.client-ip=91.218.175.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xGRPHOC4"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=A/v7LPhRkH6ascBEThHb/vODFW80MSZ8BAktCxFOPL4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790688174; v=1; x=1791292974;
 b=xGRPHOC4VOQ3+sVj6In3mJimicpaYt8IRvt3bbJmY8rATe+IBu1to0tcWpdroAMk28KRyw8z
 1vNS9kEXQOAsVHWYmfL5UJGb1Lz8B8xfuFaqGR7ZS565Np4Qg7aV4tBMNAgYeJfY07WNpWS40B5
 GVmfoygewO1neYtgJN5LH9mE=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 97957a3aa1451cfd;
	Tue, 29 Sep 2026 13:22:54 +0000
X-Mizu-Trace-ID: 97957a3aa1451cfd
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5b8e81e2a0bso8274e87.0
        for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 06:22:54 -0700 (PDT)
X-Gm-Message-State: AFq9FYK1B0NQITJTvlVfzwm4n1OLL41cPsgCxHzw+uQRqf0NWmR4vwPg
	D+F+bnESb8xtB3/tKBdDd5tJm02V7VgubksZOvrehsY5DLA03RBF30LFN4gu4QyQitITd8bgeyE
	mGP/58OhXt2W/gYJELM8qfZ28OuPZ4DYiF1zFDGtb
X-Received: by 2002:a05:6512:628d:b0:5ae:b1b3:145a with SMTP id
 2adb3069b0e04-5ba2e7b40d0mr148813e87.6.1790688173434; Tue, 29 Sep 2026
 06:22:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260929093548.3598547-1-maz@kernel.org> <20260929093548.3598547-3-maz@kernel.org>
In-Reply-To: <20260929093548.3598547-3-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 29 Sep 2026 14:22:17 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzzX9g1+kgX_hBZ8gKQ1hbGbNjHrm0QMjQMmM0j-=SoXQ@mail.gmail.com>
X-Gm-Features: AclHuK_L9SaIlRtG-n3tXUkF9oIjgxk-0gMREksoQR95sfSSAdxHohLUu-uHe4Y
Message-ID: <CA+EHjTzzX9g1+kgX_hBZ8gKQ1hbGbNjHrm0QMjQMmM0j-=SoXQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] KVM: arm64: Turn vcpu->arch.pause into a counter
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Steffen Eiden <seiden@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Yuchao Zhang <ndaugoing@gmail.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 29 Sept 2026 at 10:36, Marc Zyngier <maz@kernel.org> wrote:
>
> We have situations where we can call kvm_arm_halt_guest() without
> holding config_lock, which means that halt and resume can overlap in
> funny ways when called from separate contexts, and result in situations
> where a vcpu is resumed while other parts of KVM assume it is halted.
> Consequences are left to the imagination of the reader.
>
> Fix this sorry situation by turning kvm_vcpu_arch::pause into an
> atomic counter, which makes the races described above harmless.
>
> Fixes: 3b92830ad41b2 ("KVM: arm/arm64: implement kvm_arm_[halt,resume]_guest")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba < fuad.tabba@linux.dev>

Cheers,
/fuad


> ---
>  arch/arm64/include/asm/kvm_host.h |  7 +++----
>  arch/arm64/kvm/arm.c              | 21 ++++++++++++---------
>  2 files changed, 15 insertions(+), 13 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 27fe0cd5b2d7a..66ea2372f9870 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -889,11 +889,10 @@ struct kvm_vcpu_arch {
>         /*
>          * Don't run the guest (internal implementation need).
>          *
> -        * Contrary to the flags above, this is set/cleared outside of
> -        * a vcpu context, and thus cannot be mixed with the flags
> -        * themselves (or the flag accesses need to be made atomic).
> +        * Contrary to the flags above, this is updated outside of
> +        * a vcpu context, and thus cannot be mixed with the flags.
>          */
> -       bool pause;
> +       atomic_t pause;
>
>         /*
>          * We maintain more than a single set of debug registers to support
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 5f5dd8bead4b9..9a4871cd796bc 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -561,6 +561,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>         kvm_arm_pvtime_vcpu_init(&vcpu->arch);
>
>         vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
> +       atomic_set(&vcpu->arch.pause, 0);
>
>         /*
>          * This vCPU may have been created after mpidr_data was initialized.
> @@ -835,6 +836,11 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>         return ret;
>  }
>
> +static bool vcpu_can_run(struct kvm_vcpu *vcpu)
> +{
> +       return !kvm_arm_vcpu_stopped(vcpu) && !atomic_read(&vcpu->arch.pause);
> +}
> +
>  /**
>   * kvm_arch_vcpu_runnable - determine if the vcpu can be scheduled
>   * @v:         The VCPU pointer
> @@ -850,8 +856,7 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
>                       (kvm_timer_should_notify_user(v) ||
>                        kvm_pmu_should_notify_user(v)));
>
> -       return ((irq_lines || kvm_vgic_vcpu_pending_irq(v))
> -               && !kvm_arm_vcpu_stopped(v) && !v->arch.pause);
> +       return ((irq_lines || kvm_vgic_vcpu_pending_irq(v)) && vcpu_can_run(v));
>  }
>
>  bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
> @@ -1014,7 +1019,7 @@ void kvm_arm_halt_guest(struct kvm *kvm)
>         struct kvm_vcpu *vcpu;
>
>         kvm_for_each_vcpu(i, vcpu, kvm)
> -               vcpu->arch.pause = true;
> +               atomic_inc(&vcpu->arch.pause);
>         kvm_make_all_cpus_request(kvm, KVM_REQ_SLEEP);
>  }
>
> @@ -1024,8 +1029,8 @@ void kvm_arm_resume_guest(struct kvm *kvm)
>         struct kvm_vcpu *vcpu;
>
>         kvm_for_each_vcpu(i, vcpu, kvm) {
> -               vcpu->arch.pause = false;
> -               __kvm_vcpu_wake_up(vcpu);
> +               if (atomic_dec_and_test(&vcpu->arch.pause))
> +                       __kvm_vcpu_wake_up(vcpu);
>         }
>  }
>
> @@ -1033,11 +1038,9 @@ static void kvm_vcpu_sleep(struct kvm_vcpu *vcpu)
>  {
>         struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
>
> -       rcuwait_wait_event(wait,
> -                          (!kvm_arm_vcpu_stopped(vcpu)) && (!vcpu->arch.pause),
> -                          TASK_INTERRUPTIBLE);
> +       rcuwait_wait_event(wait, vcpu_can_run(vcpu), TASK_INTERRUPTIBLE);
>
> -       if (kvm_arm_vcpu_stopped(vcpu) || vcpu->arch.pause) {
> +       if (!vcpu_can_run(vcpu)) {
>                 /* Awaken to handle a signal, request we sleep again later. */
>                 kvm_make_request(KVM_REQ_SLEEP, vcpu);
>         }
> --
> 2.47.3
>
