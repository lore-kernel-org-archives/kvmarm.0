Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45EFFC71155
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:41:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A32AF206F9
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:41:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A32AF206F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F07B4B3C2;
	Wed,  2 Dec 2020 13:41:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5twDi74Mrk1C; Wed,  2 Dec 2020 13:41:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8D0C4B424;
	Wed,  2 Dec 2020 13:41:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08C6E4B363
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:41:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iUs1TPnWvmaZ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 13:41:36 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 581A64B2CE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:41:35 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id z7so5173956wrn.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Dec 2020 10:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=JTPYqEMEJVYu7EDLdYK8M/9yDaVtcEHoKzFLwQ3C9WQ=;
 b=G9nRp1NClO5ThaoHR0FfWTTV1jX37+O++dpEWQ5M8ktTDAMpJeJccyh4QbRtPHzrgj
 3p0wDTK1oNkUPBZWEB48xqyd1DpiPlza78uG3UJmd0FRgJoXsvYEFC5/dJ6p1PDADnej
 JzxUan8mUbqcytiT8Xsbq58HdA7MIJPBZrBTgotHo8Pn9CTEZK8UNEMPbhDMlXHR7m1s
 PDfiRnDCZkEazv3nGY2YNAECEwG/U/mnyvg+RXProtzJE1N/fcd9LDxLtq4B8OclAb90
 fHQNn4wIZufUltwam9z0S7haohHxuJjP1yQ/G1kC05DlOQE4unx7Y8oRzB8xond/u6h2
 YkBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=JTPYqEMEJVYu7EDLdYK8M/9yDaVtcEHoKzFLwQ3C9WQ=;
 b=Oo5biMWgzs3oyE+u0fQCD6bkVJBBy2F1u3QisZl5XZqK97R3yDbLO8kx4UnozQ0I8q
 H6xB75rygBhLqKd3hOE1hIKLR/g/1BJheZnnqbfKkICyco7GLxIayB18altvBmSIDb8w
 F+5N3TqfMGnbKHafenSikDNYnpDLWcq0p7SYwh1ZlcrBkEGNJRxmKEh7dmZOjFgl7Zs6
 99kAcCA6pDiUQr2U/hrJsLQ76GWXZVB6FfqsVIz/O/HC3WjUY9Ai+GLvJ3dq0g8eT9xc
 ADERHS0Ez1mls6AvvEeEpc3PR886bGz82rIjqQ6Gj/qPS3G+fN4AIrcv6DQIY8/tpb08
 7FxA==
X-Gm-Message-State: AOAM533MTbRhXsZQitMTwZxHdzYu30hxbyNCYAWM06fVlB3So1YX8bu1
 tDngCz7Hl2sOpY8o09q+EIqa5BXKjhceqg==
X-Google-Smtp-Source: ABdhPJziIgLZ0tc/W8uCPyhlwdgytrCa5jtp+4HLbEeMEMxZ9Y3AuJ3UEdaL+P3G5xYsvTsXBF1VmQ==
X-Received: by 2002:a5d:4610:: with SMTP id t16mr5088666wrq.391.1606934493917; 
 Wed, 02 Dec 2020 10:41:33 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:5ddd:b7c5:e3c9:e87a])
 by smtp.gmail.com with ESMTPSA id r21sm3315301wrc.16.2020.12.02.10.41.32
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 02 Dec 2020 10:41:32 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 03/26] psci: Support psci_ops.get_version for v0.1
Date: Wed,  2 Dec 2020 18:40:59 +0000
Message-Id: <20201202184122.26046-4-dbrazdil@google.com>
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

KVM's host PSCI SMC filter needs to be aware of the PSCI version of the
system but currently it is impossible to distinguish between v0.1 and
PSCI disabled because both have get_version == NULL.

Populate get_version for v0.1 with a function that returns a constant.

psci_opt.get_version is currently unused so this has no effect on
existing functionality.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 drivers/firmware/psci/psci.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
index 00af99b6f97c..ace5b9ac676c 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -146,7 +146,12 @@ static int psci_to_linux_errno(int errno)
 	return -EINVAL;
 }
 
-static u32 psci_get_version(void)
+static u32 psci_0_1_get_version(void)
+{
+	return PSCI_VERSION(0, 1);
+}
+
+static u32 psci_0_2_get_version(void)
 {
 	return invoke_psci_fn(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
 }
@@ -421,7 +426,7 @@ static void __init psci_init_smccc(void)
 static void __init psci_0_2_set_functions(void)
 {
 	pr_info("Using standard PSCI v0.2 function IDs\n");
-	psci_ops.get_version = psci_get_version;
+	psci_ops.get_version = psci_0_2_get_version;
 
 	psci_function_id[PSCI_FN_CPU_SUSPEND] =
 					PSCI_FN_NATIVE(0_2, CPU_SUSPEND);
@@ -450,7 +455,7 @@ static void __init psci_0_2_set_functions(void)
  */
 static int __init psci_probe(void)
 {
-	u32 ver = psci_get_version();
+	u32 ver = psci_0_2_get_version();
 
 	pr_info("PSCIv%d.%d detected in firmware.\n",
 			PSCI_VERSION_MAJOR(ver),
@@ -514,6 +519,8 @@ static int __init psci_0_1_init(struct device_node *np)
 
 	pr_info("Using PSCI v0.1 Function IDs from DT\n");
 
+	psci_ops.get_version = psci_0_1_get_version;
+
 	if (!of_property_read_u32(np, "cpu_suspend", &id)) {
 		psci_function_id[PSCI_FN_CPU_SUSPEND] = id;
 		psci_ops.cpu_suspend = psci_cpu_suspend;
-- 
2.29.2.454.gaff20da3a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
