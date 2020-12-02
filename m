Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5850DC71155
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:41:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A0050221FA
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:41:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0050221FA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 257AF4B415;
	Wed,  2 Dec 2020 13:41:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id guds5KhovMz4; Wed,  2 Dec 2020 13:41:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24B154B41C;
	Wed,  2 Dec 2020 13:41:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E622B4B40C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:41:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jt5xxDNJBB+U for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 13:41:43 -0500 (EST)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F0F744B414
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:41:41 -0500 (EST)
Received: by mail-wr1-f65.google.com with SMTP id z7so5174271wrn.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Dec 2020 10:41:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=qXwVi8GgD0h+y0Z1L4Qz/RxstC0DDwAUVzhRN0FU904=;
 b=i+G98kVudQR6uGePmNxw8xCv7SMJAja1ZSWowPxR1m3WcQORTplZuJmLizNsMjEhCh
 wEKbRahBqXc7XUcmyktVRkyyRuiuvzzaXLq/c+bjP3tKDlOtoQz2LX6scrNS6qFBjsDZ
 jJFI5aZZ9jlIWXo5dAO5x0M14XqlhIjLXybyL7t9tmYSDxxm8vj02XMeVsJGeAbRe3Ec
 bHjOvS6lH4XPiSfInJTeRmGrp8KEenXa0rxR8rBCPjCgXRbh7UKOJ0EfJ0JxTI2zZtoa
 SeNlCdJAZECI2DajIMd/1/nTwrPVyOC5AzMf8GimCHFwpoSij5LlSefToJPi7j30LqQ8
 It/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=qXwVi8GgD0h+y0Z1L4Qz/RxstC0DDwAUVzhRN0FU904=;
 b=coHxHzXCvFkeB54CuPtKY7FXcZtRlYwuS7wcZ90SgU0I6OvhzST38H70pScHCbg2JT
 NUFgFjSBZe+5Y0hXy2D1mHJ9nvdWSFTthU4yELxp1zBCdKmIjgR9yPdfVAcgWVP9WoKu
 eAvdYKr2woUI1UrxpT5laJt3AMPNGohCGI88/JdlXrG4e6Q0CBYRXTyx8LoLmydLYPZ5
 AX+VNQRYwLkimeZcHfKfudzytVPEhlLfQD2oIl7Ite2PxzCFOcFgskCDFfaDLBqO8ALi
 sEU6tlwdgbh0g2yHKMQ5Cu++CnMEjiUklJ+h7GEEgeG4uTUXOIPJopvYAEyyICECRzQh
 V1VQ==
X-Gm-Message-State: AOAM5310S8AFMNSQFMSPoKHXM/NZmsfgRjRFxyLPbiBGmjUc5hun7Uu4
 wbC7XBLYrG5S3xpMjCUtjslhWZqJJp5aMg==
X-Google-Smtp-Source: ABdhPJzo+3XrHLu5MZisvjC9Vlqkp9p6BFe0uyPEE/+3sbo7phn6YCf8SNKtKbXnK5PdAZQg2KF0+w==
X-Received: by 2002:a5d:4f0e:: with SMTP id c14mr4996465wru.422.1606934500673; 
 Wed, 02 Dec 2020 10:41:40 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:5ddd:b7c5:e3c9:e87a])
 by smtp.gmail.com with ESMTPSA id p11sm3257202wrj.14.2020.12.02.10.41.39
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 02 Dec 2020 10:41:39 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 06/26] psci: Add accessor for psci_0_1_function_ids
Date: Wed,  2 Dec 2020 18:41:02 +0000
Message-Id: <20201202184122.26046-7-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201202184122.26046-1-dbrazdil@google.com>
References: <20201202184122.26046-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sudeep Holla <sudeep.holla@arm.com>, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
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

Make it possible to retrieve a copy of the psci_0_1_function_ids struct.
This is useful for KVM if it is configured to intercept host's PSCI SMCs.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 drivers/firmware/psci/psci.c | 12 +++++-------
 include/linux/psci.h         |  9 +++++++++
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
index 593fdd0e09a2..f5fc429cae3f 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -58,15 +58,13 @@ typedef unsigned long (psci_fn)(unsigned long, unsigned long,
 				unsigned long, unsigned long);
 static psci_fn *invoke_psci_fn;
 
-struct psci_0_1_function_ids {
-	u32 cpu_suspend;
-	u32 cpu_on;
-	u32 cpu_off;
-	u32 migrate;
-};
-
 static struct psci_0_1_function_ids psci_0_1_function_ids;
 
+struct psci_0_1_function_ids get_psci_0_1_function_ids(void)
+{
+	return psci_0_1_function_ids;
+}
+
 #define PSCI_0_2_POWER_STATE_MASK		\
 				(PSCI_0_2_POWER_STATE_ID_MASK | \
 				PSCI_0_2_POWER_STATE_TYPE_MASK | \
diff --git a/include/linux/psci.h b/include/linux/psci.h
index 2a1bfb890e58..4ca0060a3fc4 100644
--- a/include/linux/psci.h
+++ b/include/linux/psci.h
@@ -34,6 +34,15 @@ struct psci_operations {
 
 extern struct psci_operations psci_ops;
 
+struct psci_0_1_function_ids {
+	u32 cpu_suspend;
+	u32 cpu_on;
+	u32 cpu_off;
+	u32 migrate;
+};
+
+struct psci_0_1_function_ids get_psci_0_1_function_ids(void);
+
 #if defined(CONFIG_ARM_PSCI_FW)
 int __init psci_dt_init(void);
 #else
-- 
2.29.2.454.gaff20da3a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
