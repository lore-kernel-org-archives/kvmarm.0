Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6413A3DB94
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 18:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705947242; cv=none; b=QHOSre8i8DIIq2QQlzjRFimFoTHMDyI1tvVXXrNmDItkLzcML9SSqdJLxS5VKpgrEKPgowpgfcDvJjxO7xS6kb9g57ttnnBxQDU0VVQdPapUWAlAVq47px4dlM0W8o+lwELLdaGyyjRlumXJs3oZ9WTZUR9lmRgfM6s56nHggs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705947242; c=relaxed/simple;
	bh=uXZt+ggYQwr2UORMUCddxIJ24b9qDYjES/RyXmgrMy8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bApDGkKufX9Pe3vXBJwykviaQiyxrUVjaiVgTfR6loQFzhK7x1yCyXeDcu6ZTyp//NKLBmxIxJDJfUqW5nK4mZHf+eoq3SzQi7DBktxL4Qp3/Q8zu+qk2/VmLdqAtyvI27FStuuqbJ5dIadm8BEBRWlzf/3Qc7YD6rpuji8jfHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uOeTv9aX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uOeTv9aX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEA1C3277D;
	Mon, 22 Jan 2024 18:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705947241;
	bh=uXZt+ggYQwr2UORMUCddxIJ24b9qDYjES/RyXmgrMy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOeTv9aXEVA3NqnYtgsdXBhgGG80y04r5rIKauRG/5qXr6qTMuyUjX6pAXo+Q3+n6
	 wFxMjU9OASxTp5tueB2JnoeL6kaNe/uwKD2/lAaQSMQQl9JQvvzJK71t7Z2PzZqryW
	 356YOvIFG7KEs+U9V3Wiap3288uViTZfkNCFsjdRgomO5WdIwENDBsjgt4SQ9Cjdfp
	 PpqUXMgKnSo0MwLEtvr2aZbkYETHQz0CG08DbgVCGC395ovdyghH8kQlVu55dO5YqE
	 jbFEOyLJgtn42WS3YnBc3MOmo1hS3Zpob3XkEpzZZHgac6BEi9e6CGM5XW4CRKlRjv
	 94JOWCJ4FRaCQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rRyo4-00Dh6E-1m;
	Mon, 22 Jan 2024 18:14:00 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v4 08/10] KVM: arm64: Expose ID_AA64MMFR4_EL1 to guests
Date: Mon, 22 Jan 2024 18:13:42 +0000
Message-Id: <20240122181344.258974-9-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240122181344.258974-1-maz@kernel.org>
References: <20240122181344.258974-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, suzuki.poulose@arm.com, ardb@kernel.org, james.morse@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We can now expose ID_AA64MMFR4_EL1 to guests, and let NV guests
understand that they cannot really switch HCR_EL2.E2H to 0 on
some platforms.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c   | 7 +++++++
 arch/arm64/kvm/sys_regs.c | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index ba95d044bc98..d55e809e26cb 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -133,6 +133,13 @@ static u64 limit_nv_id_reg(u32 id, u64 val)
 		val |= FIELD_PREP(NV_FTR(MMFR2, TTL), 0b0001);
 		break;
 
+	case SYS_ID_AA64MMFR4_EL1:
+		val = 0;
+		if (!cpus_have_final_cap(ARM64_HAS_HCR_NV1))
+			val |= FIELD_PREP(NV_FTR(MMFR4, E2H0),
+					  ID_AA64MMFR4_EL1_E2H0_NI_NV1);
+		break;
+
 	case SYS_ID_AA64DFR0_EL1:
 		/* Only limited support for PMU, Debug, BPs and WPs */
 		val &= (NV_FTR(DFR0, PMUVer)	|
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 88b8fbeafaa0..08a9571fa809 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2350,7 +2350,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 					ID_AA64MMFR2_EL1_NV |
 					ID_AA64MMFR2_EL1_CCIDX)),
 	ID_SANITISED(ID_AA64MMFR3_EL1),
-	ID_UNALLOCATED(7,4),
+	ID_SANITISED(ID_AA64MMFR4_EL1),
 	ID_UNALLOCATED(7,5),
 	ID_UNALLOCATED(7,6),
 	ID_UNALLOCATED(7,7),
-- 
2.39.2

