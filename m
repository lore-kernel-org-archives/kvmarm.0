Return-Path: <SRS0=x+jN=ER=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47FDDC5517A
	for <kvmarm@archiver.kernel.org>; Wed, 11 Nov 2020 12:32:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7A4B620709
	for <kvmarm@archiver.kernel.org>; Wed, 11 Nov 2020 12:32:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Ja7qkn/l"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A4B620709
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AABE54B994;
	Wed, 11 Nov 2020 07:32:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Cs+l+kmvquil; Wed, 11 Nov 2020 07:32:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B895A4B9A1;
	Wed, 11 Nov 2020 07:32:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BFC04B93E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Nov 2020 07:32:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JPXWzA7-68LV for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Nov 2020 07:32:26 -0500 (EST)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5D92D4B93B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Nov 2020 07:32:26 -0500 (EST)
Received: by mail-wm1-f67.google.com with SMTP id s13so2159265wmh.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Nov 2020 04:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=XtEuYJqpVWdYVZAacuVpb6hyxFgTbQMkbAIhltpNKL8=;
 b=Ja7qkn/lq9oiqwC27+zkFQJeArO4GLvWWzlfFEwQ4TlruRJR5FzFVktlan4lAT8uhT
 GTABF5yUj9gP5jOMJ9b5esYLbeH5VjnSC//QJghLJYlz73VNRELC20/ketIza7Dr2R8U
 cCkGoBD7R6CNx1xup45TuhqV+reaJnR2Cd0zcdo6OcHKd6Sxt4z0Np1Bu6C2Z5LKmWKV
 5UgF385H5RiSnyWytK9qT7kC4gPbObKUnFyLIn3MFhVEWNO4irXz27rtFMVJsspRyhBJ
 1uT0ZDHMKlz9yGFhLJjHKc+kpshuA1VbkZOaClTXU0YlDhhMESkMLX080Wqtp0Qw9iIF
 DR3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=XtEuYJqpVWdYVZAacuVpb6hyxFgTbQMkbAIhltpNKL8=;
 b=gRLjBBNPYKyN0SiSNupxYUv9ppBegeMkinvUcZNnh5dyKcA4UezGhV9sXMqgwr/4K0
 lhdLtN1agb36HnsqatebbN3GVhf9524UyAuBvZ4DZ1anilyoyAJu5/wWSYjjxV4Mpxqb
 2VOl9lvHfm4kQAayuwv+nj8t1VjqJzXqNXcPvkdwpQxuI/Lr4yITG7bw49o3g0MADXTq
 F5nU4XlF/IJrFjpQLiPeGF/jOwyFSipD7AsuF9lPaD7iMjPhzdAxvi5B5NXE4NEA1nkf
 ajw1BpDKj64ODg8N/TQTZJLO0mtpo/M36ZR6w+LNidaHZBUkgb1P0odinxulNZNuVb0B
 wVYQ==
X-Gm-Message-State: AOAM530LgS51GqrQTwytvtqkkvayeu3ZpmtyTrckj+MUb6LrynQofRZZ
 /UTdSPmrL/5Ad5+DXpl1w9UNLg==
X-Google-Smtp-Source: ABdhPJyMdXM5aicXN5Ib33YGeRQlcphSIsMKmTWL4A6/3D5qrbO5zhbeG85AQYouCaWcr+Nk5zMANQ==
X-Received: by 2002:a7b:c384:: with SMTP id s4mr3911891wmj.77.1605097945020;
 Wed, 11 Nov 2020 04:32:25 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:2595:ed05:1717:fe6e])
 by smtp.gmail.com with ESMTPSA id q16sm2414688wrn.13.2020.11.11.04.32.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 11 Nov 2020 04:32:23 -0800 (PST)
Date: Wed, 11 Nov 2020 12:32:22 +0000
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v1 06/24] kvm: arm64: Support per_cpu_ptr in nVHE hyp code
Message-ID: <20201111123222.ooevu6nryu3ncphv@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
 <20201109113233.9012-7-dbrazdil@google.com>
 <f28c9a67759cb04157e888b3a71b2ce2@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f28c9a67759cb04157e888b3a71b2ce2@kernel.org>
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
> > +	cpu_base_array = kern_hyp_va(&kvm_arm_hyp_percpu_base[0]);
> 
> There is no guarantee that this will not generate a PC relative
> addressing, resulting in kern_hyp_va() being applied twice.
> 
> Consider using hyp_symbol_addr() instead, which always does the right
> by forcing a PC relative addressing and not subsequently mangling
> the address.
> 
> > +	this_cpu_base = kern_hyp_va(cpu_base_array[cpu]);
> > +	return this_cpu_base - (unsigned long)&__per_cpu_start;
> 
> And this is the opposite case: if the compiler generates an absolute
> address, you're toast. Yes, this is just as unlikely, but hey...
> Same remedy should apply.

Good point, and I'll probably keep forgetting about this in the future. Now
that all .hyp.text is only executed under hyp page tables, should we start
thinking about fixing up the relocations?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
