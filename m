Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63B9E3F58FF;
	Mon,  8 Jun 2026 14:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929819; cv=none; b=NtQTXmMKbX7zGTBNtHHDP/U/e8Qur9WToVMNzw3KhHC22l/zkX/vt3MLG9O4auP16pIy9TpDv7AwIRjBCI0mHO2RdnEiFSoCzl6QJmrqOP9htvBaqsZn7VpeqZlWUNj25r1brN/JQn3b2Xkd6OKq6TOiOPyPMcMogryVqlV+oVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929819; c=relaxed/simple;
	bh=Vg4yOkePdRdKG/abJ/Tj7JapEcEFmmEQlW00KZrlOXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OygwZCYW/B8Csh9h8CqnNYzC4A35Vni4GKlt4tAhWry0FrrB8UJ0997Q5q8x4zzRecDGDuXI2zEr/+mbLzv18On8kSDOckOyzICAJZLFJZMB5puVF+eUIOTwoX3NI5x5xfYvoCKQlNHnGKwwHzqbnLYkzIF3ldATIU0EgsZMnOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from io.home.8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 180AF2028DB;
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
	joerg.roedel@amd.com,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
Subject: [PATCH 56/60] kvm: svm: Implement GET_AP_APIC_IDS NAE event
Date: Mon,  8 Jun 2026 16:42:48 +0200
Message-ID: <20260608144252.351443-57-joro@8bytes.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260608144252.351443-1-joro@8bytes.org>
References: <20260608144252.351443-1-joro@8bytes.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tom Lendacky <thomas.lendacky@amd.com>

Implement the GET_APIC_IDS NAE event to gather and return the list of
APIC IDs for all vCPUs in the guest.

Since it is now possible to launch vCPUs without going through the
LAUNCH_UPDATE process, be sure to mark the guest state protected and to
enable LBR virtualization.

Since it is now possible to launch vCPUs by APIC ID before the first
INIT-SIPI request, be sure to check for the AP create event in the
kvm_arch_vcpu_ioctl_run() loop when the AP is in the uninitialized state.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Co-developed-by: Joerg Roedel <joerg.roedel@amd.com>
Co-developed-by: Carlos López <clopez@suse.de>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/sev-common.h |  1 +
 arch/x86/include/uapi/asm/svm.h   |  1 +
 arch/x86/kvm/svm/sev.c            | 87 +++++++++++++++++++++++++++++--
 3 files changed, 86 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index ee17a3541b55..cedb7ea91da5 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -137,6 +137,7 @@ enum psc_op {
 #define GHCB_HV_FT_SNP			BIT_ULL(0)
 #define GHCB_HV_FT_SNP_AP_CREATION	BIT_ULL(1)
 #define GHCB_HV_FT_SNP_RINJ		(BIT_ULL(2) | GHCB_HV_FT_SNP_AP_CREATION)
+#define GHCB_HV_FT_APIC_ID_LIST		BIT_ULL(4)
 #define GHCB_HV_FT_SNP_MULTI_VMPL	BIT_ULL(5)
 
 /*
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index d281dd21c540..91395b82eadd 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -123,6 +123,7 @@
 #define SVM_VMGEXIT_HVDB_QUERY			2
 #define SVM_VMGEXIT_HVDB_CLEAR			3
 #define SVM_VMGEXIT_HV_IPI                      0x80000015ull
+#define SVM_VMGEXIT_GET_APIC_IDS		0x80000017ull
 #define SVM_VMGEXIT_SNP_RUN_VMPL		0x80000018ull
 #define SVM_VMGEXIT_SAVIC			0x8000001aull
 #define SVM_VMGEXIT_SAVIC_REGISTER_GPA		0
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 12b039823c1c..c0b2879f8e9f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -40,9 +40,10 @@
 #define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
-#define GHCB_HV_FT_SUPPORTED	(GHCB_HV_FT_SNP |		\
-				 GHCB_HV_FT_SNP_AP_CREATION |	\
-				 GHCB_HV_FT_SNP_RINJ)
+#define GHCB_HV_FT_SUPPORTED	(GHCB_HV_FT_SNP			| \
+				 GHCB_HV_FT_SNP_AP_CREATION	| \
+				 GHCB_HV_FT_SNP_RINJ		| \
+				 GHCB_HV_FT_APIC_ID_LIST)
 
 /*
  * The GHCB spec essentially states that all non-zero error codes other than
@@ -3518,6 +3519,10 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 			if (!kvm_ghcb_rax_is_valid(svm))
 				goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_GET_APIC_IDS:
+		if (!kvm_ghcb_rax_is_valid(svm))
+			goto vmgexit_err;
+		break;
 	case SVM_VMGEXIT_NMI_COMPLETE:
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
@@ -4439,6 +4444,78 @@ static int sev_snp_hv_ipi(struct vcpu_svm *svm)
 	return 0;
 }
 
+struct sev_apic_id_desc {
+	u32	num_entries;
+	u32	apic_ids[];
+};
+
+static void sev_get_apic_ids(struct vcpu_svm *svm)
+{
+	struct ghcb *ghcb = svm->sev_es.ghcb;
+	struct kvm_vcpu *vcpu = &svm->vcpu, *loop_vcpu;
+	struct kvm *kvm = vcpu->kvm;
+	unsigned int id_desc_size;
+	struct sev_apic_id_desc *desc;
+	struct page *page;
+	gpa_t gpa;
+	u64 pages;
+	unsigned long i;
+	int n;
+
+	pages = vcpu->arch.regs[VCPU_REGS_RAX];
+
+	/* Each APIC ID is 32-bits in size, so make sure there is room */
+	n = atomic_read(&kvm->online_vcpus);
+	/*TODO: is this possible? */
+	if (n < 0)
+		return;
+
+	id_desc_size = sizeof(*desc);
+	id_desc_size += n * sizeof(desc->apic_ids[0]);
+	if (id_desc_size > (pages * PAGE_SIZE)) {
+		vcpu->arch.regs[VCPU_REGS_RAX] = PFN_UP(id_desc_size);
+		return;
+	}
+
+	gpa = svm->vmcb->control.exit_info_1;
+
+	ghcb_set_sw_exit_info_1(ghcb, 2);
+	ghcb_set_sw_exit_info_2(ghcb, 5);
+
+	if (!page_address_valid(vcpu, gpa))
+		return;
+
+	page = gfn_to_page(kvm, gpa_to_gfn(gpa));
+	kvm_release_page_unused(page);
+	if (!page)
+		return;
+
+	if (!pages)
+		return;
+
+	/* Allocate a buffer to hold the APIC IDs */
+	desc = kvzalloc(id_desc_size, GFP_KERNEL_ACCOUNT);
+	if (!desc)
+		return;
+
+	desc->num_entries = n;
+	kvm_for_each_vcpu(i, loop_vcpu, kvm) {
+		/*TODO: is this possible? */
+		if (i >= n)
+			break;
+
+		desc->apic_ids[i] = loop_vcpu->vcpu_id;
+	}
+
+	if (!kvm_write_guest(kvm, gpa, desc, id_desc_size)) {
+		/* IDs were successfully written */
+		ghcb_set_sw_exit_info_1(ghcb, 0);
+		ghcb_set_sw_exit_info_2(ghcb, 0);
+	}
+
+	kvfree(desc);
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -4730,6 +4807,10 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		}
 		ret = 1;
 		break;
+	case SVM_VMGEXIT_GET_APIC_IDS:
+		sev_get_apic_ids(svm);
+		ret = 1;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
-- 
2.53.0

