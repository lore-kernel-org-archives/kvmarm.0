Return-Path: <SRS0=x+jN=ER=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FD94C56201
	for <kvmarm@archiver.kernel.org>; Wed, 11 Nov 2020 11:31:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 60268207BB
	for <kvmarm@archiver.kernel.org>; Wed, 11 Nov 2020 11:31:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="QU5fxZrG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 60268207BB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 871014B7D7;
	Wed, 11 Nov 2020 06:31:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2MSVeTGBJCsV; Wed, 11 Nov 2020 06:31:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FBEF4B7C9;
	Wed, 11 Nov 2020 06:31:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA9184B7BA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Nov 2020 06:31:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ehl8mjVOVlZL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Nov 2020 06:31:50 -0500 (EST)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
 [209.85.221.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BD96E4B7B9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Nov 2020 06:31:50 -0500 (EST)
Received: by mail-wr1-f42.google.com with SMTP id r17so2217666wrw.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Nov 2020 03:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=U9WY4YwHoHsiLnMTjdtJfngq4inlaDzEyXm6ZeBp3Tk=;
 b=QU5fxZrGw6uKul6IuPlDVukJDFf/9w8mjopTg92s3jOuwPNLG2hAfJAdvlF9fg/Jz3
 iLmd8sMlfvwdFCY4C8OrmeUQb4J5rvRMcHgbwQUcWNKZO3sct8Ge+6GCLmXLBfS/XF4X
 Yq7XWiwRPbpZsxvUo/W3+ZIn/9Eiyd1KNe9EHHTbSeoKl8JHJv5nmFUofGid71w3ZjDm
 hjuWawWuTkiix/v2wCtK1tyemtdfp4wJSL6firAUZYMqDWHy/hR7079/G4y3PBHy88N+
 JJmPLFpPmjmsRb8YLdMt29Jt85/lzFMhMxuy3e9vb8ZK24eTRWuFhSko+r2BsdY9gikK
 TJqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=U9WY4YwHoHsiLnMTjdtJfngq4inlaDzEyXm6ZeBp3Tk=;
 b=CqzP0zxw0p5u6u4IFOnag+RaKrJymxqkEiHUHVQoH2vjlZ5A6OB9IMeU1Xm16Opx9z
 9tXqwVmx6HkRWpf5bPnncEMsuFnpAg5TXDhDsQPeccx2WzdugROWj9LMvAC5SyySp/OB
 i/93OlKL0Pdts5/HztE0knXyyBSYHEMc72PwsIZ97L1muhlRzCCOb91dHlDiWBGIL0VA
 R6c+iGAghgNJ/zIQRFGcbw40ZtlTzw65qxwNeB4WOtA9fHampBFp5C61i7mCU+/jAXNJ
 HUKDYnB4YrEGyBdUeiMl4iw1CiQ+Cf5cPIXirkM0n+ULE96GOG0c3dLkIyqOdAQO2nJj
 bI1g==
X-Gm-Message-State: AOAM532gRDZf7+SObAo+TiV1xmv95OSaunb9N2d6+zIOfnwCv/cI9le9
 aIQRRLsAW4YFzaBOVd5g7XKCLw==
X-Google-Smtp-Source: ABdhPJxdgoPMtvIpc8ik98fEm9DP705DkNY3XXFbPwfG7LegNZBJtunQHwh7cI5tVfwKzEHEOdLISA==
X-Received: by 2002:adf:f3d1:: with SMTP id g17mr30133095wrp.156.1605094309513; 
 Wed, 11 Nov 2020 03:31:49 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:2595:ed05:1717:fe6e])
 by smtp.gmail.com with ESMTPSA id c17sm2213099wml.14.2020.11.11.03.31.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 11 Nov 2020 03:31:48 -0800 (PST)
Date: Wed, 11 Nov 2020 11:31:47 +0000
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v1 01/24] psci: Accessor for configured PSCI version
Message-ID: <20201111113147.ddoqadqaw6hcukow@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
 <20201109113233.9012-2-dbrazdil@google.com>
 <ba9c8ccf25ff82b834ab78930570b993@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ba9c8ccf25ff82b834ab78930570b993@kernel.org>
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

> > +
> >  struct psci_operations {
> >  	u32 (*get_version)(void);
> >  	int (*cpu_suspend)(u32 state, unsigned long entry_point);
> 
> I still maintain that populating .get_version in all cases instead of
> duplicating an existing functionality is a better outcome. PSCI not
> supported would be implied by .get_version being NULL.
> 
> What breaks?

Must have missed that suggestion before. Good idea, I'll do that.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
