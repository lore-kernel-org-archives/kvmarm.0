Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B85C5C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:03:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 33A5B64F6A
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:03:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33A5B64F6A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB2084B795;
	Fri, 19 Mar 2021 06:03:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UATZex91ZYPI; Fri, 19 Mar 2021 06:03:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB2904B787;
	Fri, 19 Mar 2021 06:03:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DE834B72A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:03:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U1MEEYWZRM0w for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 06:03:10 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E9F94B786
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:03:10 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id z6so21531860wrh.11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 03:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=B1o/tWAgXq2CfBeEXWR8qd9iUkNYsN5CjCSGu1Kqq9M=;
 b=IIpYdevqjuz3Dt+0g749eHxi3/lKZ6lv2eB7vGkp8aylMJTha2kBOFJ33jcWwBBvbL
 fsYtpnkTHIvNCNR0QP/MFIHW12ET3w3p0A83KgJqStIL+kvekjM0pCp9O8inXFXKFaIT
 W89OAcxQWgjL8SdmPz+W5k6C6SUW7hFE6tgaj6uVOMXOFVcl8hiv0SdT9ikV4oEM+SCO
 YAL8MIoUnRpPnSpMyXthiAIg/5Nb5gNforc+Um021Yg3JWTAgOU6VHrt3djShKLi8kvK
 /jtr509scpifThJdhix+/zlgXKjF+OwzpsugsoXeGUIBqsmrbpOlZ3r6Q5y29wyATsd6
 bynw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=B1o/tWAgXq2CfBeEXWR8qd9iUkNYsN5CjCSGu1Kqq9M=;
 b=P1I9OemH6cOaoiKcQ301nf9T+EQriDhvzIo/M3aUQcy3/1ESf8J6N32XCR+IijYZJS
 F3ER5QPOeuq/TjqRFBxNEgH3lpXZUzRSgQ7Wt9SLkxkGKUOR8RJFb1sbWOTKJNEJ6yCN
 HdHuabSL8PkSM9I+BAQsyA9Qrm1LcE5fEnqyKtsFhAYdrCrHIjNpm52ogMmTCxLHy9Q4
 OsCOgXogUDFmAglRb4J1vMitz6cjSH2LAqhFsl/841GFwAbfhLCal3vJvbWtyhUnKwi1
 RFtP5HqvBAQatUoUJKYoE3bD/jPdvGEh+SSme0f5x+U3Lqc7zrr+Q5wqONbAbFV1tdti
 GwNw==
X-Gm-Message-State: AOAM530oAsQm33MvURC0pdbKiL/cS72sZa2Fs2rZ7+2gB/e6h+Ewo9Zh
 pBHJXrzTvKpGQhjB2yK811DSn95giTKx
X-Google-Smtp-Source: ABdhPJzyJ6jBqZnIFYxLIb1hQMYw/VHqB942OhtZTNlNumNwml6dV0RIjHk4MQe4PNbig7/dbzfGrtulqVAG
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:600c:3553:: with SMTP id
 i19mr3005427wmq.1.1616148189759; Fri, 19 Mar 2021 03:03:09 -0700 (PDT)
Date: Fri, 19 Mar 2021 10:01:45 +0000
In-Reply-To: <20210319100146.1149909-1-qperret@google.com>
Message-Id: <20210319100146.1149909-38-qperret@google.com>
Mime-Version: 1.0
References: <20210319100146.1149909-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v6 37/38] KVM: arm64: Disable PMU support in protected mode
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

The host currently writes directly in EL2 per-CPU data sections from
the PMU code when running in nVHE. In preparation for unmapping the EL2
sections from the host stage 2, disable PMU support in protected mode as
we currently do not have a use-case for it.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/perf.c | 3 ++-
 arch/arm64/kvm/pmu.c  | 8 ++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/perf.c b/arch/arm64/kvm/perf.c
index 739164324afe..8f860ae56bb7 100644
--- a/arch/arm64/kvm/perf.c
+++ b/arch/arm64/kvm/perf.c
@@ -55,7 +55,8 @@ int kvm_perf_init(void)
 	 * hardware performance counters. This could ensure the presence of
 	 * a physical PMU and CONFIG_PERF_EVENT is selected.
 	 */
-	if (IS_ENABLED(CONFIG_ARM_PMU) && perf_num_counters() > 0)
+	if (IS_ENABLED(CONFIG_ARM_PMU) && perf_num_counters() > 0
+				       && !is_protected_kvm_enabled())
 		static_branch_enable(&kvm_arm_pmu_available);
 
 	return perf_register_guest_info_callbacks(&kvm_guest_cbs);
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index faf32a44ba04..03a6c1f4a09a 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -33,7 +33,7 @@ void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr)
 {
 	struct kvm_host_data *ctx = this_cpu_ptr_hyp_sym(kvm_host_data);
 
-	if (!ctx || !kvm_pmu_switch_needed(attr))
+	if (!kvm_arm_support_pmu_v3() || !ctx || !kvm_pmu_switch_needed(attr))
 		return;
 
 	if (!attr->exclude_host)
@@ -49,7 +49,7 @@ void kvm_clr_pmu_events(u32 clr)
 {
 	struct kvm_host_data *ctx = this_cpu_ptr_hyp_sym(kvm_host_data);
 
-	if (!ctx)
+	if (!kvm_arm_support_pmu_v3() || !ctx)
 		return;
 
 	ctx->pmu_events.events_host &= ~clr;
@@ -172,7 +172,7 @@ void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu)
 	struct kvm_host_data *host;
 	u32 events_guest, events_host;
 
-	if (!has_vhe())
+	if (!kvm_arm_support_pmu_v3() || !has_vhe())
 		return;
 
 	preempt_disable();
@@ -193,7 +193,7 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)
 	struct kvm_host_data *host;
 	u32 events_guest, events_host;
 
-	if (!has_vhe())
+	if (!kvm_arm_support_pmu_v3() || !has_vhe())
 		return;
 
 	host = this_cpu_ptr_hyp_sym(kvm_host_data);
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
