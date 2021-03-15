Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 434EDC433E0
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 16:53:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9D83364F36
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 16:53:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D83364F36
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00FC14B659;
	Mon, 15 Mar 2021 12:53:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ak5TtrW2RqIm; Mon, 15 Mar 2021 12:53:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1CEF4B622;
	Mon, 15 Mar 2021 12:53:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFFD84B5E9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 12:53:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CepeWf-SP7zK for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 12:53:22 -0400 (EDT)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com
 [209.85.128.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8D9AA4B5B8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 12:53:22 -0400 (EDT)
Received: by mail-wm1-f50.google.com with SMTP id
 m20-20020a7bcb940000b029010cab7e5a9fso20685225wmi.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 09:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=8jtK4LvHkQIstlrA5wZLxNvqJwLdyrOtIEuLebCwaq4=;
 b=gzyooPr/RXjEiOoZImRlh/c4wGsriorODrbvY7BTIMjGIhjq4kfsyJ2yVtFCBuzuAn
 j5bh7TXHhr736yFDkanUNL0+cANtSiwUSsO2SeJDXlOSqPzqDUY+C680a4s9L/10R6av
 xC7ngG6hErYLUCNHi7rRrY+6hi2OZR8jKUNd+He5swRuREZ1qpz5Hy7w94k6C1k8CGc0
 JPFP6RNl7DHjOYhI0NxQ9TxXSHvNYjzSaKZN8y1shjslUL+rrzWFUrePgvUtmrmxZELP
 RfwHJFHGqZx9d4V2qG+XFuAMTHPdbmIvepOCSlZEkTCyKSgguFqeAUv3/s0Cq9lmlxp/
 bOjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=8jtK4LvHkQIstlrA5wZLxNvqJwLdyrOtIEuLebCwaq4=;
 b=CwnBlXLl7aJ8Ur4auVmevxuMN+2zW+4twFITX9wDx8n08A2peRUBqD3AVUANZBKCfb
 TCV/ynR7PNicTvF6JmwhCHDK6xFnBWJInj/GrGj8MDePPb5QmU/v5+7uN4K78lr+4E6L
 IUgXUpYTO1gdPW2q9LVLejCdPAyMVbPWGgsJa8X6BUY1ZondQbP46Q445Qym8zmUf2hS
 fnchsVuc9y8LqhKwyTTrb1wMNRGMMvjlipIgIQ7spZFuxXZsglDzjBegRvmGSyc/LyDb
 S/DpGsCmyNk01PftuNuGcvoXTBmad2JgpuFXATYnhPn0NF6ooosXjD3VUtWSVrIEcbLv
 Yduw==
X-Gm-Message-State: AOAM532l+lIZ3T/fiPbDP5E/Q7SXqnQDL5dn2tKKqGzbuJuiECsAi5hb
 ln4FubaQRr7Dcpgh0H+E5LLgdA==
X-Google-Smtp-Source: ABdhPJzyCUjEeIdn7MkxvV/Kzfaapb7kOKbdOTz0f/wFjhROoS2sYscMCclWPUTXv0qdQaa+Htk3kQ==
X-Received: by 2002:a1c:6707:: with SMTP id b7mr563679wmc.185.1615827201290;
 Mon, 15 Mar 2021 09:53:21 -0700 (PDT)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id j6sm218657wmq.16.2021.03.15.09.53.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 15 Mar 2021 09:53:20 -0700 (PDT)
Date: Mon, 15 Mar 2021 16:53:18 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 29/36] KVM: arm64: Use page-table to track page
 ownership
Message-ID: <YE+Q/vFpSaAO5vZS@google.com>
References: <20210315143536.214621-1-qperret@google.com>
 <20210315143536.214621-30-qperret@google.com>
 <20210315163618.GF3430@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210315163618.GF3430@willie-the-truck>
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

On Monday 15 Mar 2021 at 16:36:19 (+0000), Will Deacon wrote:
> On Mon, Mar 15, 2021 at 02:35:29PM +0000, Quentin Perret wrote:
> > As the host stage 2 will be identity mapped, all the .hyp memory regions
> > and/or memory pages donated to protected guestis will have to marked
> > invalid in the host stage 2 page-table. At the same time, the hypervisor
> > will need a way to track the ownership of each physical page to ensure
> > memory sharing or donation between entities (host, guests, hypervisor) is
> > legal.
> > 
> > In order to enable this tracking at EL2, let's use the host stage 2
> > page-table itself. The idea is to use the top bits of invalid mappings
> > to store the unique identifier of the page owner. The page-table owner
> > (the host) gets identifier 0 such that, at boot time, it owns the entire
> > IPA space as the pgd starts zeroed.
> > 
> > Provide kvm_pgtable_stage2_set_owner() which allows to modify the
> > ownership of pages in the host stage 2. It re-uses most of the map()
> > logic, but ends up creating invalid mappings instead. This impacts
> > how we do refcount as we now need to count invalid mappings when they
> > are used for ownership tracking.
> > 
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h |  21 +++++
> >  arch/arm64/kvm/hyp/pgtable.c         | 127 ++++++++++++++++++++++-----
> >  2 files changed, 124 insertions(+), 24 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 4ae19247837b..683e96abdc24 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -238,6 +238,27 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
> >  			   u64 phys, enum kvm_pgtable_prot prot,
> >  			   void *mc);
> >  
> > +/**
> > + * kvm_pgtable_stage2_set_owner() - Annotate invalid mappings with metadata
> > + *				    encoding the ownership of a page in the
> > + *				    IPA space.
> 
> The function does more than this, though, as it will also go ahead and unmap
> existing valid mappings which I think should be mentioned here, no?

Right, I see why you mean. How about:

'Unmap and annotate pages in the IPA space to track ownership'

> > +int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > +				 void *mc, u8 owner_id)
> > +{
> > +	int ret;
> > +	struct stage2_map_data map_data = {
> > +		.phys		= KVM_PHYS_INVALID,
> > +		.mmu		= pgt->mmu,
> > +		.memcache	= mc,
> > +		.mm_ops		= pgt->mm_ops,
> > +		.owner_id	= owner_id,
> > +	};
> > +	struct kvm_pgtable_walker walker = {
> > +		.cb		= stage2_map_walker,
> > +		.flags		= KVM_PGTABLE_WALK_TABLE_PRE |
> > +				  KVM_PGTABLE_WALK_LEAF |
> > +				  KVM_PGTABLE_WALK_TABLE_POST,
> > +		.arg		= &map_data,
> > +	};
> > +
> > +	if (owner_id > KVM_MAX_OWNER_ID)
> > +		return -EINVAL;
> > +
> > +	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
> > +	dsb(ishst);
> 
> Why is the DSB needed here? afaict, we only ever unmap a valid entry (which
> will have a DSB as part of the TLBI sequence) or we update the owner for an
> existing invalid entry, in which case the walker doesn't care.

Indeed, that is now unnecessary. I'll remove it.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
