Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D26FFC433E6
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:03:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6EC1C64EF6
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:03:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6EC1C64EF6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A3C64B69B;
	Fri, 19 Mar 2021 06:03:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 10TWciTgcS7J; Fri, 19 Mar 2021 06:03:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2356D4B77F;
	Fri, 19 Mar 2021 06:03:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7D824B69B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:03:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P5fJpog3QP2J for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 06:03:03 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EACB84B682
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:03:02 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id k4so31803439qvf.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 03:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=72klzlc424mmLnO4+mJQoCgQ9qRpj0AFz2PNi4O1btg=;
 b=TMZfoBWZybpbOvmfNQdWuKj+QVKLPZzdehM7jBlnqDYUOKYV3P/bzmuXd9DoW51F8R
 H6kFU8L0dmMyPxVo6VKzl0acSAKA4miwiVfDJC2HaQLLKPJVKpVuNECdOvffl0h20EGZ
 dki+nPIqygOPTh07KcxIji93rqNvHQ/YplTidtBxHrXcga0uelpTSZ2ciZ26j4uc0BiH
 HGy7Ctq2zMR9RMv3+Nww1SOu1DedI/hlRfgdFh1lRqoBGPGSb0v4Eu5hpQ/sOow7W0QU
 BiB9P1/vWKs+V5Dv34S8S2KeMqtEpLRBiF45IC2HkWJWzyyj0By+9TDBtYVd88DAn7ux
 XhiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=72klzlc424mmLnO4+mJQoCgQ9qRpj0AFz2PNi4O1btg=;
 b=OCWetifX+xiRlwpMjVzJg2tUTOK5FCSivWd5HdGWerwSh2sxdWaeuj592MSMIfAwpX
 P080wXoloCxbR7/ntxow7Acsrsry8bTcQFbjjH7Y+wXG/Rqv5416PU+eHGN12V+TfV5h
 w2XXnK14c9JKaRu1HLNLF4WIsVtWCwD5e2zj91V/6mFUmtIbORECTYZUevnWuQ30r3Dc
 lp9e1+5t9yjTR8gEdT1OhVHxGK9fbdSgOpq/32g0ITM1snp+pTDHtubYZDmQJKOabAQV
 kqD/qqTBOgZQj2P6u1xybCcYgxPbz7umz3WRh3jnwGVV1DnNSNau6UYAxAJPKt9O1HMX
 tigA==
X-Gm-Message-State: AOAM530j7NGYujSdY0n4H/D5nK6kIQ77/eWeFWretC00Hz/LI/WJykNg
 8ouLmHvFXRNffA7Snps7lWpvscSabLla
X-Google-Smtp-Source: ABdhPJz5Nn0SRzIcLJbprGdjasWPY3TTPXoVZ8gwqBfwupsjTDVeieeAgP/GqFP3q3tkNq0mnFuOA6wwnW1X
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:6214:15d1:: with SMTP id
 p17mr8491639qvz.28.1616148182510; Fri, 19 Mar 2021 03:03:02 -0700 (PDT)
Date: Fri, 19 Mar 2021 10:01:42 +0000
In-Reply-To: <20210319100146.1149909-1-qperret@google.com>
Message-Id: <20210319100146.1149909-35-qperret@google.com>
Mime-Version: 1.0
References: <20210319100146.1149909-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v6 34/38] KVM: arm64: Provide sanitized mmfr* registers at EL2
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

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_cpufeature.h | 2 ++
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c       | 2 ++
 arch/arm64/kvm/sys_regs.c               | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_cpufeature.h b/arch/arm64/include/asm/kvm_cpufeature.h
index c2e7735f502b..ff302d15e840 100644
--- a/arch/arm64/include/asm/kvm_cpufeature.h
+++ b/arch/arm64/include/asm/kvm_cpufeature.h
@@ -20,5 +20,7 @@
 #endif
 
 DECLARE_KVM_HYP_CPU_FTR_REG(arm64_ftr_reg_ctrel0);
+DECLARE_KVM_HYP_CPU_FTR_REG(arm64_ftr_reg_id_aa64mmfr0_el1);
+DECLARE_KVM_HYP_CPU_FTR_REG(arm64_ftr_reg_id_aa64mmfr1_el1);
 
 #endif
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
index 71f00aca90e7..17ad1b3a9530 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
@@ -13,6 +13,8 @@
  * Copies of the host's CPU features registers holding sanitized values.
  */
 DEFINE_KVM_HYP_CPU_FTR_REG(arm64_ftr_reg_ctrel0);
+DEFINE_KVM_HYP_CPU_FTR_REG(arm64_ftr_reg_id_aa64mmfr0_el1);
+DEFINE_KVM_HYP_CPU_FTR_REG(arm64_ftr_reg_id_aa64mmfr1_el1);
 
 /*
  * nVHE copy of data structures tracking available CPU cores.
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
