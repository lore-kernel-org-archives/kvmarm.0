Return-Path: <SRS0=ZrZ1=SU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF85EC10F14
	for <kvmarm@archiver.kernel.org>; Thu, 18 Apr 2019 16:08:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 71D6C20693
	for <kvmarm@archiver.kernel.org>; Thu, 18 Apr 2019 16:08:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71D6C20693
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A4024A555;
	Thu, 18 Apr 2019 12:08:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FnPNFa4QlAYf; Thu, 18 Apr 2019 12:08:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB5F84A54D;
	Thu, 18 Apr 2019 12:08:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 16E334A51E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Apr 2019 12:08:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mcp7k03a9t2v for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Apr 2019 12:08:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7A524A4FD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Apr 2019 12:08:26 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 604FD15AB;
 Thu, 18 Apr 2019 09:08:26 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1FF4B3F5AF;
 Thu, 18 Apr 2019 09:08:23 -0700 (PDT)
From: Dave Martin <Dave.Martin@arm.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 12/14] KVM: Clarify capability requirements for
 KVM_ARM_VCPU_FINALIZE
Date: Thu, 18 Apr 2019 17:07:09 +0100
Message-Id: <1555603631-8107-13-git-send-email-Dave.Martin@arm.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1555603631-8107-1-git-send-email-Dave.Martin@arm.com>
References: <1555603631-8107-1-git-send-email-Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>,
 Christoffer Dall <cdall@kernel.org>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Julien Grall <julien.grall@arm.com>, linux-arm-kernel@lists.infradead.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190418160709.8gvQvEam4A7AfQ74w66EBqY7Lu95biCGp85IVw89Cso@z>

Userspace is only supposed to use KVM_ARM_VCPU_FINALIZE when there
is some vcpu feature that can actually be finalized.

This means that documenting KVM_ARM_VCPU_FINALIZE as available or
not depending on the capabilities present is not helpful.

This patch amends the documentation to describe availability in
terms of which capability is required for each finalizable feature
instead.

In any case, userspace sees the same error (EINVAL) regardless of
whether the given feature is not present or KVM_ARM_VCPU_FINALIZE
is not implemented at all.

No functional change.

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 Documentation/virtual/kvm/api.txt | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 03df379..5519df0 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -3999,17 +3999,16 @@ userspace should not expect to get any particular value there.
 
 4.119 KVM_ARM_VCPU_FINALIZE
 
-Capability: KVM_CAP_ARM_SVE
 Architectures: arm, arm64
 Type: vcpu ioctl
 Parameters: int feature (in)
 Returns: 0 on success, -1 on error
 Errors:
   EPERM:     feature not enabled, needs configuration, or already finalized
-  EINVAL:    unknown feature
+  EINVAL:    feature unknown or not present
 
 Recognised values for feature:
-  arm64      KVM_ARM_VCPU_SVE
+  arm64      KVM_ARM_VCPU_SVE (requires KVM_CAP_ARM_SVE)
 
 Finalizes the configuration of the specified vcpu feature.
 
-- 
2.1.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
