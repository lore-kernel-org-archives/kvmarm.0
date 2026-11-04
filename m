Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793820087;
	b=jH/wRxEuYkbtDXC+FMFf+HENpSULUpVDbLt6Qnniq7n4/jwK8YR/tPGcIenxgP3oCbuO
	 rQh93LlWtrCGiPNtOJM7FKBhB/FnpmLDC0aj6R2afFHSOSBHlYHngu5e4pZtPYe7Z+2P/
	 Sa0sLeV1VnGm6JfA4ycG6M9udmAMiKNO46pRrWqdXzpAE17Ytj0RbEGDmsUdst0X+tEfY
	 pqQCtS/ZsjldXlcO4G0TR2jI4lzKUmV8x4Pte3168l/uPg/p/WvEHZ2oFcOvHi6n2YDKR
	 f2bW0WJZSmiN0owELxsOxX8xM+rytnrPGBqyCU0Jsyl+7nOfi+ttTtc5x72yCMeQ4MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793820087;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=zdElaTd7YRVsFwsDycYRrDENHLjE57PQRCsvjvBpX4Y=;
	b=HihNxbodsxH+CjH6EaEXSntZef1ZFpgYZn+JX9XEmPMrWkvZ7Tr6Utc3LmrpOwNMYFig
	 xwxHtsLiZ7eKHuuviKyIeerqHZgz4ZYghi0JlU5tbLg3soQO2RBjTP2DuY3r4FCvcu0q2
	 4zc++mZts1PZX32ROkRaHkX3/IbnjmkAfXO36YcMAdNoh/8PfzA8rJef+38R7XlzotEZe
	 LoyVMDfM4LXINwW+wu/X/pgXnZLbJd4x9Ch0xpdC6UXZWHjRm++QwjQ3+0rJqlTgaamGC
	 guRY+VlrACcMxrVPP7o1JZ+lOMtxM25/C083ScmQl0On3Tu90rgQj5prBFN4P1X7Txg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LIwCyfR5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41126606AB2C
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 19:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LIwCyfR5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF61F1F00A1A;
	Wed,  4 Nov 2026 19:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820087;
	bh=zdElaTd7YRVsFwsDycYRrDENHLjE57PQRCsvjvBpX4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LIwCyfR5iFbeWLDbUDSWUmMJ/qcohtNOuooIROop2AXyf/OKeBIrEqj7zlOPmSsfg
	 uY7QCMaxuXrMOnHNFlMXkcjBZUiKZuHoMFzdWjli5swWaEDpzb9YVUjHz0n2c/JXLL
	 Xm8A7DPpBbB3t34+UJ5/jGOUPOq2QshN6Jmt583YGCM2FG12A5qPVnxQ/tt4gEPOZ8
	 aX68vCb/7Zhe+EK0GZVHOFYil2vm7wemznOv0LGHSsoYNlKMQoPB1Q6UJ0HXgpDLeW
	 gwoFq85SZ+Hr2wV51nxPPfy4Kwhz+VrpYpVHg0ace1XXHnr/oSAjvl4vs8UsuyKq+m
	 NhY8oV1QBLmwQ==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 2/8] KVM: arm64: nv: Add CGT description for FEAT_PoPS instructions
Date: Wed,  4 Nov 2026 11:21:18 -0800
Message-ID: <20261104192124.3932743-3-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104192124.3932743-1-oupton@kernel.org>
References: <20261104192124.3932743-1-oupton@kernel.org>
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

