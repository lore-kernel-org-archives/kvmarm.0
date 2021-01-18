Return-Path: <SRS0=ax30=GV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C407CC433E0
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 11:19:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3AB4E221F8
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 11:19:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3AB4E221F8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 843444B254;
	Mon, 18 Jan 2021 06:19:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LjTAl+UHdNnh; Mon, 18 Jan 2021 06:19:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B53924B268;
	Mon, 18 Jan 2021 06:19:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E80A4B267
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 04:31:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0xUh+8c0P9TA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jan 2021 04:31:48 -0500 (EST)
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com
 [209.85.210.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2CFE34B266
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 04:31:48 -0500 (EST)
Received: by mail-pf1-f178.google.com with SMTP id o20so1455710pfu.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 01:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=weNjZrEErNFXHPTaQIIiTw8hbCn51QM6hPaZLo2TDko=;
 b=d5iBcuanzwfbdvR36IQ+qsOR6a8QsF1WATdXJqKyaRnjqYi0Esw85UmGyK7zAL2x+7
 1Auk0l2eCTBoGwSLjN1EvOMk6lBipyCw9ocuN8pUiO61PFXJJYN2UKIzGX6+YYaDV5Da
 cYiioEKebmXl+QkkRpOZMRtmkvJEOKZteVF73gDDJKMtwXds4a34CmWzUzEEw8P2jkOu
 SMhRPfUftfVc/9QEiflRheTKINE2Z3Py8Dc1AhrDglJO4ehV9wYgyfJHhu4VwzZaiyGD
 5FirodtnY+RSGmmgw0y0yQ5jgj+pBO1TLQZ60GDldG3/7DJ+pt4WlSuIIrecD+emI4v5
 ICBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=weNjZrEErNFXHPTaQIIiTw8hbCn51QM6hPaZLo2TDko=;
 b=I7GOmU0GViMG4/TiObVZygNenZtQnuCCd17YUsmKKhN8WIZFok6sKJksEOIZAzE7Xj
 vBHnovOHvo4lAssX1x7OldAgU2wkZmv19BEE7QN1QrnpDvd6eb43TVePb0U0HjzPkSMz
 lEhP6UX/nmZJJ/bP6NcrYLsXEGBAovP7Ai8tEadye1HJZZZK/UaD9gDs8RgJwvpH0p5B
 9LuyvHNcTuuWCPhj4UQK0jrskMQ+xGCgzVHwOzIbZHhB/4+OfBRoHmuAaft7FC7A7ydU
 oBB7fM4+Ax/SJcw9mRM8sUbti1J+ey5MmrdgSusTfyI84vtE0HbL9zaWW6omqYFyFe6m
 uSMw==
X-Gm-Message-State: AOAM530DTC+/00MAS5S5i/dE5s+XhMgVItyelBCovaQJCfU/oW8t9uCr
 K3Ao0D9UwRwXqKJJOu3fM2M=
X-Google-Smtp-Source: ABdhPJwWa+OnJ54swVw4LtN6TdwayZCIBZs0XWey0PmTyVWlKeAVuKwG5U+nZNRpYqEfkhTFCZyXLQ==
X-Received: by 2002:a65:63c7:: with SMTP id n7mr25633698pgv.285.1610962307166; 
 Mon, 18 Jan 2021 01:31:47 -0800 (PST)
Received: from localhost.localdomain ([122.10.161.207])
 by smtp.gmail.com with ESMTPSA id z13sm2828607pgf.89.2021.01.18.01.31.44
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Mon, 18 Jan 2021 01:31:46 -0800 (PST)
From: Yejune Deng <yejune.deng@gmail.com>
To: maz@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org
Subject: [PATCH] KVM: arm64: Fix the return value of smp_call_function_single()
Date: Mon, 18 Jan 2021 17:31:37 +0800
Message-Id: <20210118093137.3383-1-yejune.deng@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
X-Mailman-Approved-At: Mon, 18 Jan 2021 06:19:16 -0500
Cc: yejune.deng@gmail.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

In smp_call_function_single(), the 3rd parameter isn't the return value
and it's always positive. But it may return a negative value. So the
'ret' is should be the return value of the smp_call_function_single().

In check_kvm_target_cpu(), 'phys_target' is more readable than 'ret'.

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
---
 arch/arm64/kvm/arm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 04c44853b103..5fa5c04106de 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1815,9 +1815,9 @@ static int init_hyp_mode(void)
 	return err;
 }
 
-static void check_kvm_target_cpu(void *ret)
+static void check_kvm_target_cpu(void *phys_target)
 {
-	*(int *)ret = kvm_target_cpu();
+	*(int *)phys_target = kvm_target_cpu();
 }
 
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr)
@@ -1879,7 +1879,7 @@ void kvm_arch_irq_bypass_start(struct irq_bypass_consumer *cons)
 int kvm_arch_init(void *opaque)
 {
 	int err;
-	int ret, cpu;
+	int ret, cpu, phys_target;
 	bool in_hyp_mode;
 
 	if (!is_hyp_mode_available()) {
@@ -1900,7 +1900,7 @@ int kvm_arch_init(void *opaque)
 			 "Only trusted guests should be used on this system.\n");
 
 	for_each_online_cpu(cpu) {
-		smp_call_function_single(cpu, check_kvm_target_cpu, &ret, 1);
+		ret = smp_call_function_single(cpu, check_kvm_target_cpu, &phys_target, 1);
 		if (ret < 0) {
 			kvm_err("Error, CPU %d not supported!\n", cpu);
 			return -ENODEV;
-- 
2.29.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
