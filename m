Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E4BB3F23C2;
	Mon,  8 Jun 2026 14:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929806; cv=none; b=XrYCn0vTR0Qkg1WkK4JE2mskdVLq2ZuiPxWMyDv9MYQQwiJRk+kc++Bo0ItOqTBUWrpbepv7SKSD/ewuL3FSG+fvc6mDCnyfgrDSA8reAVXFvsjoWRC49P9A1AmJBp9SbT1Wf4j+nrV9/raPLrs2YYjBW4U8G7oUJxXCdkFnI24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929806; c=relaxed/simple;
	bh=r01oPy7rd2WamfMpohUjCz6YLI85cTtOVquyKCt6CKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vD2b+6ATwsfQCykCw1JJteGZwZjqxflI8JJBHjwfMMZSME+teiVXtS9ZC3d14JUXhvt9lbTQjaY6mL4CV+jvbAzXz4YCHQYNiCCflQ3oWVgS32ie5L6wfuilbAbn0uvanWajnCtiVmpnYesrGwy1xAcQUzbTy3/QnDpxhZUX3WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from io.home.8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 80CE32028C1;
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
Subject: [PATCH 30/60] kvm: Add KVM_EXIT_PLANE_EVENT
Date: Mon,  8 Jun 2026 16:42:22 +0200
Message-ID: <20260608144252.351443-31-joro@8bytes.org>
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

Add a new exit-type to KVM for telling user-space that a plane-vcpu is
missing. Create a helper which fills out the kvm_run exit structure.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Co-developed-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/kvm_host.h |  2 ++
 include/uapi/linux/kvm.h | 10 ++++++++++
 virt/kvm/kvm_main.c      | 12 ++++++++++++
 3 files changed, 24 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3ecd472c7cfa..90b97137840e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1649,6 +1649,8 @@ void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu);
 
+int kvm_request_create_plane(struct kvm_vcpu *vcpu, unsigned plane, u64 apic_id);
+
 #ifndef CONFIG_S390
 void __kvm_vcpu_kick(struct kvm_vcpu *vcpu, bool wait);
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 24e34b8e4819..a88d987c7882 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -146,6 +146,13 @@ struct kvm_exit_snp_req_certs {
 	__u64 ret;
 };
 
+struct kvm_plane_event_exit {
+#define KVM_PLANE_EVENT_CREATE_VCPU	1
+	__u32 cause;
+	__u32 plane;
+	__u64 extra[8];
+};
+
 #define KVM_S390_GET_SKEYS_NONE   1
 #define KVM_S390_SKEYS_MAX        1048576
 
@@ -193,6 +200,7 @@ struct kvm_exit_snp_req_certs {
 #define KVM_EXIT_ARM_SEA          41
 #define KVM_EXIT_ARM_LDST64B      42
 #define KVM_EXIT_SNP_REQ_CERTS    43
+#define KVM_EXIT_PLANE_EVENT      44
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -497,6 +505,8 @@ struct kvm_run {
 		} arm_sea;
 		/* KVM_EXIT_SNP_REQ_CERTS */
 		struct kvm_exit_snp_req_certs snp_req_certs;
+		/* KVM_EXIT_PLANE_EVENT */
+		struct kvm_plane_event_exit plane_event;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 03a44ff62f0f..f0f78bb74e51 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3973,6 +3973,18 @@ bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_wake_up);
 
+int kvm_request_create_plane(struct kvm_vcpu *vcpu, unsigned plane, u64 apic_id)
+{
+	vcpu->run->exit_reason = KVM_EXIT_PLANE_EVENT;
+	memset(&vcpu->run->plane_event, 0, sizeof(vcpu->run->plane_event));
+	vcpu->run->plane_event.cause = KVM_PLANE_EVENT_CREATE_VCPU;
+	vcpu->run->plane_event.plane = plane;
+	vcpu->run->plane_event.extra[0] = apic_id;
+
+	return 0;
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_request_create_plane);
+
 #ifndef CONFIG_S390
 /*
  * Kick a sleeping VCPU, or a guest VCPU in guest mode, into host kernel mode.
-- 
2.53.0

