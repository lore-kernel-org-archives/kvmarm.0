Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31AB7C2D0A3
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:32:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 94705216C4
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:32:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="WWfakKwG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 94705216C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 32FD24B755;
	Mon,  9 Nov 2020 06:32:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HhElXtzETNjR; Mon,  9 Nov 2020 06:32:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14FD94B74E;
	Mon,  9 Nov 2020 06:32:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15E074B749
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:32:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P5Y3nDIt-wCn for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 06:32:43 -0500 (EST)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 17FED4B71D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:32:43 -0500 (EST)
Received: by mail-wr1-f67.google.com with SMTP id l1so3906063wrb.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Nov 2020 03:32:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=pzuHJ5pL7t9NbTEFogq/8Y23xeOn+spq7fy4sQhhUGw=;
 b=WWfakKwGe1YouBXlERhaEppVHXGHFfpGO6bW/qiGXsfrnx2X9Lb/WvrzQ1BmW5RS/5
 zHLiFC7sJhMK2RlWUkklFx+QINQJt1MhJ3kSxKkvhs0XrDOB01DonqHn5Emvim+ioae0
 mzXqV6OD7rZ1HSeAlSSDGTafFQGnM2ub6vcj/8Xmt2enbD8TouDTCyPN/DRyQDDtF59k
 mWUJLHIx+sJoEQIEa+cOmDc1ijKk+N4l7rd1M6uJti+h61k4Lpgatharg5X9b8N/s2tO
 3ys6wT2kD/LsHwgKSgmM2snJbpUNI7giobddJY6xsKxnsjnqKVOAuK1ozzqZAQuNkoXW
 p8NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=pzuHJ5pL7t9NbTEFogq/8Y23xeOn+spq7fy4sQhhUGw=;
 b=f7+MTaW0rh+P4ToT6Nh9dnwE0rBITGz+HEIniH5BiOc+2CZMUT8AGOtJEl+/CFss6Y
 NSgj7kw71eLE0oU4nJSV1wIl/xqdqv5rXXdNQVF+RCcuL3kHRzJK4+g+iHDzlCk1V8kT
 y/RTNaX0HCXavEMzb95XYPsDHtcIKJhfpGYUi1Y1q/p1CiVhS4SStEiMGXgnoLV/qI5o
 hoSRqtusaohUSio6j/WPrXmprX2srwKsXgHT/C6/kwtOugmX9uVIR7lXK05UajJKb4nU
 KvSxWA6W3Aijo3/qGlZxN92nnSkW8cAHWMJ/cgAGyO141NZPL85fpK4uAzU0zJJQoXrp
 GSkA==
X-Gm-Message-State: AOAM532GBnEKuHAn4h+Mr8H13FMOXdhFMdTNJ3+OO3nFuqU3BsH05eej
 NdEyC9HXOYYc0ErD8pkh2fFQJ6kV/SRhLEs0
X-Google-Smtp-Source: ABdhPJygvHSvFhOYazfMvt3AJzEQrYuyl6Z5s6RaM4KlhnPW6/ZF7ztOig2+Ano7PbZOzUl7hy8ELw==
X-Received: by 2002:adf:ef48:: with SMTP id c8mr17832902wrp.399.1604921561816; 
 Mon, 09 Nov 2020 03:32:41 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:209d:10b7:c480:3e1f])
 by smtp.gmail.com with ESMTPSA id y20sm12191934wma.15.2020.11.09.03.32.40
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 09 Nov 2020 03:32:40 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 01/24] psci: Accessor for configured PSCI version
Date: Mon,  9 Nov 2020 11:32:10 +0000
Message-Id: <20201109113233.9012-2-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109113233.9012-1-dbrazdil@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
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

The version of PSCI that the kernel should use to communicate with
firmware is typically obtained from probing PSCI_VERSION. However, that
doesn't work for PSCI v0.1 where the host gets the information from
DT/ACPI, or if PSCI is not supported / was disabled.

KVM's host PSCI proxy needs to be configured with the same version
used by the host driver. Expose the PSCI version used by the host
with a read-only accessor.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 drivers/firmware/psci/psci.c | 11 +++++++++++
 include/linux/psci.h         |  8 ++++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
index 00af99b6f97c..bc1b2d60fdbf 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -49,6 +49,13 @@ static int resident_cpu = -1;
 struct psci_operations psci_ops;
 static enum arm_smccc_conduit psci_conduit = SMCCC_CONDUIT_NONE;
 
+static int driver_version = PSCI_VERSION(0, 0);
+
+int psci_driver_version(void)
+{
+	return driver_version;
+}
+
 bool psci_tos_resident_on(int cpu)
 {
 	return cpu == resident_cpu;
@@ -461,6 +468,8 @@ static int __init psci_probe(void)
 		return -EINVAL;
 	}
 
+	driver_version = ver;
+
 	psci_0_2_set_functions();
 
 	psci_init_migrate();
@@ -514,6 +523,8 @@ static int __init psci_0_1_init(struct device_node *np)
 
 	pr_info("Using PSCI v0.1 Function IDs from DT\n");
 
+	driver_version = PSCI_VERSION(0, 1);
+
 	if (!of_property_read_u32(np, "cpu_suspend", &id)) {
 		psci_function_id[PSCI_FN_CPU_SUSPEND] = id;
 		psci_ops.cpu_suspend = psci_cpu_suspend;
diff --git a/include/linux/psci.h b/include/linux/psci.h
index 2a1bfb890e58..5b5dcf176aa6 100644
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
+int psci_driver_version(void);
+
 struct psci_operations {
 	u32 (*get_version)(void);
 	int (*cpu_suspend)(u32 state, unsigned long entry_point);
-- 
2.29.2.222.g5d2a92d10f8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
