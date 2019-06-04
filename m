Return-Path: <SRS0=jSi8=UD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB38C282CE
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jun 2019 08:55:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5776624C4A
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jun 2019 08:55:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sW4SdT2R"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5776624C4A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D05B84A4E8;
	Tue,  4 Jun 2019 04:55:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KKfl4-kWs2U3; Tue,  4 Jun 2019 04:55:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB92E4A3B2;
	Tue,  4 Jun 2019 04:55:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02EE24A3B2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jun 2019 04:55:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2LFBZNioNRvV for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jun 2019 04:55:51 -0400 (EDT)
Received: from mail-pg1-f193.google.com (mail-pg1-f193.google.com
 [209.85.215.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 06C914A332
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jun 2019 04:55:50 -0400 (EDT)
Received: by mail-pg1-f193.google.com with SMTP id f25so9952551pgv.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Jun 2019 01:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=kx5q7zCTFKw0j3QN1oqE8pZnZTP9To8Le7W99DKm2LU=;
 b=sW4SdT2R95XIX+vXafemro3dM2V7gCnY1WEO1ChuJw8577FfF4rpJTWX3J2hPWsmiw
 b15JXnIO87kszDkbXvD9vAIkC9jcBM/+CZdeQeK64Dili6fANlVoIrxtnTODhCmQaosz
 ZrjP9hAEmTn5YbHldzcM7oZW+ufKWM2emARh/YhJkOag4U+xO/+uS0WFmSLd9i8MNg/e
 WWUyHYR2R9bUxhOGAymLg4gqZMSc01/zfU9c5fUJQoQhTJXQPpwh2ABhYsBOrDJ67hEX
 YxLddJ/KMmCzeJO8Wd67wtIPVoFogIEfgAWggKTgK12LnKB7X7XfxzQdPQxjlpFB7N4p
 UEXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=kx5q7zCTFKw0j3QN1oqE8pZnZTP9To8Le7W99DKm2LU=;
 b=FZPC7dfwSgdpkxdCg+gxRaNdHnY+atLInHUmoMDeTvrFPQ8WwhhzagBMWLdm+p7+CG
 xgOgH1/gt8SWtbWr1rKgvUSdDEz78ox9sfdFcqkwpdsxDIQoxlG+zWyqbDyqbhmP+oaG
 JhYdv6ryumi7/vdj1GiJle2d3kPI3LJa9uKTpvF0MLzy3LzcakE1EOn6s6p2uDu1TCsG
 62rudXScHrkCPd/1X9ZR3pzmOLuYK11na9MNE1OAMxjJD9RU9D/aB6LzNOB1/0O27XYH
 o2tkIbM8dNceWiZ+JvDIwX4fD8NaujQHU0Irn2dDMw4bP0y1XHWGFcPs8RpOmKypIV2I
 CbEw==
X-Gm-Message-State: APjAAAWq6+s+Q4SULom9eNC9LeF+p9jPWyIyzCoYL/B2umIMv2FnnA/R
 0khJyMdEl0/dSxXUlKcaMWrt0g==
X-Google-Smtp-Source: APXvYqxAVFtSOCZX5AfZ+92Sy7EAVfXddvBIiq0QZdyyoPKzviGrJnwpdWBBPBjPOpg361VTnR4AkA==
X-Received: by 2002:a17:90a:bf84:: with SMTP id
 d4mr34814181pjs.124.1559638549661; 
 Tue, 04 Jun 2019 01:55:49 -0700 (PDT)
Received: from localhost ([122.172.66.84])
 by smtp.gmail.com with ESMTPSA id l23sm18420974pgh.68.2019.06.04.01.55.47
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Tue, 04 Jun 2019 01:55:47 -0700 (PDT)
Date: Tue, 4 Jun 2019 14:25:45 +0530
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] KVM: arm64: Drop 'const' from argument of vq_present()
Message-ID: <20190604085545.hsmxfqkpt2cbrhtw@vireshk-i7>
References: <699121e5c938c6f4b7b14a7e2648fa15af590a4a.1559623368.git.viresh.kumar@linaro.org>
 <20190604084349.prnnvjvjaeuhsmgs@mbp>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190604084349.prnnvjvjaeuhsmgs@mbp>
User-Agent: NeoMutt/20180716-391-311a52
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
 Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
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

On 04-06-19, 09:43, Catalin Marinas wrote:
> On Tue, Jun 04, 2019 at 10:13:19AM +0530, Viresh Kumar wrote:
> > We currently get following compilation warning:
> > 
> > arch/arm64/kvm/guest.c: In function 'set_sve_vls':
> > arch/arm64/kvm/guest.c:262:18: warning: passing argument 1 of 'vq_present' from incompatible pointer type
> > arch/arm64/kvm/guest.c:212:13: note: expected 'const u64 (* const)[8]' but argument is of type 'u64 (*)[8]'
> 
> Since the vq_present() function does not modify the vqs array, I don't
> understand why this warning. Compiler bug?

Probably yes. Also marking array argument to functions as const is a
right thing to do, to declare that the function wouldn't change the
array values.

I tried a recent toolchain and this doesn't happen anymore.

Sorry for the noise.

-- 
viresh
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
