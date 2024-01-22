Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FD340BFC
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 20:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705954739; cv=none; b=Q+b1ZfajaqF8WqL9QIqxNNmyV5S269X2JNJIbnxP333EtM7GnPrig69COljKDwwaktYhi4TIBOSzJPTsqawqQxvszvT3tll4Gb5p7Q6UY81GwqYt4suU3fT79FEUcDOMBMB31ayADiOE4uCRNqCr2NPvCcWQLgtaKHOzJvZ3Ymo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705954739; c=relaxed/simple;
	bh=Y6Ud94S3Ia51gUXWEYLNZbQnv5MDPnQI+5KuKXMMiv0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WVeMKro2FYIYofcz13qn0B+D5mw1rtyaMMJPAvrk/TOG31aiT2NYx/gOTyh/FB9sFQJOj99w1iY0KqDzhnRPgUahijvy6/BApqL+K1H1RYctdspLslGIafxVO/x+ps6O3Ud7VrLVDuiHYlBDSXU652qSyIbJZuph3aMoeWsfoAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eTvajV+A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eTvajV+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8DCEC4167D;
	Mon, 22 Jan 2024 20:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705954738;
	bh=Y6Ud94S3Ia51gUXWEYLNZbQnv5MDPnQI+5KuKXMMiv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eTvajV+AKlEiLGVyBs3c4YHdj67fHUyZgDm5n2E4zqSo3WWXc8cQl2gMywmpM629s
	 G5TVIvn2eBCD+6UwKzpGrypMA66AxOuJpwSvWzWbCh3zhtcdh1TheBv1MIp/Bu0ebc
	 GCBxaKeFWNeXKvA2F/tcrnMhDqsQ/8SBMMPGfLmOuxADBzFOoV5tfE3TzJxB2RWXUN
	 W8JaJrSEHy2nk0j/07C3iQ+lfnFrb1e4bmo1xguqxmdMZ4wEcA4UZzSUpEeVxx1iQq
	 qKckB4ry4jIT4YtrVyflflLeW53ODQbfFj4FAXXcKt6COGZf28xbN13KE+D0ySYz9j
	 2rdLTs08Sv86g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rS0ky-00DjkQ-UI;
	Mon, 22 Jan 2024 20:18:56 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 07/25] KVM: arm64: nv: Drop sanitised_sys_reg() helper
Date: Mon, 22 Jan 2024 20:18:34 +0000
Message-Id: <20240122201852.262057-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240122201852.262057-1-maz@kernel.org>
References: <20240122201852.262057-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we have the infrastructure to enforce a sanitised register
value depending on the VM configuration, drop the helper that only
used the architectural RES0 value.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 431fd429932d..7a4a886adb9d 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1897,14 +1897,6 @@ static bool check_fgt_bit(u64 val, const union trap_config tc)
 	return ((val >> tc.bit) & 1) == tc.pol;
 }
 
-#define sanitised_sys_reg(vcpu, reg)			\
-	({						\
-		u64 __val;				\
-		__val = __vcpu_sys_reg(vcpu, reg);	\
-		__val &= ~__ ## reg ## _RES0;		\
-		(__val);				\
-	})
-
 bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
 {
 	union trap_config tc;
@@ -1940,25 +1932,25 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
 
 	case HFGxTR_GROUP:
 		if (is_read)
-			val = sanitised_sys_reg(vcpu, HFGRTR_EL2);
+			val = __vcpu_sys_reg(vcpu, HFGRTR_EL2);
 		else
-			val = sanitised_sys_reg(vcpu, HFGWTR_EL2);
+			val = __vcpu_sys_reg(vcpu, HFGWTR_EL2);
 		break;
 
 	case HDFGRTR_GROUP:
 	case HDFGWTR_GROUP:
 		if (is_read)
-			val = sanitised_sys_reg(vcpu, HDFGRTR_EL2);
+			val = __vcpu_sys_reg(vcpu, HDFGRTR_EL2);
 		else
-			val = sanitised_sys_reg(vcpu, HDFGWTR_EL2);
+			val = __vcpu_sys_reg(vcpu, HDFGWTR_EL2);
 		break;
 
 	case HAFGRTR_GROUP:
-		val = sanitised_sys_reg(vcpu, HAFGRTR_EL2);
+		val = __vcpu_sys_reg(vcpu, HAFGRTR_EL2);
 		break;
 
 	case HFGITR_GROUP:
-		val = sanitised_sys_reg(vcpu, HFGITR_EL2);
+		val = __vcpu_sys_reg(vcpu, HFGITR_EL2);
 		switch (tc.fgf) {
 			u64 tmp;
 
@@ -1966,7 +1958,7 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
 			break;
 
 		case HCRX_FGTnXS:
-			tmp = sanitised_sys_reg(vcpu, HCRX_EL2);
+			tmp = __vcpu_sys_reg(vcpu, HCRX_EL2);
 			if (tmp & HCRX_EL2_FGTnXS)
 				tc.fgt = __NO_FGT_GROUP__;
 		}
-- 
2.39.2

