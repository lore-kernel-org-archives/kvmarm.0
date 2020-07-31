Return-Path: <SRS0=F5E6=BK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C79A6C433E1
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 08:19:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5028421883
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 08:19:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="HKkCROCg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5028421883
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2A7D4B3D6;
	Fri, 31 Jul 2020 04:19:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W2iak+k8h6CQ; Fri, 31 Jul 2020 04:19:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E67C54B464;
	Fri, 31 Jul 2020 04:19:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BF584B3D4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 04:19:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nZQf0r3R0I7q for <kvmarm@lists.cs.columbia.edu>;
 Fri, 31 Jul 2020 04:19:17 -0400 (EDT)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F3FF74B3D6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 04:19:16 -0400 (EDT)
Received: by mail-wm1-f67.google.com with SMTP id d190so7804303wmd.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 01:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Q8OpMiJ+z4ZHwmpiATogVeChudpSi8OJUrMWzrMdEXE=;
 b=HKkCROCgWVfB5Zs1f7eEF5gOlL3UGVnCFzaPZgvCjZAgU2+U3MHRKopkOrVZeyR3vf
 vjudcrXjbLvmNlu7/eZbioHE81Ouw2sKkbTh/Kj9d0qisV8UZIamJehMXRAEKBhfP0yJ
 o2WEioVtsuTNBdPDxVhLkq/4iWGa4i8OhZO8zvrv2Al+dBmSxBDj+LRKycrsrooeLEFT
 gCw+E9gzfz5m/00SouG06jEsh+F5Wvse1G1rUJ1lHsFBEr41wEZV+RNxptyA5W2TgVvl
 6abSqymXPVo+6IRpqlLE0W5xc/txiifofJQasl9SzvsE8/apY7eqtw0ejGSS6/IvlOqB
 tKeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Q8OpMiJ+z4ZHwmpiATogVeChudpSi8OJUrMWzrMdEXE=;
 b=G6ic/GjRAk2aHLWYlasZzTt/iiDZPAYsx6NFPTaW+JLZArXkY/jNS9w+2ATs4CXiFd
 eAGhfw0bXklcDgBnBrmHKjZGZ+rbPlFbbXgAxy9lThukc07jgRBaV3M7oOoZC0u0edbV
 KQ8By3A3cNz5eHr3Lqb6SiTszNzXR4XjakCUnkppZtRVlCyyUGMMqPEldEQXKK5KHWHu
 odZBzIdQ5+m3WTpHcJ/rzF5MSojlFl0EKpyBAg01rnNIOIgzOKYAMMjpj17EnJrbQdhM
 I6geoAikswcWZumnmc8wHxE9sNm6vUJF1eNs1Y18uXgO++LPCQSxbjHegER7RR+feNmw
 SFyA==
X-Gm-Message-State: AOAM530oAQCVbQrHxhjVDwluztVF3qqrYYiaWUpJHEJg6CNP7E4FFth+
 vuie+YvuOUvMURoAw+UhYZFfpw==
X-Google-Smtp-Source: ABdhPJw2xNbOV3xC63XD4TJSfkwYZDWWkbXBDvb97fYK764gELmnXWQ3+iN4lpi1f/3Ln4sCAR25GQ==
X-Received: by 2002:a7b:cf0c:: with SMTP id l12mr2884769wmg.77.1596183555084; 
 Fri, 31 Jul 2020 01:19:15 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:110:f693:9fff:fef4:a7ef])
 by smtp.gmail.com with ESMTPSA id g16sm12171266wrs.88.2020.07.31.01.19.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 31 Jul 2020 01:19:14 -0700 (PDT)
Date: Fri, 31 Jul 2020 09:19:11 +0100
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH 02/20] KVM: arm64: Add support for creating
 kernel-agnostic stage-1 page tables
Message-ID: <20200731081911.GB3201636@google.com>
References: <20200730153406.25136-1-will@kernel.org>
 <20200730153406.25136-3-will@kernel.org>
 <20200731081436.GA3201636@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200731081436.GA3201636@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On Friday 31 Jul 2020 at 09:14:36 (+0100), Quentin Perret wrote:
> Hey Will,
> 
> On Thursday 30 Jul 2020 at 16:33:48 (+0100), Will Deacon wrote:
> > +void *kvm_pgtable_hyp_alloc_cookie(u32 va_bits)
> > +{
> > +	struct kvm_pgtable *pgt = kzalloc(sizeof(*pgt), GFP_KERNEL);
> > +
> > +	if (!pgt)
> > +		return NULL;
> > +
> > +	pgt->ia_bits = va_bits;
> > +	pgt->start_level = kvm_start_level(va_bits);
> > +
> > +	pgt->pgd = (kvm_pte_t *)get_zeroed_page(GFP_KERNEL);
> > +	if (!pgt->pgd) {
> > +		kfree(pgt);
> > +		pgt = NULL;
> > +	}
> > +
> > +	return pgt;
> > +}
> > +
> > +static int hyp_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> > +			   enum kvm_pgtable_walk_flags flag, void * const arg)
> > +{
> > +	free_page((unsigned long)kvm_pte_follow(*ptep));
> > +	return 0;
> > +}
> > +
> > +void kvm_pgtable_hyp_free_cookie(void *cookie)
> > +{
> > +	size_t pgd_sz;
> > +	struct kvm_pgtable *pgt = cookie;
> > +	struct kvm_pgtable_walker walker = {
> > +		.cb	= hyp_free_walker,
> > +		.flags	= KVM_PGTABLE_WALK_TABLE_POST,
> > +	};
> > +
> > +	if (kvm_pgtable_walk(cookie, 0, BIT(pgt->ia_bits), &walker))
> > +		kvm_err("Failed to free page-table pages\n");
> > +
> > +	pgd_sz = kvm_pgd_pages(pgt) * PAGE_SIZE;
> > +	free_pages_exact(pgt->pgd, pgd_sz);
> 
> Given that the pgd is unconditionally a single page for the stage 1 case
> (as per kvm_pgtable_hyp_alloc_cookie() above), should we simplify this
> to a simple free_page()? Or did you want to factorize this with the
> stage 2 free path?

Hmm, or maybe it's the alloc() path that needs fixing actually ...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
