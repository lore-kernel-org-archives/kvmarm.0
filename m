Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F22B21E097
	for <kvmarm@lists.linux.dev>; Fri, 12 Sep 2025 21:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757712193; cv=none; b=M44/SnqbWCIWvz66tHTAFa5HNw8o2Atoujv0iHMaldTOrZOsNdS8TNwkGES2ShqVMPiIbdkt2idg5nUlIpSwKNbilbC8+tEuL03SFQ6rqBpZ6yePD9ygzpihCwXYemdK7fJ9jqyxLRlPDi036f1mPazxtpVFoXTkIUiWTGWCe4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757712193; c=relaxed/simple;
	bh=UZSof+UssHWDeSE7qJnRMTFyOTixAlBW2bL+UFvnIBI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MzydaddLkVh6iLsK+oocRsMD2dP/eTpEnDBkKEmnGU/ecuyLxgK0NRjH8UDcSh+q9niPCMA9HBITCn84GnGnJBvELfvQN/YzHq6nl5LmVaI+Qm23C3weWxr6vcHLvkoHmuzF3UagxYfQ4C6bqxJuyd1yd9PK0MZZp+3AXrdNLo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Lhq6Vvm3; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Lhq6Vvm3"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757712190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pkkx2ghy+Rrc4F1zzY63h3XBIEPTjetx+EZ/gPA8ajA=;
	b=Lhq6Vvm3zsvcE1Ek7uczVMrfv2pKjCZs8Ao6OqIanX2NVUiuDjkt6h4o5WVbXiq+LzgD16
	0c2+Q+Fc4SZ6ryWvkvMi/WeGQ8tlRUYQRJEXCQPCj/zm5/1PTZxuzLv81fVu9azd/jaJNW
	SJC3MgTFoMPRGpbpxuG6qzJywQ6cTfQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 02/11] KVM: arm64: nv: Don't erroneously claim FEAT_DoubleLock for NV VMs
Date: Fri, 12 Sep 2025 14:22:49 -0700
Message-Id: <20250912212258.407350-3-oliver.upton@linux.dev>
In-Reply-To: <20250912212258.407350-1-oliver.upton@linux.dev>
References: <20250912212258.407350-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

ID_AA64DFR0_EL1.DoubleLock is one of those annoying signed feature
fields where a non-negative value implies that a feature is implemented
and a negative value implies that it is not. While the intention of
masking this field was likely to hide the feature, KVM actually
advertises it, even on unsupporting hardware.

Remove FEAT_DoubleLock from the mask, making the NI value visible to the
VM. Take care to accept the old, incorrect values for this field as
we've lied to userspace.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/nested.c   |  1 -
 arch/arm64/kvm/sys_regs.c | 25 +++++++++++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 53c57d105c93..4044dc66fa39 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1582,7 +1582,6 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 			 ID_AA64DFR0_EL1_MTPMU		|
 			 ID_AA64DFR0_EL1_TraceBuffer	|
 			 ID_AA64DFR0_EL1_TraceFilt	|
-			 ID_AA64DFR0_EL1_DoubleLock	|
 			 ID_AA64DFR0_EL1_PMSVer		|
 			 ID_AA64DFR0_EL1_CTX_CMPs	|
 			 ID_AA64DFR0_EL1_SEBEP		|
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b29f72478a50..cb7fc871c42d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1997,6 +1997,26 @@ static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
 	return val;
 }
 
+/*
+ * Older versions of KVM erroneously claim support for FEAT_DoubleLock with
+ * NV-enabled VMs on unsupporting hardware. Silently ignore the incorrect
+ * value if it is consistent with the bug.
+ */
+static bool ignore_feat_doublelock(struct kvm_vcpu *vcpu, u64 val)
+{
+	u8 host, user;
+
+	if (!vcpu_has_nv(vcpu))
+		return false;
+
+	host = SYS_FIELD_GET(ID_AA64DFR0_EL1, DoubleLock,
+			     read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1));
+	user = SYS_FIELD_GET(ID_AA64DFR0_EL1, DoubleLock, val);
+
+	return host == ID_AA64DFR0_EL1_DoubleLock_NI &&
+	       user == ID_AA64DFR0_EL1_DoubleLock_IMP;
+}
+
 static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       u64 val)
@@ -2028,6 +2048,11 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	if (debugver < ID_AA64DFR0_EL1_DebugVer_IMP)
 		return -EINVAL;
 
+	if (ignore_feat_doublelock(vcpu, val)) {
+		val &= ~ID_AA64DFR0_EL1_DoubleLock;
+		val |= SYS_FIELD_PREP_ENUM(ID_AA64DFR0_EL1, DoubleLock, NI);
+	}
+
 	return set_id_reg(vcpu, rd, val);
 }
 
-- 
2.39.5

