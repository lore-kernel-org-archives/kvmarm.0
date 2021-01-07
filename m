Return-Path: <SRS0=9u6M=GK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ED54C433E6
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jan 2021 11:21:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D5A0823343
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jan 2021 11:21:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D5A0823343
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DAE14B3E9;
	Thu,  7 Jan 2021 06:21:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qnA2VxlHe+Ch; Thu,  7 Jan 2021 06:21:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFCA14B3CE;
	Thu,  7 Jan 2021 06:21:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 465E94B3C0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2021 06:21:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JbOdDj1MsfMH for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Jan 2021 06:21:29 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7F68B4B3CB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2021 06:21:26 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 926A92333F;
 Thu,  7 Jan 2021 11:21:25 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kxTM3-005p1o-Ny; Thu, 07 Jan 2021 11:21:23 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 09/18] KVM: Documentation: Add arm64 KVM_RUN error codes
Date: Thu,  7 Jan 2021 11:20:52 +0000
Message-Id: <20210107112101.2297944-10-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107112101.2297944-1-maz@kernel.org>
References: <20210107112101.2297944-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 catalin.marinas@arm.com, dbrazdil@google.com, eric.auger@redhat.com,
 mark.rutland@arm.com, natechancellor@gmail.com, qcai@redhat.com,
 shannon.zhao@linux.alibaba.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvm@vger.kernel.org, Qian Cai <qcai@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Shannon Zhao <shannon.zhao@linux.alibaba.com>,
 linux-arm-kernel@lists.infradead.org,
 Nathan Chancellor <natechancellor@gmail.com>, kvmarm@lists.cs.columbia.edu
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

From: Alexandru Elisei <alexandru.elisei@arm.com>

The API documentation states that general error codes are not detailed, but
errors with specific meanings are. On arm64, KVM_RUN can return error
numbers with a different meaning than what is described by POSIX or the C99
standard (as taken from man 3 errno).

Absent from the newly documented error codes is ERANGE which can be
returned when making a change to the EL2 stage 1 tables if the address is
larger than the largest supported input address. Assuming no bugs in the
implementation, that is not possible because the input addresses which are
mapped are the result of applying the macro kern_hyp_va() on kernel virtual
addresses.

CC: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20201201150157.223625-2-alexandru.elisei@arm.com
---
 Documentation/virt/kvm/api.rst | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e00a66d72372..4e5316ed10e9 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -380,9 +380,14 @@ This ioctl is obsolete and has been removed.
 
 Errors:
 
-  =====      =============================
+  =======    ==============================================================
   EINTR      an unmasked signal is pending
-  =====      =============================
+  ENOEXEC    the vcpu hasn't been initialized or the guest tried to execute
+             instructions from device memory (arm64)
+  ENOSYS     data abort outside memslots with no syndrome info and
+             KVM_CAP_ARM_NISV_TO_USER not enabled (arm64)
+  EPERM      SVE feature set but not finalized (arm64)
+  =======    ==============================================================
 
 This ioctl is used to run a guest virtual cpu.  While there are no
 explicit parameters, there is an implicit parameter block that can be
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
