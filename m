Return-Path: <SRS0=un+q=B4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D304C433DF
	for <kvmarm@archiver.kernel.org>; Tue, 18 Aug 2020 10:34:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8899F207FB
	for <kvmarm@archiver.kernel.org>; Tue, 18 Aug 2020 10:34:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="YxVcWajo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8899F207FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E1524BD79;
	Tue, 18 Aug 2020 06:34:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IlwcV91kxaeb; Tue, 18 Aug 2020 06:34:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED8DF4BEDF;
	Tue, 18 Aug 2020 06:34:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CBF64BE04
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Aug 2020 06:34:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F4xRLTZBMsRM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Aug 2020 06:34:26 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7FE764BD79
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Aug 2020 06:34:26 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5842B2075E;
 Tue, 18 Aug 2020 10:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1597746865;
 bh=4RQGb2A7yfUC/cTbElTMskDSYGMeQDBt6Q0bd2Jz0tc=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=YxVcWajoVivmrZvy6C50qbHAiEH2qP1eq0Sm3P+CT2LbvmV0bs+lT1eHK5bIJaKKP
 y8rE8XEqQEhXCcaM/um0atmR2cFUleRSuOnG3x8SLCrKti3aBLHGtcz1DK7Sp7Iinh
 a+mNp7UzQEdsunWDcLTp4z04FJmUb9vY4scDFy8U=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k7ywh-003rus-OC; Tue, 18 Aug 2020 11:34:23 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>
Subject: Re: [PATCH 0/2] KVM: arm64: Fix sleeping while atomic BUG() on OOM
Date: Tue, 18 Aug 2020 11:34:20 +0100
Message-Id: <159774684758.2661110.9212490740883121538.b4-ty@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200811102725.7121-1-will@kernel.org>
References: <20200811102725.7121-1-will@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, will@kernel.org, suzuki.poulose@arm.com,
 pbonzini@redhat.com, james.morse@arm.com, sean.j.christopherson@intel.com,
 tsbogend@alpha.franken.de, paulus@ozlabs.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Paul Mackerras <paulus@ozlabs.org>, Paolo Bonzini <pbonzini@redhat.com>
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

On Tue, 11 Aug 2020 11:27:23 +0100, Will Deacon wrote:
> While stress-testing my arm64 stage-2 page-table rewrite [1], I ran into
> a sleeping while atomic BUG() during OOM that I can reproduce with
> mainline.
> 
> The problem is that the arm64 page-table code periodically calls
> cond_resched_lock() when unmapping the stage-2 page-tables, but in the
> case of OOM, this occurs in atomic context.
> 
> [...]

Applied to kvm-arm64/pt-rework-base, thanks!

[1/2] KVM: Pass MMU notifier range flags to kvm_unmap_hva_range()
      commit: 462a296d8a2004063ab3c6b4df07d6f165786734
[2/2] KVM: arm64: Only reschedule if MMU_NOTIFIER_RANGE_BLOCKABLE is not set
      commit: 78dcf128f9bb3a6a3950a21cf097cdc48cf3f505

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
