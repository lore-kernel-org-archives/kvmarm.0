Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C1B1CD15
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 15:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733843761; cv=none; b=tsRQOXC4FFQunJ86Vcsr965TNiraCkXj9gNNQQ8L35Ne0nAvKddQrRQ9ZXPaGIi1SWZ2sLADE1pZl4CQl2O5dWJe8TxGNrmX585IlSkNKd9peZR955Dr0DKpOklMhW02jAlCin+30gwN473VgMI+NRn44CUzstbzG0yyz1MX0Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733843761; c=relaxed/simple;
	bh=8kN6LxvVCu219DP/ty/ojwWtnjH8wcUqw76Wx1ztkOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q0gPoGrSceOczuhdF0e+k1/N20yAEpZnKrtIvSBikLd36m6ic7rNwW3zX+2O06QRx7oMep7oOVPAikr85n3FAWyyzPnD2EDGtEPTnxK8hNcOPzVAeUL8FPCfS0tZ4SlLiqWJEXYAs3d4mF9Nh5VIrgQp7DDPdypD5FIOiLrgvuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iRTVpt/w; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iRTVpt/w"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-aa67f31a858so441443566b.2
        for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 07:15:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733843758; x=1734448558; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Lccj5szcR2Loq0SLYGfcfm6VfqCNUTcb2r9ZMHJPtZI=;
        b=iRTVpt/w4PdaWjQwhnjLocucCcBefmWgFxLnvsaF0DcAW6iEi+zLVJWcU0avxlCSlI
         NkAAHYMeNMM6c8t7l6lGzZQ8fkfao1G2lAAz0IQ5PRZOg2nduGHGqVpQ+IDUEwvSVLXh
         ahbyYX+I3d05WRifeVDKMJAUOU+TeTK49cgsRwM/6XoqIE9WpcDRcjmMQ1cgF9B8EnIq
         EywTyFUUnNLyx3Ra2FY6bG5IxVsOKTCdyQDcf5vVCorp/L1w4iHjcDsqIxTCDFxSKNrn
         mkgJ2QizX/KTYX1LeCyb3Ttu+AD2kP+xmsu/GUtXi7No9MujaQT3am1ofltY1CfgS6PI
         8S6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733843758; x=1734448558;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lccj5szcR2Loq0SLYGfcfm6VfqCNUTcb2r9ZMHJPtZI=;
        b=wfLTHYh1F0ar5N16sn1/bpLqm0kqQ9wuKEybMLG5XteknHRKB6RvoaUxT/QMG8h+zH
         fsHlnKOVL/0wHGL9ZQADue7Cmf0933hiVGny3Q9yABHRwuNbUpU1hT7X30FMaaDjGOGg
         Kb/QkjqWeSH9/yKUV8SIpTTKURQuw2+m0boiTE6BZu/kMWFZIQ5Ux0noKjJdya4oROGt
         GoKynENBMKUO/Z88gD+FWdqDQTHAPOfQTKCTBIQfHgb2fYBLYmGPY495vfFg6YiaHb7O
         A+cpAPYx1M9hk43cC7AIoANj9fjTdiqv7cYOEaYilOUwMX8SpcP6VoVaAoUqhOzH1HBl
         HEjw==
X-Forwarded-Encrypted: i=1; AJvYcCXImmNjm7WkP08v7b4M/itIA/lBpSeh1cLZodtVBaCsvVe4cuTDYpfLmEJTBNYRGL1MEdBQ7BA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwGsGYwzWaCY9ZfwUBJTmLll1yT+LVH350Cin07cpc8/7uXV40f
	vyXiCzhWQ00e132Q4/ULpeafEIQZ0FGz7+TphWflzxPExftxoJABUkY31wpIWw==
X-Gm-Gg: ASbGncuZWNOQVjYgeh8K+uy4lqAILglHkyr/JGrBGvUdnIlGBAr54RCF++o073h910Z
	YguTO4OBnHwymTEz/1K9gN1de9FN3nZ01Bp1gm8IBHzGpVmKKJxyoCAswwEYMsRbJ6RywOriUng
	2IWVlyXMriSJsTVlmrnA+zPMS1qgi7fX3+kWgY6/sHSlB5Q7npeFDW9C6tCHr20H7tRnSHxfYSC
	gWvUAx4Ethb9317O86RdiJXQNFcVJpPLMwttuc2gPuWBS2BwLW29po5V74SChHaDZnVJsv5Ne8F
	QIWfQrfbfj3R
X-Google-Smtp-Source: AGHT+IGQyoODgkoUO+Oc0opjizE3auLPjFl7HcIY2FHdwIvo4FWM24+WSW6gR/vIwAErqWTGt1UzGQ==
X-Received: by 2002:a17:906:4d2:b0:aa6:aa89:6d5e with SMTP id a640c23a62f3a-aa6aa8971d4mr141516366b.18.1733843758225;
        Tue, 10 Dec 2024 07:15:58 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa68f4eb962sm281095666b.3.2024.12.10.07.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 07:15:57 -0800 (PST)
Date: Tue, 10 Dec 2024 15:15:54 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/18] KVM: arm64: Change the layout of enum
 pkvm_page_state
Message-ID: <Z1hbKrUPXdEokXpP@google.com>
References: <20241203103735.2267589-1-qperret@google.com>
 <20241203103735.2267589-2-qperret@google.com>
 <CA+EHjTxfchr+ggO_z_zrrFTrFpS3oTJXt13t-854xWxYY=oSQQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTxfchr+ggO_z_zrrFTrFpS3oTJXt13t-854xWxYY=oSQQ@mail.gmail.com>

Hey Fuad,

On Tuesday 10 Dec 2024 at 12:59:44 (+0000), Fuad Tabba wrote:
> Hi Quentin,
> 
> On Tue, 3 Dec 2024 at 10:37, Quentin Perret <qperret@google.com> wrote:
> >
> > The 'concrete' (a.k.a non-meta) page states are currently encoded using
> > software bits in PTEs. For performance reasons, the abstract
> > pkvm_page_state enum uses the same bits to encode these states as that
> > makes conversions from and to PTEs easy.
> >
> > In order to prepare the ground for moving the 'concrete' state storage
> > to the hyp vmemmap, re-arrange the enum to use bits 0 and 1 for this
> > purpose.
> >
> > No functional changes intended.
> >
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 17 ++++++++++-------
> >  1 file changed, 10 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > index 0972faccc2af..ca3177481b78 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > @@ -24,25 +24,28 @@
> >   */
> >  enum pkvm_page_state {
> >         PKVM_PAGE_OWNED                 = 0ULL,
> > -       PKVM_PAGE_SHARED_OWNED          = KVM_PGTABLE_PROT_SW0,
> > -       PKVM_PAGE_SHARED_BORROWED       = KVM_PGTABLE_PROT_SW1,
> > -       __PKVM_PAGE_RESERVED            = KVM_PGTABLE_PROT_SW0 |
> > -                                         KVM_PGTABLE_PROT_SW1,
> > +       PKVM_PAGE_SHARED_OWNED          = BIT(0),
> > +       PKVM_PAGE_SHARED_BORROWED       = BIT(1),
> > +       __PKVM_PAGE_RESERVED            = BIT(0) | BIT(1),
> >
> >         /* Meta-states which aren't encoded directly in the PTE's SW bits */
> > -       PKVM_NOPAGE,
> > +       PKVM_NOPAGE                     = BIT(2),
> >  };
> > +#define PKVM_PAGE_META_STATES_MASK     (~(BIT(0) | BIT(1)))
> >
> >  #define PKVM_PAGE_STATE_PROT_MASK      (KVM_PGTABLE_PROT_SW0 | KVM_PGTABLE_PROT_SW1)
> >  static inline enum kvm_pgtable_prot pkvm_mkstate(enum kvm_pgtable_prot prot,
> >                                                  enum pkvm_page_state state)
> >  {
> > -       return (prot & ~PKVM_PAGE_STATE_PROT_MASK) | state;
> > +       BUG_ON(state & PKVM_PAGE_META_STATES_MASK);
> 
> This is a slight change in functionality, having a BUG_ON instead of
> just masking out illegal states. Is it necessary?

Yep, this is arguably a bit zealous. Passing e.g. PKVM_NOPAGE to
pkvm_mkstate() would be properly bogus, so having a WARN_ON() or
BUG_ON() in there is still a good thing, but it should be done in a
separate patch.

I'll rework in v3.

> > +       prot &= ~PKVM_PAGE_STATE_PROT_MASK;
> > +       prot |= FIELD_PREP(PKVM_PAGE_STATE_PROT_MASK, state);
> > +       return prot;
> >  }
> >
> >  static inline enum pkvm_page_state pkvm_getstate(enum kvm_pgtable_prot prot)
> >  {
> > -       return prot & PKVM_PAGE_STATE_PROT_MASK;
> > +       return FIELD_GET(PKVM_PAGE_STATE_PROT_MASK, prot);
> >  }
> >
> >  struct host_mmu {
> > --
> > 2.47.0.338.g60cca15819-goog
> >
