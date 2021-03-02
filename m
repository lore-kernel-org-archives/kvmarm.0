Return-Path: <SRS0=a/wb=IA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED10C433DB
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 18:20:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0927B64F1F
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 18:20:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0927B64F1F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 60B324B6C8;
	Tue,  2 Mar 2021 13:20:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8Iib1qKJn6rQ; Tue,  2 Mar 2021 13:20:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F1114B6C9;
	Tue,  2 Mar 2021 13:20:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35C0E4B31E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 11:49:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qVYLGlnMpSiH for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Mar 2021 11:49:17 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DD1F4B31D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 11:49:17 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A6DA1FB;
 Tue,  2 Mar 2021 08:49:16 -0800 (PST)
Received: from e120529.arm.com (unknown [10.37.8.4])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F7493F7D7;
 Tue,  2 Mar 2021 08:49:13 -0800 (PST)
From: Daniel Kiss <daniel.kiss@arm.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 0/1] kvm: arm64: Add SVE support for nVHE.
Date: Tue,  2 Mar 2021 17:48:49 +0100
Message-Id: <20210302164850.3553701-1-daniel.kiss@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
X-Mailman-Approved-At: Tue, 02 Mar 2021 13:20:42 -0500
Cc: maz@kernel.org, broonie@kernel.org, linux-arm-kernel@lists.infradead.org,
 Dave.Martin@arm.com, Daniel Kiss <daniel.kiss@arm.com>
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

Addressing review comments from the previous version[1].
The discussed optimisation will be a sparate patch later.

[1] https://www.spinics.net/lists/arm-kernel/msg874768.html

Changes from v2:
* Comments are addressed.
* rebased to v5.11

Changes from v1:
* Vector length handling is changed.

Daniel Kiss (1):
  kvm: arm64: Add SVE support for nVHE.

 arch/arm64/Kconfig                      |  7 -----
 arch/arm64/include/asm/el2_setup.h      |  2 +-
 arch/arm64/include/asm/fpsimd.h         |  6 ++++
 arch/arm64/include/asm/fpsimdmacros.h   | 24 ++++++++++++++--
 arch/arm64/include/asm/kvm_arm.h        |  6 ++++
 arch/arm64/include/asm/kvm_host.h       | 17 +++--------
 arch/arm64/kernel/entry-fpsimd.S        |  5 ----
 arch/arm64/kvm/arm.c                    |  5 ----
 arch/arm64/kvm/fpsimd.c                 | 38 ++++++++++++++++++++-----
 arch/arm64/kvm/hyp/fpsimd.S             | 15 ++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 34 +++++++++++-----------
 arch/arm64/kvm/hyp/nvhe/switch.c        | 24 ++++++++++++++++
 arch/arm64/kvm/reset.c                  |  4 ---
 13 files changed, 127 insertions(+), 60 deletions(-)

-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
