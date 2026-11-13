Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.92.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794594399;
	b=igwubqh6/xELtTusIutjIzqpS1CaL2ur9C2Jeaa+aschJSzpNOyxOTXj18z7F/T3ldom
	 vofLoU5A2+r8PHEa8/E8OHmsimhs8nuActCi9OaGP14B4EN4PY7W3HqAE/1rNz9JXF2D3
	 VCbE83sYrD5Flpdw4jFMNn8F4oW1OzC5wY3A5Jx6o4qpSAMUORI5hSF//o+eAJJ9ySWUJ
	 I5PyhPmEpN95oxnxgcbekR2WuzgEc55dQMi/N+zujySFiQgG4QKOk3Pfy+z8ybKexMGUH
	 iyXjbHXRFQFqBamKDhrzAG+5BLw7n+ngq/YofoBcVbjs6Mtxnkr5AhP9h9fk9gng7Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794594399;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Sender:X-SRS-Rewrite;
	bh=j/cyH+I8JbWGr5y7TfZ1fzTJDNXAOvaKoNeDeX1cLxg=;
	b=IdYix+jAJr00zIf/+Xobb5d4rwBSqKnL2BU/hX9UHjauofHAGU2/aOw5xPlr2mqMoPui
	 Yl7pAG/u9B05nBFzQQofLwmLGCfIvxoQcCROVa1dAuzNbTAunpIPIA2wUGvECbKXVjAuh
	 Vj7ffP8dRGoGDXmvFm/aC2MYa+fwU6RUYUR7mcbNFXFWY9w/fZdqjGp40xLyL4JLe2SbV
	 DKzdSV+G523PSP5V5zRD2ZlHBqvF0QA1k6i3MTn4z7t7MUiLcNCZsCfuk7KcTQzE9N8Jl
	 ++8cZQ4ClUAcEhc6Q2+4GLvg81q19Vca4kBtbbXxm/htUkf5/aLOOr3ZjAhwzK/jgSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=desiato.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=oqb9qBbL;
	arc=none smtp.remote-ip=90.155.92.199
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC73606C149;
	Fri, 13 Nov 2026 18:26:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9EC73606C149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=oqb9qBbL
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=j/cyH+I8JbWGr5y7TfZ1fzTJDNXAOvaKoNeDeX1cLxg=; b=oqb9qBbLcyFRFld14uYWjtCayL
	AN3z/nzQ9Nwv+qMPkfYzvER/Q6aj+KsXb0xcDtyCZVlk7KLKENSZnsDADr0rAH8Kf9cnHybdsrm56
	q2B9QNHKOmeg3RTuBOV0eXIowU7ogn/RsBZysvkMsSYqj7stBXOiQIvyoVZH3gjySgbr2RhnXMixz
	v8Gk+Un3Ld2Yy/W/tBcmJu/+RS6/yN1gjFmqnpzwJc0BWVG1wRCtlAc5TbVnGtOQyagsle+vrKws4
	o9PbqYnhPRjpmNzIxNh4Xet/3kkwS5mfI5em/aRlb7dbOycG8V4Zs1406FgRF529RYxcf4W7GC6qd
	I5WRM+GQ==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRvyU-0000000BeOc-16c6;
	Fri, 13 Nov 2026 18:26:30 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.99.5 #2 (Red Hat Linux))
	id 1xRvyR-00000000LYd-3rMe;
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
Subject: [RFC PATCH 13/13] KVM: selftests: Cover plane state sharing
Date: Fri, 13 Nov 2026 11:26:07 -0700
Message-ID: <20261113182607.82813-14-dwmw2@infradead.org>
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

Check the KVM_CAP_PLANES share mask: KVM_CAP_PLANES_SHARE reports
XCR0|DR6 on the system fd, 0 on a VM fd before the opt-in and the
enabled bits after it; an unknown bit and a non-zero args[2] fail with
EINVAL, and a second opt-in with another mask fails with EEXIST.

Then, with no sharing and with XCR0 and DR6 shared, write XCR0 and DR6
through plane 0 before creating a plane-1 twin, and check that the twin
inherits them only when shared; write them through plane 1 and check
plane 0; and have plane 1 write DR6 with MOV (real mode, plane 0 held)
and check that plane 0 sees the guest's value only when DR6 is shared.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 tools/testing/selftests/kvm/x86/planes_test.c | 159 +++++++++++++++++-
 1 file changed, 157 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/planes_test.c b/tools/testing/selftests/kvm/x86/planes_test.c
index dd3c251f0b7a..02242cc7d576 100644
--- a/tools/testing/selftests/kvm/x86/planes_test.c
+++ b/tools/testing/selftests/kvm/x86/planes_test.c
@@ -3,8 +3,8 @@
  * Test the KVM_CAP_PLANES opt-in and the plane lifecycle uAPI: plane
  * creation bounds, plane vCPU creation, the independence of
  * per-plane vCPU register state, the Hyper-V VP index of a plane
- * vCPU created after KVM_SET_CPUID, and KVM_SET_CPUID2 once a twin
- * has run.
+ * vCPU created after KVM_SET_CPUID, KVM_SET_CPUID2 once a twin has
+ * run, and the KVM_CAP_PLANES share mask.
  */
 #include <errno.h>
 #include <string.h>
@@ -434,6 +434,154 @@ static void test_cpuid_after_twin_ran(void)
 	kvm_vm_free(vm);
 }
 
+static int __enable_planes_share(struct kvm_vm *vm, u64 count, u64 share, u64 arg2)
+{
+	struct kvm_enable_cap cap = {
+		.cap = KVM_CAP_PLANES,
+		.args = { count, share, arg2 },
+	};
+
+	return __vm_ioctl(vm, KVM_ENABLE_CAP, &cap);
+}
+
+/*
+ * KVM_CAP_PLANES_SHARE reports the supported share bits on the system fd
+ * and the enabled ones on a VM fd.  Unknown bits and a non-zero args[2]
+ * are refused, and like the count the mask is set once.
+ */
+static void test_share_opt_in(void)
+{
+	u64 defined = KVM_PLANE_SHARE_XCR0 | KVM_PLANE_SHARE_DR6;
+	u64 unknown = ~defined & -~defined;
+	struct kvm_vm *vm;
+
+	TEST_ASSERT_EQ(kvm_check_cap(KVM_CAP_PLANES_SHARE), defined);
+
+	vm = vm_create_barebones_irqchip(true);
+	TEST_ASSERT_EQ(vm_check_cap(vm, KVM_CAP_PLANES_SHARE), 0);
+	TEST_ASSERT_EQ(__enable_planes_share(vm, 2, unknown, 0), -1);
+	TEST_ASSERT_EQ(errno, EINVAL);
+	TEST_ASSERT_EQ(__enable_planes_share(vm, 2, 0, 1), -1);
+	TEST_ASSERT_EQ(errno, EINVAL);
+	TEST_ASSERT_EQ(vm_check_cap(vm, KVM_CAP_PLANES), 1);
+
+	TEST_ASSERT_EQ(__enable_planes_share(vm, 2, KVM_PLANE_SHARE_DR6, 0), 0);
+	TEST_ASSERT_EQ(vm_check_cap(vm, KVM_CAP_PLANES_SHARE), KVM_PLANE_SHARE_DR6);
+	TEST_ASSERT_EQ(__enable_planes_share(vm, 2, KVM_PLANE_SHARE_XCR0, 0), -1);
+	TEST_ASSERT_EQ(errno, EEXIST);
+	TEST_ASSERT_EQ(vm_check_cap(vm, KVM_CAP_PLANES_SHARE), KVM_PLANE_SHARE_DR6);
+	kvm_vm_free(vm);
+}
+
+static u64 get_xcr0(int fd)
+{
+	struct kvm_xcrs xcrs = {};
+
+	TEST_ASSERT_EQ(ioctl(fd, KVM_GET_XCRS, &xcrs), 0);
+	TEST_ASSERT_EQ(xcrs.nr_xcrs, 1);
+	return xcrs.xcrs[0].value;
+}
+
+static void set_xcr0(int fd, u64 xcr0)
+{
+	struct kvm_xcrs xcrs = { .nr_xcrs = 1, .xcrs[0] = { .xcr = 0, .value = xcr0 } };
+
+	TEST_ASSERT_EQ(ioctl(fd, KVM_SET_XCRS, &xcrs), 0);
+}
+
+static u64 get_dr6(int fd)
+{
+	struct kvm_debugregs dbg;
+
+	TEST_ASSERT_EQ(ioctl(fd, KVM_GET_DEBUGREGS, &dbg), 0);
+	return dbg.dr6;
+}
+
+static void set_dr6(int fd, u64 dr6)
+{
+	struct kvm_debugregs dbg;
+
+	TEST_ASSERT_EQ(ioctl(fd, KVM_GET_DEBUGREGS, &dbg), 0);
+	dbg.dr6 = dr6;
+	TEST_ASSERT_EQ(ioctl(fd, KVM_SET_DEBUGREGS, &dbg), 0);
+}
+
+/*
+ * With @share, a write through one plane is seen through the other, and a
+ * plane vCPU created later starts with plane 0's value; without it each
+ * plane keeps its own.  Checked for XCR0 and DR6 by ioctl, and for DR6 by
+ * a guest MOV in plane 1 (real mode, at CODE_GPA, with plane 0 held).
+ */
+static void test_share_state(u64 share)
+{
+	static const u8 mov_dr6[] = {
+		0x66, 0xb8, 0xf4, 0x0f, 0xff, 0xff,	/* mov $0xffff0ff4, %eax */
+		0x0f, 0x23, 0xf0,			/* mov %eax, %dr6 */
+		0xe6, 0x10,				/* out %al, $0x10 */
+	};
+	bool xcr0_shared = share & KVM_PLANE_SHARE_XCR0;
+	bool dr6_shared = share & KVM_PLANE_SHARE_DR6;
+	u64 hold = KVM_PLANE_RUN_STATE_USER_HOLD, none = 0;
+	struct kvm_plane_vcpu *vcpu1;
+	struct kvm_plane *plane;
+	struct kvm_sregs sregs;
+	struct kvm_vcpu *vcpu0;
+	struct kvm_regs regs;
+	struct kvm_vm *vm;
+
+	vm = vm_create_barebones_irqchip(true);
+	TEST_ASSERT_EQ(__enable_planes_share(vm, 2, share, 0), 0);
+	plane = vm_plane_add(vm, 1);
+	vcpu0 = __vm_vcpu_add(vm, 0);
+	vcpu_init_cpuid(vcpu0, kvm_get_supported_cpuid());
+
+	/* Plane 0 first, then a plane-1 twin that inherits or not. */
+	set_xcr0(vcpu0->fd, XFEATURE_MASK_FP | XFEATURE_MASK_SSE);
+	set_dr6(vcpu0->fd, 0xffff0ff1);
+	vcpu1 = __vm_plane_vcpu_add(vcpu0, plane);
+	TEST_ASSERT_EQ(get_xcr0(vcpu1->fd), xcr0_shared ?
+		       XFEATURE_MASK_FP | XFEATURE_MASK_SSE : XFEATURE_MASK_FP);
+	TEST_ASSERT_EQ(get_dr6(vcpu1->fd), dr6_shared ? 0xffff0ff1 : 0xffff0ff0);
+
+	/* A write through plane 1. */
+	set_xcr0(vcpu1->fd, XFEATURE_MASK_FP);
+	set_dr6(vcpu1->fd, 0xffff0ff2);
+	TEST_ASSERT_EQ(get_xcr0(vcpu0->fd), xcr0_shared ?
+		       XFEATURE_MASK_FP : XFEATURE_MASK_FP | XFEATURE_MASK_SSE);
+	TEST_ASSERT_EQ(get_dr6(vcpu0->fd), dr6_shared ? 0xffff0ff2 : 0xffff0ff1);
+
+	/* A guest write of DR6 in plane 1. */
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, CODE_GPA, 1, 1, 0);
+	memcpy(addr_gpa2hva(vm, CODE_GPA), mov_dr6, sizeof(mov_dr6));
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
+	vcpu0->run->immediate_exit = 1;
+	TEST_ASSERT_EQ(__vcpu_run(vcpu0), -1);
+	TEST_ASSERT_EQ(errno, EINTR);
+	vcpu0->run->immediate_exit = 0;
+
+	TEST_ASSERT(get_dr6(vcpu1->fd) & BIT(2),
+		    "plane 1 DR6 0x%lx lacks the B2 bit the guest wrote",
+		    (unsigned long)get_dr6(vcpu1->fd));
+	if (dr6_shared)
+		TEST_ASSERT_EQ(get_dr6(vcpu0->fd), get_dr6(vcpu1->fd));
+	else
+		TEST_ASSERT_EQ(get_dr6(vcpu0->fd), 0xffff0ff1);
+
+	kvm_vm_free(vm);
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_PLANES));
@@ -445,6 +593,13 @@ int main(int argc, char *argv[])
 	test_plane_lifecycle();
 	test_late_twin_vp_index();
 	test_cpuid_after_twin_ran();
+	test_share_opt_in();
+	if (kvm_cpu_has(X86_FEATURE_XSAVE)) {
+		test_share_state(0);
+		test_share_state(KVM_PLANE_SHARE_XCR0 | KVM_PLANE_SHARE_DR6);
+	} else {
+		print_skip("XSAVE not supported, plane state sharing");
+	}
 
 	return 0;
 }
-- 
2.50.1

