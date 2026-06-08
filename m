Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D7773F0A85;
	Mon,  8 Jun 2026 14:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929815; cv=none; b=r3FuMTGtage5DYxTVfS/fFLxRqCpY5LJl9hNy/FJG7qO1X7iYMwLBpHMrn71+5mbeqZvSEhHfrzYZKZGy9HlBCLsphY84EL7nl4lNRCCdjPYHqJ0z1H6Bn5g/4v9kMWROpjPrJ6j8YRE6xC/7eBMor6Rjv7MnYPHrq/rXvAgHmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929815; c=relaxed/simple;
	bh=pcp4odT3NNnPWZpyjZ6003LhvZo4f0DoCv0aN5fr2xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZxs5aM2c5q1T6Jhv5crroN2kSMvF6+OtwM92tHk+1uhcZTHw0cG7A/kZhlWhhrIZo8aCxIwiZqoOvXD/FwG78Ql5/KIvnOBNupjQzstdOakJcE9FbtFQBcxhG9+mZ3LQnReJmIZOb/Skhf2tvkyTlBB4xRM0ceIyJqd9AQwGQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from io.home.8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id B9A7C2028D0;
	Mon,  8 Jun 2026 16:43:14 +0200 (CEST)
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
Subject: [PATCH 45/60] kvm: x86: Update state for all plane VCPUs after CPUID update
Date: Mon,  8 Jun 2026 16:42:37 +0200
Message-ID: <20260608144252.351443-46-joro@8bytes.org>
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

Make sure to update CPUID dependent state for all VCPUs of a given
plane when CPUID state is updated.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/cpuid.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 27e2f7e25038..fab075bb6fdc 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -513,6 +513,8 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 {
 	struct kvm_vcpu_common *common = vcpu->common;
 	u32 vcpu_caps[NR_KVM_CPU_CAPS];
+	struct kvm_vcpu *v;
+	unsigned i;
 	int r;
 
 	/*
@@ -562,9 +564,11 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 
 #ifdef CONFIG_KVM_HYPERV
 	if (kvm_cpuid_has_hyperv(vcpu)) {
-		r = kvm_hv_vcpu_init(vcpu);
-		if (r)
-			goto err;
+		vcpu_for_each_plane(common, i, v) {
+			r = kvm_hv_vcpu_init(vcpu);
+			if (r)
+				goto err;
+		}
 	}
 #endif
 
@@ -572,10 +576,12 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	if (r)
 		goto err;
 
+	vcpu_for_each_plane(vcpu->common, i, v) {
 #ifdef CONFIG_KVM_XEN
-	vcpu->arch.xen.cpuid = kvm_get_hypervisor_cpuid(vcpu, XEN_SIGNATURE);
+		v->arch.xen.cpuid = kvm_get_hypervisor_cpuid(vcpu, XEN_SIGNATURE);
 #endif
-	kvm_vcpu_after_set_cpuid(vcpu);
+		kvm_vcpu_after_set_cpuid(v);
+	}
 
 success:
 	kvfree(e2);
-- 
2.53.0

