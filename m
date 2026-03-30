Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A64B2E091B
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882151; cv=none; b=SSidTEYIsqUcEgeA9jOoNWFEFGc02h1j/heEJ58qZ05Goz2Te2KOT0gZOpJEhkyu8k+/Wk8fL+KYHSk3wWwY2p89MHHvde8cNDQoHUB3gU68x0JbZvZFVJG46FVbxXXCTivdnGbff144lV2ZCoCZtZLBNBui44nOdUGQ9UqcUM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882151; c=relaxed/simple;
	bh=ow7XJsMmy3N9br36ooPJfkzHGKyMX+Ym+pCiAfKaBdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJ7A90pjwqcOoyyTksX0RpcnlxxIpRUzFuOvtLKWPkxS3ZbbvTr9cgzN7u3mtnYZJOKC4wYXnNOebG9/MHldLcQmD6+xLZ0PMeoMl1iKNfFN5L67OXQIVYBLBR6NczSe65b3q2+1bBIkxtNXWwYdxOlCsV36Tx3IlMpI6OuouNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lFqFqj50; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lFqFqj50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5454BC4CEF7;
	Mon, 30 Mar 2026 14:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774882151;
	bh=ow7XJsMmy3N9br36ooPJfkzHGKyMX+Ym+pCiAfKaBdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFqFqj50wqr2FJViioFsNc9/xL2EuLqR6jXGF6Z/MOtfJQ9BCUl44tzp6ti+xvG5D
	 IdCmLt/223LdESYrVQlR4EX/VrFy2cpgX91nWRvfM5LSU9uA1GYIkO52L3vu+h4ZwE
	 VbcGyrV/EbWfBmherpgyHGDl3ji7AooM/wHQwntACvNC5j3ZKdqQhdHuOvZlO0i81h
	 2U8hDyqiHlEvCHNfJycsHGOkGczb5cRd5lH3CvyJpLETrg5ixfjOSCucdHLwtqZ6Ta
	 iP5VdXcJQ3tZELv7/zjh7WDoPc8SUqNfPzDUmEQqfnGaythR2pkFiVn2hePslG3rP8
	 tBJZoU8DRJ28Q==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v5 06/38] KVM: arm64: Expose self-hosted debug regs as RAZ/WI for protected guests
Date: Mon, 30 Mar 2026 15:48:07 +0100
Message-ID: <20260330144841.26181-7-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330144841.26181-1-will@kernel.org>
References: <20260330144841.26181-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fuad Tabba <tabba@google.com>

Debug and trace are not currently supported for protected guests, so
trap accesses to the related registers and emulate them as RAZ/WI for
now. Although this isn't strictly compatible with the architecture, it's
sufficient for Linux guests and means that debug support can be added
later on.

Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 06d28621722e..0a84140afa28 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -392,6 +392,14 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 	/* Cache maintenance by set/way operations are restricted. */
 
 	/* Debug and Trace Registers are restricted. */
+	RAZ_WI(SYS_DBGBVRn_EL1(0)),
+	RAZ_WI(SYS_DBGBCRn_EL1(0)),
+	RAZ_WI(SYS_DBGWVRn_EL1(0)),
+	RAZ_WI(SYS_DBGWCRn_EL1(0)),
+	RAZ_WI(SYS_MDSCR_EL1),
+	RAZ_WI(SYS_OSLAR_EL1),
+	RAZ_WI(SYS_OSLSR_EL1),
+	RAZ_WI(SYS_OSDLR_EL1),
 
 	/* Group 1 ID registers */
 	HOST_HANDLED(SYS_REVIDR_EL1),
-- 
2.53.0.1018.g2bb0e51243-goog

