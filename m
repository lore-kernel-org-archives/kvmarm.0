Return-Path: <SRS0=cLXx=CZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D74C433E2
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 13:35:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BEB5F222B8
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 13:35:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="OpOeI24L"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BEB5F222B8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DBEE64B470;
	Wed, 16 Sep 2020 09:35:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z-Yr+Af0l3rl; Wed, 16 Sep 2020 09:35:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 043B44B478;
	Wed, 16 Sep 2020 09:35:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E449A4B46A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 09:35:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CvHZ4VD+pi+Y for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Sep 2020 09:35:07 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BB4C84B45C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 09:35:07 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id s12so6913981wrw.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 06:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Y0GHMsQrfoNkF8hoL5Nxc0+CH+Sz1FlZ4J0DpK8dO70=;
 b=OpOeI24LEAE+oDQATH8MdVWdt4mZNQ4qh1Hc0omlnt7RwHiPRKvJrLL01717FgPnnb
 1t+n+B6+mnQxwsOhc5OfAHt9THe5P9ok+08CnWZwgPJLemA4xraL3S0LRRaUFrd0nuU7
 yRKZjwxGHu2Xcb4i1Mdyqj+a2bvB9eJzXsEOa3kbquHPZTCRLg6PiXODmEUA6N/ezqtH
 WrdIqnvo6yMjPIgfbcKtYQzcIktY+hY7v3S3aaNBZGh1xFeC7rDf3IQUoCoKX+3JD4qH
 ShFWfgA8F0+G1Or4c6EbK0e67x7FvsJI33FROdF/TI1M6+2DETeMlQ74rxZgNY5SadWE
 gcLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Y0GHMsQrfoNkF8hoL5Nxc0+CH+Sz1FlZ4J0DpK8dO70=;
 b=ujKrJx/LLuu3nOiEpiZzKNUwzebn18g9oADWPmvNmRhsZ3IXkf0aItXkbfqHb1y+zq
 PY4EH8k0DfdIUo+JDey/1Qmw76gXRHWtqqHBvHdYge353gr4EiVq4asWMiPaGrsgk95r
 r0ybbInBmP+6ITrL7MX31pBj8HOGKK36kGtL+89Z6ndQa5iotQLGWi/WGsjkoUWFxs2W
 CgUmNRd8h8/BaCkEttzbnaJblOhrBIyREmWju/cnS2rlPjqxJx4/qoI0bi84bgwbOyGJ
 nkHuO0av34dr6lLCI0LtVEmBBHkOi31ECW1IG6nYsVvGSzRRCuBhep3ZmXKo5w8l9Gns
 upXg==
X-Gm-Message-State: AOAM532CJQwSoXAxnRFKRe4pmwaDmXt2c5BVl5CT4Oh2WN/Z98PTGiJ8
 ENP6zmhEjJi0W3F2nP+l/ZcZnQ==
X-Google-Smtp-Source: ABdhPJxj1njKOkMy/uGBtiswR54WhjIWwVc4v6yTTlieFUIM6NmtAP4wvPkgHYBaLSDHrvMxwMPqPg==
X-Received: by 2002:a5d:45cc:: with SMTP id b12mr4416951wrs.395.1600263306480; 
 Wed, 16 Sep 2020 06:35:06 -0700 (PDT)
Received: from google.com ([2a01:4b00:8523:2d03:e49d:f6be:d31b:ad3c])
 by smtp.gmail.com with ESMTPSA id v9sm37780715wrv.35.2020.09.16.06.35.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Sep 2020 06:35:05 -0700 (PDT)
Date: Wed, 16 Sep 2020 14:35:04 +0100
From: David Brazdil <dbrazdil@google.com>
To: Andrew Scull <ascull@google.com>
Subject: Re: [PATCH v2 10/10] kvm: arm64: Remove unnecessary hyp mappings
Message-ID: <20200916133504.7v5j7y5ccajw2a7s@google.com>
References: <20200903091712.46456-1-dbrazdil@google.com>
 <20200903091712.46456-11-dbrazdil@google.com>
 <20200910140738.GE93664@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200910140738.GE93664@google.com>
Cc: linux-arch@vger.kernel.org, kernel-team@android.com,
 Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

> > +	for_each_possible_cpu(cpu)
> > +		*(per_cpu_ptr_nvhe(arm64_ssbd_callback_required, cpu)) =
> > +			per_cpu(arm64_ssbd_callback_required, cpu);
> 
> Careful with breaking allocations across lines, that seems to be taboo
> in this subsystem.

Happy to put the `ptr` var back. Sorry *embarrassed emoji*.

Thanks for reviewing,
David
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
