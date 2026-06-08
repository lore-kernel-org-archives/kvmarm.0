Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EB983F99FE;
	Mon,  8 Jun 2026 14:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929819; cv=none; b=I608wZt3Um6mGJ0a4zyvMDISYKRU5WjSx1SPIYX4LbiFdkWdO8/2QwZhntZO6fnjWTsScoGkVhoP6YzxunjNI4XNYM7N4BHVfR4uEBitJQ70kcedp2LOq8rsfzBUefKrP1K08IpPoAfuV+OVYYQ9HqJ4CZSPIfYmV2TOFIVTA2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929819; c=relaxed/simple;
	bh=MKg+RoBj2VzO4/fAZX985++Nau/uYMRAk0CphzgoUeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHLvq7gx7lIZuXyR5AK4wUoEmSi9Z3h6CShIHvlvCYOqwV4c8dYQP9GIJczYW80/BXuohXeb2Zp1jkNg60Jg2UrLnzVvuN+xVz4kM/xRm4QY1LV0CI1PVu1RLAEOLpg0r0nvY7UM20bCPS0FFqm5VY2dPT0jklnAxMgNk72gMKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from io.home.8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 6FCF12028D8;
	Mon,  8 Jun 2026 16:43:16 +0200 (CEST)
From: =?UTF-8?q?J=C3=B6rg=20R=C3=B6del?= <joro@8bytes.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
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
	joerg.roedel@amd.com
Subject: [PATCH 53/60] kvm: x86: Introduce max_planes x86-op
Date: Mon,  8 Jun 2026 16:42:45 +0200
Message-ID: <20260608144252.351443-54-joro@8bytes.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260608144252.351443-1-joro@8bytes.org>
References: <20260608144252.351443-1-joro@8bytes.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Paolo Bonzini <pbonzini@redhat.com>

Allow x86 hardware backends to overwrite the number of supported
planes per VM type.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Co-developed-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 1 +
 arch/x86/include/asm/kvm_host.h    | 2 ++
 arch/x86/kvm/svm/svm.c             | 1 +
 arch/x86/kvm/vmx/main.c            | 1 +
 arch/x86/kvm/x86.c                 | 8 +++++++-
 arch/x86/kvm/x86.h                 | 1 +
 6 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 207d56d12459..4f96090c04c9 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -152,6 +152,7 @@ KVM_X86_OP_OPTIONAL_RET0(gmem_max_mapping_level)
 KVM_X86_OP_OPTIONAL(gmem_invalidate)
 KVM_X86_OP(alloc_plane)
 KVM_X86_OP(free_plane)
+KVM_X86_OP(max_planes)
 #endif
 
 #undef KVM_X86_OP
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1b7aa48c961e..bfa0188d372f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2016,6 +2016,8 @@ struct kvm_x86_ops {
 
 	struct kvm_plane *(*alloc_plane)(void);
 	void (*free_plane)(struct kvm_plane *);
+
+	unsigned (*max_planes)(struct kvm *);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2a92d8d18d7c..99357de14034 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5448,6 +5448,7 @@ struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.alloc_plane = x86_alloc_plane,
 	.free_plane = x86_free_plane,
+	.max_planes = kvm_x86_default_max_planes,
 };
 
 /*
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index a2fc4eeeca1d..572921bdfb32 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -1034,6 +1034,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.alloc_plane = x86_alloc_plane,
 	.free_plane = x86_free_plane,
+	.max_planes = kvm_x86_default_max_planes,
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 60b34bd4da9d..c6910356b061 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -482,10 +482,16 @@ static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all_except_vmx) +
 			      (KVM_LAST_EMULATED_VMX_MSR - KVM_FIRST_EMULATED_VMX_MSR + 1)];
 static unsigned int num_msr_based_features;
 
-unsigned kvm_arch_max_planes(struct kvm *kvm)
+unsigned kvm_x86_default_max_planes(struct kvm *kvm)
 {
 	return 1;
 }
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_x86_default_max_planes);
+
+unsigned kvm_arch_max_planes(struct kvm *kvm)
+{
+	return kvm_x86_call(max_planes)(kvm);
+}
 
 struct kvm_plane *x86_alloc_plane(void)
 {
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 812bd6004a4c..ff57ba568031 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -800,5 +800,6 @@ static inline bool kvm_is_valid_u_s_cet(struct kvm_vcpu *vcpu, u64 data)
 
 struct kvm_plane *x86_alloc_plane(void);
 void x86_free_plane(struct kvm_plane *plane);
+unsigned kvm_x86_default_max_planes(struct kvm *kvm);
 
 #endif
-- 
2.53.0

