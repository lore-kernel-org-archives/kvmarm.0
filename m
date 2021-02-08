Return-Path: <SRS0=ArS2=HK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E71C433DB
	for <kvmarm@archiver.kernel.org>; Mon,  8 Feb 2021 15:02:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7D42164EB7
	for <kvmarm@archiver.kernel.org>; Mon,  8 Feb 2021 15:02:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D42164EB7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CCD8B4B5A0;
	Mon,  8 Feb 2021 10:02:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vq+HO1CqLxVc; Mon,  8 Feb 2021 10:02:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA1354B590;
	Mon,  8 Feb 2021 10:02:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 471894B590
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2021 10:02:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 60OOVUYhsb+P for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Feb 2021 10:02:26 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4C73C4B14E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2021 10:02:26 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 166F264E29;
 Mon,  8 Feb 2021 15:02:25 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l983S-00CoV5-QY; Mon, 08 Feb 2021 15:02:23 +0000
MIME-Version: 1.0
Date: Mon, 08 Feb 2021 15:02:22 +0000
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v7 00/23] arm64: Early CPU feature override, and
 applications to VHE, BTI and PAuth
In-Reply-To: <20210208143248.GA25934@willie-the-truck>
References: <20210208095732.3267263-1-maz@kernel.org>
 <20210208143248.GA25934@willie-the-truck>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <240a0245f75d8368a4d90a5e6740dc7d@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, psodagud@codeaurora.org,
 sramana@codeaurora.org, catalin.marinas@arm.com, marcan@marcan.st,
 linux-kernel@vger.kernel.org, ardb@kernel.org, pajay@qti.qualcomm.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Srinivas Ramana <sramana@codeaurora.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Hector Martin <marcan@marcan.st>,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 Ajay Patil <pajay@qti.qualcomm.com>, Prasad Sodagudi <psodagud@codeaurora.org>,
 kernel-team@android.com, Ard Biesheuvel <ardb@kernel.org>,
 linux-arm-kernel@lists.infradead.org
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

Hi Will,

On 2021-02-08 14:32, Will Deacon wrote:
> Hi Marc,
> 
> On Mon, Feb 08, 2021 at 09:57:09AM +0000, Marc Zyngier wrote:
>> It recently came to light that there is a need to be able to override
>> some CPU features very early on, before the kernel is fully up and
>> running. The reasons for this range from specific feature support
>> (such as using Protected KVM on VHE HW, which is the main motivation
>> for this work) to errata workaround (a feature is broken on a CPU and
>> needs to be turned off, or rather not enabled).
>> 
>> This series tries to offer a limited framework for this kind of
>> problems, by allowing a set of options to be passed on the
>> command-line and altering the feature set that the cpufeature
>> subsystem exposes to the rest of the kernel. Note that this doesn't
>> change anything for code that directly uses the CPU ID registers.
> 
> I applied this locally, but I'm seeing consistent boot failure under 
> QEMU when
> KASAN is enabled. I tried sprinkling some __no_sanitize_address 
> annotations
> around (see below) but it didn't help. The culprit appears to be
> early_fdt_map(), but looking a bit more closely, I'm really nervous 
> about the
> way we call into C functions from __primary_switched. Remember -- this 
> code
> runs _twice_ when KASLR is active: before and after the randomization. 
> This
> also means that any memory writes the first time around can be lost due 
> to
> the D-cache invalidation when (re-)creating the kernel page-tables.

Well, we already call into C functions with KASLR, and nothing explodes
with that, so I must be doing something else wrong.

I do have cache maintenance for the writes to the shadow registers, so 
that
part should be fine. But I think I'm missing some cache maintenance 
around
the FDT base itself, and I wonder what happens when we go around the 
loop.

I'll chase this down now.

Thanks for the heads up.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
