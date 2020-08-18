Return-Path: <SRS0=un+q=B4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E569CC433E1
	for <kvmarm@archiver.kernel.org>; Tue, 18 Aug 2020 14:41:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 722E72087D
	for <kvmarm@archiver.kernel.org>; Tue, 18 Aug 2020 14:41:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="AOCKY6z/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 722E72087D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01F2C4BBFB;
	Tue, 18 Aug 2020 10:41:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HHY2px4VGTKV; Tue, 18 Aug 2020 10:41:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE6174BC11;
	Tue, 18 Aug 2020 10:41:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3B084BBFB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Aug 2020 10:41:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RPO8Uq1PfQBr for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Aug 2020 10:41:04 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA5544BB98
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Aug 2020 10:41:04 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 70C852083B;
 Tue, 18 Aug 2020 14:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1597761663;
 bh=bJPOt4B5MgpMDT2n+zzNZ+rE9AaQj654FX1OxJw6sDk=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=AOCKY6z/atNldeFw82NlnljvDaIkZ1FqC+aSBMu3yFXm9qvkAyP1Gs4olwzL0n+JN
 KtfqIK08IDgo0RkpYl8PMbUn6s3DUAhVyXc/EQOmH1F+zB4VF2sIxTbf7BWv2kFOUi
 VkiNd596tsEYNkhmbOs65QaPxRz3BbwlGWmAiHAI=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k82nN-003vcz-O3; Tue, 18 Aug 2020 15:41:01 +0100
MIME-Version: 1.0
Date: Tue, 18 Aug 2020 15:41:01 +0100
From: Marc Zyngier <maz@kernel.org>
To: Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [RFC PATCH 0/5] KVM: arm64: Add pvtime LPT support
In-Reply-To: <20200817084110.2672-1-zhukeqian1@huawei.com>
References: <20200817084110.2672-1-zhukeqian1@huawei.com>
User-Agent: Roundcube Webmail/1.4.7
Message-ID: <8308f52e4c906cad710575724f9e3855@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: zhukeqian1@huawei.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, steven.price@arm.com, catalin.marinas@arm.com,
 will@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, Steven Price <steven.price@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On 2020-08-17 09:41, Keqian Zhu wrote:
> Hi all,
> 
> This patch series picks up the LPT pvtime feature originally developed
> by Steven Price: https://patchwork.kernel.org/cover/10726499/
> 
> Backgroud:
> 
> There is demand for cross-platform migration, which means we have to
> solve different CPU features and arch counter frequency between hosts.
> This patch series can solve the latter problem.
> 
> About LPT:
> 
> This implements support for Live Physical Time (LPT) which provides the
> guest with a method to derive a stable counter of time during which the
> guest is executing even when the guest is being migrated between hosts
> with different physical counter frequencies.
> 
> Changes on Steven Price's work:
> 1. LPT structure: use symmatical semantics of scale multiplier, and use
>    fraction bits instead of "shift" to make everything clear.
> 2. Structure allocation: host kernel does not allocates the LPT 
> structure,
>    instead it is allocated by userspace through VM attributes. The 
> save/restore
>    functionality can be removed.
> 3. Since LPT structure just need update once for each guest run, add a 
> flag to
>    indicate the update status. This has two benifits: 1) avoid multiple 
> update
>    by each vCPUs. 2) If the update flag is not set, then return NOT 
> SUPPORT for
>    coressponding guest HVC call.
> 4. Add VM device attributes interface for userspace configuration.
> 5. Add a base LPT read/write layer to reduce code.
> 6. Support ptimer scaling.
> 7. Support timer event stream translation.
> 
> Things need concern:
> 1. https://developer.arm.com/docs/den0057/a needs update.

LPT was explicitly removed from the spec because it doesn't really
solve the problem, specially for the firmware: EFI knows
nothing about this, for example. How is it going to work?
Also, nobody was ever able to explain how this would work for
nested virt.

ARMv8.4 and ARMv8.6 have the feature set that is required to solve
this problem without adding more PV to the kernel.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
