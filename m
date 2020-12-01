Return-Path: <SRS0=s1GN=FF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D37C64E7B
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 14:43:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D92B820757
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 14:43:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="ICa9ez6x"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D92B820757
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09F3B4B925;
	Tue,  1 Dec 2020 09:43:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BtEV1pFGnEKf; Tue,  1 Dec 2020 09:43:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF4EE4B926;
	Tue,  1 Dec 2020 09:43:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDE9A4B91D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 09:43:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8HLj+X5cnOuE for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2020 09:43:52 -0500 (EST)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B24DA4B6EF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 09:43:52 -0500 (EST)
Received: by mail-wr1-f67.google.com with SMTP id 23so2981973wrc.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Dec 2020 06:43:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=JIA0Scl4OIMMkSS/5dfb1RixGjs/UhotRuHwz308dGA=;
 b=ICa9ez6xKvXoVFd5a+nyt9V7db40a6UDXltW3gu+5eDTPPoS7Y+JHn0qhh505cto8f
 GRLJkOPi8X4qfWqafWsQ6KrEg1FBVyXFnMuueku5Rvh2nAkHFVLVmB94DGc7SMapcND8
 iCfVQkWismF7cf9Pxzp3Pi5NrsRfBnkClOAt3axQ3sGSRNPGhXQv7qFGz5pajfx4cjxn
 5vFpF4gkJTjJGtnvbwVNxH5lm7Jc0cCZfd9IXPiS4SNeZVCufI98odvCCzyskxTIRMwx
 S+gz72PQ6q5hfrC4mBZr8J/bOiuIbHPAIKUX5idfyO8GKJNpNm3oeMe1COzvBl6m/a3D
 I85A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=JIA0Scl4OIMMkSS/5dfb1RixGjs/UhotRuHwz308dGA=;
 b=qG78KLDvjMazFYykCT88xJfDW8M2uI43bbvWHV5+447X95S7qks6I8gkXNRh9jd2am
 NOaklEDk57b6xFmdQVnSyHjHDvEmD8Ft4CY1OlB5bXpMykP2AH11ofKJ7QCiISSiDxmP
 /wTa+TUWcu8L/xErVs6hJr/+xnag7PUTg61q7zsKPMPa69TGChXa3o1siMKn95t+y13b
 dw900IVbNMUijBKgXMoALQEyWFafyQiQaxwapQhKXgqIzqhjeZdmDnB3WZSS91JAbTim
 kVEViCVtJKYbn6Qj/76qrt8Gp7s0PO/rMJq7nii2CArTU+KD2+UdaxcKpVURVol926GT
 PP2w==
X-Gm-Message-State: AOAM533yEkVS+j9bN2Wf45D/nA0RRlv1DnR5pLhzBzVQEx92c8sWXx8U
 O0UvNr+OCeAayD+JcebW3cm1iw==
X-Google-Smtp-Source: ABdhPJxFvoIa6LKNTCZysKjYl0L3o6ekKKdzC32vTURn5ckCGb5MJxfK027unJvURm7vUyFNvUoRNg==
X-Received: by 2002:a5d:4e87:: with SMTP id e7mr4467528wru.70.1606833831387;
 Tue, 01 Dec 2020 06:43:51 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:7c5f:5ab5:ac1f:89ce])
 by smtp.gmail.com with ESMTPSA id y130sm99756wmc.22.2020.12.01.06.43.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 01 Dec 2020 06:43:50 -0800 (PST)
Date: Tue, 1 Dec 2020 14:43:49 +0000
From: David Brazdil <dbrazdil@google.com>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v3 06/23] kvm: arm64: Add kvm-arm.protected early kernel
 parameter
Message-ID: <20201201144349.bglz7yicc3peixe6@google.com>
References: <20201126155421.14901-1-dbrazdil@google.com>
 <20201126155421.14901-7-dbrazdil@google.com>
 <20201127163254.zxdrszlveaxhluwn@bogus>
 <20201201131913.u7m2eifvtus74dra@google.com>
 <20201201140734.GA86881@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201201140734.GA86881@C02TD0UTHF1T.local>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 Sudeep Holla <sudeep.holla@arm.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
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

> > > be just me, but if you agree please update so that it doesn't give remote
> > > idea that it is not valid on VHE enabled hardware.
> > > 
> > > I was trying to run this on the hardware and was trying to understand the
> > > details on how to do that.
> > 
> > I see what you're saying, but !CONFIG_ARM64_VHE isn't accurate either. The
> > option makes sense if:
> >   1) all cores booted in EL2
> >      == is_hyp_mode_available()
> >   2) ID_AA64MMFR1_EL1.VH=0 or !CONFIG_ARM64_VHE
> >      == !is_kernel_in_hyp_mode()
> > 
> > The former feels implied for KVM, the latter could be 'Valid if the kernel
> > is running in EL1'? WDYT?
> 
> I reckon we can avoid the restriction if we instead add an early stub
> like with have for KASLR. That way we could parse the command line
> early, and if necessary re-initialize EL2 and drop to EL1 before the
> main kernel has to make any decisions about how to initialize things.
> That would allow us to have a more general kvm-arm.mode option where a
> single kernel Image could support:
> 
> * "protected" mode on nVHE or VHE HW
> * "nvhe" mode on nVHE or VHE HW
> * "vhe" mode on VHE HW
> 
> ... defaulting to VHE/nVHE modes depending on HW support.
> 
> That would also be somewhat future-proof if we have to add other
> variants of protected mode in future, as we could extend the mode option
> with parameters for each mode.

Agreed that 'mode' is a more future-proof flag and I would very much love to
have an option to force nVHE on VHE HW. I however expect that the early stub
would not be a trivial addition and would not want to get into that in this
series. Could we agree on 'protected' as the only supported value for the time
being?

David

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
