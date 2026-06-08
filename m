Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D32C13D8101;
	Mon,  8 Jun 2026 14:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929807; cv=none; b=jCukn0xO/AkVcRPk39JQG0CZrcfoPGQQp3f0wV2/afhU3U0ag7NZnigjqVQWF11Xzr2zR7KqMv9gGYIN6tj2KLImpj5TNEsebMCxZBtjunkCJ2hm/U3TVJE257sF/Sw+2F54Le0Xh5lr9nQy2h5nW2QyaqOH82C2lDXj6V9DQi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929807; c=relaxed/simple;
	bh=BuxBu1Wtmb8n3LKbbRLqBxdKHkJRVxiYCMrrVO+nF+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/uA91fCR9/wi7knACEh+pKF7OYDsGw8JKdDeCPJEuZwtmtaZQ15FePMUnmLLu/DYEmWJz6Nw/01qn6x2iTXq8QJ+sCyzWLbnbHZb6UE1oWMmPjfc5tfHCrYJMDZDtSVn7xR08Iopu89+H79yd//3sbTXirgbgky01OS13djrBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from io.home.8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 4CB882028C0;
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
Subject: [PATCH 29/60] kvm: Implement KVM_CREATE_PLANE ioctl
Date: Mon,  8 Jun 2026 16:42:21 +0200
Message-ID: <20260608144252.351443-30-joro@8bytes.org>
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

Add a new VM ioctl to create a new plane. It returns a new file
descriptor which supports per-plane ioctls.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Co-developed-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/uapi/linux/kvm.h |  2 ++
 virt/kvm/kvm_main.c      | 75 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 813f964a6dc1..24e34b8e4819 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1355,6 +1355,8 @@ struct kvm_s390_keyop {
 #define KVM_GET_DEVICE_ATTR	  _IOW(KVMIO,  0xe2, struct kvm_device_attr)
 #define KVM_HAS_DEVICE_ATTR	  _IOW(KVMIO,  0xe3, struct kvm_device_attr)
 
+#define KVM_CREATE_PLANE	  _IO(KVMIO, 0xe4)
+
 /*
  * ioctls for vcpu fds
  */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5a0277e2ac7c..03a44ff62f0f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4843,6 +4843,34 @@ static long kvm_vcpu_compat_ioctl(struct file *filp,
 }
 #endif
 
+static long kvm_plane_ioctl(struct file *filp, unsigned int ioctl,
+			    unsigned long arg)
+{
+	struct kvm_plane *plane = filp->private_data;
+
+	if (plane->kvm->mm != current->mm || plane->kvm->vm_dead)
+		return -EIO;
+
+	switch (ioctl) {
+	default:
+		return -ENOTTY;
+	}
+}
+
+static int kvm_plane_release(struct inode *inode, struct file *filp)
+{
+	struct kvm_plane *plane = filp->private_data;
+
+	kvm_put_kvm(plane->kvm);
+	return 0;
+}
+
+static struct file_operations kvm_plane_fops = {
+	.unlocked_ioctl = kvm_plane_ioctl,
+	.release = kvm_plane_release,
+	KVM_COMPAT(kvm_plane_ioctl),
+};
+
 static int kvm_device_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	struct kvm_device *dev = filp->private_data;
@@ -5288,6 +5316,49 @@ static int kvm_vm_ioctl_get_stats_fd(struct kvm *kvm)
 	return fd;
 }
 
+static int kvm_vm_ioctl_create_plane(struct kvm *kvm, unsigned id)
+{
+	struct kvm_plane *plane;
+	struct file *file;
+	int r, fd;
+
+	if (id >= kvm_arch_max_planes(kvm) ||
+	    WARN_ON_ONCE(id >= KVM_MAX_PLANES))
+		return -EINVAL;
+
+	guard(mutex)(&kvm->lock);
+	if (kvm->planes[id])
+		return -EEXIST;
+
+	fd = get_unused_fd_flags(O_CLOEXEC);
+	if (fd < 0)
+		return fd;
+
+	plane = kvm_create_plane(kvm, id);
+	if (!plane) {
+		r = -ENOMEM;
+		goto put_fd;
+	}
+
+	kvm_get_kvm(kvm);
+	file = anon_inode_getfile("kvm-plane", &kvm_plane_fops, plane, O_RDWR);
+	if (IS_ERR(file)) {
+		r = PTR_ERR(file);
+		goto put_kvm;
+	}
+
+	fd_install(fd, file);
+	return fd;
+
+put_kvm:
+	kvm_put_kvm(kvm);
+	kvm_destroy_one_plane(plane);
+put_fd:
+	put_unused_fd(fd);
+	return r;
+}
+
+
 #define SANITY_CHECK_MEM_REGION_FIELD(field)					\
 do {										\
 	BUILD_BUG_ON(offsetof(struct kvm_userspace_memory_region, field) !=		\
@@ -5306,6 +5377,9 @@ static long kvm_vm_ioctl(struct file *filp,
 	if (kvm->mm != current->mm || kvm->vm_dead)
 		return -EIO;
 	switch (ioctl) {
+	case KVM_CREATE_PLANE:
+		r = kvm_vm_ioctl_create_plane(kvm, arg);
+		break;
 	case KVM_CREATE_VCPU:
 		r = kvm_vm_ioctl_create_vcpu(kvm, arg);
 		break;
@@ -6676,6 +6750,7 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	kvm_chardev_ops.owner = module;
 	kvm_vm_fops.owner = module;
 	kvm_vcpu_fops.owner = module;
+	kvm_plane_fops.owner = module;
 	kvm_device_fops.owner = module;
 
 	kvm_preempt_ops.sched_in = kvm_sched_in;
-- 
2.53.0

