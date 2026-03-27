Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304852DF155
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 14:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774620071; cv=none; b=SCPzn7dLvq0dL6t4ByD1AQHbO3Bg1GSWTJipbzL0epM5au6Rm+LE0yk+crZ+J++e5BgNnavTxQwSJwfkvMMA3OTx82fzqFNPUiZeEDpNQRFGumXVDN6tOUH7fBNaD7x9l31PMSo7igqYMZqjsgvFjOnGLm34Ewe0cikyiS/ejk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774620071; c=relaxed/simple;
	bh=ow7XJsMmy3N9br36ooPJfkzHGKyMX+Ym+pCiAfKaBdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NpJ0ccP5ElqM/eVm70nibhAaeijbcuSpHDxWmoF+lo4QXn3a+3yWUSB65tGa7Nr0g/welJRCkwVhiJiFTPZH8/1ITC08N5oOxiSFo65uzoF5jMIh+JC4AniowQjgVYeyC5r58NKbtnpF5m1w/QvXPXf4tnuogIsuG4rpmZ1WTwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fpdPJ9rE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fpdPJ9rE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC2AC19423;
	Fri, 27 Mar 2026 14:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774620070;
	bh=ow7XJsMmy3N9br36ooPJfkzHGKyMX+Ym+pCiAfKaBdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fpdPJ9rE4C5ofwCxzMs7Rwxv0FmPNhAVVzrGNogUIMJsH8eZA+AFXT2Avk+4I4e7y
	 HP5ppWyaymTseJfGmYRfK7XqfmogtEJb2VKCQCOvu6s5X19/kJ2WiXy+YEiYIYNp3q
	 WXKv1yS1Oar9YDC9Q+3pQG8EAZDdArY+smPLKW/v/NRtQCHNQk3qJ8M0gLLEatx/3M
	 2HHxoLFde0BzYGEI5q0YEvNcTQ47CN4AirPAXRA39FXahTCcdcwirM+OJPsp6svLwb
	 RCRyRCpjUCFXw+Cfn+Gp5h329VelFFptXbmiPOSS+PoitdrijKdwlrpt1fqsnnwbdz
	 3c2f1mdmFvMaw==
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
Subject: [PATCH v4 06/38] KVM: arm64: Expose self-hosted debug regs as RAZ/WI for protected guests
Date: Fri, 27 Mar 2026 14:00:05 +0000
Message-ID: <20260327140039.21228-7-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327140039.21228-1-will@kernel.org>
References: <20260327140039.21228-1-will@kernel.org>
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

