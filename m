Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.92.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794594399;
	b=HT5dTJdTpObEsTF8pKUhAEz2xGMQUXlb0dEeJXwXFDYGPz7+jxq7PwEj3UhX74/vku1V
	 X6y4QwDZ71oeNIJvAHk56XTGH5eztW2tsFc2tSNd+64xZddXe0dAqSCarS0dvjimzTsOW
	 LJ2OrQROt9cE8PSisAA8UtzYqC+N5MeJt9hiopVUMVFnwiBXsYa86/cvJHsyAdYOuirXk
	 99e3VPCX0ZbjDj4yvGbS26Y532dZ3eHFmscI74FJFWTQ6G+vFQvxHl9aEt8b+d0gNOvQn
	 H4OfjANvGHyrebTzpgcJcW2X6W5bUfHsZQsNdhnuCodO0sIQ4GQYir9LW2ywf/Uog6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794594399;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Sender:X-SRS-Rewrite;
	bh=1AnoyR0j7y5hdrymYbL+ph5cczEf+Al0Tzoil8ZfR/Q=;
	b=qpBtbY2kvlpcTBp2litcszcP1yKM+rFyxrN2W2tYxld24K4CKPeYU6zyQkMOipBj+tc3
	 l5CPFKbu+HyklhPpRkGSlO3vCuZuEOdsz8K49I4uPByz1I9/9nJjj/XSd93pCCEX/Ngr9
	 VbtI0coU4QWQy6ITBI6NDjbi/M7+LyXcR7VPzCpyVxsuVi/ZCeWoCYlyc1flT60fKUBM7
	 kKOF+3TPYrU+YULit1+jjIx8yF20zC1pd3jNmSVgkR5+ipp6j0wRwUgmx9SDXNwZla6Zc
	 OEW46hiKbI9T87OOQRKTnxKL/dX9lOFGOHQ9L7LatKvfMLCiVT8dC6yofGjxY1Kx1nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=desiato.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=hEmKYu4c;
	arc=none smtp.remote-ip=90.155.92.199
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE11606C14B;
	Fri, 13 Nov 2026 18:26:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9EE11606C14B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=hEmKYu4c
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1AnoyR0j7y5hdrymYbL+ph5cczEf+Al0Tzoil8ZfR/Q=; b=hEmKYu4crsHN6alaS6gx4febeC
	bBb2NUhbMZ5nWRl3GR3qDIUZZj9V3hZFviUpX5E2SmikEwTum+wkvcL4hR0+ud4EXfbfT1pTv97r7
	H4nSpPnODolqqQyw81YXnMDLl0QPwSyDqGfhmTW7fXZZ8+vwMO0rVE5rjn8OPd9mCSstFbUmL8VKp
	C4gP2NpnmJg/mzEAIWov1vU4Y6mRSlilz+pPxacK8RJLR6siF04H7xrN0yrsJXKReF40AqvkNEXAM
	L+zp+1MsgIWI5PCEqROMMPtxAiLdq0lcO2na+uqUF9pTLSSafp6xbLjyHWyynqv6BPqWFTL6CBVCY
	e26pXl9g==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRvyU-0000000BeOY-15uE;
	Fri, 13 Nov 2026 18:26:30 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.99.5 #2 (Red Hat Linux))
	id 1xRvyR-00000000LY7-2B60;
	Fri, 13 Nov 2026 18:26:07 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: =?UTF-8?q?J=C3=B6rg=20R=C3=B6del?= <joro@8bytes.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	James.Bottomley@HansenPartnership.com,
	Melody Wang <huibo.wang@amd.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	x86@kernel.org,
	coconut-svsm@lists.linux.dev,
	joerg.roedel@amd.com,
	Mushahid Hussain <hmushi@amazon.co.uk>,
	Sriram Nambakam <snambakam@linux.microsoft.com>,
	David Woodhouse <dwmw@amazon.co.uk>
Subject: [RFC PATCH 05/13] KVM: selftests: Cover plane run-state ioctls in planes_test
Date: Fri, 13 Nov 2026 11:25:59 -0700
Message-ID: <20261113182607.82813-6-dwmw2@infradead.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261113182607.82813-1-dwmw2@infradead.org>
References: <20260608144252.351443-1-joro@8bytes.org>
 <20261113182607.82813-1-dwmw2@infradead.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

Assert that a new plane-1 vCPU starts with KVM_PLANE_RUN_STATE_INACTIVE
and plane 0's with no flags, that every valid combination of
KVM_PLANE_RUN_STATE_USER_HOLD, KVM_PLANE_RUN_STATE_SUSPENDED and
KVM_PLANE_RUN_STATE_INACTIVE reads back as written (so a saved state
restores), and that clearing them reads back as runnable. INACTIVE on
plane 0, INACTIVE together with SUSPENDED and the lowest undefined bit
are refused with EINVAL, and a refused SET leaves an existing hold in
place. On a VM that did not enable more than one plane both ioctls fail
with EINVAL.

With plane 0 held and nothing runnable, KVM_RUN still honours
immediate_exit with EINTR, and otherwise exits with KVM_EXIT_PLANE_EVENT
and cause KVM_PLANE_EVENT_HELD, with kvm_run's if_flag and apic_base
filled in as on any other exit. That exit leaves registers marked in
kvm_dirty_regs unconsumed and unrefreshed, and once plane 1 is released
they land in plane 1, not plane 0. If plane 0 holds a pending I/O
completion, here from a real-mode OUT, a held KVM_RUN fails with EBUSY,
with or without immediate_exit, leaves the KVM_EXIT_IO in kvm_run and
plane 0's RIP on the OUT, and the OUT retires once plane 0 is released.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 tools/testing/selftests/kvm/x86/planes_test.c | 198 +++++++++++++++++-
 1 file changed, 196 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/planes_test.c b/tools/testing/selftests/kvm/x86/planes_test.c
index f7db6cb6807d..968f1b099b8e 100644
--- a/tools/testing/selftests/kvm/x86/planes_test.c
+++ b/tools/testing/selftests/kvm/x86/planes_test.c
@@ -8,6 +8,10 @@
 #include <string.h>
 
 #include "kvm_util.h"
+#include "processor.h"
+
+/* Where the run-state test puts plane 0's one instruction. */
+#define CODE_GPA	0x1000
 
 /*
  * Whether this host lets a VM have more than one plane: the opt-in also
@@ -61,12 +65,22 @@ static void test_enable_cap_bounds(void)
 static void test_enable_cap_too_late(void)
 {
 	struct kvm_vm *vm = vm_create_barebones_irqchip(true);
-
-	__vm_vcpu_add(vm, 0);
+	struct kvm_vcpu *vcpu = __vm_vcpu_add(vm, 0);
 
 	TEST_ASSERT_EQ(__vm_enable_cap(vm, KVM_CAP_PLANES, 2), -1);
 	TEST_ASSERT_EQ(errno, EEXIST);
 
+	/* Without more than one user-managed plane there is no run state. */
+	{
+		u64 flags;
+
+		TEST_ASSERT_EQ(__vcpu_ioctl(vcpu, KVM_GET_PLANE_RUN_STATE, &flags), -1);
+		TEST_ASSERT_EQ(errno, EINVAL);
+		flags = 0;
+		TEST_ASSERT_EQ(__vcpu_ioctl(vcpu, KVM_SET_PLANE_RUN_STATE, &flags), -1);
+		TEST_ASSERT_EQ(errno, EINVAL);
+	}
+
 	kvm_vm_free(vm);
 }
 
@@ -107,6 +121,186 @@ static void test_plane_lifecycle(void)
 	vcpu0 = __vm_vcpu_add(vm, 0);
 	vcpu1 = __vm_plane_vcpu_add(vcpu0, plane);
 
+	/*
+	 * A new plane-1 vCPU is inactive, and plane 0's has no flags.
+	 * Every valid combination reads back as written, so a saved state
+	 * restores; unknown bits, INACTIVE on plane 0 and INACTIVE together
+	 * with SUSPENDED are refused.
+	 */
+	{
+		static const u64 states[] = {
+			KVM_PLANE_RUN_STATE_USER_HOLD,
+			KVM_PLANE_RUN_STATE_SUSPENDED,
+			KVM_PLANE_RUN_STATE_USER_HOLD |
+				KVM_PLANE_RUN_STATE_SUSPENDED,
+			KVM_PLANE_RUN_STATE_INACTIVE,
+			KVM_PLANE_RUN_STATE_USER_HOLD |
+				KVM_PLANE_RUN_STATE_INACTIVE,
+			0,
+		};
+		u64 flags = ~0ULL;
+		int i;
+
+		plane_vcpu_ioctl(vcpu1, KVM_GET_PLANE_RUN_STATE, &flags);
+		TEST_ASSERT_EQ(flags, KVM_PLANE_RUN_STATE_INACTIVE);
+		flags = ~0ULL;
+		vcpu_ioctl(vcpu0, KVM_GET_PLANE_RUN_STATE, &flags);
+		TEST_ASSERT_EQ(flags, 0);
+
+		flags = KVM_PLANE_RUN_STATE_INACTIVE;
+		TEST_ASSERT_EQ(__vcpu_ioctl(vcpu0, KVM_SET_PLANE_RUN_STATE,
+					    &flags), -1);
+		TEST_ASSERT_EQ(errno, EINVAL);
+
+		for (i = 0; i < ARRAY_SIZE(states); i++) {
+			flags = states[i];
+			plane_vcpu_ioctl(vcpu1, KVM_SET_PLANE_RUN_STATE, &flags);
+			flags = ~0ULL;
+			plane_vcpu_ioctl(vcpu1, KVM_GET_PLANE_RUN_STATE, &flags);
+			TEST_ASSERT_EQ(flags, states[i]);
+		}
+
+		/* A refused SET leaves the hold in place. */
+		flags = KVM_PLANE_RUN_STATE_USER_HOLD;
+		plane_vcpu_ioctl(vcpu1, KVM_SET_PLANE_RUN_STATE, &flags);
+
+		flags = KVM_PLANE_RUN_STATE_INACTIVE | KVM_PLANE_RUN_STATE_SUSPENDED;
+		TEST_ASSERT_EQ(__plane_vcpu_ioctl(vcpu1, KVM_SET_PLANE_RUN_STATE,
+						  &flags), -1);
+		TEST_ASSERT_EQ(errno, EINVAL);
+
+		/* The lowest bit that no flag defines. */
+		flags = ~(u64)(KVM_PLANE_RUN_STATE_USER_HOLD |
+			       KVM_PLANE_RUN_STATE_SUSPENDED |
+			       KVM_PLANE_RUN_STATE_INACTIVE);
+		flags &= -flags;
+		TEST_ASSERT_EQ(__plane_vcpu_ioctl(vcpu1, KVM_SET_PLANE_RUN_STATE,
+						  &flags), -1);
+		TEST_ASSERT_EQ(errno, EINVAL);
+		flags = ~0ULL;
+		plane_vcpu_ioctl(vcpu1, KVM_GET_PLANE_RUN_STATE, &flags);
+		TEST_ASSERT_EQ(flags, KVM_PLANE_RUN_STATE_USER_HOLD);
+	}
+
+	/*
+	 * Plane 1 is held from above.  With plane 0 held too, nothing is
+	 * runnable, and KVM_RUN hands that back to userspace instead of
+	 * running the held plane 0.
+	 */
+	{
+		u64 flags = KVM_PLANE_RUN_STATE_USER_HOLD;
+		struct kvm_regs regs;
+
+		vcpu_ioctl(vcpu0, KVM_SET_PLANE_RUN_STATE, &flags);
+
+		/* immediate_exit yields EINTR, as on any KVM_RUN. */
+		vcpu0->run->immediate_exit = 1;
+		TEST_ASSERT_EQ(__vcpu_run(vcpu0), -1);
+		TEST_ASSERT_EQ(errno, EINTR);
+		vcpu0->run->immediate_exit = 0;
+
+		/* The exit fills in kvm_run like any other: poison two fields. */
+		vcpu0->run->if_flag = 0xff;
+		vcpu0->run->apic_base = 0;
+		TEST_ASSERT_EQ(__vcpu_run(vcpu0), 0);
+		TEST_ASSERT_EQ(vcpu0->run->exit_reason, KVM_EXIT_PLANE_EVENT);
+		TEST_ASSERT_EQ(vcpu0->run->plane_event.cause, KVM_PLANE_EVENT_HELD);
+		TEST_ASSERT_EQ(vcpu0->run->plane_event.plane, 0);
+		TEST_ASSERT_EQ(vcpu0->run->if_flag, 0);
+		TEST_ASSERT_EQ(vcpu0->run->apic_base,
+			       vcpu_get_msr(vcpu0, MSR_IA32_APICBASE));
+
+		/*
+		 * Registers userspace marks dirty are for the plane that runs
+		 * next: the held exit neither consumes nor overwrites them.
+		 */
+		plane_vcpu_ioctl(vcpu1, KVM_GET_REGS, &vcpu0->run->s.regs.regs);
+		vcpu0->run->s.regs.regs.rdx = 0x5ca1ab1e;	/* arbitrary marker */
+		vcpu0->run->kvm_valid_regs = KVM_SYNC_X86_REGS;
+		vcpu0->run->kvm_dirty_regs = KVM_SYNC_X86_REGS;
+		TEST_ASSERT_EQ(__vcpu_run(vcpu0), 0);
+		TEST_ASSERT_EQ(vcpu0->run->exit_reason, KVM_EXIT_PLANE_EVENT);
+		TEST_ASSERT_EQ(vcpu0->run->kvm_dirty_regs, KVM_SYNC_X86_REGS);
+		TEST_ASSERT_EQ(vcpu0->run->s.regs.regs.rdx, 0x5ca1ab1e);
+
+		/*
+		 * Released, plane 1 is next and takes them; immediate_exit
+		 * stops it before entry, after the registers are applied.
+		 */
+		flags = 0;
+		plane_vcpu_ioctl(vcpu1, KVM_SET_PLANE_RUN_STATE, &flags);
+		vcpu0->run->immediate_exit = 1;
+		TEST_ASSERT_EQ(__vcpu_run(vcpu0), -1);
+		TEST_ASSERT_EQ(errno, EINTR);
+		vcpu0->run->immediate_exit = 0;
+		TEST_ASSERT_EQ(vcpu0->run->kvm_dirty_regs, 0);
+		vcpu0->run->kvm_valid_regs = 0;
+
+		plane_vcpu_ioctl(vcpu1, KVM_GET_REGS, &regs);
+		TEST_ASSERT_EQ(regs.rdx, 0x5ca1ab1e);
+		vcpu_ioctl(vcpu0, KVM_GET_REGS, &regs);
+		TEST_ASSERT(regs.rdx != 0x5ca1ab1e,
+			    "plane 0 took the registers dirtied while it was held");
+
+		vcpu_ioctl(vcpu0, KVM_SET_PLANE_RUN_STATE, &flags);
+	}
+
+	/*
+	 * A completion plane 0 still owes its last exit stays pending while
+	 * plane 0 is held: KVM_RUN fails with EBUSY and leaves the exit in
+	 * kvm_run, and the completion runs once plane 0 runs again.  The
+	 * exit is a real-mode OUT at CODE_GPA, which userspace handles.
+	 */
+	{
+		static const u8 out_insn[] = { 0xe6, 0x10 };	/* out %al, $0x10 */
+		u64 flags = KVM_PLANE_RUN_STATE_USER_HOLD;
+		struct kvm_sregs sregs;
+		struct kvm_regs regs;
+
+		vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, CODE_GPA,
+					    1, 1, 0);
+		memcpy(addr_gpa2hva(vm, CODE_GPA), out_insn, sizeof(out_insn));
+
+		vcpu_sregs_get(vcpu0, &sregs);
+		sregs.cs.selector = 0;
+		sregs.cs.base = 0;
+		vcpu_sregs_set(vcpu0, &sregs);
+		vcpu_regs_get(vcpu0, &regs);
+		regs.rip = CODE_GPA;
+		vcpu_regs_set(vcpu0, &regs);
+
+		/* Plane 1 stays held, so only plane 0 can run. */
+		plane_vcpu_ioctl(vcpu1, KVM_SET_PLANE_RUN_STATE, &flags);
+		TEST_ASSERT_EQ(__vcpu_run(vcpu0), 0);
+		TEST_ASSERT_EQ(vcpu0->run->exit_reason, KVM_EXIT_IO);
+		TEST_ASSERT_EQ(vcpu0->run->io.direction, KVM_EXIT_IO_OUT);
+		TEST_ASSERT_EQ(vcpu0->run->io.port, 0x10);
+
+		vcpu_ioctl(vcpu0, KVM_SET_PLANE_RUN_STATE, &flags);
+		vcpu0->run->immediate_exit = 1;
+		TEST_ASSERT_EQ(__vcpu_run(vcpu0), -1);
+		TEST_ASSERT_EQ(errno, EBUSY);
+		vcpu0->run->immediate_exit = 0;
+		TEST_ASSERT_EQ(__vcpu_run(vcpu0), -1);
+		TEST_ASSERT_EQ(errno, EBUSY);
+		TEST_ASSERT_EQ(vcpu0->run->exit_reason, KVM_EXIT_IO);
+		TEST_ASSERT_EQ(vcpu0->run->io.port, 0x10);
+		vcpu_regs_get(vcpu0, &regs);
+		TEST_ASSERT_EQ(regs.rip, CODE_GPA);
+
+		/* Released, plane 0 retires the OUT before immediate_exit. */
+		flags = 0;
+		vcpu_ioctl(vcpu0, KVM_SET_PLANE_RUN_STATE, &flags);
+		vcpu0->run->immediate_exit = 1;
+		TEST_ASSERT_EQ(__vcpu_run(vcpu0), -1);
+		TEST_ASSERT_EQ(errno, EINTR);
+		vcpu0->run->immediate_exit = 0;
+		vcpu_regs_get(vcpu0, &regs);
+		TEST_ASSERT_EQ(regs.rip, CODE_GPA + sizeof(out_insn));
+
+		plane_vcpu_ioctl(vcpu1, KVM_SET_PLANE_RUN_STATE, &flags);
+	}
+
 	/* Register state is per plane: write plane 1, plane 0 unaffected. */
 	plane_vcpu_ioctl(vcpu1, KVM_GET_REGS, &regs1);
 	regs1.rbx = 0x5157ca11;	/* arbitrary marker */
-- 
2.50.1

