Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAFFCC433E0
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 16:56:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5853964F33
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 16:56:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5853964F33
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFF494B3CE;
	Mon, 15 Mar 2021 12:56:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zHuJ5eBAKSlE; Mon, 15 Mar 2021 12:56:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6FA14B442;
	Mon, 15 Mar 2021 12:56:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0BCF4B1BE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 12:56:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DAzdfo8458vc for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 12:56:25 -0400 (EDT)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com
 [209.85.128.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D80D34B340
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 12:56:25 -0400 (EDT)
Received: by mail-wm1-f52.google.com with SMTP id g25so8522898wmh.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 09:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Y+xprG6vtxLrLveW5ZtmXkAhTW+9ve7ImVtbj1EZZHk=;
 b=mrnugUQmzKMeO4p3w/jnYU3L1WrHmqn69Ewz5QiylBU/GCQ7x2L5iCA/2VLhI22o1f
 W7jrrGpK5WWx3YVj7oM5uobQdYkmkHBrkxM8eBM/wtyNCQ4B3xtYrO0pRfS2MHwwMm/i
 r/yLef5VBQeLl5z7LufUnSYeT6PSQvb4YAx4eHzXliCNP0KVZVVrmT2OE9ql2ZoUCj4h
 6qLCrwsSJSS8Y7DinACPvae2jg3sDwxPbWHNSNB+c75KtEIH5lOiOTB+Tpk/HrTM4ABe
 gEjS0u885Zc+dHqAvZDyTfOraMGPj1KodeE4dzb6MOdSO+ppf8lS43Ce2F1tOKysy4CZ
 VMKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Y+xprG6vtxLrLveW5ZtmXkAhTW+9ve7ImVtbj1EZZHk=;
 b=dBqOGoP5nbMi0STJ5H1FudS3JM5eJnvNVfW3uYn5W451J0GYY5kt5n4Kx87kR2TTpK
 gKfOObktNAHIFW+d4z00kh9cWQsM7uWFozg1gUhkxB7c7VwbTd5n69RApQ9IyZK3q4pr
 AnyW39P5YTiUsPUzqaliNnmlS6nKpQrmz2LClgKnfKYVNMuGEV39zHr15LKAGsg/i8IE
 pRWgeBf2hH5wHBs/McYuRap3JPJEYqi1Ly9MP7eRBIpzMR8lLsH2DyVKjKSYWLjIYqT2
 80K1Tvxsu3xGTE0lh9PcbCJdjjnUYxnMldHdLudW7JsjZo5wfildewvAMHsPrbN75xEh
 I+7g==
X-Gm-Message-State: AOAM533XdVOVqz9Y0TL70H/FPJGeetsxj0nYMXW0BAnzsigDbnodxN8e
 zWiKIm9pH8fyTleUTplbh9S50w==
X-Google-Smtp-Source: ABdhPJxvHGew9n7ZzD/LWAiEsnPZPO/Aweogz7praM5dvQpdXhh8dOt7XfTLD17acpcb9/3p3JioXA==
X-Received: by 2002:a1c:c206:: with SMTP id s6mr563841wmf.77.1615827384635;
 Mon, 15 Mar 2021 09:56:24 -0700 (PDT)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id s18sm22046028wrr.27.2021.03.15.09.56.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 15 Mar 2021 09:56:24 -0700 (PDT)
Date: Mon, 15 Mar 2021 16:56:21 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 14/36] KVM: arm64: Provide __flush_dcache_area at EL2
Message-ID: <YE+RtegUL4ki2qa/@google.com>
References: <20210315143536.214621-1-qperret@google.com>
 <20210315143536.214621-15-qperret@google.com>
 <20210315163322.GE3430@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210315163322.GE3430@willie-the-truck>
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

On Monday 15 Mar 2021 at 16:33:23 (+0000), Will Deacon wrote:
> On Mon, Mar 15, 2021 at 02:35:14PM +0000, Quentin Perret wrote:
> > We will need to do cache maintenance at EL2 soon, so compile a copy of
> > __flush_dcache_area at EL2, and provide a copy of arm64_ftr_reg_ctrel0
> > as it is needed by the read_ctr macro.
> > 
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_cpufeature.h |  2 ++
> >  arch/arm64/kvm/hyp/nvhe/Makefile        |  3 ++-
> >  arch/arm64/kvm/hyp/nvhe/cache.S         | 13 +++++++++++++
> >  arch/arm64/kvm/sys_regs.c               |  1 +
> >  4 files changed, 18 insertions(+), 1 deletion(-)
> >  create mode 100644 arch/arm64/kvm/hyp/nvhe/cache.S
> > 
> > diff --git a/arch/arm64/include/asm/kvm_cpufeature.h b/arch/arm64/include/asm/kvm_cpufeature.h
> > index 3fd9f60d2180..efba1b89b8a4 100644
> > --- a/arch/arm64/include/asm/kvm_cpufeature.h
> > +++ b/arch/arm64/include/asm/kvm_cpufeature.h
> > @@ -13,3 +13,5 @@
> >  #define KVM_HYP_CPU_FTR_REG(name) extern struct arm64_ftr_reg kvm_nvhe_sym(name)
> >  #endif
> >  #endif
> > +
> > +KVM_HYP_CPU_FTR_REG(arm64_ftr_reg_ctrel0);
> 
> I still think this is a bit weird. If you really want to macro-ise stuff,
> then why not follow the sort of thing we do for e.g. per-cpu variables and
> have separate DECLARE_HYP_CPU_FTR_REG and DEFINE_HYP_CPU_FTR_REG macros.
> 
> That way kvm_cpufeature.h can have header guards like a normal header and
> we can drop the '#ifndef KVM_HYP_CPU_FTR_REG' altogether. I don't think
> the duplication of the symbol name really matters -- it should fail at
> build time if something is missing.

I just tend to hate unnecessary boilerplate, but if you feel strongly
about it, happy to change :)

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
