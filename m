Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA9D3F20EE;
	Tue,  2 Jun 2026 15:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780415683; cv=none; b=iSJr7y4cSd5XXjn3ImRBSUyHIgBoEaG3LLTR/HKeS25JN9QS9dGCiaXTlcgC31AIvdXdgDqqiIgPDHjX2lQhUl0qkWFsWGRj1ZVDYppGCjjN58woPzl55xpJo4gJPwm+sYhElTY4UTjkUd6ylvt4WkTd8m8B7lS3opLPRPRI6lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780415683; c=relaxed/simple;
	bh=HQIvd+2o/7ur5Wj3ZDqOjfG4t0on/yzr4yEbthfh2U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KES3IMXy6I1dZPDk1SMm/BKW24Ue+D9j7zZrd8mZ3plOo26wFOaGpLpI3UBEzhLxcdZy4Vk8p2cZzRAVZvF4yudV3yoA5SbJg3Aaszrm+IlJjZY9GSSvh2CV67wnAA2Na2Cz2v/5TJrrM3DXXk4YOiDkCoVOr8yMc7sr8uguE5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gUv8EgRw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gUv8EgRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396F31F00899;
	Tue,  2 Jun 2026 15:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780415682;
	bh=lzl6t0t3qxJibjJvjA0dSccYkRiILP6ZySVO4tCSiAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gUv8EgRwvEG6JaKaDfOvjN0ue2cl04+4oQ6798Nb6yLtUbBeeWtFrmdDiJaHP2wE8
	 csahU2BiCLpOhGUWbK7y4sTZtaOevOQCpsVOq4nX5IwriXwdCdxb3ia8rvsBRHBH4S
	 wyFxzF6bQu861yZpjOlt+nxuoj73zVlKc4M8WDp89jiJpM0LaOqvOAMuwGhxjde4t7
	 yLKZA9t4QfbaF8RpX0go5dPA9BS4xMWuQJmlPcF0TMACBfy6StwlXjkm5B8vE3ducZ
	 3JKSwmg9hHej8kz9Uuno16hAUggsZXz6R1KsDmla7wRNjzwz9jUVVj0AGkWkN6TDWL
	 ir8y5e8uwD9hw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wURRw-00000008fVv-213V;
	Tue, 02 Jun 2026 15:54:40 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 3/3] arm64: cpufeature: Expose ID_AA64ISAR2_EL1.ATS1A to KVM
Date: Tue,  2 Jun 2026 16:54:29 +0100
Message-ID: <20260602155430.2088142-4-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260602155430.2088142-1-maz@kernel.org>
References: <20260602155430.2088142-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

KVM needs to know if the HW implements FEAT_ATS1A in order to correctly
sanitise HFGITR_EL2.ATS1E1A, which otherwise defaults to RES0 and
AT S1E1A traps are handled as UNDEF.

Solves this by exposing ID_AA64ISAR2_EL1.ATS1A to the rest of the kernel.

Fixes: ff987ffc0c18c ("KVM: arm64: nv: Add support for FEAT_ATS1A")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6d53bb15cf7bb..62b0d77217eeb 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -266,6 +266,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar1[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64isar2[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_EL1_ATS1A_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_EL1_LUT_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_EL1_CSSC_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_EL1_RPRFM_SHIFT, 4, 0),
-- 
2.47.3

