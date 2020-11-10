Return-Path: <SRS0=+U1N=EQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,RCVD_DOTEDU_SUSP,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 913D3C4742C
	for <kvmarm@archiver.kernel.org>; Tue, 10 Nov 2020 14:13:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C0BB620797
	for <kvmarm@archiver.kernel.org>; Tue, 10 Nov 2020 14:13:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="eevBjJdx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C0BB620797
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1ABE44B8BC;
	Tue, 10 Nov 2020 09:13:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5hTDzCvsMkgf; Tue, 10 Nov 2020 09:13:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D689B4B902;
	Tue, 10 Nov 2020 09:13:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 214024B93C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 09:13:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jJ-Z6aaU5Y0D for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Nov 2020 09:13:16 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2277F4B8D0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 09:13:16 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id BB782207E8;
 Tue, 10 Nov 2020 14:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605017594;
 bh=JIJiOB88U7qGpDmmoxCMenpTc0s/h87h3MJM7Q4ZwqA=;
 h=From:To:Cc:Subject:Date:From;
 b=eevBjJdxE5ATVifFoMcdFwRvrDrdPcf5A4Uq/2knK9AMjrV+rWkfyxDhEH01yIWef
 3klarVSpE4HXbH9ai0o4gTWeHp9jseRMkfwBjO6DSQaRxmLxSG8piSTXfX81nNjkn0
 bj3yquDDsN6Py/6sLS8LytdTTa4yjRyN7GGPZc8U=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kcUOW-009T8Q-Da; Tue, 10 Nov 2020 14:13:12 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 0/3] KVM: arm64: Another set of CSV2-related fixes
Date: Tue, 10 Nov 2020 14:13:05 +0000
Message-Id: <20201110141308.451654-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, liangpeng10@huawei.com, will@kernel.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>, kernel-team@android.com
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

This small series addresses a couple of Spectre-v2 related issues:

- Fix a live migration regression introduced with the setting of CSV2
  on systems that are not affected by Spectre-v2, but that don't
  directly expose it in ID_AA64PFR0_EL1

- Inject an UNDEF exception if the guest tries to access any of
  SCXTNUM_ELx, as we don't advertise it to guests.

Patches on top of 5.10-rc2.

* From v1:
  - Only register a new value for CSV2 on a valid write to ID_AA64PFR0_EL1
  - Delete even more code in patch #2

Marc Zyngier (3):
  KVM: arm64: Allow setting of ID_AA64PFR0_EL1.CSV2 from userspace
  KVM: arm64: Unify trap handlers injecting an UNDEF
  KVM: arm64: Handle SCXTNUM_ELx traps

 arch/arm64/include/asm/kvm_host.h |   2 +
 arch/arm64/include/asm/sysreg.h   |   4 ++
 arch/arm64/kvm/arm.c              |  16 +++++
 arch/arm64/kvm/sys_regs.c         | 111 ++++++++++++++++++------------
 4 files changed, 89 insertions(+), 44 deletions(-)

-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
