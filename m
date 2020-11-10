Return-Path: <SRS0=+U1N=EQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F131C4742C
	for <kvmarm@archiver.kernel.org>; Tue, 10 Nov 2020 13:00:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B62C320679
	for <kvmarm@archiver.kernel.org>; Tue, 10 Nov 2020 13:00:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="rmy95vdp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B62C320679
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BAEFE4B94A;
	Tue, 10 Nov 2020 08:00:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xF7BY8m+hg3W; Tue, 10 Nov 2020 08:00:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9083A4B8C5;
	Tue, 10 Nov 2020 08:00:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 209674B8BC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 08:00:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id geejT9moHJNl for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Nov 2020 08:00:53 -0500 (EST)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 15C784B610
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 08:00:53 -0500 (EST)
Received: by mail-wm1-f67.google.com with SMTP id h62so2908563wme.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 05:00:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=ybTfB3rMzNb3Par8rFjgeakZunYZuUZMKJ+Bmz10zcI=;
 b=rmy95vdpdJpdRJEwkEsHwMF2i7Fz09alyS8dBJCzhsq01cijLN8w5esY1ZgkK53FPV
 cSZVG2U0tVWBNACNlF4zAsr53awUP6kvc6EZeub8DlRiqt0DTC+er4HbV1uCeFqiPJ99
 sdFZIsB5B5pl9ED/FsK6NiGe8gsyiW3UxBWgelUOXa/7zqTNhBVRwaNK7nxhA8Gatkxn
 /+OTNzRCmv/uOkcMA5ccEW7f2IWVHoQ1rtZhE6udkHHOnDKmCgXe09q0K1/KcOtILr8t
 KmIvz9YQTbrKfjAl+ynn6ylt/s2TIDhpXNSm3OUNTj+K4rN6JazdW82/S48+Lx5HrrIn
 7q3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ybTfB3rMzNb3Par8rFjgeakZunYZuUZMKJ+Bmz10zcI=;
 b=q6wdxV1sZ2Iok3kBVgmoFbV0Q8fpks49+eZEzriUL2GSRWH/J9dk82+R3oF2q8hlXu
 PS7CF2dntUkMEdTm2fdWVv8TLih0+LYMENlJUXsbsK16jWR8RJ+KQP1C4CqLB1BO+c0J
 5F0n9J1i2OM5kDO16tuznBBfjBAV8UPIKxUyDeU6gZEPoP6K7V3ZKPiz8odWysB0Zj6q
 JIWHDASbYt8ll4OnpdFv4uRsKIon+13t+H1QRtXDYa4p0qBh/gYEGzX6RyFLfslAeJ1a
 Bm9+AYW05F1baCSFfJVZRnLH1q95jynOjPQ1brI9Q8xxvJwWd7TajOXUCwbA5oikxDZN
 zwXw==
X-Gm-Message-State: AOAM5317pEYglam9dRSaU1hlYTCrkvgJ+Kq23iNU5K33XBIBWTUftYIE
 K8mJ8eUTtnl1oOyA1VOF5V/ISw==
X-Google-Smtp-Source: ABdhPJwOPtmMtv6OjKVZB2aVxNghBPp9/tnek0StNVDL8wEHHKGQzndhEh0APrbsGcFVBzNIdtfVVQ==
X-Received: by 2002:a1c:2bc3:: with SMTP id r186mr4442378wmr.163.1605013251758; 
 Tue, 10 Nov 2020 05:00:51 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:870:7715:aaa1:475e])
 by smtp.gmail.com with ESMTPSA id 35sm15115746wro.71.2020.11.10.05.00.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 10 Nov 2020 05:00:50 -0800 (PST)
Date: Tue, 10 Nov 2020 13:00:49 +0000
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v1 23/24] kvm: arm64: Trap host SMCs in protected mode.
Message-ID: <20201110130049.pwc4ilqy2ue2ydvu@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
 <20201109113233.9012-24-dbrazdil@google.com>
 <10952bcf24bebd5e317d09ced415bfb1@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <10952bcf24bebd5e317d09ced415bfb1@kernel.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > @@ -88,6 +88,12 @@ SYM_CODE_END(__kvm_hyp_init)
> >   * x0: struct kvm_nvhe_init_params PA
> >   */
> >  SYM_CODE_START(___kvm_hyp_init)
> > +alternative_cb kvm_patch_hcr_flags
> > +	mov_q	x1, HCR_HOST_NVHE_FLAGS
> 
> You really want to be careful here: the mov_q macro expands to 2, 3 or 4
> instructions, depending on the input data...
> 
> It is also odd that you have both a static key and a patching alternative.
> Why isn't "protected KVM" a capability that can be evaluated as a a non
> patching alternative? In general, I'd like to reserve patching alternatives
> to values that cannot be evaluated at compile time (VM offsets, for
> example).

Capability was my initial idea as well but it looked tied to CPU features.
Looking at it again, you're right that there is precedent for setting them
from kernel params. Alright, I'll change it and that will get rid of the
custom patching.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
