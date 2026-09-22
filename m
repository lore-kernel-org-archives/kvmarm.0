Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B1E5650F7;
	Tue, 22 Sep 2026 16:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790092909; cv=none; b=TnN94kZODT5GY+zT5zUbvyEbtdstjDkx/HCSBt/lb/ZYNNfh9nUC/QcTqxM25YXG/Lf7X//qO50AjltAOPvClZbxU3dpUNVW1UCFySN1lXFpmvrDGM1MtYq9khDqp4wqM29eukXdzJXTZPRQKp99GIgAJwAFZQW+rkIcH6p2Ds4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790092909; c=relaxed/simple;
	bh=8juOv1uaDdY6IuaTC3vffouy8oZLz41SERNmmIQ7Wlo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=koXNAMswExXT5wPHLosWWyOw7Aqmz8CZeUf1WCEsxUClJt9Y2URo/wiFPiBSwLkDlXLNAMxswCSvmLzPHnyai7Cxo+6iVggrXquJW9FgJEddPBvVCoJWZRYGgAUPnCsJBofPCQkCqdyBwMYRU0Uggc9ca541+lfzGB7n/3F5gPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TgHOkTxp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TgHOkTxp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E421F0089B;
	Tue, 22 Sep 2026 16:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790092906;
	bh=Fj8qv/s1QXBda8PJDTUNriPLEJtaxLhFWQtl59nKm2g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TgHOkTxpKTkCp2koCURoESESmBJBN0clKbStRr6qZEszbQCwdNdvQlCngTcc4FXyT
	 X3ciCuZGg4tsjBvDauLeGD99T9LKFTC38AG7YYn2SE8tKI0MP9RYZpjh6VPGp1mrE6
	 QnB8WRl9Ahwhvj8TkU40GxcT1CyqaqHBay5DfVSXfFnwlbl5Y63YYFGLiaRO3yPeA5
	 ghBCXsnSifEuUsagpHdAwCvn/VOzPBB26gUJnEDMOaPnt4BCcA+/70UlAGxb8A2v0G
	 Kj8Y7aeLSig6sJTwRB2DHqMDIhfmnxtkMdTQPa+M9BMRFJZIorJ4+Ep0yymWA2X/4+
	 v62pUHjkSJF0g==
Date: Tue, 22 Sep 2026 17:01:40 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Jack Thomson <jackabt@amazon.com>, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3] KVM: arm64: Clear the VM's feature bitmap when
 kvm_setup_vcpu() fails
Message-ID: <arKmKAehWmYxfEp3@gremlin>
References: <20260921190843.107881-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921190843.107881-1-fuad.tabba@linux.dev>

On Mon, Sep 21, 2026 at 08:08:43PM +0100, Fuad Tabba wrote:
> __kvm_vcpu_set_target() copies the requested features into the VM-wide
> bitmap before kvm_setup_vcpu() runs and doesn't undo it when setup
> fails, so a rejected KVM_ARM_VCPU_INIT leaves the VM recording features
> that were never set up. With HAS_EL2 | HAS_EL2_E2H0 on a host without
> FEAT_NV1, kvm_vcpu_init_nested() returns -EINVAL before it allocates any
> nested stage-2 MMU, and vcpu_has_nv() is then true with
> nested_mmus_size == 0; its -ENOMEM paths do the same on a VM's first
> INIT.
>
> Until one INIT has succeeded, every INIT that passes the feature check
> rewrites the bitmap and a failure leaves it there; once
> KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED is set, kvm_vcpu_init_changed()
> has already required the requested features to equal the bitmap, so
> the copy is a no-op. Clear the bitmap on failure while the flag is
> clear.
>
> This showed up with the series that enables KVM_PRE_FAULT_MEMORY for
> arm64, since the generic kvm_vcpu_pre_fault_memory() calls vcpu_load()
> without checking that the vCPU has been initialised. After the rejected
> INIT, the first call's vcpu_load() reads hw_mmu still set to the
> canonical MMU and leaves it alone, but its vcpu_put() takes the
> vcpu_has_nv() branch into kvm_vcpu_put_hw_mmu(), which clears hw_mmu.
> The second call's vcpu_load() reads hw_mmu as NULL and takes the
> nested branch into get_s2_mmu_nested(), whose search over
> nested_mmus_size == 0 leaves s2_mmu NULL for the
> BUG_ON(atomic_read(&s2_mmu->refcnt)), under mmu_lock. On kvmarm/next
> with the series applied:

This is no longer accurate at the latest revision of my series ([0])but maybe worth
keeping for historic detail?

[0]: https://lore.kernel.org/kvmarm/20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org/

>
>   Unable to handle kernel NULL pointer dereference at virtual address 0000000000000074
>   Call trace:
>    kvm_vcpu_load_hw_mmu (arch/arm64/kvm/nested.c:891) (P)
>    kvm_arch_vcpu_load (arch/arm64/kvm/arm.c:662)
>    kvm_vcpu_pre_fault_memory (virt/kvm/kvm_main.c:170 virt/kvm/kvm_main.c:4349)
>    kvm_vcpu_ioctl (virt/kvm/kvm_main.c:4639)
>
> Fixes: 427733579744e ("KVM: arm64: Select default PMU in KVM_ARM_VCPU_INIT handler")
> Suggested-by: Oliver Upton <oupton@kernel.org>
> Link: https://lore.kernel.org/r/20260825-kvm-arm-prefault-v1-0-befe8947702e@kernel.org/
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Seems reasonable to me so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> v3:
>  - Clear the bitmap on failure instead of saving and restoring it, only
>    while KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED is clear, since with the
>    flag set the copy was a no-op (Oliver).
>  - Commit message: drop the "latent, exposed by the series" framing and
>    state the flag invariant behind the clear; the pre-fault crash is
>    how the bug showed up.
>  - Dropped Lorenzo's Reviewed-by since the code changed.
>
> v2:
>  - Commit message: say what the prefault series enables, bring the
>    two-ioctl walk and the trace up from below the fold, the trace
>    decoded, and drop the Fixes: on 1de10b7d13a97, which had nothing
>    fallible after the copy (Lorenzo).
>  - Fold Lorenzo's Reviewed-by.
>
> Reproduced on kvmarm/next plus the series under QEMU (-cpu max with an
> Apple M2 MIDR, which has_nv1() denies; kvm-arm.mode=nested):
> KVM_ARM_VCPU_INIT with HAS_EL2 | HAS_EL2_E2H0 returns -EINVAL, then
> KVM_PRE_FAULT_MEMORY twice. With the fix both calls return -ENOENT and
> the host is unaffected. Based on kvmarm/fixes; applies cleanly to
> v7.3-rc4 and to kvmarm/next.
>
> v2: https://lore.kernel.org/r/20260921063718.1604533-1-fuad.tabba@linux.dev/
> v1: https://lore.kernel.org/r/20260918120553.163139-1-fuad.tabba@linux.dev/
>
>  arch/arm64/kvm/arm.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index eaf583b771931..bd19f64ae82ef 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1698,8 +1698,16 @@ static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
>  	bitmap_copy(kvm->arch.vcpu_features, &features, KVM_VCPU_MAX_FEATURES);
>
>  	ret = kvm_setup_vcpu(vcpu);
> -	if (ret)
> +	if (ret) {
> +		/*
> +		 * Clear the bitmap if setup fails on the first vCPU to be
> +		 * initialized.
> +		 */
> +		if (!test_bit(KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED, &kvm->arch.flags))
> +			bitmap_zero(kvm->arch.vcpu_features, KVM_VCPU_MAX_FEATURES);
> +
>  		goto out_unlock;
> +	}
>
>  	/* Now we know what it is, we can reset it. */
>  	kvm_reset_vcpu(vcpu);
>
> base-commit: 6b1bca1b1ab77f60a62087337bfe6e2f0efb9e6d
> --
> 2.39.5
>

--
Cheers, Lorenzo
