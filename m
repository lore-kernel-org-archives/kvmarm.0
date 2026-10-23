Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792789042;
	b=bprj/wJh+h/hy0v2EjEIHZa9wNhUf2Xd5ozUKWVD5eLK6r6xK39XCsBe0h96xDfWO53O
	 xeCsMESzb2kycLWaCRE6R774Z30hR3sABCEkS2o3RLy3n7TtMI+rth4rS9zRBYalUtGWW
	 2lkCQQ+BMstr3cXUv1KaeLolpj8g1dhUTfrDC/Jx6SATmDiH/dz0xFQIEsAyHf34Pd2nZ
	 NYPxCny6V9tgP7ZG/+Ap3gb/Nv5UkqcpoOaPwV2SqfV9LsBbi+faF+eIOINpvyxhKCGlW
	 yfFQc6pSz+EkBDPrdORL1pe+nYJQVoR+rPL7hKWgS0nEGYAQtkP2TDrxLCPydBVhTVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792789042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=g/QP0M32Fp7JIq8p7pO19iKh514so/hjbeFUaOaUHjM=;
	b=awSl73mozVtYTrpEHuAEm3kkVXEZdnTctDllb00lhvYXZBz72kuhmbXMdoQ9ufsahqDX
	 JoAh1+8Tj5EUjD4bMh1FAXt+yi4B2DWfWdgEQeA+K4AsCXDX/baVgk9qGiT+Rr0QW7eNK
	 +NZGrwYJijIVkFpwoVEF/dpfgwh9tfm4OaIMg/fJPWaQghtm9talHhPFyHobIVKdFQZCE
	 OpvTz+Y4fET9jRg+lYaQPHM6o8T+ek8V0Lhvjrs1Y22uDA0RNBR/CcElwcP/6Tv+poCih
	 wJqz88vppxpjASpjpWHcsH3p/3S2lahKVDATwvunhbyVWDTmy3PAYx/RiJDTdyLo/Hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=feTlWc3j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB19606A31E
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 20:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=feTlWc3j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC171F031E5;
	Fri, 23 Oct 2026 20:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792789042;
	bh=g/QP0M32Fp7JIq8p7pO19iKh514so/hjbeFUaOaUHjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=feTlWc3jJ9uhx6+I4krYi+LPMivBl9v/Rjx+8/7+RL0ehWULmiSqFxpFbaFVVD5yD
	 fKKmeuNmvaWquYhBeTAXmPB/6pi0lA4SBDHftLEVt8wZgs6IfXURMjV866rNstWoYU
	 yvuu564LbI9etVq6FsXNKK3IePvYthpMieK75Fn5XE4tiWQQr2UMPymQPPo+BPjNCd
	 qiQXIqWQofu0VoYBlMNbo3UP2lKYjlwNqql4Z+c1QxlJZDsBh5imOUL9oKTAOqf822
	 BEtzBsNpyZKqaq/QvufNVfxS/9CaFJoCkrSor+4ISPQMpR5STJUlRp5u9S/SAZYfXc
	 c7iYWpnYEWijw==
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
Subject: [PATCH v2 24/28] KVM: arm64: nv: Expose FEAT_HAFT
Date: Fri, 23 Oct 2026 13:56:06 -0700
Message-ID: <20261023205610.1044532-25-oupton@kernel.org>
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

Both stages of translation now support the access flag on table
descriptors, advertise the feature.

Reviewed-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 5ae818a70ae2..0c468235f123 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -2052,7 +2052,7 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		/* FEAT_S2FWB implies IDC */
 		if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB) &&
 		    cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
-			val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR1_EL1, HAFDBS, DBM);
+			val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR1_EL1, HAFDBS, HAFT);
 		else
 			val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR1_EL1, HAFDBS, AF);
 		break;
-- 
2.47.3

