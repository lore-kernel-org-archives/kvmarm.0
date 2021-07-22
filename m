Return-Path: <SRS0=vB6B=MO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ED31C6377D
	for <kvmarm@archiver.kernel.org>; Thu, 22 Jul 2021 09:12:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B52F6610F7
	for <kvmarm@archiver.kernel.org>; Thu, 22 Jul 2021 09:12:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B52F6610F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23D4E4B0D5;
	Thu, 22 Jul 2021 05:12:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l6pN+ThDtcj1; Thu, 22 Jul 2021 05:12:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 385D84B0B1;
	Thu, 22 Jul 2021 05:12:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13E6D4B0B1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Jul 2021 05:12:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vnbGYSJPQ3QW for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Jul 2021 05:12:02 -0400 (EDT)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com
 [209.85.221.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B94754A4CD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Jul 2021 05:12:02 -0400 (EDT)
Received: by mail-wr1-f46.google.com with SMTP id m2so5142762wrq.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Jul 2021 02:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=NaNS9AMgRmwWpk7IwOuTN+Dqg/nfKEvds147rH9Tsw4=;
 b=ecOgwWM0pxO8mzTAh4/Y9NmnUmrXKIT5LaCzZ6YB70MqSZc0e2QHL4FSMP/Cs70w71
 Ur5QgKQQr5sD1sSbh/MO/Y1K1b3JmBpFyxtSX8JKjxNlzPtdQUIQFCtpPh4MgPMaNI9J
 6U6SnNmQQ2n+xayFQbhYElJ3CYfYnE2pkowTi2ZIsJM7lyiug/9KoE7fly4mp3uddkFW
 GNC496bmEs61CWvpFoFpFZmXdcQMUMP9MqRZYnmhYUG+IWztvLd2Kn3z01attIDw7zl1
 A6jjXrbGH/PXNwY93OuFBHFGKmxWI5l+QIRigCPrc5YLVDdDFo0ziiuYJa7DFXmruZx4
 BEYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=NaNS9AMgRmwWpk7IwOuTN+Dqg/nfKEvds147rH9Tsw4=;
 b=p6j8DuWmxPQYWgMjGRaeRBTDDP8hXkXs7eKWwO5S6t2Xm2b9v0OKPjQb39n/NXaG1Y
 0iTj5aq9I1ul2ev+38aGLaNiV0ip8kILYJf9sTXHOL67izvAQ1Eydcn9W6jRlIvKyPxD
 E49p5PPX13C5hilEOensD2Nbrs4g5dFPsxSeB8ejbaAuVrghO9CnfvDVh864gv2E89or
 vW95VWAm5fVusvq7Tr0CPudxQzzAYpe1lzCpzXxKhK8R2SEkc5Jw3VXKeefAfjmVxbgZ
 HNIUr3dzcECoxyl9/gdk5U+gRprt5vQgsgYEZiJu4RoGYwZxT8y82KFIUno9x9BTT4ng
 3m9Q==
X-Gm-Message-State: AOAM533B5TW+oTeyklIx5kYOa/9osMmcs0jEfbSbmfyq2y4qgWTg7d3U
 EHorR/1tNnbahJniJ6JzfoVjzw==
X-Google-Smtp-Source: ABdhPJyLWiHBnDA36VBmChvvNm3hWvX+VZpa3Rz7wOqMiZ8+/dewGGLnMKuFbyZcmEza8fsTByf6lg==
X-Received: by 2002:a5d:568a:: with SMTP id f10mr28245004wrv.293.1626945121506; 
 Thu, 22 Jul 2021 02:12:01 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:efb1:2fcc:e84:52ad])
 by smtp.gmail.com with ESMTPSA id f26sm24174882wmc.29.2021.07.22.02.12.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 22 Jul 2021 02:12:01 -0700 (PDT)
Date: Thu, 22 Jul 2021 10:11:58 +0100
From: Quentin Perret <qperret@google.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v2 3/3] kvm/arm: Align the VMID allocation with the arm64
 ASID one
Message-ID: <YPk2XqrOeP6dEtPL@google.com>
References: <20210616155606.2806-1-shameerali.kolothum.thodi@huawei.com>
 <20210616155606.2806-4-shameerali.kolothum.thodi@huawei.com>
 <20210721163138.GD11003@willie-the-truck>
 <f7d708704fb84380af85298a98f7a48c@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f7d708704fb84380af85298a98f7a48c@huawei.com>
Cc: "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Linuxarm <linuxarm@huawei.com>, "maz@kernel.org" <maz@kernel.org>,
 Will Deacon <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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

On Thursday 22 Jul 2021 at 06:45:14 (+0000), Shameerali Kolothum Thodi wrote:
> > From: Will Deacon [mailto:will@kernel.org]
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > index 4b60c0056c04..a02c4877a055 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > @@ -106,8 +106,7 @@ int kvm_host_prepare_stage2(void *mem_pgt_pool,
> > void *dev_pgt_pool)
> > >  	mmu->pgd_phys = __hyp_pa(host_kvm.pgt.pgd);
> > >  	mmu->arch = &host_kvm.arch;
> > >  	mmu->pgt = &host_kvm.pgt;
> > > -	mmu->vmid.vmid_gen = 0;
> > > -	mmu->vmid.vmid = 0;
> > > +	atomic64_set(&mmu->vmid.id, 0);
> > 
> > I think this is the first atomic64 use in the EL2 object, which may pull in
> > some fatal KCSAN instrumentation. Quentin, have you run into this before?
> > 
> > Might be simple just to zero-initialise mmu for now, if it isn't already.
> 
> I will check that.

Yes I think what saves us here is that, AFAICT. arm64 doesn't support
KCSAN yet. But the day it does, this should fail to link (hopefully)
because of out-of-line calls into e.g. __kasan_check_write().

So yes, a simple zeroing here is probably preferable.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
