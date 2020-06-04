Return-Path: <SRS0=AWUd=7R=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 993A5C433E3
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jun 2020 13:34:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1F83620772
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jun 2020 13:34:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="PNA+5znU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F83620772
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A574D4B32F;
	Thu,  4 Jun 2020 09:34:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QK7c+mThwyPD; Thu,  4 Jun 2020 09:34:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A2684B346;
	Thu,  4 Jun 2020 09:34:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A9574B2FE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jun 2020 09:34:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yerUg2YVPu1X for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Jun 2020 09:34:06 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 290C24B325
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jun 2020 09:34:06 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 099E120772;
 Thu,  4 Jun 2020 13:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1591277645;
 bh=rcP0ID3sZv+j+DKkPTrcUriG90Uun00qknLwobPg9EU=;
 h=From:To:Cc:Subject:Date:From;
 b=PNA+5znUqtVizpteIx5iiQH+oJlxiDqad2kOGfq9Qemb6XNvFMSy8+8BhCaCxVeYF
 DuC1RWChGU82A86yA3iGVXIOGL7Ke90uWaxbkMVFnsbCI86sf594bpQ2s6Wy1we3xu
 1LTE4mL0vo8yyu7tdIuAujVsdbNWI+0X6xczLYIk=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jgq0R-000G3O-GP; Thu, 04 Jun 2020 14:34:03 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/3] kvm: arm64: Pointer Authentication handling fixes
Date: Thu,  4 Jun 2020 14:33:51 +0100
Message-Id: <20200604133354.1279412-1-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, will@kernel.org,
 catalin.marinas@arm.com, mark.rutland@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
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

I recently discovered that the Pointer Authentication (PtrAuth)
handling code in KVM is busted, and has been for a while. The main
issue is that the we save the host's keys from a preemptible
context. Things will go wrong at some point.

In order to address this, the first patch move the saving of the
host's keys to vcpu_load(). It is done eagerly, which is a bore, but
is at least safe. This is definitely stable material.

The following two patches are adding an optimisation and a fix for a
corner case: we handle key saving and HCR massaging as a fixup, much
like the FPSIMD code. This subsequently allows us to deal with the
ugly case of a guest enabling PtrAuth despite it not being advertised,
resulting in PAC instructions UNDEF'ing while they should be NOPs.

This has been very lightly tested on a model.

Marc Zyngier (3):
  KVM: arm64: Save the host's PtrAuth keys in non-preemptible context
  KVM: arm64: Handle PtrAuth traps early
  KVM: arm64: Enforce PtrAuth being disabled if not advertized

 arch/arm64/include/asm/kvm_emulate.h |  6 ---
 arch/arm64/kvm/arm.c                 |  3 +-
 arch/arm64/kvm/handle_exit.c         | 38 ---------------
 arch/arm64/kvm/hyp/switch.c          | 73 ++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c            | 13 ++---
 5 files changed, 80 insertions(+), 53 deletions(-)

-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
