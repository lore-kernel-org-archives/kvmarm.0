Return-Path: <SRS0=Tpw5=6V=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28242C47247
	for <kvmarm@archiver.kernel.org>; Thu,  7 May 2020 14:36:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A65A52083B
	for <kvmarm@archiver.kernel.org>; Thu,  7 May 2020 14:36:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="ZzB4d4PH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A65A52083B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 107F14B3A1;
	Thu,  7 May 2020 10:36:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fA5fYpbQxWnL; Thu,  7 May 2020 10:36:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2744C4B325;
	Thu,  7 May 2020 10:36:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E209C4B316
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 May 2020 10:36:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lUfIqinFntIi for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 May 2020 10:36:20 -0400 (EDT)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE5E44B2C3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 May 2020 10:36:20 -0400 (EDT)
Received: by mail-wm1-f68.google.com with SMTP id y24so7112108wma.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 May 2020 07:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:date:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=97qbtlSksxUqP4IepQZvJvrELnOIuCcLtceZei2X0fU=;
 b=ZzB4d4PH21eRkcpcL8/dT+++RvB0ZZmSphkIMJLtD5oMY2Jnwy7S98JFpZfw1OYm52
 3TWG2h2gorD9PKb0JKdyLP7kgH0CYBI6AQD+bD51IoyPOPJmai2OhLaOaM2Tn8KR/r+T
 0HjMn9km6DG+HcLGaNGTTtsaAmKgEi66yeYEVYKrej1QmHPcsTZfgNVFFeqPB5IR4/oJ
 G297cddKz4Z7Lxx7yvZy8V268l+77Bsr7s7lMPa0lTjhhO62NCnger0sZ9xW99EGDqJN
 GyLqbTJdof20XyI1vBiW1i2flDKKGUJpK3R7pfKCu/PK8sMvX8aEdJ/CQGv2O2uojqIf
 fROw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:date:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=97qbtlSksxUqP4IepQZvJvrELnOIuCcLtceZei2X0fU=;
 b=HZ6NlehrUlsPx6rB7gB3H9gmXkX33cHuSioetsfcPWngdpU7dNE9DdetQLdUXa9q5X
 R1ss/rSo8wAO/dswW/ra7/atOTdvCkiD9GdNsCevzcfw5Vl2wRtBkkgPtjnisbHItSBW
 kyS+6j+pNee8lzbMgBKlCChs3cdiESjLhu4c5sUR3hY5W8tUg8mgUtkQ3ATriD+nNLRr
 uDld7NWGTT6+mutN9iwD6aglJJgfyWYVXa6OiimYdTJ4ZqdPTOjG/q7n5OSkycaI1c6r
 Qm2Up/asU53iipGF0swk0AloXEPhSsxac/1WV+idJNl0B9FcdDJK0CFfr8n7oj756wih
 wuRQ==
X-Gm-Message-State: AGi0PuZs/NqhCuE8nUHJfkH1fDzWf21dTUder8UYGWFBtoQiv6qP6P9T
 RNJzYxEGYDWNuWO/coZyrCQL0A==
X-Google-Smtp-Source: APiQypKByb7yOAaqMEZY3XrineEZDS7bGjGUh3lbDYheXhS+bRdzViSRoAmOnUwDPOJrmi6GqqsTGw==
X-Received: by 2002:a1c:7d4b:: with SMTP id y72mr10888700wmc.11.1588862179402; 
 Thu, 07 May 2020 07:36:19 -0700 (PDT)
Received: from dbrazdil-macbookpro.roam.corp.google.com
 ([2a01:4b00:8523:2d03:1887:a290:f251:d169])
 by smtp.gmail.com with ESMTPSA id c190sm8793473wme.4.2020.05.07.07.36.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 07 May 2020 07:36:18 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
X-Google-Original-From: David Brazdil
 <dbrazdil@dbrazdil-macbookpro.roam.corp.google.com>
Date: Thu, 7 May 2020 15:36:17 +0100
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 03/15] arm64: kvm: Fix symbol dependency in
 __hyp_call_panic_nvhe
Message-ID: <20200507143617.2j5x3mfxi3ber7ig@dbrazdil-macbookpro.roam.corp.google.com>
References: <20200430144831.59194-1-dbrazdil@google.com>
 <20200430144831.59194-4-dbrazdil@google.com>
 <87blmzj2w5.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87blmzj2w5.wl-maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
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

Hi Marc,

> 
> What breaks without this constraint? Is it a fix that should go in
> early? Otherwise looks good.

This only becomes an issue when __hyp_call_panic_nvhe() and
__hyp_call_panic_vhe() are moved to separate files, so I don't think it's
necessary to go in early.

Currently the string variable (declared static) is seen by the C compiler as
used by __hyp_call_panic_vhe(). But when split, the variable in the nVHE source
file becomes unused, is dropped by the compiler and the inline assembly's
reference is unresolved. We could then alias __hyp_text___hyp_panic_string back
to the VHE copy, but this is the right way of addressing it.

Thanks for the review,
David

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
