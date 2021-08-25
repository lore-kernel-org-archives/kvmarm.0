Return-Path: <SRS0=u4Cy=NQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 343F1C432BE
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:18:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DC22C611F0
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:18:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DC22C611F0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 911454B27D;
	Wed, 25 Aug 2021 12:18:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id si8yWDWrIREw; Wed, 25 Aug 2021 12:18:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24F9A4B2A3;
	Wed, 25 Aug 2021 12:17:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA4834B205
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:17:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yXmmoyxYhP7F for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Aug 2021 12:17:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0851F4B249
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:17:27 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9EACF1063;
 Wed, 25 Aug 2021 09:17:26 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5044F3F66F;
 Wed, 25 Aug 2021 09:17:25 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 09/39] KVM: Add kvm_warn{,_ratelimited} macros
Date: Wed, 25 Aug 2021 17:17:45 +0100
Message-Id: <20210825161815.266051-10-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210825161815.266051-1-alexandru.elisei@arm.com>
References: <20210825161815.266051-1-alexandru.elisei@arm.com>
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

Add the kvm_warn() and kvm_warn_ratelimited() macros to print a kernel
warning.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 include/linux/kvm_host.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ae7735b490b4..ada5019ad93d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -605,6 +605,10 @@ struct kvm {
 
 #define kvm_err(fmt, ...) \
 	pr_err("kvm [%i]: " fmt, task_pid_nr(current), ## __VA_ARGS__)
+#define kvm_warn(fmt, ...) \
+	pr_warn("kvm [%i]: " fmt, task_pid_nr(current), ## __VA_ARGS__)
+#define kvm_warn_ratelimited(fmt, ...) \
+	pr_warn_ratelimited("kvm [%i]: " fmt, task_pid_nr(current), ## __VA_ARGS__)
 #define kvm_info(fmt, ...) \
 	pr_info("kvm [%i]: " fmt, task_pid_nr(current), ## __VA_ARGS__)
 #define kvm_debug(fmt, ...) \
-- 
2.33.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
