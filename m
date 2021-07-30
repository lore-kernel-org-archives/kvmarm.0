Return-Path: <SRS0=HDjL=MW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2004CC4320A
	for <kvmarm@archiver.kernel.org>; Fri, 30 Jul 2021 12:58:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8B8C960F46
	for <kvmarm@archiver.kernel.org>; Fri, 30 Jul 2021 12:58:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8B8C960F46
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 012AE4B09B;
	Fri, 30 Jul 2021 08:58:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SL1sjHPIzQyo; Fri, 30 Jul 2021 08:58:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E48964B0B2;
	Fri, 30 Jul 2021 08:58:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E6744B09A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 08:58:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wB9BRyxbRuIq for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jul 2021 08:58:51 -0400 (EDT)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com
 [209.85.221.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 071764A1B0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 08:58:51 -0400 (EDT)
Received: by mail-wr1-f50.google.com with SMTP id n12so11248158wrr.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 05:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=j8hwjM/QSzVbDdpvE5AeYjXhEWiO5+EcdPNYuJTkjFg=;
 b=TsfEJZvy1y2u50cLgrLLYofgWvuIMkgvXW0S+vvSU9GzX3mFKvG6124i06yOC8eb27
 20oETj/Pf8KSzJbb8oyT+eGuILBv/+i1pZ1yYPBDlVQCRZHWC4CrsXkwUFlGcwmS3eMC
 j1k6mWNpgiiH44Wu1eF0cfG2ZCnBWvtdaIBVuugBYUy6Xt3I9AlfYgi3SCEbxomhC9vU
 2RGxTWO+cEpbNB2ViIzHIEnFw8U9NRenXL5JGiiD8tz/wL4ygy6t/NEK5VwNqnS7obW7
 ob0CwQ821wKM68qZa6pKGtKOBElIFnHxra9+PupVE5JcWVCd4j53gRNXxHm0UbJDwPnP
 ejOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=j8hwjM/QSzVbDdpvE5AeYjXhEWiO5+EcdPNYuJTkjFg=;
 b=gAbjhEcDCGloZxVzLVIRiWv7m7fAGkVDcYbetD6dPBom3ub07Q1kISB/yPQzxD+0A3
 JzvdZHDhmjQLq+VDifJw2BKHnYFude0zHIhmhpBLWKxEr/kT21f1fXRZz5tHNt/dGlDH
 wGREDc+2fwzSl8MU5WjQr1vld53HrgOQHbEAW9kfofWaSpNRP7+xl7UsZqlZU6fPG5BC
 m++PdlVuIMBVXFGsA0hhuTea9zYbrs5dtz2rVhzdo0KFVLsN5xKlTGoE3BiJdDhyqxYm
 vlyzQdvB1kIGIwNvOFxpXbTPQ7xTrV4oItjvReMYFl42Oq5SEbte+F8b/SGBcN6nZIjn
 U7Xw==
X-Gm-Message-State: AOAM533NupjbKxlqSQxsuQCYFKYcpBCFkC9iW94r8YtBzL43YGWyKv8m
 B/OUkir/I5HM4JEA2tNMHOLLVw==
X-Google-Smtp-Source: ABdhPJw3CJ1cqpI0Y4vGMsPLtJPixEOIGryBdXpTDYmJE+DPDNyY/xAIzO3MXjhCsbR8ZQ/NrllLug==
X-Received: by 2002:adf:d087:: with SMTP id y7mr2868579wrh.323.1627649929764; 
 Fri, 30 Jul 2021 05:58:49 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:26d7:991f:a808:7661])
 by smtp.gmail.com with ESMTPSA id h12sm1678791wrm.62.2021.07.30.05.58.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 30 Jul 2021 05:58:49 -0700 (PDT)
Date: Fri, 30 Jul 2021 13:58:46 +0100
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH 04/16] KVM: arm64: Add MMIO checking infrastructure
Message-ID: <YQP3hnkXs1R7PRqt@google.com>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-5-maz@kernel.org>
 <20210727181107.GC19173@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210727181107.GC19173@willie-the-truck>
Cc: kernel-team@android.com, kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Srivatsa Vaddagiri <vatsa@codeaurora.org>, linux-kernel@vger.kernel.org,
 Shanker R Donthineni <sdonthineni@nvidia.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Tuesday 27 Jul 2021 at 19:11:08 (+0100), Will Deacon wrote:
> On Thu, Jul 15, 2021 at 05:31:47PM +0100, Marc Zyngier wrote:
> > Introduce the infrastructure required to identify an IPA region
> > that is expected to be used as an MMIO window.
> > 
> > This include mapping, unmapping and checking the regions. Nothing
> > calls into it yet, so no expected functional change.
> > 
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |   2 +
> >  arch/arm64/include/asm/kvm_mmu.h  |   5 ++
> >  arch/arm64/kvm/mmu.c              | 115 ++++++++++++++++++++++++++++++
> >  3 files changed, 122 insertions(+)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 4add6c27251f..914c1b7bb3ad 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -125,6 +125,8 @@ struct kvm_arch {
> >  #define KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER	0
> >  	/* Memory Tagging Extension enabled for the guest */
> >  #define KVM_ARCH_FLAG_MTE_ENABLED			1
> > +	/* Gues has bought into the MMIO guard extension */
> > +#define KVM_ARCH_FLAG_MMIO_GUARD			2
> >  	unsigned long flags;
> >  
> >  	/*
> > diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> > index b52c5c4b9a3d..f6b8fc1671b3 100644
> > --- a/arch/arm64/include/asm/kvm_mmu.h
> > +++ b/arch/arm64/include/asm/kvm_mmu.h
> > @@ -170,6 +170,11 @@ phys_addr_t kvm_mmu_get_httbr(void);
> >  phys_addr_t kvm_get_idmap_vector(void);
> >  int kvm_mmu_init(u32 *hyp_va_bits);
> >  
> > +/* MMIO guard */
> > +bool kvm_install_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa);
> > +bool kvm_remove_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa);
> > +bool kvm_check_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa);
> > +
> >  static inline void *__kvm_vector_slot2addr(void *base,
> >  					   enum arm64_hyp_spectre_vector slot)
> >  {
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 3155c9e778f0..638827c8842b 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1120,6 +1120,121 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
> >  		kvm_set_pfn_accessed(pte_pfn(pte));
> >  }
> >  
> > +#define MMIO_NOTE	('M' << 24 | 'M' << 16 | 'I' << 8 | '0')
> 
> Although this made me smile, maybe we should carve up the bit space a bit
> more carefully ;) Also, you know somebody clever will "fix" that typo to
> 'O'!
> 
> Quentin, as the other user of this stuff at the moment, how do you see the
> annotation space being allocated? Feels like we should have some 'type'
> bits which decide how to parse the rest of the entry.

Yes, that's probably worth doing. I've been thinking about using fancy
data structures with bitfields and such, but none of that really seems
to bit a simpler approach. So how about we make the annotate() function
accept two arguments instead of one: an 'enum kvm_pte_inval_type type'
and 'u64 payload', and then we provide a static inline helper in
pgtable.h to unpack an invalid PTE into type/payload members? I'd guess
7 bits for the type should be more than enough and the payload can use
the rest.

Thoughts?

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
