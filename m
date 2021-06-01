Return-Path: <SRS0=w8eh=K3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9DDCC47093
	for <kvmarm@archiver.kernel.org>; Tue,  1 Jun 2021 13:31:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 51E3F613CB
	for <kvmarm@archiver.kernel.org>; Tue,  1 Jun 2021 13:31:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 51E3F613CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2CE049FB0;
	Tue,  1 Jun 2021 09:31:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tgeAeqo0UbnT; Tue,  1 Jun 2021 09:31:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E202B49E93;
	Tue,  1 Jun 2021 09:31:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B62C149E5F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Jun 2021 09:31:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EMhh+QfMbwaf for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Jun 2021 09:31:11 -0400 (EDT)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com
 [209.85.221.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 73B0C49E57
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Jun 2021 09:31:11 -0400 (EDT)
Received: by mail-wr1-f43.google.com with SMTP id q5so14340358wrs.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Jun 2021 06:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=ceM+pzGaASjItNNpKWFEaDd0DaKnxYhb/K4oaZ7JsPI=;
 b=LP2fsEvMTFs8wSLGgZY1ubi1BD83fbQR+WWGlnKbnhrJzkcoYhZUlw/ZkFPHVRX2pS
 1kxI8JgLhb0g3kz0pGI8o3ABqCJYAa0imQmWdnz1EWZGapSxVVG0FE8I2m7eCNFp+FhJ
 LX0uC4VCrnahVcOZ/Fet/aQm0qdopbZL6zqs2RlZqUjc4xKX7utUPhIEuwzdWLNG7IVz
 ++liR5Sn4WQaIdIQG2oJDi6hnggLc2WP6sfG4+RcODkWpixbjWvXjXfdGBeUfjYhoY1y
 DhzTNVl41otb4rKKFkL85f8end5tGK+CpDfjGjCeZ4NEEnEvWdsyM8i67qe/y/1t0Wyt
 kmQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ceM+pzGaASjItNNpKWFEaDd0DaKnxYhb/K4oaZ7JsPI=;
 b=AlDSbaVEaxiVAzOFxU1TBG27P0ZD9V6J93cNgj1w+6oXC541SYrDFHR+3f1Yqrlqpb
 o+r4sbHH0lyxzvmduLAALGm/q5UarORpIXDKrQvTx6g1AWWkxefiLQ7iNCoceqifSMUJ
 NvOekVw5LjAne8jVWsi9ebVC3WeBgdey/+K9aoAsahvxECTU7P9K/TQBx1pwVl+jMQdJ
 sVwjSFVCdMHtDe8Y0UvYUlOFqakg07kxBoLOfYUS7xJ7u8LrZilvyNmhz8rwliiWSTFP
 C9ClU1rQqkVBtQCglMp/YeW6P63UTggtHfNe+BH6B0XGLy9tged+DZ2DFCk+4k/kGEQC
 OocA==
X-Gm-Message-State: AOAM53144c2fpHydqfnnT2M2FmJyRVty9u1xOMLkRV9YcrE7zCd3+bGa
 EhMS/MIJtPRVqmKxvdDeE7aUEA==
X-Google-Smtp-Source: ABdhPJwkD2HduO0uUirxMSgy26JktuDamd44LHDyKx90TnuHOIIZTT9Fv/kzeN7mfG9dVVkN7NVWOg==
X-Received: by 2002:a5d:4003:: with SMTP id n3mr27693980wrp.173.1622554270083; 
 Tue, 01 Jun 2021 06:31:10 -0700 (PDT)
Received: from google.com (105.168.195.35.bc.googleusercontent.com.
 [35.195.168.105])
 by smtp.gmail.com with ESMTPSA id w13sm490487wmi.4.2021.06.01.06.31.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 01 Jun 2021 06:31:09 -0700 (PDT)
Date: Tue, 1 Jun 2021 13:31:06 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/7] KVM: arm64: Move hyp_pool locking out of refcount
 helpers
Message-ID: <YLY2mjxGCSyunnhV@google.com>
References: <20210527125134.2116404-1-qperret@google.com>
 <20210527125134.2116404-2-qperret@google.com>
 <87sg2123pj.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87sg2123pj.wl-maz@kernel.org>
Cc: kernel-team@android.com, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Tuesday 01 Jun 2021 at 13:02:00 (+0100), Marc Zyngier wrote:
> On Thu, 27 May 2021 13:51:28 +0100,
> Quentin Perret <qperret@google.com> wrote:
> > 
> > The hyp_page refcount helpers currently rely on the hyp_pool lock for
> > serialization. However, this means the refcounts can't be changed from
> > the buddy allocator core as it already holds the lock, which means pages
> > have to go through odd transient states.
> > 
> > For example, when a page is freed, its refcount is set to 0, and the
> > lock is transiently released before the page can be attached to a free
> > list in the buddy tree. This is currently harmless as the allocator
> > checks the list node of each page to see if it is available for
> > allocation or not, but it means the page refcount can't be trusted to
> > represent the state of the page even if the pool lock is held.
> > 
> > In order to fix this, remove the pool locking from the refcount helpers,
> > and move all the logic to the buddy allocator. This will simplify the
> > removal of the list node from struct hyp_page in a later patch.
> 
> Is there any chance some documentation could be added so that we have
> a record of what the locking boundaries are? Something along the line
> of what we have in arch/arm64/kvm/vgic/vgic.c, for example.

Sounds like a good idea, I'll go write something.

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
