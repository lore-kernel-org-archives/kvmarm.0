Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD7343F8A6;
	Tue, 14 Jul 2026 09:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784020613; cv=none; b=k66yt0lfdVboWBmUDn1/aWdn7Y8SllmcCLsNh2/bq1kYJyTLKym5GEVi4uShBlmDF1vbHX/NFRPeqxHV+6hgl604RksHAf7lBWRSV1eQt5vtMgvsQcNtXBEfNtOMTOEpF2u1/NPRquVsk8MY7SWJythm3RjEPBQHMZKRuNvksC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784020613; c=relaxed/simple;
	bh=VLZWYBZnScUMVbCqb39qjY6ehohCLw5zitTNdWOBcHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rxnindrFVy9VXhUZ4AuKIgl6XCDRmPwuXFS25zautUvZdcJ+4qx5HiVr6matueqsli4g+pKE8KbOEKABdYYemITLMkPxMMR/MT+jXaO2xG5D47pOM7ldU1GbU5KjwkrSj+id921NLM0RNUWurkMNJV6IAkvlru4TnAlopEgODd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g/ZZXLW6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g/ZZXLW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4B01F01559;
	Tue, 14 Jul 2026 09:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784020611;
	bh=Zj2ikyX7bBttwfozOnp0vCaUHZFhgvkkDvwyqU4jtCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g/ZZXLW6J9S+jPcwfyx08ae5OCQGjjYg+SK0Hco3hpx45OF8uSaCGuU60LwZDLUqw
	 Q+eCdO5Z8fQqbthR5iZPj+QwGOco+nwTYLO4Et9RPfE+ccZBIo1qcvDC8HogS5BKYR
	 tmXKxYgh3pdHOktUm+BOHkh7IYo0ntKjKQ/KHKlEITTBofJruszX1uJkP8ze2SoV0Z
	 V/Yy5dRrFAF4nxczFSu4QelFZYL/0zyNMSF5wdIzWoQ8ivIixoCEBTWWhcPjNNtJ0n
	 RDfX79bve81N/F6O/1HpI2l+dMPq66pKjU1tQT6nZBrjIBIFvh1XDSky/Grqw9v2gn
	 tRgsY42kmSZ+A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wjZFx-00000004ny1-334p;
	Tue, 14 Jul 2026 09:16:49 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 13/28] arm64: sysreg: Add NVHCR_EL2 description as a mirror of HCR_EL2
Date: Tue, 14 Jul 2026 10:16:26 +0100
Message-ID: <20260714091641.1970822-14-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714091641.1970822-1-maz@kernel.org>
References: <20260714091641.1970822-1-maz@kernel.org>
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

FEAT_NV3 introduces a new register that contains the HCR_EL2 value
exposed to a NV guest. As such, it has the exact same layout as
HCR_EL2.

Describe NVHCR_EL2 as a mapping to HCR_EL2.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index c6e8117a6f9cd..31e4ea455a9ce 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -4266,6 +4266,9 @@ Field	1	E2TRE
 Field	0	E0HTRE
 EndSysreg
 
+Sysreg	NVHCR_EL2	3	4	1	5	0
+Mapping	HCR_EL2
+EndSysreg
 
 Sysreg HDFGRTR2_EL2	3	4	3	1	0
 Res0	63:25
-- 
2.47.3

