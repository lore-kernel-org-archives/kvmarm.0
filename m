Return-Path: <SRS0=PxFR=EK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69312C55178
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E5C9C2075E
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Wd2U/unp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E5C9C2075E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82E7B4B6E6;
	Wed,  4 Nov 2020 13:37:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9zGrJwWBFhtw; Wed,  4 Nov 2020 13:37:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17FA34B7FE;
	Wed,  4 Nov 2020 13:37:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FDD44B7AD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GuJ7Snj7Bfbt for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2020 13:37:31 -0500 (EST)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 912954B781
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:31 -0500 (EST)
Received: by mail-wm1-f67.google.com with SMTP id h62so3288212wme.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2020 10:37:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=EXNwt+3vSlZrX0Tc14BJDd1gNrfJjl5kGrrEIH8XAj4=;
 b=Wd2U/unpY3ZmVHfcTbXAiJY7KLJhty+qkCnEOe1v+9gF7Tk+esJECns+5NE7xRADVQ
 rb4jMmrIrDFF3Uqc+kw+TsQP0kUBbP0Q60mBlfNxiHzEXnQZF440tMQx2el8T+naYfSe
 nl6S2po85sezmLtPjaY/udhRbTngUIYz9zKldqnrNaoNQummnBHmMim25jYYlhSDGnMB
 Cuq7Q+xfCJoLb+/MPsBLXPPSxHnCmLW/mhKnoYOoXXFQRNHjTAzA522j5kTSmzHtOXCP
 IKtntiI2vPQxFCCjANt2TbA2A8r58wUouHeIdCcZ/vjLL7AFsxzBAHJM1tvSTiqOAKAb
 /xjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=EXNwt+3vSlZrX0Tc14BJDd1gNrfJjl5kGrrEIH8XAj4=;
 b=CpB+5xwoxB+mgRKnBinCR7bye+kfz1Bd8WC1X0p5FRTsgwQyKY0K84AF7mJLFkWZps
 nGhNcirjiUL9sC20U8r8mKiwcs2JhRX1Hy3Z1e1CV7hs7J3dpAIYDMsVMy/RiZIKSm74
 B/o+q3h7dyVvrYhsBqoFO+yO3jmPW1rN+2X4XpS1WUZXLLONMnlt/CyJCx8sOFnRHlCS
 k6ki+SZitMbQtYbRKlQEpn6pa89dvf4NVhK/nYnQaLTAFzAy+9igVIk0crZGxcJ09GFg
 8x5ytEQk5WicU2zEeq2HeciCVgEqrS8M9EO/oOqTfdE8sb+gFT5HrapykOPyfYZnr1k3
 kGOw==
X-Gm-Message-State: AOAM53088OnIfvPPa8zexpLwQlUfEKzoeqo6SbcNOIgZoAp9fsoFBLPd
 Jw3HfGYGzflrSQ5LzS1dP967RNTZ4etU42GM
X-Google-Smtp-Source: ABdhPJwYR8Ha03TCz1M7oXikmCAwIAt1jt3ItFF9iYz0IjOXIOyB9xrETMaJm4+yQW9aUe1KTMy7ig==
X-Received: by 2002:a7b:c401:: with SMTP id k1mr5901008wmi.120.1604515050112; 
 Wed, 04 Nov 2020 10:37:30 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:c8d2:30f2:53c6:bc2])
 by smtp.gmail.com with ESMTPSA id h4sm3635371wrp.52.2020.11.04.10.37.28
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 Nov 2020 10:37:28 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 24/26] kvm: arm64: Keep nVHE EL2 vector installed
Date: Wed,  4 Nov 2020 18:36:28 +0000
Message-Id: <20201104183630.27513-25-dbrazdil@google.com>
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

KVM by default keeps the stub vector installed and installs the nVHE
vector only briefly for init and later on demand. Change this policy
to install the vector at init and then never uninstall it.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/arm.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 6fbda652200b..3dff6af69eca 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -64,6 +64,11 @@ static bool vgic_present;
 static DEFINE_PER_CPU(unsigned char, kvm_arm_hardware_enabled);
 DEFINE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
+static bool keep_hyp_installed(void)
+{
+	return !is_kernel_in_hyp_mode();
+}
+
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
@@ -1430,7 +1435,8 @@ static void _kvm_arch_hardware_disable(void *discard)
 
 void kvm_arch_hardware_disable(void)
 {
-	_kvm_arch_hardware_disable(NULL);
+	if (!keep_hyp_installed())
+		_kvm_arch_hardware_disable(NULL);
 }
 
 #ifdef CONFIG_CPU_PM
@@ -1473,11 +1479,13 @@ static struct notifier_block hyp_init_cpu_pm_nb = {
 
 static void __init hyp_cpu_pm_init(void)
 {
-	cpu_pm_register_notifier(&hyp_init_cpu_pm_nb);
+	if (!keep_hyp_installed())
+		cpu_pm_register_notifier(&hyp_init_cpu_pm_nb);
 }
 static void __init hyp_cpu_pm_exit(void)
 {
-	cpu_pm_unregister_notifier(&hyp_init_cpu_pm_nb);
+	if (!keep_hyp_installed())
+		cpu_pm_unregister_notifier(&hyp_init_cpu_pm_nb);
 }
 #else
 static inline void hyp_cpu_pm_init(void)
@@ -1580,7 +1588,8 @@ static int init_subsystems(void)
 	kvm_coproc_table_init();
 
 out:
-	on_each_cpu(_kvm_arch_hardware_disable, NULL, 1);
+	if (err || !keep_hyp_installed())
+		on_each_cpu(_kvm_arch_hardware_disable, NULL, 1);
 
 	return err;
 }
-- 
2.29.1.341.ge80a0c044ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
