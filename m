Return-Path: <SRS0=WQmE=TD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41223C004C9
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:44:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 00F132075E
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:44:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00F132075E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F0BA4A514;
	Fri,  3 May 2019 08:44:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3BajkTbYYbDI; Fri,  3 May 2019 08:44:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 511C04A509;
	Fri,  3 May 2019 08:44:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 054B44A4BC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:44:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 75cQLOfcJQb7 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 May 2019 08:44:47 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E23604A4CB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:44:46 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5299C374;
 Fri,  3 May 2019 05:44:46 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1BDE43F220;
 Fri,  3 May 2019 05:44:42 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 01/56] KVM: Documentation: Document arm64 core registers in
 detail
Date: Fri,  3 May 2019 13:43:32 +0100
Message-Id: <20190503124427.190206-2-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 "zhang . lei" <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>,
 kvmarm@lists.cs.columbia.edu, Amit Daniel Kachhap <amit.kachhap@arm.com>,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
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

From: Dave Martin <Dave.Martin@arm.com>

Since the the sizes of individual members of the core arm64
registers vary, the list of register encodings that make sense is
not a simple linear sequence.

To clarify which encodings to use, this patch adds a brief list
to the documentation.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Julien Grall <julien.grall@arm.com>
Reviewed-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 Documentation/virtual/kvm/api.txt | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 7de9eee73fcd..2d4f7ce5e967 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2107,6 +2107,30 @@ contains elements ranging from 32 to 128 bits. The index is a 32bit
 value in the kvm_regs structure seen as a 32bit array.
   0x60x0 0000 0010 <index into the kvm_regs struct:16>
 
+Specifically:
+    Encoding            Register  Bits  kvm_regs member
+----------------------------------------------------------------
+  0x6030 0000 0010 0000 X0          64  regs.regs[0]
+  0x6030 0000 0010 0002 X1          64  regs.regs[1]
+    ...
+  0x6030 0000 0010 003c X30         64  regs.regs[30]
+  0x6030 0000 0010 003e SP          64  regs.sp
+  0x6030 0000 0010 0040 PC          64  regs.pc
+  0x6030 0000 0010 0042 PSTATE      64  regs.pstate
+  0x6030 0000 0010 0044 SP_EL1      64  sp_el1
+  0x6030 0000 0010 0046 ELR_EL1     64  elr_el1
+  0x6030 0000 0010 0048 SPSR_EL1    64  spsr[KVM_SPSR_EL1] (alias SPSR_SVC)
+  0x6030 0000 0010 004a SPSR_ABT    64  spsr[KVM_SPSR_ABT]
+  0x6030 0000 0010 004c SPSR_UND    64  spsr[KVM_SPSR_UND]
+  0x6030 0000 0010 004e SPSR_IRQ    64  spsr[KVM_SPSR_IRQ]
+  0x6060 0000 0010 0050 SPSR_FIQ    64  spsr[KVM_SPSR_FIQ]
+  0x6040 0000 0010 0054 V0         128  fp_regs.vregs[0]
+  0x6040 0000 0010 0058 V1         128  fp_regs.vregs[1]
+    ...
+  0x6040 0000 0010 00d0 V31        128  fp_regs.vregs[31]
+  0x6020 0000 0010 00d4 FPSR        32  fp_regs.fpsr
+  0x6020 0000 0010 00d5 FPCR        32  fp_regs.fpcr
+
 arm64 CCSIDR registers are demultiplexed by CSSELR value:
   0x6020 0000 0011 00 <csselr:8>
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
