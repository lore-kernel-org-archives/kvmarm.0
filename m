Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794594372;
	b=TiLb2VDelbbuQbjpvU+8LKpE1WpPuNnSPjl7+0RWhebXc7KOFcD2/r1CwC+76SzPqaer
	 mtjPzaRP2FjPLiLPru3hIouAuL5VoLsNyBJj3D2TfPuST3Af2+Oq+oQ8sNq+aPaKaeOoM
	 kzo/eEpf44FJgxoTNlrleuczpVUpJcQjM3s6f1I7AZMJo1vhRfEO9WdLrl08HsptlnaV6
	 9acDaDfAFRlVZ6DhPuOdV9gKd58cATTwxn5F5T51VcyTWL7LhybPMxBiR2ErcRigRckdR
	 +StL7YiGTSsQuNt2Sc0pZv6o+F6rPmfVYLDFZ+A4ROwrjF5HKCDUUsTam6XAMPnZh6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794594372;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Sender:X-SRS-Rewrite;
	bh=3knGUwEX3LR/PwBuS8cYZDYxWXd5qe0dWzFQ3S99SZs=;
	b=qejTI+fCqK/kGi3yiDhOrt6yxKWni1BKSi9UGcbzH0fJ2j9UlrQDKoujVM+244Zb7IuJ
	 rNkqiwgYOKU+k0LTdIhbjGjmkDfX+lva0quOLRkbjt78DxP+7Ec0iyktzDd62hDxhDvgU
	 Nfc32BxJ+5dpOEfJdt61zgZ/vJnvEtGUC6Z7pYgStjlCx04VOhJR1oaSXdH8HfmGCLdDC
	 1uYFDf2F8cgwv11sW4nYl7ODHxfpmI1q42313h5lt1GQ6hiDfSsVJsSd9cjudpZaFVMhN
	 EqskwHVutl3NLSsmlPGrlUNuI+SklRSJrOR+MbgHqDiyfMbaq9/rnxbjUrZUtPSuO7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=casper.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=oxtqnu7y;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5FE606A334;
	Fri, 13 Nov 2026 18:26:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D5FE606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=oxtqnu7y
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3knGUwEX3LR/PwBuS8cYZDYxWXd5qe0dWzFQ3S99SZs=; b=oxtqnu7yOfVjjijBSQNv6hFkAT
	7rrf4C0IFfgpDJHNae3KAaOYtDlGhhNFvPZU2XMyUH8q9ZgayQiIx5CUPtgh3qKPmvkznd5baell4
	qT+nJLyntHk9jV723rPFRcZfvzas034jOQBPBiUCLpjjjk/eyQzeHqFCh6+Yg+ct4FZA7lVHTaTOW
	RgtSjD2ZNno3pTU8PAE6z7ZxMEAff7eFttgHQGG5tFvUWCa0Lk/NHsbfHE0mZ11lDeDs0MnyozGS8
	Ef1g2IAtTO8xtRJ2DCaeW/ucr+aaT7BEB+6hAAfjOGKwCCaEDO3TfXO+zWWbEmffSMa2YbnxgZpv9
	frzIfiMA==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRvyR-00000004cT3-3mmx;
	Fri, 13 Nov 2026 18:26:08 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.99.5 #2 (Red Hat Linux))
	id 1xRvyR-00000000LYN-2yMj;
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
Subject: [RFC PATCH 09/13] KVM: x86: Let userspace choose state for plane twins to share
Date: Fri, 13 Nov 2026 11:26:03 -0700
Message-ID: <20261113182607.82813-10-dwmw2@infradead.org>
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

Which per-vCPU state the planes of a vCPU share is policy for the VMM.
Hyper-V VSM shares XCR0 between VTLs, and whether it shares DR6 depends
on the processor, as HvRegisterVsmCapabilities.Dr6Shared reports; a VMM
with a different privilege model may want neither. So far the only knob
is the plane count, which leaves nothing to key such sharing on but the
opt-in itself.

Take a mask of state to share in args[1] of KVM_ENABLE_CAP(KVM_CAP_PLANES),
set once together with the count. Unknown bits, and a non-zero args[2]
or args[3], fail with -EINVAL. A new KVM_CAP_PLANES_SHARE reports the
supported bits on the system fd and the enabled bits on a VM fd, as
KVM_CAP_PLANES reports the ceiling and the live count. No bits are
defined yet; the following patches add XCR0 and DR6.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 Documentation/virt/kvm/api.rst  | 12 +++++++++++-
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              |  8 ++++++++
 arch/x86/kvm/x86.h              | 11 +++++++++++
 include/uapi/linux/kvm.h        |  1 +
 5 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 4196f3fc5718..a6008cb33e99 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -9316,7 +9316,8 @@ hpage_2g module parameter is not set to 1, -EINVAL is returned.
 
 :Architectures: x86
 :Target: VM
-:Parameters: args[0] contains the number of planes to make available
+:Parameters: args[0] contains the number of planes to make available,
+             args[1] a mask of state that the planes of a vCPU share
 
 Opts the VM in to using multiple planes, raising the limit on plane ids
 that KVM_CREATE_PLANE accepts to args[0], which must be between 1 and the
@@ -9339,6 +9340,15 @@ This capability must be enabled before any vCPU or extra plane has been
 created, and the chosen count cannot be changed afterwards; otherwise
 -EEXIST is returned.
 
+Each plane of a vCPU normally keeps its own copy of the vCPU's register
+state, apart from the CPUID model, which the planes always share.  args[1]
+selects state that the planes of a vCPU share instead, so that a write
+through one plane is seen by all of them.  KVM_CHECK_EXTENSION
+(KVM_CAP_PLANES_SHARE) returns the bits KVM supports on the system fd, and
+the bits the VM enabled on a VM fd.  Setting an unsupported bit, or a
+non-zero args[2] or args[3], fails with -EINVAL.  Like the count, the mask
+is set once.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 596be8ad7154..99a671ac2386 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1195,6 +1195,7 @@ struct kvm_arch {
 	bool has_protected_eoi;
 	bool has_protected_pmu;
 	bool pre_fault_allowed;
+	u8 plane_share;
 	unsigned int user_max_planes;
 	struct hlist_head *mmu_page_hash;
 	struct list_head active_mmu_pages;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index af28e73e4b9b..4d70e111eeb0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2460,6 +2460,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VM_TSC_CONTROL:
 		r = kvm_caps.has_tsc_control;
 		break;
+	case KVM_CAP_PLANES_SHARE:
+		r = kvm ? READ_ONCE(kvm->arch.plane_share) : KVM_PLANE_SHARE_VALID;
+		break;
 	case KVM_CAP_X2APIC_API:
 		r = KVM_X2APIC_API_VALID_FLAGS;
 		if (kvm && !irqchip_split(kvm))
@@ -4174,6 +4177,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		r = -EINVAL;
 		if (cap->args[0] < 1 || cap->args[0] > KVM_MAX_USER_PLANES)
 			goto planes_unlock;
+		if (cap->args[1] & ~KVM_PLANE_SHARE_VALID)
+			goto planes_unlock;
+		if (cap->args[2] || cap->args[3])
+			goto planes_unlock;
 		/* Planes are only supported with a split irqchip. */
 		if (!irqchip_split(kvm))
 			goto planes_unlock;
@@ -4195,6 +4202,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		if (kvm->created_vcpus || kvm->has_planes ||
 		    kvm->arch.user_max_planes)
 			goto planes_unlock;
+		WRITE_ONCE(kvm->arch.plane_share, cap->args[1]);
 		WRITE_ONCE(kvm->arch.user_max_planes, cap->args[0]);
 		r = 0;
 planes_unlock:
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index fb87ceaa9563..2f51b476dbd1 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -923,4 +923,15 @@ struct kvm_plane *x86_alloc_plane(void);
 void x86_free_plane(struct kvm_plane *plane);
 unsigned kvm_x86_default_max_planes(struct kvm *kvm);
 
+/*
+ * The per-vCPU state that userspace may ask the planes of a vCPU to share,
+ * in args[1] of KVM_ENABLE_CAP(KVM_CAP_PLANES).
+ */
+#define KVM_PLANE_SHARE_VALID	0
+
+static inline bool kvm_plane_shares(struct kvm *kvm, u64 state)
+{
+	return READ_ONCE(kvm->arch.plane_share) & state;
+}
+
 #endif
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index abf023ed78c4..aef86ef3976f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1017,6 +1017,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_PMU_V3_STRICT 251
 #define KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES 252
 #define KVM_CAP_PLANES 254
+#define KVM_CAP_PLANES_SHARE 256
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.50.1

