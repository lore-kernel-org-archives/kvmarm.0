Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.143
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792738879;
	b=Iw+jqj6BBOSspF29qHrDYAAZ24cREcryhASXSv5SYcCdNYHCudqGdlfaSSMyKK/a0yqo
	 sTOUOJjwnFAlUL6sCea/MlX5eL/Aj3lBT563gZIWAyq5iubp3+/CaRAKmct5YL2GVxyuV
	 DisUUG44U5/Yjgg7xdyEpWPXWrmzwYxwo0niwW4v/I+Er+BdcGirQvd9UOdWDFN2cryaX
	 spPY1B/GZIGnBRHLqp5SOVN3Ln2AUskxKJINwdMkhtmBcE9Twqt5aVsDcD/U56n3zCxMu
	 wyky5k6JHN+4Xu51zjXcX3Rb+zvqW4oF4YlexVoOA5dPRVu6ocz9Na2mmn/+u4euT2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792738879;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=IthMuZ/X3+pBoLoIufpj4zbJGn8A/2aYhe0XUm0DWMM=;
	b=J2OHK1v+v733iINHqVOBBdj16nR9LPTGrrqoX0BxpI1WfMLVD9E8CFa8M6VEiHj5uSl0
	 k4BbUy65l0DEbnDHE+uxvQQm+dt3/iVu2WQrKuazCqoLGHdJelAHcHkPn7upvIg9ywKiN
	 UYqs54ojRNgpe/H99aS5yjSYKWsYeFoHMwbLh9OwkPwznST4wvk1cTew4AQw07KLNBzYC
	 9VsAGlqHNHZrS729mvgszrWd+ruEfoxPdNUDy2KbIbfkAlv9rYZpZzQHqvDucoLS+IgBi
	 nzU4L/KbRAOGcXbX1k1X5151aVPqguDaVyV0WpQO3Fno8/jV90wiqJrdoToWvN8QyUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VIIyaJ0S;
	arc=none smtp.remote-ip=91.218.175.143
Received: from mta0.migadu.com (out-143.mta0.migadu.com [91.218.175.143])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0577B606A31B
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 07:01:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0577B606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VIIyaJ0S
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=bc/l25RHGTThA1qU58knnGQTtBxP0XgtC5Ldu46NdMg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792738877; v=1; x=1793343677;
 b=VIIyaJ0Sw52+V97m1HKFMIqSa8yNktq8sfhmwLCLfRwHTvhwV0dPleik4OXIPg2DcDAfVuTs
 yVRIUsm/0QDbsndkPZ8u3CEHzlCuhbWSoLIFMxsl3QiNzNSTJBfnt8tWlqqrFHZzL9tRocntdjZ
 bLk6ry6z00cJbZ/RFAUTs7Mo=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id c1557c2947e98bd9;
	Fri, 23 Oct 2026 07:01:16 +0000
X-Mizu-Trace-ID: c1557c2947e98bd9
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Zhou Wang <wangzhou1@hisilicon.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: arm64: Hide FEAT_LS64_ACCDATA from guests
Date: Fri, 23 Oct 2026 08:01:09 +0100
Message-ID: <20261023070110.1833446-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261023070110.1833446-1-fuad.tabba@linux.dev>
References: <20261023070110.1833446-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit 58ce78667a641 ("arm64: Add support for FEAT_{LS64,
LS64_V}"), a guest sees the host's ID_AA64ISAR1_EL1.LS64, but KVM only
enables the FEAT_LS64 and FEAT_LS64_V instructions in HCRX_EL2. On a
host with FEAT_LS64_ACCDATA, a guest's ST64BV0 therefore traps and hits
the WARN_ON_ONCE() in handle_other(). ACCDATA_EL1 isn't trapped or
context-switched either, so every guest on that CPU shares it.

Rather than support FEAT_LS64_ACCDATA, which requires ACCDATA_EL1 to be
context-switched, cap the field at LS64_V. The guest's ACCDATA_EL1
accesses then UNDEF. This hides FEAT_LS64WB too, as it implies
FEAT_LS64_ACCDATA.

A VM saved on an older kernel can carry any level up to the host's, so
keep accepting those from the VMM, capped the same way. One saved at
LS64_ACCDATA or above restores at LS64_V.

Fixes: 58ce78667a641 ("arm64: Add support for FEAT_{LS64, LS64_V}")
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 44aae52c473d7..7801166991b12 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1958,6 +1958,9 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 				 ID_AA64ISAR1_EL1_API |
 				 ID_AA64ISAR1_EL1_GPA |
 				 ID_AA64ISAR1_EL1_GPI);
+
+		/* ACCDATA_EL1 isn't context-switched, so no FEAT_LS64_ACCDATA */
+		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64ISAR1_EL1, LS64, LS64_V);
 		break;
 	case SYS_ID_AA64ISAR2_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
@@ -2403,6 +2406,22 @@ static int set_id_aa64pfr2_el1(struct kvm_vcpu *vcpu,
 	return set_id_reg(vcpu, rd, user_val);
 }
 
+static int set_id_aa64isar1_el1(struct kvm_vcpu *vcpu,
+				const struct sys_reg_desc *rd, u64 user_val)
+{
+	u64 hw_val = read_sanitised_ftr_reg(SYS_ID_AA64ISAR1_EL1);
+	u64 ls64_mask = ID_AA64ISAR1_EL1_LS64_MASK;
+
+	/*
+	 * Older kernels let userspace set LS64 up to the host's level, so
+	 * keep accepting those values, capped at LS64_V.
+	 */
+	if ((user_val & ls64_mask) <= (hw_val & ls64_mask))
+		user_val = ID_REG_LIMIT_FIELD_ENUM(user_val, ID_AA64ISAR1_EL1, LS64, LS64_V);
+
+	return set_id_reg(vcpu, rd, user_val);
+}
+
 /*
  * Allow userspace to de-feature a stage-2 translation granule but prevent it
  * from claiming the impossible.
@@ -3428,10 +3447,11 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* CRm=6 */
 	ID_WRITABLE(ID_AA64ISAR0_EL1, ~ID_AA64ISAR0_EL1_RES0),
-	ID_WRITABLE(ID_AA64ISAR1_EL1, ~(ID_AA64ISAR1_EL1_GPI |
-					ID_AA64ISAR1_EL1_GPA |
-					ID_AA64ISAR1_EL1_API |
-					ID_AA64ISAR1_EL1_APA)),
+	ID_FILTERED(ID_AA64ISAR1_EL1, id_aa64isar1_el1,
+		    ~(ID_AA64ISAR1_EL1_GPI |
+		      ID_AA64ISAR1_EL1_GPA |
+		      ID_AA64ISAR1_EL1_API |
+		      ID_AA64ISAR1_EL1_APA)),
 	ID_WRITABLE(ID_AA64ISAR2_EL1, ~(ID_AA64ISAR2_EL1_RES0 |
 					ID_AA64ISAR2_EL1_APA3 |
 					ID_AA64ISAR2_EL1_GPA3)),
-- 
2.47.3

