Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5429D1FC7EF;
	Tue,  3 Dec 2024 19:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733252597; cv=none; b=ul4wu3Vllpvg8PJZAI/qbjh0nSYtspoBDpRctDPmmV/V0JJGdgGZB/PYq10pgb1gkT2edboqBOXzdjZJSOKPiY52LpMdSmPlECZviBgqecENCG9Fk8kcHCZK4vB6YILz4laIgxvfgUh1+YSySP6e4HFcvRofYFHP2TqFKaeLVKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733252597; c=relaxed/simple;
	bh=eijrbAe3pZqlViuINmabDVrHYMVGawiSwmMh9zjp4eU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jVfMNCI2QkYeFzubXIQv33J0xX+shouAcRQUdKs+UGxx2KO82nS/NK6qWpENAB4WTFjNcgVhZm9qIYAPGUi3zjHzHWEFCN59aUh9yb1gP9z3NcSMPrKUQ8pHNuZoXkjnJSPIMgAGwGufCfvKRAAD2Ct0hbIozF4D9mtQLZ0qcOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M4xOX2qv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M4xOX2qv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0B7C4CED6;
	Tue,  3 Dec 2024 19:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733252596;
	bh=eijrbAe3pZqlViuINmabDVrHYMVGawiSwmMh9zjp4eU=;
	h=From:To:Cc:Subject:Date:From;
	b=M4xOX2qvVUnVLmMBciJn/ktir9cYv44PQgN516P1RUy/hPZeRytnnVwufr9xCirtN
	 L6zCvXUtA0hCxoxiHFGoFlRNuy2LURLASnKomgcf3JbfAYcAit3FgiUPW9KAUKkqVU
	 OO6GIRcXSxn8trEcptZ09FAOK2BdsqOPLLs4jpjQKpDudO+FnHeNQWlzmc9XtlWZuy
	 KNrNEq15+0bxzTIJJ9qAyAGvCh+fFTGp6gghmLFLZCtq2Y1Jd9kiYhmkegjDnHQr1f
	 hZeMLJ7T2GV9snlpAedM7OzOiWRKh0Je1Zj7P+UNLm2YfdGDK10JlY4CPlnwhTemWw
	 bGAddOoecVgYw==
Received: from ip-185-104-136-29.ptr.icomera.net ([185.104.136.29] helo=localhost.localdomain)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tIYB0-000CK2-FB;
	Tue, 03 Dec 2024 19:03:14 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	stable@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>
Subject: [PATCH] KVM: arm64: Do not allow ID_AA64MMFR0_EL1.ASIDbits to be overridden
Date: Tue,  3 Dec 2024 19:02:36 +0000
Message-ID: <20241203190236.505759-1-maz@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.104.136.29
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, stable@vger.kernel.org, will@kernel.org, mark.rutland@arm.com, james.morse@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Catalin reports that a hypervisor lying to a guest about the size
of the ASID field may result in unexpected issues:

- if the underlying HW does only supports 8 bit ASIDs, the ASID
  field in a TLBI VAE1* operation is only 8 bits, and the HW will
  ignore the other 8 bits

- if on the contrary the HW is 16 bit capable, the ASID field
  in the same TLBI operation is always 16 bits, irrespective of
  the value of TCR_ELx.AS.

This could lead to missed invalidations if the guest was lead to
assume that the HW had 8 bit ASIDs while they really are 16 bit wide.

In order to avoid any potential disaster that would be hard to debug,
prenent the migration between a host with 8 bit ASIDs to one with
wider ASIDs (the converse was obviously always forbidden). This is
also consistent with what we already do for VMIDs.

If it becomes absolutely mandatory to support such a migration path
in the future, we will have to trap and emulate all TLBIs, something
that nobody should look forward to.

Fixes: d5a32b60dc18 ("KVM: arm64: Allow userspace to change ID_AA64MMFR{0-2}_EL1")
Reported-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a26f02ec8748..b1918adbd0aa 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2674,7 +2674,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_WRITABLE(ID_AA64MMFR0_EL1, ~(ID_AA64MMFR0_EL1_RES0 |
 					ID_AA64MMFR0_EL1_TGRAN4_2 |
 					ID_AA64MMFR0_EL1_TGRAN64_2 |
-					ID_AA64MMFR0_EL1_TGRAN16_2)),
+					ID_AA64MMFR0_EL1_TGRAN16_2 |
+					ID_AA64MMFR0_EL1_ASIDBITS)),
 	ID_WRITABLE(ID_AA64MMFR1_EL1, ~(ID_AA64MMFR1_EL1_RES0 |
 					ID_AA64MMFR1_EL1_HCX |
 					ID_AA64MMFR1_EL1_TWED |
-- 
2.43.0

