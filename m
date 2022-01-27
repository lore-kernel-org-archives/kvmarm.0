Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C03DEC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 03:09:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6409E49EEE;
	Wed, 26 Jan 2022 22:09:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id v2JmBFXvQhlB; Wed, 26 Jan 2022 22:09:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1388F49E5F;
	Wed, 26 Jan 2022 22:09:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5086B49EEF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 22:09:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vjlGSok62uIZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 22:09:07 -0500 (EST)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F3DBC49ED9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 22:09:06 -0500 (EST)
Received: by mail-pl1-f202.google.com with SMTP id
 v14-20020a170902e8ce00b0014b48e8e498so821665plg.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 19:09:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=lqWGfh2BJMERTwHvF+7RFLuQxcilmmI6PUG6asomKXE=;
 b=U/7s/RD/eWobrbk6Ldg3LkBFZ1PgmOUJlVBFTuh99tKfbEgEQWP4jPoq38c0nptkxy
 7t3su/tNuMcY5Ot+znpjZd4STvjf9VIezzUO40l2zRyqnyagTjuHvItXTkUPgxcIazGp
 xswQhIsvCV0mfnifIKbouhGkN0Xs8TfHfCi3OVkvw2HwaSjDkcV4GhLTH1YWsaLnkkKq
 xGmYWxZS/YfymhudibefhxEqrAertW+N5r68/tsC9VBmOqPEgjPyXe5ayTBTlnlowM7X
 xt8sOOFma55MRiH85uByCVjk6fqnNf/PWzqS0t8yHV5LLtgwMU31t47Wa+m5j64VTDM9
 SdMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=lqWGfh2BJMERTwHvF+7RFLuQxcilmmI6PUG6asomKXE=;
 b=AjvIWYV4Hax1kgHXloX52HNDgwNyP+b1rj/j2cNo1LNev082n0mjjWCuRkmQ1h6d8N
 uhi4JXm9Ha26cbyPUQWwBnoWNe0W78sMPvSal196M9SHg1kNNpLC16ta9nWS7pgPtXoq
 TRQ1CnIGW5vD7zO3pfKHVfYP3Qib1Ol0WrnhiBm+G30ibvTv9rlle6QoY84zjOxTUDs3
 18BZ3xTq7O0Zaxge8lNMiyLHpFnmw9zrhjRcREhXRLzQQtzs2WYb4oE8dvi8H0DAHE1S
 8y36C+e5KPhinakNXr/CiZPFkaZAFr70Fu8ALUT0VTYXJ4ULc6UV5P7vcMtZC3Rn7GZr
 qToA==
X-Gm-Message-State: AOAM532KKbFihv6UiptCTMhGGks/xt6kamzYIKluy/7705y9Nm/VxJ5U
 qnFbDuSj+ZIniawcflLaWduv9keN/0xjZw==
X-Google-Smtp-Source: ABdhPJx5gWsEp7INU7scxngnVF9QetFYhYL4j1t6IkPIGmvXy8Dl4Zych8ub9e0y2Xeaod39U96Ah8zx+33LvA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:903:1250:: with SMTP id
 u16mr1663963plh.126.1643252946183; Wed, 26 Jan 2022 19:09:06 -0800 (PST)
Date: Wed, 26 Jan 2022 19:08:55 -0800
In-Reply-To: <20220127030858.3269036-1-ricarkol@google.com>
Message-Id: <20220127030858.3269036-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220127030858.3269036-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 2/5] kvm: selftests: aarch64: pass vgic_irq guest args as a
 pointer
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc: maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>
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

The guest in vgic_irq gets its arguments in a struct. This struct used
to fit nicely in a single register so vcpu_args_set() was able to pass
it by value by setting x0 with it. Unfortunately, this args struct grew
after some commits and some guest args became random (specically
kvm_supports_irqfd).

Fix this by passing the guest args as a pointer (after allocating some
guest memory for it).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reported-by: Reiji Watanabe <reijiw@google.com>
Cc: Andrew Jones <drjones@redhat.com>
---
 .../testing/selftests/kvm/aarch64/vgic_irq.c  | 29 ++++++++++---------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index e6c7d7f8fbd1..b701eb80128d 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -472,10 +472,10 @@ static void test_restore_active(struct test_args *args, struct kvm_inject_desc *
 		guest_restore_active(args, MIN_SPI, 4, f->cmd);
 }
 
-static void guest_code(struct test_args args)
+static void guest_code(struct test_args *args)
 {
-	uint32_t i, nr_irqs = args.nr_irqs;
-	bool level_sensitive = args.level_sensitive;
+	uint32_t i, nr_irqs = args->nr_irqs;
+	bool level_sensitive = args->level_sensitive;
 	struct kvm_inject_desc *f, *inject_fns;
 
 	gic_init(GIC_V3, 1, dist, redist);
@@ -484,11 +484,11 @@ static void guest_code(struct test_args args)
 		gic_irq_enable(i);
 
 	for (i = MIN_SPI; i < nr_irqs; i++)
-		gic_irq_set_config(i, !args.level_sensitive);
+		gic_irq_set_config(i, !level_sensitive);
 
-	gic_set_eoi_split(args.eoi_split);
+	gic_set_eoi_split(args->eoi_split);
 
-	reset_priorities(&args);
+	reset_priorities(args);
 	gic_set_priority_mask(CPU_PRIO_MASK);
 
 	inject_fns  = level_sensitive ? inject_level_fns
@@ -497,17 +497,17 @@ static void guest_code(struct test_args args)
 	local_irq_enable();
 
 	/* Start the tests. */
-	for_each_supported_inject_fn(&args, inject_fns, f) {
-		test_injection(&args, f);
-		test_preemption(&args, f);
-		test_injection_failure(&args, f);
+	for_each_supported_inject_fn(args, inject_fns, f) {
+		test_injection(args, f);
+		test_preemption(args, f);
+		test_injection_failure(args, f);
 	}
 
 	/* Restore the active state of IRQs. This would happen when live
 	 * migrating IRQs in the middle of being handled.
 	 */
-	for_each_supported_activate_fn(&args, set_active_fns, f)
-		test_restore_active(&args, f);
+	for_each_supported_activate_fn(args, set_active_fns, f)
+		test_restore_active(args, f);
 
 	GUEST_DONE();
 }
@@ -739,6 +739,7 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
 	int gic_fd;
 	struct kvm_vm *vm;
 	struct kvm_inject_args inject_args;
+	vm_vaddr_t args_gva;
 
 	struct test_args args = {
 		.nr_irqs = nr_irqs,
@@ -757,7 +758,9 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
 	vcpu_init_descriptor_tables(vm, VCPU_ID);
 
 	/* Setup the guest args page (so it gets the args). */
-	vcpu_args_set(vm, 0, 1, args);
+	args_gva = vm_vaddr_alloc_page(vm);
+	memcpy(addr_gva2hva(vm, args_gva), &args, sizeof(args));
+	vcpu_args_set(vm, 0, 1, args_gva);
 
 	gic_fd = vgic_v3_setup(vm, 1, nr_irqs,
 			GICD_BASE_GPA, GICR_BASE_GPA);
-- 
2.35.0.rc0.227.g00780c9af4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
