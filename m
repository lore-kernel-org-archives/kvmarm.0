Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFD831D373;
	Mon,  3 Nov 2025 16:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188929; cv=none; b=iRs8xONiXJmWI5RK0bLqdoR2S0ZeA5ZkPl7/wewmqYL0z1Kb1JclUWOgyW/x5dXBmX0QC9u8XQNN2BBWfGDNAOpwdu0wVv74KHGUh2eJnK5gwJdcacXkkJ75Q+ks4CbYeVpnT2xTQn5SEPr5sw37AMbZCrzcz/VwBlTO/HDYSv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188929; c=relaxed/simple;
	bh=D6ThXSRZO2uuFBNvwNHEMq61UAk/PzFpLpciFk2Nw+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ryTawZucbZ2GrHRyeo/y5XlH/KdapJGp4jkLtvZqiUlaZU2Oecga9TYXPWf68g7HDq1QiySGH+mEpvcgP+3j4p5Q6FEr5pXi1nKbxluccNpy97PBoLCEAeDMZ8XFN100qdYxX+b9jRBrikTV/Fa+jpELGx8wXe/lTEJXG6nsmNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m7GSaK7O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m7GSaK7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA86C113D0;
	Mon,  3 Nov 2025 16:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762188928;
	bh=D6ThXSRZO2uuFBNvwNHEMq61UAk/PzFpLpciFk2Nw+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7GSaK7OPWiiIcHJbO0nWOheoD/cBmHo8NiA5a/eWA/FN14Ba/syrJVu/HaYuX4a7
	 FumPmby4o9wMFexDtQSkQdCR8Ht+9LOn6Kb2Ok+ZcGkKtVOaoLp95ji3IICmdHygl0
	 44bjxkueadHJzitVx2NCua/vZFYt7KjiB47p2D10/3uUaVqGVlg+yVHNgBOQ1hab83
	 JEfiVTY766RT0O/2B4BcT4XbWu9eo8uRqvVVD0dFolhpUNwn/9OaFG2gAXYl4MRME0
	 2jUeqrhAdSi/YP8gDgqtNhGdNjf1ywripZg0F/BTkBH4OY/0VlWR00f4jd/NRE+DZn
	 QxgS5l9QmU1fA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vFxq3-000000021VN-054s;
	Mon, 03 Nov 2025 16:55:27 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
Subject: [PATCH 10/33] KVM: arm64: GICv3: Preserve EOIcount on exit
Date: Mon,  3 Nov 2025 16:54:54 +0000
Message-ID: <20251103165517.2960148-11-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251103165517.2960148-1-maz@kernel.org>
References: <20251103165517.2960148-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, christoffer.dall@arm.com, Volodymyr_Babchuk@epam.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

EOIcount is how the virtual CPU interface signals that the guest
is deactivating interrupts outside of the LRs when EOImode==0.

We therefore need to preserve that information so that we can find
out what actually needs deactivating.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 00ad89d71bb3f..aa04cc9cdc1ab 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -225,6 +225,12 @@ void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if)
 
 		elrsr = read_gicreg(ICH_ELRSR_EL2);
 
+		if (cpu_if->vgic_hcr & ICH_HCR_EL2_LRENPIE) {
+			u64 val = read_gicreg(ICH_HCR_EL2);
+			cpu_if->vgic_hcr &= ~ICH_HCR_EL2_EOIcount;
+			cpu_if->vgic_hcr |= val & ICH_HCR_EL2_EOIcount;
+		}
+
 		write_gicreg(compute_ich_hcr(cpu_if) & ~ICH_HCR_EL2_En, ICH_HCR_EL2);
 
 		for (i = 0; i < used_lrs; i++) {
-- 
2.47.3

