Return-Path: <SRS0=HOrx=GL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64425C433E0
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 16:51:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BABED239FE
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 16:51:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BABED239FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 118924B42A;
	Fri,  8 Jan 2021 11:51:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DB+P8Exv4zdC; Fri,  8 Jan 2021 11:51:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 225C64B42C;
	Fri,  8 Jan 2021 11:51:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 716CD4B428
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 11:51:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HH4rj42Kbvc0 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jan 2021 11:51:15 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 40D6A4B36D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 11:51:15 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 084A9239FD;
 Fri,  8 Jan 2021 16:51:14 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kxuyl-0067gk-RL; Fri, 08 Jan 2021 16:51:11 +0000
MIME-Version: 1.0
Date: Fri, 08 Jan 2021 16:51:11 +0000
From: Marc Zyngier <maz@kernel.org>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH] KVM: arm64: Compute TPIDR_EL2 ignoring MTE tag
In-Reply-To: <20210108161254.53674-1-steven.price@arm.com>
References: <20210108161254.53674-1-steven.price@arm.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <e49459f08d0afb30a120dfb3d6b80741@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: steven.price@arm.com, catalin.marinas@arm.com,
 will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 glider@google.com, akpm@linux-foundation.org, andreyknvl@google.com,
 vincenzo.frascino@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Andrey Konovalov <andreyknvl@google.com>,
 Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will@kernel.org>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Steven,

On 2021-01-08 16:12, Steven Price wrote:
> KASAN in HW_TAGS mode will store MTE tags in the top byte of the
> pointer. When computing the offset for TPIDR_EL2 we don't want anything
> in the top byte, so remove the tag to ensure the computation is correct
> no matter what the tag.
> 
> Fixes: 94ab5b61ee16 ("kasan, arm64: enable CONFIG_KASAN_HW_TAGS")
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Without this fix I can't boot a config with KASAN_HW_TAGS and KVM on an
> MTE enabled host. I'm unsure if this should really be in
> this_cpu_ptr_nvhe_sym().

this_cpu_ptr_nvhe_sym() should return something that is valid for
the EL1 kernel, so I guess untagging in the helper may not be
that useful.

However, I'm more concerned by anything at requires us to follow
pointers set up by EL1 at EL2. It looks to me that the only reason
the whole thing works is because kern_hyp_va() *accidentally* drops
tags before applying the EL1/EL2 offset...

Or am I getting it wrong?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
