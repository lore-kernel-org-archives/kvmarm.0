Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81373C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 20EF0619A6
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 20EF0619A6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFD684B173;
	Mon,  8 Nov 2021 21:39:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bLebKdC27yKb; Mon,  8 Nov 2021 21:39:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF2D24B178;
	Mon,  8 Nov 2021 21:39:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32BB44A3A5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rujf407+hyEx for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Nov 2021 21:39:42 -0500 (EST)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3578C4B203
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:41 -0500 (EST)
Received: by mail-pf1-f201.google.com with SMTP id
 x20-20020aa79414000000b0049f9cb19a5fso7130961pfo.17
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Nov 2021 18:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=PPiN1OStZtyVFCjdaIWEwxJI+HtnmXRJCjCg0WeY/1o=;
 b=OxMHCCrLIoOcCMO/e5i3qk9CbDTPcyfH/A0Qr9+1rMkft67CvoCbmVGS73fctt+EO5
 NqvDBRhCHVAGsjWn5IBooSf2P8XSrqLQAPuBh5nWiACSD7eGaw/fA0Upe6wDptH9zDy9
 eDTRtvDOCzWsKdo7N+KbAyOBihzFY12OSkL2pZOHYky9xGaNC4svekA/tbK6Sf0iuSym
 qVuX3POy/yYEBSX6BsVnctG2MlD2vtKB08buXcUsSmQgvJ/RD/ecv7rqlgUOwwjf7h9D
 UyCo9QxmWzIDZ5/7rsn8Rjzfge40e6w4oGUqEHUXD9hIE8sOYbAWzDCnipaiI6sgAO53
 b5zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=PPiN1OStZtyVFCjdaIWEwxJI+HtnmXRJCjCg0WeY/1o=;
 b=fH2jBgkzo0iSwbO1yjKW75/gN6pfpY/2CNugvTjIUJXJmBSu9rha60s2yOfe6jh+Jv
 8tUcWe1w8Z5UqM/k6b2gUfvQFXayRboVsupBBToOzr46HBeN+z5vKmzr/7qmrVFt51ds
 e8piV5HLg9sMKRJkDanN/8smA5ujs0Eo/iGEk6AQSRS42YnF8pN2PFHcIQONtg2GiCOx
 ApUdXjN9AsllXsepxZ8A3lmWCyB8So76ycyTgHAt26K3lYNHZH2KslU7yFnnnKkm2VSH
 ym7b/9Ef3j86DyRHrPPNVkFafhmyNko5TZCTGi5uVYj3B9m2rtGSUQHutKzcV7V9snfo
 AqPg==
X-Gm-Message-State: AOAM530Ho6DFWVeeXpPQnrwP04PZtloZDC1bg26fa9S+YOSUTTh7STD5
 kVVqLUQI7tbsWkffZmGYHwmmq3gXx0eYpw==
X-Google-Smtp-Source: ABdhPJxU+zWdcLp8dVxfcgRk+DuxHI2NjXI/Ir2OWJNuLQgheWLYUiaRCPVy7IyeFg4h4yIqHdXiJWMiaj63TQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:ced0:b0:142:189a:4284 with SMTP
 id d16-20020a170902ced000b00142189a4284mr3987840plg.79.1636425580412; Mon, 08
 Nov 2021 18:39:40 -0800 (PST)
Date: Mon,  8 Nov 2021 18:39:06 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-18-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 17/17] KVM: selftests: aarch64: add test for restoring active
 IRQs
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu, 
 drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc: pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org
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

Add a test that restores multiple IRQs in active state, it does it by
writing into ISACTIVER from the guest and using KVM ioctls. This test
tries to emulate what would happen during a live migration: restore
active IRQs.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_irq.c  | 91 +++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index ab39f0bf18e7..e6c7d7f8fbd1 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -66,6 +66,7 @@ typedef enum {
 	KVM_SET_LEVEL_INFO_HIGH,
 	KVM_INJECT_IRQFD,
 	KVM_WRITE_ISPENDR,
+	KVM_WRITE_ISACTIVER,
 } kvm_inject_cmd;
 
 struct kvm_inject_args {
@@ -96,6 +97,9 @@ static void kvm_inject_get_call(struct kvm_vm *vm, struct ucall *uc,
 #define KVM_INJECT(cmd, intid)							\
 	_KVM_INJECT_MULTI(cmd, intid, 1, false)
 
+#define KVM_ACTIVATE(cmd, intid)						\
+	kvm_inject_call(cmd, intid, 1, 1, false);
+
 struct kvm_inject_desc {
 	kvm_inject_cmd cmd;
 	/* can inject PPIs, PPIs, and/or SPIs. */
@@ -119,6 +123,12 @@ static struct kvm_inject_desc inject_level_fns[] = {
 	{ 0, },
 };
 
+static struct kvm_inject_desc set_active_fns[] = {
+	/*                                      sgi    ppi    spi */
+	{ KVM_WRITE_ISACTIVER,			true,  true,  true },
+	{ 0, },
+};
+
 #define for_each_inject_fn(t, f)						\
 	for ((f) = (t); (f)->cmd; (f)++)
 
@@ -126,6 +136,9 @@ static struct kvm_inject_desc inject_level_fns[] = {
 	for_each_inject_fn(t, f)						\
 		if ((args)->kvm_supports_irqfd || (f)->cmd != KVM_INJECT_IRQFD)
 
+#define for_each_supported_activate_fn(args, t, f)				\
+	for_each_supported_inject_fn((args), (t), (f))
+
 /* Shared between the guest main thread and the IRQ handlers. */
 volatile uint64_t irq_handled;
 volatile uint32_t irqnr_received[MAX_SPI + 1];
@@ -147,6 +160,12 @@ static uint64_t gic_read_ap1r0(void)
 	return reg;
 }
 
+static void gic_write_ap1r0(uint64_t val)
+{
+	write_sysreg_s(val, SYS_ICV_AP1R0_EL1);
+	isb();
+}
+
 static void guest_set_irq_line(uint32_t intid, uint32_t level);
 
 static void guest_irq_generic_handler(bool eoi_split, bool level_sensitive)
@@ -274,6 +293,55 @@ static void guest_inject(struct test_args *args,
 	reset_priorities(args);
 }
 
+/*
+ * Restore the active state of multiple concurrent IRQs (given by
+ * concurrent_irqs).  This does what a live-migration would do on the
+ * destination side assuming there are some active IRQs that were not
+ * deactivated yet.
+ */
+static void guest_restore_active(struct test_args *args,
+		uint32_t first_intid, uint32_t num,
+		kvm_inject_cmd cmd)
+{
+	uint32_t prio, intid, ap1r;
+	int i;
+
+	/* Set the priorities of the first (KVM_NUM_PRIOS - 1) IRQs
+	 * in descending order, so intid+1 can preempt intid.
+	 */
+	for (i = 0, prio = (num - 1) * 8; i < num; i++, prio -= 8) {
+		GUEST_ASSERT(prio >= 0);
+		intid = i + first_intid;
+		gic_set_priority(intid, prio);
+	}
+
+	/* In a real migration, KVM would restore all GIC state before running
+	 * guest code.
+	 */
+	for (i = 0; i < num; i++) {
+		intid = i + first_intid;
+		KVM_ACTIVATE(cmd, intid);
+		ap1r = gic_read_ap1r0();
+		ap1r |= 1U << i;
+		gic_write_ap1r0(ap1r);
+	}
+
+	/* This is where the "migration" would occur. */
+
+	/* finish handling the IRQs starting with the highest priority one. */
+	for (i = 0; i < num; i++) {
+		intid = num - i - 1 + first_intid;
+		gic_set_eoi(intid);
+		if (args->eoi_split)
+			gic_set_dir(intid);
+	}
+
+	for (i = 0; i < num; i++)
+		GUEST_ASSERT(!gic_irq_get_active(i + first_intid));
+	GUEST_ASSERT_EQ(gic_read_ap1r0(), 0);
+	GUEST_ASSERT_IAR_EMPTY();
+}
+
 /*
  * Polls the IAR until it's not a spurious interrupt.
  *
@@ -391,6 +459,19 @@ static void test_preemption(struct test_args *args, struct kvm_inject_desc *f)
 		test_inject_preemption(args, MIN_SPI, 4, f->cmd);
 }
 
+static void test_restore_active(struct test_args *args, struct kvm_inject_desc *f)
+{
+	/* Test up to 4 active IRQs. Same reason as in test_preemption. */
+	if (f->sgi)
+		guest_restore_active(args, MIN_SGI, 4, f->cmd);
+
+	if (f->ppi)
+		guest_restore_active(args, MIN_PPI, 4, f->cmd);
+
+	if (f->spi)
+		guest_restore_active(args, MIN_SPI, 4, f->cmd);
+}
+
 static void guest_code(struct test_args args)
 {
 	uint32_t i, nr_irqs = args.nr_irqs;
@@ -422,6 +503,12 @@ static void guest_code(struct test_args args)
 		test_injection_failure(&args, f);
 	}
 
+	/* Restore the active state of IRQs. This would happen when live
+	 * migrating IRQs in the middle of being handled.
+	 */
+	for_each_supported_activate_fn(&args, set_active_fns, f)
+		test_restore_active(&args, f);
+
 	GUEST_DONE();
 }
 
@@ -619,6 +706,10 @@ static void run_guest_cmd(struct kvm_vm *vm, int gic_fd,
 			kvm_irq_write_ispendr_check(gic_fd, i,
 					VCPU_ID, expect_failure);
 		break;
+	case KVM_WRITE_ISACTIVER:
+		for (i = intid; i < intid + num; i++)
+			kvm_irq_write_isactiver(gic_fd, i, VCPU_ID);
+		break;
 	default:
 		break;
 	}
-- 
2.34.0.rc0.344.g81b53c2807-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
