Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DFA53D8101;
	Mon,  8 Jun 2026 14:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929800; cv=none; b=GJmw2PuBDf7SrQ52dTqtQhgCTTHEgwpHc6i4y30kwleg4pu3whJJu5iweYwyIPszmF8npPEbFOj/wBZfzJJ/SyKJxyB1ZqM18rbL9XbuZx1BOPtAvEG6uYUwVZYi/olwDy//LMlSD6rh4BkqT5hNyvRfsaRU1eXklhwvdqziG58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929800; c=relaxed/simple;
	bh=+5Evc1x7QVKNEwtVOLev8X9y7+x3L2POXsXegsnZGp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tc7a0Hfz18UeT/pKg1EpAk/Nn7gr59dQ4E6M+56Ovh65gP9fkgKqhuk+5q9kNSNgbvgKt6bzG4/g4TXWpPxDc2dc9407FcRz5uuqZwQTCmkw9v/2SICRalBcof8BjarLJdW1A15ssA4eaqXvC4cOP9DuVBdXhovsZTkuwYjbkqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from io.home.8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id E5A762028AC;
	Mon,  8 Jun 2026 16:43:06 +0200 (CEST)
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
Subject: [PATCH 09/60] kvm: Introduce struct kvm_plane
Date: Mon,  8 Jun 2026 16:42:01 +0200
Message-ID: <20260608144252.351443-10-joro@8bytes.org>
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

Introduce a data structure to keep VM-wide per-plane state. Initialize
the structure with a back-pointer to struct kvm and the plane level
the structure represents.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Co-developed-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/kvm_host.h |  7 +++++++
 include/uapi/linux/kvm.h |  6 ++++++
 virt/kvm/kvm_main.c      | 41 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4c14aee1fb06..5be4c9f118b4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -767,6 +767,11 @@ struct kvm_memslots {
 	int node_idx;
 };
 
+struct kvm_plane {
+	struct kvm *kvm;
+	unsigned level;
+};
+
 struct kvm {
 #ifdef KVM_HAVE_MMU_RWLOCK
 	rwlock_t mmu_lock;
@@ -806,6 +811,8 @@ struct kvm {
 	spinlock_t gpc_lock;
 	struct list_head gpc_list;
 
+	struct kvm_plane *planes[KVM_MAX_PLANES];
+
 	/*
 	 * created_vcpus is protected by kvm->lock, and is incremented
 	 * at the beginning of KVM_CREATE_VCPU.  online_vcpus is only
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6c8afa2047bf..813f964a6dc1 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -730,6 +730,11 @@ struct kvm_enable_cap {
 #define KVM_GET_EMULATED_CPUID	  _IOWR(KVMIO, 0x09, struct kvm_cpuid2)
 #define KVM_GET_MSR_FEATURE_INDEX_LIST    _IOWR(KVMIO, 0x0a, struct kvm_msr_list)
 
+/*
+ * Maximum number of supported planes
+ */
+#define KVM_MAX_PLANES	16
+
 /*
  * Extension capability list.
  */
@@ -996,6 +1001,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_S390_USER_OPEREXEC 246
 #define KVM_CAP_S390_KEYOP 247
 #define KVM_CAP_S390_VSIE_ESAMODE 248
+#define KVM_CAP_PLANES 249
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 881f92d7a469..a68469c6d12e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1095,6 +1095,38 @@ static inline struct kvm_io_bus *kvm_get_bus_for_destruction(struct kvm *kvm,
 static int kvm_enable_virtualization(void);
 static void kvm_disable_virtualization(void);
 
+static struct kvm_plane *kvm_create_plane(struct kvm *kvm, unsigned plane_level)
+{
+	struct kvm_plane *plane = kzalloc(sizeof(*plane), GFP_KERNEL_ACCOUNT);
+
+	if (!plane)
+		return NULL;
+
+	plane->kvm = kvm;
+	plane->level = plane_level;
+
+	kvm->planes[plane_level] = plane;
+
+	return plane;
+}
+
+static void kvm_destroy_one_plane(struct kvm_plane *plane)
+{
+	kfree(plane);
+}
+
+static void kvm_destroy_planes(struct kvm *kvm)
+{
+	int i;
+
+	for (i = 0; i < KVM_MAX_PLANES; ++i) {
+		if (kvm->planes[i] == NULL)
+			continue;
+		kvm_destroy_one_plane(kvm->planes[i]);
+		kvm->planes[i] = NULL;
+	}
+}
+
 static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 {
 	struct kvm *kvm = kvm_arch_alloc_vm();
@@ -1127,6 +1159,12 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 
 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
 
+	/* Initialize planes array and allocate plane 0 */
+	if (kvm_create_plane(kvm, 0) == NULL) {
+		r = -ENOMEM;
+		goto out_no_planes;
+	}
+
 	/*
 	 * Force subsequent debugfs file creations to fail if the VM directory
 	 * is not created (by kvm_create_vm_debugfs()).
@@ -1225,6 +1263,8 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 out_err_no_irq_srcu:
 	cleanup_srcu_struct(&kvm->srcu);
 out_err_no_srcu:
+	kvm_destroy_planes(kvm);
+out_no_planes:
 	kvm_arch_free_vm(kvm);
 	mmdrop(current->mm);
 	return ERR_PTR(r);
@@ -1304,6 +1344,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	xa_destroy(&kvm->mem_attr_array);
 #endif
 	kvm_arch_free_vm(kvm);
+	kvm_destroy_planes(kvm);
 	preempt_notifier_dec();
 	kvm_disable_virtualization();
 	mmdrop(mm);
-- 
2.53.0

