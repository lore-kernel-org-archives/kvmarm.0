Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0D7AC83017
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:42:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 125B92224C
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:42:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 125B92224C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DC3F4B460;
	Wed,  2 Dec 2020 13:42:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GCYuJjvrj8OU; Wed,  2 Dec 2020 13:42:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3F394B45B;
	Wed,  2 Dec 2020 13:42:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD5484B460
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:42:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UgmQVy-59zhK for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 13:42:23 -0500 (EST)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D87AC4B450
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:42:22 -0500 (EST)
Received: by mail-wm1-f66.google.com with SMTP id d3so10155145wmb.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Dec 2020 10:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=pdq1h6Iz7BaS9XHPJecHzTrxzCvHIq7bY+OCaqaUt9I=;
 b=KOEK4s1Ox/QOtxtUNQV6lW8tsX7N/Qz11MQmpxX+mgoAtIqI4ROGadur0j1GvfPZ3S
 qnd7H6icVbP7FDjQA0VS8bb07nR1MeQ9HF9dNdeQKXtjw8SrZGW8CvARHvvIL/pDJYw9
 eub897JAH61yZK0cmDaSunb3DJmizow9dhDher5Z/q5p1VMb022tLjTj1d+6gVWvzGkI
 lV5sPeEzfS+NmliZtrXh/m9lZlnFM4iwGM29uCkyDwzCsWZB16dkh9pbesIly660+TGZ
 JZZN/EW6Xuubk9oqq8U0SFC0cRqU+n2i1xAYFPOjwGtz5rGvLtCOgvpc80RP5Qr2nhJv
 CvJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=pdq1h6Iz7BaS9XHPJecHzTrxzCvHIq7bY+OCaqaUt9I=;
 b=LllYFE9CBDdUsFna3OoXeI5ElnLEoWSMu/nfWhDDxG4iaq2TAXHSLmgciMp9V74CAm
 U99nF7jF9u0z0+0wrjvvKQLh0L8E9wYDHlTZx6PY7k2h+FuQ44WMH3CqOxYo9WOJmuUa
 fscsCuNFVRm4wd2obSYJTX8lPpH3oRB2AejgmpHd7ICwlVupMpk2SVQOtFPzBbuz0IHo
 WR+uMN64itFLIxR4azGECf/eXTHWdFjOdDLtiqH/wXlB4yHp6nHCHzBf8RLYka2hBNnI
 icpg8ppDZeblhAWM1cBfy+e+BZNayyy0A/3XmjlT0womcSNN2Fl3yvIMNu2xP8nNG+I8
 +urg==
X-Gm-Message-State: AOAM531L+Vu4J6CJyvlZsmvh1XWafQRYxN/a3RKJZFuBRjljYFfSMYbp
 R40ewZJzEy3NDWjiUkW8df1XagfqqV0lKA==
X-Google-Smtp-Source: ABdhPJyAghBSBueIUZyEOdUpBSWInTgxUTJ9HrAjeXaOhO6iHRoqpQZbX/aG+qsqholRHQQrI3MT8A==
X-Received: by 2002:a1c:9ac6:: with SMTP id c189mr4470560wme.137.1606934541552; 
 Wed, 02 Dec 2020 10:42:21 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:5ddd:b7c5:e3c9:e87a])
 by smtp.gmail.com with ESMTPSA id o13sm2912807wmc.44.2020.12.02.10.42.20
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 02 Dec 2020 10:42:20 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 24/26] kvm: arm64: Keep nVHE EL2 vector installed
Date: Wed,  2 Dec 2020 18:41:20 +0000
Message-Id: <20201202184122.26046-25-dbrazdil@google.com>
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

KVM by default keeps the stub vector installed and installs the nVHE
vector only briefly for init and later on demand. Change this policy
to install the vector at init and then never uninstall it if the kernel
was given the protected KVM command line parameter.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/arm.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fda7bfa440d5..5f8776eefe46 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1531,7 +1531,8 @@ static void _kvm_arch_hardware_disable(void *discard)
 
 void kvm_arch_hardware_disable(void)
 {
-	_kvm_arch_hardware_disable(NULL);
+	if (!is_protected_kvm_enabled())
+		_kvm_arch_hardware_disable(NULL);
 }
 
 #ifdef CONFIG_CPU_PM
@@ -1574,11 +1575,13 @@ static struct notifier_block hyp_init_cpu_pm_nb = {
 
 static void __init hyp_cpu_pm_init(void)
 {
-	cpu_pm_register_notifier(&hyp_init_cpu_pm_nb);
+	if (!is_protected_kvm_enabled())
+		cpu_pm_register_notifier(&hyp_init_cpu_pm_nb);
 }
 static void __init hyp_cpu_pm_exit(void)
 {
-	cpu_pm_unregister_notifier(&hyp_init_cpu_pm_nb);
+	if (!is_protected_kvm_enabled())
+		cpu_pm_unregister_notifier(&hyp_init_cpu_pm_nb);
 }
 #else
 static inline void hyp_cpu_pm_init(void)
@@ -1666,7 +1669,8 @@ static int init_subsystems(void)
 	kvm_sys_reg_table_init();
 
 out:
-	on_each_cpu(_kvm_arch_hardware_disable, NULL, 1);
+	if (err || !is_protected_kvm_enabled())
+		on_each_cpu(_kvm_arch_hardware_disable, NULL, 1);
 
 	return err;
 }
-- 
2.29.2.454.gaff20da3a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
