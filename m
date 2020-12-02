Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CB0CC71156
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:41:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7C775221FA
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:41:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C775221FA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC1124B3CE;
	Wed,  2 Dec 2020 13:41:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id buDqAOF9JYUh; Wed,  2 Dec 2020 13:41:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A91B4B41A;
	Wed,  2 Dec 2020 13:41:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC1774B3A7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:41:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vVkg2+u1fbD4 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 13:41:39 -0500 (EST)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B5B954B2CE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:41:39 -0500 (EST)
Received: by mail-wr1-f65.google.com with SMTP id p8so5161666wrx.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Dec 2020 10:41:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=cK6AK8VTndq2WNu92SDcRQLBfLwMiV+V214MHUEgg2w=;
 b=Xf/f5iL7f+U7uWYo68hnex0nqviSfyrK8iju0quGui/JaXe3jHIb4ayRSem4PO/dq2
 lJGlb+3oWwRKdmbaF5MTjSBGA1a/nZ3DnuYAFU0VXkg3XJeK83UY1px90mjbi3yXR1Mb
 iM4vVVqC7wOJlGnKkNBM4fXDzNbk9nKHDjGpETmTOggyBJ43ISHXgf96DSwHeZ+e19Zg
 qzN5AGHZoq4l2bC1PF4CKHiN+laTlUEI/0jdRvB/GCkrYMSfiNf9DuMdmu6iUyf28J74
 kWyZuBuapoYx8SF7rQXnFicabHz3K+IUHtgj2IDCOGeZb28eFFDsBHNzY2NUKlGXgXVv
 XqJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=cK6AK8VTndq2WNu92SDcRQLBfLwMiV+V214MHUEgg2w=;
 b=TtleWG1snTJWDac7itOwMMV6B1spphA0i3U8Yhr17VpaQPR5j6oS7iVUzGK/1LHNwj
 pGz+n3HB4fLbsKtcqF2wSvPddvU9rSKLGOGRSpeodjwG8/lupnmh4OFqhEGk9vCmMY0z
 LZrDZ2g+eFa2w48rqeRVsXYvw8O6buVwi4E1+sEp0DBk/zcUXl2vy/IU/D472djm14zN
 Fdqjk2EqCHMD47E/F42HN6Q1HgzfT2vlPgn6PbmdLacEfgb0SD4Cp46d7kir+LCL3B+3
 4HFWPP1ItTgTrqWh6rXXld8ichdDX2QFyvJze+kKTTajyNlL1gXJ0+x8+kQS8r2NDi8Z
 onGQ==
X-Gm-Message-State: AOAM5321ormb9oFXXNLfcEAPs5mWx1Kq4wPtja6VdwgAl0FLVQqjUnwW
 PYyEGt2GbUXpRA5j+YsfMZsepgFExKNYSQ==
X-Google-Smtp-Source: ABdhPJyx6RaeHoVm3xBFk7dQ2A5SBfxrzx+C7n8O07sr+KP5yugR90H9p2be9APNazqd8m8Fn6a1ww==
X-Received: by 2002:adf:dd81:: with SMTP id x1mr5122600wrl.163.1606934498348; 
 Wed, 02 Dec 2020 10:41:38 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:5ddd:b7c5:e3c9:e87a])
 by smtp.gmail.com with ESMTPSA id z21sm2967184wmk.20.2020.12.02.10.41.36
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 02 Dec 2020 10:41:37 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 05/26] psci: Replace psci_function_id array with a struct
Date: Wed,  2 Dec 2020 18:41:01 +0000
Message-Id: <20201202184122.26046-6-dbrazdil@google.com>
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

Small refactor that replaces array of v0.1 function IDs indexed by an
enum of function-name constants with a struct of function IDs "indexed"
by field names. This is done in preparation for exposing the IDs to
other parts of the kernel. Exposing a struct avoids the need for
bounds checking.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 drivers/firmware/psci/psci.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
index 13b9ed71b446..593fdd0e09a2 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -58,15 +58,14 @@ typedef unsigned long (psci_fn)(unsigned long, unsigned long,
 				unsigned long, unsigned long);
 static psci_fn *invoke_psci_fn;
 
-enum psci_function {
-	PSCI_FN_CPU_SUSPEND,
-	PSCI_FN_CPU_ON,
-	PSCI_FN_CPU_OFF,
-	PSCI_FN_MIGRATE,
-	PSCI_FN_MAX,
+struct psci_0_1_function_ids {
+	u32 cpu_suspend;
+	u32 cpu_on;
+	u32 cpu_off;
+	u32 migrate;
 };
 
-static u32 psci_function_id[PSCI_FN_MAX];
+static struct psci_0_1_function_ids psci_0_1_function_ids;
 
 #define PSCI_0_2_POWER_STATE_MASK		\
 				(PSCI_0_2_POWER_STATE_ID_MASK | \
@@ -178,7 +177,7 @@ static int __psci_cpu_suspend(u32 fn, u32 state, unsigned long entry_point)
 
 static int psci_0_1_cpu_suspend(u32 state, unsigned long entry_point)
 {
-	return __psci_cpu_suspend(psci_function_id[PSCI_FN_CPU_SUSPEND],
+	return __psci_cpu_suspend(psci_0_1_function_ids.cpu_suspend,
 				  state, entry_point);
 }
 
@@ -198,7 +197,7 @@ static int __psci_cpu_off(u32 fn, u32 state)
 
 static int psci_0_1_cpu_off(u32 state)
 {
-	return __psci_cpu_off(psci_function_id[PSCI_FN_CPU_OFF], state);
+	return __psci_cpu_off(psci_0_1_function_ids.cpu_off, state);
 }
 
 static int psci_0_2_cpu_off(u32 state)
@@ -216,7 +215,7 @@ static int __psci_cpu_on(u32 fn, unsigned long cpuid, unsigned long entry_point)
 
 static int psci_0_1_cpu_on(unsigned long cpuid, unsigned long entry_point)
 {
-	return __psci_cpu_on(psci_function_id[PSCI_FN_CPU_ON], cpuid, entry_point);
+	return __psci_cpu_on(psci_0_1_function_ids.cpu_on, cpuid, entry_point);
 }
 
 static int psci_0_2_cpu_on(unsigned long cpuid, unsigned long entry_point)
@@ -234,7 +233,7 @@ static int __psci_migrate(u32 fn, unsigned long cpuid)
 
 static int psci_0_1_migrate(unsigned long cpuid)
 {
-	return __psci_migrate(psci_function_id[PSCI_FN_MIGRATE], cpuid);
+	return __psci_migrate(psci_0_1_function_ids.migrate, cpuid);
 }
 
 static int psci_0_2_migrate(unsigned long cpuid)
@@ -548,22 +547,22 @@ static int __init psci_0_1_init(struct device_node *np)
 	psci_ops.get_version = psci_0_1_get_version;
 
 	if (!of_property_read_u32(np, "cpu_suspend", &id)) {
-		psci_function_id[PSCI_FN_CPU_SUSPEND] = id;
+		psci_0_1_function_ids.cpu_suspend = id;
 		psci_ops.cpu_suspend = psci_0_1_cpu_suspend;
 	}
 
 	if (!of_property_read_u32(np, "cpu_off", &id)) {
-		psci_function_id[PSCI_FN_CPU_OFF] = id;
+		psci_0_1_function_ids.cpu_off = id;
 		psci_ops.cpu_off = psci_0_1_cpu_off;
 	}
 
 	if (!of_property_read_u32(np, "cpu_on", &id)) {
-		psci_function_id[PSCI_FN_CPU_ON] = id;
+		psci_0_1_function_ids.cpu_on = id;
 		psci_ops.cpu_on = psci_0_1_cpu_on;
 	}
 
 	if (!of_property_read_u32(np, "migrate", &id)) {
-		psci_function_id[PSCI_FN_MIGRATE] = id;
+		psci_0_1_function_ids.migrate = id;
 		psci_ops.migrate = psci_0_1_migrate;
 	}
 
-- 
2.29.2.454.gaff20da3a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
