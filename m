Return-Path: <SRS0=lrOB=GC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 061FFC433DB
	for <kvmarm@archiver.kernel.org>; Wed, 30 Dec 2020 10:06:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6E800221F8
	for <kvmarm@archiver.kernel.org>; Wed, 30 Dec 2020 10:06:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E800221F8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1BA24B1CA;
	Wed, 30 Dec 2020 05:06:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jjD34CfGMAWu; Wed, 30 Dec 2020 05:06:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5E074B1D1;
	Wed, 30 Dec 2020 05:06:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BE6E4B1CB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Dec 2020 05:06:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a9iGayyXP-Qn for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Dec 2020 05:06:23 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 525C14B1CA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Dec 2020 05:06:23 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1A4EA21D94;
 Wed, 30 Dec 2020 10:06:22 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kuYN2-004YYb-0Y; Wed, 30 Dec 2020 10:06:20 +0000
MIME-Version: 1.0
Date: Wed, 30 Dec 2020 10:06:19 +0000
From: Marc Zyngier <maz@kernel.org>
To: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [PATCH] KVM: arm64: Allow PSCI SYSTEM_OFF/RESET to return
In-Reply-To: <20201229170412.GN1551@shell.armlinux.org.uk>
References: <20201229160059.64135-1-dbrazdil@google.com>
 <20201229170412.GN1551@shell.armlinux.org.uk>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <0e1d555404e4ae8edcf6737735dc0eb7@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: linux@armlinux.org.uk, dbrazdil@google.com,
 kvmarm@lists.cs.columbia.edu, mark.rutland@arm.com, lorenzo.pieralisi@arm.com,
 suzuki.poulose@arm.com, sudeep.holla@arm.com, linux-kernel@vger.kernel.org,
 james.morse@arm.com, linux-arm-kernel@lists.infradead.org,
 catalin.marinas@arm.com, kernel-team@android.com, will@kernel.org,
 julien.thierry.kdev@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On 2020-12-29 17:04, Russell King - ARM Linux admin wrote:
> On Tue, Dec 29, 2020 at 04:00:59PM +0000, David Brazdil wrote:
>> The KVM/arm64 PSCI relay assumes that SYSTEM_OFF and SYSTEM_RESET 
>> should
>> not return, as dictated by the PSCI spec. However, there is firmware 
>> out
>> there which breaks this assumption, leading to a hyp panic. Make KVM
>> more robust to broken firmware by allowing these to return.
> 
> Are you sure you should just return?
> 
> We've had issues in the past with Linux reboot(2) that returns
> to userspace, allowing on 32-bit ARM for example watchdogs to
> unexpectedly continue being serviced.

I don't think this changes anything compared to the case where
the PSCI relay isn't enabled. The EL1 part of the kernel would
see the SYSTEM_RESET call return, and handle it accordingly
(stay in a while(1) loop).

This is consistent with the PSCI relay design goal of being
invisible to the EL1 kernel.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
