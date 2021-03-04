Return-Path: <SRS0=dAAB=IC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94617C433DB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 15:49:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BBD6264F1C
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 15:49:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BBD6264F1C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 066544B3DB;
	Thu,  4 Mar 2021 10:49:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 01a-75ASd8b4; Thu,  4 Mar 2021 10:49:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B4974B3F0;
	Thu,  4 Mar 2021 10:49:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B7224B3DB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 10:49:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hWfPz1KlTJUz for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Mar 2021 10:49:09 -0500 (EST)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com
 [209.85.221.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2605D4B1F2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 10:49:09 -0500 (EST)
Received: by mail-wr1-f53.google.com with SMTP id f12so24376342wrx.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Mar 2021 07:49:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=LhGupbzdEthuR24ULnc5046PaiLJrBs+er9+oVApeFU=;
 b=EWHLHh+IyVUqUgAF4LFZSuMlY9wO0QpbQ806Aov0N14LnzY3kFNc0MBKZlNk0fMhBa
 7g4Vv/tUs3yoiKwACuE890DOhAPuphZYbSCPPuUaBxUgawsBJAdJTCBLXVzt5wVIYVUt
 zc8bT49uF5u2iGpc6PKcZNdkMzvNW6RSaF2yAKzUaTiHmSf1WpEgc5Yhp8f7q+4albDc
 nF4lron7w2kjGuZ+LtZ6whwHeQQrh6JNZcPXFeccx3iXxxUL7VHPFH6MEx27zPsugvH7
 ZyGHw9Tchk2qVIeN2zMA+sCqvgrf1e2fXQObBmKBSPKY2GJeESgGs+oXFyLQCjmcCF1l
 u3jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=LhGupbzdEthuR24ULnc5046PaiLJrBs+er9+oVApeFU=;
 b=fXmf9jQD/eC3FU4/g4cHuyEsIar4urE3k+chKFNjK0oLnfo4UJbz2Z00HLlSTf+A08
 j6yYwMhEH+sOTNW5yKiFreQQEIdH0jl0ZoT6d7GyxsCP588yO+HYUj1tga7lvUpgBRqJ
 E8IFYIwa0OjUZvSaprgGHby9KML8bNSwjni9vodChJL+WoqDjL5hmsw06dJ9iSOHBEDt
 kP+5U+JKF/kqIXzrvncj9/C43fqlzD1hXSH2qix4RegujwHHhMg7ZnHCopx8xnjh56b7
 Yq1izu3zayBvdwdXL1hfziklgkdn2m7Z14gJDH7OFZJ3NtvnQTcjUgpIP5YyUaPPEK/F
 z7Zw==
X-Gm-Message-State: AOAM531xaArfCj72WmDlSFf89sdY0APJYF2Mw5EmeT8ty6AXI0wJl88c
 VJ4RVNbwixe/w4K34vS/R+0IOw==
X-Google-Smtp-Source: ABdhPJwAMOHT+NpKRPC4qB1GLJVh8vLpTUsT2vC7aS+EbNwN1mBpqTrXaelCzUyIK9ZPcLvl/WPgqA==
X-Received: by 2002:adf:9bcf:: with SMTP id e15mr4631058wrc.276.1614872947974; 
 Thu, 04 Mar 2021 07:49:07 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id m10sm10074082wmh.13.2021.03.04.07.49.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 04 Mar 2021 07:49:07 -0800 (PST)
Date: Thu, 4 Mar 2021 15:49:05 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 12/32] KVM: arm64: Introduce a Hyp buddy page allocator
Message-ID: <YEEBccpDtnJJdwkJ@google.com>
References: <20210302150002.3685113-1-qperret@google.com>
 <20210302150002.3685113-13-qperret@google.com>
 <20210304153036.GA21507@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210304153036.GA21507@willie-the-truck>
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

On Thursday 04 Mar 2021 at 15:30:36 (+0000), Will Deacon wrote:
> On Tue, Mar 02, 2021 at 02:59:42PM +0000, Quentin Perret wrote:
> > +void *hyp_alloc_pages(struct hyp_pool *pool, unsigned int order)
> > +{
> > +	unsigned int i = order;
> > +	struct hyp_page *p;
> > +
> > +	hyp_spin_lock(&pool->lock);
> > +
> > +	/* Look for a high-enough-order page */
> > +	while (i < pool->max_order && list_empty(&pool->free_area[i]))
> > +		i++;
> > +	if (i >= pool->max_order) {
> > +		hyp_spin_unlock(&pool->lock);
> > +		return NULL;
> > +	}
> > +
> > +	/* Extract it from the tree at the right order */
> > +	p = list_first_entry(&pool->free_area[i], struct hyp_page, node);
> > +	p = __hyp_extract_page(pool, p, order);
> > +
> > +	hyp_spin_unlock(&pool->lock);
> > +	hyp_page_ref_inc(p);
> 
> I find this a little scary, as we momentarily drop the lock. It think
> it's ok because the reference count on the page must be 0 at this point,

Yep, @p shouldn't be visible to the caller yet so this should be fine.

> but actually then I think it would be clearer to have a
> hyp_page_ref_init() function which could take the lock, check that the
> refcount is indeed 0 and then set it to 1.

Works for me. Maybe I'll use another name for the API to stay consistent
with the kernel gfp code (hyp_page_ref_inc() and friends are inspired
from their kernel counterpart). And I guess I can hyp_panic() if the
refcount is not 0 at this point to match the VM_BUG_ON_PAGE() in
set_page_refcounted().

Thanks!
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
