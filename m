Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DB363F44D6;
	Mon,  8 Jun 2026 14:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929810; cv=none; b=pjSSA51Q/lgJ3/ITn/OJu5jlyY6B3gmSSgUYkJJEndFCF0c2AROV4TveV8eYr4jiovqcLDxZMFXFkQk4LnU7Ix/l7FMm4tF1IPe6kSaIlR+xZZvNLFjimeh8bCmolUMh34TMw29YcDXi+ZCXm8/RJ+cUoljUeRVwtYk51KdEty4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929810; c=relaxed/simple;
	bh=Kx6usmQZyoTepTASnVWuTPJCepDAX1PROg4KuGNUQGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZIDmKLtqqOJtlmnMTI8+3NDD0+UcZ+i+qXkIZUGkaN6YdDwoc9d5sYRcbgBt6JDQcQuec5Z0kZeGdQUsF/1GgZAm+to1UN4C4dFm1Iyfv5GsRKzILUzC8np2IRNXCsUSjiZJtEzSd/TDXdQujdodnyOxuDOe+ydkSV5VqnAqf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from io.home.8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id B53292028C2;
	Mon,  8 Jun 2026 16:43:11 +0200 (CEST)
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
Subject: [PATCH 31/60] kvm: Allocate struct kvm_plane in architecture code
Date: Mon,  8 Jun 2026 16:42:23 +0200
Message-ID: <20260608144252.351443-32-joro@8bytes.org>
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

Move plane allocation to architecture code so that per-arch
implementations can embed the structure into another one for keeping
additional data.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/arm64/kvm/arm.c       | 13 +++++++++++++
 arch/loongarch/kvm/vm.c    | 13 +++++++++++++
 arch/mips/kvm/mips.c       | 13 +++++++++++++
 arch/powerpc/kvm/powerpc.c | 13 +++++++++++++
 arch/riscv/kvm/main.c      | 13 +++++++++++++
 arch/s390/kvm/kvm-s390.c   | 13 +++++++++++++
 arch/x86/kvm/x86.c         | 13 +++++++++++++
 include/linux/kvm_host.h   |  2 ++
 virt/kvm/kvm_main.c        |  6 +++---
 9 files changed, 96 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7e6d2773fd39..d7a4b9b239dc 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -205,6 +205,19 @@ unsigned kvm_arch_max_planes(struct kvm *kvm)
 	return 1;
 }
 
+struct kvm_plane *kvm_alloc_plane(void)
+{
+	/* For better type checking, do not return kzalloc() value directly */
+	struct kvm_plane *plane = kzalloc(sizeof(*plane), GFP_KERNEL_ACCOUNT);
+
+	return plane;
+}
+
+void kvm_free_plane(struct kvm_plane *plane)
+{
+	kfree(plane);
+}
+
 /**
  * kvm_arch_init_vm - initializes a VM data structure
  * @kvm:	pointer to the KVM struct
diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
index 14f1232c6e0c..e4d2814b717d 100644
--- a/arch/loongarch/kvm/vm.c
+++ b/arch/loongarch/kvm/vm.c
@@ -114,6 +114,19 @@ unsigned kvm_arch_max_planes(struct kvm *kvm)
 	return 1;
 }
 
+struct kvm_plane *kvm_alloc_plane(void)
+{
+	/* For better type checking, do not return kzalloc() value directly */
+	struct kvm_plane *plane = kzalloc(sizeof(*plane), GFP_KERNEL_ACCOUNT);
+
+	return plane;
+}
+
+void kvm_free_plane(struct kvm_plane *plane)
+{
+	kfree(plane);
+}
+
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	int r;
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 60870452119d..e22d2a267e03 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -120,6 +120,19 @@ unsigned kvm_arch_max_planes(struct kvm *kvm)
 	return 1;
 }
 
+struct kvm_plane *kvm_alloc_plane(void)
+{
+	/* For better type checking, do not return kzalloc() value directly */
+	struct kvm_plane *plane = kzalloc(sizeof(*plane), GFP_KERNEL_ACCOUNT);
+
+	return plane;
+}
+
+void kvm_free_plane(struct kvm_plane *plane)
+{
+	kfree(plane);
+}
+
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 {
 	return false;
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index cfa40be20e00..35658cded0cb 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -504,6 +504,19 @@ unsigned kvm_arch_max_planes(struct kvm *kvm)
 	return 1;
 }
 
+struct kvm_plane *kvm_alloc_plane(void)
+{
+	/* For better type checking, do not return kzalloc() value directly */
+	struct kvm_plane *plane = kzalloc(sizeof(*plane), GFP_KERNEL_ACCOUNT);
+
+	return plane;
+}
+
+void kvm_free_plane(struct kvm_plane *plane)
+{
+	kfree(plane);
+}
+
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	int r;
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index 5adba3a455a3..46834b2ddfae 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -22,6 +22,19 @@ unsigned kvm_arch_max_planes(struct kvm *kvm)
 	return 1;
 }
 
+struct kvm_plane *kvm_alloc_plane(void)
+{
+	/* For better type checking, do not return kzalloc() value directly */
+	struct kvm_plane *plane = kzalloc(sizeof(*plane), GFP_KERNEL_ACCOUNT);
+
+	return plane;
+}
+
+void kvm_free_plane(struct kvm_plane *plane)
+{
+	kfree(plane);
+}
+
 static void kvm_riscv_setup_vendor_features(void)
 {
 	/* Andes AX66: split two-stage TLBs */
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 24f24ea95f86..94c40b2aa759 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3191,6 +3191,19 @@ unsigned kvm_arch_max_planes(struct kvm *kvm)
 	return 1;
 }
 
+struct kvm_plane *kvm_alloc_plane(void)
+{
+	/* For better type checking, do not return kzalloc() value directly */
+	struct kvm_plane *plane = kzalloc(sizeof(*plane), GFP_KERNEL_ACCOUNT);
+
+	return plane;
+}
+
+void kvm_free_plane(struct kvm_plane *plane)
+{
+	kfree(plane);
+}
+
 void kvm_arch_free_vm(struct kvm *kvm)
 {
 	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 25299c8c28e3..d6bf0425525c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -487,6 +487,19 @@ unsigned kvm_arch_max_planes(struct kvm *kvm)
 	return 1;
 }
 
+struct kvm_plane *kvm_alloc_plane(void)
+{
+	/* For better type checking, do not return kzalloc() value directly */
+	struct kvm_plane *plane = kzalloc(sizeof(*plane), GFP_KERNEL_ACCOUNT);
+
+	return plane;
+}
+
+void kvm_free_plane(struct kvm_plane *plane)
+{
+	kfree(plane);
+}
+
 /*
  * All feature MSRs except uCode revID, which tracks the currently loaded uCode
  * patch, are immutable once the vCPU model is defined.
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 90b97137840e..55e3e9046975 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1157,6 +1157,8 @@ void vcpu_load(struct kvm_vcpu *vcpu);
 void vcpu_put(struct kvm_vcpu *vcpu);
 
 unsigned kvm_arch_max_planes(struct kvm *kvm);
+struct kvm_plane *kvm_alloc_plane(void);
+void kvm_free_plane(struct kvm_plane *plane);
 
 #ifdef CONFIG_KVM_IOAPIC
 void kvm_arch_post_irq_ack_notifier_list_update(struct kvm *kvm);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f0f78bb74e51..4f2c8f46a0d3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1209,7 +1209,7 @@ static void kvm_disable_virtualization(void);
 
 static struct kvm_plane *kvm_create_plane(struct kvm *kvm, unsigned plane_level)
 {
-	struct kvm_plane *plane = kzalloc(sizeof(*plane), GFP_KERNEL_ACCOUNT);
+	struct kvm_plane *plane = kvm_alloc_plane();
 
 	if (!plane)
 		return NULL;
@@ -1227,7 +1227,7 @@ static struct kvm_plane *kvm_create_plane(struct kvm *kvm, unsigned plane_level)
 	return plane;
 
 out_free_plane:
-	kfree(plane);
+	kvm_free_plane(plane);
 
 	return NULL;
 }
@@ -1235,7 +1235,7 @@ static struct kvm_plane *kvm_create_plane(struct kvm *kvm, unsigned plane_level)
 static void kvm_destroy_one_plane(struct kvm_plane *plane)
 {
 	kvm_arch_plane_destroy(plane);
-	kfree(plane);
+	kvm_free_plane(plane);
 }
 
 static void kvm_destroy_planes(struct kvm *kvm)
-- 
2.53.0

