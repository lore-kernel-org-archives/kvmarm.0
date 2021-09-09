Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BBF0C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 01:38:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C919061166
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 01:38:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C919061166
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BA684A500;
	Wed,  8 Sep 2021 21:38:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aull00a51Lem; Wed,  8 Sep 2021 21:38:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A7F94B0D9;
	Wed,  8 Sep 2021 21:38:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74B624A49C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 21:38:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9v2bOD9o4xg4 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Sep 2021 21:38:48 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 87E974A5A0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 21:38:47 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 u13-20020a17090a4bcd00b00198e965f8f4so296359pjl.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 18:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=CjBV1NcFy7p27eV1/jQ5yVLZ7UVN92HtWY4NlfI6+Nk=;
 b=qs44jTJxzDkHSQpQ3NQhsxvConzusDrdn8GVAQZkcQJ5b+Gf5cFcq+1LrnKjJ3qm4U
 IuVGUIv+Jm5UBRAL0UWp2YKCJiJWATPdxBLM7NOxgHM87/Ubckxo1gtt4k9jA/7RGXBM
 Qou8fUA1VNeeZou9MCS5yT/PR9gx7Il1wk+bXjTtgmUyNXl/4E7N57Q+12qLz3f3ZE2y
 ecBKEYRHqKGHv80Qqr+cRsYSsEpyK8YERJW3DxnoO0EtISch3Bvh9NCq5sZSd3XWfv4Y
 ABcqFuy0WPFgkDqTcVpYf5C4WGuZvOQ+4Vej5j0NsDyBBV5zXMiKM0YkCvBFObLVGX13
 FLDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=CjBV1NcFy7p27eV1/jQ5yVLZ7UVN92HtWY4NlfI6+Nk=;
 b=XaQjc01DBS82KbhoMA3vSGwdoB6rALjDIZeUulAr42nmB3FSlzOxXxR48+pkAyXbRL
 +UIlCHMNBYHRxihp5zQ3Br35qT+vkyXE5APrqumVyHqlea7gOTwmKGcedkWevrj7wrJQ
 kJkNY+YSlAFwfpA2n5m/vNYGm5kdQL+LmYogcLGs8AKvGeqBZNm60bkqdujU855lu+NZ
 OMSgV0I/oG43Xzd55Dv+hmxY0KXICXqyC3iPq4i+5uaknxy7sH8KYHzkBwBls5jVLf1M
 80498qN9U+MGYOPsGnCy2dAoptQ+S0SNl/RvObgIc8P1r3fop6jIcQQ1/Owdbq4aXpCj
 wJWg==
X-Gm-Message-State: AOAM531xSCIiUWJI+iCiI10fGs9YgcwjgKPf/GFPtGvFJLKD+Wu6KhFO
 A8gP9RXWgiGEnRCAgHPf+hXadAd28mL8
X-Google-Smtp-Source: ABdhPJyuqoo++7vtCPsZXEiAOGwdyb60M1j/VQFztVww0kA042US1QoYXW+DsIcfE2quLAQ598C/fZFY3ypv
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a62:cdcd:0:b0:405:27a5:fbbb with SMTP id
 o196-20020a62cdcd000000b0040527a5fbbbmr605460pfg.7.1631151526738; Wed, 08 Sep
 2021 18:38:46 -0700 (PDT)
Date: Thu,  9 Sep 2021 01:38:09 +0000
In-Reply-To: <20210909013818.1191270-1-rananta@google.com>
Message-Id: <20210909013818.1191270-10-rananta@google.com>
Mime-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v4 09/18] KVM: arm64: selftests: Add guest support to get the
 vcpuid
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Andrew Jones <drjones@redhat.com>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

At times, such as when in the interrupt handler, the guest wants
to get the vcpuid that it's running on. As a result, introduce
get_vcpuid() that returns the vcpuid of the calling vcpu. At its
backend, the VMM prepares a map of vcpuid and mpidr during VM
initialization and exports the map to the guest for it to read.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h |  3 ++
 .../selftests/kvm/lib/aarch64/processor.c     | 46 +++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index b6088c3c67a3..150f63101f4c 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -133,6 +133,7 @@ void vm_install_exception_handler(struct kvm_vm *vm,
 		int vector, handler_fn handler);
 void vm_install_sync_handler(struct kvm_vm *vm,
 		int vector, int ec, handler_fn handler);
+void vm_vcpuid_map_init(struct kvm_vm *vm);
 
 static inline void cpu_relax(void)
 {
@@ -194,4 +195,6 @@ static inline void local_irq_disable(void)
 	asm volatile("msr daifset, #3" : : : "memory");
 }
 
+int get_vcpuid(void);
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 632b74d6b3ca..9844b62227b1 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -13,9 +13,17 @@
 #include "processor.h"
 
 #define DEFAULT_ARM64_GUEST_STACK_VADDR_MIN	0xac0000
+#define VM_VCPUID_MAP_INVAL			-1
 
 static vm_vaddr_t exception_handlers;
 
+struct vm_vcpuid_map {
+	uint64_t mpidr;
+	int vcpuid;
+};
+
+static struct vm_vcpuid_map vcpuid_map[KVM_MAX_VCPUS];
+
 static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
 {
 	return (v + vm->page_size) & ~(vm->page_size - 1);
@@ -426,3 +434,41 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 	assert(vector < VECTOR_NUM);
 	handlers->exception_handlers[vector][0] = handler;
 }
+
+void vm_vcpuid_map_init(struct kvm_vm *vm)
+{
+	int i = 0;
+	struct vcpu *vcpu;
+	struct vm_vcpuid_map *map;
+
+	list_for_each_entry(vcpu, &vm->vcpus, list) {
+		map = &vcpuid_map[i++];
+		map->vcpuid = vcpu->id;
+		get_reg(vm, vcpu->id,
+			ARM64_SYS_KVM_REG(SYS_MPIDR_EL1), &map->mpidr);
+		map->mpidr &= MPIDR_HWID_BITMASK;
+	}
+
+	if (i < KVM_MAX_VCPUS)
+		vcpuid_map[i].vcpuid = VM_VCPUID_MAP_INVAL;
+
+	sync_global_to_guest(vm, vcpuid_map);
+}
+
+int get_vcpuid(void)
+{
+	int i, vcpuid;
+	uint64_t mpidr = read_sysreg(mpidr_el1) & MPIDR_HWID_BITMASK;
+
+	for (i = 0; i < KVM_MAX_VCPUS; i++) {
+		vcpuid = vcpuid_map[i].vcpuid;
+		GUEST_ASSERT_1(vcpuid != VM_VCPUID_MAP_INVAL, mpidr);
+
+		if (mpidr == vcpuid_map[i].mpidr)
+			return vcpuid;
+	}
+
+	/* We should not be reaching here */
+	GUEST_ASSERT_1(0, mpidr);
+	return -1;
+}
-- 
2.33.0.153.gba50c8fa24-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
