Return-Path: <SRS0=mzwA=FH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9630AC63777
	for <kvmarm@archiver.kernel.org>; Thu,  3 Dec 2020 10:51:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BB9AA208FE
	for <kvmarm@archiver.kernel.org>; Thu,  3 Dec 2020 10:51:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB9AA208FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C4494B1F6;
	Thu,  3 Dec 2020 05:51:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XPSFByPkZJQQ; Thu,  3 Dec 2020 05:51:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3493F4B1DF;
	Thu,  3 Dec 2020 05:51:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3BE24B1D7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2020 05:51:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IHNQ-OXu0ub4 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Dec 2020 05:51:05 -0500 (EST)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C6C004B1AE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2020 05:51:05 -0500 (EST)
Received: by mail-wm1-f68.google.com with SMTP id c198so2350325wmd.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Dec 2020 02:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=J635piZ/rKtx29aOFmG6FBeR7lY3a126JY0Ld6qBL8E=;
 b=fni8XWXJ65ktP4os0NGZmoCZnWcQlMQwfmVk+oa0QMvzC/S/FiZu5x4NUr6/TfBu2u
 aGL0yFbeRZ+leewJ5jdWZ870HeL1nfnq7hYaQLKPB7AUeIDrnL2/sLEotr4DN2JkzHBT
 pwHykLj1/wxm2FwPVt9ebwwP5LZdSYfrdyvZlYYHfQBYFvg0GEXdqNSiipAaWOtyhQwC
 oq3G8GuN5Z3jcOfF0QT51qncDQ7x5Cy6mzbRYDZ5RmR6unquAdOJIlwLxq5lgUEjQTgp
 akHOiyxmgEY5yWCmR3qVBpFsKv80keuCej/CLKHSQ9v8LQytI21vDmBRO8PTmbn6/fAI
 J+yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=J635piZ/rKtx29aOFmG6FBeR7lY3a126JY0Ld6qBL8E=;
 b=hupGz1uJH6eaJkwZRpmZyUZ7/pqTyk4h3exgS0mM3eP0fVgjYs+gyIMe8FbKX0yQuh
 3k+kPr+dP913aZYB9hLYAtsYVPNJevAimqKmJy3W2Vh6yBISveGbim35/KDLtXadc/8g
 PXlFA6Zx4lZ0POfq0VMlh2YPVyQ7+frNHBuq7ks+GJCUMKMdW6at7Yecdbljccbz6m8Y
 CtOKxvZgKKqWRMFUoY6FFSSxNomMqbg/aRcUYVpRnUp7ij3Lmq63oVDVaKsm4MhuaLoY
 hpE6XZdFPVULVrXxWrb2naZcQoA9EFw4asCgUSm15noxZSkq5nroXTbrk9jWLht3xHe4
 7r5w==
X-Gm-Message-State: AOAM5319VQXncyidTMUCSEU2/sNIO+eIPGEo1b4lEdPStis/Wd1L/4g4
 q66LAKWnV3gvSAp7Yx5CIawqng==
X-Google-Smtp-Source: ABdhPJwGxdGvAQwd3g9g/37YjONjS4wKyf5gl3p84BlZU5tkURTC0Xd03MbOOLQNl0Y5+ujoR/UhFw==
X-Received: by 2002:a1c:1b06:: with SMTP id b6mr2603884wmb.101.1606992664603; 
 Thu, 03 Dec 2020 02:51:04 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:5ddd:b7c5:e3c9:e87a])
 by smtp.gmail.com with ESMTPSA id u66sm1073595wmg.30.2020.12.03.02.51.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 03 Dec 2020 02:51:03 -0800 (PST)
Date: Thu, 3 Dec 2020 10:51:02 +0000
From: David Brazdil <dbrazdil@google.com>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v4 06/26] psci: Add accessor for psci_0_1_function_ids
Message-ID: <20201203105102.zpnjielsqdf3z3ox@google.com>
References: <20201202184122.26046-1-dbrazdil@google.com>
 <20201202184122.26046-7-dbrazdil@google.com>
 <20201203104712.GC96754@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201203104712.GC96754@C02TD0UTHF1T.local>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sudeep Holla <sudeep.holla@arm.com>, linux-arm-kernel@lists.infradead.org,
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

On Thu, Dec 03, 2020 at 10:47:12AM +0000, Mark Rutland wrote:
> On Wed, Dec 02, 2020 at 06:41:02PM +0000, David Brazdil wrote:
> > Make it possible to retrieve a copy of the psci_0_1_function_ids struct.
> > This is useful for KVM if it is configured to intercept host's PSCI SMCs.
> > 
> > Signed-off-by: David Brazdil <dbrazdil@google.com>
> 
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> 
> ... just to check, does KVM snapshot which function IDs are valid, or do
> we want to add that state here too? That can be a follow-up if
> necessary.

Ah, that's a good point. It doesn't, but can infer that from psci_ops.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
