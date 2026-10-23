Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792789041;
	b=NZjYOYrkauiHnjo/rVmwLEN8YNh9uBl+pmem9fgzyqtqpaoh2DGtPvpa0EvHm8J6ojRY
	 rV8do+rDpq4VBIGZ719XlCPeZ+dQH+TAl9Cam02It3UW3mbZLUUPt2+VX42sne6sql7lK
	 eDIZurxZCkNt3D4VoYaRxNN2ZNbiWgaV2nWQFy5FV4Yw55a1JcfTp1Nz85/tY4AvThSQJ
	 aOuAsPzhHh5S9Vhq/IkeLGvzRynmydAntSJwYyrac0v/3DXUCmw/+oYEHS26VgdrwDyvC
	 y54RJKuiNuZ5EKGDArbkGppSWv18dkeoEmeCOH6WhSsZz1SzqYyS/W56ZenPGJvV7RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792789041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=xhgZHoVfKBPNRATxJ5oMiRmhlFrIVbhzGnpHflUS5EA=;
	b=5PuECY/ZF2RNaMZyzJNZkZ4CkuxQ7hOm4bvQJ5kw8vHkGFDoM9Lm1apcBYcdwHxVlwfh
	 o02hznJYZermSrOyu2Bum3Apj/fivl6tZTGIY9gDkr82/pGVbSl6jqfzqiq4xippRuimP
	 zzz6VcdGucBZm//QuQkxYoATczHAG8Lst1NFqWs+IwI2xN/dVshrWx5bJrUYr1DmOritz
	 GQ/2YA3DURGq6RAVWXXQEzBQrr1LDt5/EfPU1/9SZ6FADHgUHNVz+Si556ZOcok/aw8wd
	 PzfvVTn7QMZoF76pA9DOyWtyB0sZ0UQ4rnb6OUHRfkRUNZne15O3OQl3p15JeqKyyAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eAeCzVAh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA58606A31B
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 20:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eAeCzVAh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB7D1F031E0;
	Fri, 23 Oct 2026 20:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792789041;
	bh=xhgZHoVfKBPNRATxJ5oMiRmhlFrIVbhzGnpHflUS5EA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eAeCzVAh6njwHlmPUlgy+qNwGNf8Z2riHicE8pzIyP6kobMJajwQ5kluLE+xluM7g
	 rAtxe2V7emuat2iml9rq/TWZh81m+4a7d3g4WC2BlSLKWeI5SkFPF/xFx1fu/oTIrT
	 qAB6/Xp2yFkBi+gxoCUAXrhtzIMDMe97uzG9ghcsbBlwWojVW18zkTVy1Z8wUN1GJo
	 DlTx6+6WeeOULdoZveaK5qMODpmmuyI5qfe6eqwcGuilulqBK1IDB7FnLX1TOTZ2RI
	 NABGDMi1Yn3IzY/0Ad2BkjELD8/A0PoC9l1s366t68Dr6JvyvEwIvWMVzBsNPTK0Gu
	 MmH5EmF0UOdpQ==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 21/28] KVM: arm64: nv: Expose FEAT_HAFDBS
Date: Fri, 23 Oct 2026 13:56:03 -0700
Message-ID: <20261023205610.1044532-22-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261023205610.1044532-1-oupton@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org>
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

Everything is in place now to support hardware dirty state management.
Flip the corresponding bit and advertise the feature to the guest.

Reviewed-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/nested.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 46fcc75f4c20..eb20409a14b1 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -2040,7 +2040,12 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features))
 			val &= ~ID_AA64MMFR1_EL1_VH;
 
-		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR1_EL1, HAFDBS, AF);
+		/* FEAT_S2FWB implies IDC */
+		if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB) &&
+		    cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
+			val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR1_EL1, HAFDBS, DBM);
+		else
+			val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR1_EL1, HAFDBS, AF);
 		break;
 
 	case SYS_ID_AA64MMFR2_EL1:
-- 
2.47.3

