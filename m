Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2A52F50
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 19:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727809504; cv=none; b=BpwGlCVVNPSEmbyKTZ20g2B5QYl2UitFdJrmF+C+5o2spB9dC1EmxaP4x5EFVGazxUiOJK4yzBtlEz7iQmu+pyHpCedF2eoffMs/QHRjFZka0BI/TZVu98axxSDYIz6gJ3S3UnhlLC1ps17VRatr0I03XBFcDd7kHPDBU/55Tv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727809504; c=relaxed/simple;
	bh=g6Lj84hmed5dHS7oxueyPB4Y5u1TBd2Rxo/Vk7QmwZ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CktEAzuadLQOUsZ5NFE+SF+gEfp7pAvCJbiW4JMC5qOHFmzzKQshTCPnQKgRq++nBLTSPq1IdO77XnM02AWw+fOPpj6fXwtUPt9shvp/FW3QbM11Jnx6kkv6g5oCOMRKw+5SY9+lngAmW1itS/Ug6SjbTT45h3gjYirKZ+/BlTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YvvSyBa2; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YvvSyBa2"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7d4fc1a2bb7so5134023a12.1
        for <kvmarm@lists.linux.dev>; Tue, 01 Oct 2024 12:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727809503; x=1728414303; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KP7bIGn628nPRgFVUP2K8Ks1JDBOckXS9ehhXL76qkI=;
        b=YvvSyBa2ZeRjE0yFP1De+Y7TSwQ0NAUhcDXoIe+rDztJRsroG5iVe7cQeipcWkV7Lo
         14h8N68atQrl1NNUIUqvyXUZxrdSSDy84KUyXCiQiHRk9KUnRz+Txh4S6VzXb9do/AIH
         RFxAiwPp1oYNJoxf4n9xjpE13t/FNUvHsH4XNNqbSZmNpNYJw9+b6Be3EEY1uzKzPvst
         mSRqv2vA+rPJhRrEtj93SwpLRi5+EFHVYgSj3RSXJJf1K3UptiId1YBaZntVZOs2mRYs
         zKXIWqT9scEJ1n0xropx4n3xOGZl6DO4CdlCB8A5jkUjUupO7OW2GFwCUQoYXxDjT4Mv
         kTvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727809503; x=1728414303;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KP7bIGn628nPRgFVUP2K8Ks1JDBOckXS9ehhXL76qkI=;
        b=Xr9fRsK34MTAt6HGlF0XlHTs6YcshOIm2YWua5NxxAAYvJvwTiALSB1k0m+G0G+THx
         07tSnoFlAQO9wZEeduB1XHHjU0kCIRBfVbQcq/xxZwimmdJlxQOVsXh1h6VtsfgSjAOB
         R5BnWhKHjvsFIE3XJiUtjdltz7a+BWTgUrzetkX1bPaUI2k/KQlUAePj28w8dafsK4tn
         leQRRZCCsFBcmvfrWBT79k4w+Zy7OF6v+sVco6xxtwjCd26W+63GWpGS7IyJ/MdaUBCN
         jwExnblt8pqDyCWevq5U/GOAQARU0tUTiQFiMomOS2qXnepCDzbpKXj0Sssox1A2f2E7
         TfyA==
X-Gm-Message-State: AOJu0YxW62xnK195U5dFvBRe89pdrK+CEjtPVf0CSeE7EcfujDAJEi1T
	yLzH1LdMQzy/yOpkSfKNnB+2fiUvZac/xtxkr9MiBeeFEZP9Rb4PWmdav9L56sNt7q2VYUo+ujt
	ToQ==
X-Google-Smtp-Source: AGHT+IEaG80iOC/lQwZz5wIqmTMZ3vx8eW5Db4JZCb8mBc2PBdAFFduIGmgZqIDSYy5Y2RrtNoNdwSlWElg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:62c7:0:b0:7cd:82fb:3de3 with SMTP id
 41be03b00d2f7-7e9afe10227mr500a12.4.1727809502494; Tue, 01 Oct 2024 12:05:02
 -0700 (PDT)
Date: Tue, 1 Oct 2024 12:05:01 -0700
In-Reply-To: <20241001001709.1303668-4-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241001001709.1303668-1-oliver.upton@linux.dev> <20241001001709.1303668-4-oliver.upton@linux.dev>
Message-ID: <ZvxH3el9SNuNWwi8@google.com>
Subject: Re: [PATCH 3/3] KVM: arm64: nv: Punt stage-2 recycling to a vCPU request
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 01, 2024, Oliver Upton wrote:
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 367f0d3d3194..ab7d387379a0 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1031,6 +1031,8 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
>  
>  		if (kvm_dirty_ring_check_request(vcpu))
>  			return 0;
> +
> +		check_nested_vcpu_requests(vcpu);
>  	}
>  
>  	return 1;
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 1ba211541290..749babdbda81 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -632,9 +632,9 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
>  	/* set the scene for the next search */
>  	kvm->arch.nested_mmus_next = (i + 1) % kvm->arch.nested_mmus_size;
>  
> -	/* clear the old state */
> +	/* make sure we don't forget to do the laundry */
>  	if (kvm_s2_mmu_valid(s2_mmu))
> -		kvm_stage2_unmap_range(s2_mmu, 0, kvm_phys_size(s2_mmu), false);
> +		s2_mmu->pending_unmap = true;

Question time.  The code that's just out of sight modifies the nested MMU's tlb_vttbr:

	s2_mmu->tlb_vttbr = vcpu_read_sys_reg(vcpu, vttbr_el2) & ~vttbr_cnp_bit;
	s2_mmu->tlb_vtcr = vcpu_read_sys_reg(vcpu, vtcr_el2);
	s2_mmu->nested_stage2_enabled = vcpu_read_sys_reg(vcpu, hcr_el2) & hcr_vm;

which is consumed by kvm_s2_mmu_iterate_by_vmid().  IIUC, kvm_s2_mmu_iterate_by_vmid()
is used only when emulating some form of tlbi that's executed by the guest?  I.e.
is guaranteed to do the right thing because KVM ensures the old state is purged
prior to entering the guest?

>  	/*
>  	 * the virtual vmid (modulo cnp) will be used as a key when matching
> @@ -649,6 +649,9 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
>  	s2_mmu->nested_stage2_enabled = vcpu_read_sys_reg(vcpu, hcr_el2) & hcr_vm;
>  
>  out:
> +	if (s2_mmu->pending_unmap)
> +		kvm_make_request(kvm_req_nested_s2_unmap, vcpu);

If I followed everything correctly, I don't think a request is needed.  the
request will never be cross-vCPU, and each vCPU holds a reference to the MMU, so
the MMU can't be recycled, i.e. pending_unmap is guaranteed to be relevant to the
vCPU's usage of the MMU.  More thoughts below in check_nested_vcpu_requests().

Somewhat of a side topic, the handling of xfer_to_guest_mode_handle_work() in
kvm_arch_vcpu_ioctl_run() is confusing.  If a signal is pending (ret == -eintr),
KVM will skip checking requests, e.g. not unmap the nested stage-2, but then continue
with other pieces of the entry flow.  I'm guessing that's intentional as it looks
like KVM needs to flush hardware state in case that info is exposed to userspace.

But it really warps the mind when trying to reason about what will happen if
there is a relevant request, e.g. if the below code needs to load a new stage-2
for a new vmid, it could do so with the to-be-unmapped contents.

		/*
		 * check conditions before entering the guest
		 */
		ret = xfer_to_guest_mode_handle_work(vcpu);
		if (!ret)
			ret = 1;

		if (ret > 0)
			ret = check_vcpu_requests(vcpu);

		/*
		 * preparing the interrupts to be injected also
		 * involves poking the gic, which must be done in a
		 * non-preemptible context.
		 */
		preempt_disable();

		/*
		 * the vmid allocator only tracks active vmids per
		 * physical cpu, and therefore the vmid allocated may not be
		 * preserved on vmid roll-over if the task was preempted,
		 * making a thread's vmid inactive. so we need to call
		 * kvm_arm_vmid_update() in non-premptible context.
		 */
		if (kvm_arm_vmid_update(&vcpu_to_hw_mmu_unsafe(vcpu)->vmid) &&
		    has_vhe())
			__load_stage2(vcpu_to_hw_mmu_unsafe(vcpu),
				      &vcpu->kvm->arch);

> +
>  	kvm_get_s2_mmu(s2_mmu);
>  	return s2_mmu;
>  }
> @@ -1186,3 +1189,17 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
>  
>  	return 0;
>  }
> +
> +void check_nested_vcpu_requests(struct kvm_vcpu *vcpu)
> +{
> +	if (kvm_check_request(kvm_req_nested_s2_unmap, vcpu)) {
> +		CLASS(vcpu_hw_mmu, mmu)(vcpu);
> +
> +		write_lock(&vcpu->kvm->mmu_lock);
> +		if (mmu->pending_unmap) {

I doubt it's a functional issue, but if multiple vCPUs are purging the same nested
stage-2 MMU, and the first vCPU yields while unmapping, then KVM will end up with
multiple vCPUs doing the unmap.  And irrespective of whether or not the first vCPU
(or vCPUs) yields, they'll all contend for mmu_lock, which is especially problematic
since pending writers will block future readers.

Would it instead make sense to do something like the below?  Checking for the
need to unmap outside of mmu_lock would also more or less eliminate the need for
a request.

#define KVM_S2_UNMAP_PENDING		BIT(0)
#define KVM_S2_UNMAP_IN_PROGRESS	BIT(1)

	unsigned long ops = atomic_read(mmu->unmap_operations);
	unsigned long new;

	if (!(ops & KVM_S2_UNMAP_PENDING))
		return;

	if (!(ops & KVM_S2_UNMAP_IN_PROGRESS)) {
		ops = cmpxchg(mmu->unmap_operations, ops,
			      ops | KVM_S2_UNMAP_IN_PROGRESS);

	/* Nothing more to do if the unmap already completed. */
	if (!(ops & KVM_S2_UNMAP_PENDING))
		return;

	/* If a different vCPU started the unmap, simply wait for it to finish. */
	if (ops & KVM_S2_UNMAP_IN_PROGRESS) {
		while (atomic_read(&mmu->unmap_operations))
			cond_resched(); /* enter a waitq? */
		return;
	}

	write_lock(&vcpu->kvm->mmu_lock);
	kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), true);
	write_unlock(&vcpu->kvm->mmu_lock);

	atomic_set(&mmu->unmap_operations, 0);

> +			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), true);
> +			mmu->pending_unmap = false;
> +		}
> +		write_unlock(&vcpu->kvm->mmu_lock);
> +	}
> +}
> -- 
> 2.46.1.824.gd892dcdcdd-goog
