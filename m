Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6973074A2
	for <kvmarm@lists.linux.dev>; Tue,  2 Dec 2025 08:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764664557; cv=none; b=Rg/fo7YSvh+YZHnMx1pzbwCOQelettr/kTFXp9FTi5OorOreUCqbk1GsGDziyyKZ13xLZL3wmcdnmNCkGajtUlMcyvyWRPdvkTV1L7SUEKcLf+1gj60sZdNV6it3j4Q7oL63zbwPkSLTnrtAq9jt9mqa7DYlPD+yd8nuhZiYcdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764664557; c=relaxed/simple;
	bh=gHOM5bTm/siJ0+zuEDfJS5XT4JUYNOqWZnXLfLNBnw0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r0zlUA0jMdcS/S4HljUR8YGelyj3QDVDT6gKtozVn7E5LmQRQE78J6jpKCQoSoV8IJp4HAdefMpdnCGCTfb0ctwTvfNn7pb+kDoa1pX4FW5g8LEcFCC5CnDa5ygDa8UCX6iBGPYh8NM3PJ7AW9pvvv35MquGebCkT6joAK+8fA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--changyuanl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B67DB6gi; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--changyuanl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B67DB6gi"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b99763210e5so8782071a12.3
        for <kvmarm@lists.linux.dev>; Tue, 02 Dec 2025 00:35:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764664555; x=1765269355; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W6B5OqMy67kr8q+11wZNONtDWMMpaPIwFbThvyADwmk=;
        b=B67DB6giITW2574LnacvpJbzbDWnGQE9zMD33iQxpHvvzhCP9gF60GM0RLeI4KMqMx
         zjA5VJsr2RoAmWTudZQ3s6CiD0fvXzVQibUt35jkdbmwR34I9ksnDn1Cx1mnkIv7p6v3
         zt3QIvbThRkL+OIzb8ek8kGTiWI0CaFp1ntnLfXuXMn28u54wdxmZrWSnDbL6hngR+F4
         4ilNbosWdutE3aOCISPTPr57nBDGAaR+z3IYTBpUhgh6FIZeLphIjZ0BAJ3b1p6F3464
         lnejBiGREQuJefoW4VAqOrLeIZ6tvxMqxeB/VhtxuNAzlPb44AS9JT23qz7jHScsNuNn
         XJrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764664555; x=1765269355;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W6B5OqMy67kr8q+11wZNONtDWMMpaPIwFbThvyADwmk=;
        b=mrpdrO5/s2oWcEscd0gMSA4h3alsot0f7nhYJtFqyV3oy+7ZpcqElRoGQrKlODoWkJ
         cqW5Bm3KizalvvV+YKA3hfNHqfTqLePEc6WjFXzmC7MV8ThLJQxKtta6P2eIjwG+bc0i
         66r+LKlX2DWFNKiGB0FK4aBju5e04aaihoae1cEWrL42yRbtTdU98gDJpsNVpwqfexDm
         hQR90C3bUMkdn9HHHSpBZuEDh8FzYvgMyaNENjvjDohXoqdbdf7VUFl7F/QpVdg1OOOC
         IU6rDSHPGlr4fAoxWGe8f3j1lVgkGOBJzMWv0GqQQPLYkleWz5OaSOqzkdbYzg4xdrX4
         F6Ew==
X-Forwarded-Encrypted: i=1; AJvYcCXUHxcaFkKiVwkLz9nRPetYLxKhyEK+97vlzbKI+8cH5qrmWBBuO1UZecLvhGvv7kOOXpfosv4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwosIZs+W09PlYqnu5RkbH99MlUUclyS9zMUEaqNO+oT5eNHmQa
	DODAO4EO9SCvE15SDBE1QMsV7I5spcg7G5v+t0aWSw04BtAX6pbCm/VRmlvjFuLcLIQVYd97C29
	2DoMhpBeB5oW9hJ9j88B7DQ==
X-Google-Smtp-Source: AGHT+IGb5peSwTweL+kT4iMjAsZiwlPMM3x6CCn7fxcWmgYrU7ZMSeiv42KQvwk9tb1HT/dlWaP97KF+vN1SUw9m
X-Received: from dybph18.prod.google.com ([2002:a05:7301:4192:b0:2a4:7453:cd4e])
 (user=changyuanl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:6b18:b0:2a4:55ae:fbd8 with SMTP id 5a478bee46e88-2a7192f5ae0mr15983784eec.37.1764664554525;
 Tue, 02 Dec 2025 00:35:54 -0800 (PST)
Date: Tue,  2 Dec 2025 00:35:50 -0800
In-Reply-To: <20250212182558.2865232-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250212182558.2865232-3-maz@kernel.org>
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
Message-ID: <20251202083550.88668-1-changyuanl@google.com>
Subject: Re: [PATCH v2 2/2] KVM: arm64: vgic: Hoist SGI/PPI alloc from
 vgic_init() to kvm_create_vgic()
From: Changyuan Lyu <changyuanl@google.com>
To: maz@kernel.org
Cc: glider@google.com, joey.gouly@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, oliver.upton@linux.dev, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Wed, Feb 12, 2025 at 18:25:58 +0000, Marc Zyngier <maz@kernel.org> wrote:
> If userspace creates vcpus, then a vgic, we end-up in a situation
> where irqchip_in_kernel() will return true, but no private interrupt
> has been allocated for these vcpus. This situation will continue
> until userspace initialises the vgic, at which point we fix the
> early vcpus. Should a vcpu run or be initialised in the interval,
> bad things may happen.
>
> An obvious solution is to move this fix-up phase to the point where
> the vgic is created. This ensures that from that point onwards,
> all vcpus have their private interrupts, as new vcpus will directly
> allocate them.

I have a concern that this patch might cause an issue if userspace creates
VCPUs *after* a VGIC is created but *before* it has been initialized via
`KVM_DEV_ARM_VGIC_CTRL_INIT`.

For example, consider the following call sequence:

1.  Create VGIC via `KVM_CREATE_DEVICE`.
2.  Create all VCPUs.
3.  Issue `KVM_ARM_VCPU_INIT` to all VCPUs.
4.  Issue `KVM_DEV_ARM_VGIC_CTRL_INIT` to the VGIC.

> With that, we have the invariant that when irqchip_in_kernel() is
> true, all vcpus have their private interrupts.
>
> Reported-by: Alexander Potapenko <glider@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-init.c | 74 ++++++++++++++++-----------------
>  1 file changed, 37 insertions(+), 37 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index bc7e22ab5d812..775461cf2d2db 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> [...]
>
> -static int vgic_allocate_private_irqs_locked(struct kvm_vcpu *vcpu)
> +static int vgic_allocate_private_irqs_locked(struct kvm_vcpu *vcpu, u32 type)
>  {
>  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>  	int i;
> @@ -218,17 +236,28 @@ static int vgic_allocate_private_irqs_locked(struct kvm_vcpu *vcpu)
>  			/* PPIs */
>  			irq->config = VGIC_CONFIG_LEVEL;
>  		}
> +
> +		switch (type) {
> +		case KVM_DEV_TYPE_ARM_VGIC_V3:
> +			irq->group = 1;
> +			irq->mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
> +			break;

`vgic_allocate_private_irqs_locked()` appears to be called in two scenarios:

a) When the VGIC is created, in `kvm_vgic_create()`.
b) When a VCPU is created, in `kvm_vm_ioctl_create_vcpu()`.

For scenario (b), the call path is:

`kvm_vm_ioctl_create_vcpu()`
-> `kvm_arch_vcpu_create()`
  -> `kvm_vgic_vcpu_init()`
    -> `vgic_allocate_private_irqs()`
      -> `vgic_allocate_private_irqs_locked()`

However, since the VCPU has just been created, its `MPIDR_EL1` register
value has not been assigned at this point. The VCPU's `MPIDR_EL1`
register is populated later when `KVM_ARM_VCPU_INIT` is issued, via
the following call path:

`kvm_arch_vcpu_ioctl_vcpu_init()`
-> `kvm_vcpu_set_target()`
  -> `__kvm_vcpu_set_target()`
    -> `kvm_reset_vcpu()`
      -> `kvm_reset_sys_regs()`
        -> `reset_mpidr()`

Therefore, with the call sequence I mentioned at the beginning,
`irq->mpidr` would be assigned an uninitialized value. This suggests that
for `irq->mpidr = kvm_vcpu_get_mpidr_aff(vcpu)` to work correctly, we
must rely on the code path from scenario (a). This would imply that
with this patch, all VCPUs must be created and initialized before the
VGIC is created.

> +		case KVM_DEV_TYPE_ARM_VGIC_V2:
> +			irq->group = 0;
> +			irq->targets = BIT(vcpu->vcpu_id);
> +			break;
> +		}
>  	}
>
>  	return 0;
>  }
>
> -static int vgic_allocate_private_irqs(struct kvm_vcpu *vcpu)
> +static int vgic_allocate_private_irqs(struct kvm_vcpu *vcpu, u32 type)
>  {
>  	int ret;
>
>  	mutex_lock(&vcpu->kvm->arch.config_lock);
> -	ret = vgic_allocate_private_irqs_locked(vcpu);
> +	ret = vgic_allocate_private_irqs_locked(vcpu, type);
>  	mutex_unlock(&vcpu->kvm->arch.config_lock);
>
>  	return ret;
> @@ -258,7 +287,7 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
>  	if (!irqchip_in_kernel(vcpu->kvm))
>  		return 0;
>
> -	ret = vgic_allocate_private_irqs(vcpu);
> +	ret = vgic_allocate_private_irqs(vcpu, dist->vgic_model);
>  	if (ret)
>  		return ret;
>
> [...]

Please let me know if my understanding is incorrect. Thank you!

Best,
Changyuan
