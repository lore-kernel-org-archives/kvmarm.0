Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792789010;
	b=MQn+F7FmQazeMrETmKrABjfVpHJRN5Q+Rn8tV/qIb61Jh7P2zC8fFf4zHxB4xZtb9WR5
	 xS/kOiJbLBfqyusaq9UtXoURJGtQ+ertJJtUomKWpb31mfKOWW7Jcx1XrzRYhqKjlh5EY
	 vG3uKEiSh5MVAPdFb9OhjxRG3/o1pPTQQ+D55TfSx8xklzobWlplB3xFiRb2Gfg2+EaeY
	 y54BhsAfiid7MXsBCZencriKmmt2My5Nteo/qklRSMm+MAGnFaKbK6mbpBG+I98xgu+G2
	 OSDO34FKGjcDQ1Jjh4MwtHLHSJc2g95mgyKnSb190cnU7K985JeQC6rTbj2DQ3WHhPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792789010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=sD3mGCV8BL/5Gs4RekCtJWpXYQNGxsgu5WEzJ4j9V4Q=;
	b=s5gPJJA3d3UeSXc/JUbHbSQYAFfSqSHGf1CzUfg2E2YK08DEXSM5H3BXbrXVezTeJ6aI
	 lt9gIH6ePdV/1QwRrGiBqzX+JpeRG0BZySNoixxA1ehwZNh5AnwBNY/mt8ZdToSYIXFS4
	 IOuiy+KtKnOp74RNpoMboEdrsxLJYA9Js04oqqHbrOP78stBr+2qN6lgtTXhsVow6yilu
	 kpejdFgchsgaa1awo+B96N9csDy86NCQMKsuPFswEGTtSW2BU8guJCeT6lPP0Fz8dYWH1
	 9HDqZU3Ge5or7b5PQRmD38XDAnCbXkv6QeK+w12u68OehpdGMarP8YkZGwkoF0yTG3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g4gbhFtl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8E3606A320
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 20:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g4gbhFtl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A6B1F031E3;
	Fri, 23 Oct 2026 20:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792789009;
	bh=sD3mGCV8BL/5Gs4RekCtJWpXYQNGxsgu5WEzJ4j9V4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g4gbhFtlKRG0r7FgHGKnUjBLPTt/Q2V1eDztiygGkzorlssTf6GEBT9t2PH/cFwaW
	 TdOv0fJ10WeX/MoGGjHkpVSXLqISkJc71exrhnvecBFOT5Skf/kKizslvBI/hdFPq7
	 a063iN3eKkL84VfiwGaXSx48rh9lurTlu75SUYXZW2YEuFOMHh3PyEzQ3QdLDTi0A5
	 IPl0DDhHkB4Vv4bgc0vyp4K0sjyJFrTH8s3wqyN+66yMV2WEF2xKE/H0SGRuVhJ0O3
	 6d/eaW+fkBJ09krzvqcJ6FlQaSQmQROiBm9Z39ZB4O9ev+2RwWYW+gKdQOCdixLI0a
	 pST83PI1EX/7A==
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
Subject: [PATCH v2 15/28] KVM: arm64: nv: Respect HD when computing translated TCR
Date: Fri, 23 Oct 2026 13:55:57 -0700
Message-ID: <20261023205610.1044532-16-oupton@kernel.org>
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

In a similar vein to the recent fix for FEAT_HAF, propagate the L1
hypervisor's setting for HD to the translated TCR_EL1 value, allowing
FEAT_HAFDBS to be used by an L1 hypervisor in the EL2 translation
regime.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index d51d011fc68a..11944dfb204c 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -30,7 +30,8 @@ static inline u64 translate_tcr_el2_to_tcr_el1(u64 tcr)
 	       (tcr & TCR_EL2_ORGN0_MASK) |
 	       (tcr & TCR_EL2_IRGN0_MASK) |
 	       (tcr & TCR_EL2_T0SZ_MASK) |
-	       ((tcr & TCR_EL2_HA) ? TCR_HA : 0);
+	       ((tcr & TCR_EL2_HA) ? TCR_HA : 0) |
+	       ((tcr & TCR_EL2_HD) ? TCR_HD : 0);
 }
 
 static inline u64 translate_cptr_el2_to_cpacr_el1(u64 cptr_el2)
-- 
2.47.3

