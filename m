Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BDF3E474
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 18:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705947244; cv=none; b=SQ1WD+nKjhNIp/BKjxV58rUuF/pwLGOEfuA4Vg43XJrgnkFQQexpQGgqdX329ssdEMyxx2jCn2nmfw/onoEP5VmiO7oEp14sqFEDgUbxptzaV2fbi6/1msLTDn48o6Dl8tcmYkqSPFraFWEs1kYzGBE1CWb7fr4lqZUhhWzFNmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705947244; c=relaxed/simple;
	bh=Bh3vfMD6ju54Foxy9nsQsQaciPYfPW4GwDoMUkoGUDk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Gs7s2l+KQwOzfvi4aPl5M+5NAvLrk3JksK6N41i5SL9koHWL82iK0CpfWyvHXlD8feFZwE17Wmc/IEzmEf17encWd1eTqInhjSYnbj00UYr31nPuQc4Sab+MVBIrV00ONWulxa+btOUV5NcFgzNxeaFPhFEjyCaykO2VCuQkRyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PQR4QNKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PQR4QNKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4C1C32782;
	Mon, 22 Jan 2024 18:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705947242;
	bh=Bh3vfMD6ju54Foxy9nsQsQaciPYfPW4GwDoMUkoGUDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQR4QNKY2VYo5a2TVsy+3eUubdi/1SsZP6JY1a/GxU1CjNppsWYpVhG3gIkkC8Ti4
	 UD8dvHZKPRUJUHI5rmIP1RVXSayyDYBVD8oX5ypeOJGKRxKOz/QAB5tzFw3PxqNzmC
	 gbH6E/blEzgCoQpNV20TufmQ2F171FdtiyktNnHS98wi/pWgsfnnSWODgYnvPRK/aO
	 YScUvJHpIy/L46hT4EYyDCvu51eJbCz1mzWnnvcPIUfAyt7wRFiKAv0CtWm9wfKlsm
	 FPToIu9+q7mDCuZLLyIl7HA9u1ODoWQzjN3tDSC49Ibc5H9ojqnbBPv0ng2p38E2h/
	 zHRdpcdA9AT9w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rRyo4-00Dh6E-Ea;
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
Subject: [PATCH v4 10/10] KVM: arm64: Handle Apple M2 as not having HCR_EL2.NV1 implemented
Date: Mon, 22 Jan 2024 18:13:44 +0000
Message-Id: <20240122181344.258974-11-maz@kernel.org>
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

Although the Apple M2 family of CPUs can have HCR_EL2.NV1 being
set and clear, with the change in trap behaviour being OK, they
explode spectacularily on an EL2 S1 page table using the nVHE
format. This is no good.

Let's pretend this HW doesn't have NV1, and move along.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 91249d20883b..0f29ac43c7a2 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1796,7 +1796,23 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
 
 static bool has_nv1(const struct arm64_cpu_capabilities *entry, int scope)
 {
-	return !has_cpuid_feature(entry, scope);
+	/*
+	 * Although the Apple M2 family appears to support NV1, the
+	 * PTW barfs on the nVHE EL2 S1 page table format. Pretend
+	 * that it doesn't support NV1 at all.
+	 */
+	static const struct midr_range nv1_ni_list[] = {
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD_PRO),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE_PRO),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD_MAX),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE_MAX),
+		{}
+	};
+
+	return !(has_cpuid_feature(entry, scope) ||
+		 is_midr_in_range_list(read_cpuid_id(), nv1_ni_list));
 }
 
 #if defined(ID_AA64MMFR0_EL1_TGRAN_LPA2) && defined(ID_AA64MMFR0_EL1_TGRAN_2_SUPPORTED_LPA2)
-- 
2.39.2

