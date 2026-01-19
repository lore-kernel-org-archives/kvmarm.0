Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F6D221543
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768826832; cv=none; b=UOlL27Hch0o2y41zFQyz00sR1kT/4AtKfLSCX1i30fQyp9Vhp7mbeOXBeZN37r1Nb/d0ilOV+OPHV0pbm8c6/G624FATVjmRlIgMLqd1lJkNFVJljOwPIOb/YQHxs/S61fXwbaK6mVZ9DiskBKaDZMUq5/fH7Ae1zQ37mMng5fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768826832; c=relaxed/simple;
	bh=Ci8Yc7ndwDlszED/Qx1HGsS3eO9VUT9SMiftdYGNQu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cThhWQH9YeSiE+QGuDwpFnSW4KaZJScfw6nBAXTOPIH7lWpYPc4micnZFDnakdlft45cMqvSj+t6OzDWSqauYaqlFTp+jmnmM0aJsJ5oYFitOzCrxfMpXaEKstyGEqN1HlQDekkrsK8i4zW30pVH3FS3/fF9i27ghhBYRFJF0xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L+kax+mF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L+kax+mF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222CBC116C6;
	Mon, 19 Jan 2026 12:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768826831;
	bh=Ci8Yc7ndwDlszED/Qx1HGsS3eO9VUT9SMiftdYGNQu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+kax+mFuRN3ESDhczlAuyD1l3SxYTvc0LuBJJvNxSL9yW0Tmwni1tTupHx0CRQag
	 2ZUPTwTToR9s9KbzvtArqerdYpOdalYAD77fPrj5Ubpet1iEMLGKhd4m2vvm5Vhoty
	 4Ise9kfMx92nTCCN28VIngy4Vq8Yr7OLh0X2wg9uu7zH/1niw5c7B3LC/TfyVQtdUe
	 wPfrxH4y8FfwKjw41yUL7+B40vcOxgggBIAGFrh2HLJr6FxzkFov5DAX5Sw5s6HZj5
	 EFxiHU8ceqqFbpA5XxE0tRcFBOcextPcLnPrIh7SFL3FGPDcrw6DIqUEw9pkp5AbcI
	 LG06VOagfk4bQ==
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
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 06/35] KVM: arm64: Expose self-hosted debug regs as RAZ/WI for protected guests
Date: Mon, 19 Jan 2026 12:45:59 +0000
Message-ID: <20260119124629.2563-7-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260119124629.2563-1-will@kernel.org>
References: <20260119124629.2563-1-will@kernel.org>
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

Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 3108b5185c20..c106bb796ab0 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -372,6 +372,14 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
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
2.52.0.457.g6b5491de43-goog

