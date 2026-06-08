Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00E073F888A;
	Mon,  8 Jun 2026 14:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929814; cv=none; b=AKHCkSZ5RzRmL96xGCVfMh4HhVke22n66CipY+7v1uC+2XFd1eo1lgLY0q9iY9h+TjrdL6poV2hJeGEKkbFj+xTGFtCNOMPxNBSLiQVvdwhkz+5YB6154UrbAjKwV827zJdeXotkkpHs7A2kfO9jDsQSaJm2MKaOfYl1vg+CaXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929814; c=relaxed/simple;
	bh=BvjNCxnN228MSt40dnG4giObj3PBnoIC1IoQ5WyhYzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dLTZ9jB9vQYvkqydyMudyZ6T0+9o/CR02LS1USg0eRhG2ibpyJME01xIkyZ3wfOJEQ9MKuOkGl1/+pUTz9Epjyrp05e5MChdOMpz9yjfuVr8tGbDjWyX9JciS2GMqkZ+MrDYKy/DUcwXPXaYKQKY2X3U4egoBLaEYu1ITxcmsnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from io.home.8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 94CCC2028D4;
	Mon,  8 Jun 2026 16:43:15 +0200 (CEST)
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
Subject: [PATCH 49/60] kvm: x86: Allow hardware backend to overwrite struct kvm_plane allocation
Date: Mon,  8 Jun 2026 16:42:41 +0200
Message-ID: <20260608144252.351443-50-joro@8bytes.org>
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

From: Joerg Roedel <joerg.roedel@amd.com>

Allow the hardware backend implementations to allocate the struct
kvm_plane instances so that they can carry hardware specific
information along them.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 ++
 arch/x86/include/asm/kvm_host.h    |  3 +++
 arch/x86/kvm/svm/svm.c             |  3 +++
 arch/x86/kvm/vmx/main.c            |  5 ++++-
 arch/x86/kvm/x86.c                 | 16 ++++++++++++++--
 arch/x86/kvm/x86.h                 |  4 ++++
 6 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index c8bff1e9325e..207d56d12459 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -150,6 +150,8 @@ KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
 KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
 KVM_X86_OP_OPTIONAL_RET0(gmem_max_mapping_level)
 KVM_X86_OP_OPTIONAL(gmem_invalidate)
+KVM_X86_OP(alloc_plane)
+KVM_X86_OP(free_plane)
 #endif
 
 #undef KVM_X86_OP
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c2651774d785..0955097aca9c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2011,6 +2011,9 @@ struct kvm_x86_ops {
 	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
 	int (*gmem_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn, bool is_private);
+
+	struct kvm_plane *(*alloc_plane)(void);
+	void (*free_plane)(struct kvm_plane *);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0b57dde29e40..2a92d8d18d7c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5445,6 +5445,9 @@ struct kvm_x86_ops svm_x86_ops __initdata = {
 	.gmem_prepare = sev_gmem_prepare,
 	.gmem_invalidate = sev_gmem_invalidate,
 	.gmem_max_mapping_level = sev_gmem_max_mapping_level,
+
+	.alloc_plane = x86_alloc_plane,
+	.free_plane = x86_free_plane,
 };
 
 /*
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index f9c4703dda54..a2fc4eeeca1d 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -1030,7 +1030,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.vcpu_mem_enc_ioctl = vt_op_tdx_only(vcpu_mem_enc_ioctl),
 	.vcpu_mem_enc_unlocked_ioctl = vt_op_tdx_only(vcpu_mem_enc_unlocked_ioctl),
 
-	.gmem_max_mapping_level = vt_op_tdx_only(gmem_max_mapping_level)
+	.gmem_max_mapping_level = vt_op_tdx_only(gmem_max_mapping_level),
+
+	.alloc_plane = x86_alloc_plane,
+	.free_plane = x86_free_plane,
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b9828cd31136..5f48392d4738 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -487,18 +487,30 @@ unsigned kvm_arch_max_planes(struct kvm *kvm)
 	return 1;
 }
 
-struct kvm_plane *kvm_alloc_plane(void)
+struct kvm_plane *x86_alloc_plane(void)
 {
 	/* For better type checking, do not return kzalloc() value directly */
 	struct kvm_plane *plane = kzalloc(sizeof(*plane), GFP_KERNEL_ACCOUNT);
 
 	return plane;
 }
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(x86_alloc_plane);
 
-void kvm_free_plane(struct kvm_plane *plane)
+void x86_free_plane(struct kvm_plane *plane)
 {
 	kfree(plane);
 }
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(x86_free_plane);
+
+struct kvm_plane *kvm_alloc_plane(void)
+{
+	return kvm_x86_call(alloc_plane)();
+}
+
+void kvm_free_plane(struct kvm_plane *plane)
+{
+	kvm_x86_call(free_plane)(plane);
+}
 
 /*
  * All feature MSRs except uCode revID, which tracks the currently loaded uCode
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 38a905fa86de..812bd6004a4c 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -797,4 +797,8 @@ static inline bool kvm_is_valid_u_s_cet(struct kvm_vcpu *vcpu, u64 data)
 
 	return true;
 }
+
+struct kvm_plane *x86_alloc_plane(void);
+void x86_free_plane(struct kvm_plane *plane);
+
 #endif
-- 
2.53.0

