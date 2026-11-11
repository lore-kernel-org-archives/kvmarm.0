Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794436158;
	b=h7uMzF9wwuAidHRbVVRfwjf9WlKyix9JunmQUwfD+EqQoVKkr38LMYILKPPtKfIRfnlv
	 jkapcOlPpYq3pXNWN8mMoK9k39hRk5y76qyKoPXfQcsDGeK1/jLx/qiniprHXqt3MdGS7
	 ZU0OTRaJX4aUhqrtrHTf3AtzZ/ABSdPfWmkVpdeQtsV/YA8v5xszb9ecKhVXIdPQEcAPM
	 4q0/MGSieWsJKEkLzJ2y39berWcua+Jd4/bkJ374NQtdiNKlPwP1engtlJTu2cz5+WymI
	 f1RG1Spk5iKpgIFjunZo3iXQHwkdcEPme8E5LiRK0/CGZtl5A+Fkr7cwJM4UYCqv89w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794436158;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Sender:X-SRS-Rewrite;
	bh=KgKBmfNow48cZ1G10epSivTTjrObHChEEXVuHDKOCn8=;
	b=O1wM8/UjAXIxgArd1RC3kpVKCCPfBkg0+9nIAOp1jju00pyj8be1ZyFf07/2bjoA7Rb4
	 qtPw3OdyOPQXRIdvH49lkW/ywt2k0r29JoCYrYhaGmJT9NC+bGcz0BuXuMgAV9A0+Jy4s
	 oFZz2UEZ7+j2oOERPSCm4PeXTqqgO1ftvGLDMnIyw4lOGrrh1bosG83KAYy32ANq0+gzQ
	 3Rvi7CnJ81qEcr2a9Pc14oLaMpkcYaOqlpnAw0N1rEphQiSoQY63KiNG96LpZriDx76PD
	 jNV9YIhZ/w0PNL4P3VXYAJp2/dikY3LbIJsLzQlKHKNV7XKJZnIArZOF71ldOmdq/JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=casper.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=Pm4SuBXS;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0D0606A332;
	Wed, 11 Nov 2026 22:29:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F0D0606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=Pm4SuBXS
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KgKBmfNow48cZ1G10epSivTTjrObHChEEXVuHDKOCn8=; b=Pm4SuBXS8SoBqJZi9NmFWsZy9L
	x0MVQqHd1l+IslxepicxxQh2nE6uQ9N5mEoR6whjfR2AZEz0psaZYeVvZrGpompc62cXG3u+5ARTk
	pcOkzQ+oqbY2/rACT0DRF9FDvvrAzai3SmStFzKXJNu/QPMJdWkOzaWIq/k3DtCl2jZBwvP6AN6XO
	UbzUJXfObyZ6n4anyORINk1sg/CGhCBAhpV2N8FAlMjebExTQ6poCdOsdWybSf5ywhurcd2eOp2Xp
	TdgU8Yc54ANXwBz9lKNifs4DgAAREosK5RNlgVCYs8BHe1r9NCJZmwK0oo0q+fcChzZ1LcYpMCF1i
	PND7Y70A==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRGoZ-0000000G3nm-43bK;
	Wed, 11 Nov 2026 22:29:12 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.99.5 #2 (Red Hat Linux))
	id 1xRGoZ-00000000088-35Wr;
	Wed, 11 Nov 2026 22:29:11 +0000
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
Subject: [PATCH 05/16] KVM: x86: Initialise Hyper-V state on every plane vCPU
Date: Wed, 11 Nov 2026 14:29:00 -0800
Message-ID: <20261111222911.477-6-dwmw2@infradead.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261111222911.477-1-dwmw2@infradead.org>
References: <20260608144252.351443-1-joro@8bytes.org>
 <20261111222911.477-1-dwmw2@infradead.org>
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

When userspace sets a Hyper-V CPUID, kvm_set_cpuid() walks the vCPU's
planes to allocate the per-plane kvm_vcpu_hv, but passes the plane-0
vCPU to kvm_hv_vcpu_init() on every iteration. Non-zero plane vCPUs
are left without hv_vcpu, which trips the
WARN_ON_ONCE(vcpu->arch.hyperv_enabled) in kvm_hv_set_cpuid() and
leaves their vp_index and SynIC state uninitialised until a lazy init
path happens to run. Pass the plane vCPU being iterated.

A twin created *after* KVM_SET_CPUID never passes through
kvm_set_cpuid() at all, but shares a CPUID that already advertises
Hyper-V. Allocate its context in kvm_arch_vcpu_create(), so that
-ENOMEM fails KVM_CREATE_VCPU on the plane fd rather than leaving one
twin silently without Hyper-V.

That allocation runs before the twin's vcpu->vcpu_idx is assigned, so
kvm_hv_vcpu_init() takes the default VP index from the common, which
already holds it. With vcpu->vcpu_idx the twin would latch 0xFFFFFFFF,
and a host write of the real index to HV_X64_MSR_VP_INDEX would then
decrement num_mismatched_vp_indexes for a mismatch that was never
counted. (Assigning vcpu->vcpu_idx earlier instead would defeat the
"vcpu_idx < 0 means unreachable" test that to_hv_vcpu()'s lockdep
assertion falls back on during creation.)

Also admit KVM_ENABLE_CAP on plane vCPU fds, so userspace can enable
per-vCPU capabilities such as KVM_CAP_HYPERV_SYNIC2 on a plane vCPU
before it first runs.

Fixes the Hyper-V initialisation of plane vCPUs in "kvm: x86: Update
state for all plane VCPUs after CPUID update" and "KVM: Implement
KVM_CREATE_VCPU ioctl for planes".

Fixes: https://lore.kernel.org/all/20260608144252.351443-46-joro@8bytes.org/
Fixes: https://lore.kernel.org/all/20260608144252.351443-34-joro@8bytes.org/
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/cpuid.c  |  4 ++--
 arch/x86/kvm/cpuid.h  |  1 +
 arch/x86/kvm/hyperv.c |  7 ++++++-
 arch/x86/kvm/x86.c    | 20 +++++++++++++++++++-
 4 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7a32f658238a..54bcfedc5226 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -326,7 +326,7 @@ static void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 						 vcpu->arch.ia32_xss, true);
 }
 
-static bool kvm_cpuid_has_hyperv(struct kvm_vcpu *vcpu)
+bool kvm_cpuid_has_hyperv(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_KVM_HYPERV
 	struct kvm_cpuid_entry2 *entry;
@@ -553,7 +553,7 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 #ifdef CONFIG_KVM_HYPERV
 	if (kvm_cpuid_has_hyperv(vcpu)) {
 		vcpu_for_each_plane(common, i, v) {
-			r = kvm_hv_vcpu_init(vcpu);
+			r = kvm_hv_vcpu_init(v);
 			if (r)
 				goto err;
 		}
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 2abfab4b1c33..02dbd02c8f80 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -21,6 +21,7 @@ static inline void kvm_finalize_cpu_caps(void)
 }
 
 void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu);
+bool kvm_cpuid_has_hyperv(struct kvm_vcpu *vcpu);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry2(struct kvm_cpuid_entry2 *entries,
 					       int nent, u32 function, u64 index);
 /*
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 1855b7e13e82..0b7440d09d49 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -997,7 +997,12 @@ int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
 	for (i = 0; i < ARRAY_SIZE(hv_vcpu->stimer); i++)
 		stimer_init(&hv_vcpu->stimer[i], i);
 
-	hv_vcpu->vp_index = vcpu->vcpu_idx;
+	/*
+	 * A plane twin is initialised here from kvm_arch_vcpu_create(),
+	 * before vcpu->vcpu_idx is assigned; the index it is about to
+	 * get is already in the shared common.
+	 */
+	hv_vcpu->vp_index = vcpu->common->vcpu_idx;
 
 	for (i = 0; i < HV_NR_TLB_FLUSH_FIFOS; i++) {
 		INIT_KFIFO(hv_vcpu->tlb_flush_fifo[i].entries);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2e38eaa0b7df..25f574bfbb32 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3467,6 +3467,7 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 bool kvm_arch_is_vcpu_plane_ioctl(unsigned ioctl)
 {
 	switch (ioctl) {
+	case KVM_ENABLE_CAP:
 	case KVM_GET_DEBUGREGS:
 	case KVM_SET_DEBUGREGS:
 	case KVM_GET_LAPIC:
@@ -9635,9 +9636,24 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.hv_root_tdp = INVALID_PAGE;
 #endif
 
+	/*
+	 * A plane twin created after KVM_SET_CPUID shares CPUID that may
+	 * already advertise Hyper-V.  Allocate the Hyper-V context now so
+	 * a failure fails the creation; left to kvm_vcpu_after_set_cpuid()
+	 * below, an -ENOMEM silently downgrades just this twin to no
+	 * Hyper-V (its MSRs fail) while the shared CPUID still advertises
+	 * the Hyper-V signature, and nothing short of another full
+	 * KVM_SET_CPUID repairs it.
+	 */
+	if (kvm_cpuid_has_hyperv(vcpu)) {
+		r = kvm_hv_vcpu_init(vcpu);
+		if (r)
+			goto free_guest_fpu;
+	}
+
 	r = kvm_x86_call(vcpu_create)(vcpu);
 	if (r)
-		goto free_guest_fpu;
+		goto free_hv;
 
 	kvm_xen_init_vcpu(vcpu);
 	vcpu_load(vcpu);
@@ -9648,6 +9664,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu_put(vcpu);
 	return 0;
 
+free_hv:
+	kvm_hv_vcpu_uninit(vcpu);
 free_guest_fpu:
 	fpu_free_guest_fpstate(&vcpu->arch.guest_fpu);
 free_emulate_ctxt:
-- 
2.50.1

