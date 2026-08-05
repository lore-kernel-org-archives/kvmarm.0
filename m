Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08F440EBB0
	for <kvmarm@lists.linux.dev>; Wed,  5 Aug 2026 09:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785923567; cv=none; b=OZq3haoRSZLay+Z5krg5OHnVxT8SpsFLZnFQcP6X80j4fnlKjPsXy9OFP+lWqQEek/zsKFjOx6U2wQukcBGwS0Uwe8N6FnpgYmmz/kvBzwMqY3AlrSGCnkokwmzV/wipHBHddbD1goJKkD58Kw1Yo8qalk81nGn4fgkbb8hlGNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785923567; c=relaxed/simple;
	bh=jOzaT9rukaXdROnS3UTz7jsbWEW4GdzKbyqUUbWLAcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bxs4Q4O46t9D5p3l/dLzUFM9krsGfYnqlcwkr4LmvP6XRTgORd9TPANbOQqpKeq+6SZgQjIwfMFGDOOrxDyFshIw/3TDz6R5GiSJ6zRGOKoIPrizQEQyRaCXW7V3cXEgPER3O/vG3nNFfIoLLzoxfEngMokx/GwGnAjyRcMJtrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ceSVutw5; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ceSVutw5"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4994d67d260so35045e9.1
        for <kvmarm@lists.linux.dev>; Wed, 05 Aug 2026 02:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785923563; x=1786528363; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1uBOsoS/PbVTyBqO9ehWQ4MdxFkJS8vIp8kt3+czyyg=;
        b=ceSVutw5VYWTZBJuX0TeAGFCFjDEKWw3NJdwgT7sgRIwuAOHYhd4n3yaRNVgRQEiKs
         4i4/OdouW7xgoEB3cN/NzuVIKRWGdqcg0yTlgc+69O2lvNyz4s6Fe9BDe0ptLj4ASWRh
         xwnHI68ZMSEhDzT0Bco6g2UqUw7MSVqHJFhYWOHCv0V90G5lTnY1E6F/ZB5aTLbOUGZl
         oaB1scMsU5eUC4QFn3ZG3A3r2FCV+cB+LA+FT1pUZLQSvDda0wtmpDONn3q0da7DNZZq
         R505kKQlw8Bye8tbhsRoqqcG6AXVk5RKAkx/MeQL5EVL1irYfZePT/UtQd5PmvgLK3QX
         ++Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785923563; x=1786528363;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1uBOsoS/PbVTyBqO9ehWQ4MdxFkJS8vIp8kt3+czyyg=;
        b=oBiSM+jIUx1eryX6QR43UKErAiKy5C4C0ozsUSNuCIoVO5nhB60wJHiNWQZCQJYFTe
         8v3w0ML0Ko5x6oHZ1629RT1RQP/auxeLdkkAUgeeMyn2UzNp7hIGJimXmQRppOHkVbEI
         H6l/B7aOoM+yTAGjzWj1f2VEFt8ByHcbTxtjUqoThzf4sehcP/n8Bw5NSESU+sayCL9k
         oxyaEoncCVRFA1cv6Limu6Xwb6LY46Pz05ruamCe3P6+XmeQx/LFmfso4AufN/s98nxm
         9+xbOzzzc1UUzkjm7NoJXIWP1uZC2kzwiCzkHsdtGra3T0jkE8CeEyWbuOq/bUlUHGrV
         Hchg==
X-Forwarded-Encrypted: i=1; AHgh+RpzMymYJifi93N3Hpe8IJY95QIgIVoWNDR17FxdZWIU4Fds9mbKxXvQ5O/UNzdLhlvCcJYcqo0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxSN1jdqMAkpXa1wPS+bVq9LajbhurRGIDICFxikujrGiUxoUce
	pbwy/N2DHU8PcRTm3pBXQ92ji0e7IeFomSQ1Im+j8ZJ7O1v0hLwmkfbmmMHKtiQ2hg==
X-Gm-Gg: AR+sD12BXzLHfm/Dgu8uQ3LYBNIU79NulWx9c/29YE2omE7VU67LFYtixNzRTALDwLR
	MQx8qvTlCW20VHCs5CZnf+8bI791w9iftRQ365jigPO1Nu/sievSerfQtR4k1JYPv6IRik5+IIL
	4YjdSsu67Rw2vdrKVpY6IZ+J8G27/i79z+NFF68jIvXWqFvQw7qbJTMo884YprpCjYJNXp8I3Jl
	dJlQTIpQq1hD4yMRhETmygJokzhrE+yEhmIAdcBUUPeg7L4M1+yOcQH4y3iiJi1uxmgiVJkdids
	XLGc6MRQKs1QdmewytidQahHNxeobqeLmAG20mVwjx3ejL6Tiay4Sf3hpvPLu/todOyWKlZUBZ1
	UiCcIReoPLA+2MKEI3Bv3sq8yrP/vlinWniWNkxNS4KBgEnfITjtonSrebAboI2I+ydsXbTsuw3
	CvgIHLum29V8kowkaaPhm1PfStgFPc6+/w64NC7y8tnCNsB4eJmUfp2yfa0d5Yq1VwqsK8MkhsI
	blLvhqN4Yspn8J0mmpV7FK8rAKCY3jN
X-Received: by 2002:a7b:cb93:0:b0:490:b2ae:44ca with SMTP id 5b1f17b1804b1-4994f114900mr802195e9.5.1785923562831;
        Wed, 05 Aug 2026 02:52:42 -0700 (PDT)
Received: from google.com (63.235.189.35.bc.googleusercontent.com. [35.189.235.63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fec249a5fsm7282244f8f.33.2026.08.05.02.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 02:52:42 -0700 (PDT)
Date: Wed, 5 Aug 2026 09:52:38 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: alexandru.elisei@arm.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, catalin.marinas@arm.com,
	dbrazdil@google.com, joey.gouly@arm.com, kees@kernel.org,
	mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org,
	perlarsen@google.com, qperret@google.com, rananta@google.com,
	smostafa@google.com, suzuki.poulose@arm.com, tabba@google.com,
	tglx@kernel.org, bgrzesik@google.com, will@kernel.org,
	yuzenghui@huawei.com
Subject: Re: [PATCH 03/14] KVM: arm64: Support host MMIO trap handlers for
 unmapped devices
Message-ID: <anMH5hHxEMxh6spO@google.com>
References: <20260310124933.830025-1-sebastianene@google.com>
 <20260310124933.830025-4-sebastianene@google.com>
 <acJukVJzZJEoPEyE@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acJukVJzZJEoPEyE@google.com>

On Tue, Mar 24, 2026 at 10:59:29AM +0000, Vincent Donnefort wrote:
> On Tue, Mar 10, 2026 at 12:49:22PM +0000, Sebastian Ene wrote:
> > Introduce a mechanism to register callbacks for MMIO accesses to regions
> > unmapped from the host Stage-2 page tables.
> > 
> > This infrastructure allows the hypervisor to intercept host accesses to
> > protected or emulated devices. When a Stage-2 fault occurs on a
> > registered device region, the hypervisor will invoke the associated
> > callback to emulate the access.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_arm.h      |  3 ++
> >  arch/arm64/include/asm/kvm_pkvm.h     |  6 ++++
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 41 +++++++++++++++++++++++++++
> >  arch/arm64/kvm/hyp/nvhe/setup.c       |  3 ++
> >  4 files changed, 53 insertions(+)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> > index 3f9233b5a130..8fe1e80ab3f4 100644
> > --- a/arch/arm64/include/asm/kvm_arm.h
> > +++ b/arch/arm64/include/asm/kvm_arm.h
> > @@ -304,6 +304,9 @@
> >  
> >  /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
> >  #define HPFAR_MASK	(~UL(0xf))
> > +
> > +#define FAR_MASK	GENMASK_ULL(11, 0)
> > +
> >  /*
> >   * We have
> >   *	PAR	[PA_Shift - 1	: 12] = PA	[PA_Shift - 1 : 12]
> > diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> > index 48ec7d519399..5321ced2f50a 100644
> > --- a/arch/arm64/include/asm/kvm_pkvm.h
> > +++ b/arch/arm64/include/asm/kvm_pkvm.h
> > @@ -19,9 +19,15 @@
> >  
> >  #define PKVM_PROTECTED_REGS_NUM	8
> >  
> > +struct pkvm_protected_reg;
> > +
> > +typedef void (pkvm_emulate_handler)(struct pkvm_protected_reg *region, u64 offset, bool write,
> > +				    u64 *reg, u8 reg_size);
> > +
> >  struct pkvm_protected_reg {
> >  	u64 start_pfn;
> >  	size_t num_pages;
> > +	pkvm_emulate_handler *cb;
> >  };
> >  
> >  extern struct pkvm_protected_reg kvm_nvhe_sym(pkvm_protected_regs)[];
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index 7c125836b533..f405d2fbd88f 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -13,6 +13,7 @@
> >  #include <asm/stage2_pgtable.h>
> >  
> >  #include <hyp/fault.h>
> > +#include <hyp/adjust_pc.h>
> >  
> >  #include <nvhe/gfp.h>
> >  #include <nvhe/memory.h>
> > @@ -608,6 +609,41 @@ static int host_stage2_idmap(u64 addr)
> >  	return ret;
> >  }
> >  
> > +static bool handle_host_mmio_trap(struct kvm_cpu_context *host_ctxt, u64 esr, u64 addr)
> > +{
> > +	u64 offset, reg_value = 0, start, end;
> > +	u8 reg_size, reg_index;
> > +	bool write;
> > +	int i;
> > +
> > +	for (i = 0; i < num_protected_reg; i++) {
> 
> This is potentially slow for a fast path. As this is an array, we could sort it
> and do a binary search, just like find_mem_range?

Yes we can do that but there are not too many fields in the array(8
atm.)  and we only enter in this when we trap MMIO (because we check for
!addr_is_memory(..))

Thanks,
Sebastian

> 
> > +		start = pkvm_protected_regs[i].start_pfn << PAGE_SHIFT;
> > +		end = start + (pkvm_protected_regs[i].num_pages << PAGE_SHIFT);
> > +
> > +		if (start > addr || addr > end)
> > +			continue;
> > +
> > +		reg_size = BIT((esr & ESR_ELx_SAS) >> ESR_ELx_SAS_SHIFT);
> > +		reg_index = (esr & ESR_ELx_SRT_MASK) >> ESR_ELx_SRT_SHIFT;
> > +		write = (esr & ESR_ELx_WNR) == ESR_ELx_WNR;
> > +		offset = addr - start;
> > +
> > +		if (write)
> > +			reg_value = host_ctxt->regs.regs[reg_index];
> > +
> > +		pkvm_protected_regs[i].cb(&pkvm_protected_regs[i], offset, write,
> > +					  &reg_value, reg_size);
> > +
> > +		if (!write)
> > +			host_ctxt->regs.regs[reg_index] = reg_value;
> > +
> > +		kvm_skip_host_instr();
> > +		return true;
> > +	}
> > +
> > +	return false;
> > +}
> > +
> >  void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
> >  {
> >  	struct kvm_vcpu_fault_info fault;
> > @@ -630,6 +666,11 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
> >  	 */
> >  	BUG_ON(!(fault.hpfar_el2 & HPFAR_EL2_NS));
> >  	addr = FIELD_GET(HPFAR_EL2_FIPA, fault.hpfar_el2) << 12;
> > +	addr |= fault.far_el2 & FAR_MASK;
> > +
> > +	if (ESR_ELx_EC(esr) == ESR_ELx_EC_DABT_LOW && !addr_is_memory(addr) &&
> > +	    handle_host_mmio_trap(host_ctxt, esr, addr))
> > +		return;
> >  
> >  	ret = host_stage2_idmap(addr);
> >  	BUG_ON(ret && ret != -EAGAIN);
> > diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> > index ad5b96085e1b..f91dfebe9980 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> > @@ -296,6 +296,9 @@ static int unmap_protected_regions(void)
> >  			if (ret)
> >  				goto err_setup;
> >  		}
> > +
> > +		if (reg->cb)
> > +			reg->cb = kern_hyp_va(reg->cb);
> >  	}
> >  
> >  	return 0;
> > -- 
> > 2.53.0.473.g4a7958ca14-goog
> > 
