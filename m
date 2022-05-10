Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 089F4C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 09:57:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F6994B1AB;
	Tue, 10 May 2022 05:57:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MNJTgH+NojWt; Tue, 10 May 2022 05:57:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A9E549EFF;
	Tue, 10 May 2022 05:57:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23FE34B0C2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 05:57:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rD8vZxbnWQ72 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 May 2022 05:57:15 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 033D14B0F5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 05:57:14 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id
 e9-20020a05600c4e4900b00394779649b1so1046790wmq.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 02:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=7tYpf+XT7mqI5zWxw47YWbNdAk9NQpBh8N59P16iZps=;
 b=JLXcjvk+IY4Z774b57vzytjw/LTp7NpJOIL/tlbDd9FP+oJ2WSZOpvoLPIZh9M9R2q
 vy2/eIwg8KGFk1sWxZ0ZGUa6Gn69nTU/XjdsN06Dyew10vGSQ/vs941bDwQGeTbagiE7
 4waFgHP+qlXvZGc2EpRhP9IPYvxI48gw7buC1bp9wh3wOmprHaPKkC9HAmWHgTqYdlPS
 Bak4TpzVI7ZU9268sprBG1Hu8cBzzedrF4CPaOCaNI6Zzahd/+n7lvbYW6ULxexfigOm
 qGiGJOlRsEtAv96mwVGeeREn3LmSrbVdKiqoBOvuZg4vnKJ+zxZ47jPL5HB4Ks8y92a/
 csTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=7tYpf+XT7mqI5zWxw47YWbNdAk9NQpBh8N59P16iZps=;
 b=ZDfygs/bESxF5a50A8OtFC0V8/UrgqCEkpH1o1D1WuWorf6A6e3KedG0/aEuRVyhsW
 eWRinlsHOyhdCPQV8rxkvo5zUKhfdFq5GTVYrxuAk4fJFBuqBlWtJzEmG0Om2k3PaEns
 V/TuHIVe7Tnl8PxowTKjpxrPnri5CeWt+6+i3D8p6Q1pFTfbdLzUPr+DU5C4odS6H94U
 1eijn4dBicJsUyWAQy96FeNgEeFB5lMXBEcsmjRoJ1ROPxMRbh3LiPGqVHiXgzjHwRu9
 xcA5ql4F7wCgfJgsNDHy31wlxdsS+TE8ZQ4aKWLH30yyMfiKFqlg9nfk7N+Fa9HDv7wd
 pcfQ==
X-Gm-Message-State: AOAM530i277+onXnRiJhTkJU0pY9xbWO/dfNvVziuBCLT33X6WXj7Wan
 UH+hQXK1o5l40HPkCs2MyTBDEJEJGtoi3eKZ9H4GwGt7XE75Y/H/ssh/uzLd2RwFr/Uux2MQRsl
 BymCEjHbYGOhBASyO9QKVhr/zbmej9LpWXXPhli4lLIeTnNkFfGRYQXv4PewmniAaf8E=
X-Google-Smtp-Source: ABdhPJweAUnGLDe5eXP7PWtCeinDLLVpuencYzseISdW/noLsSVemwzynd4ZY3BhcPIG0+uLrQnO21B9qQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:1553:b0:394:7642:7927
 with SMTP id
 f19-20020a05600c155300b0039476427927mr21101313wmg.16.1652176633992; Tue, 10
 May 2022 02:57:13 -0700 (PDT)
Date: Tue, 10 May 2022 09:57:07 +0000
In-Reply-To: <20220510095710.148178-1-tabba@google.com>
Message-Id: <20220510095710.148178-2-tabba@google.com>
Mime-Version: 1.0
References: <20220510095710.148178-1-tabba@google.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v4 1/4] KVM: arm64: Wrapper for getting pmu_events
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

Reviewed-by: Oliver Upton <oupton@google.com>
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
