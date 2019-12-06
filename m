Return-Path: <SRS0=eeW8=Z4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD728C2D0B1
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 11:44:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 752C124673
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 11:44:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 752C124673
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E98344AF3E;
	Fri,  6 Dec 2019 06:44:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qyQuxywiVHpV; Fri,  6 Dec 2019 06:44:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC2584AF09;
	Fri,  6 Dec 2019 06:44:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 974154AF01
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 06:44:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vNMkxSBCtr6r for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Dec 2019 06:44:33 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BD92E4AE8D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 06:44:33 -0500 (EST)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1idC2C-0001th-7s; Fri, 06 Dec 2019 12:44:32 +0100
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 0/2] kvm/arm64: unimplemented sysreg improvements
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Fri, 06 Dec 2019 11:44:32 +0000
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <20191205180652.18671-1-mark.rutland@arm.com>
References: <20191205180652.18671-1-mark.rutland@arm.com>
Message-ID: <5fdc9f333b8658a73645b6ed40280402@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org,
 alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 kvmarm@lists.cs.columbia.edu, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

On 2019-12-05 18:06, Mark Rutland wrote:
> While testing some other patches, I realised that KVM's logging of
> trapped sysreg accesses can log inconsistent information, and this is
> arguably unnecessary for IMPLEMENTATION DEFINED system registers.
>
> This patches fix that up, ensureing that logged information is
> consistent, and avoiding logging for IMPLEMENTATION DEFINED 
> registers.
>
> Mark.
>
> Mark Rutland (2):
>   kvm/arm64: sanely ratelimit sysreg messages
>   kvm/arm64: don't log IMP DEF sysreg traps
>
>  arch/arm64/kvm/sys_regs.c | 20 ++++++++++++++------
>  arch/arm64/kvm/sys_regs.h | 17 +++++++++++++++--
>  2 files changed, 29 insertions(+), 8 deletions(-)

Applied, thanks.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
