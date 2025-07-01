Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4170C2C859
	for <kvmarm@lists.linux.dev>; Tue,  1 Jul 2025 14:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751379761; cv=none; b=PP887zwjKN+fQcP66hcO5OUPStM+vHwceqC1mgIprcR9uQ3XDn3pHMyxipv6faS+4+glC+t/ofRZEBgVdrjwGx11vfMVI9/criSmjmAPICTIsZ6SfO1kBcIsSGECB5zOdPuMtKK1rLZg7jvutSnPEce0KPsXXR4cB7V2YG03xmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751379761; c=relaxed/simple;
	bh=Wl4lyyrYUcT3WQOaPBwaLkFiqBgAhrV+nWS3JZrxsb4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=V1nCU56jWt8EiJhq4SVH435o3wac8LG7oWnkKFrJAtAAQzxEBJZ3rXd3I0gjlZFMKMmmTcgyw406+92ej+vDEW2gt1G6A1B0soUdqYusyIb/Twitra8DtF5aBms9cfEi+SS2V4xmQu6c7brulQ5HLSFavpFRxm6DzT/d65AR98g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T1muoWW9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T1muoWW9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE16C4CEEB;
	Tue,  1 Jul 2025 14:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751379760;
	bh=Wl4lyyrYUcT3WQOaPBwaLkFiqBgAhrV+nWS3JZrxsb4=;
	h=From:To:Cc:Subject:Date:From;
	b=T1muoWW9B/AVNJTOi1xuV0GGFtHeR+/s3BIaFKkSAeBVDkTCw8do064SOOFkbDIzs
	 jnQ5ZueO5VbdDTgSSobJUO+p8axqMx9Oa/oakN22ZNBgR/Unyqw08C5LjNUaEJHf+j
	 m0ECv6oBrCivuaYNsKIdFvdmjwCNPw7rWfXYphFkZm8EuMTftB3UUah2gD10ARbqSH
	 1ohxeJgw6XWcNX9vf7eoFXaxtoGwQry9769LIJ5wDm7iegGfMMiyHOzK5iC9vjEFRK
	 flr+hNNLZntlbzvxaWoOB8PKonYND+aTurHfviXqeIvtVtIxGJ8NVbW3WJEK8Ly0jf
	 ePvlx8vQ1YkCg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uWbsc-00BbMO-Mr;
	Tue, 01 Jul 2025 15:22:38 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: Fix handling of FEAT_GTG for unimplemented granule sizes
Date: Tue,  1 Jul 2025 15:22:25 +0100
Message-Id: <20250701142225.753984-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Booting an EL2 guest on a system only supporting a subset of the
possible page sizes leads to interesting situations.

For example, on a system that only supports 4kB and 64kB, and is
booted with a 4kB kernel, we end-up advertising 16kB support at
stage-2, which is pretty weird.

That's because we consider that any S2 bigger than our base granule
is fair game, irrespective of what the HW actually supports.

Add new checks that will verify that this granule size is actually
supported before publishing it to the guest.

Fixes: e7ef6ed4583ea ("KVM: arm64: Enforce NV limits on a per-idregs basis")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 5b191f4dc5668..dc1d26559bfa3 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1402,6 +1402,21 @@ static void kvm_map_l1_vncr(struct kvm_vcpu *vcpu)
 	}
 }
 
+#define has_tgran_2(__r, __sz)						\
+	({								\
+		u64 _s1, _s2, _mmfr0 = __r;				\
+									\
+		_s2 = SYS_FIELD_GET(ID_AA64MMFR0_EL1,			\
+				    TGRAN##__sz##_2, _mmfr0);		\
+									\
+		_s1 = SYS_FIELD_GET(ID_AA64MMFR0_EL1,			\
+				    TGRAN##__sz, _mmfr0);		\
+									\
+		((_s2 != ID_AA64MMFR0_EL1_TGRAN##__sz##_2_NI &&		\
+		  _s2 != ID_AA64MMFR0_EL1_TGRAN##__sz##_2_TGRAN##__sz) || \
+		 (_s2 == ID_AA64MMFR0_EL1_TGRAN##__sz##_2_TGRAN##__sz && \
+		  _s1 != ID_AA64MMFR0_EL1_TGRAN##__sz##_NI));		\
+	})
 /*
  * Our emulated CPU doesn't support all the possible features. For the
  * sake of simplicity (and probably mental sanity), wipe out a number
@@ -1411,6 +1426,8 @@ static void kvm_map_l1_vncr(struct kvm_vcpu *vcpu)
  */
 u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 {
+	u64 orig_val = val;
+
 	switch (reg) {
 	case SYS_ID_AA64ISAR0_EL1:
 		/* Support everything but TME */
@@ -1480,13 +1497,16 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		 */
 		switch (PAGE_SIZE) {
 		case SZ_4K:
-			val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN4_2, IMP);
+			if (has_tgran_2(orig_val, 4))
+				val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN4_2, IMP);
 			fallthrough;
 		case SZ_16K:
-			val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN16_2, IMP);
+			if (has_tgran_2(orig_val, 16))
+				val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN16_2, IMP);
 			fallthrough;
 		case SZ_64K:
-			val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN64_2, IMP);
+			if (has_tgran_2(orig_val, 64))
+				val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN64_2, IMP);
 			break;
 		}
 
-- 
2.39.2

