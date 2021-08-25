Return-Path: <SRS0=u4Cy=NQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 655DDC4338F
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:20:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1605561153
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:20:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1605561153
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBBB44B236;
	Wed, 25 Aug 2021 12:20:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VA-MyFkYBtks; Wed, 25 Aug 2021 12:20:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0044C4B28F;
	Wed, 25 Aug 2021 12:19:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE3504B230
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:19:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aVE1ZLIht5gB for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Aug 2021 12:19:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 212EC4B265
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:18:52 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DBE051042;
 Wed, 25 Aug 2021 09:18:51 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D21553F66F;
 Wed, 25 Aug 2021 09:18:50 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH v4 kvmtool 3/5] init: Add last_{init, exit} list macros
Date: Wed, 25 Aug 2021 17:19:56 +0100
Message-Id: <20210825161958.266411-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210825161958.266411-1-alexandru.elisei@arm.com>
References: <20210825161958.266411-1-alexandru.elisei@arm.com>
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

Add a last_init macro for constructor functions that will be executed last
in the initialization process. Add a symmetrical macro, last_exit, for
destructor functions that will be the last to be executed when kvmtool
exits.

The list priority for the late_{init, exit} macros has been bumped down a
spot, but their relative priority remains unchanged, to keep the same size
for the init_lists and exit_lists.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 include/kvm/util-init.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/kvm/util-init.h b/include/kvm/util-init.h
index 13d4f04df678..e6a0e1696689 100644
--- a/include/kvm/util-init.h
+++ b/include/kvm/util-init.h
@@ -39,7 +39,8 @@ static void __attribute__ ((constructor)) __init__##cb(void)		\
 #define dev_init(cb) __init_list_add(cb, 5)
 #define virtio_dev_init(cb) __init_list_add(cb, 6)
 #define firmware_init(cb) __init_list_add(cb, 7)
-#define late_init(cb) __init_list_add(cb, 9)
+#define late_init(cb) __init_list_add(cb, 8)
+#define last_init(cb) __init_list_add(cb, 9)
 
 #define core_exit(cb) __exit_list_add(cb, 0)
 #define base_exit(cb) __exit_list_add(cb, 2)
@@ -47,5 +48,6 @@ static void __attribute__ ((constructor)) __init__##cb(void)		\
 #define dev_exit(cb) __exit_list_add(cb, 5)
 #define virtio_dev_exit(cb) __exit_list_add(cb, 6)
 #define firmware_exit(cb) __exit_list_add(cb, 7)
-#define late_exit(cb) __exit_list_add(cb, 9)
+#define late_exit(cb) __exit_list_add(cb, 8)
+#define last_exit(cb) __exit_list_add(cb, 9)
 #endif
-- 
2.33.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
