Return-Path: <SRS0=1hyK=BH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20F66C433DF
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jul 2020 11:04:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9BD80204EA
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jul 2020 11:04:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZVv5HUnM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9BD80204EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B9434B9D1;
	Tue, 28 Jul 2020 07:04:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DYouHZSyu1QE; Tue, 28 Jul 2020 07:04:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F5744B9A7;
	Tue, 28 Jul 2020 07:04:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C25F34B99E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2020 07:04:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JYMkEOPg54iO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jul 2020 07:04:38 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D41594B9A7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2020 07:04:38 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9A570204EA;
 Tue, 28 Jul 2020 11:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1595934277;
 bh=DgU4yKbmp8OwurHB5DLCGWi9A01qQNe/KIyrPlNU668=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=ZVv5HUnMOVp2vHnZ9/jtVS2y/XyBACUo9eSxXbsVecuIY/cF0jYniuWzpdyF237jW
 bM6z0VJwVTsJBMSyi4czmL0gVP2+4XvXlcYnaRF2dC0KH1ocPws2APpXg/68W+2rE9
 DZ84dmgv9dkZZJLwx+eHIxFkWz332B+nJWqx/PVc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k0NPQ-00FczY-4W; Tue, 28 Jul 2020 12:04:36 +0100
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 James Morse <james.morse@arm.com>, David Brazdil <dbrazdil@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 0/2] Unify non-VHE ASLR features behind
 CONFIG_RANDOMIZE_BASE
Date: Tue, 28 Jul 2020 12:04:31 +0100
Message-Id: <159593423897.3960510.2442620106516348363.b4-ty@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200721094445.82184-1-dbrazdil@google.com>
References: <20200721094445.82184-1-dbrazdil@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: will@kernel.org, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, james.morse@arm.com, dbrazdil@google.com,
 catalin.marinas@arm.com, android-kvm@google.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: android-kvm@google.com, kernel-team@android.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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

On Tue, 21 Jul 2020 10:44:43 +0100, David Brazdil wrote:
> There is currently no way to disable nVHE ASLR, e.g. for debugging, so the
> first patch in this series makes it conditional on RANDOMIZE_BASE, same as
> KASLR. Note that the 'nokaslr' command line flag has no effect here.
> 
> Second patch unifies the HARDEN_EL2_VECTORS errate for A57 and A72 behind
> the same Kconfig for simplicity. Happy to make it just depend on
> RANDOMIZE_BASE if having an option to keep randomization on but hardenning
> off is preferred.
> 
> [...]

Applied to kvm-arm64/misc-5.9, thanks!

[1/2] KVM: arm64: Make nVHE ASLR conditional on RANDOMIZE_BASE
      commit: 24f69c0fa4e252f706884114b7d6353aa07678b5
[2/2] KVM: arm64: Substitute RANDOMIZE_BASE for HARDEN_EL2_VECTORS
      commit: a59a2edbbba7397fede86e40a3da17e5beebf98b

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
