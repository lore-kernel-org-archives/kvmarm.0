Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176F2244681
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 20:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758141100; cv=none; b=IMiPx93YmDDka7eHXZB6PWxYC+9LVwimD9I18UN9xFrPF8MA644tYez6nxvvD3J0Ju8dXeTeoLUQsAQI7nQTWI3PynoVGf5BYgGFGsz7LnHD65w2M2hJwCzNTIchvQAbYCaKRmrFWGouSkIWig5AaxnC6xbVEVMZ0bEfBy5EAnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758141100; c=relaxed/simple;
	bh=lPy1VfMhOR71BnQGqiW+88Er6rf3Nz6NZPW2u66ssBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsD7lTWxrxYvnTJ0XmBvvG/UWLh7NKhiX5O06u1quH3TJSUptCb7d2omvVkQH6rWCNdAguoTqLgreY7CB1ln5p6i+/ikVHyWXyifmXgPjiAgxLFzNLpkME2peXomAgLT+PEahC8LJF8cNcHNip0fMoPkQnkMktqzuYDoAIhRMvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tFAHKidB; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tFAHKidB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758141097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LV0ANWBQM71mimE4ANzztRHCzPjeSV62yWTT2mN+yZg=;
	b=tFAHKidBWMaOn4yKLiFzw7xELeY8JrfMUBshUzly2w3YTHDQ1CqN0I1dl925Tb+BPmQZSo
	F5VAe93q2PlP1HxL3uQaC+uZS8KIyueci5t8l5ZCYZcgipOXu9AsO9xAQ8VZLXs2+QOhNa
	QrwOTqFV5aI9zTPJPCl7bOdLXfwFRu4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/2] KVM: arm64: nv: Apply guest's MDCR traps in nested context
Date: Wed, 17 Sep 2025 13:31:25 -0700
Message-ID: <20250917203125.283116-3-oliver.upton@linux.dev>
In-Reply-To: <20250917203125.283116-1-oliver.upton@linux.dev>
References: <20250917203125.283116-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM needs to ensure the guest hypervisor's traps take effect when the
vCPU is in a nested context. While supporting infrastructure is in place
for most of the EL2 trap registers, MDCR_EL2 is not.

Fold the guest's trap configuration into the effective MDCR_EL2. Apply
it directly to the in-memory representation as it gets recomputed on
every vcpu_load() anyway.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/nested.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 9559c64e7e0c..61542d6fd8f5 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1797,8 +1797,25 @@ void kvm_nested_sync_hwstate(struct kvm_vcpu *vcpu)
 		kvm_inject_serror_esr(vcpu, vcpu_get_vsesr(vcpu));
 }
 
+/*
+ * KVM unconditionally sets most of these traps anyway but use an allowlist
+ * to document the guest hypervisor traps that may take precedence and guard
+ * against future changes to the non-nested trap configuration.
+ */
+#define NV_MDCR_GUEST_INCLUDE	(MDCR_EL2_TDE	|	\
+				 MDCR_EL2_TDA	|	\
+				 MDCR_EL2_TDRA	|	\
+				 MDCR_EL2_TTRF	|	\
+				 MDCR_EL2_TPMS	|	\
+				 MDCR_EL2_TPM	|	\
+				 MDCR_EL2_TPMCR	|	\
+				 MDCR_EL2_TDCC	|	\
+				 MDCR_EL2_TDOSA)
+
 void kvm_nested_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 {
+	u64 guest_mdcr = __vcpu_sys_reg(vcpu, MDCR_EL2);
+
 	/*
 	 * In yet another example where FEAT_NV2 is fscking broken, accesses
 	 * to MDSCR_EL1 are redirected to the VNCR despite having an effect
@@ -1806,4 +1823,6 @@ void kvm_nested_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 	 */
 	if (is_hyp_ctxt(vcpu))
 		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
+	else
+		vcpu->arch.mdcr_el2 |= (guest_mdcr & NV_MDCR_GUEST_INCLUDE);
 }
-- 
2.47.3

