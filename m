Return-Path: <SRS0=ioR1=HG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC9AEC433DB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 14:07:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0ECF864DDE
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 14:07:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0ECF864DDE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A5334B235;
	Thu,  4 Feb 2021 09:07:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LgY1BlTORanJ; Thu,  4 Feb 2021 09:07:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FE474B1F9;
	Thu,  4 Feb 2021 09:07:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CE634B0F5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 09:07:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uDde-O1eXN7s for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2021 09:07:11 -0500 (EST)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com
 [209.85.221.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 676984B0FA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 09:07:11 -0500 (EST)
Received: by mail-wr1-f41.google.com with SMTP id d16so3594635wro.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Feb 2021 06:07:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=SWIWwQW6c5y88ky/tGs9MVqHhJ06CmDpooCYplmMmBc=;
 b=swdDPht2Lmes3NRKcd0D09P2eSo7wqGrMvXBzwBahtocMqUz+PI3h7a1j4QF/1I+2F
 Napqaio3hbJU4FaWdTljFdT9GQEZLvRS2h15ZQnH6CgIIyoEuAd9oVuTryYOrk2mlzcF
 4u4NRnQWccLZ/rGyeMPPM5NktE919Q9ePn5TGIbNI2WNom9nuxz3/KZmQ/SufLbfB12S
 Ly/4MOavDtEIX0aX1Np/uAf71oetpRkIKsdgFrARq3vxM7pdDWGsc2uHbNUKLq/OTn0L
 VAjX7bCcdKx0mbm1Mkx8pXn7cC2YbWImcou37XatElDjg+3bt2sAFEy3U6T8ZFa/9vf9
 4mcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=SWIWwQW6c5y88ky/tGs9MVqHhJ06CmDpooCYplmMmBc=;
 b=uh4CyLbci4iR1Bz/ohwPN3mfzDl3fyBg5HAn02n085QQuEPsJsLIqow/wTyhYcncMT
 n+g8c00p6idbivH/joruvQQcMnbQksmYYk8pHqh/+N6W9zPI6kqSZEcClcm3vBHQsr1L
 Gx1PDs384FORiYvlBcOU2xBmX3v0nnZyePFxtofP/lpaIOkCTTp+sgJhEgpEpEQbchg/
 umsHCnb8fX3i7eQVNUMu06pAhJJO9Ijx2mZVz5jrEg3cNTTG9jrLPrzf+yVYjB4Vfoex
 zmEUL+E1iJBcdqTejOerq93yfl7OKp5HbwJnx0e0XFJ8DGhB1XCy4gSnJQy7jBukcU4g
 OhpQ==
X-Gm-Message-State: AOAM531oYFJL7lQkPPHhhXZFzSid66PgTNAGsdF55H75Jt8JQ+vL961F
 80aNxf44dmei1PqDpDMCvfzvXA==
X-Google-Smtp-Source: ABdhPJwc/XtLGWIgPXmeIBHTVUramPSFwm7Rted+Qltv0unFuXU/mKs7ZFZVO+X5jCKlbBWoiTTkVw==
X-Received: by 2002:a5d:49cf:: with SMTP id t15mr9407446wrs.217.1612447630175; 
 Thu, 04 Feb 2021 06:07:10 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id b19sm6002248wmj.22.2021.02.04.06.07.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 04 Feb 2021 06:07:08 -0800 (PST)
Date: Thu, 4 Feb 2021 14:07:04 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH v2 21/26] KVM: arm64: Refactor kvm_arm_setup_stage2()
Message-ID: <YBv/iEl/Bjlte+yq@google.com>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-22-qperret@google.com>
 <20210203155354.GE18974@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210203155354.GE18974@willie-the-truck>
Cc: devicetree@vger.kernel.org, kernel-team@android.com, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Frank Rowand <frowand.list@gmail.com>, kvmarm@lists.cs.columbia.edu
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

On Wednesday 03 Feb 2021 at 15:53:54 (+0000), Will Deacon wrote:
> On Fri, Jan 08, 2021 at 12:15:19PM +0000, Quentin Perret wrote:
> > In order to re-use some of the stage 2 setup at EL2, factor parts of
> > kvm_arm_setup_stage2() out into static inline functions.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_mmu.h | 48 ++++++++++++++++++++++++++++++++
> >  arch/arm64/kvm/reset.c           | 42 +++-------------------------
> >  2 files changed, 52 insertions(+), 38 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> > index 662f0415344e..83b4c5cf4768 100644
> > --- a/arch/arm64/include/asm/kvm_mmu.h
> > +++ b/arch/arm64/include/asm/kvm_mmu.h
> > @@ -280,6 +280,54 @@ static inline int kvm_write_guest_lock(struct kvm *kvm, gpa_t gpa,
> >  	return ret;
> >  }
> >  
> > +static inline u64 kvm_get_parange(u64 mmfr0)
> > +{
> > +	u64 parange = cpuid_feature_extract_unsigned_field(mmfr0,
> > +				ID_AA64MMFR0_PARANGE_SHIFT);
> > +	if (parange > ID_AA64MMFR0_PARANGE_MAX)
> > +		parange = ID_AA64MMFR0_PARANGE_MAX;
> > +
> > +	return parange;
> > +}
> > +
> > +/*
> > + * The VTCR value is common across all the physical CPUs on the system.
> > + * We use system wide sanitised values to fill in different fields,
> > + * except for Hardware Management of Access Flags. HA Flag is set
> > + * unconditionally on all CPUs, as it is safe to run with or without
> > + * the feature and the bit is RES0 on CPUs that don't support it.
> > + */
> > +static inline u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
> > +{
> > +	u64 vtcr = VTCR_EL2_FLAGS;
> > +	u8 lvls;
> > +
> > +	vtcr |= kvm_get_parange(mmfr0) << VTCR_EL2_PS_SHIFT;
> > +	vtcr |= VTCR_EL2_T0SZ(phys_shift);
> > +	/*
> > +	 * Use a minimum 2 level page table to prevent splitting
> > +	 * host PMD huge pages at stage2.
> > +	 */
> > +	lvls = stage2_pgtable_levels(phys_shift);
> > +	if (lvls < 2)
> > +		lvls = 2;
> > +	vtcr |= VTCR_EL2_LVLS_TO_SL0(lvls);
> > +
> > +	/*
> > +	 * Enable the Hardware Access Flag management, unconditionally
> > +	 * on all CPUs. The features is RES0 on CPUs without the support
> > +	 * and must be ignored by the CPUs.
> > +	 */
> > +	vtcr |= VTCR_EL2_HA;
> > +
> > +	/* Set the vmid bits */
> > +	vtcr |= (get_vmid_bits(mmfr1) == 16) ?
> > +		VTCR_EL2_VS_16BIT :
> > +		VTCR_EL2_VS_8BIT;
> > +
> > +	return vtcr;
> > +}
> 
> Although I think this is functionally fine, I think it's unusual to see
> large "static inline" functions like this in shared header files. One
> alternative approach would be to follow the example of
> kernel/locking/qspinlock_paravirt.h, where the header is guarded in such a
> way that is only ever included by kernel/locking/qspinlock.c and therefore
> doesn't need the "inline" at all. That separation really helps, I think.

Alternatively, I might be able to have an mmu.c file in the hyp/ folder,
and to compile it for both the host kernel and the EL2 obj as we do for
a few things already. Or maybe I'll just stick it in pgtable.c. Either
way, it'll add a function call, but I can't really see that having any
measurable impact, so we should be fine.

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
