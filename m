Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E52DC433F5
	for <kvmarm@archiver.kernel.org>; Mon,  9 May 2022 12:03:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1AA24B2F8;
	Mon,  9 May 2022 08:03:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6NPn8vOP+ijI; Mon,  9 May 2022 08:03:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4D0B4B2E5;
	Mon,  9 May 2022 08:03:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6359D4B2D8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 08:03:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4gdjujBKYGFL for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 08:03:35 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 055964A36B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 08:03:34 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id
 r9-20020a1c4409000000b0039468585269so3127932wma.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 05:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=PEsOycq/BqUbO+joqsC0k3/vBLTkPzLqQtgkv0/3GNY=;
 b=D95TwjidHbGJTlpWhdnQhP8xeyiQM5Wl3Wd6d43amZNHx2r2A0bRj/GdLAJuM20xF2
 YuKzDh9HaACaoltlBQOiCRChlO1+sTR7G09M8621qMUyHwDaMzwMby526yVFlLm6fSTh
 V1BgbzPsxGNfM2qhT2Zt256CCtziEF0KUPKxgwGZbKKexNK98SQYGi6UOKVYleEqNTqO
 shOSlEvnyNAPZl4Qb9Ed1p6VSucWt6MtLLBGXs0FMpnrUB4ULti6F/RMToRCu7RPpbXc
 8eFxOevtMxdZ6YblQP6lMhva0cu1xzFNlqp/V47L0N/eV2gvZtsdan1v2ndtsWvl8iZE
 eytg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=PEsOycq/BqUbO+joqsC0k3/vBLTkPzLqQtgkv0/3GNY=;
 b=p07OirR3SlxPVgqkkWXhewVqK8Ix3PxTU+mdQurOV2OX1tp5gQEBWjFKLSI3aznFhS
 bs9hEzSAs3D605TENd9BxMi+CIeGdIOh0G+bDdSm8yBoTHV/80dnyP/4c5Qvm0U3A1ar
 PtXUfMFwk5ktzJKazOe3tYgE1fVZG/vLt1NGNV1tw4su1nL7DjBK9iopt21w95m/xlmG
 HL0U+cKprJYDM5JsDFFzGPLjr0K59L6nYAounK0/mixpDpk4mKjMudOQn568zV35x09Q
 en6oZWSsen+ZRTPO7ojKbfGeWoF8FBQq0tcDrMxH7DilYWNgDhX2zHpAoydCWWqnpEHT
 ogfA==
X-Gm-Message-State: AOAM5324VbxgpOpnr5aP9O+CAJNSEyEKmLgsmrHeycmxjhdZys8vh1/A
 PDa30jIgt3e7MvCH9L9PnAYv1uW1/NcQXjZKBrc4cZfQZvaiCh1Tdf8K0/6fkjdd5Zw8pYzyhVI
 I5OkGyFRiY6tChDh+bzMOmDiARh/Qym3qHNu/Q5FecdArkrX79QFcikRP7WgCAJ+dUEw=
X-Google-Smtp-Source: ABdhPJzex7lNd7SzGwLrdRB/ywArjVyPaFTHaYY7n9Dvh6Sh3zCzZ/8dAh9ayZN24LUXtQ5loKemTuLlvQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:3583:b0:394:77fc:d6a2
 with SMTP id
 p3-20020a05600c358300b0039477fcd6a2mr15673600wmq.63.1652097814110; Mon, 09
 May 2022 05:03:34 -0700 (PDT)
Date: Mon,  9 May 2022 12:03:27 +0000
In-Reply-To: <20220509120330.3043773-1-tabba@google.com>
Message-Id: <20220509120330.3043773-2-tabba@google.com>
Mime-Version: 1.0
References: <20220509120330.3043773-1-tabba@google.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v3 1/4] KVM: arm64: Wrapper for getting pmu_events
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
index 03a6c1f4a09a..4bd38ff34221 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -25,21 +25,31 @@ static bool kvm_pmu_switch_needed(struct perf_event_attr *attr)
 	return (attr->exclude_host != attr->exclude_guest);
 }
 
+static struct kvm_pmu_events *kvm_get_pmu_events(void)
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
+	struct kvm_pmu_events *pmu = kvm_get_pmu_events();
 
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
+	struct kvm_pmu_events *pmu = kvm_get_pmu_events();
 
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
+	pmu = kvm_get_pmu_events();
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
+	pmu = kvm_get_pmu_events();
+	events_guest = pmu->events_guest;
+	events_host = pmu->events_host;
 
 	kvm_vcpu_pmu_enable_el0(events_host);
 	kvm_vcpu_pmu_disable_el0(events_guest);
-- 
2.36.0.512.ge40c2bad7a-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
