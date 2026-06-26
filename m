Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108523C3797
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 21:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782509748; cv=none; b=F7YWaNyy61cLxuD3MEwxeEGuB7L6NTE1+UGWjetJN7FxN+2AKqDkSQyyYPSN3Y/WZtSkSOfpHrD4zwdl79BOmQ8hn6WHN6H9fnUtyBqa3RpKHfgrdTBSkt1NDG2bsIw0C21J9DBMFmIm8+d6F1Z4Q7qRggYVSdQdotvCKzd62ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782509748; c=relaxed/simple;
	bh=yEo+LT2ltYPr4052P4Sig18/nnI5tphcxF7DG8DxEsE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pna/jAgK9rvy5EVW8zAfKom3R9ifc75jfRNSnnYSP44Xquh4St4F11/S0BSqbU2eEMSvCakod1TlaNSnhv8WfgeTopfsjL2u6YIhAIG2BrlcO3dURQUS2sj0X7pBQX4gczyGfTrpfpD3/mYMDEyFYJe+cdYuFn0UvBGG4WvmrqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i+wsin3k; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i+wsin3k"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-36d97a4e08fso1085587a91.0
        for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 14:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782509745; x=1783114545; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ZSZM6YQ5KHnml7cuEP2t6/hmi1sPUG+74rGvCiTMMxg=;
        b=i+wsin3kOjokgBvLalVoP/eNEctrZo0QenhekPun0KlY0GvuGBT3K7BWHRtOOzOyiZ
         kvpC8tDBD8HYyk/IJfwndys3isUdcu9s9KozdCxMSLnwZdUweUIcjKeuFct5UfLrKQLP
         mbduH33RUrKWDGsvUNGvnz7a+cujAvllJRvvLawW4O4GGmxCGWQKzM6rztUL37xyUqQk
         YFW1o5GC+rj5uqRpA7Xmh4WDIHI0XUJsPW+nHUIKiiQ57NG1IAtndgcv8Gr921tUP8An
         mbdee5Nv8grZYfZRrL6P3ddTbO93YZTBYy5VjQD2ZF1rBsKwqR+DhSjtRiOhftrjNyTT
         89Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782509745; x=1783114545;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZSZM6YQ5KHnml7cuEP2t6/hmi1sPUG+74rGvCiTMMxg=;
        b=IsTfmPTW+NHRslbW7LZaSQpSMTjv8PaRFPpekPyjW9mElkr8UV3t8I632BWgkjxy/d
         rHLbjdvr5r6mD/f9bhSCQMBQxEkhSZkgT/jfCY73JhtRTlIUHlbNmB2lwYn1pdIVHP/q
         X+Vur7WaGvVM5ZORrdSEhjX+fPGhKRtYI3iymC/FflO9pG0MoJLYV2viUldHPHMhHmcJ
         FhUbL9kPlOb2c2+V43Cvx39tW7XLLpSAy9gDv02KM3H0YqOo6At+yxh0Re5yLsgxqAI9
         UdAboY2C8KN5tAokEkY7KMU/i+slw8x96dBv3aGofuhQubb+4Hs3kVok8/ph5Bhn3AqE
         Ngqw==
X-Forwarded-Encrypted: i=1; AHgh+RrXpkDUgpi1kBjAjNyHs016uWM9zihPgOwQtT30Rr3KBSMQUVmR8ydY0DZR6e7ELv2ysSKVyfk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzjs3SR/k9JPHOzBxqgVFsE3orOAoG0Gh+Pu8LWIEPVj3krmaB4
	wqnAbeTNwFzteCS9tkYeH445Rod66UyMNA2g/7pTfdifWMT4H51UO5wqiakp6Yfy/XTMaad9fda
	R1aakww==
X-Received: from pjub20.prod.google.com ([2002:a17:90a:cc14:b0:37d:f152:3b63])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:270b:b0:37c:6973:5a65
 with SMTP id 98e67ed59e1d1-37dfa1ead47mr7035730a91.17.1782509745112; Fri, 26
 Jun 2026 14:35:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jun 2026 14:35:20 -0700
In-Reply-To: <20260626213534.3866178-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260626213534.3866178-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260626213534.3866178-8-seanjc@google.com>
Subject: [PATCH v8 07/20] KVM: selftests: Add an irqfd send+receive (and later
 IRQ bypass) test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>, 
	Josh Hilke <jrhilke@google.com>
Content-Type: text/plain; charset="UTF-8"

From: David Matlack <dmatlack@google.com>

Add a new test, irq_test to verify that KVM correctly delivers interrupts
to a running vCPU, when triggered via an eventfd bound to a KVM GSI using
KVM's irqfd mechanism.

This test is intentionally simple, for now.  Support for sending interrupts
via VFIO devices, for IRQ bypass, and for other features will be added in
the near future.

Add the test in common code, even though it currently will only build and
run on x86, as the concept and the bulk of the host-side code isn't
specific to x86.

Suggested-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/kvm/20250404193923.1413163-68-seanjc@google.com
Signed-off-by: David Matlack <dmatlack@google.com>
Co-developed-by: Josh Hilke <jrhilke@google.com>
Signed-off-by: Josh Hilke <jrhilke@google.com>
[sean: use while() and TEST_ASSERT() instead of if-statement => TEST_FAIL()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm |   1 +
 tools/testing/selftests/kvm/irq_test.c   | 170 +++++++++++++++++++++++
 2 files changed, 171 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/irq_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index ae0dfd67dd31..a24875fada03 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -157,6 +157,7 @@ TEST_GEN_PROGS_x86 += coalesced_io_test
 TEST_GEN_PROGS_x86 += dirty_log_perf_test
 TEST_GEN_PROGS_x86 += guest_memfd_test
 TEST_GEN_PROGS_x86 += hardware_disable_test
+TEST_GEN_PROGS_x86 += irq_test
 TEST_GEN_PROGS_x86 += mmu_stress_test
 TEST_GEN_PROGS_x86 += rseq_test
 TEST_GEN_PROGS_x86 += steal_time
diff --git a/tools/testing/selftests/kvm/irq_test.c b/tools/testing/selftests/kvm/irq_test.c
new file mode 100644
index 000000000000..9f8895b89821
--- /dev/null
+++ b/tools/testing/selftests/kvm/irq_test.c
@@ -0,0 +1,170 @@
+// SPDX-License-Identifier: GPL-2.0
+#include "kvm_util.h"
+#include "test_util.h"
+#include "apic.h"
+#include "processor.h"
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <pthread.h>
+#include <sys/eventfd.h>
+
+static u64 timeout_ns = 2ULL * 1000 * 1000 * 1000;
+static bool guest_ready_for_irqs[KVM_MAX_VCPUS];
+static bool guest_received_irq[KVM_MAX_VCPUS];
+static bool done;
+
+#define GUEST_RECEIVED_IRQ(__vcpu)	\
+	SYNC_FROM_GUEST_AND_READ((__vcpu)->vm, guest_received_irq[(__vcpu)->id])
+
+static u32 guest_get_vcpu_id(void)
+{
+	return x2apic_read_reg(APIC_ID);
+}
+
+static void guest_irq_handler(struct ex_regs *regs)
+{
+	WRITE_ONCE(guest_received_irq[guest_get_vcpu_id()], true);
+
+	x2apic_write_reg(APIC_EOI, 0);
+}
+
+static void guest_code(void)
+{
+	x2apic_enable();
+
+	sti_nop();
+
+	WRITE_ONCE(guest_ready_for_irqs[guest_get_vcpu_id()], true);
+
+	while (!READ_ONCE(done))
+		cpu_relax();
+
+	GUEST_DONE();
+}
+
+static void *vcpu_thread_main(void *arg)
+{
+	struct kvm_vcpu *vcpu = arg;
+	struct ucall uc;
+
+	vcpu_run(vcpu);
+	TEST_ASSERT_EQ(UCALL_DONE, get_ucall(vcpu, &uc));
+
+	return NULL;
+}
+
+static void kvm_route_msi(struct kvm_vm *vm, u32 gsi, struct kvm_vcpu *vcpu,
+			  u8 vector)
+{
+	struct {
+		struct kvm_irq_routing header;
+		struct kvm_irq_routing_entry entry;
+	} routing = {
+		.header.nr = 1,
+		.entry = {
+			.gsi = gsi,
+			.type = KVM_IRQ_ROUTING_MSI,
+			.u.msi.address_lo = 0xFEE00000 | (vcpu->id << 12),
+			.u.msi.data = vector,
+		},
+	};
+
+	vm_ioctl(vm, KVM_SET_GSI_ROUTING, &routing.header);
+}
+
+static void help(const char *name)
+{
+	printf("Usage: %s [-h]\n", name);
+	printf("\n");
+	printf("Tests KVM interrupt routing and delivery via irqfd.\n");
+	printf("\n");
+	exit(KSFT_FAIL);
+}
+
+int main(int argc, char **argv)
+{
+	/*
+	 * Pick a random vector and a random GSI to use for device IRQ.
+	 *
+	 * Pick an IRQ vector in range [32, UINT8_MAX]. Min value is 32 because
+	 * Linux/x86 reserves vectors 0-31 for exceptions and architecture
+	 * defined NMIs and interrupts.
+	 *
+	 * Pick a GSI in range [24, KVM_MAX_IRQ_ROUTES - 1]. The min value is 24
+	 * because KVM reserves GSIs 0-15 for legacy ISA IRQs and 16-23 only go
+	 * to the IOAPIC. The max is KVM_MAX_IRQ_ROUTES - 1, because
+	 * KVM_MAX_IRQ_ROUTES is exclusive.
+	 */
+	u32 gsi = kvm_random_u64_in_range(&kvm_rng, 24, KVM_MAX_IRQ_ROUTES - 1);
+	u8 vector = kvm_random_u64_in_range(&kvm_rng, 32, UINT8_MAX);
+
+	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
+	pthread_t vcpu_threads[KVM_MAX_VCPUS];
+	int nr_irqs = 1000, nr_vcpus = 1;
+	int i, j, c, eventfd;
+	struct kvm_vm *vm;
+
+	while ((c = getopt(argc, argv, "h")) != -1) {
+		switch (c) {
+		case 'h':
+		default:
+			help(argv[0]);
+		}
+	}
+
+	TEST_REQUIRE(kvm_arch_has_default_irqchip());
+
+	vm = vm_create_with_vcpus(nr_vcpus, guest_code, vcpus);
+	vm_install_exception_handler(vm, vector, guest_irq_handler);
+
+	eventfd = kvm_new_eventfd();
+
+	pr_info("Injecting interrupts for GSI %d (guest vector 0x%x) %d times\n",
+		gsi, vector, nr_irqs);
+
+	kvm_assign_irqfd(vm, gsi, eventfd);
+
+	for (i = 0; i < nr_vcpus; i++)
+		pthread_create(&vcpu_threads[i], NULL, vcpu_thread_main, vcpus[i]);
+
+	for (i = 0; i < nr_vcpus; i++) {
+		struct kvm_vcpu *vcpu = vcpus[i];
+
+		while (!SYNC_FROM_GUEST_AND_READ(vm, guest_ready_for_irqs[vcpu->id]))
+			continue;
+	}
+
+	for (i = 0; i < nr_irqs; i++) {
+		struct kvm_vcpu *vcpu = vcpus[i % nr_vcpus];
+		struct timespec start;
+
+		kvm_route_msi(vm, gsi, vcpu, vector);
+
+		for (j = 0; j < nr_vcpus; j++)
+			TEST_ASSERT(!GUEST_RECEIVED_IRQ(vcpus[j]),
+				    "IRQ flag for vCPU %d not clear prior to test",
+				    vcpus[j]->id);
+
+		eventfd_write(eventfd, 1);
+
+		clock_gettime(CLOCK_MONOTONIC, &start);
+		while (!GUEST_RECEIVED_IRQ(vcpu) &&
+		       timespec_to_ns(timespec_elapsed(start)) <= timeout_ns)
+			cpu_relax();
+
+		TEST_ASSERT(GUEST_RECEIVED_IRQ(vcpu),
+			    "vCPU %d timed out waiting for IRQ (vector 0x%x) from GSI %d\n",
+			    vcpu->id, vector, gsi);
+
+		WRITE_AND_SYNC_TO_GUEST(vm, guest_received_irq[vcpu->id], false);
+	}
+
+	WRITE_AND_SYNC_TO_GUEST(vm, done, true);
+
+	for (i = 0; i < nr_vcpus; i++)
+		pthread_join(vcpu_threads[i], NULL);
+
+	return 0;
+}
-- 
2.55.0.rc0.799.gd6f94ed593-goog

