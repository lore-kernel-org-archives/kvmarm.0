Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70A8D3F4858;
	Mon,  8 Jun 2026 14:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929810; cv=none; b=Rjstpp7PB0xyM14c8K+84g6VpdaI/hfdd8fpYdoLUDtrBekC8cnJ2aoGFqUlloYaia5CoKQiOAF7qf/DiKXFa5iT+9GbKoc1fVAOyzR9GowhFWN847uPDNRhwp/wkD4p8JVjIoIGIr8SKPN0Fge1QwKQHvZrm5s9ra98+YwSRCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929810; c=relaxed/simple;
	bh=+10xLxSz2hdoIHB3HQB3QYazOPEqpz5qTWBbJNGvwo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kcWW1mZ7FWggCWMD1jHwRhyKYu+jzWXoIPT2rASoLg813w9dNkfzDtwwaxHbyPSzTi05ltzkhkwonwoPXxI+bLh301UBH2HOV77pPhTJIiuRUvI6OMm9D2bteYi3LRg3/DQYyk3GfbDG9PqD6wh629FXMq5HnfXou80e6V/sKOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from io.home.8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 5E0962028C5;
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
Subject: [PATCH 34/60] kvm: Keep track of plane VCPUs in struct kvm_vcpu_common
Date: Mon,  8 Jun 2026 16:42:26 +0200
Message-ID: <20260608144252.351443-35-joro@8bytes.org>
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

Introduce an array which keeps track of per-plane VCPU instances for a
single VCPU index. This is a short-cut to not always tranverse the
xarrays on plane switches.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/kvm_host.h | 6 ++++++
 virt/kvm/kvm_main.c      | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b8c3f8f11cb4..5c3f9dfa15ea 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -335,6 +335,8 @@ struct kvm_vcpu_common {
 	/* Currently active VCPU */
 	struct kvm_vcpu *current_vcpu;
 
+	struct kvm_vcpu *vcpus[KVM_MAX_PLANES];
+
 	/* Locks */
 	int ____srcu_idx; /* Don't use this directly.  You've been warned. */
 #ifdef CONFIG_PROVE_RCU
@@ -382,6 +384,10 @@ struct kvm_vcpu_common {
 	struct kvm_vcpu_arch_common arch;
 };
 
+#define vcpu_for_each_plane(common, i, v)			\
+	for ((i) = 0; (i) < KVM_MAX_PLANES; ++(i))		\
+		if (((v) = common->vcpus[(i)]) != NULL)
+
 struct kvm_vcpu {
 	struct kvm *kvm;
 	struct kvm_plane *plane;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8839f91fd15e..9d30fd85ce5f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -524,6 +524,8 @@ static int kvm_vcpu_init_common(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned
 
 static void kvm_vcpu_finish_common(struct kvm_vcpu *vcpu)
 {
+	WARN_ON(vcpu->common->vcpus[vcpu->plane_level] != NULL);
+	vcpu->common->vcpus[vcpu->plane_level] = vcpu;
 	smp_wmb();
 	if (vcpu->plane_level == 0) {
 		/*
@@ -555,6 +557,7 @@ static void kvm_vcpu_common_destroy(struct kvm_vcpu *vcpu)
 
 	vcpu->common = NULL;
 	vcpu->run = NULL;
+	common->vcpus[vcpu->plane_level] = NULL;
 
 	if (vcpu->plane_level != 0)
 	       return;
-- 
2.53.0

