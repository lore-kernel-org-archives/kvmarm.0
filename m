Return-Path: <SRS0=zOpf=C7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA77CC2D0E2
	for <kvmarm@archiver.kernel.org>; Tue, 22 Sep 2020 17:55:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0566523787
	for <kvmarm@archiver.kernel.org>; Tue, 22 Sep 2020 17:55:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="mpb3KRYs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0566523787
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50B6D4B3A5;
	Tue, 22 Sep 2020 13:55:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2kqLDjo4ZSZv; Tue, 22 Sep 2020 13:55:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C0524B3BD;
	Tue, 22 Sep 2020 13:55:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E3964B391
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 13:55:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B8SL+ROacd+z for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Sep 2020 13:55:05 -0400 (EDT)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 995664B2DA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 13:55:05 -0400 (EDT)
Received: by mail-wm1-f68.google.com with SMTP id b79so4248811wmb.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 10:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=qDuqWZC1VW8EQfRTwPy1SQY9Ugia7fQLlUkBJbJw2ug=;
 b=mpb3KRYsHGqaV+XbtgbH5xYHePKnUNApKF+8H80qUiSDOh2I7ZkW6cemtP/OqS4sfa
 O9qNFo6rYWvbfjngVHSQJtV39YfrqDBygii/bNyFKYK/QYQXRapOjGChdBZDONhoYCEw
 C+N5zK4PUScYEiO/iwfysMRi+n0SI+ghafp3hF+D0WgIhsd5ca9O2VlvYGUpdDa/xWY4
 +luI/GJNy0LTakzRhcTqnAbxtl2WCkWQNx/vkTpcb4n4t+vYOrtkcYzzAN+/OuBlOs4d
 HuyPtqS/sy82pht3gov8SpLOvtkriDaLFIXFKpyxddBR485hmSZbKMwY9tm6WQ7AYHm7
 u8/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=qDuqWZC1VW8EQfRTwPy1SQY9Ugia7fQLlUkBJbJw2ug=;
 b=QeGHm6VrgunSVAjqCZ7tx5/zTprqzMxCRgml7DcRL3Lr4IEVGJ1SOlOwq1lJKrnUOs
 zoe33HBOm76ckMygHCsV68Tzq5PsnqjX5TA1vvtzdJhYKCW/+Im7Flpq7d3wYsx4b5Hz
 yZOCJIiVcTR3LUDoOiHFMrfB1h/cqv2toWymdoyiP1z7sKhT1gZmE64DsbpDsdyX2GZY
 PtqytaRIRCsGAvUU7OoneuawbLhDBtTAgMtwlAHw7gQVFkxq3zFtKHf/BVqpT0m45/CO
 kwL/t0apW/cJiUAa+CMHd/QRwlKfXTdTMjzD/1EuXon66wYpj3o6UZm9frJD5/o4+T1S
 zSdA==
X-Gm-Message-State: AOAM5305MI86vNRTWnn/eVilK3516RO59fTyNE6ytrULnV8PCpdtbG1Y
 DUx2ETyWF3Tbj68gYnNnb6Evww==
X-Google-Smtp-Source: ABdhPJzolE/26FKJ6uSxzitqtAryO9MchyZJUE0K1lhB7o+h59fgvoQhUwPcnNYz9fEC4TwM5UIGgQ==
X-Received: by 2002:a7b:c958:: with SMTP id i24mr2379869wml.50.1600797304450; 
 Tue, 22 Sep 2020 10:55:04 -0700 (PDT)
Received: from google.com ([2a01:4b00:8523:2d03:55c2:2cdf:ff31:96a3])
 by smtp.gmail.com with ESMTPSA id q4sm26879934wru.65.2020.09.22.10.55.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 22 Sep 2020 10:55:03 -0700 (PDT)
Date: Tue, 22 Sep 2020 18:55:02 +0100
From: David Brazdil <dbrazdil@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 01/11] kvm: arm64: Partially link nVHE hyp code,
 simplify HYPCOPY
Message-ID: <20200922175205.6gacjibejr7mmbgw@google.com>
References: <20200916173439.32265-1-dbrazdil@google.com>
 <20200916173439.32265-2-dbrazdil@google.com>
 <20200918085116.GA30834@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200918085116.GA30834@willie-the-truck>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, kernel-team@android.com,
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

> > +#define HYP_SECTION_NAME(NAME)	.hyp##NAME
> > +
> > +/* Defines an ELF hyp section from input section @NAME and its subsections. */
> > +#define HYP_SECTION(NAME) \
> > +	HYP_SECTION_NAME(NAME) : { *(NAME NAME##.[0-9a-zA-Z_]*) }
> 
> I still don't get why we can't just use NAME ## .* for the regex here. That
> matches what we do elsewhere for linker script wildcarding, e.g. .rodata.*,
> .init.text.* ...  in asm-generic/vmlinux.lds.h. Why is it different for
> these sections?

Shouldn't matter. I copied it from a script in the Clang LTO branch. Will align
it with what's in the main arm64 script.

> > +# 2) Compile linker script.
> > +$(obj)/hyp.lds: $(src)/hyp.lds.S FORCE
> > +	$(call if_changed_dep,cpp_lds_S)
> 
> You need a .gitignore file listing hyp.lds, otherwise some idiot will end
> up committing it. I definitely didn't do that when playing around with this
> series. Nope. Not at all.

Thanks for noticing, I never compile in-tree. Added
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
