Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9F83F20E8;
	Tue,  2 Jun 2026 15:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780415683; cv=none; b=FXQwnZqY6UgBJkIUH3xkMmho5m9C+BHPShw5AXXYE809siAlgMVUaLwwaRQSV7QqG3NaqxNoyrZJuXyMYyS1wcsalm5SG/F6ouWsxvZ2pUU+xf4YyH8tOGqTdBctNUQlfxTnVoDYHaAoU9jn/8JgMTs3HpEOx6VzAm/AX0NV6LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780415683; c=relaxed/simple;
	bh=aSoXWPM9HrjiXNB0pHn3UxuANYhsF0+9huyxBXnRHhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ae2DVFQTZj+AL3Ti+HsCCxh6gGcX8iKHAO2VX2fv+ZQsw9Ed1zDllUVeLVspQdZ1hSiCiJV58qO2/Z5mbBpZGpRTC9S+PxKq5o0mUWP1lWVzpHaYl/Z54q1ACqxcWFoYxdDwaEpmXcCkQzodjbESg1kw50/oTC/+FKixjtDtnYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lJnKKqId; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lJnKKqId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA6F1F0089A;
	Tue,  2 Jun 2026 15:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780415682;
	bh=1vxy7PyT01yTHtRopz8wtpkXTFr/2qg3hF3A5T13CZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lJnKKqIde6NubJQGVaroidOoyR7QsbRcRKFwI4xIr/td6Q4nWRFW1mEVopRx9swJg
	 6pdIVyvbCw8l1SsJnD92GI/pLynjsjV2di5bRHemooHUuyhUmxxsHvOr2qYzriC066
	 oeKD2ZgaqLySGuSJUcYynokZQixUhDhc5VLOJfS4QNhu6C9BOfXirnGYgLrFpB7ygR
	 69TOsXqX43B2ZNlWST8qrFVlNmDe9WdPPGrEgmryxI0YFbyBqAsVq0M5hhj2EczQkJ
	 3Xm+Czm/gceiN0vRphSE0iJ099hH7ffnz9sA1RIPng6XNmIjmtzYzV+PhcsEZvvwjE
	 uW3z1/y0Zuh2g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wURRw-00000008fVv-19WD;
	Tue, 02 Jun 2026 15:54:40 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 2/3] KVM: arm64: Wire AT S1E1A in the system instruction handling table
Date: Tue,  2 Jun 2026 16:54:28 +0100
Message-ID: <20260602155430.2088142-3-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260602155430.2088142-1-maz@kernel.org>
References: <20260602155430.2088142-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Despite having handling code for AT S1E1A, the instruction was
never plugged into the system instruction table, leading to an
exception being injected in the guest.

If the guest is Linux and using the __kvm_at() helper, the exception
is actually handled in the helper, and KVM continues more or less
silently by reentering the guest. Not exactly what you'd expect.

Fix this by plugging the emulation code where required.

Fixes: ff987ffc0c18c ("KVM: arm64: nv: Add support for FEAT_ATS1A")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 148fc3400ea81..753fe30d322c3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4217,6 +4217,7 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	SYS_INSN(AT_S1E0W, handle_at_s1e01),
 	SYS_INSN(AT_S1E1RP, handle_at_s1e01),
 	SYS_INSN(AT_S1E1WP, handle_at_s1e01),
+	SYS_INSN(AT_S1E1A, handle_at_s1e01),
 
 	{ SYS_DESC(SYS_DC_CSW), access_dcsw },
 	{ SYS_DESC(SYS_DC_CGSW), access_dcgsw },
-- 
2.47.3

