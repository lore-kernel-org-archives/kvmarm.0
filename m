Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793812220;
	b=tOrVzLqKooNfnsF+TyeWxp/igO0ZksDR44sGSU44GZ9BuKeXWlo7dQm+9HIh96RNG9vE
	 mXYa+pXPd303iZRToGFF/eEXqA74JI+cDyFjQgMjerYEORzWaczpAMEtnummzLW8qRsW8
	 o7fiovMXIgfd98S42PtoN4EZlEBa6W4l/guKTA/pmCE14Pf4lHtSIzkAWBEzk23oShL87
	 GRqnHqFeMW3wlWpLWclMv7c+r2i4raoPm6dOo/s+IwiDCW99Y+9jUf0GP5RNNNd16fdOO
	 crBHLZIJAu+qwHCAyiMSOR/ge+G05xvsFxitTQZX8E84sL10T4Ehs/aSc7bpFO5/XGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793812220;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=JpK/rwJkmBbYoKvEiBVl5EkDOuuQ1msEJkdUE3eKSzA=;
	b=Yz8sdBB4zW/H55G3GMKhLzvDqakFjPdaTyMVhMEasXzxrTGi4wijPUPwZmKYz9i9EqPj
	 1n1GErvbxSwiFpXhf0XzqWw60/G6Q6gtShneiLEvGglKkPuD5NLjhwNuBBg4lOu2+uoQn
	 hdsg0NySdRBpAFLFtt6tRprnquPDGfsxQDcgfblVOiL3/h1iZ8HfUbwF13FHmK11zIzzE
	 fkfklsb1LWfjCWGtoH+AM03Vu6IcOWNIXETSvQ8uiOpckaS6cm8eyOVWVtrRqUk5x4o0r
	 kKYbBhIpnQ7kNN1Nmv38z+7UaMXdmFfb5rvrZL6LM2SvwEpTO0rVaQVhUwBp2H3watA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=G+9MQy65;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9975A606A326
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 17:10:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9975A606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=G+9MQy65
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D869E1BB2;
	Wed,  4 Nov 2026 09:10:15 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F3EC3F673;
	Wed,  4 Nov 2026 09:10:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793812218; bh=zsT8M1bqCl4DS/rBZ1yB70lx5mbuaQSc3Dk0g2oeC5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G+9MQy65V6ejda+rxF+/BhBiWaGHDRyW8Qz3i0wazJB0MASoudVeoMXKhsFQ/FGWf
	 vzlbxKTJ/C6HKmn7CMGS4EZQgDQzCwqPNgYjo+fgX+KN+AaOYpFcr7XIGG0Yn+D11x
	 mlhExJLql4h3BuorVYeNCOcrSsfjd0RoyvxaXYoI=
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
Subject: Re: [PATCH v2 28/28] KVM: arm64: Add tracepoints for S2 page table walk
Date: Wed,  4 Nov 2026 17:10:14 +0000
Message-ID: <autm9hyaf3KbpJnJ@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023205610.1044532-29-oupton@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org> <20261023205610.1044532-29-oupton@kernel.org>
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

On Fri, Oct 23, 2026 at 01:56:10PM -0700, Oliver Upton wrote:
> MMU walk steps are a useful tidbit of information for KVM hackers. As
> these events are far closer to modelling CPU architecture than exposing
> KVM internals it clears the bar for adding tracepoints.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_nested.h |  6 ++++
>  arch/arm64/kvm/nested.c             | 14 ++++-----
>  arch/arm64/kvm/trace_arm.h          | 47 +++++++++++++++++++++++++++++
>  3 files changed, 59 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index 341604b619cc..65dc411188cb 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -128,6 +128,12 @@ struct kvm_walk_access {
>  	bool	write;
>  };
>  
> +struct s2_walk_step {
> +	u64		desc_pa;
> +	u64		desc;
> +	int		level;
> +};
> +
>  extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, struct kvm_walk_access *access,
>  			      struct kvm_s2_trans *result);
>  extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 0c468235f123..a04ab2200d36 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -17,6 +17,7 @@
>  #include <asm/sysreg.h>
>  
>  #include "sys_regs.h"
> +#include "trace.h"
>  #include "vgic/vgic.h"
>  
>  struct vncr_tlb {
> @@ -155,12 +156,6 @@ struct s2_walk_info {
>  	bool		haft;
>  };
>  
> -struct s2_walk_step {
> -	u64		desc_pa;
> -	u64		desc;
> -	int		level;
> -};
> -
>  static u32 compute_fsc(int level, u32 fsc)
>  {
>  	return fsc | (level & 0x3);
> @@ -279,10 +274,10 @@ static int handle_desc_update(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
>  			      struct s2_walk_step *ws, struct kvm_s2_trans *out,
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
>  		new |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
> @@ -307,6 +302,7 @@ static int handle_desc_update(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
>  	if (ret == -EAGAIN)
>  		return ret;
>  	if (!ret) {
> +		trace_kvm_s2_desc_update(ws, access->ia, old_cpu);
>  		out->desc = ws->desc;
>  		out->dirty = out->desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
>  		return 0;
> @@ -425,6 +421,8 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
>  			return ret;
>  		}
>  
> +		trace_kvm_s2_walk_step(&ws, access->ia);
> +
>  		/* Check for valid descriptor at this point */
>  		if (!(ws.desc & KVM_PTE_VALID)) {
>  			out->esr = compute_fsc(ws.level, ESR_ELx_FSC_FAULT);
> diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
> index 9fe9b57f6fa8..0bf1a0be2636 100644
> --- a/arch/arm64/kvm/trace_arm.h
> +++ b/arch/arm64/kvm/trace_arm.h
> @@ -467,6 +467,53 @@ TRACE_EVENT(kvm_s1_desc_update,
>  		      __entry->pa, __entry->level)
>  );
>  
> +TRACE_EVENT(kvm_s2_walk_step,
> +	    TP_PROTO(struct s2_walk_step *ws, u64 ia),
> +	    TP_ARGS(ws, ia),
> +
> +	    TP_STRUCT__entry(
> +		__field(u64,	ia)
> +		__field(u64,	desc)
> +		__field(u64,	pa)
> +		__field(int,	level)
> +	    ),
> +
> +	    TP_fast_assign(
> +		__entry->ia	= ia;
> +		__entry->desc	= ws->desc;
> +		__entry->pa	= ws->desc_pa;
> +		__entry->level	= ws->level;
> +	    ),
> +
> +	    TP_printk("ia: 0x%llx desc: 0x%llx pa: 0x%llx level: %d",
> +		      __entry->ia, __entry->desc, __entry->pa, __entry->level)
> +);
> +
> +TRACE_EVENT(kvm_s2_desc_update,
> +	    TP_PROTO(struct s2_walk_step *ws, u64 ia, u64 old),
> +	    TP_ARGS(ws, ia, old),
> +
> +	    TP_STRUCT__entry(
> +		__field(u64,	ia)
> +		__field(u64,	new)
> +		__field(u64,	old)
> +		__field(u64,	pa)
> +		__field(int,	level)
> +	    ),
> +
> +	    TP_fast_assign(
> +		__entry->ia	= ia;
> +		__entry->new	= ws->desc;
> +		__entry->old	= old;
> +		__entry->pa	= ws->desc_pa;
> +		__entry->level	= ws->level;
> +	    ),
> +
> +	    TP_printk("ia: 0x%llx new: 0x%llx old: 0x%llx pa: 0x%llx level: %d",
> +		      __entry->ia, __entry->new, __entry->old, __entry->pa,
> +		      __entry->level)
> +);
> +
>  #endif /* _TRACE_ARM_ARM64_KVM_H */
>  
>  #undef TRACE_INCLUDE_PATH
> -- 
> 2.47.3
> 

LGTM! FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
