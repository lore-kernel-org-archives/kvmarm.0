Return-Path: <SRS0=ChHZ=IK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5279BC433DB
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 06:34:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A1F2C64F82
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 06:34:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A1F2C64F82
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E7A7B4B40B;
	Fri, 12 Mar 2021 01:34:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YP6sFtLbHjnI; Fri, 12 Mar 2021 01:34:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5846F4B656;
	Fri, 12 Mar 2021 01:34:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D61A4B568
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 01:34:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id utlloh4bDmHC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Mar 2021 01:34:13 -0500 (EST)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com
 [209.85.128.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7ED464B40B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 01:34:13 -0500 (EST)
Received: by mail-wm1-f48.google.com with SMTP id g25so3097283wmh.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 22:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=1/tfClp+7Xwws1Pzo0a1sfKu9YRenK6a+xVG2qklwd4=;
 b=HbVmTtEiViLLTmj5PsNXwihfohAn4IXar+c8rDArckbzttahoELkcZBLU3H5B53M/B
 yl8Qsl8vmYcFYPbNLm+E/5rs/XVU4JRHK+xzL83AabloXrgBHN7x2JmIjv8WIJWn5Lsq
 lsaS7UHui+qNtWlL1ZsDZ7/bXi/Qs0gL76SLst2hQL5e+3lvM+AatMVQRAgQeijKee10
 K2n1ny8KYwAdg60MLTf6jwBKv2SPzfS8if6SfxlCzOHublVVFvtMyjLX9iAXb0XND6Bf
 IT6GVVHlt4CWPXSvvX0XBMG3ls9F43VdruAt03ENP6+32alyb6S1sqAgZn9Q7yvRByZj
 QVYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=1/tfClp+7Xwws1Pzo0a1sfKu9YRenK6a+xVG2qklwd4=;
 b=igM0EVprsgAGO4vKPN3XoaZXX02gnV9+IvKAjRPfcUc069p8FDhsCGzwmshktYgNyl
 Xpi9yQ9AzbpUBaEo1w2JJwH0sA2gxVmkvROCE/udt1ZY7+B0axfELwkpme9K9xAX+4v9
 ldDsNDXgx/BynZ9fRz2AV1N97eiGyIc7HJb/ciKisCbNMjJy7Y0dyNFLg4x8XIBsLy55
 nzWqI9VnqZA5BWB/PmllSHSt2Ni7UKimhMpDY4QvtBUNgJfBVVFSWrkoPgUt7os53704
 n27o+Xnfv6zPqR/hXyqBoHy+yD3UdWrbF5xZpj7QAbdByOl+vzsMlegI2r+kOOI9x0QE
 mcGA==
X-Gm-Message-State: AOAM533EdmqqbCM+RO8OvLq9FUuDBfrclNsf68/C4y12uGgDLY5LpsgT
 tN66ZHSCtNqQeZSY/7NYKyR+aw==
X-Google-Smtp-Source: ABdhPJzA/b526bFotN9qw9enozEUd7huuW/LQlBGtEU+Rk9os7n745FhiM+n3ml6/wx92ZKbGriN1g==
X-Received: by 2002:a05:600c:35c1:: with SMTP id
 r1mr11379120wmq.60.1615530852267; 
 Thu, 11 Mar 2021 22:34:12 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id s18sm7409255wrr.27.2021.03.11.22.34.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 11 Mar 2021 22:34:12 -0800 (PST)
Date: Fri, 12 Mar 2021 06:34:09 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 13/34] KVM: arm64: Enable access to sanitized CPU
 features at EL2
Message-ID: <YEsLYX2CjNMXF9TN@google.com>
References: <20210310175751.3320106-1-qperret@google.com>
 <20210310175751.3320106-14-qperret@google.com>
 <20210311193638.GE31586@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210311193638.GE31586@willie-the-truck>
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thursday 11 Mar 2021 at 19:36:39 (+0000), Will Deacon wrote:
> On Wed, Mar 10, 2021 at 05:57:30PM +0000, Quentin Perret wrote:
> > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> > index 066030717a4c..f2d8b479ff74 100644
> > --- a/arch/arm64/kernel/cpufeature.c
> > +++ b/arch/arm64/kernel/cpufeature.c
> > @@ -1154,6 +1154,18 @@ u64 read_sanitised_ftr_reg(u32 id)
> >  }
> >  EXPORT_SYMBOL_GPL(read_sanitised_ftr_reg);
> >  
> > +int copy_ftr_reg(u32 id, struct arm64_ftr_reg *dst)
> > +{
> > +	struct arm64_ftr_reg *regp = get_arm64_ftr_reg(id);
> > +
> > +	if (!regp)
> > +		return -EINVAL;
> > +
> > +	memcpy(dst, regp, sizeof(*regp));
> 
> Can you not just use struct assignment here?

Sure.

> > diff --git a/arch/arm64/kvm/hyp/nvhe/cache.S b/arch/arm64/kvm/hyp/nvhe/cache.S
> > new file mode 100644
> > index 000000000000..36cef6915428
> > --- /dev/null
> > +++ b/arch/arm64/kvm/hyp/nvhe/cache.S
> > @@ -0,0 +1,13 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Code copied from arch/arm64/mm/cache.S.
> > + */
> > +
> > +#include <linux/linkage.h>
> > +#include <asm/assembler.h>
> > +#include <asm/alternative.h>
> > +
> > +SYM_FUNC_START_PI(__flush_dcache_area)
> > +	dcache_by_line_op civac, sy, x0, x1, x2, x3
> > +	ret
> > +SYM_FUNC_END_PI(__flush_dcache_area)
> 
> Separate patch for this? (or fold it into that one really near the start
> that introduces some other PI helpers).

Right, I guess that'll make reverts and such easier so why not.

> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 4f2f1e3145de..84be93df52fa 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -21,6 +21,7 @@
> >  #include <asm/debug-monitors.h>
> >  #include <asm/esr.h>
> >  #include <asm/kvm_arm.h>
> > +#include <asm/kvm_cpufeature.h>
> >  #include <asm/kvm_emulate.h>
> >  #include <asm/kvm_hyp.h>
> >  #include <asm/kvm_mmu.h>
> > @@ -2775,3 +2776,23 @@ void kvm_sys_reg_table_init(void)
> >  	/* Clear all higher bits. */
> >  	cache_levels &= (1 << (i*3))-1;
> >  }
> > +
> > +#undef KVM_HYP_CPU_FTR_REG
> > +#define KVM_HYP_CPU_FTR_REG(id, name) \
> > +	{ .sys_id = id, .dst = (struct arm64_ftr_reg *)&kvm_nvhe_sym(name) },
> > +struct __ftr_reg_copy_entry {
> > +	u32			sys_id;
> > +	struct arm64_ftr_reg	*dst;
> > +} hyp_ftr_regs[] __initdata = {
> > +	#include <asm/kvm_cpufeature.h>
> > +};
> 
> This looks a bit elaborate to me. Why can't you just spell things out here
> like:
> 
> #define KVM_HYP_CPU_FTR_REG(id, name) \
> 	{ .sys_id = id, .dst = (struct arm64_ftr_reg *)&kvm_nvhe_sym(name) }
> 
> struct __ftr_reg_copy_entry {
> 	u32			sys_id;
> 	struct arm64_ftr_reg	*dst;
> } hyp_ftr_regs[] __initdata = {
> 	KVM_HYP_CPU_FTR_REG(SYS_CTR_EL0, arm64_ftr_reg_ctrel0),
> 	...
> };
> 
> and then have the header file be a normal, guarded header which just
> declares these things? The id parameter to the macro isn't used there.

I just tried to reduce the boilerplate as much as possible -- in the
current form you only need to add additional features to the header
it'll 'just work'.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
