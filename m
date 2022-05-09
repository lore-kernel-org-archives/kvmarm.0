Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEC12C433FE
	for <kvmarm@archiver.kernel.org>; Mon,  9 May 2022 09:55:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 868F54B2FA;
	Mon,  9 May 2022 05:55:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tEpzYZpwGN5V; Mon,  9 May 2022 05:55:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69C9A4B2E5;
	Mon,  9 May 2022 05:55:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4CA54B2E3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 05:55:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7iE8vuFKCtC7 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 05:55:06 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 865BE4B25F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 05:55:06 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 m8-20020adfc588000000b0020c4edd8a57so5568063wrg.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 02:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=PEsOycq/BqUbO+joqsC0k3/vBLTkPzLqQtgkv0/3GNY=;
 b=g+c+j7bSPEpCCZWJ0yc4bDlMeBuvKdOYSdoiinO/IP2PCsLySXUFR9IAdRQs1S3tvu
 PgLelUeE6kn8ZAGqxtbMk1YS+txI61vJkl2yOo5l08EGPAqXYXL9OqlhTUxIcidp9P8z
 8ufEBABduWfAeM35eMBwGg7LiRpbESdvrQr8EMslXoQf8Fc/5y5mCPAg1aTLCpuAU3/x
 MvYNCvh6ohHRKwPFkSOBYdz+PQltzP3+xMSTb9J2Oo8KrkRiiSwaB71oTSjUqrHkFTiJ
 Xq/kxtHzkmPNttJ2KDJ3qCYCH+BG2GU4xdC8JvCD3VC8owBEPj+/ir2Uu4erigZ2waIl
 zgMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=PEsOycq/BqUbO+joqsC0k3/vBLTkPzLqQtgkv0/3GNY=;
 b=PqC3oIRudSFZlXcmgkPBQhYcM6m/esv/0rJWkbZw89kbSoqQrt4yGWy/R8NE2iCsty
 pjo97iKgK9hJBmzzg/Mdvm11IXNsMuo09syR2RvNFTNfeiS6m+3dJ/C9yJKrVTrJwR5+
 JEU32IgwEA+1j1uepXh2gWAimReG3Lqck4E7cxA+F4jrQclFkfyPnfpriBkCXplMHKVG
 oN9Zzr20VaDbdrBlcyah0KF2UZWd3M/Liz3Z1cuilWFeqQtmCZdPRrf2xjrxi8rVU2dh
 bM1oLRoTqPXjarXCmgdUAtB8DL0QL0mZNsm0qVnwdtiIf/Lwgs7lyFe6NPrhe27XL4pM
 E5WQ==
X-Gm-Message-State: AOAM533EzR0TcO2lyYFRXBo3I9fb++Qrc29G5XaGyFE1GAS81QLQnu3N
 5rOnfGYu9jJCyalKwWm7edSRqTD0tsgM8WA9ljNniRC3QuKz/eDzL3ojiXBIwaNgAzLW1Nqh5qk
 nHCe+xEv3u7M6X8Q2Mgxu5d66J2H8QMQNi37t5vEgKmXjbMmm3Punsn0fcmoMPg1lnyk=
X-Google-Smtp-Source: ABdhPJxhIl2GDHdXdY+j+1yX7XXlnMRyoArPiWnJ3Wu4rUcVSpHT51MLikxuqb9gd5v+xhTwR4aNmcQfAw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a1c:35c7:0:b0:38e:4c59:6788 with
 SMTP id
 c190-20020a1c35c7000000b0038e4c596788mr941361wma.1.1652090104665; Mon, 09 May
 2022 02:55:04 -0700 (PDT)
Date: Mon,  9 May 2022 09:54:57 +0000
In-Reply-To: <20220509095500.2408785-1-tabba@google.com>
Message-Id: <20220509095500.2408785-2-tabba@google.com>
Mime-Version: 1.0
References: <20220509095500.2408785-1-tabba@google.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v2 1/4] KVM: arm64: Wrapper for getting pmu_events
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
