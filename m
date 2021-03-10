Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55E5BC433DB
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:59:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EAB0B64FB3
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:59:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EAB0B64FB3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FFCF4B646;
	Wed, 10 Mar 2021 12:59:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kO-GmSlj2lMQ; Wed, 10 Mar 2021 12:59:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A296E4B6A5;
	Wed, 10 Mar 2021 12:59:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 567874B41F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:59:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6KFPR9ObRY6E for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 12:59:08 -0500 (EST)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E03544B6B0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:59:07 -0500 (EST)
Received: by mail-wr1-f74.google.com with SMTP id p12so5739487wrn.18
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 09:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=4EIGP2sevMQZpUEhabq0vC76HCNx6QyIyPvKeAoptlw=;
 b=IUQjACmevhkq9a+GZxx+Ua4aB9ez1Bug28fxYTbFk46qxQU32oTjX7DRLGH9l/Il7X
 FqP7G7yyiuLPnHPSwII8NLcc8xT3okF4VsOdVhhzD45KhzQKh06Ri+jitNWpfqbLNjbH
 s7lNBTP16IEnv0g+B92roDljctBUXo4JJN1l3q5jmxXNKvjrw4EX2MUG2YyqiyXTFc0v
 efw7ExzmKbpVMP1Qf7AqwLiKwmBN9zmwUKW/Xurj/d027vYb3d6dQtC+WGD06I7JSB1Y
 AFj0gkGVkEn9NnTYZK0YUmw6ye4NL3Qrs3yQ4hcfmWyjyO/wYe696C31It5TCXguX2XH
 NObg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=4EIGP2sevMQZpUEhabq0vC76HCNx6QyIyPvKeAoptlw=;
 b=quOnVj3vyvb6CuSlsZ49P7iZkgmjDBXf8cm6x119p+MFcMX1kT2UIhh6T7KYaDaw4X
 TasRpa/OS+Fni77WzgCyg04PUXnl6zgMvnZLP4HJ1GbVXWgW0ukoFzZNICy8TPBqzEMH
 cC0RyTHiEkQezWC6akvQ0rpES4bQ3lINyx8256xqY6asHxg78aFo7q7DVfHl1Vf23P0t
 lioBAKh5ZBS9T2WmTAwQtQFpm+Cmby44LNtaMvnKzrQWZbKXtggd7OvT26XHzDTCd9fa
 BW3m+8V2fExj1NDH5F1QDvBvewdfKp8fZY971FpnVewkTNHuPy+QgGrrsADBJTFZK2c3
 HALw==
X-Gm-Message-State: AOAM531eXxGTdCMgncrAvPnUi+DDOfXij+dQCTV8h2jJBLU6tSTduKmC
 yjuvx9Kk7ale69RF6WMqlcPNDRJZ5xXB
X-Google-Smtp-Source: ABdhPJxqMXK+TnYtjOGnCmi+0PPkd0E3rU72V4cOYCFhyuU5o0IeGdkRrDs5euTQUF4Pwmy1O7cEd08Y9MWQ
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:6000:1803:: with SMTP id
 m3mr4806187wrh.50.1615399147126; Wed, 10 Mar 2021 09:59:07 -0800 (PST)
Date: Wed, 10 Mar 2021 17:57:50 +0000
In-Reply-To: <20210310175751.3320106-1-qperret@google.com>
Message-Id: <20210310175751.3320106-34-qperret@google.com>
Mime-Version: 1.0
References: <20210310175751.3320106-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 33/34] KVM: arm64: Disable PMU support in protected mode
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, tabba@google.com
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
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
