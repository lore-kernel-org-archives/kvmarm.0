Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DA83538BF
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 18:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762972453; cv=none; b=T80gi7SKO/EgnR0Q6pu5xh3Mjv9yMjuPQffdsv+dl2f8du+s7fFt7WqNooRR0cQIj1+Ny9ECWRyMXEAUXJk0vCp93W8qaTgUEujBwqhO/1mrsBvB5bnliXEOJqJuWe2g+a4gfUyK1ELF7Iz5o6rXE2VYGRNlbU69w+vxSFkUCL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762972453; c=relaxed/simple;
	bh=AoYmfGcJUp5B9mI/GW58GpX5IuhJqktu2/eHnlVBJjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmZ0Fz+8JlLpzJPyz0DZRN1rqeoFn5IoJFCxI70ZkpuONWhdUSH0cPsVxLogPHgMDTh9413DDOzDxpsIaWqMsWx4pBF6tqq+ql4zpzTbbPH+uEfZlhAanlpjZmnn4yogjYC+NrzO7qpZSd9XCh7uQTbz57rYsnHRql+dQUWfR0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cL5EPN+w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cL5EPN+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0483DC4CEF7;
	Wed, 12 Nov 2025 18:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762972453;
	bh=AoYmfGcJUp5B9mI/GW58GpX5IuhJqktu2/eHnlVBJjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cL5EPN+wgPNcPWlcM6/SRegDK4nwB4WzFx3iUT6FkVP4VqLniOZaV6oSsXtQASG81
	 GiyqCa8KoDDnywKjIlvtduEg9f7o4xa+YKd4VUnlzV8jLnpbpElx7+igN/fZPedOMX
	 QSCLOgujeNki1ay3Nf9RPiShtIYt/Rli4Qfk2NXm+FhgLKAsvqC0stTEIHmELftwkq
	 wWcsIz2WcC/pNvdStPvYHTweAxIgAaarFrP11UgclcWy/Q70jPKd1mgfDkxkY+Czjm
	 NWqisEFnVCdOTDLL7CNvZILRnH9Ey5JCed+LpqmOIOCAXRo/KtyLAhni9/qu2Wc8eU
	 VJePpFc3feoUg==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 12/12] KVM: arm64: nv: Expose hardware access flag management to NV guests
Date: Wed, 12 Nov 2025 10:34:06 -0800
Message-ID: <20251112183406.2118981-13-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251112183406.2118981-1-oupton@kernel.org>
References: <20251112183406.2118981-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Everything is in place to update the access flag at S1 and S2. Expose
support for the access flag flavor of FEAT_HAFDBS to NV guests.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/nested.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 7293769dacf5..2914fd20ad1f 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1601,11 +1601,13 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 	case SYS_ID_AA64MMFR1_EL1:
 		val &= ~(ID_AA64MMFR1_EL1_CMOW		|
 			 ID_AA64MMFR1_EL1_nTLBPA	|
-			 ID_AA64MMFR1_EL1_ETS		|
-			 ID_AA64MMFR1_EL1_HAFDBS);
+			 ID_AA64MMFR1_EL1_ETS);
+
 		/* FEAT_E2H0 implies no VHE */
 		if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features))
 			val &= ~ID_AA64MMFR1_EL1_VH;
+
+		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR1_EL1, HAFDBS, AF);
 		break;
 
 	case SYS_ID_AA64MMFR2_EL1:
-- 
2.47.3

