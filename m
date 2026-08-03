Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56905371D02;
	Mon,  3 Aug 2026 23:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785798834; cv=none; b=KHYpRvKOyj0ucSoFIVN/rx4n/afwnEwwmtfG6rchCjJ1EvaNPsIPfI9YCZ9KnaQkY4QsRgpTRDcQgzzbAzvuw1ybmhUytpeLMpaEV7TNAuytKMUYTzFyc82tWn4LYIjIAeRerHkK1MoBQwmx76hTfsEt+aramIBUmwPCz0Cn2SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785798834; c=relaxed/simple;
	bh=cmvAQBxB4SuCRvDZjmRe7yIsmwDDWXuwPP1P7cDHpHg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=k8kVN5qqvEQ1BzN93yP127Bvcaa1f2mNMi60KWGxmJJztrAJdzAQWUl4BblZPoafM/ouwHuRjqnUwGxpnB5ib+XaDcJgFbZH9dJfk+mbEZe1xVLxfYa8Kj7Qa91euJvL62TeRbD+ll1xsQiFxRGZOFBFoEHTgznHpqPd5sduIVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n1B1ZB7N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n1B1ZB7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F49A1F00A3A;
	Mon,  3 Aug 2026 23:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785798831;
	bh=YWlLd/PWbYINVwpXcYMDnYu5TnVLNXcprwUMzPtexF8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=n1B1ZB7NZk/zoYIXJLELhvaOM9ee9r5LVdnVLFMQMZsrlnvmIdWA+QekBRoe3mAld
	 wP8pfbEDj80MlaUqf7PJI5to074itwnVO+jFmV0VJrRF06BnHYy1VH2v0Zq2JHYW11
	 VB9d352PsFVMr74/vovZl17L9KshF7Wd/TuxDLQ2c5ur2To0jmdIMYMeuDKp+uRtWV
	 zBXoGsy1zV0hu5UDplg/4twF1AI2CUGde8uqEUHTUUPV6sGINervfzYzN71HSqITe5
	 T/KEUrGie3wI1HZ71MxeNFGXkjyN4d6LOhVP0CX1jx5x9/KNA291EAt6LqEtDWPOhq
	 7bReHO3mfm8ig==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 03 Aug 2026 23:56:47 +0100
Subject: [PATCH v18 02/14] KVM: arm64: Fix FGT mapping for
 HFGITR_EL2.nGCSEPP
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260803-arm64-gcs-v18-2-fd8c40f5ad88@kernel.org>
References: <20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org>
In-Reply-To: <20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Oliver Upton <oupton@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1184; i=broonie@kernel.org;
 h=from:subject:message-id; bh=cmvAQBxB4SuCRvDZjmRe7yIsmwDDWXuwPP1P7cDHpHg=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqcSCbkagjMfsbLEpGUmar5p5Ty1V7CBLnEKnXQ
 ra30SaQdMOJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCanEgmwAKCRAk1otyXVSH
 0PAhB/9mBKlZ9sVJgzTIjaFaUlLo2gm1JQgfsLOHRI6C9ty/0BN1X7qgdk6ZxWd3wzBBIPCYqrj
 IkzEXO5sLn18xJK+vWZxGakaHibAVq8z/fDea75/tAKJyMW3jK1i5Ypo218kwnr7TMA9crMVpV2
 x2H8Hxj9pFwJyoOrDU22vdQnfjMB8UhlTesrZaTvGn4IkKzHKGizQQ241EoRZz4o+vMsJ//EDsH
 ffcB2O+ppdot5+e/1l9sbdToya2Chjq0TTMyvSEJMMmqL/iJVNqPXLQmx8qpA0ni6iciKzN4+cN
 YTh1cd8OWdeVI7abMF8P7TUTR51VzLQa0mcGkLjbzWt6ViL+
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

The encoding to trap mapping currently maps a FGT on OP_GCSPOPX to
HFGITR_EL2.nGCSEPP but as per DDI0601 2026-06 this FGT controls trapping
of GCSPUSHX and GCSPOPCX, and not the separate GCSPOPX instruction.
Update the mapping to reflect the architecture.

Fixes: 863ac38984a82 ("KVM: arm64: Add missing HFGITR_EL2 FGT entries to nested virt")
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 3c82f392845d..b32742d9dd73 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1432,7 +1432,7 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
 	SR_FGT(OP_AT_S1E1A, 		HFGITR, ATS1E1A, 1),
 	SR_FGT(OP_COSP_RCTX, 		HFGITR, COSPRCTX, 1),
 	SR_FGT(OP_GCSPUSHX, 		HFGITR, nGCSEPP, 0),
-	SR_FGT(OP_GCSPOPX, 		HFGITR, nGCSEPP, 0),
+	SR_FGT(OP_GCSPOPCX, 		HFGITR, nGCSEPP, 0),
 	SR_FGT(OP_GCSPUSHM, 		HFGITR, nGCSPUSHM_EL1, 0),
 	SR_FGT(OP_BRB_IALL, 		HFGITR, nBRBIALL, 0),
 	SR_FGT(OP_BRB_INJ, 		HFGITR, nBRBINJ, 0),

-- 
2.47.3

