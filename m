Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACFA348445;
	Thu, 16 Jul 2026 06:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784184308; cv=none; b=sseSQisfqgPixpUr6kIEwJjcayBOVsj8Uad5itgJg4pCIhKoq+bfiun7f5Rv5lacrRopjgYrhNI7Esu8PKRrXDHz+EXlKAB4ZQ9AKSSHAU+SvW8ubEmg2CWd8IZpbdaTKDDXyi86PiqvrZb1qQKAOezshzdcSotNwoNAvWpvayQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784184308; c=relaxed/simple;
	bh=B+RPWLmKBBJ+TxlNUSXj7Eof75EAU6oRG0hCLpmLyWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jdC70sKPpeecxsDFVw9BZmChp3ETpjQouEJ8deBAjvj7wf/dTSenfumGtQxwL0tPrGrfbF6ui2RJIrcB0wJm2XIeMX7D7lfMAGaGTTxJf2yqWk5YXpHwwnGgv4vtzqC9gUwvB8/Y+re3ShV79t2fXJZ4xvbz+DM9Lb8VgO+GXcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Madks8dW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Madks8dW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D491F000E9;
	Thu, 16 Jul 2026 06:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784184306;
	bh=19yKS+O/fpA2riFL7dxV6VygyRkDnrquIviX6BjC4RY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Madks8dWlCdHfXJHxmAGI0CG2hqP5O5PJ1vfQVltwDeXMqF4CoUFAqybtIOY2nwVe
	 uHATZgU5Qn0zMOMhoze6BRx0aWylcMik1TiHczQIW82px6rKfKPYfj3yFg36qUEjyG
	 lZ1IxPvzq8kVAuaZYhJ3TCYkSfoy7Rgg7Y7LCVK+uOShbfc1ckL1GwjuZ3AHgMd/tT
	 3C6SDWvJ/s9AQeCwQjWwHjoyN24JukT25dI6VK5vvhrrKTFDfcD7ugDCPbr2/lLU7m
	 jo+NEhTYaPr098lFoug+ZzljiYICRLxYsp+M95bk9aLhMDDCoErGDbEP6RHTDhOIjE
	 EYFIHMesz26KA==
Date: Wed, 15 Jul 2026 23:45:05 -0700
From: Oliver Upton <oupton@kernel.org>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Sebastian Ene <sebastianene@google.com>
Subject: Re: [PATCH v4 3/6] KVM: arm64: nv: Add nested revmap broken
 tracepoint
Message-ID: <alh98Zz42OdWo-jp@kernel.org>
References: <20260714115926.2044757-1-weilin.chang@arm.com>
 <20260714115926.2044757-4-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714115926.2044757-4-weilin.chang@arm.com>

Hi Wei-Lin,

On Tue, Jul 14, 2026 at 12:59:22PM +0100, Wei-Lin Chang wrote:
> Add a tracepoint to track when a nested reverse map becomes broken. This
> makes it easier to detect NV performance degradation caused by full
> shadow stage-2 unmaps.
> 
> Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>

I'm not too excited about making a tracepoint out of this, especially
since a 'broken' reverse map is more of a KVM implementation detail
(that could change) than anything else.

BPF is quite popular at this point, do you think it's reasonable to
instead expect the curious KVM developer to attach a kprobe and inspect
the state of the nested MMU?

Thanks,
Oliver

> ---
>  arch/arm64/kvm/nested.c    |  7 ++++++-
>  arch/arm64/kvm/trace_arm.h | 27 +++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 065823e415ce..22f8a1daca93 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -17,6 +17,7 @@
>  #include <asm/sysreg.h>
>  
>  #include "sys_regs.h"
> +#include "trace.h"
>  
>  struct vncr_tlb {
>  	/* The guest's VNCR_EL2 */
> @@ -916,8 +917,12 @@ void kvm_record_nested_revmap(gpa_t canonical_ipa, struct kvm_s2_mmu *mmu,
>  
>  	mas_set_range(&mas_rmap, canonical_ipa, canonical_ipa_end);
>  	if (mas_store_gfp(&mas_rmap, xa_mk_value(new_entry),
> -			  GFP_NOWAIT | __GFP_ACCOUNT))
> +			  GFP_NOWAIT | __GFP_ACCOUNT)) {
> +		trace_kvm_nested_revmap_broken(mmu - mmu->arch->nested_mmus,
> +					       canonical_ipa, canonical_ipa_end,
> +					       nested_ipa, new_entry);
>  		mmu->nested_revmap_broken = true;
> +	}
>  unlock:
>  	mtree_unlock(revmap_mt);
>  }
> diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
> index 9c60f6465c78..0db90068ff63 100644
> --- a/arch/arm64/kvm/trace_arm.h
> +++ b/arch/arm64/kvm/trace_arm.h
> @@ -415,6 +415,33 @@ TRACE_EVENT(kvm_forward_sysreg_trap,
>  		      sys_reg_Op2(__entry->sysreg))
>  );
>  
> +TRACE_EVENT(kvm_nested_revmap_broken,
> +	    TP_PROTO(int mmu_idx, unsigned long canonical_ipa,
> +		     unsigned long canonical_ipa_end, unsigned long nested_ipa,
> +		     unsigned long revmap_entry),
> +	    TP_ARGS(mmu_idx, canonical_ipa, canonical_ipa_end, nested_ipa, revmap_entry),
> +
> +	    TP_STRUCT__entry(
> +		__field(int,			mmu_idx)
> +		__field(unsigned long,		canonical_ipa)
> +		__field(unsigned long,		nested_ipa)
> +		__field(size_t,			size)
> +		__field(unsigned long,		revmap_entry)
> +	    ),
> +
> +	    TP_fast_assign(
> +		__entry->mmu_idx = mmu_idx;
> +		__entry->canonical_ipa = canonical_ipa;
> +		__entry->nested_ipa = nested_ipa;
> +		__entry->size = canonical_ipa_end - canonical_ipa + 1;
> +		__entry->revmap_entry = revmap_entry;
> +	    ),
> +
> +	    TP_printk("mmu idx: %d, cipa: 0x%016lx, nipa: 0x%016lx, size: 0x%016lx, entry: %016lx",
> +		      __entry->mmu_idx, __entry->canonical_ipa, __entry->nested_ipa,
> +		      __entry->size, __entry->revmap_entry)
> +);
> +
>  #endif /* _TRACE_ARM_ARM64_KVM_H */
>  
>  #undef TRACE_INCLUDE_PATH
> -- 
> 2.43.0
> 
