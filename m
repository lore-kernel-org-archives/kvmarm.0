Return-Path: <SRS0=WvL8=E7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74D29C5519F
	for <kvmarm@archiver.kernel.org>; Wed, 25 Nov 2020 13:33:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B6771206F7
	for <kvmarm@archiver.kernel.org>; Wed, 25 Nov 2020 13:33:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="QT9LtFym"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6771206F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 040E34B880;
	Wed, 25 Nov 2020 08:33:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iXRDLhLnQ3HC; Wed, 25 Nov 2020 08:33:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B2D94B877;
	Wed, 25 Nov 2020 08:33:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE14B4B849
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Nov 2020 08:33:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dt6ZjlIoFIrJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Nov 2020 08:33:25 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AEA794B7D7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Nov 2020 08:33:25 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5497C206E5;
 Wed, 25 Nov 2020 13:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606311204;
 bh=qMR4WaI/ekNVGzswOam38uhrE/iZ8ZA6U592n3HBsvA=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=QT9LtFymLx8QxE54gU6H9wvWBf3Zmp2NL62G/yRo5IKH1uA1RS5ZMlF9xlm4NUh8n
 KKoc2BajuiVZdWaWJgwSsSGyR3SvLPOooBFuUMJFByB62z3+8WM4xF2p2zkARFkQnT
 DALFOGDQb1xluXHCpLujP+PjetHuUrGfCRAtlt2g=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1khuvC-00DXJl-9S; Wed, 25 Nov 2020 13:33:22 +0000
MIME-Version: 1.0
Date: Wed, 25 Nov 2020 13:33:22 +0000
From: Marc Zyngier <maz@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v2 04/24] arm64: Move MAIR_EL1_SET to asm/memory.h
In-Reply-To: <20201125132617.qf6vd752dtfasyi7@google.com>
References: <20201116204318.63987-1-dbrazdil@google.com>
 <20201116204318.63987-5-dbrazdil@google.com> <87mtz85geh.wl-maz@kernel.org>
 <20201125103137.iml7mqpzhylldvqy@google.com>
 <e6c9184c6ee986d134625932b4fa8e89@kernel.org>
 <20201125132617.qf6vd752dtfasyi7@google.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <a37ac792b61d4931d0b4d1356e96415e@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: dbrazdil@google.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, will@kernel.org, dennis@kernel.org, tj@kernel.org,
 cl@linux.com, mark.rutland@arm.com, lorenzo.pieralisi@arm.com,
 qperret@google.com, ascull@google.com, qwandor@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, Will Deacon <will@kernel.org>,
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

On 2020-11-25 13:26, David Brazdil wrote:

>> I came up with the following patch on top of this series that seems to
>> compile without issue.
> 
> That seems to have an implicit dependency of sysreg.h on memory.h, 
> doesn't it?
> I had it the other way round initially. I also tried including memory.h 
> in
> sysreg.h. That creates a circular dependency mmdebug.h -> bug.h -> ... 
> ->
> sysreg.h -> memory.h -> mmdebug.h. Pretty annoying. I could try to fix 
> that,
> or create a new header file... :(

I don't think we need this. Any low-level source using MAIR_ELx_SET is 
bound
to require memory.h as well, one way or another. As this is all 
#defines,
it won't break anything unless actively used.

And given that this is used in exactly *two* places, I don't believe 
there
is a need for over-engineering this.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
