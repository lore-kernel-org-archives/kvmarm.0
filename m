Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11FCBC433EF
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 08:41:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 680C74B164;
	Fri,  8 Apr 2022 04:41:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OqJD2mlj34FU; Fri,  8 Apr 2022 04:41:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 210214B190;
	Fri,  8 Apr 2022 04:41:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1CA34B191
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 04:40:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bF169snLVX-2 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2022 04:40:57 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B061349F20
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 04:40:57 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id
 j6-20020a05600c1c0600b0038e7d07ebcaso2085144wms.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2022 01:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=LyDJmbc6nMyu9SqFkdCVfRuw20aqoQ+eVo1CxcriK0Q=;
 b=AWfeAcuBrGqYMES/PReNxM1XZXjrhduKo6KW+tfZ/y3VNlNUj5YwKv2mJJDYhHQ++/
 9ObdW3SCMl5GDRzCmv1sEcpbdrfyXPaNSp5O9Cr+8nFeTlSm2fG3IndQ0YdInAaeag7U
 NQB9utZaMymR3+nrvNVt99T5BgD2HGaymqkN/wTT2kldkOJLNIvyeAebzlwu3293Zjam
 d3IautnXo40AVx4lxQSjklEVdBgt4TnG0uCsgnu00gV/UfOgYXUF2vfCEpJKXG3/GQ38
 YCbWypVbzjm1SmJHin+D6nWnYP3FpKD1PJoWmCy9ivRJLiI+3nLo1bhh8gkbgHrM3S8N
 H+Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=LyDJmbc6nMyu9SqFkdCVfRuw20aqoQ+eVo1CxcriK0Q=;
 b=BCVFFz6BjVuoRENPgGyY4nGImdu5NfnY5PLKPo4w5t705gKT+NnfujHPXzOKRtO33l
 PG3xNaQI6iVHjgCkbRRXW+hp9gy52SKDb1p/x/Doba+5bIitlhBOpcwvm40+7YUDwcUg
 NLYX26AWlZJ+/khTuOckmGDWrpOpbDPjnyfpHd5ubjm5IBHTmiWYOjfU462CFF6a5Aux
 z1X54BJleFlFZ1A0mv49uQc+uyh180WHyAh+RhkId68WEStNf2JVIkZVf+t1uyrEc3n4
 bAFSEeIYnnJX+bXId1AesCG0DMTuMV/xWrfKXsiqOAzH9hZKqaRnG9izuI2i4zEyHqem
 nB9A==
X-Gm-Message-State: AOAM532LzyZIfAr/YdWzXFRXG5OJanZGVXTfoLKGXz//UMxv716llLNV
 cRNPXnmIOelfUIZ1vTR4f3zDauTf1jO/RFZa3EHcfzXAn/w0P/6dAWTkr26emu9uUX15uHobIDz
 hWOsp4khOsonKvZrzl/LAzHtF6JGbLMkryc5z6Ybqitz4hw4ouvYG4fve85v3UWCgjmM=
X-Google-Smtp-Source: ABdhPJwcwJKTFKHdWVHs0DHwjSzunvpscueaTN17VxvDtj4+qD4ue3cgyCG+Nu8rIuQWDFDjaGq2K96DpA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:600c:3789:b0:38c:bd93:77d6
 with SMTP id
 o9-20020a05600c378900b0038cbd9377d6mr16172413wmr.12.1649407256759; Fri, 08
 Apr 2022 01:40:56 -0700 (PDT)
Date: Fri,  8 Apr 2022 09:40:50 +0100
In-Reply-To: <20220408084052.3310931-1-tabba@google.com>
Message-Id: <20220408084052.3310931-2-tabba@google.com>
Mime-Version: 1.0
References: <20220408084052.3310931-1-tabba@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v1 1/3] KVM: arm64: Wrapper for getting pmu_events
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, maz@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Eases migrating away from using hyp data and simplifies the code.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/pmu.c | 42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 03a6c1f4a09a..310d47c9990f 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -25,21 +25,31 @@ static bool kvm_pmu_switch_needed(struct perf_event_attr *attr)
 	return (attr->exclude_host != attr->exclude_guest);
 }
 
+static struct kvm_pmu_events *get_kvm_pmu_events(void)
+{
+	struct kvm_host_data *ctx = this_cpu_ptr_hyp_sym(kvm_host_data);
+
+	if (!ctx)
+		return NULL;
+
+	return &ctx->pmu_events;
+}
+
 /*
  * Add events to track that we may want to switch at guest entry/exit
  * time.
  */
 void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr)
 {
-	struct kvm_host_data *ctx = this_cpu_ptr_hyp_sym(kvm_host_data);
+	struct kvm_pmu_events *pmu = get_kvm_pmu_events();
 
-	if (!kvm_arm_support_pmu_v3() || !ctx || !kvm_pmu_switch_needed(attr))
+	if (!kvm_arm_support_pmu_v3() || !pmu || !kvm_pmu_switch_needed(attr))
 		return;
 
 	if (!attr->exclude_host)
-		ctx->pmu_events.events_host |= set;
+		pmu->events_host |= set;
 	if (!attr->exclude_guest)
-		ctx->pmu_events.events_guest |= set;
+		pmu->events_guest |= set;
 }
 
 /*
@@ -47,13 +57,13 @@ void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr)
  */
 void kvm_clr_pmu_events(u32 clr)
 {
-	struct kvm_host_data *ctx = this_cpu_ptr_hyp_sym(kvm_host_data);
+	struct kvm_pmu_events *pmu = get_kvm_pmu_events();
 
-	if (!kvm_arm_support_pmu_v3() || !ctx)
+	if (!kvm_arm_support_pmu_v3() || !pmu)
 		return;
 
-	ctx->pmu_events.events_host &= ~clr;
-	ctx->pmu_events.events_guest &= ~clr;
+	pmu->events_host &= ~clr;
+	pmu->events_guest &= ~clr;
 }
 
 #define PMEVTYPER_READ_CASE(idx)				\
@@ -169,16 +179,16 @@ static void kvm_vcpu_pmu_disable_el0(unsigned long events)
  */
 void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu)
 {
-	struct kvm_host_data *host;
+	struct kvm_pmu_events *pmu;
 	u32 events_guest, events_host;
 
 	if (!kvm_arm_support_pmu_v3() || !has_vhe())
 		return;
 
 	preempt_disable();
-	host = this_cpu_ptr_hyp_sym(kvm_host_data);
-	events_guest = host->pmu_events.events_guest;
-	events_host = host->pmu_events.events_host;
+	pmu = get_kvm_pmu_events();
+	events_guest = pmu->events_guest;
+	events_host = pmu->events_host;
 
 	kvm_vcpu_pmu_enable_el0(events_guest);
 	kvm_vcpu_pmu_disable_el0(events_host);
@@ -190,15 +200,15 @@ void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu)
  */
 void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)
 {
-	struct kvm_host_data *host;
+	struct kvm_pmu_events *pmu;
 	u32 events_guest, events_host;
 
 	if (!kvm_arm_support_pmu_v3() || !has_vhe())
 		return;
 
-	host = this_cpu_ptr_hyp_sym(kvm_host_data);
-	events_guest = host->pmu_events.events_guest;
-	events_host = host->pmu_events.events_host;
+	pmu = get_kvm_pmu_events();
+	events_guest = pmu->events_guest;
+	events_host = pmu->events_host;
 
 	kvm_vcpu_pmu_enable_el0(events_host);
 	kvm_vcpu_pmu_disable_el0(events_guest);
-- 
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
