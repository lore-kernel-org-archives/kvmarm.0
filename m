Return-Path: <SRS0=wPN+=FL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45A1BC433FE
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 14:11:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A5AC6235F9
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 14:11:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5AC6235F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE1014B269;
	Mon,  7 Dec 2020 09:11:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YlvNX4qLxxbN; Mon,  7 Dec 2020 09:11:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 045344B27F;
	Mon,  7 Dec 2020 09:11:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C28434B25E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 09:11:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3vIhZmtaJEGW for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2020 09:11:28 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 991B04B137
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 09:11:28 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id a12so6099863wrv.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Dec 2020 06:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=kIglN2ENPr7zZxCKU9K9FdFhtb6JGzaE8AjsYQ4PtZ4=;
 b=Xhc60KBVbnArBSefinJI+TleN6X7aSEsNC0tQlYENBG2ZPPq9HpuIQyl0v3s77lz4d
 NaMMqkGUk2Y6w0tvbOkQAG1I6KgVd7yT8Wffq4xZm8NRs0HSBoivHZie/1RGmt2n3epv
 FWlxQlQGrjPu/b46XKseWpoWCCzY5a8gSoyHbAKyk7rvq6JkalR11VCCD+mz9yo/uYLt
 /GNmeSpjO/bd11ul7t0LgHnVA+wEfaLMtlihFIarwy5Cyr5nU64+sqY0OE8VOWKzZlX0
 3JRdkzVznY/XSjGX9AlOwFk42GHr6PPa4BxCms3CvL/Valg4Rg86Mypisvmqg2JBHR3o
 XV0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=kIglN2ENPr7zZxCKU9K9FdFhtb6JGzaE8AjsYQ4PtZ4=;
 b=t50Y2lojmlBJMRaJZ6x45y+BUBdI4L3mfvLej7LvZDJ4VF8/CCYz6H/KgW/yuu77AZ
 FiOp6+yozKp06yfKweXZHI8MnPAHs/aujMnmwj7NOLTZRrBK4xAmIXx/xLrxnN1LY7cf
 MvKMNU0CzXAWnq+jGY7b9DyXpSMQ0660TM53ak9kOWFnQ6Wozr/xmt1/prAbX65RQKRS
 TbSH0DlmxiJUN3WFpP7+PhJk+tnAx0EbMixh3jE+YuAkUqsPM7K/SHy9VCMlG4JRyYG4
 qr4tQoQ66vmq1y6fAZyASdOwXZ0+7jsJxIVKNom2LUYPQk0Iq6iv+VmaVen3ldTkT78Y
 GsGw==
X-Gm-Message-State: AOAM533QkJWnHTF3Wgeh9AJzGlMEgJ4v1vOC4vcroxRfPuqMrNPF5gCp
 MwjHJdyFHdFtLDjka5z6D07JHQ==
X-Google-Smtp-Source: ABdhPJwy02g4n9Bw93wn8robHfmfXCvn8HmKD427RxXtDweC+OQzf6Bi6J3mgHqERGzkgRm3qn05dQ==
X-Received: by 2002:adf:fdc7:: with SMTP id i7mr17832777wrs.398.1607350287293; 
 Mon, 07 Dec 2020 06:11:27 -0800 (PST)
Received: from google.com ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 by smtp.gmail.com with ESMTPSA id z2sm3072994wml.23.2020.12.07.06.11.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Dec 2020 06:11:26 -0800 (PST)
Date: Mon, 7 Dec 2020 14:11:20 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH 16/27] KVM: arm64: Prepare Hyp memory protection
Message-ID: <X844CBNCTL4XT3iq@google.com>
References: <20201117181607.1761516-1-qperret@google.com>
 <20201117181607.1761516-17-qperret@google.com>
 <20201207134052.GA4563@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201207134052.GA4563@willie-the-truck>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, kernel-team@android.com, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>,
 open list <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>,
 Frank Rowand <frowand.list@gmail.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>
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

On Monday 07 Dec 2020 at 13:40:52 (+0000), Will Deacon wrote:
> Why not use the RESERVEDMEM_OF_DECLARE() interface for the hypervisor
> memory? That way, the hypervisor memory can either be statically partitioned
> as a carveout or allocated dynamically for us -- we wouldn't need to care.

Yup, I did consider that, but the actual amount of memory we need to
reserve for the hypervisor depends on things such as the size of struct
hyp_page, which depends on the kernel you're running (that is, it might
change over time). So, that really felt like something the kernel should
be doing, to keep the DT backward compatible, ... Or did you have
something more elaborate in mind?

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
