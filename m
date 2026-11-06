Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793989921;
	b=X7SqxHQaXEmQxyHNt5RLVbX+Z1FCrOpStDQ2Uca++vin2AntxpEWd+jKVoeGI2kazKcN
	 vpF+KpJzWZeVGgjFhnsVDkDFnA/C5T899j1OxKQViD+sZ6nQ6wA1Np6rmH9k1hNtqk0is
	 ctI2y7u7OOIwuDdRzvBJxOVU28huwO7jhb7AEm5KLFFthbJl599zp4XLip01EcqPUHdEl
	 uJO2Jr8/+ogGcpUfWrrtzw0ahWGSCI0Ho/th/g0bq4tFW+zq9nogRP9e7EzbvU2w0KWjm
	 Sl/IUUTwwOMjO43IsH4ADabhKQa0AYUtg5jmBIQbTu7O0OaGMyDHILbhNibxp/lpkBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793989921;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=FAE94lWpgWKKeCb67HBpGAQrF4M07C/IUhlefBjBE3g=;
	b=JaoLK7auJV1Z7m3ujjtMLb/GplyBqjgYw+CEFAH/T1TIO0L8Cj/zN0655VwXASwlMiiQ
	 qPOA8KlDh226m6Yb2/XypIYa3nnBBlpkckEABig+L9/rqWLF8q3LZRWMFxXhv0eWsVbx3
	 QSz3ufdd5PfB6cph2fLg3UqJKL7KMciUGn/JoedSSqSCQMWLAw7SaP8jXy6KQtjPYKgVd
	 f733oCRNO8VuSzEXde9+bOCsUuF+JQDxKxPoWjIoUmyEf9WBp+nv7Qxz/L5pHwpU6ixOV
	 8j2PJc9UOqXt0XXYlBJ/cBLg0Qnvqt4afZ4TjNl9PzL8x/AFUTlaGE2oahnO7BhxSGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VKv9DKK6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907B2606A32C
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 18:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VKv9DKK6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC3F1F008A6;
	Fri,  6 Nov 2026 18:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793989921;
	bh=FAE94lWpgWKKeCb67HBpGAQrF4M07C/IUhlefBjBE3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VKv9DKK61wYY6qQCS//ordwfv4tC2qUKctIvtDLhsxwo/9LJnf7i9k8frWnTKTv90
	 Jqb1NEqKPp53jnr2N7MAdrw0deFH2SoTug1o3+JWBQMIJGYj9sm4qgAI7H3x/EZWDF
	 WYBiBTqUCZRbzHyPAaPR4y1DDJ7Mxn/icBB2F5dJmlqtRCE1FTBkyuPX3H4e+xs/D/
	 /mA0+HO1AN5n9AZmF3/91Ie5+k5eNqxJjTpSGXKq7Jepkd2GLYLOjqjV7JjzDcYJ8f
	 T3fXJMbUOwz02pu0oaqluWnE5Qw1Z5aN6CFDMCp+319kCyhBJ82A3hGNycUys9tzys
	 hJFXsdYJkKs5w==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>,
	Leonardo Bras <leo.bras@arm.com>
Subject: [PATCH v2 2/8] KVM: arm64: nv: Add CGT description for FEAT_PoPS instructions
Date: Fri,  6 Nov 2026 10:31:48 -0800
Message-ID: <20261106183154.3590825-3-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261106183154.3590825-1-oupton@kernel.org>
References: <20261106183154.3590825-1-oupton@kernel.org>
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

The DC CIVAPS and DC CIGDVAPS instructions are both affected by
HCR_EL2.TPCP. Add the missing CGT descriptors.

Fixes: a7484c80e5ca ("KVM: arm64: Allow userspace to request KVM_ARM_VCPU_EL2*")
Reviewed-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 2bec81668361..d04ac5203454 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -747,6 +747,8 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(SYS_DC_CGDVAP,		CGT_HCR_TPC),
 	SR_TRAP(SYS_DC_CGVADP,		CGT_HCR_TPC),
 	SR_TRAP(SYS_DC_CGDVADP,		CGT_HCR_TPC),
+	SR_TRAP(SYS_DC_CIVAPS,		CGT_HCR_TPC),
+	SR_TRAP(SYS_DC_CIGDVAPS,	CGT_HCR_TPC),
 	SR_TRAP(SYS_IC_IVAU,		CGT_HCR_TPU_TOCU),
 	SR_TRAP(SYS_IC_IALLU,		CGT_HCR_TPU_TOCU),
 	SR_TRAP(SYS_IC_IALLUIS,		CGT_HCR_TPU_TICAB),
-- 
2.47.3

