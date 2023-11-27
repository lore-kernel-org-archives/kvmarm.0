Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D241A730
	for <kvmarm@lists.linux.dev>; Mon, 27 Nov 2023 11:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CNIbEe26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8491AC433C7;
	Mon, 27 Nov 2023 11:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701085569;
	bh=RYnRjoeKOsmLznGa7HZFefYf/HrFe4O9I7VJ66wu7yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNIbEe26PWyMwb7I8KmHnduZmNhP11Twb4Bp71ZqUd6GeGX9DvSY3gw1qmVI0r1sl
	 6kGOdaAeS8xisU9kGpzBZHIheWIW26Vnbzqdj5x/UjoTv07z6jn5qiZVfFodiFdtx7
	 cKaqKzqN4IWhIw7PwTyTQAzlpfUQ+gz/yy5wUba9Fltme2EpAI3Bv6CHwsHdnvqw8H
	 JewXryzlhy9ag49kqVStB0pe8PSzvp5nbhe1MYKU1a/jMyOcWWP6+Ot9cVt9siJMQQ
	 pfR8N/qF7SOchFsKnPNgJmz4opWe3xLFDvMRxhwTvqeyW1PmIQLg6MBShaRGMXREzU
	 iP447vGcMXe7Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r7a3z-00GleL-Kh;
	Mon, 27 Nov 2023 11:46:07 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v3 12/13] KVM: arm64: Expose ID_AA64MMFR4_EL1 to guests
Date: Mon, 27 Nov 2023 11:45:58 +0000
Message-Id: <20231127114559.990314-13-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231127114559.990314-1-maz@kernel.org>
References: <20231127114559.990314-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, ardb@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We can now expose ID_AA64MMFR4_EL1 to guests, and let NV guests
understand that they cannot really switch HCR_EL2.E2H to 0 on
some platforms.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c   | 4 ++++
 arch/arm64/kvm/sys_regs.c | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 042695a210ce..3885f1c93979 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -137,6 +137,10 @@ void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
 		val |= FIELD_PREP(NV_FTR(MMFR2, TTL), 0b0001);
 		break;
 
+	case SYS_ID_AA64MMFR4_EL1:
+		val &= NV_FTR(MMFR4, E2H0);
+		break;
+
 	case SYS_ID_AA64DFR0_EL1:
 		/* Only limited support for PMU, Debug, BPs and WPs */
 		val &= (NV_FTR(DFR0, PMUVer)	|
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9f76f24b96f8..ff2e66f0bda1 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2197,7 +2197,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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

