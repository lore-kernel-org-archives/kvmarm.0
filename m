Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060AE324B22
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 22:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763419415; cv=none; b=mB3IXpwg0D44t0aQoqfpcG2u3Hd7L5gD0nt+MiwHtg5GB8xBskFMD4eu0dvlsbFePrgXLx0UjejMaARnxSAFGzCmZrTrSFzMZkJ9oBU0NDnFT69WYlx1lMtkkiWmb4tY2ZAOAPlieZZIvcoYqJayGBOF0CmRuL9Hlj6d3Nq6mAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763419415; c=relaxed/simple;
	bh=JkPZ4r0bcsp+Er9TnUJQEeAzrNHw96bBA6KDxB60I7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gv2H0KVsOUYt8LR4GoVhJkYQwDPpvR1p0kRTkJizUgGusZGSQcgfEJ+2a6Gfp5TgB0+5MvU2szd9hZty108rXL/DwX/x37U1ZMmhIk9WyW2Kei6Xk688n5moP1YjAVUcV2QiB3rO7k/61cXcsMHrU2Z+a9t2S4rEv1NkC6GwKzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VrQ9Jx9o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VrQ9Jx9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F71BC2BCB1;
	Mon, 17 Nov 2025 22:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763419414;
	bh=JkPZ4r0bcsp+Er9TnUJQEeAzrNHw96bBA6KDxB60I7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VrQ9Jx9oOJVoL7HrXQlzD9QFWgBkSkEeL1sV/R5KxCteQZb2xnunSyN0BuKnMnoLu
	 L0IpSi/jEWajT03sbzhN5o4kX88GOfvSzsKBNs0wqXA50rUEbK4dBJ8dxyQLxeM4u4
	 +a94KzKSdKs1/51RjPampeKesbkQVsXpQeYi/IXZSbO4XucrGcLLA53Adb3T4d4vHr
	 adfsMHaMsaLFNOHp/+/+NLdD8/PiB4Hfp0VlqA+zovvo0QEQWRoq9/hNNxW/zyV54l
	 +zG+gSbn0CoCK36EUJOj942DPMigFQCV3iXJ0eWiRQodepNVjtdeAJ3mspgN4sEL3P
	 VJP9fnHXLv8pA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 13/14] KVM: arm64: nv: Expose hardware access flag management to NV guests
Date: Mon, 17 Nov 2025 14:43:24 -0800
Message-ID: <20251117224325.2431848-14-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251117224325.2431848-1-oupton@kernel.org>
References: <20251117224325.2431848-1-oupton@kernel.org>
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
index 5921b66279b8..dbd3900e8bff 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1603,11 +1603,13 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
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

