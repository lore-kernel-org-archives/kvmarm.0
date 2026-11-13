Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794594372;
	b=LA2D12c11qd67yiDkXT9D9F5syeTIgqrUEinePF2xFCdW6UkRAEUhR/9wdBMHtJcoH/t
	 wk1xXdLohkgASnNhZBYVuFqsrHJdsh2RbSWq6zKcGmQ52xojSK4MIwPzNWbohsyNRSlOS
	 H3IkvVy5NDNQrsStr9Skye2Jg9a6txI/AEpZul7rwtkimM0iWfcTLMfcOXE4vafroBjBU
	 9efaGksH6zdmh4QZNBAM5QfBRY10zQuPBEDWhwT2jVVVZaX5aTIUzPr6cVA4F4T9QA6id
	 wUNfXSaaMMRaBLLwkbHjltOfXGoWbsCW0bsHnQOTe2sWZMvzP/LiZfaxq7wNNEUOJEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794594372;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Sender:X-SRS-Rewrite;
	bh=msKkdHtgD2b3oR0fa9FcUaIRWkyCYgWeMc0j/s9P6i0=;
	b=ryZRqNJLFbZsw++iM5SauyvyU0KaCsQkYznGGyKRqPljOh9NAcfCgOtePH2zPeojyJvY
	 hvcxtdM0JBGVThsXf+Z8aPKlDl5AI+7hzyWY/kFb/7ev+q+XxP22ouTgynUPMquYf5R+0
	 3Vd/bw/rp3To4QjQXMDpEhY636IvOc8SC8SmjUOeGM3ZxCuy7+CVh3a2iGgc6HiTkFDHR
	 Lebjbt4fxSfA7mEpC1or4WXuVxi4HvTa03JGVJOSG6dx26IIw/iiWk+Rsf9XOAgtWj8Yi
	 hf0WS36vRqstIYvtGg7Ha03XuoJP1sjznaBrPgY6TzdShfklj/drK2GXSw8EwCKnBrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=casper.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=Zx4HqS+o;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E40A606A335;
	Fri, 13 Nov 2026 18:26:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E40A606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=Zx4HqS+o
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=msKkdHtgD2b3oR0fa9FcUaIRWkyCYgWeMc0j/s9P6i0=; b=Zx4HqS+ofJPysjuxqvHILtgMFz
	fztLdc4K36XPZ6PZLoefYSbw5DvHM+1xg5D4gEN2t8LvGnjxeeCHChs5cqiQU8+1x/zFQnXQm646l
	vCozneNrBYMFTQebLmimVaDmt9AlOhKnN8aFK8Ck5mwgxEamqEAohOcXnHxWiAo4ctWEEbIWq232P
	PtDivBQLBUReqXJ/pN+aqrdQ2PA79OVflNncjbceKvt52DZsZpvaOD+W/NZ8oVFHu11SdZ8Du2CMf
	BEorl+Ej/aumtFZWUFZU87deTHDoGnNf8xcR6AYFSQsO4S2/ugiQhV9+n/AGOGTMttC3B7jF72eYy
	/Ez7yqiA==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRvyS-00000004cT7-0Gm0;
	Fri, 13 Nov 2026 18:26:08 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.99.5 #2 (Red Hat Linux))
	id 1xRvyR-00000000LYZ-3bgH;
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
Subject: [RFC PATCH 12/13] KVM: selftests: Check CPUID handling of plane twins
Date: Fri, 13 Nov 2026 11:26:06 -0700
Message-ID: <20261113182607.82813-13-dwmw2@infradead.org>
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
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

Two checks of how plane twins follow the CPUID they share.

A plane vCPU created after KVM_SET_CPUID gets its Hyper-V context in
kvm_arch_vcpu_create(), before its vCPU index is assigned, and used to
latch a VP index of 0xFFFFFFFF. Create two vCPUs, give them a Hyper-V
CPUID, then create their plane-1 twins and check that
HV_X64_MSR_VP_INDEX on each twin reads its vCPU index.

Once a twin has run, KVM_SET_CPUID2 must accept only the CPUID already
set, even on a plane 0 that has never run. Run plane 1 with plane 0
held (a real-mode OUT, then retired), and check that identical CPUID is
accepted and that CPUID with XTILE added to leaf 0xD fails with EINVAL.
Before kvm_set_cpuid() checked every twin, that call went on to the
fpstate code, which failed it with EPERM, or resized the twin that ran
if the process had AMX permission.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 tools/testing/selftests/kvm/x86/planes_test.c | 125 +++++++++++++++++-
 1 file changed, 122 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/planes_test.c b/tools/testing/selftests/kvm/x86/planes_test.c
index 968f1b099b8e..dd3c251f0b7a 100644
--- a/tools/testing/selftests/kvm/x86/planes_test.c
+++ b/tools/testing/selftests/kvm/x86/planes_test.c
@@ -1,16 +1,19 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * Test the KVM_CAP_PLANES opt-in and the plane lifecycle uAPI: plane
- * creation bounds, plane vCPU creation, and the independence of
- * per-plane vCPU register state.
+ * creation bounds, plane vCPU creation, the independence of
+ * per-plane vCPU register state, the Hyper-V VP index of a plane
+ * vCPU created after KVM_SET_CPUID, and KVM_SET_CPUID2 once a twin
+ * has run.
  */
 #include <errno.h>
 #include <string.h>
 
 #include "kvm_util.h"
 #include "processor.h"
+#include "hyperv.h"
 
-/* Where the run-state test puts plane 0's one instruction. */
+/* Where the tests that enter a plane put its one instruction. */
 #define CODE_GPA	0x1000
 
 /*
@@ -317,6 +320,120 @@ static void test_plane_lifecycle(void)
 	kvm_vm_free(vm);
 }
 
+/*
+ * A plane vCPU created after KVM_SET_CPUID gets its Hyper-V context at
+ * creation, and its default VP index must be its vCPU index like any
+ * other vCPU's, not the -1 the vCPU carries until it is published.
+ */
+static void test_late_twin_vp_index(void)
+{
+	struct kvm_plane_vcpu *twin;
+	struct kvm_vcpu *vcpu[2];
+	struct kvm_plane *plane;
+	struct kvm_vm *vm;
+	int i;
+
+	if (!kvm_has_cap(KVM_CAP_SYS_HYPERV_CPUID)) {
+		print_skip("KVM_CAP_SYS_HYPERV_CPUID not supported");
+		return;
+	}
+
+	vm = vm_create_barebones_irqchip(true);
+	vm_enable_cap(vm, KVM_CAP_PLANES, 2);
+	plane = vm_plane_add(vm, 1);
+
+	for (i = 0; i < 2; i++) {
+		vcpu[i] = __vm_vcpu_add(vm, i);
+		vcpu_set_hv_cpuid(vcpu[i]);
+	}
+
+	for (i = 0; i < 2; i++) {
+		twin = __vm_plane_vcpu_add(vcpu[i], plane);
+		TEST_ASSERT_EQ(plane_vcpu_get_msr(twin, HV_X64_MSR_VP_INDEX), i);
+	}
+
+	kvm_vm_free(vm);
+}
+
+/*
+ * CPUID is shared between plane twins, so once any twin has run,
+ * KVM_SET_CPUID2 on plane 0 only accepts the CPUID already set, even
+ * while plane 0 itself has never run.  Without that, an enlarged
+ * dynamic xfeature would resize the fpstate of the twin that ran.
+ * Plane 1 runs here with plane 0 held: a real-mode OUT at CODE_GPA,
+ * which is then retired.
+ */
+static void test_cpuid_after_twin_ran(void)
+{
+	static const u8 out_insn[] = { 0xe6, 0x10 };	/* out %al, $0x10 */
+	u64 hold = KVM_PLANE_RUN_STATE_USER_HOLD, none = 0;
+	struct kvm_cpuid_entry2 *leaf_d = NULL;
+	struct kvm_plane_vcpu *vcpu1;
+	struct kvm_cpuid2 *enlarged;
+	struct kvm_plane *plane;
+	struct kvm_sregs sregs;
+	struct kvm_vcpu *vcpu0;
+	struct kvm_regs regs;
+	struct kvm_vm *vm;
+	u32 i;
+
+	vm = vm_create_barebones_irqchip(true);
+	vm_enable_cap(vm, KVM_CAP_PLANES, 2);
+	plane = vm_plane_add(vm, 1);
+	vcpu0 = __vm_vcpu_add(vm, 0);
+	vcpu1 = __vm_plane_vcpu_add(vcpu0, plane);
+	vcpu_init_cpuid(vcpu0, kvm_get_supported_cpuid());
+
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, CODE_GPA, 1, 1, 0);
+	memcpy(addr_gpa2hva(vm, CODE_GPA), out_insn, sizeof(out_insn));
+
+	plane_vcpu_ioctl(vcpu1, KVM_GET_SREGS, &sregs);
+	sregs.cs.selector = 0;
+	sregs.cs.base = 0;
+	plane_vcpu_ioctl(vcpu1, KVM_SET_SREGS, &sregs);
+	plane_vcpu_ioctl(vcpu1, KVM_GET_REGS, &regs);
+	regs.rip = CODE_GPA;
+	plane_vcpu_ioctl(vcpu1, KVM_SET_REGS, &regs);
+
+	vcpu_ioctl(vcpu0, KVM_SET_PLANE_RUN_STATE, &hold);
+	plane_vcpu_ioctl(vcpu1, KVM_SET_PLANE_RUN_STATE, &none);
+	TEST_ASSERT_EQ(__vcpu_run(vcpu0), 0);
+	TEST_ASSERT_EQ(vcpu0->run->exit_reason, KVM_EXIT_IO);
+	TEST_ASSERT_EQ(vcpu0->run->io.port, 0x10);
+
+	/* Retire the OUT without entering again. */
+	vcpu0->run->immediate_exit = 1;
+	TEST_ASSERT_EQ(__vcpu_run(vcpu0), -1);
+	TEST_ASSERT_EQ(errno, EINTR);
+	vcpu0->run->immediate_exit = 0;
+
+	/* Identical CPUID is still accepted. */
+	TEST_ASSERT_EQ(__vcpu_ioctl(vcpu0, KVM_SET_CPUID2, vcpu0->cpuid), 0);
+
+	/*
+	 * An enlarged dynamic xfeature is refused by the has-run check
+	 * (EINVAL), before the fpstate code could fail it for lack of
+	 * permission (EPERM).
+	 */
+	enlarged = allocate_kvm_cpuid2(vcpu0->cpuid->nent);
+	memcpy(enlarged, vcpu0->cpuid, kvm_cpuid2_size(vcpu0->cpuid->nent));
+	for (i = 0; i < enlarged->nent; i++) {
+		if (enlarged->entries[i].function == 0xd &&
+		    enlarged->entries[i].index == 0)
+			leaf_d = &enlarged->entries[i];
+	}
+	if (leaf_d) {
+		leaf_d->eax |= XFEATURE_MASK_XTILE;
+		TEST_ASSERT_EQ(__vcpu_ioctl(vcpu0, KVM_SET_CPUID2, enlarged), -1);
+		TEST_ASSERT_EQ(errno, EINVAL);
+	} else {
+		print_skip("no CPUID leaf 0xD, enlarged-xfeature check");
+	}
+	free(enlarged);
+
+	kvm_vm_free(vm);
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_PLANES));
@@ -326,6 +443,8 @@ int main(int argc, char *argv[])
 	test_enable_cap_bounds();
 	test_enable_cap_too_late();
 	test_plane_lifecycle();
+	test_late_twin_vp_index();
+	test_cpuid_after_twin_ran();
 
 	return 0;
 }
-- 
2.50.1

