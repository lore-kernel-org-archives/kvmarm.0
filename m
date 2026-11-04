Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793812160;
	b=VvJ3ugxqapILR6//801FACujkoTQK7DAmUpIzFPvhfZc+52CWCiodtl0Wrz2rGkdHt3R
	 7RCkqpiEYFF1lrLL9QDqKNWBBDmbxfxMISqG2CVcfPsTR4iShfkQOciCSIx73gdwjF3DU
	 5XE0ygdAdtp0b62k01SxNyzkrb/oNMgYubf9OQMMO7AbfWg+puim8RiUUtgmXOSEBSZrW
	 4KlUQby99qBjYMK2T2+V2AlmyFRlawiYoE3u7uo5C7CBTX8bciQtGworoIEtoq8BlrJ2n
	 UqWrGssVdD6jy2Aq8nD59DDVaig8oN+J99OhfdtBjhnJLXmaRPyR/oLzBPRCnmY9KGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793812160;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=AHCOB/CvUzw5p9p9QZp1FYPtdPoM+s82+qPxsJAZbA4=;
	b=RvmztaWEE5ZZiE6jfyHw44B/4I8ZkHo6Y8zsmeVdBYJ2rq3u7tldco9eYe1k8gKrjOuT
	 dmCDodGnnUe99sXaegkT37emiE9/+lWs5ru7D0r+Wg6O+KiVDuezQO4fmvYnegsi8Ibey
	 Qm/Osk86o+4qNeLzDMg6ExQbQTiJJpbAB1wCI/3iNULJdsz2h/C++UGab5KsBK1PuhQiG
	 8DhhZDw2XHRXg1ykqWZWjOHLO28vmMHCgtP/7PV2lFLKBv++ll0i//U+a/krWjyWSQ1fH
	 y5en0nP+GNYviNY/pKh1MyMOmx364KSWkX9s+hoXDWKhivU69QO8rAsvef6VkrbJUHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="FUA3oXW/";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E68F606A326
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 17:09:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E68F606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=FUA3oXW/
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D11511BB2;
	Wed,  4 Nov 2026 09:09:15 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 96CAB3F673;
	Wed,  4 Nov 2026 09:09:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793812158; bh=2IIhPdA7ImqETn8gA1DSPvp/2x+hF1Oe3wKxP1OHO2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FUA3oXW/keeP7VFeApO2AMlvLftd6glp+HzCPP0bhqjUor9tJRn03pXU2XA7NmLWH
	 b3EEoSkNAFbLJn5js9NdFTxsXybdi1/Ar7fZWlDfZ9dgTY6zGFouYHWoExxjdKjfED
	 X/bE5nV1SA5KmxueGf1Tx4kWBzk2Uk3uJ/Djt6rk=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH v2 27/28] KVM: arm64: Add tracepoints for S1 page table walk
Date: Wed,  4 Nov 2026 17:09:15 +0000
Message-ID: <autmuxdI41yc5_98@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023205610.1044532-28-oupton@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org> <20261023205610.1044532-28-oupton@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Oct 23, 2026 at 01:56:09PM -0700, Oliver Upton wrote:
> MMU walk steps are a useful tidbit of information for KVM hackers. As
> these events are far closer to modelling CPU architecture than exposing
> KVM internals it clears the bar for adding tracepoints.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_nested.h |  8 +++++
>  arch/arm64/kvm/at.c                 | 18 +++++-----
>  arch/arm64/kvm/trace_arm.h          | 52 +++++++++++++++++++++++++++++
>  3 files changed, 68 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index 81d8b1676fe4..341604b619cc 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -343,6 +343,14 @@ struct s1_walk_info {
>  	bool			haft;
>  };
>  
> +struct s1_walk_step {
> +	u64			desc;
> +	u64			desc_ipa;
> +	u64			desc_pa;
> +	struct kvm_s2_trans	s2_trans;
> +	int			level;
> +};
> +
>  struct s1_walk_result {
>  	union {
>  		struct {
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 8f1be3af64e8..1a49eb3c288a 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -11,6 +11,8 @@
>  #include <asm/kvm_mmu.h>
>  #include <asm/lsui.h>
>  
> +#include "trace.h"
> +
>  static int get_ia_size(struct s1_walk_info *wi)
>  {
>  	return 64 - wi->txsz;
> @@ -433,14 +435,6 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  	return -EFAULT;
>  }
>  
> -struct s1_walk_step {
> -	u64			desc;
> -	u64			desc_ipa;
> -	u64			desc_pa;
> -	struct kvm_s2_trans	s2_trans;
> -	int			level;
> -};
> -
>  static int kvm_read_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 *desc,
>  			    struct s1_walk_info *wi)
>  {
> @@ -492,10 +486,10 @@ static int handle_desc_update(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  			      struct s1_walk_step *ws, struct s1_walk_result *wr,
>  			      struct kvm_walk_access *access)
>  {
> -	u64 old, new;
> +	u64 old, old_cpu, new;
>  	int ret;
>  
> -	old = new = ws->desc;
> +	old = old_cpu = new = ws->desc;
>  
>  	if (should_set_access_flag(wi, ws, access))
>  		new |= PTE_AF;
> @@ -529,6 +523,8 @@ static int handle_desc_update(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  		return ret;
>  	}
>  
> +	trace_kvm_s1_desc_update(ws, access->ia, old_cpu);
> +
>  	wr->desc = ws->desc;
>  	wr->dirty = !(wr->desc & PTE_RDONLY);
>  	return 0;
> @@ -614,6 +610,8 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  			return ret;
>  		}
>  
> +		trace_kvm_s1_walk_step(&ws, access->ia);
> +
>  		/* Invalid descriptor */
>  		if (!(ws.desc & BIT(0)))
>  			goto transfault;
> diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
> index 9c60f6465c78..9fe9b57f6fa8 100644
> --- a/arch/arm64/kvm/trace_arm.h
> +++ b/arch/arm64/kvm/trace_arm.h
> @@ -415,6 +415,58 @@ TRACE_EVENT(kvm_forward_sysreg_trap,
>  		      sys_reg_Op2(__entry->sysreg))
>  );
>  
> +TRACE_EVENT(kvm_s1_walk_step,
> +	    TP_PROTO(struct s1_walk_step *ws, u64 ia),
> +	    TP_ARGS(ws, ia),
> +
> +	    TP_STRUCT__entry(
> +		__field(u64,	ia)
> +		__field(u64,	desc)
> +		__field(u64,	ipa)
> +		__field(u64,	pa)
> +		__field(int,	level)
> +	    ),
> +
> +	    TP_fast_assign(
> +		__entry->ia	= ia;
> +		__entry->desc	= ws->desc;
> +		__entry->ipa	= ws->desc_ipa;
> +		__entry->pa	= ws->desc_pa;
> +		__entry->level	= ws->level;
> +	    ),
> +
> +	    TP_printk("ia: 0x%llx desc: 0x%llx ipa: 0x%llx pa: 0x%llx level: %d",
> +		      __entry->ia, __entry->desc, __entry->ipa, __entry->pa,
> +		      __entry->level)
> +);
> +
> +TRACE_EVENT(kvm_s1_desc_update,
> +	    TP_PROTO(struct s1_walk_step *ws, u64 ia, u64 old),
> +	    TP_ARGS(ws, ia, old),
> +
> +	    TP_STRUCT__entry(
> +		__field(u64,	ia)
> +		__field(u64,	new)
> +		__field(u64,	old)
> +		__field(u64,	ipa)
> +		__field(u64,	pa)
> +		__field(int,	level)
> +	    ),
> +
> +	    TP_fast_assign(
> +		__entry->ia	= ia;
> +		__entry->new	= ws->desc;
> +		__entry->old	= old;
> +		__entry->ipa	= ws->desc_ipa;
> +		__entry->pa	= ws->desc_pa;
> +		__entry->level	= ws->level;
> +	    ),
> +
> +	    TP_printk("ia: 0x%llx new: 0x%llx old: 0x%llx ipa: 0x%llx pa: 0x%llx level: %d",
> +		      __entry->ia, __entry->new, __entry->old, __entry->ipa,
> +		      __entry->pa, __entry->level)
> +);
> +
>  #endif /* _TRACE_ARM_ARM64_KVM_H */
>  
>  #undef TRACE_INCLUDE_PATH
> -- 
> 2.47.3
> 


Tracepoints :)

FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
