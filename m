Return-Path: <SRS0=ioR1=HG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64EC6C433E0
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 14:24:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BDEF164E4A
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 14:24:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BDEF164E4A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A5E84B245;
	Thu,  4 Feb 2021 09:24:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id g4Qk7rVIf-XQ; Thu,  4 Feb 2021 09:24:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 410084B207;
	Thu,  4 Feb 2021 09:24:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C9D34B1FD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 09:24:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CPaoAOIzahej for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2021 09:24:51 -0500 (EST)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com
 [209.85.128.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 27E1C4B0D8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 09:24:51 -0500 (EST)
Received: by mail-wm1-f43.google.com with SMTP id i9so3158195wmq.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Feb 2021 06:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=R1KAZ4C9ZeFSR+FFennp2QasFQcPFSyFTyZPPFMkXU8=;
 b=fCG8+WqCngaRVeR+fwhWXAcIWBn5Sl2e4mDoXuHKx8d69fodkwnVanTjcKzun/Oq1F
 aTuzHpifYoZkmVn9bAHqWJgOJOooBfSwFajyd2zSvXQqpExigCq2XXq0+QtPS5k0mrbC
 x0q4/10MpavYzq68sUQS9x65l72az1O6NDyfucEPMbG4JeQlFbs9Q2nyOXha6I4TQIEc
 PO/rwCmZ4HiKjmoHcQS6UP/eZBjC0WutDWRCjo2hkH2sCoVsGdcL/3M82SEwcTCBi9Vn
 dH03nNLXfcRs2DN/nVxzrDRf5njO6cbdUEANrH34er4ju+uET6WVTEZVNMKVoC/U2Mmk
 aF3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=R1KAZ4C9ZeFSR+FFennp2QasFQcPFSyFTyZPPFMkXU8=;
 b=mSjKlT4EkQy7kesr9jJ+g22b7Hbx6YV4Ox4SrJD9AL4SGu+D8VoDmXO7jrN/JQjATG
 v583MZ+pVvk1tCca2obPDpPDOQxlw9Q79EktPkxLAJUe8+L7BRMw75sGeeqh2nrW4m5P
 iTpbvjhrZMHCvBKkYAWL+pKNAP9KiKhkZkXmmfyes7Dt7xYpIW+OIJoYHoT9cDMD8HKW
 KJ/5wCVAWRRcwDmKgq1P7SbjjnQOVy/RxXMswxEz7PtE6VT84+5bv7dGnKAZd9yLVJMo
 4J/FFwyh4q/aZfoHE6dqreuhMycs4ieVLiHCqPYG6Nbkqpln2B3l0DJiyLOXR0tO3LaG
 fIgQ==
X-Gm-Message-State: AOAM5307W7PeaTNPJIxAZ1aqime755SdXs0wbbrb7LQcBvPIr1DahrMc
 J4jgH9CHxFgBJjqafsKUjbmizQ==
X-Google-Smtp-Source: ABdhPJyG/2NylKDcXm3Y18fIrqWKuc6sdceMpQkq33NZ0aiLb5JS4Ixo+Ft8ux+j9u+mNAQt0C8/Cw==
X-Received: by 2002:a7b:c153:: with SMTP id z19mr7657226wmi.87.1612448690019; 
 Thu, 04 Feb 2021 06:24:50 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id v6sm8568185wrx.32.2021.02.04.06.24.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 04 Feb 2021 06:24:49 -0800 (PST)
Date: Thu, 4 Feb 2021 14:24:44 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH v2 24/26] KVM: arm64: Make memcache anonymous in
 pgtable allocator
Message-ID: <YBwDrBH8p0aEpKKC@google.com>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-25-qperret@google.com>
 <20210203155944.GH18974@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210203155944.GH18974@willie-the-truck>
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

On Wednesday 03 Feb 2021 at 15:59:44 (+0000), Will Deacon wrote:
> On Fri, Jan 08, 2021 at 12:15:22PM +0000, Quentin Perret wrote:
> > The current stage2 page-table allocator uses a memcache to get
> > pre-allocated pages when it needs any. To allow re-using this code at
> > EL2 which uses a concept of memory pools, make the memcache argument to
> > kvm_pgtable_stage2_map() anonymous. and let the mm_ops zalloc_page()
> > callbacks use it the way they need to.
> > 
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h | 6 +++---
> >  arch/arm64/kvm/hyp/pgtable.c         | 4 ++--
> >  2 files changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 8e8f1d2c5e0e..d846bc3d3b77 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -176,8 +176,8 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
> >   * @size:	Size of the mapping.
> >   * @phys:	Physical address of the memory to map.
> >   * @prot:	Permissions and attributes for the mapping.
> > - * @mc:		Cache of pre-allocated GFP_PGTABLE_USER memory from which to
> > - *		allocate page-table pages.
> > + * @mc:		Cache of pre-allocated memory from which to allocate page-table
> > + *		pages.
> 
> We should probably mention that this memory must be zeroed, since I don't
> think the page-table code takes care of that.

OK, though I think this is unrelated to this change -- this is already
true today I believe. Anyhow, I'll pile a change on top.

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
