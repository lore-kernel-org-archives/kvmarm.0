Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.92.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794594399;
	b=rJhjLe0rMIW8US05Ws9DRNgLhIVdSdu2/Tc3zSrFskEdEoRxhDFsQF5Ro+nQJPTDhtX4
	 TxGQ33iBgrGJOprHwwS4oFGclWA9OJCuZq+6yUdRzkFrB9Y/YuthWSbD8CqGFrvNQEH0b
	 FL2lmK9gl2AU69ft17HoMIIft4RHGRRL6aQUI2RsUwdNLfxjeU3i8JmxluiJ5zajtQ/zp
	 zdAtzsv8ovZE8kDJnE9zXYcz9Ksru6FYW8Hk7IZxdhpc1kdSich2gu28k/Bq3Cf48ZI++
	 m1Iyag5vi3D1sULhzTiTwhlS/h2CMLCgX1cXGwYOXkqJWaYW6lKpvnurgYmeUL7iAdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794594399;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Sender:X-SRS-Rewrite;
	bh=wt/q8P3zBd6hu3TnYFCC/E9Q4utWihMtB20Llr0upI4=;
	b=fi2vylLW6hOhvHJko+HrtCIi/it/ReckX4RrO6OZh/5H28koOOi5vzkOTHT8QJKJeiUU
	 +kkfFNpBxA6atNEWNo7kpmgEfs64qNxwup+fA+EKMfx8ELO6FCE7KHECsGl+vpBG8vYWI
	 tbupYXS770MVc0nCXXl3DoHvXMWezijKBvBLHmlOcOYWCK/2Q7V8NPfMB+pPmWjF4/Oo9
	 rOiXX1b1OE8cPdQftB+cOWvyq+JcSQ6DbkIZ1+FGdDIBr2QCsxUgpHK0p/x5SA3aVnGvr
	 dV0GWLhRXupsU6KtdVEKCDcYHHE9v7axScJf93IomMXh+WaJJYlrBrOMoZhvypOlrQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=desiato.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=IurXzNvO;
	arc=none smtp.remote-ip=90.155.92.199
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB92606C148;
	Fri, 13 Nov 2026 18:26:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9EB92606C148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=IurXzNvO
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wt/q8P3zBd6hu3TnYFCC/E9Q4utWihMtB20Llr0upI4=; b=IurXzNvOVzHUcQTnti7AZh9iWR
	2PP1E9zBV7zj0qsF2ZP+4FPlAHRv6adPzJmuYKePMPZELglQtVflHlNUVyH45pRep/Nnz3pKM7cJC
	xynxAXqcJ3Mw8dMFpiH817ogl/06FIs+3k7trMuaeqn8dH1MFGrhkqWfepyGFVtgOD+nuVOEf7wNL
	tLg5nMccierJmLRrPIljFS2pkkOPccd3+KeviApcxvzMRIPOMeNPPuvyNBN+lmyL/kK8/TSipAI7s
	uv77YUqE3/BiVqMZ3+tzNXB6mnoDk2nvjrRhZIjDNTVe0jLeBRQeKBnsUgCkIrUx2PUFratgVzwT4
	3h1pmwcQ==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRvyU-0000000BeOa-173F;
	Fri, 13 Nov 2026 18:26:30 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.99.5 #2 (Red Hat Linux))
	id 1xRvyR-00000000LYJ-2o1a;
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
Subject: [RFC PATCH 08/13] KVM: planes: Enlarge every twin's fpstate for dynamic xfeatures
Date: Fri, 13 Nov 2026 11:26:02 -0700
Message-ID: <20261113182607.82813-9-dwmw2@infradead.org>
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

Plane twins share CPUID, so a twin's guest can set the XCR0 bits for a
dynamic xfeature such as AMX's XTILEDATA with its own XSETBV. But
kvm_check_cpuid() calls fpu_enable_guest_xfd_features() only for the
vCPU that KVM_SET_CPUID was issued on, and a twin created afterwards
starts with the default fpstate. A twin that then runs AMX code loses
its tile data on every fpstate save, because the fpstate it saves into
has no room for it. On a host that exposes AMX to the guest, any twin
using AMX hits this.

Whether the XRSTORS on the next entry can also leave a previous
context's tile registers in place for that twin to read is an open
question; it has not been verified.

Enlarge the fpstate of every twin in kvm_check_cpuid(), and give a twin
created after KVM_SET_CPUID the dynamic xfeatures of its plane-0
sibling's fpstate.

Only a twin that has not run may have its fpstate enlarged:
fpstate_realloc() hands a guest fpstate that is not loaded a fresh
image and copies nothing, so a twin that has run would lose its XSAVE
state. kvm_set_cpuid() already accepts only identical CPUID once the
vCPU has run, but it checked only the vCPU the ioctl was issued on.
With plane 0 held while a higher plane runs, KVM_SET_CPUID2 on plane 0
would pass that check and resize the plane that ran. Since the twins
share CPUID, take the identical-CPUID path once any twin has run.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/cpuid.c | 21 +++++++++++++++++++--
 arch/x86/kvm/x86.c   | 17 +++++++++++++++++
 2 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c5fa0551ddd5..971ebd781c6e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -141,7 +141,9 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_find_cpuid_entry2);
 static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
+	struct kvm_vcpu *v;
 	u64 xfeatures;
+	int i, r;
 
 	/*
 	 * The existing code assumes virtual address is 48-bit or 57-bit in the
@@ -168,7 +170,18 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
 	if (!xfeatures)
 		return 0;
 
-	return fpu_enable_guest_xfd_features(&vcpu->arch.guest_fpu, xfeatures);
+	/*
+	 * The planes share CPUID, so any twin's guest can enable these
+	 * xfeatures in its XCR0: enlarge every twin's fpstate, not just
+	 * this vCPU's.
+	 */
+	vcpu_for_each_plane(vcpu->common, i, v) {
+		r = fpu_enable_guest_xfd_features(&v->arch.guest_fpu, xfeatures);
+		if (r)
+			return r;
+	}
+
+	return 0;
 }
 
 static u32 kvm_apply_cpuid_pv_features_quirk(struct kvm_vcpu *vcpu);
@@ -545,8 +558,12 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	 * VMMs (e.g. QEMU) reuse vCPU fds for CPU hotplug/unplug and do
 	 * KVM_SET_CPUID{,2} again. To support this legacy behavior, check
 	 * whether the supplied CPUID data is equal to what's already set.
+	 * Plane twins share CPUID, so this applies once any twin has run.
 	 */
-	if (!kvm_can_set_cpuid_and_feature_msrs(vcpu)) {
+	vcpu_for_each_plane(common, i, v) {
+		if (kvm_can_set_cpuid_and_feature_msrs(v))
+			continue;
+
 		r = kvm_cpuid_check_equal(vcpu, e2, nent);
 		if (r)
 			goto err;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6d3d93e85a65..af28e73e4b9b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9771,6 +9771,23 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.hv_root_tdp = INVALID_PAGE;
 #endif
 
+	/*
+	 * A plane twin created after KVM_SET_CPUID shares CPUID that may
+	 * already allow dynamic xfeatures, which KVM_SET_CPUID enabled only
+	 * in the twins that existed at the time.  Give it the dynamic
+	 * xfeatures of its plane-0 sibling's fpstate.
+	 */
+	if (vcpu->plane_level && vcpu->common->vcpus[0]) {
+		u64 dyn = vcpu->common->vcpus[0]->arch.guest_fpu.fpstate->xfeatures &
+			  XFEATURE_MASK_USER_DYNAMIC;
+
+		if (dyn) {
+			r = fpu_enable_guest_xfd_features(&vcpu->arch.guest_fpu, dyn);
+			if (r)
+				goto free_guest_fpu;
+		}
+	}
+
 	/*
 	 * A plane twin created after KVM_SET_CPUID shares CPUID that may
 	 * already advertise Hyper-V.  Allocate the Hyper-V context now so
-- 
2.50.1

