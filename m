Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794436157;
	b=D/UDft/JgxfAQsezW4g1tfFwg8KNlrPBEe17tCJeNvxE3mpP0jsjQIyBV6GjgZ6nTb8z
	 zHQ4dfnTlOUvZbzPVh1HlDjyYG2aiFQyzY3zkPmCUvtU+30I/w9BhQ+sAKO31oGTWW6le
	 m9YuWgsZAq9G+pGbSBrqVIk/Y3UvxfrRckRpk55pE3sS8YIz98M3TqlcNDXbrPJXkc5Qf
	 sH5enW8MXuya2xswqb9KSmOW2SeZP0yW3KC743XjioMxxKcl0ZrbN0lIQn8qI3TvaEtHm
	 DN4ukWTJUJggsfDVT9g/olXF8EphCD/myk4nE+livdkQTJl1zkOIHdXcX3LsmS3n3gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794436157;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Sender:X-SRS-Rewrite;
	bh=vestvomZ7rRP1B3U6q1sqnTnXF0ZBci1/XWHqSLuq/k=;
	b=Iw0DIVQM61JOw39dNv3ABJWtPweXVFuKiisleBKV+MMIEP0zcZiEqkNwkqrSl7BK8tME
	 nYDCeJ8mCT11mIp9Lna2LMBk8GRHjbOQIQxghegVETPNjcL323ExJMRO5VmYh+1G+kKKj
	 UKjH8VF8yGYyxQZQ+77+o8pX3jfVsAl/h5pODaQppTTo9XgZRMVOsRi6iKRgm7qzEFZ9d
	 KbqzXegtfUpoOZdY1h1q2oXHG0yxFvsJf50kH8LgAngY7dfyT2ub10Gg5+2TsavxU9rXi
	 WrxnQks/sEl/Gic6PEpMR6HUdYll6sB8NSPGPajxIjGziuBIucEM7y0LQt/AYroVmfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=casper.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=rVKR4EoU;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDDC606A327;
	Wed, 11 Nov 2026 22:29:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6EDDC606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=rVKR4EoU
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=vestvomZ7rRP1B3U6q1sqnTnXF0ZBci1/XWHqSLuq/k=; b=rVKR4EoUQukRzLiXFIHcDb9FFd
	FDPcPWaxhE71qH5PIZSv7vooQkW/zUyHhGtRqED26UkFVzwPEHPjFAbqH5Q6ieOCbmFdxI5w45Z30
	eByqRPQq92Bya32NwARx4RG92gh6GgCi36gOy5C7w1naV8uv4DjPTJ+ncmoYZ38+CysdwXsD6xvcI
	E3nAPKxMXpgdUPCoeBt7q8pmVKI64kxT6ezto8ryI6Bqmeue2U3D8766FSDk4w+oKFmBMjl7VOx+P
	mEd8bqEdU52KUELDf63jeToigmnIuEp/7aGvhlrrgK74hFb9ENUC8/BrNfZV7GzlfJyIXQmLKm7z2
	yVO5Xfaw==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRGoa-0000000G3o0-1gsK;
	Wed, 11 Nov 2026 22:29:12 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.99.5 #2 (Red Hat Linux))
	id 1xRGoa-0000000008i-0uyB;
	Wed, 11 Nov 2026 22:29:12 +0000
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
Subject: [PATCH 14/16] KVM: x86: Derive runtime CPUID bits from the executing plane
Date: Wed, 11 Nov 2026 14:29:09 -0800
Message-ID: <20261111222911.477-15-dwmw2@infradead.org>
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

From: Mushahid Hussain <hmushi@amazon.co.uk>

Some CPUID bits follow registers of the vCPU: CPUID.1:ECX.OSXSAVE
follows CR4.OSXSAVE, CPUID.7:ECX.OSPKE follows CR4.PKE, CPUID.1:EDX.APIC
follows the APIC enable, CPUID.1:ECX.MWAIT follows MISC_ENABLE, and the
XSAVE area sizes in leaf 0xD follow XCR0 and XSS. KVM keeps the CPUID
table of a vCPU in the state its planes share, and refreshes those bits
into the table from the state of whichever vCPU runs when the table is
dirty. The planes of a vCPU have their own control registers, so after
one plane sets CR4.OSXSAVE, CPUID on every plane of that vCPU reports
OSXSAVE until a plane with it clear refreshes the table, and the other
way round. The architecture requires CPUID to describe the processor
that executes it, and for a plane that is the plane's own registers.

A Windows guest with Virtual Secure Mode shows the leak. Its secure
kernel runs on a plane whose CR4.OSXSAVE is clear while the normal
kernel on the other plane has set it. The secure kernel executes the
usual probe, CPUID.1 followed by a test of OSXSAVE, reads the bit set
and executes XGETBV, which raises #UD because its own CR4 does not
permit it.

Compute the bits that follow vCPU registers when CPUID is emulated,
from the registers of the vCPU that executes it, and no longer refresh
the shared table on that path. The table keeps the view of plane 0 for
KVM_GET_CPUID2 and KVM_SET_CPUID2, which act on the plane 0 vCPU, and
their refresh stays as it is.

Fixes the shared runtime CPUID bits in "kvm: x86: Move CPUID state to
struct kvm_vcpu_arch_common".

[dwmw2: dropped the plane selftest hunk; this branch has no
 plane_x86_test.c.  The per-VTL OSXSAVE contract is pinned by the
 hyperv_vsm tests on the vsm-v2 branch of
 git://git.infradead.org/users/dwmw2/kvm-unit-tests.git instead.]
Fixes: https://lore.kernel.org/all/20260608144252.351443-44-joro@8bytes.org/
Not-signed-off-by: Mushahid Hussain <hmushi@amazon.co.uk>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 Documentation/virt/kvm/api.rst |   7 +++
 arch/x86/kvm/cpuid.c           | 107 +++++++++++++++++++++++----------
 arch/x86/kvm/cpuid.h           |   5 +-
 3 files changed, 86 insertions(+), 33 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d21378183c51..c1a6536354fd 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -370,6 +370,13 @@ cpu's hardware control block.
 VCPUs for non-zero planes can only be created if the VCPU the same index has
 already been created for plane zero.
 
+The planes of a vCPU share its CPUID model, set through the plane 0 fd with
+KVM_SET_CPUID2.  The CPUID bits that follow a vCPU's own registers (OSXSAVE
+from CR4.OSXSAVE, OSPKE from CR4.PKE, the APIC enable, MWAIT from
+MISC_ENABLE, and the XSAVE area sizes from XCR0 and XSS) reflect the plane
+that executes CPUID, since every plane has these registers of its own.
+KVM_GET_CPUID2 returns them as plane 0 sees them.
+
 4.8 KVM_GET_DIRTY_LOG
 ---------------------
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c9b7dfc5c967..c5fa0551ddd5 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -173,6 +173,9 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
 
 static u32 kvm_apply_cpuid_pv_features_quirk(struct kvm_vcpu *vcpu);
 static void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
+static void kvm_cpuid_apply_runtime(struct kvm_vcpu *vcpu, u32 function,
+				    u32 index, u32 *eax, u32 *ebx, u32 *ecx,
+				    u32 *edx);
 
 /* Check whether the supplied CPUID data is equal to what is already set for the vCPU. */
 static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
@@ -280,50 +283,50 @@ static u64 cpuid_get_supported_xss(struct kvm_vcpu *vcpu)
 	return (best->ecx | ((u64)best->edx << 32)) & kvm_caps.supported_xss;
 }
 
-static __always_inline void kvm_update_feature_runtime(struct kvm_vcpu *vcpu,
-						       struct kvm_cpuid_entry2 *entry,
-						       unsigned int x86_feature,
-						       bool has_feature)
-{
-	cpuid_entry_change(entry, x86_feature, has_feature);
-	guest_cpu_cap_change(vcpu->common, x86_feature, has_feature);
-}
-
+/* The table keeps plane 0's view of the runtime bits for KVM_GET_CPUID2. */
 static void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
 
+	/*
+	 * Compute from the plane-0 twin no matter which plane triggered
+	 * the refresh: KVM_SET_CPUID runs this for every plane in turn.
+	 */
+	if (vcpu->common->vcpus[0])
+		vcpu = vcpu->common->vcpus[0];
+
 	vcpu->common->arch.cpuid_dynamic_bits_dirty = false;
 
 	best = kvm_find_cpuid_entry(vcpu, 1);
 	if (best) {
-		kvm_update_feature_runtime(vcpu, best, X86_FEATURE_OSXSAVE,
-					   kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE));
-
-		kvm_update_feature_runtime(vcpu, best, X86_FEATURE_APIC,
-					   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
-
+		kvm_cpuid_apply_runtime(vcpu, 1, 0, &best->eax, &best->ebx,
+					&best->ecx, &best->edx);
+		guest_cpu_cap_change(vcpu->common, X86_FEATURE_OSXSAVE,
+				     cpuid_entry_has(best, X86_FEATURE_OSXSAVE));
+		guest_cpu_cap_change(vcpu->common, X86_FEATURE_APIC,
+				     cpuid_entry_has(best, X86_FEATURE_APIC));
 		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT))
-			kvm_update_feature_runtime(vcpu, best, X86_FEATURE_MWAIT,
-						   vcpu->arch.ia32_misc_enable_msr &
-						   MSR_IA32_MISC_ENABLE_MWAIT);
+			guest_cpu_cap_change(vcpu->common, X86_FEATURE_MWAIT,
+					     cpuid_entry_has(best, X86_FEATURE_MWAIT));
 	}
 
 	best = kvm_find_cpuid_entry_index(vcpu, 7, 0);
-	if (best)
-		kvm_update_feature_runtime(vcpu, best, X86_FEATURE_OSPKE,
-					   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
-
+	if (best) {
+		kvm_cpuid_apply_runtime(vcpu, 7, 0, &best->eax, &best->ebx,
+					&best->ecx, &best->edx);
+		guest_cpu_cap_change(vcpu->common, X86_FEATURE_OSPKE,
+				     cpuid_entry_has(best, X86_FEATURE_OSPKE));
+	}
 
 	best = kvm_find_cpuid_entry_index(vcpu, 0xD, 0);
 	if (best)
-		best->ebx = xstate_required_size(vcpu->arch.xcr0, false);
+		kvm_cpuid_apply_runtime(vcpu, 0xd, 0, &best->eax, &best->ebx,
+					&best->ecx, &best->edx);
 
 	best = kvm_find_cpuid_entry_index(vcpu, 0xD, 1);
-	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
-		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
-		best->ebx = xstate_required_size(vcpu->arch.xcr0 |
-						 vcpu->arch.ia32_xss, true);
+	if (best)
+		kvm_cpuid_apply_runtime(vcpu, 0xd, 1, &best->eax, &best->ebx,
+					&best->ecx, &best->edx);
 }
 
 bool kvm_cpuid_has_hyperv(struct kvm_vcpu *vcpu)
@@ -2133,17 +2136,58 @@ get_out_of_range_cpuid_entry(struct kvm_vcpu *vcpu, u32 *fn_ptr, u32 index)
 	return kvm_find_cpuid_entry_index(vcpu, basic->eax, index);
 }
 
+/*
+ * The planes share the CPUID table but not CR4, the APIC enable, MISC_ENABLE
+ * or XCR0/XSS: the bits that follow those come from the executing plane.
+ */
+static void kvm_cpuid_apply_runtime(struct kvm_vcpu *vcpu, u32 function,
+				    u32 index, u32 *eax, u32 *ebx, u32 *ecx,
+				    u32 *edx)
+{
+	switch (function) {
+	case 1:
+		*ecx &= ~feature_bit(OSXSAVE);
+		if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE))
+			*ecx |= feature_bit(OSXSAVE);
+
+		*edx &= ~feature_bit(APIC);
+		if (vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE)
+			*edx |= feature_bit(APIC);
+
+		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
+			*ecx &= ~feature_bit(MWAIT);
+			if (vcpu->arch.ia32_misc_enable_msr &
+			    MSR_IA32_MISC_ENABLE_MWAIT)
+				*ecx |= feature_bit(MWAIT);
+		}
+		break;
+	case 7:
+		if (index)
+			break;
+		*ecx &= ~feature_bit(OSPKE);
+		if (kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE))
+			*ecx |= feature_bit(OSPKE);
+		break;
+	case 0xd:
+		if (index == 0)
+			*ebx = xstate_required_size(vcpu->arch.xcr0, false);
+		else if (index == 1 &&
+			 (*eax & (feature_bit(XSAVES) | feature_bit(XSAVEC))))
+			*ebx = xstate_required_size(vcpu->arch.xcr0 |
+						    vcpu->arch.ia32_xss, true);
+		break;
+	default:
+		break;
+	}
+}
+
 bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 	       u32 *ecx, u32 *edx, bool exact_only)
 {
 	u32 orig_function = *eax, function = *eax, index = *ecx;
-	struct kvm_vcpu_common *common = vcpu->common;
 	struct kvm_cpuid_entry2 *entry;
 	bool exact, used_max_basic = false;
 
-	if (common->arch.cpuid_dynamic_bits_dirty)
-		kvm_update_cpuid_runtime(vcpu);
-
 	entry = kvm_find_cpuid_entry_index(vcpu, function, index);
 	exact = !!entry;
 
@@ -2157,6 +2201,7 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 		*ebx = entry->ebx;
 		*ecx = entry->ecx;
 		*edx = entry->edx;
+		kvm_cpuid_apply_runtime(vcpu, function, index, eax, ebx, ecx, edx);
 		if (function == 7 && index == 0) {
 			u64 data;
 			if ((*ebx & (feature_bit(RTM) | feature_bit(HLE))) &&
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 02dbd02c8f80..0128cb38b0f2 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -276,8 +276,9 @@ static __always_inline bool guest_cpu_cap_has(struct kvm_vcpu *vcpu,
 	struct kvm_vcpu_common *common = vcpu->common;
 
 	/*
-	 * Except for MWAIT, querying dynamic feature bits is disallowed, so
-	 * that KVM can defer runtime updates until the next CPUID emulation.
+	 * Except for MWAIT, querying dynamic feature bits is disallowed: the
+	 * guest gets them from the state of the plane that executes CPUID, and
+	 * the table copy is refreshed only for the CPUID ioctls.
 	 */
 	BUILD_BUG_ON(x86_feature == X86_FEATURE_APIC ||
 		     x86_feature == X86_FEATURE_OSXSAVE ||
-- 
2.50.1

