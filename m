Return-Path: <SRS0=PxFR=EK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A3A3C55178
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:36:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 78D4320719
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:36:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="i5BcYNcM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 78D4320719
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F15584B79C;
	Wed,  4 Nov 2020 13:36:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q5IVWmNOhbUX; Wed,  4 Nov 2020 13:36:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E537C4B79E;
	Wed,  4 Nov 2020 13:36:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6950D4B561
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:36:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bLf5Pa1Amo8Z for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2020 13:36:41 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5F0234B543
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:36:41 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id s9so23139255wro.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2020 10:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=z4vcpIwywIa5rhEfDa3o17Qy4qQsjexN6rFsZvVCzvI=;
 b=i5BcYNcM6qzN9gIC6Zos02dnE8rZIudFYfeZNcnVwst4EKmc2q2Ms0tbFD1K145rhN
 EyN53gm3SYcjXj8YeQ6px/NtuPMVkpv0swt2sKzFjniFPQHXjOXIiS7QGmMPwHCKGjEH
 0Y3xO9i6IiXIkvBXE8sXwf5az6q2KrGHDE9VP6ovxCl47Hjt9bnzJ5X6mSzWBWX9/rMZ
 sUhvIEaRKj3w2xnjFLkI0BbBArxSG2s/9yPW2CInP6hqnbPKsOM1QaOm07yVZubZXTzR
 RbNN8m8Nvtbbf4tTxGVyg9zdj3UxpU6TOXKsOOF9/VaDzNPIbU98PtEkTT04FBQeh4Mu
 +bMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=z4vcpIwywIa5rhEfDa3o17Qy4qQsjexN6rFsZvVCzvI=;
 b=Ke2b+k/u7mbVltoDg8zdNsGwkduzxkA/aZX+NCMhxAZ4jHtjcgWqxi4klvB9b55UJ8
 wa79T32Ma4QMXxQoXcGbzpyfJGYAOXIY8A/Tfm8JfBax2TXRcxlXaE7YnhMlas39AUHQ
 Fp2POzPHMhzuXWnlc7uy35abaWF77//lkYSGk1iAFA4Ub8OtGDmtL9mYHMKIhPgbkLyV
 8oU8BTTo1zKVHVubRJBAGXb8toblbqFhP732BhHXC52TqjjiKZUlWrzw3Dvx27wc4CbK
 gI6xbVNKI85mL2fv46DoKSurgDeBYCNrVmPEQT/tTlEsvgQjC2gIrgGTFLmK+za0Va1C
 c6rg==
X-Gm-Message-State: AOAM533vn48WSkNCbFcBDVaxNGEQywE+of1p8z4AiDwUKVjoYYPsbhIX
 6h1T99lBIxkeSX1lX/YicqTxxVn8pnG3E/X6
X-Google-Smtp-Source: ABdhPJzrzz9sHPqQ+PdVQq+JJJnWPJd6Kn6P7U2cR/hpaxn8sZnauzi5oOrw6gyAkzxG8ER6mhlOAQ==
X-Received: by 2002:a05:6000:1252:: with SMTP id
 j18mr32575217wrx.18.1604514999931; 
 Wed, 04 Nov 2020 10:36:39 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:c8d2:30f2:53c6:bc2])
 by smtp.gmail.com with ESMTPSA id 15sm3271469wmg.1.2020.11.04.10.36.37
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 Nov 2020 10:36:38 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 01/26] psci: Export configured PSCI version
Date: Wed,  4 Nov 2020 18:36:05 +0000
Message-Id: <20201104183630.27513-2-dbrazdil@google.com>
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

The version of PSCI that the kernel should use to communicate with
firmware is typically obtained from probing PSCI_VERSION. However, that
doesn't work for PSCI v0.1 where the host gets the information from
DT/ACPI, or if PSCI is not supported / was disabled.

KVM's PSCI proxy for the host needs to be configured with the same
version used by the host driver. Expose the PSCI version used by the
host.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 drivers/firmware/psci/psci.c | 6 ++++++
 include/linux/psci.h         | 8 ++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
index 00af99b6f97c..ff523bdbfe3f 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -49,6 +49,8 @@ static int resident_cpu = -1;
 struct psci_operations psci_ops;
 static enum arm_smccc_conduit psci_conduit = SMCCC_CONDUIT_NONE;
 
+int psci_driver_version = PSCI_VERSION(0, 0);
+
 bool psci_tos_resident_on(int cpu)
 {
 	return cpu == resident_cpu;
@@ -461,6 +463,8 @@ static int __init psci_probe(void)
 		return -EINVAL;
 	}
 
+	psci_driver_version = ver;
+
 	psci_0_2_set_functions();
 
 	psci_init_migrate();
@@ -514,6 +518,8 @@ static int __init psci_0_1_init(struct device_node *np)
 
 	pr_info("Using PSCI v0.1 Function IDs from DT\n");
 
+	psci_driver_version = PSCI_VERSION(0, 1);
+
 	if (!of_property_read_u32(np, "cpu_suspend", &id)) {
 		psci_function_id[PSCI_FN_CPU_SUSPEND] = id;
 		psci_ops.cpu_suspend = psci_cpu_suspend;
diff --git a/include/linux/psci.h b/include/linux/psci.h
index 2a1bfb890e58..cb35b90d1746 100644
--- a/include/linux/psci.h
+++ b/include/linux/psci.h
@@ -21,6 +21,14 @@ bool psci_power_state_is_valid(u32 state);
 int psci_set_osi_mode(bool enable);
 bool psci_has_osi_support(void);
 
+/**
+ * The version of the PSCI specification followed by the driver.
+ * This is equivalent to calling PSCI_VERSION except:
+ *   (a) it also works for PSCI v0.1, which does not support PSCI_VERSION, and
+ *   (b) it is set to v0.0 if the PSCI driver was not initialized.
+ */
+extern int psci_driver_version;
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
