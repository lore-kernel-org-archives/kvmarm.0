Return-Path: <SRS0=mQ94=YO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF80CA9EB7
	for <kvmarm@archiver.kernel.org>; Mon, 21 Oct 2019 14:06:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 546A12053B
	for <kvmarm@archiver.kernel.org>; Mon, 21 Oct 2019 14:06:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 546A12053B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9FC14A9B6;
	Mon, 21 Oct 2019 10:06:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KJYIRPA6c+2I; Mon, 21 Oct 2019 10:06:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDC1F4A9B9;
	Mon, 21 Oct 2019 10:06:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DABFE4A9AE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 10:06:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Daoa9AaKR0Z8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Oct 2019 10:06:01 -0400 (EDT)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EEFC04A993
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 10:06:00 -0400 (EDT)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iMYJp-0005GP-K0; Mon, 21 Oct 2019 16:05:57 +0200
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v6 08/10] arm/arm64: Provide a wrapper for SMCCC 1.1 calls
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Mon, 21 Oct 2019 15:05:57 +0100
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <890a7909-1083-2e6d-368a-f1d03788f5a1@arm.com>
References: <20191011125930.40834-1-steven.price@arm.com>
 <20191011125930.40834-9-steven.price@arm.com>
 <099040bb979b7cb878a7f489033aacc7@www.loen.fr>
 <890a7909-1083-2e6d-368a-f1d03788f5a1@arm.com>
Message-ID: <760679a0a6fef6041b0e7bec8d04d81f@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: steven.price@arm.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 catalin.marinas@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com,
 linux@armlinux.org.uk, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, mark.rutland@arm.com, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
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

On 2019-10-21 14:43, Steven Price wrote:
> On 21/10/2019 12:42, Marc Zyngier wrote:
>> On 2019-10-11 13:59, Steven Price wrote:
> [...]
>> All this should most probably go on top of the SMCCC conduit cleanup 
>> that
>> has already been already queued in the arm64 tree (see
>> arm64/for-next/smccc-conduit-cleanup).
>
> Good point, I'll rebase. Are you happy for the entire series to be 
> based
> on top of that? i.e. based on commit e6ea46511b1a ("firmware: 
> arm_sdei:
> use common SMCCC_CONDUIT_*")

Absolutely. I'll sync with Will and Catalin to get a stable branch that
includes these commits.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
