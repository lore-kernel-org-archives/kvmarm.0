Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B46E30E838
	for <kvmarm@lists.linux.dev>; Tue,  4 Aug 2026 03:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785812980; cv=none; b=CAvzVzaM/xh7T3+DgIp35bQ2rX/qMMZaS6OOYX5DPMYjZ4olc9tFoMULJ82wKsSWHoK7fuNhGJ9+u3G2DBaW64D5IJoLHPmJc1fNSRxosDW57P0OZx3DTrErsN2KrcVIdp6QSctFbmZlhwBVpI0OMsLviT/A9LC7rDDVSosescU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785812980; c=relaxed/simple;
	bh=iQ8khAqKQoqT7Z97u5JeT8XWZ9kj74fl9yVWyAYs3M8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IXDZGTDp9i4iIHcukPu7MmQh5hRLVab914PcDEofxhBgQVO4v4emm6SJGxtMKvUqVikgSX1tbqPmEHkCVkaYLXLGZGd2ZxSqJf+iXsXKQFyvVZ9HRzaf7mdCPJzypnNqMf0zat4hoBcYa7Ys5IYJSHJhoGGEEm7RefHxJNwgNOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Bj6EgW77; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Bj6EgW77"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785812967; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=m9TqxE7fyLCYVXMRCNCzUHqpEufNhcGr/4nD/q7HOCE=;
	b=Bj6EgW773AeB66aP1dZch337QBMM0jQ1mh4rBCx+vh795fXgt/BQNyzJPxU/xBEA08vvlxbBDa9+60UETa/D3e0lVZkXVQKdSwRIlctJoIdfBxvoE4chS90wJOxgdq/mUHArAIAaRhtdKXzw4KVdoLaH7G3qniOmPFC7wKGrpAo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X8MV38Y_1785812965;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X8MV38Y_1785812965 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 04 Aug 2026 11:09:26 +0800
Date: Tue, 4 Aug 2026 11:09:25 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Steffen Eiden <seiden@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Hyunwoo Kim <imv4bel@gmail.com>
Subject: Re: [PATCH 6/6] KVM: arm64: Add VNCR TLB tracking again
Message-ID: <jtw5wkairjo6fxsv7lclgjkaixn4dwjtdufp6vtu3mmoidqp3l@cr5bmrvzz2ng>
References: <20260801124818.366274-1-maz@kernel.org>
 <20260801124818.366274-7-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260801124818.366274-7-maz@kernel.org>

On Sat, Aug 01, 2026 at 01:48:18PM +0800, Marc Zyngier wrote:
> Having established that our VNCR TLB tracking was flawed and dropped
> it from KVM, it is time to replace it with something that works.
>
> The goal of that tracking is to hit the TLBI slow path if there
> are any VNCR TLBs in the guest, irrespective of their mapping state.
>
> For this purpose, we introduce an VM wide counter (vncr_tlb_count)
> that tracks how many valid VNCR TLB are present. This means that
> creating such TLB must increment the counter, and invalidation
> decrement it, and both these operations must be done with the MMU
> lock held for write.
>
> On TLBI handling affecting EL2 S1, a non-zero counter forces the
> handling to take the slow path to consider the VNCR TLBs.
>
> Not exactly rocket science. Hopefully I got it right this time.

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |  3 +++
>  arch/arm64/kvm/hyp/vhe/switch.c   |  5 +++--
>  arch/arm64/kvm/nested.c           | 25 +++++++++++++++++++------
>  3 files changed, 25 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index ac16f96c878d6..108966a9db12b 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -411,6 +411,9 @@ struct kvm_arch {
>  	/* Masks for VNCR-backed and general EL2 sysregs */
>  	struct kvm_sysreg_masks	*sysreg_masks;
>
> +	/* Count the number of VNCR_EL2 TLBs */
> +	atomic_t vncr_tlb_count;
> +
>  	/*
>  	 * For an untrusted host VM, 'pkvm.handle' is used to lookup
>  	 * the associated pKVM instance in the hypervisor.
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index c09b1d411c584..eb59549ec2172 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -424,10 +424,11 @@ static bool kvm_hyp_handle_tlbi_el2(struct kvm_vcpu *vcpu, u64 *exit_code)
>  		return false;
>
>  	/*
> -	 * If we have to check for any VNCR mapping being invalidated,
> +	 * If we have to check for any VNCR TLB being invalidated,
>  	 * go back to the slow path for further processing.
>  	 */
> -	if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu))
> +	if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu) &&
> +	    atomic_read(&vcpu->kvm->arch.vncr_tlb_count))
>  		return false;
>
>  	__kvm_skip_instr(vcpu);
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 84915e2cff604..1e3fd98f6589b 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -48,6 +48,7 @@ void kvm_init_nested(struct kvm *kvm)
>  {
>  	kvm->arch.nested_mmus = NULL;
>  	kvm->arch.nested_mmus_size = 0;
> +	atomic_set(&kvm->arch.vncr_tlb_count, 0);
>  }
>
>  static int init_nested_s2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
> @@ -997,9 +998,11 @@ u16 get_asid_by_regime(struct kvm_vcpu *vcpu, enum trans_regime regime)
>  	return asid;
>  }
>
> -static void invalidate_vncr(struct vncr_tlb *vt)
> +static void invalidate_vncr(struct kvm *kvm, struct vncr_tlb *vt)
>  {
> +	BUG_ON(!vt->valid);
>  	vt->valid = false;
> +	atomic_dec(&kvm->arch.vncr_tlb_count);
>  	if (vt->cpu != -1)
>  		unmap_l1_vncr(vt);
>  }
> @@ -1042,7 +1045,7 @@ static void kvm_invalidate_vncr_ipa(struct kvm *kvm, u64 start, u64 end)
>
>  	kvm_for_each_vncr_tlb(i, vcpu, vt, kvm)
>  		if (vncr_tlb_intersects(vt, vt->wr.pa, start, end - start))
> -			invalidate_vncr(vt);
> +			invalidate_vncr(kvm, vt);
>  }
>
>  struct s1e2_tlbi_scope {
> @@ -1090,7 +1093,7 @@ static void invalidate_vncr_va(struct kvm *kvm,
>  			break;
>  		}
>
> -		invalidate_vncr(vt);
> +		invalidate_vncr(kvm, vt);
>  	}
>  }
>
> @@ -1326,13 +1329,20 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
>   *   intersects with the TLBI request, invalidate it, and unmap the page
>   *   from the fixmap. Because we need to look at all the vcpu-private TLBs,
>   *   this requires some wide-ranging locking to ensure that nothing races
> - *   against it. This may require some refcounting to avoid the search when
> - *   no such TLB is present.
> + *   against it. This requires some refcounting to avoid the search when
> + *   no such TLB is present (see below).
>   *
>   * - On MMU notifiers, we must invalidate our TLB in a similar way, but
>   *   looking at the IPA instead. The funny part is that there may not be a
>   *   stage-2 mapping for this page if L1 hasn't accessed it using LD/ST
>   *   instructions.
> + *
> + * - vncr_tlb_count tracks the number of valid VNCR TLBs VM-wide. This isn't
> + *   the number of *mapped* L1 VNCR pages, which is likely be a subset (and
> + *   by definition, a TLBI handled from L1 runs with the canonical VNCR
> + *   page, not the L1's). The innermost trap handling code checks this to
> + *   find out whether to return to the guest ASAP (no L1 TLBs) or to visit
> + *   this part of the world for some extra invalidation work.
>   */
>
>  int kvm_vcpu_allocate_vncr_tlb(struct kvm_vcpu *vcpu)
> @@ -1387,7 +1397,8 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
>  	 */
>  	scoped_guard(write_lock, &vcpu->kvm->mmu_lock) {
>  		this_cpu_reset_vncr_fixmap(vcpu);
> -		vt->valid = false;
> +		if (vt->valid)
> +			invalidate_vncr(vcpu->kvm, vt);
>
>  		vt->wi = (struct s1_walk_info) {
>  			.regime	= TR_EL20,
> @@ -1459,6 +1470,8 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
>  		vt->valid = true;
>  		vt->cpu = -1;
>
> +		atomic_inc(&vcpu->kvm->arch.vncr_tlb_count);
> +
>  		kvm_make_request(KVM_REQ_MAP_L1_VNCR_EL2, vcpu);
>  		kvm_release_faultin_page(vcpu->kvm, page, false, vt->wr.pw && vt->hpa_writable);
>  	}
> --
> 2.47.3
>
