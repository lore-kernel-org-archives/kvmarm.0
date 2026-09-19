Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9777D64A8C
	for <kvmarm@lists.linux.dev>; Sat, 19 Sep 2026 12:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789821116; cv=none; b=C1ZACi7PBhkARHhhovXY5p3h9BE6a7WVBuzWySOXrjoyZAsCqHsMAWEXA+7V8qMnZu9pJbTDi9ysDI/59rTLX3+CX+/sR75vtGjxw+NwalCRKKH57aG/d8cAxTUpOkgcxLMsYNWvqeG5L8/wOnCI2GRUTRHC8JDB4AZ/dWNJItU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789821116; c=relaxed/simple;
	bh=d09jg3LLlE5cdmDX1DN9DZz3HSUF55KfYSW1NN18Jt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0/vd6pdJcuK6lIITCqP8Z8M3ACDlLkJKuehtQj2esF8b5CJCELcRCt/uxTivj8ybvCm2LA4Zj2xRb26cNmtrPHR4mg7RDyFk3lyQSO0LoPSQB09iqnmxHWS53ObAG1+CU5CHtOvC8kxRlsmDxIyHDFYyByfhjrf73VrtNunF78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YZIdgLXE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YZIdgLXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300B71F000FF;
	Sat, 19 Sep 2026 12:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789821115;
	bh=GBqFniyZ3g3+J9Du6G8y0kPV5tZ80T53Bvj1N2LISzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YZIdgLXELNEnTvoOi0DxTzoE2DAGAHWLUO64Q1UJ39nmIpz+UNYa7dhOzBDgi9BEy
	 vfgwgBeBhf/Mm42rFMBOj7WS+o8SJSDSVpxBXTcu0m6M4ZVUYABR3DpI+m7DuhBfPb
	 N+Kz0jQ9ZluYO3lTSHmvPygkGil/4jCXT0p7Bhcg7V27b63r1NHlJDZ0ZLJk/I3kIY
	 SRz2oZGBuVkExi1Ud0Wdwi1XtPZdTA6i+kY3d5V5IbwJ27Bd9AZI0nem+BD9EQYsSk
	 jPiCuY8jfBUzCCDp+th8E8WcpSzk7TxJYpoDG1v+FKQncvIbuziyOg3dTQ3sZ7g4CZ
	 P7tUbNFe/TB/A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1x7uET-0000000AwvV-1QLo;
	Sat, 19 Sep 2026 12:31:53 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH 1/4] KVM: arm64: vgic-v5: Drop __iomem attribute from {vmd,vpet}_base
Date: Sat, 19 Sep 2026 13:31:47 +0100
Message-ID: <20260919123150.3283606-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260919123150.3283606-1-maz@kernel.org>
References: <20260919123150.3283606-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev, sascha.bischoff@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Both vmd_base and vpet_base are pointers to kmalloc'd memory, and
therefore cannot carry the __iomem attribute, which designates pointers
to MMIO.

Drop the abusive qualifier.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609190650.liMAzwjF-lkp@intel.com/
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v5-tables.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgic-v5-tables.h
index b2ffbe68c05b4..89096926563f7 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.h
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
@@ -23,8 +23,8 @@ struct vmtl2_entry {
 typedef __le64 vpe_entry;
 
 struct vgic_v5_vm_info {
-	void __iomem		*vmd_base;
-	vpe_entry __iomem	*vpet_base;
+	void			*vmd_base;
+	vpe_entry		*vpet_base;
 	void			*vped_base;
 	u8			vpe_id_bits;
 
-- 
2.47.3

