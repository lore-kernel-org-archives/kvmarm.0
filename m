Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794236335;
	b=FZe2GUlkpNS8PMAxageE8R7KzqP/hlNfgfBMV75Pxa6r2JPXtYJRiXH+W0jzMsAaelqu
	 hruhXSAg2JnSyQLq5t/g38miRt/24DYHTymj+GPOSOiO8bME0r/dh5mdMTlhBl2eKZiAO
	 /R6eJmA4y6GBokPuaTjd//KjV+FJUlzrutCEvZsixGlD2t0j8WpHYwqbWk697R1RFYfB/
	 /+tCHXFbFweZYb24O91bb7Gu2et0KYVdyijP5sSoTAEWZJGGOT3s+X82oAbXBdpMnS43C
	 CqxlJas6CTMyJ2Jd/e+eprsdRN8+VYnFD5N4JMjAEtHN1yPpxvIPLdTWvdaGpr5bagw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794236335;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=BUlcemVKSy1aly5lghh79Jsyo31y0KT2wUOF5YDxAD0=;
	b=H2ee1T1T74mQAiYzwBD57vTNYug2nph8Fzo4H1Nfm04KDGgrYWtQawQW7XXu1MBDgFa1
	 1efmL5QlEALillzBwETpt+2oOW7BCi6PIDKzgwdR8Dng5xj3sSRmm/LVuLGoECpt957Xk
	 oZDvOGI2xLn73gDQx9lE5jpT5Rch/z+Ww4kj6YwYnd5LGds4oRFjt9PKYNTyZU6LhAJ9S
	 OXiMeeG1mM/3BObQ92p7c35jAAEq1cNgDlkTTVw3vr9chQjQlIEUZ/13x7yBy1kN+RCCq
	 8KX/yAsbh3Avf6QCUYt+39c6vtEvIh/BaosDMloBDsYEiMdFGepiY04na2W6eh8NQIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ShO469X1;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BA96606A321
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 14:58:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8BA96606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ShO469X1
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 86D9714BF;
	Mon,  9 Nov 2026 06:58:49 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 51C5B3F85F;
	Mon,  9 Nov 2026 06:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794236332; bh=/YWsMtiXHeD2+Z2sUeLJPW83qIoOAL9dkqf6qd2V4L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ShO469X1gAaFl21c/gOhk658pkxBTvkupJH4758MUyMLy2l4iioX1Ddp55jNu3MFS
	 M71yuxbbIMOhKiq9IPd43G+AeifDeU9yBi1PCLmh48fcl/rrxoF0jZ3QwmQPcXBOaW
	 1jWPBo+fWWTp3tLmqrWTRShdrcmoObkX8BNFpwFc=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v4 2/3] KVM: arm64: Introduce KVM_PGTABLE_WALK_SKIP_LEVEL* walk flags
Date: Mon,  9 Nov 2026 14:58:42 +0000
Message-ID: <avHfohqBxlNqo8_R@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <au4YvD_8B3PzbofZ@kernel.org>
References: <20261106161240.1345126-1-leo.bras@arm.com> <20261106161240.1345126-3-leo.bras@arm.com> <au4YvD_8B3PzbofZ@kernel.org>
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

On Fri, Nov 06, 2026 at 10:13:16AM -0800, Oliver Upton wrote:
> Hi Leo,
> 
> On Fri, Nov 06, 2026 at 04:12:37PM +0000, Leonardo Bras wrote:
> > Add new walking flags KVM_PGTABLE_WALK_SKIP_LEVEL{0-3}.
> > When used, they make the kvm_pgtable_walk() skip the given level, as well
> > as levels higher than that.
> > 
> > Being able to skip levels substancially decreases the runtime of a
> > pagetable walk when the callback function does nothing on that level.
> > 
> > Signed-off-by: Leonardo Bras <leo.bras@arm.com>
> 
> I'm still not crazy about using a flag per level... This is what I have
> stuffed on top locally. I've got a similar oneline fix for patch #3 to
> initialize the field with an offset.
> 
> Any opinions?
> 
> Thanks,
> Oliver
> 
> commit cad2070228c4305b5a83ce0a4cfa4aaa3dc0eb44
> Author: Oliver Upton <oupton@kernel.org>
> Date:   Fri Nov 6 10:03:14 2026 -0800
> 
>     squash! KVM: arm64: Introduce KVM_PGTABLE_WALK_SKIP_LEVEL* walk flags
>     
>     KVM: arm64: Add support for early termination of table walk recursion
>     
>     Add a new field to the walk flags that represents an offset from the
>     last level of the page table hierarchy at which recursion should
>     terminate.
> 
>     Signed-off-by: Leonardo Bras <leo.bras@arm.com>
>     [oliver: pass a numeric value instead of a flag per level]
>     Signed-off-by: Oliver Upton <oupton@kernel.org>
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 1d7a9125e522..18dcce3c506e 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -326,10 +326,8 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
>   * @KVM_PGTABLE_WALK_SKIP_CMO:		Visit and update table entries
>   *					without Cache maintenance
>   *					operations required.
> - * @KVM_PGTABLE_WALK_SKIP_LEVEL0:	Skip visiting level 0+ entries
> - * @KVM_PGTABLE_WALK_SKIP_LEVEL1:	Skip visiting level 1+ entries
> - * @KVM_PGTABLE_WALK_SKIP_LEVEL2:	Skip visiting level 2+ entries
> - * @KVM_PGTABLE_WALK_SKIP_LEVEL3:	Skip visiting level 3 entries
> + * @KVM_PGTABLE_WALK_SKIP_OFFSET:	Offset from KVM_PGTABLE_LAST_LEVEL at
> + * 					which the walk should stop descending
>   */
>  enum kvm_pgtable_walk_flags {
>  	KVM_PGTABLE_WALK_LEAF			= BIT(0),
> @@ -339,18 +337,9 @@ enum kvm_pgtable_walk_flags {
>  	KVM_PGTABLE_WALK_IGNORE_EAGAIN		= BIT(4),
>  	KVM_PGTABLE_WALK_SKIP_BBM_TLBI		= BIT(5),
>  	KVM_PGTABLE_WALK_SKIP_CMO		= BIT(6),
> -	/* SKIP_LEVEL* flags should not be split nor reordered */
> -	KVM_PGTABLE_WALK_SKIP_LEVEL0		= BIT(7),
> -	KVM_PGTABLE_WALK_SKIP_LEVEL1		= BIT(8),
> -	KVM_PGTABLE_WALK_SKIP_LEVEL2		= BIT(9),
> -	KVM_PGTABLE_WALK_SKIP_LEVEL3		= BIT(10),
> +	KVM_PGTABLE_WALK_SKIP_OFFSET		= GENMASK(9, 7),
>  };
>  
> -#define KVM_PGTABLE_WALK_SKIP_LEVELS 	(KVM_PGTABLE_WALK_SKIP_LEVEL0 | \
> -					 KVM_PGTABLE_WALK_SKIP_LEVEL1 | \
> -					 KVM_PGTABLE_WALK_SKIP_LEVEL2 | \
> -					 KVM_PGTABLE_WALK_SKIP_LEVEL3 )
> -
>  struct kvm_pgtable_visit_ctx {
>  	kvm_pte_t				*ptep;
>  	kvm_pte_t				old;
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 6aaf2696c99a..3008817da6c5 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -147,9 +147,12 @@ static bool kvm_pgtable_walk_continue(const struct kvm_pgtable_walker *walker,
>  
>  static bool kvm_pgtable_skip_level(s8 level, enum kvm_pgtable_walk_flags flags)
>  {
> -	u32 skip = FIELD_GET(KVM_PGTABLE_WALK_SKIP_LEVELS, flags);
> +	u8 offset = FIELD_GET(KVM_PGTABLE_WALK_SKIP_OFFSET, flags);
>  
> -	return unlikely(skip && level >= ffs(skip) - 1);
> +	BUILD_BUG_ON(!FIELD_FIT(KVM_PGTABLE_WALK_SKIP_OFFSET,
> +				KVM_PGTABLE_LAST_LEVEL - KVM_PGTABLE_FIRST_LEVEL));
> +
> +	return unlikely(level > KVM_PGTABLE_LAST_LEVEL - offset);
>  }
>  
>  static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
> 

Hi Oliver,
Sure, I agree it looks much better in terms of coding: it uses a single 
flag and only 3 bits for all levels. Checking it is simpler as well, so I 
am pretty much willing to use it in v5.

The only part that bothers me is naming... skip_offset seems a bit generic 
to me:

	struct kvm_pgtable_walker walker = {
		.flags  = KVM_PGTABLE_WALK_LEAF |
			  FIELD_PREP(KVM_PGTABLE_WALK_SKIP_OFFSET, 1),
	}

What if we use, instead: 

KVM_PGTABLE_WALK_SKIP_LAST_N_LEVELS 

Then when using, we could have something like:
 
        struct kvm_pgtable_walker walker = {
                .flags  = KVM_PGTABLE_WALK_LEAF |
			  FIELD_PREP(KVM_PGTABLE_WALK_SKIP_LAST_N_LEVELS, 1),
	}

It becomes much longer, but I think it looks easier to understand it like 
this, if I did not already knew what it does. (Maybe we can think on 
something a bit shorter?)


What do you think?

Thanks!
Leo
