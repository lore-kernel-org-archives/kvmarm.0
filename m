Return-Path: <SRS0=PxFR=EK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14401C4742C
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:36:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 686BF2083B
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:36:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="GjufsStQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 686BF2083B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D56E94B7A9;
	Wed,  4 Nov 2020 13:36:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZC2fVEKCOD0B; Wed,  4 Nov 2020 13:36:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 153C24B7B1;
	Wed,  4 Nov 2020 13:36:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB9174B55A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:36:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z+BlO5MGgjC2 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2020 13:36:43 -0500 (EST)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8AC974B7A6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:36:43 -0500 (EST)
Received: by mail-wm1-f66.google.com with SMTP id k18so3264885wmj.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2020 10:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=KMYzxJDYxfHlXJHNbiZJ0RtJwPETqciyv+NsXmdBd5Y=;
 b=GjufsStQ+HyoPB83S7Ba9wxZeSrIRXkcXxAxPID7JhjR+e70vcnGKegRMVIYfysv7o
 Aqy9GF51B2tXn8u3oe9zVHDNUbK2UjEYfUl0ImJtzs/qCnSFhbV8uAm01P1AEnwJSTKY
 886tVk2x+NqZ5mbipyudrXGoKPfd75Ue1T3DpW0nxqJunhv6vnfS3Iwujj+lpucAL2j2
 j0mudlvRcrcyi0KAqUQGnQDvtN05+8dSDdGl/vWDpoo8shIIkYtCVWQ7JrYQpG8Ud1tT
 DFeM3GX/XIeyX0MPssEYN6d5bp19EuNjOd7hRYPB3gs5DyH308XmOGyqTzEtvSLxC8S/
 jr5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=KMYzxJDYxfHlXJHNbiZJ0RtJwPETqciyv+NsXmdBd5Y=;
 b=KpFjiiVdF1ZvlQmwV8BYR92qJKwrP7IYkmi1EAqWOFZZS46E8kuNzzpgiAGdOD4Vmi
 Osxt7OvMQXVIqsJOoWN1pIRgt3KbqPnp5PQ2EOHsPMdsWJsx7sd1XMHH7SDWVfOIZX5o
 PJP0wXhAoWdWQezycYxW5ssP4TYS7LlCYCoieYiMi4smCI+TXrmZnS0BHip0M675Vj1n
 N+5ESKzQiN7XdwcYwkyIqKkB6ZKav9FCL8pE5sLPgaFGQgUZvEfV+rtHr9Jxxa+6PbBW
 dH5dIt90Cy2IAbv3qkDMQ6DYgIaJeKoXHuowX9vb4/vzTD3jHhaH/JnQXe1QvOXIcjkG
 sSdA==
X-Gm-Message-State: AOAM531JOk0IH9qAXXOZ+H41i+PQ1RkGbWE0mG54ocT6KPmvFrk9yBPo
 fcaaY37xrex2SCkKo9gAx8BX8lEaheltmK3r
X-Google-Smtp-Source: ABdhPJxe5MqDZ8brVsIs/z3j+gd8UQSoF3AlIuXpflyiQYSloiegdjfrS3Wak4Mz8sQzKefo8pVKsw==
X-Received: by 2002:a7b:c748:: with SMTP id w8mr6054631wmk.32.1604515002281;
 Wed, 04 Nov 2020 10:36:42 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:c8d2:30f2:53c6:bc2])
 by smtp.gmail.com with ESMTPSA id u10sm4014080wrw.36.2020.11.04.10.36.40
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 Nov 2020 10:36:41 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 02/26] psci: Export configured PSCI function IDs
Date: Wed,  4 Nov 2020 18:36:06 +0000
Message-Id: <20201104183630.27513-3-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201104183630.27513-1-dbrazdil@google.com>
References: <20201104183630.27513-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
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

Function IDs used by PSCI are configurable for v0.1 via DT/APCI. If the
host is using PSCI v0.1, KVM's PSCI proxy needs to use the same IDs.
Expose the array holding the information.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 drivers/firmware/psci/psci.c | 10 +---------
 include/linux/psci.h         | 10 ++++++++++
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
index ff523bdbfe3f..ffcb88f60e21 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -60,15 +60,7 @@ typedef unsigned long (psci_fn)(unsigned long, unsigned long,
 				unsigned long, unsigned long);
 static psci_fn *invoke_psci_fn;
 
-enum psci_function {
-	PSCI_FN_CPU_SUSPEND,
-	PSCI_FN_CPU_ON,
-	PSCI_FN_CPU_OFF,
-	PSCI_FN_MIGRATE,
-	PSCI_FN_MAX,
-};
-
-static u32 psci_function_id[PSCI_FN_MAX];
+u32 psci_function_id[PSCI_FN_MAX];
 
 #define PSCI_0_2_POWER_STATE_MASK		\
 				(PSCI_0_2_POWER_STATE_ID_MASK | \
diff --git a/include/linux/psci.h b/include/linux/psci.h
index cb35b90d1746..877d844ee6d9 100644
--- a/include/linux/psci.h
+++ b/include/linux/psci.h
@@ -29,6 +29,16 @@ bool psci_has_osi_support(void);
  */
 extern int psci_driver_version;
 
+enum psci_function {
+	PSCI_FN_CPU_SUSPEND,
+	PSCI_FN_CPU_ON,
+	PSCI_FN_CPU_OFF,
+	PSCI_FN_MIGRATE,
+	PSCI_FN_MAX,
+};
+
+extern u32 psci_function_id[PSCI_FN_MAX];
+
 struct psci_operations {
 	u32 (*get_version)(void);
 	int (*cpu_suspend)(u32 state, unsigned long entry_point);
-- 
2.29.1.341.ge80a0c044ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
