Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B21563F1AAC;
	Mon,  8 Jun 2026 14:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929820; cv=none; b=fDflVLG+cD2LdpvPSG5ac9Y0BELjrTz8RkDgoehU5Q7gDrBwukFSXEG8phXBLsipor6+5V8+LApNWZRHkCHjzMdRB5kRqAXzrLBsiHR/yq6GEVJSanVd905Hi6uT9EHYCzK6Bn572WFLZnM8K9Oh4bLMPsz/hJLivloCBOfabnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929820; c=relaxed/simple;
	bh=mbWm+HGdaEQiUN4G1XXeJLYotq+qlL1X3dQave7Qpdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aF7emFkr0pACKLhlND0iJONCNO8ATCOoSFyQVcpCCRCpIGCEaYWKBv99DC/PWdoJ7DZsNKvK/0q9C+29FldTVox576uTRck03GCDMQe4G36oLqixAgROUNo7ZDf/90K93wj0NTrrR93AEp/pJH0+DYTlvRvTpiIg/aIYGQPkOFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from io.home.8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id A4CBA2028D9;
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
Subject: [PATCH 54/60] kvm: x86: Restrict KVM planes support to KVM_IRQCHIP_SPLIT
Date: Mon,  8 Jun 2026 16:42:46 +0200
Message-ID: <20260608144252.351443-55-joro@8bytes.org>
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

The code right now only supports plane-aware IOAPIC IRQ routing for
IRQ-chip in split mode. Enforce that restriction in the KVM x86 code.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/x86.c       | 8 ++++++--
 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 5 +++++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c6910356b061..0b9fa1059481 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -490,6 +490,10 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_x86_default_max_planes);
 
 unsigned kvm_arch_max_planes(struct kvm *kvm)
 {
+	/* For now, planes are only supported with irqchip=split */
+	if (!irqchip_split(kvm))
+		return 1;
+
 	return kvm_x86_call(max_planes)(kvm);
 }
 
@@ -6833,7 +6837,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		if (cap->args[0] > KVM_MAX_IRQ_ROUTES)
 			goto split_irqchip_unlock;
 		r = -EEXIST;
-		if (irqchip_in_kernel(kvm))
+		if (irqchip_in_kernel(kvm) || kvm->has_planes)
 			goto split_irqchip_unlock;
 		if (kvm->created_vcpus)
 			goto split_irqchip_unlock;
@@ -7398,7 +7402,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 			goto create_irqchip_unlock;
 
 		r = -EINVAL;
-		if (kvm->created_vcpus)
+		if (kvm->created_vcpus || kvm->has_planes)
 			goto create_irqchip_unlock;
 
 		r = kvm_pic_init(kvm);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3b62fb354267..dbf81e2520f2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -918,6 +918,7 @@ struct kvm {
 	struct list_head gpc_list;
 
 	struct kvm_plane *planes[KVM_MAX_PLANES];
+	bool has_planes;
 
 	/*
 	 * created_vcpus is protected by kvm->lock, and is incremented
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8f1a16af519a..ff27cdbe8d92 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5477,6 +5477,10 @@ static int kvm_vm_ioctl_create_plane(struct kvm *kvm, unsigned id)
 	    WARN_ON_ONCE(id >= KVM_MAX_PLANES))
 		return -EINVAL;
 
+	/* Planes are only supported with in-kernel IRQ-chip */
+	if (!kvm_arch_irqchip_in_kernel(kvm))
+		return -EINVAL;
+
 	guard(mutex)(&kvm->lock);
 	if (kvm->planes[id])
 		return -EEXIST;
@@ -5498,6 +5502,7 @@ static int kvm_vm_ioctl_create_plane(struct kvm *kvm, unsigned id)
 		goto put_kvm;
 	}
 
+	kvm->has_planes = true;
 	fd_install(fd, file);
 	return fd;
 
-- 
2.53.0

