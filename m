Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF928253F14
	for <kvmarm@lists.linux.dev>; Thu, 18 Sep 2025 16:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758214518; cv=none; b=EzJPrWVpJmHlMde5MKEz6Rl9dYkP1GiJ9MAX7HONwkFhDBEtPrjbTdADJwF8ypMN30M5+/isKr9dOd7L0EyPcMl1OCwHWqPKQ868n60iqB62XkJLTesrrIABONLfVrvn2z01pGWgJrVQgAO3wZkA4I8x9/4mCS2H34sG0uWhyZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758214518; c=relaxed/simple;
	bh=d5YiUrjMeLDpw3K4Av+Lipvj0nMw98acCH2x7N2+Maw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h5ph5hhWOpHcx+78a7Or8kAagmeuD+i2I2YCBRQ5BTbcvguh+uJGJxzqeAwjQTdStydH83QKvdr8mC1shd1eNx5UlDPJ+f65cCs9Sxii2gS50zoDCAXwXsq8l+XLaztPMV+B+YAomXplSVv4Mz8dv+cx7fMU3T4SRBMtPCB80ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HNfQJ2+l; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HNfQJ2+l"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758214514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eIiqvknu5fhykmVE6F5nroE2JXZ0WiK9Cm5Q0Aga/z8=;
	b=HNfQJ2+l6OkLuLrXX+ZL6H6fLehJmgdluUImWxXphbO/i31BHcIO2VBt8cOSmoaBvw3Xm9
	7d//QKRzyXrEXoZQz8znRLk1Vtrfz+j3v2UtlL+ICMzvelLDKbk4HUfaHS9u7Gf8kmP7xB
	s5b0IFNP3gtyAtYY4zABwFhczQ5wjrM=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Itaru Kitayama <itaru.kitayama@linux.dev>
Subject: [PATCH] KVM: arm64: nv: Allow userspace to de-feature stage-2 TGRANs
Date: Thu, 18 Sep 2025 09:55:05 -0700
Message-ID: <20250918165505.415017-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM advertises the stage-2 TGRAN fields as writable to userspace but
prevents any modification for NV-enabled VMs. Update the special-cased
sanitization to permit de-featuring a particular TGRAN without allowing
the legacy value which refers to the stage-1 field for support.

Cc: Itaru Kitayama <itaru.kitayama@linux.dev>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b29f72478a50..83ecfdb46704 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2148,16 +2148,29 @@ static int set_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
 	return set_id_reg(vcpu, rd, user_val);
 }
 
+/*
+ * Allow userspace to de-feature a stage-2 translation granule but prevent it
+ * from claiming the impossible.
+ */
+#define tgran2_val_allowed(tg, safe, user)			\
+({								\
+	u8 __s = SYS_FIELD_GET(ID_AA64MMFR0_EL1, tg, safe);	\
+	u8 __u = SYS_FIELD_GET(ID_AA64MMFR0_EL1, tg, user);	\
+								\
+	__s == __u || __u == ID_AA64MMFR0_EL1_##tg##_NI;	\
+})
+
 static int set_id_aa64mmfr0_el1(struct kvm_vcpu *vcpu,
 				const struct sys_reg_desc *rd, u64 user_val)
 {
 	u64 sanitized_val = kvm_read_sanitised_id_reg(vcpu, rd);
-	u64 tgran2_mask = ID_AA64MMFR0_EL1_TGRAN4_2_MASK |
-			  ID_AA64MMFR0_EL1_TGRAN16_2_MASK |
-			  ID_AA64MMFR0_EL1_TGRAN64_2_MASK;
 
-	if (vcpu_has_nv(vcpu) &&
-	    ((sanitized_val & tgran2_mask) != (user_val & tgran2_mask)))
+	if (!vcpu_has_nv(vcpu))
+		return set_id_reg(vcpu, rd, user_val);
+
+	if (!tgran2_val_allowed(TGRAN4_2, sanitized_val, user_val) ||
+	    !tgran2_val_allowed(TGRAN16_2, sanitized_val, user_val) ||
+	    !tgran2_val_allowed(TGRAN64_2, sanitized_val, user_val))
 		return -EINVAL;
 
 	return set_id_reg(vcpu, rd, user_val);

base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
-- 
2.47.3

