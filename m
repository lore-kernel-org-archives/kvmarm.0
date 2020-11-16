Return-Path: <SRS0=JeL3=EW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41A3BC4742C
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:43:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A25492224F
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:43:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="LpPgLYJo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A25492224F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B9BA4C24B;
	Mon, 16 Nov 2020 15:43:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WRWjFBxpa2DM; Mon, 16 Nov 2020 15:43:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33D354C1E0;
	Mon, 16 Nov 2020 15:43:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A331A4C19D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:43:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5vAPySG1hCIV for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2020 15:43:28 -0500 (EST)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A24A94C252
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:43:28 -0500 (EST)
Received: by mail-wr1-f65.google.com with SMTP id p8so20290979wrx.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 12:43:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=HBK5eZkVMoQritbd0wCyBeq8n+u1kTTgyjfghI2qI2A=;
 b=LpPgLYJoCTv1oHKKJjTShTeJ0/jzOj8483R1CyGe1/2yiVHw7V+amuY2dvDpQHINYo
 B71XuITyMBPai4U5C6bwKeUbWwMyZoqtuG+ktdinJPefMIYT5OKiw4TZp1VA2qnS0Y7i
 qNcxpiT4Yiep08Ci0LKvyduGtf9H/28dn9zw9DWwG8kr7EwA668DtdnfK4Mnx7PrfUdl
 D2iNXtKU2gxvyT50AqnyqkyBUsEGaZHkJ6nfWFso5KbSeHu4i5iIOb/OtoKv+e4Nf+oI
 vzovOiJ+Q4vTPXfsSSvudXA8WMmsl8qtUik5L4t7/Oc1UtHytqTGpUI4dciQJHhRjFre
 TEjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=HBK5eZkVMoQritbd0wCyBeq8n+u1kTTgyjfghI2qI2A=;
 b=uWZVTy+pJ82ccscBboCeHj/uN4SM4tWGUI9h+UcY+wssx2jBUfvpr7MymhY3DeyLB1
 OJboyZU57g3gJvgeD7ATGlJgxdgJCpuy8Fp8j9H3sbA9g2Hydnp6aKGYUNo208dW+Pin
 MvXWzHvvlgBRcAJiPAaWgFIKJcGr7bgBnpOFg2feYfPMZoZzNfnY7mAh+TiYxmvQLRa1
 gaNydjHE9XmVigiGyIy4OniBD1xZY8/rbz1yep8589XATTIRaKWDNOhMIT/A1mWEK+FF
 FOO90cWe4hx5AwR/5ZTsPd0/69Lf0Y1kw8JWiDJO/ays4nuj5P+KJo9Q3jZg7d2Bbjl5
 W0Uw==
X-Gm-Message-State: AOAM530bIGBU3x/o738tyberhjORl3jgJRWDTk9Gq1XIMzhbLwYpCwsp
 aZl321z89xDeA9IqFbAnxg2BFtFw2MxKapusZ0M=
X-Google-Smtp-Source: ABdhPJw6INFk2z1GcoyqqnoLQUKmvHq4aEzJ1qjQiEeW2TjsoBHTbzNVv6avTC1esSkrC1mwnL7QGg==
X-Received: by 2002:adf:a40c:: with SMTP id d12mr21800321wra.154.1605559407257; 
 Mon, 16 Nov 2020 12:43:27 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:bc40:bd71:373a:1b33])
 by smtp.gmail.com with ESMTPSA id o10sm516959wma.47.2020.11.16.12.43.25
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 16 Nov 2020 12:43:26 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 02/24] psci: Accessor for configured PSCI function IDs
Date: Mon, 16 Nov 2020 20:42:56 +0000
Message-Id: <20201116204318.63987-3-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116204318.63987-1-dbrazdil@google.com>
References: <20201116204318.63987-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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
host is using PSCI v0.1, KVM's host PSCI proxy needs to use the same IDs.
Expose the array holding the information with a read-only accessor.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 drivers/firmware/psci/psci.c | 14 ++++++--------
 include/linux/psci.h         | 10 ++++++++++
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
index 213c68418a65..d835f3d8b121 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -58,16 +58,14 @@ typedef unsigned long (psci_fn)(unsigned long, unsigned long,
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
 static u32 psci_function_id[PSCI_FN_MAX];
 
+u32 psci_get_function_id(enum psci_function fn)
+{
+	WARN_ON(fn >= PSCI_FN_MAX);
+	return psci_function_id[fn];
+}
+
 #define PSCI_0_2_POWER_STATE_MASK		\
 				(PSCI_0_2_POWER_STATE_ID_MASK | \
 				PSCI_0_2_POWER_STATE_TYPE_MASK | \
diff --git a/include/linux/psci.h b/include/linux/psci.h
index 2a1bfb890e58..5b49a5c82d6f 100644
--- a/include/linux/psci.h
+++ b/include/linux/psci.h
@@ -21,6 +21,16 @@ bool psci_power_state_is_valid(u32 state);
 int psci_set_osi_mode(bool enable);
 bool psci_has_osi_support(void);
 
+enum psci_function {
+	PSCI_FN_CPU_SUSPEND,
+	PSCI_FN_CPU_ON,
+	PSCI_FN_CPU_OFF,
+	PSCI_FN_MIGRATE,
+	PSCI_FN_MAX,
+};
+
+u32 psci_get_function_id(enum psci_function fn);
+
 struct psci_operations {
 	u32 (*get_version)(void);
 	int (*cpu_suspend)(u32 state, unsigned long entry_point);
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
