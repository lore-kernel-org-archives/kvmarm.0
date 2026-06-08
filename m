Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D365C3F4DF0;
	Mon,  8 Jun 2026 14:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929813; cv=none; b=Cf7ke3Z4SmDAB+KqHXinyXA4HrL9V/oPtzkdcnxJdnzM1pTrkkqMnp6eyKEzAVRkcrRLk2zj15qERHgQzYU0o/FtfsSadgSOTvItH3Y5k8mgavlpGQV7c0N4KYlGjG2IzrW1x+LuYnSMDWTpt5wCCQ2IXO75lk4wxi3mOYQem4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929813; c=relaxed/simple;
	bh=Le/G0vQ0/TnbqWe2dBxWLFgIozxJJ/jsvXKWfnBsbj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1Bgx7vR+89Bv4+Ri8SyhYvVKkqrY4BEfaTbrkHWtn+epWi3mcSRUooXNilDApFjKCl4CO8AlmrFmxsjC4Wde5bYxYjyrRZU8b6JKdjOCgnzLvun+wcpyzm9kmCm5i/MBhvaHVzMX0WkuA2ZkKlSR82t3hz/cYzm8OvyxoZKybM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from io.home.8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 3F1722028C9;
	Mon,  8 Jun 2026 16:43:13 +0200 (CEST)
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
Subject: [PATCH 38/60] kvm: Make KVM_SIGNAL_MSI per plane
Date: Mon,  8 Jun 2026 16:42:30 +0200
Message-ID: <20260608144252.351443-39-joro@8bytes.org>
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

Allow the KVM_SIGNAL_MSI ioctl for every plane instead of per VM.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Co-developed-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/kvm_host.h |  2 +-
 virt/kvm/irqchip.c       |  4 ++--
 virt/kvm/kvm_main.c      | 25 ++++++++++++++-----------
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index cfb6911d6771..05a10836d92d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2370,7 +2370,7 @@ static inline int kvm_init_irq_routing(struct kvm *kvm)
 
 #endif
 
-int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi);
+int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi, unsigned plane_level);
 
 void kvm_eventfd_init(struct kvm *kvm);
 int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args);
diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 14480d1df4f9..a4fea7d8dde6 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -45,7 +45,7 @@ int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin)
 	return irq_rt->chip[irqchip][pin];
 }
 
-int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi)
+int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi, unsigned plane_level)
 {
 	struct kvm_kernel_irq_routing_entry route;
 
@@ -57,7 +57,7 @@ int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi)
 	route.msi.data = msi->data;
 	route.msi.flags = msi->flags;
 	route.msi.devid = msi->devid;
-	route.msi.plane_level = 0;
+	route.msi.plane_level = plane_level;
 
 	return kvm_set_msi(&route, kvm, KVM_USERSPACE_IRQ_SOURCE_ID, 1, false);
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a30123b77112..dc59f2f9d405 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4907,6 +4907,17 @@ static long __kvm_plane_ioctl(struct kvm_plane *plane, unsigned int ioctl, unsig
 	case KVM_CREATE_VCPU:
 		r = kvm_plane_ioctl_create_vcpu(plane, arg);
 		break;
+#ifdef CONFIG_HAVE_KVM_MSI
+	case KVM_SIGNAL_MSI: {
+		void __user *argp = (void __user *)arg;
+		struct kvm_msi msi;
+
+		if (copy_from_user(&msi, argp, sizeof(msi)))
+			return -EFAULT;
+		r = kvm_send_userspace_msi(plane->kvm, &msi, plane->level);
+		break;
+	}
+#endif
 	default:
 		r = -ENOTTY;
 	}
@@ -5493,6 +5504,9 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = kvm_vm_ioctl_create_plane(kvm, arg);
 		break;
 	case KVM_CREATE_VCPU:
+#ifdef CONFIG_HAVE_KVM_MSI
+	case KVM_SIGNAL_MSI:
+#endif
 		r = __kvm_plane_ioctl(kvm->planes[0], ioctl, arg);
 		break;
 	case KVM_ENABLE_CAP: {
@@ -5597,17 +5611,6 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = kvm_ioeventfd(kvm, &data);
 		break;
 	}
-#ifdef CONFIG_HAVE_KVM_MSI
-	case KVM_SIGNAL_MSI: {
-		struct kvm_msi msi;
-
-		r = -EFAULT;
-		if (copy_from_user(&msi, argp, sizeof(msi)))
-			goto out;
-		r = kvm_send_userspace_msi(kvm, &msi);
-		break;
-	}
-#endif
 #ifdef __KVM_HAVE_IRQ_LINE
 	case KVM_IRQ_LINE_STATUS:
 	case KVM_IRQ_LINE: {
-- 
2.53.0

