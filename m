Return-Path: <SRS0=s1GN=FF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A85C64E7B
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 15:00:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5C7EF208FE
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 15:00:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C7EF208FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96B414C2A7;
	Tue,  1 Dec 2020 10:00:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ngDQM0WYOk+l; Tue,  1 Dec 2020 10:00:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A86F4C269;
	Tue,  1 Dec 2020 10:00:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBCF54B1DF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 10:00:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BBVFWusHPi-y for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2020 10:00:42 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8AEF4C1CD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 10:00:42 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5D3AA1042;
 Tue,  1 Dec 2020 07:00:42 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F6D13F575;
 Tue,  1 Dec 2020 07:00:41 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com
Subject: [PATCH 1/5] KVM: Documentation: Add arm64 KVM_RUN error codes
Date: Tue,  1 Dec 2020 15:01:53 +0000
Message-Id: <20201201150157.223625-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201150157.223625-1-alexandru.elisei@arm.com>
References: <20201201150157.223625-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: Paolo Bonzini <pbonzini@redhat.com>
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
---
 Documentation/virt/kvm/api.rst | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 36d5f1f3c6dd..090a2331b1f2 100644
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
