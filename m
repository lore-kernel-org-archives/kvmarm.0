Return-Path: <SRS0=JeL3=EW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EC76C6379F
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:44:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 40EB322240
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:44:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="l51oR3ke"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 40EB322240
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E7F454C1A3;
	Mon, 16 Nov 2020 15:44:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sQH7nSs7HeLU; Mon, 16 Nov 2020 15:44:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F03EB4C299;
	Mon, 16 Nov 2020 15:44:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C6DC4C1A3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:44:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GTWRQnvUGDQK for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2020 15:44:11 -0500 (EST)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C55F94BFBC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:44:10 -0500 (EST)
Received: by mail-wr1-f65.google.com with SMTP id r17so20306606wrw.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 12:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=5CFjz03HJxHtdKmmeq3XI0pgEGq835KLMY12UZ/ZKTg=;
 b=l51oR3keMoKmPq/v1ISAlqHy4p/t+CQYtMrQtrP9vZnPMcERdLP/QHt+d0CT9gA/Ed
 SobfYR2CeQyAX0dOJWwTVbuhvYtnVgveuYzP3rbl3Ij8p3MCRVh0iYc64p9ZQqwbsVdV
 +HDWxeSVum9m9sMkdtyDTKxiyK3NR6dpkI87nPOBs5gP20q5woGOaKJipnSGcOaCr/3f
 qvW0h4o5auBjfBRhZWRRACLhjwctmBp3xNbSSrb6KhF3xlCw/QkGVQgs5PsluJQVitm3
 fTprBP4rfDAsllrSEZg8y2fla9YfmqspG3gOWIvViQaQQlcvL/gp6db9g1rHt5WazShs
 ffbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=5CFjz03HJxHtdKmmeq3XI0pgEGq835KLMY12UZ/ZKTg=;
 b=W8kVM++MaIqYtcI4paE8Sb34U8KBRok8YUuvNtmr0QVNUKez5bLu4aZPO0vMlwhMFc
 6AHmkH3z3V3krWlCFLyL7O2fzHVgOC5sCe9ONmynfQsIZgE1nflqGzCiLOAVjajXtK+k
 cUFakrHroDNnDNBxAfMOcClA8Ea5p0GlYNOoP2kzGwJIym7iJiQIo+p19IPwv2x9bcOE
 rrrdWVdp078yNBV2jziWmfNsERoQQTw0HjFcBAHorseb7o6Sz0qQ4+fLU5N8jZvL4dmy
 gFTsdzCZz1HvZYFwf8Gu8Nv006F+nJEDGJ4b7/7CJ0shYX+5xO1Ikts77SllzwLJT3YA
 K61A==
X-Gm-Message-State: AOAM5335yNl4XSJLa/qZ5LHn4BTHMV0xm88U/Hltq1lFl9JjqBMFeAyY
 k8Fv/DVcV6RRf6YQOVP+xRRoH0Ug00obgd8doNM=
X-Google-Smtp-Source: ABdhPJwTVhg+IzYsedYHZXpYNdeAAlF6a3bNz+Xk9NrjYPSf6yZ7lt0OUtSGjKuG7foETNcuKLqMKA==
X-Received: by 2002:adf:c3c8:: with SMTP id d8mr21152047wrg.366.1605559449547; 
 Mon, 16 Nov 2020 12:44:09 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:bc40:bd71:373a:1b33])
 by smtp.gmail.com with ESMTPSA id i6sm531311wma.42.2020.11.16.12.44.08
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 16 Nov 2020 12:44:08 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 22/24] kvm: arm64: Keep nVHE EL2 vector installed
Date: Mon, 16 Nov 2020 20:43:16 +0000
Message-Id: <20201116204318.63987-23-dbrazdil@google.com>
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

KVM by default keeps the stub vector installed and installs the nVHE
vector only briefly for init and later on demand. Change this policy
to install the vector at init and then never uninstall it if the kernel
was given the protected KVM command line parameter.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/arm.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 49d2474f2a80..45bc7a6b9e0b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1443,7 +1443,8 @@ static void _kvm_arch_hardware_disable(void *discard)
 
 void kvm_arch_hardware_disable(void)
 {
-	_kvm_arch_hardware_disable(NULL);
+	if (!is_protected_kvm_enabled())
+		_kvm_arch_hardware_disable(NULL);
 }
 
 #ifdef CONFIG_CPU_PM
@@ -1486,11 +1487,13 @@ static struct notifier_block hyp_init_cpu_pm_nb = {
 
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
@@ -1575,7 +1578,8 @@ static int init_subsystems(void)
 	kvm_coproc_table_init();
 
 out:
-	on_each_cpu(_kvm_arch_hardware_disable, NULL, 1);
+	if (err || !is_protected_kvm_enabled())
+		on_each_cpu(_kvm_arch_hardware_disable, NULL, 1);
 
 	return err;
 }
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
