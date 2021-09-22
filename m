Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 500BBC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 01:09:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D8F0760F4B
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 01:09:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D8F0760F4B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BF924A3BF;
	Tue, 21 Sep 2021 21:09:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N1NM4R8n7SC2; Tue, 21 Sep 2021 21:09:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 491B84A49C;
	Tue, 21 Sep 2021 21:09:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98B344B0A3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 21:09:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iIGPV0koxolB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Sep 2021 21:09:00 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F185540573
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 21:08:59 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id
 l22-20020a05622a175600b0029d63a970f6so4867554qtk.23
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 18:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=f+eE05PCo8qChOi7C3TCse89XUY8p/e5JYZmdwEBrZo=;
 b=dJPqGgERbK013/94/AiM4dAyiKix1/DKn7frupuhal/2UEb+36tkSAU2QR5HuvuUrP
 I5lfIfz9mix3ljONjQSJPZsqUxztzw7TWpmga75sAbCpjGjAK5UHn8GmdunRx04JBBEa
 OSPrE6uEN4QUVW+aVCib2A81IVnBp5IFyxqGxm6PvXA4MAE2YJQNDMR3/msn9XXHFFW6
 9X8ORVIypjoWIBFobLZl9reRnKzG6nKCZzWycg2LhY+60z/e3pfcSmkqhxYxDAaDxsvp
 2eiyr+v4RXb88q/WrE74qS+8EHkrtgmikQdbp6ikP1p8w2pEsPV13MN/vtenr9P9f0qK
 EdAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=f+eE05PCo8qChOi7C3TCse89XUY8p/e5JYZmdwEBrZo=;
 b=LoPExbdYRZbZE70ITQzA06tfSIQUop7Lmgky0SlpfPgUCc072DvPaXURIFv1cAg9nj
 DXOeIox7tA0tCnbQBieCyfIVp23i/hDP3hDxQocfv7uWdYF+qjHis1Hntkj2T99hEXZu
 sAI0cajqF6Cn2ehtSA3bZF45xTuEINSuaPrTiI426CbxoSa2yx4pZlYn75q273KADbCj
 ejCPt95X+l+PkZkCU8Kj721dlKDkJJgfF+G8MYqWl4/+0ax5u8/nrSXdQCwUDQT1WCnp
 7pHVdOlthlxQ0JYrYEQXeuTbPTI2sKhjVpAMEiS++fPE8tUQ8DSn0eiG2PNpEA+b81vE
 tSEA==
X-Gm-Message-State: AOAM532MoOK5tMUuZUhKOF1Xs8Pvr58/TFKhdzpYTduU6zEe674kbT6/
 QSvUcox3ZnxfNKkdtRlQYiUpre92W7Ml8hrb4w==
X-Google-Smtp-Source: ABdhPJy3KpjeASdvmJujfjGe+YN1WNhBl+SU4AAgG4BY/Um41MpzopZrZLsD49XgUs0vHx6qrAvH2+FIjjqSM5Xoxw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a0c:e381:: with SMTP id
 a1mr29432178qvl.42.1632272939620; Tue, 21 Sep 2021 18:08:59 -0700 (PDT)
Date: Wed, 22 Sep 2021 01:08:51 +0000
In-Reply-To: <20210922010851.2312845-1-jingzhangos@google.com>
Message-Id: <20210922010851.2312845-3-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210922010851.2312845-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v1 3/3] KVM: arm64: Add histogram stats for handling time of
 arch specific exit reasons
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>, 
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, 
 David Matlack <dmatlack@google.com>, Peter Shier <pshier@google.com>, 
 Oliver Upton <oupton@google.com>, Sean Christopherson <seanjc@google.com>
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

These logarithmic histogram stats are useful for monitoring performance
of handling for different kinds of VCPU exit reasons.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 36 ++++++++++++
 arch/arm64/kvm/arm.c              |  4 ++
 arch/arm64/kvm/guest.c            | 43 ++++++++++++++
 arch/arm64/kvm/handle_exit.c      | 95 +++++++++++++++++++++++++++++++
 4 files changed, 178 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4d65de22add3..f1a29ca3d4f3 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -417,6 +417,9 @@ struct kvm_vcpu_arch {
 
 	/* Arch specific exit reason */
 	enum arm_exit_reason exit_reason;
+
+	/* The timestamp for the last VCPU exit */
+	u64 last_exit_time;
 };
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
@@ -605,6 +608,8 @@ struct kvm_vm_stat {
 	struct kvm_vm_stat_generic generic;
 };
 
+#define ARM_EXIT_HIST_CNT	64
+
 struct kvm_vcpu_stat {
 	struct kvm_vcpu_stat_generic generic;
 	u64 mmio_exit_user;
@@ -641,6 +646,36 @@ struct kvm_vcpu_stat {
 		u64 exit_fp_asimd;
 		u64 exit_pac;
 	};
+	/* Histogram stats for handling time of arch specific exit reasons */
+	struct {
+		u64 exit_unknown_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_irq_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_el1_serror_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_hyp_gone_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_il_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_wfi_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_wfe_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_cp15_32_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_cp15_64_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_cp14_32_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_cp14_ls_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_cp14_64_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_hvc32_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_smc32_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_hvc64_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_smc64_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_sys64_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_sve_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_iabt_low_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_dabt_low_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_softstp_low_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_watchpt_low_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_breakpt_low_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_bkpt32_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_brk64_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_fp_asimd_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_pac_hist[ARM_EXIT_HIST_CNT];
+	};
 };
 
 int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init);
@@ -715,6 +750,7 @@ void force_vm_exit(const cpumask_t *mask);
 
 int handle_exit(struct kvm_vcpu *vcpu, int exception_index);
 void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index);
+void update_hist_exit_stats(struct kvm_vcpu *vcpu);
 
 int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu);
 int kvm_handle_cp14_32(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fe102cd2e518..156f80b699d3 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -795,6 +795,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	ret = 1;
 	run->exit_reason = KVM_EXIT_UNKNOWN;
 	while (ret > 0) {
+		/* Update histogram stats for exit reasons */
+		update_hist_exit_stats(vcpu);
+
 		/*
 		 * Check conditions before entering the guest
 		 */
@@ -903,6 +906,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 */
 		guest_exit();
 		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
+		vcpu->arch.last_exit_time = ktime_to_ns(ktime_get());
 
 		/* Exit types that need handling before we can be preempted */
 		handle_exit_early(vcpu, ret);
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index abd9327d7110..bbf51578fdec 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -75,6 +75,49 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, exit_brk64),
 	STATS_DESC_COUNTER(VCPU, exit_fp_asimd),
 	STATS_DESC_COUNTER(VCPU, exit_pac),
+	/* Histogram stats for handling time of arch specific exit reasons */
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_unknown_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_irq_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_el1_serror_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_hyp_gone_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU, exit_il_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU, exit_wfi_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU, exit_wfe_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_cp15_32_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_cp15_64_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_cp14_32_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_cp14_ls_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_cp14_64_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU, exit_hvc32_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU, exit_smc32_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU, exit_hvc64_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU, exit_smc64_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU, exit_sys64_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU, exit_sve_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_iabt_low_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_dabt_low_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_softstp_low_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_watchpt_low_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_breakpt_low_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU, exit_bkpt32_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU, exit_brk64_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_fp_asimd_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU, exit_pac_hist, ARM_EXIT_HIST_CNT),
 };
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index e83cd52078b2..5e642a6275c1 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -395,3 +395,98 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 	panic("HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%016lx\n",
 	      spsr, elr_virt, esr, far, hpfar, par, vcpu);
 }
+
+void update_hist_exit_stats(struct kvm_vcpu *vcpu)
+{
+	u64 val = ktime_to_ns(ktime_get()) - vcpu->arch.last_exit_time;
+
+	if (unlikely(!vcpu->arch.last_exit_time))
+		return;
+
+	switch (vcpu->arch.exit_reason) {
+	case ARM_EXIT_UNKNOWN:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_unknown_hist, val);
+		break;
+	case ARM_EXIT_IRQ:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_irq_hist, val);
+		break;
+	case ARM_EXIT_EL1_SERROR:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_el1_serror_hist, val);
+		break;
+	case ARM_EXIT_HYP_GONE:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_hyp_gone_hist, val);
+		break;
+	case ARM_EXIT_IL:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_il_hist, val);
+		break;
+	case ARM_EXIT_WFI:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_wfi_hist, val);
+		break;
+	case ARM_EXIT_WFE:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_wfe_hist, val);
+		break;
+	case ARM_EXIT_CP15_32:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_cp15_32_hist, val);
+		break;
+	case ARM_EXIT_CP15_64:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_cp15_64_hist, val);
+		break;
+	case ARM_EXIT_CP14_32:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_cp14_32_hist, val);
+		break;
+	case ARM_EXIT_CP14_LS:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_cp14_ls_hist, val);
+		break;
+	case ARM_EXIT_CP14_64:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_cp14_64_hist, val);
+		break;
+	case ARM_EXIT_HVC32:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_hvc32_hist, val);
+		break;
+	case ARM_EXIT_SMC32:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_smc32_hist, val);
+		break;
+	case ARM_EXIT_HVC64:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_hvc64_hist, val);
+		break;
+	case ARM_EXIT_SMC64:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_smc64_hist, val);
+		break;
+	case ARM_EXIT_SYS64:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_sys64_hist, val);
+		break;
+	case ARM_EXIT_SVE:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_sve_hist, val);
+		break;
+	case ARM_EXIT_IABT_LOW:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_iabt_low_hist, val);
+		break;
+	case ARM_EXIT_DABT_LOW:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_dabt_low_hist, val);
+		break;
+	case ARM_EXIT_SOFTSTP_LOW:
+		KVM_STATS_LOG_HIST_UPDATE(
+				vcpu->stat.exit_softstp_low_hist, val);
+		break;
+	case ARM_EXIT_WATCHPT_LOW:
+		KVM_STATS_LOG_HIST_UPDATE(
+				vcpu->stat.exit_watchpt_low_hist, val);
+		break;
+	case ARM_EXIT_BREAKPT_LOW:
+		KVM_STATS_LOG_HIST_UPDATE(
+				vcpu->stat.exit_breakpt_low_hist, val);
+		break;
+	case ARM_EXIT_BKPT32:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_bkpt32_hist, val);
+		break;
+	case ARM_EXIT_BRK64:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_brk64_hist, val);
+		break;
+	case ARM_EXIT_FP_ASIMD:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_fp_asimd_hist, val);
+		break;
+	case ARM_EXIT_PAC:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_pac_hist, val);
+		break;
+	}
+}
-- 
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
