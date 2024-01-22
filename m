Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D2E3DB94
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 18:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705947241; cv=none; b=GropDvNX/74W/8J7lkGQiwN56QWPEKiTxv1RWAw0I1Gce2SUmLQz+BwC6j9WBaM22IILX//fA4l+GFs3Ht/2UEoh2X5J/3ka1a+I/P+lGhHPpjr3mgKW3db51/KXRsJnsRtqYxO4biqOdcRMGsrHclK+YopalcJTEcMi2mQUFLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705947241; c=relaxed/simple;
	bh=pMisoUEojG3/Bf7hDdiKAYm2Bh03DW07aFvgW2pzxkA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cQZ+4RtmH0Dwsqdr66tw+wYmYj/fFUe0zpChCIFJuQXQ3kfjLHb8eWytTWQeARUjGq8aELjJRfHKuHOcHCXq029g1Dq8BskLYehx2vbEAfiWIKI8H7VKJ+UdKt6iH0QgQmxeytc9xTNkU7U7Q1Z4if3t409qdkFXd3aJLo8GbN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aUORH81L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aUORH81L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A2DC43330;
	Mon, 22 Jan 2024 18:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705947241;
	bh=pMisoUEojG3/Bf7hDdiKAYm2Bh03DW07aFvgW2pzxkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aUORH81LAAj6jX5vMEVBFeJnxYMouWtOeoXv1Tf5yQ0LtJlmOThljKAPKlydkL9G7
	 eUtPgFRS7Pr8r03HidEmPnICrWcdJPjfkGR6bQg0q7FJ9fLRLP0w0QKM10KwZdSS1t
	 rLwLifWcu8vWCRiX0t+tBztKMUGdkpzgChn5XCD0WSEqlrDWb2JZ+Qwd9r6UnIx0p7
	 Pa2SQiub0ShEQMxgifOx+aWy4DCUxsl2E0PNLQ/qBfwI+MLZbQ4YYBcdPGMG7FT3zZ
	 /5LSOLH5nVXOVGLpGezI3Sntm5JTEyUlsibtKq9FJCul5+ajyf40oozqVH5hHVG/Bg
	 EuPUwKXUpRT7A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rRyo3-00Dh6E-0Y;
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
Subject: [PATCH v4 03/10] arm64: cpufeature: Correctly display signed override values
Date: Mon, 22 Jan 2024 18:13:37 +0000
Message-Id: <20240122181344.258974-4-maz@kernel.org>
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

When a field gets overriden, the kernel indicates the result of
the override in dmesg. This works well with unsigned fields, but
results in a pretty ugly output when the field is signed.

Truncate the field to its width before displaying it.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 92b1546f2622..bae5d0655262 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -949,7 +949,8 @@ static void init_cpu_ftr_reg(u32 sys_reg, u64 new)
 				pr_warn("%s[%d:%d]: %s to %llx\n",
 					reg->name,
 					ftrp->shift + ftrp->width - 1,
-					ftrp->shift, str, tmp);
+					ftrp->shift, str,
+					tmp & (BIT(ftrp->width) - 1));
 		} else if ((ftr_mask & reg->override->val) == ftr_mask) {
 			reg->override->val &= ~ftr_mask;
 			pr_warn("%s[%d:%d]: impossible override, ignored\n",
-- 
2.39.2

