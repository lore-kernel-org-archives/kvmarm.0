Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46371511209;
	Fri, 18 Sep 2026 16:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789747851; cv=none; b=HFHX5Xx+Iequ7SVcJPGUccTZx9eAkJmqGh9sPqTV4bTfeUyg3+VJkTKxu4ZMDaVG7ZSzQohG1QBWK0mVK1y1iGxujVKKijSIpj5JV7gq5+214OIsVJoueUpjC2Bkim4Md/DMmzOazqkwHWf+h8W3COfv+UqhP7d7TbdvPIMfBu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789747851; c=relaxed/simple;
	bh=PWpay9KKyu44Be93pxlm/dpOe+YvNB7DzwJa+fGwvRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BQmsa+y6Y97TQvKt6v615cVsyFWkWWFEsvohfKmJzJC+amfd/7QGYQYgzC4G0gHDJhhKxotqmBmpFi8Nfyh34XpDqou8tTTqp2Juq6g5hWejT6YUEt64lcWpFPwx7yBmjTWtCjDklJc6A/IbqsPsiFYQ10FkFxd2eqju35Ozn7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NL6U55JK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NL6U55JK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0E91F000FF;
	Fri, 18 Sep 2026 16:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789747849;
	bh=GQHF9XEf81bg9pmaUlMXRgBea1BKwvIoqVt8XWGMZc4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NL6U55JKwzRy3tNxfSVmSbKufqK/IcyzxsUmIgQlgIlaEPuUmII44cmE3XVzOCAPA
	 fTejI+2W9y+5mTLLyh3QkjkzL2EvBlp1SDW517G5W9nM38vNaqVfBsrmhLRz6wp/as
	 7WGLTUY2g8jX5wZuwL7Daj4NeMe0Y0dC5MUMBe6G2kx3cGCdoN02l0WPtObJH1QPRc
	 z5SayATDhZL5oavtPeWy6JlWP3zrXNkl8Lxpf4KX7bWwoaPXo6l9l/uN+nP6OCUD1i
	 UGO/wnQpZjmVqDfJiz2vhxYdedQXD2muIGdnUiRDnaFFDJQksrLx0iRrBLyZYxDkjo
	 PISo8EqyVMUkQ==
Date: Fri, 18 Sep 2026 17:10:43 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Jack Thomson <jackabt@amazon.com>, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH] KVM: arm64: Restore the VM's feature bitmap when
 kvm_setup_vcpu() fails
Message-ID: <aq1VjEOI3yhoFtpq@gremlin>
References: <20260918120553.163139-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918120553.163139-1-fuad.tabba@linux.dev>

On Fri, Sep 18, 2026 at 01:05:53PM +0100, Fuad Tabba wrote:
> __kvm_vcpu_set_target() copies the requested features into the VM-wide
> bitmap before kvm_setup_vcpu() runs and doesn't undo it when setup
> fails, so a rejected KVM_ARM_VCPU_INIT leaves the VM recording features
> that were never set up. With HAS_EL2 | HAS_EL2_E2H0 on a host without
> FEAT_NV1, kvm_vcpu_init_nested() returns -EINVAL before it allocates any
> nested stage-2 MMU, and vcpu_has_nv() is then true with
> nested_mmus_size == 0; its -ENOMEM paths do the same on a VM's first
> INIT.

It seems obviously correct (TM) to undo setting the features on error.

>
> Nothing in the tree loads a vCPU whose init failed, so this is latent.
> The pending KVM_PRE_FAULT_MEMORY series for arm64 does, and the second

I think this needs clarification :)

The KVM_PRE_FAULT_MEMORY series doesn't do this, or rather it only exposes the
ability for the pre-existing generic kvm_vcpu_pre_fault_memory() function to be
invoked by setting flags such as to expose pre-faulting as available for arm64.

So something like:

	The upcoming series that enables KVM_PRE_FAULT_MEMORY exposes an
	existing bug in how vCPU initialisation is performed as it allows
	the generic kvm_vcpu_pre_fault_memory() function to be called which
	calls vcpu_load() before the vCPU might be initialised.

For that bit.

> such load NULL-dereferences in get_s2_mmu_nested() under mmu_lock.

Also I think this is a bit unclear, esp. the prior reference to 'second',
not clear what that refers to. I think you should bring in some of the
context you provide under the fold for the patch.

So clarify what you do i.e.:

1. KVM_ARM_VCPU_INIT ioctl with an invalid configuration (HAS_EL2 |
   HAS_EL2_E2H0) - establishes the invalid kvm->arch.vcpu_features and
   doesn't clear down.

2. KVM_PRE_FAULT_MEMORY - This call is benign, but it calls vcpu_put()
   which calls kvm_arch_vcpu_put() and that has:

		if (vcpu_has_nv(vcpu))
			kvm_vcpu_put_hw_mmu(vcpu);

  Since the broken config causes vcpu_has_nv() to return true, incorrectly,
  and causes:

  	vcpu->arch.hw_mmu = NULL;

  To be run even though the vCPU in fact has the canonical MMU...

3. KVM_PRE_FAULT_MEMORY again - This time on load there's an issue:

	kvm_vcpu_pre_fault_memory()
	  -> vcpu_load()
	    -> kvm_arch_vcpu_load()

  Which has:

  	if (vcpu_has_nv(vcpu))
		kvm_vcpu_load_hw_mmu(vcpu);

  This leads to this path being taken:

		if (!vcpu->arch.hw_mmu) {
			scoped_guard(write_lock, &vcpu->kvm->mmu_lock)
				vcpu->arch.hw_mmu = get_s2_mmu_nested(vcpu);
		}

  And in get_s2_mmu_nested() it searches through the non-existent nested
  mmus leaving s2_mmu NULL, resulting in a NULL pointer deref on this line:

  	BUG_ON(atomic_read(&s2_mmu->refcnt)); /* We have struct MMUs to spare */

>
> Setup reads the VM-wide bitmap, so the copy can't be deferred; restore
> the previous value instead when kvm_setup_vcpu() fails.
>
> Fixes: 1de10b7d13a97 ("KVM: arm64: Get rid of vCPU-scoped feature bitmap")
> Fixes: 427733579744e ("KVM: arm64: Select default PMU in KVM_ARM_VCPU_INIT handler")

Hmm are 2 fixes really needed? It seems to me that commit 427733579744e
("KVM: arm64: Select default PMU in KVM_ARM_VCPU_INIT handler") is the
right one because that added a step _after_ setting the bitmap that can go
wrong.

> Link: https://lore.kernel.org/r/20260825-kvm-arm-prefault-v1-0-befe8947702e@kernel.org/
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

With the comments re: commit message/fixes tag addressed this seems correct
and a very good spot thanks! We very much need this for the pre fault
functionality.

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> The series' generic kvm_vcpu_pre_fault_memory() calls vcpu_load()
> before any arm64 hook, so there is no arm64 check it can pass through
> first. Reproduced on kvmarm/next plus the series under
> QEMU (-cpu max with an Apple M2 MIDR, which has_nv1() denies;
> kvm-arm.mode=nested): KVM_ARM_VCPU_INIT with HAS_EL2 | HAS_EL2_E2H0
> returns -EINVAL, then KVM_PRE_FAULT_MEMORY twice. The first call loads
> with hw_mmu still the canonical MMU and its vcpu_put() clears hw_mmu;
> the second takes the !hw_mmu path into get_s2_mmu_nested(), whose
> search over nested_mmus_size == 0 leaves s2_mmu NULL for the
> BUG_ON(atomic_read(&s2_mmu->refcnt)):
>
>   Unable to handle kernel NULL pointer dereference at virtual address 0000000000000074
>   Call trace:
>    kvm_vcpu_load_hw_mmu+0x94/0x2c0 (P)
>    kvm_arch_vcpu_load+0x2a8/0x5e8
>    kvm_vcpu_pre_fault_memory+0xa0/0x1b8
>    kvm_vcpu_ioctl+0x40c/0x6d0

I also think you should put the stack trace in the commit message, ideally
decoded via scripts/decode_stacktrace.sh!

>
> The thread dies with mmu_lock held for write and an RCU stall in
> queued_write_lock_slowpath() follows. With the fix both calls return
> -ENOENT and the host is unaffected. Applies unchanged to v7.3-rc3.
>
>  arch/arm64/kvm/arm.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index eaf583b771931..c2eb9b6da80f4 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1685,6 +1685,7 @@ static int kvm_setup_vcpu(struct kvm_vcpu *vcpu)
>  static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
>  				 const struct kvm_vcpu_init *init)
>  {
> +	DECLARE_BITMAP(old_features, KVM_VCPU_MAX_FEATURES);
>  	unsigned long features = init->features[0];
>  	struct kvm *kvm = vcpu->kvm;
>  	int ret = -EINVAL;
> @@ -1695,11 +1696,17 @@ static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
>  	    kvm_vcpu_init_changed(vcpu, init))
>  		goto out_unlock;
>
> +	/* Setup reads the VM-wide bitmap, so undo the copy if setup fails. */
> +	bitmap_copy(old_features, kvm->arch.vcpu_features,
> +		    KVM_VCPU_MAX_FEATURES);
>  	bitmap_copy(kvm->arch.vcpu_features, &features, KVM_VCPU_MAX_FEATURES);
>
>  	ret = kvm_setup_vcpu(vcpu);
> -	if (ret)
> +	if (ret) {
> +		bitmap_copy(kvm->arch.vcpu_features, old_features,
> +			    KVM_VCPU_MAX_FEATURES);
>  		goto out_unlock;
> +	}
>
>  	/* Now we know what it is, we can reset it. */
>  	kvm_reset_vcpu(vcpu);
>
> base-commit: 089e4f3c4862ba3f29dff2361caa8084879194fd
> --
> 2.39.5
>

--
Cheers, Lorenzo
