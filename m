Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 832743F7865;
	Mon,  8 Jun 2026 14:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929819; cv=none; b=G+z87JQkOGdaIZ6H185atFQVBs19DTHf/9nnJ53XxHCMHow3QAEYGZRcUNAyFT5nAA6mfN92+bAs73G424GhUAIIrJVn3gMFeSmPToDc2gkVPJSu9X5oh2/vaX4ip9QGhyT8a1JzcRUp9w+x6BWsY5itTQvZBhU6SzIiXo1RpTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929819; c=relaxed/simple;
	bh=37KBwkqQMzm819HXZqVoPMl1ffQH9bZUEHoui22d4s0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PxU+8sjRysX+8P3Ck77+kDYmfHO9QQJkyOlqiGXNuNRjzKaw9k0whhDrJK2OVbCtp+vg/pD3gFs8ZmKl//xp9snO6ymzoc6jnGYZaa0VpKEoX/SSTKV7RFCBa2JJUBljoOZeaAKE5drZELK2iAc3qQX8JbiMPIAT6smVezEzp2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from io.home.8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 841DF2028DD;
	Mon,  8 Jun 2026 16:43:17 +0200 (CEST)
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
Subject: [PATCH 58/60] kvm: svm: Invoke a specified VMPL level VMSA for the vCPU
Date: Mon,  8 Jun 2026 16:42:50 +0200
Message-ID: <20260608144252.351443-59-joro@8bytes.org>
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

From: Tom Lendacky <thomas.lendacky@amd.com>

Implement the SNP Run VMPL NAE event and MSR protocol to allow a guest to
request a different VMPL level VMSA be run for the vCPU. This allows the
guest to "call" an SVSM to process an SVSM request.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Co-developed-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/sev-common.h |  6 +++
 arch/x86/kvm/svm/sev.c            | 71 +++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index cedb7ea91da5..a09cf5690aba 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -114,6 +114,8 @@ enum psc_op {
 
 /* GHCB Run at VMPL Request/Response */
 #define GHCB_MSR_VMPL_REQ		0x016
+#define GHCB_MSR_VMPL_LEVEL_POS		32
+#define GHCB_MSR_VMPL_LEVEL_MASK	GENMASK_ULL(7, 0)
 #define GHCB_MSR_VMPL_REQ_LEVEL(v)			\
 	/* GHCBData[39:32] */				\
 	((((u64)(v) & GENMASK_ULL(7, 0)) << 32) |	\
@@ -121,6 +123,10 @@ enum psc_op {
 	GHCB_MSR_VMPL_REQ)
 
 #define GHCB_MSR_VMPL_RESP		0x017
+#define GHCB_MSR_VMPL_ERROR_POS		32
+#define GHCB_MSR_VMPL_ERROR_MASK	GENMASK_ULL(31, 0)
+#define GHCB_MSR_VMPL_RSVD_POS		12
+#define GHCB_MSR_VMPL_RSVD_MASK		GENMASK_ULL(19, 0)
 #define GHCB_MSR_VMPL_RESP_VAL(v)			\
 	/* GHCBData[63:32] */				\
 	(((u64)(v) & GENMASK_ULL(63, 32)) >> 32)
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 53cd3aba7368..b67566fcb69e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3556,6 +3556,10 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		if (!sev_snp_guest(vcpu->kvm))
 			goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_SNP_RUN_VMPL:
+		if (!sev_snp_guest(vcpu->kvm))
+			goto vmgexit_err;
+		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
 		goto vmgexit_err;
@@ -4593,6 +4597,45 @@ static void sev_get_apic_ids(struct vcpu_svm *svm)
 	kvfree(desc);
 }
 
+static int __sev_snp_run_vmpl(struct vcpu_svm *svm, unsigned int vmpl)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm_vcpu *target = vcpu->common->vcpus[vmpl];
+	struct vcpu_svm *target_svm = to_svm(target);
+
+	if (!target)
+		return -EINVAL;
+
+	/* Mark current plane as stopped so it is not selected */
+	kvm_set_mp_state(target, KVM_MP_STATE_RUNNABLE);
+	/* In case KVM_REQ_UPDATE_PROTECTED_GUEST_STATE is set - mark the new VMSA as runnable */
+	target_svm->sev_es.snp_ap_runnable = true;
+	kvm_vcpu_set_plane_runnable(target);
+	kvm_vcpu_set_plane_stopped(vcpu);
+
+	kvm_make_request(KVM_REQ_PLANE_RESCHED, vcpu);
+
+	return 1;
+}
+
+static int sev_snp_run_vmpl(struct vcpu_svm *svm)
+{
+	struct ghcb *ghcb = svm->sev_es.ghcb;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	unsigned int vmpl;
+
+	vmpl = lower_32_bits(svm->vmcb->control.exit_info_1);
+	if (vmpl >= SVM_SEV_VMPL_MAX) {
+		vcpu_unimpl(vcpu, "vmgexit: invalid VMPL level [%u] from guest\n", vmpl);
+		return -EINVAL;
+	}
+
+	ghcb_set_sw_exit_info_1(ghcb, 0);
+	ghcb_set_sw_exit_info_2(ghcb, 0);
+
+	return __sev_snp_run_vmpl(svm, vmpl);
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -4704,6 +4747,27 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 
 		ret = snp_begin_psc_msr(svm, control->ghcb_gpa);
 		break;
+	case GHCB_MSR_VMPL_REQ: {
+		unsigned int vmpl;
+
+		if (!sev_snp_guest(vcpu->kvm))
+			goto out_terminate;
+
+		vmpl = get_ghcb_msr_bits(svm, GHCB_MSR_VMPL_LEVEL_MASK, GHCB_MSR_VMPL_LEVEL_POS);
+
+		set_ghcb_msr_bits(svm, 0, GHCB_MSR_VMPL_ERROR_MASK, GHCB_MSR_VMPL_ERROR_POS);
+		set_ghcb_msr_bits(svm, 0, GHCB_MSR_VMPL_RSVD_MASK, GHCB_MSR_VMPL_RSVD_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_VMPL_RESP, GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
+
+		if (vmpl >= SVM_SEV_VMPL_MAX) {
+			vcpu_unimpl(vcpu, "vmgexit: invalid VMPL level [%u] from guest\n", vmpl);
+			set_ghcb_msr_bits(svm, 1, GHCB_MSR_VMPL_ERROR_MASK, GHCB_MSR_VMPL_ERROR_POS);
+			break;
+		}
+
+		ret = __sev_snp_run_vmpl(svm, vmpl);
+		break;
+	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -4887,6 +4951,13 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		sev_get_apic_ids(svm);
 		ret = 1;
 		break;
+	case SVM_VMGEXIT_SNP_RUN_VMPL:
+		ret = sev_snp_run_vmpl(svm);
+		if (ret < 0) {
+			svm_vmgexit_bad_input(svm, GHCB_ERR_INVALID_INPUT);
+			ret = 1;
+		}
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
-- 
2.53.0

