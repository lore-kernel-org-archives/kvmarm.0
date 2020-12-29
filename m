Return-Path: <SRS0=Fui2=GB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74408C433E0
	for <kvmarm@archiver.kernel.org>; Tue, 29 Dec 2020 19:27:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 98E43221F8
	for <kvmarm@archiver.kernel.org>; Tue, 29 Dec 2020 19:27:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 98E43221F8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8B3B4B2F0;
	Tue, 29 Dec 2020 14:27:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EDRchOfcAQYY; Tue, 29 Dec 2020 14:27:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 522F64B2F2;
	Tue, 29 Dec 2020 14:27:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 464854B2EF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Dec 2020 14:27:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cOb55tvRK27a for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Dec 2020 14:27:18 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 259A24B203
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Dec 2020 14:27:18 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D69C9207B1;
 Tue, 29 Dec 2020 19:27:16 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kuKeI-004SXK-Nx; Tue, 29 Dec 2020 19:27:14 +0000
MIME-Version: 1.0
Date: Tue, 29 Dec 2020 19:27:14 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH 00/17] arm64: Early CPU feature override, and an
 application to VHE
In-Reply-To: <20201228104958.1848833-1-maz@kernel.org>
References: <20201228104958.1848833-1-maz@kernel.org>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <20205dd2e203de92c680082eb3bf399e@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, mark.rutland@arm.com, kernel-team@android.com,
 suzuki.poulose@arm.com, catalin.marinas@arm.com, alexandru.elisei@arm.com,
 james.morse@arm.com, dbrazdil@google.com, will@kernel.org, ardb@kernel.org,
 julien.thierry.kdev@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kernel-team@android.com, Ard Biesheuvel <ardb@kernel.org>
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

On 2020-12-28 10:49, Marc Zyngier wrote:
> It recently came to light that there is a need to be able to override
> some CPU features very early on, before the kernel is fully up and
> running. The reasons for this range from specific feature support
> (such as using Protected KVM on VHE HW, which is the main motivation
> for this work) to errata workaround (a feature is broken on a CPU and
> needs to be turned off, or rather not enabled).
> 
> This series tries to offer a limited framework for this kind of
> problems, by allowing a set of options to be passed on the
> command-line and altering the feature set that the cpufeature
> subsystem exposes to the rest of the kernel. Note that this doesn't
> change anything for code that directly uses the CPU ID registers.
> 
> The series completely changes the way a VHE-capable arm64 boots, by
> *always* booting non-VHE first, and then upgrading to VHE when deemed
> capable. Although this sounds scary, this is actually simple to
> implement (and I wish I had though of it five years ago). The "upgrade
> to VHE" path is then conditioned on the VHE feature not being disabled
> from the command-line.
> 
> Said command-line parsing borrows a lot from the kaslr code, and
> subsequently allows the "nokaslr" option to be moved to the new
> infrastructure (though it all looks a bit... odd).
> 
> This has been tested on multiple VHE and non-VHE systems.

FWIW, I've just fixed a number of issues with this series, ranging
from compilation issues when CONFIG_RANDOMIZE_BASE is not set,
SPE setup bugs, and boot hangs when kaslr kicks in.

It all should be fixed now, and I have pushed an updated series
at [1], for those of you who really can't wait to try new stuff
while you could just ignore it all.

Thanks,

         M.

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=hack/arm64-early-cpufeature
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
