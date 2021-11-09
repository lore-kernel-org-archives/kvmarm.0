Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E901FC433FE
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9D824619E4
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9D824619E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F9A84B1FB;
	Mon,  8 Nov 2021 21:39:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cjnBleXS-J0d; Mon,  8 Nov 2021 21:39:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D0814B20D;
	Mon,  8 Nov 2021 21:39:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F48B4B1E0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZeAzBWysn+zz for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Nov 2021 21:39:24 -0500 (EST)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B79724B1BA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:24 -0500 (EST)
Received: by mail-pg1-f202.google.com with SMTP id
 n22-20020a6563d6000000b0029261ffde9bso11238974pgv.22
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Nov 2021 18:39:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ncjLEDYXfGn2mZ4JYj7zy7HLzUBwrfGKWWDFG4IBv6o=;
 b=Bl8Pm0ozKWM/LDLCA6K2BTKtoz58AP9+G+MiKh3oXnapRhrLqyXijXPDxepDOoJjho
 gwMqsbUylDu4bN1rhqZqClU65UZBpuqXGtMhHeuqy0oEeNQIlAQ7i4Bgo+2/ntB3CqXz
 oHc3ByRBe274NlJR4dyWfNt1jlm0F6efB0XjITVhWdiYm346FIHCozlgDoimpVUrsl/c
 4Ds0Wdc037JHHxU+uPQhzgdnd7c8e/+i+WJFu7NGXwsJ/LJ6qgRFifnbNnHPGZSieJyF
 P39musL3Jv+1mx2at5ycPfjgCGq6NYnKw1zTFnUDtVO74aD1m6LPfNqoq+PfUxVar/vu
 Nd7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ncjLEDYXfGn2mZ4JYj7zy7HLzUBwrfGKWWDFG4IBv6o=;
 b=C13tYlHRtZTHmhpKm0xA+z3qDmc2JtHHl6W9kG918egw1MKIlaZGzhLU0e/IdS46Sg
 o6FyM55eRBhxnv+0LFhk8LyIsFEdxZ2IyMD8y1S+DdzcgCan4HjArNCb0Rx1aVKyAq2g
 hnCV/Go6RFCzREx+DmG+e7Uob16sav+YtYTslp0loMCq9zDzPNN9Kqi5OHD/B78DAZPb
 oOt9eIRrNnYzYzkpiY4haZJxJ/x720Crm1YYupMQP5al0BqvUC75vCUfsHqjtzMmqORK
 4hPoAXnWcKNpHDq+ZAGVh/uDFmi7ega5d4hQnq1MnP+5GgCFuE5y4kJVKB24+iO13EQ1
 GGsQ==
X-Gm-Message-State: AOAM531nHzjO/XY8mHhK38mynyU/kXRhmAs/ZjcxiL2wsl/sVZAw43sJ
 j8HSIjVH3oVHJXNRdp9r4oXCE90CC/5Jag==
X-Google-Smtp-Source: ABdhPJx2kMz7ovig+XiKxpSShdq7aHjbFgtxozevvbz4f2HNg2/3JEyOFbLVPit84lmx/ErpG4ZdqScxc4iHTQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a62:ea16:0:b0:47b:f3d7:7a9 with SMTP id
 t22-20020a62ea16000000b0047bf3d707a9mr4400254pfh.60.1636425564008; Mon, 08
 Nov 2021 18:39:24 -0800 (PST)
Date: Mon,  8 Nov 2021 18:38:56 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-8-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 07/17] KVM: selftests: aarch64: abstract the injection
 functions in vgic_irq
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

Build an abstraction around the injection functions, so the preparation
and checking around the actual injection can be shared between tests.
All functions are stored as pointers in arrays of kvm_inject_desc's
which include the pointer and what kind of interrupts they can inject.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_irq.c  | 39 +++++++++++++++++--
 1 file changed, 36 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index e13e87427038..f5d76fef22f0 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -57,10 +57,28 @@ struct kvm_inject_args {
 /* Used on the guest side to perform the hypercall. */
 static void kvm_inject_call(kvm_inject_cmd cmd, uint32_t intid);
 
+#define KVM_INJECT(cmd, intid)							\
+	kvm_inject_call(cmd, intid)
+
 /* Used on the host side to get the hypercall info. */
 static void kvm_inject_get_call(struct kvm_vm *vm, struct ucall *uc,
 		struct kvm_inject_args *args);
 
+struct kvm_inject_desc {
+	kvm_inject_cmd cmd;
+	/* can inject PPIs, PPIs, and/or SPIs. */
+	bool sgi, ppi, spi;
+};
+
+static struct kvm_inject_desc inject_edge_fns[] = {
+	/*                                      sgi    ppi    spi */
+	{ KVM_INJECT_EDGE_IRQ_LINE,		false, false, true },
+	{ 0, },
+};
+
+#define for_each_inject_fn(t, f)						\
+	for ((f) = (t); (f)->cmd; (f)++)
+
 /* Shared between the guest main thread and the IRQ handlers. */
 volatile uint64_t irq_handled;
 volatile uint32_t irqnr_received[MAX_SPI + 1];
@@ -120,12 +138,12 @@ do { 										\
 	GUEST_ASSERT(_intid == 0 || _intid == IAR_SPURIOUS);			\
 } while (0)
 
-static void test_kvm_irq_line(uint32_t intid)
+static void guest_inject(uint32_t intid, kvm_inject_cmd cmd)
 {
 	reset_stats();
 
 	asm volatile("msr daifset, #2" : : : "memory");
-	kvm_inject_call(KVM_INJECT_EDGE_IRQ_LINE, intid);
+	KVM_INJECT(cmd, intid);
 
 	while (irq_handled < 1) {
 		asm volatile("wfi\n"
@@ -141,10 +159,23 @@ static void test_kvm_irq_line(uint32_t intid)
 	GUEST_ASSERT_IAR_EMPTY();
 }
 
+static void test_injection(struct kvm_inject_desc *f)
+{
+	if (f->sgi)
+		guest_inject(MIN_SGI, f->cmd);
+
+	if (f->ppi)
+		guest_inject(MIN_PPI, f->cmd);
+
+	if (f->spi)
+		guest_inject(MIN_SPI, f->cmd);
+}
+
 static void guest_code(void)
 {
 	uint32_t i;
 	uint32_t nr_irqs = 64; /* absolute minimum number of IRQs supported. */
+	struct kvm_inject_desc *f;
 
 	gic_init(GIC_V3, 1, dist, redist);
 
@@ -157,7 +188,9 @@ static void guest_code(void)
 
 	local_irq_enable();
 
-	test_kvm_irq_line(MIN_SPI);
+	/* Start the tests. */
+	for_each_inject_fn(inject_edge_fns, f)
+		test_injection(f);
 
 	GUEST_DONE();
 }
-- 
2.34.0.rc0.344.g81b53c2807-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
