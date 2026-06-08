Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D59843F44EA;
	Mon,  8 Jun 2026 14:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929808; cv=none; b=KtTN/dWxfo1E28kdxORyEG8qsnryklwMnWsynuf7RhEIKoK8ErH+iL/fWJVOBKZ+E5AR2zkwTPkmBf1OrKMfvGLLw5IpMa9ZzAAAfHENt1gXn5nHswGu8SNP5b8oO6slax2aC4+jY+Gzr1NObPBhYEOoGJVCn7Y2lGmWHb6OdQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929808; c=relaxed/simple;
	bh=eWpTCoZzUyM8LplF8Me7jkuNhwXVhyNCQZN7fpSl38I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rDkqGJ26ELUq6Uy7kWtfYm5bz0sOwWl0s2JLUrXIBwL5cjwXStrIRnyhDl7kGgh/VsL97Ns1+8XxVFe03K0VWnJTsLWNvHfB/YDEtB2bXXfA7uAj/x3wYKB/F/5/+9zL1iK3bzFmlA9lyfnpBviS/wr/lHOZekujqnk5YrOcA9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from io.home.8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 9229F2028C6;
	Mon,  8 Jun 2026 16:43:12 +0200 (CEST)
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
Subject: [PATCH 35/60] kvm: Add VCPU plane-scheduling state and helpers
Date: Mon,  8 Jun 2026 16:42:27 +0200
Message-ID: <20260608144252.351443-36-joro@8bytes.org>
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

The algorithm is to always run the lowest runnable plane. Plane
switches are done by stopping the current plane and setting another
runnable.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/kvm_host.h | 16 ++++++++++++++
 virt/kvm/kvm_main.c      | 45 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5c3f9dfa15ea..e3611e6cc3e4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -168,6 +168,7 @@ static inline bool kvm_is_error_gpa(gpa_t gpa)
 #define KVM_REQ_VM_DEAD			(1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_UNBLOCK			2
 #define KVM_REQ_DIRTY_RING_SOFT_FULL	3
+#define KVM_REQ_PLANE_RESCHED		4
 #define KVM_REQUEST_ARCH_BASE		8
 
 /*
@@ -324,6 +325,8 @@ struct kvm_mmio_fragment {
 	unsigned int len;
 };
 
+
+
 struct kvm_vcpu_common {
 	struct kvm *kvm;
 
@@ -381,6 +384,8 @@ struct kvm_vcpu_common {
 
 	struct kvm_dirty_ring dirty_ring;
 
+	bool plane_switch;
+
 	struct kvm_vcpu_arch_common arch;
 };
 
@@ -388,6 +393,12 @@ struct kvm_vcpu_common {
 	for ((i) = 0; (i) < KVM_MAX_PLANES; ++(i))		\
 		if (((v) = common->vcpus[(i)]) != NULL)
 
+/* Tracked per plane-VCPU - used for deciding which plane-vcpu to run */
+enum kvm_vcpu_state {
+	STOPPED,
+	RUNNABLE,
+};
+
 struct kvm_vcpu {
 	struct kvm *kvm;
 	struct kvm_plane *plane;
@@ -401,6 +412,7 @@ struct kvm_vcpu {
 	struct kvm_run *run;
 
 	u64 plane_requests;
+	enum kvm_vcpu_state plane_state;
 
 	/* S390 only */
 	bool valid_wakeup;
@@ -440,6 +452,10 @@ struct kvm_vcpu {
 	unsigned plane_level;
 };
 
+void kvm_vcpu_set_plane_runnable(struct kvm_vcpu *vcpu);
+void kvm_vcpu_set_plane_stopped(struct kvm_vcpu *vcpu);
+struct kvm_vcpu *kvm_vcpu_select_plane(struct kvm_vcpu *vcpu);
+
 static inline bool kvm_vcpu_wants_to_run(struct kvm_vcpu *vcpu)
 {
 	return vcpu->common->wants_to_run;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9d30fd85ce5f..a30123b77112 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4397,6 +4397,7 @@ static int kvm_plane_ioctl_create_vcpu(struct kvm_plane *plane, unsigned long id
 	vcpu->vcpu_idx = vcpu->common->vcpu_idx;
 	vcpu->plane = plane;
 	vcpu->plane_level = plane->level;
+	vcpu->plane_state = STOPPED;
 	vcpu->run = vcpu->common->run;
 
 	kvm_vcpu_init(vcpu, kvm, id);
@@ -4938,6 +4939,50 @@ static struct file_operations kvm_plane_fops = {
 	KVM_COMPAT(kvm_plane_ioctl),
 };
 
+void kvm_vcpu_set_plane_runnable(struct kvm_vcpu *vcpu)
+{
+	vcpu->plane_state = RUNNABLE;
+	vcpu->common->plane_switch = true;
+	kvm_make_request(KVM_REQ_PLANE_RESCHED, vcpu);
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_set_plane_runnable);
+
+void kvm_vcpu_set_plane_stopped(struct kvm_vcpu *vcpu)
+{
+	vcpu->plane_state = STOPPED;
+	kvm_make_request(KVM_REQ_PLANE_RESCHED, vcpu);
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_set_plane_stopped);
+
+struct kvm_vcpu *kvm_vcpu_select_plane(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_common *common = vcpu->common;
+	struct kvm_vcpu *ret = NULL;
+	unsigned i;
+
+	for (i = 0; i < KVM_MAX_PLANES; i++) {
+		if (common->vcpus[i] == NULL)
+			continue;
+
+		if (common->vcpus[i]->plane_state == RUNNABLE) {
+			ret = common->vcpus[i];
+			break;
+		}
+	}
+
+	if (ret == NULL) {
+		ret = common->vcpus[0];
+		ret->plane_state = RUNNABLE;
+	}
+
+	common->current_vcpu = ret;
+
+	common->plane_switch = false;
+
+	return ret;
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_select_plane);
+
 static int kvm_device_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	struct kvm_device *dev = filp->private_data;
-- 
2.53.0

