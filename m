Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6618A198A17
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 15:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789574057; cv=none; b=fNgTCffXK2ISRkbsDj3qTUecrji89HgYj8AnXCmn9rt86EDygrL2fP+1QQA7REZ4aVn6ImhTWSQrTgH4nhcP9S/JDTivAnrKbEuWHW7XILSAvJzBNDNlvpBx2I0RxZiwHxaNnsrNziHQwQoQVe+Gq+Lejx3I/mDBHXGS8F8qGC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789574057; c=relaxed/simple;
	bh=nO4Kn93ujWWbTNUYfpF4vz6nJjE3M3ST8VDInheB/xM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=OsleA0gzdrTLPqaa3MqQNN6YemX6VioAWZ/8v7/M+Ov+wQyBYPzmVXI3IabRnAUHRI1KCC/iwnenjyyzY9a0lRy47rF4bZXx5CcTa8DEQflR98bBNVAt/RGHtdYFxSKeZC2uGymkx4bIdOheSj+0HLk1IO/DdSG9uMIY4xf6Ipo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GO9DOhLv; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GO9DOhLv"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E44131516;
	Wed, 16 Sep 2026 08:54:09 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (unknown [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 010A33F86F;
	Wed, 16 Sep 2026 08:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789574053; bh=nO4Kn93ujWWbTNUYfpF4vz6nJjE3M3ST8VDInheB/xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GO9DOhLvZ/DGzXfpVS8yK4dMAvP1O9cckOp//wu6Try+wwspMAOB0cOXWMJtzfHgk
	 Nl86Bdsq6QCoFb7iuqdyeT51odxfHzvDXxTl9zveaVaBOgafYJZMelvldXwIROLKNz
	 MEJ6nW37XFxyPUjf8TwqwpgiCsDUCeOrl8gxRIJE=
From: Leonardo Bras <leo.bras@arm.com>
To: Linus Walleij <linusw@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Usama Anjum <usama.anjum@arm.com>
Subject: Re: [PATCH v2] arm64: clear_page[s] using memset
Date: Wed, 16 Sep 2026 16:54:09 +0100
Message-ID: <aqq7oZzutLP82WYB@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <aqq1sxdQNZ93oV9A@LeoBrasDK>
References: <20260916-aarch64-clear-pages-c-v2-1-0393769f7912@kernel.org> <aqq1sxdQNZ93oV9A@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Sep 16, 2026 at 04:28:51PM +0100, Leonardo Bras wrote:
> On Wed, Sep 16, 2026 at 12:03:56PM +0200, Linus Walleij wrote:
> > There is no need to try to second-guess the compiler when
> > clearing memory. Just call memset() like everyone else.
> > 
> > Since memset() already has an architecture-local MOPS
> > optimization, we do not need to do anything else to preserve
> > the MOPS optimization.
> > 
> > While at it, implement the shorthand for directly calling
> > the new prototype clear_pages() for larger page chunks.
> > 
> > No performance regressions can be seen, the fastpath
> > benchmarks differences are in the noise.
> > 
> > Usama Anjum tested next-20260821 with one warm-up and three repeats
> > in four sessions, for a total of 12 measured runs. The commands were:
> > 
> >   perf bench mem memset -k 1GB -f default -s 16GB
> >   perf bench mem mmap -p 1GB -f demand -s 32GB -l 5
> >   perf bench mem mmap -p 4KB -f demand -s 32GB -l 5
> > 
> > The results were:
> > 
> > aws-m7g.metal:
> >   Benchmark    Base bytes/sec   Change with patch
> >   memset 1GB   63932542232.12                1.92%
> >   mmap 1GB     63272579168.03               -0.57%
> >   mmap 4KB     49692830849.48               -1.11%
> > 
> > cesw-aarch64-ampereone-1s-a192-32x:
> >   Benchmark    Base bytes/sec   Change with patch
> >   memset 1GB   33895562998.71                0.25%
> >   mmap 1GB     34338454210.17                1.16%
> >   mmap 4KB     25687107580.90               -0.85%
> > 
> > Assisted-by: LLM
> > Suggested-by: Will Deacon <will@kernel.org>
> > Tested-by: Usama Anjum <usama.anjum@arm.com>
> > Link: https://lore.kernel.org/linux-arm-kernel/20260303-aarch64-clear-pages-v1-1-ad0c3ee9a555@kernel.org/
> > Link: https://lore.kernel.org/linux-arm-kernel/67ab6c51-4511-46ab-931b-a4323551147a@arm.com/
> > Signed-off-by: Linus Walleij <linusw@kernel.org>
> > ---
> > Changes in v2:
> > - Rebased on v7.3-rc1
> > - Include Usama Anjum's performance results and Tested-by tag.
> > - Link to v1: https://lore.kernel.org/r/20260306-aarch64-clear-pages-c-v1-1-77c1bb0f1c21@kernel.org
> > ---
> >  arch/arm64/include/asm/page.h    | 13 +++++++++-
> >  arch/arm64/kernel/image-vars.h   |  1 -
> >  arch/arm64/kvm/hyp/nvhe/Makefile |  2 +-
> >  arch/arm64/lib/Makefile          |  2 +-
> >  arch/arm64/lib/clear_page.S      | 53 ----------------------------------------
> >  5 files changed, 14 insertions(+), 57 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
> > index 58200de8a221..b2eaa63d9056 100644
> > --- a/arch/arm64/include/asm/page.h
> > +++ b/arch/arm64/include/asm/page.h
> > @@ -13,6 +13,7 @@
> >  #ifndef __ASSEMBLER__
> >  
> >  #include <linux/personality.h> /* for READ_IMPLIES_EXEC */
> > +#include <linux/string.h> /* for memset() */
> >  #include <linux/types.h> /* for gfp_t */
> >  #include <asm/pgtable-types.h>
> >  
> > @@ -20,7 +21,17 @@ struct page;
> >  struct vm_area_struct;
> >  
> >  extern void copy_page(void *to, const void *from);
> > -extern void clear_page(void *to);
> > +
> > +static inline void clear_pages(void *addr, unsigned int npages)
> > +{
> > +	memset(addr, 0, npages * PAGE_SIZE);
> > +}
> > +#define clear_pages clear_pages
> > +
> > +static inline void clear_page(void *addr)
> > +{
> > +	clear_pages(addr, 1);
> > +}
> >  
> >  void copy_user_highpage(struct page *to, struct page *from,
> >  			unsigned long vaddr, struct vm_area_struct *vma);
> > diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> > index 14beb7b9d304..facda8137d9b 100644
> > --- a/arch/arm64/kernel/image-vars.h
> > +++ b/arch/arm64/kernel/image-vars.h
> > @@ -119,7 +119,6 @@ KVM_NVHE_ALIAS(__start___kvm_ex_table);
> >  KVM_NVHE_ALIAS(__stop___kvm_ex_table);
> >  
> >  /* Position-independent library routines */
> > -KVM_NVHE_ALIAS_HYP(clear_page, __pi_clear_page);
> >  KVM_NVHE_ALIAS_HYP(copy_page, __pi_copy_page);
> >  KVM_NVHE_ALIAS_HYP(memcpy, __pi_memcpy);
> >  KVM_NVHE_ALIAS_HYP(memset, __pi_memset);
> > diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> > index f57450ebcb49..2ed489bf544e 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> > +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> > @@ -17,7 +17,7 @@ ccflags-y += -fno-stack-protector	\
> >  hostprogs := gen-hyprel
> >  HOST_EXTRACFLAGS += -I$(objtree)/include
> >  
> > -lib-objs := clear_page.o copy_page.o memcpy.o memset.o tishift.o
> > +lib-objs := copy_page.o memcpy.o memset.o tishift.o
> >  lib-objs := $(addprefix ../../../lib/, $(lib-objs))
> >  
> >  CFLAGS_switch.nvhe.o += -Wno-override-init
> > diff --git a/arch/arm64/lib/Makefile b/arch/arm64/lib/Makefile
> > index b33e1ca4a781..38ffd359123c 100644
> > --- a/arch/arm64/lib/Makefile
> > +++ b/arch/arm64/lib/Makefile
> > @@ -5,7 +5,7 @@ KCSAN_SANITIZE_delay.o := n
> >  
> >  lib-y		:= clear_user.o delay.o copy_from_user.o		\
> >  		   copy_to_user.o copy_page.o				\
> > -		   clear_page.o csum.o insn.o memchr.o memcpy.o		\
> > +		   csum.o insn.o memchr.o memcpy.o			\
> >  		   memset.o memcmp.o strcmp.o strncmp.o strlen.o	\
> >  		   strnlen.o strchr.o strrchr.o tishift.o
> >  
> > diff --git a/arch/arm64/lib/clear_page.S b/arch/arm64/lib/clear_page.S
> > deleted file mode 100644
> > index bd6f7d5eb6eb..000000000000
> > --- a/arch/arm64/lib/clear_page.S
> > +++ /dev/null
> > @@ -1,53 +0,0 @@
> > -/* SPDX-License-Identifier: GPL-2.0-only */
> > -/*
> > - * Copyright (C) 2012 ARM Ltd.
> > - */
> > -
> > -#include <linux/linkage.h>
> > -#include <linux/const.h>
> > -#include <asm/assembler.h>
> > -#include <asm/page.h>
> > -
> > -/*
> > - * Clear page @dest
> > - *
> > - * Parameters:
> > - *	x0 - dest
> > - */
> > -SYM_FUNC_START(__pi_clear_page)
> > -#ifdef CONFIG_AS_HAS_MOPS
> > -	.arch_extension mops
> > -alternative_if_not ARM64_HAS_MOPS
> > -	b	.Lno_mops
> > -alternative_else_nop_endif
> > -
> > -	mov	x1, #PAGE_SIZE
> > -	setpn	[x0]!, x1!, xzr
> > -	setmn	[x0]!, x1!, xzr
> > -	seten	[x0]!, x1!, xzr
> > -	ret
> > -.Lno_mops:
> > -#endif
> > -	mrs	x1, dczid_el0
> > -	tbnz	x1, #4, 2f	/* Branch if DC ZVA is prohibited */
> > -	and	w1, w1, #0xf
> > -	mov	x2, #4
> > -	lsl	x1, x2, x1
> > -
> > -1:	dc	zva, x0
> > -	add	x0, x0, x1
> > -	tst	x0, #(PAGE_SIZE - 1)
> > -	b.ne	1b
> > -	ret
> > -
> > -2:	stnp	xzr, xzr, [x0]
> > -	stnp	xzr, xzr, [x0, #16]
> > -	stnp	xzr, xzr, [x0, #32]
> > -	stnp	xzr, xzr, [x0, #48]
> > -	add	x0, x0, #64
> > -	tst	x0, #(PAGE_SIZE - 1)
> > -	b.ne	2b
> > -	ret
> > -SYM_FUNC_END(__pi_clear_page)
> > -SYM_FUNC_ALIAS(clear_page, __pi_clear_page)
> > -EXPORT_SYMBOL(clear_page)
> > 
> > ---
> > base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
> > change-id: 20260305-aarch64-clear-pages-c-590dae98c333
> > 
> > Best regards,
> > --  
> > Linus Walleij <linusw@kernel.org>
> > 
> > 
> 
> Oh, cool!
> You remove an in-kernel asm implementation to favor the standard memset(), 
> which allows you to also have a batched clear_pages() version, which should 
> also be a bit more optimized than the do-while loop running clear_page().
> 
> Last thing I would check is if there is any particular part of the current 
> clear_page() that could have different behavior than the one in memset(), 
> and if it would cause any kind of unexpected impact. 
> 
> Looking on that, I see that the memset() implementation uses setp, setm, 
> sete, while the clear_page()'s uses setpn, setmn, setn for the case with 
> MOPS. But then, reading into the docs, the instructions seem pretty much 
> the same thing. 
> 
> The arguments seem the same idea, exept for clear_page() always being xzr 
> instead of the memset value in xn, but should be the same thing.
> 
> The generic (no-MOPS) version is very different, though, which is expected 
> as the purpose of clean_page() is a particular case of memset(). Was any 
> test ran in machines without FEAT_MOPS?
> 
> Thanks!
> Leo

Oh, I browsed a bit here, and IIUC none of the tested machines have 
FEAT_MOPS, is that right?

If that's the case, the tests are exactly to what is different between 
patched and current versions. There should be no impact on MOPS version as 
the instructions are basically the same.

If I got that right, then, FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
