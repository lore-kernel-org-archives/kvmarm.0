Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28292C433E6
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AD51E64FC4
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD51E64FC4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EE834B667;
	Mon, 15 Mar 2021 10:36:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id E2ePYDjGGgfo; Mon, 15 Mar 2021 10:36:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C259F4B6E1;
	Mon, 15 Mar 2021 10:36:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 275664B6F4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dHtkKnCCA-mq for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 10:36:47 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2EDD04B6FF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:47 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id a65so2913385wmh.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=1sjrUiSLuOCFjAOkDHJ7nIx3ITkYs7fzKUyioa9mJ40=;
 b=EOHSqjIMLmTf3oiHD3RmkQcg9TZQYTPctLXy/V0f4BziHbVqUX4uyYFanP57G0CqZI
 kzH0qQ5cG6HSkzlr2E6ZjBNTir0mCD9Xy/Q2r8YD/Q/0eD4/CfrgYntSiZXDWGJ8AQLF
 K7vAW/ZAEawiWUdqMIfWOXIHRSDOOGUN4+2mgH8PhRZEPrviBcwlTL64shC35HSCg2cV
 yA7QoWm3cE4oP82rVDLmEUTOKg7Gh6EkGAbV42LPvCYkPus+4yoeGdy5BNuntlGmO/HT
 hY8/sQzuF/64X1ZaQK/NfUB161/P5+453+qtxBm6aW4ApoFK5iIG/3lrPBatWLFurlbf
 oRAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=1sjrUiSLuOCFjAOkDHJ7nIx3ITkYs7fzKUyioa9mJ40=;
 b=XFt6y0XLQJi/f0q833zbKgP5G1dAtd33ckiC8v0pS7NsR/QBUtev2a+Df5Hju2lu1N
 kq4/FNZtScsFxYVEewUMQTU6mrPmps3qa5xEfhaXCqjQUdLDLinQ75u9+D7UuHukyxoX
 m1MfAxGcAMJ3V+oT8NCOVGtyKqsAqnUGdOzPUlicwf67WEM0gEG5SCPgl5t7XdklXU7y
 WiWimm3/6AuuL40VMnIEu7HtCyUbkb9TdwYSSJAwVclkqm4Jy1PIZytt3ccCmlzDr1x6
 kCb6VkQ7/n2NlHkkv+Q61HhuxIbFxb1jnSfIkVLeZylUsTpoZu7CK45DwPkhtDqfsZr0
 XxTw==
X-Gm-Message-State: AOAM5319CqxPyMZ4LUkgOIYes4psLh/4kwGtFVg4qwykaQXnvgMBRouz
 CuJItu5HM1PyP+2I2t6CUxR4ct8aTECr
X-Google-Smtp-Source: ABdhPJxRU1Y0mzNBnxlekqfWtLXk/SoCMst6R7gkuiF3eTNottSRcVQMhVqaCB4Xbuwrq8TclRXAUa/wMXdR
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a7b:c75a:: with SMTP id
 w26mr2323wmk.49.1615819006355; Mon, 15 Mar 2021 07:36:46 -0700 (PDT)
Date: Mon, 15 Mar 2021 14:35:32 +0000
In-Reply-To: <20210315143536.214621-1-qperret@google.com>
Message-Id: <20210315143536.214621-33-qperret@google.com>
Mime-Version: 1.0
References: <20210315143536.214621-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v5 32/36] KVM: arm64: Provide sanitized mmfr* registers at EL2
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org, tabba@google.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

We will need to read sanitized values of mmfr{0,1}_el1 at EL2 soon, so
add them to the list of copied variables.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_cpufeature.h | 2 ++
 arch/arm64/kvm/sys_regs.c               | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_cpufeature.h b/arch/arm64/include/asm/kvm_cpufeature.h
index efba1b89b8a4..48cba6cecd71 100644
--- a/arch/arm64/include/asm/kvm_cpufeature.h
+++ b/arch/arm64/include/asm/kvm_cpufeature.h
@@ -15,3 +15,5 @@
 #endif
 
 KVM_HYP_CPU_FTR_REG(arm64_ftr_reg_ctrel0);
+KVM_HYP_CPU_FTR_REG(arm64_ftr_reg_id_aa64mmfr0_el1);
+KVM_HYP_CPU_FTR_REG(arm64_ftr_reg_id_aa64mmfr1_el1);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3ec34c25e877..dfb3b4f9ca84 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2784,6 +2784,8 @@ struct __ftr_reg_copy_entry {
 	struct arm64_ftr_reg	*dst;
 } hyp_ftr_regs[] __initdata = {
 	CPU_FTR_REG_HYP_COPY(SYS_CTR_EL0, arm64_ftr_reg_ctrel0),
+	CPU_FTR_REG_HYP_COPY(SYS_ID_AA64MMFR0_EL1, arm64_ftr_reg_id_aa64mmfr0_el1),
+	CPU_FTR_REG_HYP_COPY(SYS_ID_AA64MMFR1_EL1, arm64_ftr_reg_id_aa64mmfr1_el1),
 };
 
 void __init setup_kvm_el2_caps(void)
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
