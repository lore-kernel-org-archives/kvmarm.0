Return-Path: <SRS0=JeL3=EW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44C89C55ABD
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:43:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9558E2224B
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:43:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="t+iNX/pa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9558E2224B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21BE14C247;
	Mon, 16 Nov 2020 15:43:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1qqlaanmxS-n; Mon, 16 Nov 2020 15:43:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D6F24C249;
	Mon, 16 Nov 2020 15:43:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A1D74C23D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:43:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HyYrSimWwg5o for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2020 15:43:26 -0500 (EST)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B5C04C16F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:43:26 -0500 (EST)
Received: by mail-wm1-f67.google.com with SMTP id a3so563927wmb.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 12:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=zcAUCdpGWiuobZn7klovZm7k+zA43w4wed6QHZHKZWs=;
 b=t+iNX/paL9tpslCZ4CFA0oCR9xlgnZt6fxJdREt7U7vuSjqq/X58AyBogeLhmb/FgA
 seqQtQzK3lsKx2bZbh9uTqgCQ8BiJKQM1Kkc2l5gBGbgIEIK4ZvLY57zj9qQ575CVNiG
 32YGidIbqGAxwSRCkoTBCJTX6Ck5M4kMXTeTIydXYbK7dk4aWmkCMhjTFoM2M1q438vQ
 eZPIRHbbCtKMUQOnso8i7X8CQ1A5SRPmJh6MDrhmCxrglK8LbcDnHBisKHia+Y65TAWA
 aK5vNo0NXNX1qC+rBXjlsbA88aDmZKhEObSRb3tTXOeFer1H+YDQ8lWIe+INsuGEW9RO
 E6ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=zcAUCdpGWiuobZn7klovZm7k+zA43w4wed6QHZHKZWs=;
 b=r0cFBSp/0yWNPrza/05vrKzDunyKNcblObooVuH6yCMDNVkjm6CxXXQzJT184XazaT
 inUc62soLNT9DPIDwWxgx9uq0qnB8AxSQiRD1hhTqMrOyxCQ/5NuSPAboOVmvRLSHvA3
 zJSJiXi6yymAlh2ujUTl1z17hnSojTKLUcVuFCK7ZqZ8jElzXsCrjgV5fGxnbjUcG/lV
 vyToMdeTtJhQNOqt79kUXcm/jV3HUoxK9hcK/yVLtrhIFaJXs8zuhEAHHuOVNuKYVVUE
 h0rcWn+XZ/VtW16NlOhrP/52HltnlgMWykyHyfng3qt1aomsdCaB0Gx57J1HytnC+h0g
 VkHA==
X-Gm-Message-State: AOAM5330qb6LWJyCEiXd+2iKPg7kxjH4yOXB8dxnP9jUiH/L0AqOqIZ9
 ptfRP3BB/Iw9FJVrNfhOuboFLK4fGPcu1qhYLgI=
X-Google-Smtp-Source: ABdhPJzgqCTBEHgC/iMbT8zNTaAzAp+KaRl3xN6yFoQabpnmMr3bPo14Jz09qy86PvkRyrjoS3SOvg==
X-Received: by 2002:a1c:4485:: with SMTP id r127mr684535wma.177.1605559405139; 
 Mon, 16 Nov 2020 12:43:25 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:bc40:bd71:373a:1b33])
 by smtp.gmail.com with ESMTPSA id p4sm623902wmc.46.2020.11.16.12.43.23
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 16 Nov 2020 12:43:24 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 01/24] psci: Support psci_ops.get_version for v0.1
Date: Mon, 16 Nov 2020 20:42:55 +0000
Message-Id: <20201116204318.63987-2-dbrazdil@google.com>
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

KVM's host PSCI SMC filter needs to be aware of the PSCI version of the
system but currently it is impossible to distinguish between v0.1 and
PSCI disabled because both have get_version == NULL.

Populate get_version for v0.1 with a function that returns a constant.

psci_opt.get_version is currently unused so this has no effect on
existing functionality.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 drivers/firmware/psci/psci.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
index 00af99b6f97c..213c68418a65 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -146,6 +146,11 @@ static int psci_to_linux_errno(int errno)
 	return -EINVAL;
 }
 
+static u32 psci_get_version_0_1(void)
+{
+	return PSCI_VERSION(0, 1);
+}
+
 static u32 psci_get_version(void)
 {
 	return invoke_psci_fn(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
@@ -514,6 +519,8 @@ static int __init psci_0_1_init(struct device_node *np)
 
 	pr_info("Using PSCI v0.1 Function IDs from DT\n");
 
+	psci_ops.get_version = psci_get_version_0_1;
+
 	if (!of_property_read_u32(np, "cpu_suspend", &id)) {
 		psci_function_id[PSCI_FN_CPU_SUSPEND] = id;
 		psci_ops.cpu_suspend = psci_cpu_suspend;
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
