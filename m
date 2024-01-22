Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D963DB94
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 18:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705947241; cv=none; b=pjwNpw484ds89qA8saYZHczbIchPwm6mIfZNGVYRvsylC6PNedrkaXTRtvtYUd/P/+4s0GxfeTpduHZm6Vgfrw5toVXt1jNzgE5UW1DVgvT9byxR5VFsE1y5rSku4g1OYwXjoreLRmXQdi5CsjQ9BgayoXFmRjlSe+f0Lg6JvBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705947241; c=relaxed/simple;
	bh=vtwO7Y1pa9TBqUfZj+JwJZr2z9NDvi8DIG/VMxcL/3g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VCfs2rtGvVkYbL65cwiyG/+G2rV54EDfsJ+cZodBBewoK7F1coyeduKIl0OFL+VHZJlYAu89ESJ/7FxBGzHRj0qnSrwKx3FPApdfZyDG/qB2L4rD1HOJuE+X4g8Vhq4OEm/kNY1vbx9T3wO1d8ZlAutLhcoCDOeXGYMCDoP/vNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R4w7BD3W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R4w7BD3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86388C4166D;
	Mon, 22 Jan 2024 18:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705947241;
	bh=vtwO7Y1pa9TBqUfZj+JwJZr2z9NDvi8DIG/VMxcL/3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R4w7BD3WhjLdLfpJHFzM33N9nGIa8VEfffn09mnabmCICWeg9V0oRv639k9PhvHcY
	 pBGQC7CeHkwhICPNqonhlKfbRa+nY4jCGPK2EEhehhJ8FZEXYs2D2LsDZvwIPFrNjQ
	 EYvv1qwbIHBN8ephOKfqAStMYVenOP1D+CY25Q61QACoSiIA5wLUjKxTGBdlcJUweH
	 M73ThRSMCgpm2oHDi78an8Ekg4OkFRKdEY4cIgfZgPGl/J9E+I3iPA49BfK6gYzSPd
	 sHlfX04gMNpKwGc17UipRF3lID2En7fw40kIwzOn/XeV29c38i+lByOlxOSr9Wfv4R
	 fBktfios9iqqQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rRyo3-00Dh6E-L0;
	Mon, 22 Jan 2024 18:13:59 +0000
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
Subject: [PATCH v4 06/10] arm64: cpufeature: Detect HCR_EL2.NV1 being RES0
Date: Mon, 22 Jan 2024 18:13:40 +0000
Message-Id: <20240122181344.258974-7-maz@kernel.org>
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

A variant of FEAT_E2H0 not being implemented exists in the form of
HCR_EL2.E2H being RES1 *and* HCR_EL2.NV1 being RES0 (indicating that
only VHE is supported on the host and nested guests).

Add the necessary infrastructure for this new CPU capability.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 12 ++++++++++++
 arch/arm64/tools/cpucaps       |  1 +
 2 files changed, 13 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index ad3753fbdcb1..91249d20883b 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1794,6 +1794,11 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
 	return !meltdown_safe;
 }
 
+static bool has_nv1(const struct arm64_cpu_capabilities *entry, int scope)
+{
+	return !has_cpuid_feature(entry, scope);
+}
+
 #if defined(ID_AA64MMFR0_EL1_TGRAN_LPA2) && defined(ID_AA64MMFR0_EL1_TGRAN_2_SUPPORTED_LPA2)
 static bool has_lpa2_at_stage1(u64 mmfr0)
 {
@@ -2794,6 +2799,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = has_lpa2,
 	},
+	{
+		.desc = "NV1",
+		.capability = ARM64_HAS_HCR_NV1,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_nv1,
+		ARM64_CPUID_FIELDS_NEG(ID_AA64MMFR4_EL1, E2H0, NI_NV1)
+	},
 	{},
 };
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index b912b1409fc0..65090dd34641 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -35,6 +35,7 @@ HAS_GENERIC_AUTH_IMP_DEF
 HAS_GIC_CPUIF_SYSREGS
 HAS_GIC_PRIO_MASKING
 HAS_GIC_PRIO_RELAXED_SYNC
+HAS_HCR_NV1
 HAS_HCX
 HAS_LDAPR
 HAS_LPA2
-- 
2.39.2

