Return-Path: <SRS0=aM0J=O7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B757C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 10:57:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9C91A60EE2
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 10:57:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9C91A60EE2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14E944B0F1;
	Mon, 11 Oct 2021 06:57:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sZITGfFf668Y; Mon, 11 Oct 2021 06:57:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D6FA24B0B9;
	Mon, 11 Oct 2021 06:57:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C96014B093
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 06:57:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SRbFotm2tcb9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Oct 2021 06:57:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7600407F1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 06:57:14 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 24810ED1;
 Mon, 11 Oct 2021 03:57:14 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F1F3D3F66F;
 Mon, 11 Oct 2021 03:57:12 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com,
 drjones@redhat.com
Subject: [PATCH v2 0/3] KVM: arm64: Minor improvements to RAZ register handling
Date: Mon, 11 Oct 2021 11:58:37 +0100
Message-Id: <20211011105840.155815-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
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

What sparked these small patches is the series that fixed the PMU reset
values and their visibility from userspace, more specifically the
discussion around the patch that removed the PMSWINC_EL0 shadow register
[1].

The patches are straightforward cleanups without any changes in
functionality.

Tested on a rockpro64, by running kvm-unit-tests under qemu.

Changes in v2:

* Added patch #3 ("KVM: arm64: Replace get_raz_id_reg() with get_raz_reg()"), as
  suggested by Drew.
* Rebased on top of v5.15-rc5.
* Gathered Reviewed-by, thanks!
* A few small commit message changes to patch #1.

[1] https://www.spinics.net/lists/kvm-arm/msg47976.html

Alexandru Elisei (3):
  KVM: arm64: Return early from read_id_reg() if register is RAZ
  KVM: arm64: Use get_raz_reg() for userspace reads of PMSWINC_EL0
  KVM: arm64: Replace get_raz_id_reg() with get_raz_reg()

 arch/arm64/kvm/sys_regs.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

-- 
2.33.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
