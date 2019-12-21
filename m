Return-Path: <SRS0=JRaC=2L=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 836DBC2D0C0
	for <kvmarm@archiver.kernel.org>; Sat, 21 Dec 2019 10:49:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0E8F021655
	for <kvmarm@archiver.kernel.org>; Sat, 21 Dec 2019 10:49:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E8F021655
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D3A94AEC8;
	Sat, 21 Dec 2019 05:49:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s1bXblsIz1za; Sat, 21 Dec 2019 05:49:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 54E0E4AD09;
	Sat, 21 Dec 2019 05:49:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB85D4ACBA
 for <kvmarm@lists.cs.columbia.edu>; Sat, 21 Dec 2019 05:49:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 01h1xZBitPJE for <kvmarm@lists.cs.columbia.edu>;
 Sat, 21 Dec 2019 05:48:20 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 106EE4AC65
 for <kvmarm@lists.cs.columbia.edu>; Sat, 21 Dec 2019 05:48:19 -0500 (EST)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iicIy-00080I-IP; Sat, 21 Dec 2019 11:48:16 +0100
To: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v2 00/18] arm64: KVM: add SPE profiling support
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Sat, 21 Dec 2019 10:48:16 +0000
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <20191220143025.33853-1-andrew.murray@arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
Message-ID: <f023f5529361cc1e2d799daa70f196c2@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: andrew.murray@arm.com, catalin.marinas@arm.com,
 mark.rutland@arm.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 sudeep.holla@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

[fixing email addresses]

Hi Andrew,

On 2019-12-20 14:30, Andrew Murray wrote:
> This series implements support for allowing KVM guests to use the Arm
> Statistical Profiling Extension (SPE).

Thanks for this. In future, please Cc me and Will on email addresses
we can actually read.

> It has been tested on a model to ensure that both host and guest can
> simultaneously use SPE with valid data. E.g.
>
> $ perf record -e arm_spe/ts_enable=1,pa_enable=1,pct_enable=1/ \
>         dd if=/dev/zero of=/dev/null count=1000
> $ perf report --dump-raw-trace > spe_buf.txt
>
> As we save and restore the SPE context, the guest can access the SPE
> registers directly, thus in this version of the series we remove the
> trapping and emulation.
>
> In the previous series of this support, when KVM SPE isn't supported
> (e.g. via CONFIG_KVM_ARM_SPE) we were able to return a value of 0 to
> all reads of the SPE registers - as we can no longer do this there 
> isn't
> a mechanism to prevent the guest from using SPE - thus I'm keen for
> feedback on the best way of resolving this.

Surely there is a way to conditionally trap SPE registers, right? You
should still be able to do this if SPE is not configured for a given
guest (as we do for other feature such as PtrAuth).

> It appears necessary to pin the entire guest memory in order to 
> provide
> guest SPE access - otherwise it is possible for the guest to receive
> Stage-2 faults.

Really? How can the guest receive a stage-2 fault? This doesn't fit 
what
I understand of the ARMv8 exception model. Or do you mean a SPE 
interrupt
describing a S2 fault?

And this is not just pinning the memory either. You have to ensure that
all S2 page tables are created ahead of SPE being able to DMA to guest
memory. This may have some impacts on the THP code...

I'll have a look at the actual series ASAP (but that's not very soon).

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
