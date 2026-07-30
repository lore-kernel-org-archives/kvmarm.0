Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936363B8135;
	Thu, 30 Jul 2026 07:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785395465; cv=none; b=GSHUJIMKo+YZ1+4krTEryUCZWiM3VpdvcyGtB+5l7pNRCZ6PnqpQIWFKvkdjsr00zjBixTHn5rzKjp8KOZB6hSCaBJtKc4ZkxWXrRIO4GWhDCg9sRoMREJD+sHk+00w6yIAmLZUiv3ThQSbaQQaDYJSr4I3diUL9wslTz6LisTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785395465; c=relaxed/simple;
	bh=Z1iqt8FuBsxB2iEqvV8T0TL0zx66/KdGOpRA+ZHatCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZMSp+WgPdw3u4ZJQ9/YGAz1VrIpJzo+NJtHg9ooEFCmk/6cmL1tkQZ+vMWILXOZZ6rKNgwk73yc7ByTQJimuuVr39NH0aiacSc29SHHuCPuzi6et2IlCD8lFGleRNKW/zB5B0R8pdJZzzcUBALqbsP9IEYgkSu/FLPi9OnmxeUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a/s2fqW8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a/s2fqW8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D041F01562;
	Thu, 30 Jul 2026 07:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785395452;
	bh=2eYyet/VFfIhBqni7FV440APhMlnHCkir6INX8Tdx58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a/s2fqW8m3armEZqYn0elguayUEoWshuZi4WK3KnUhncowT0IHZRfzJsfLrH+T0O0
	 Szv3u5rgInHvBsMUwrmWJtsMgwVaO2b3RC4cs3eBWdpwC4eX8lir9uHCW9uL9DUTk4
	 npwTqQtJmtSfruDDMr0f/t7JdH7FTv2k4dxvNiQksnbdeFOKrcr0rxR+8X6LtUQnFp
	 F6xrwAba9HnQU4JamlL+zr7EABx/gz98i4C1JOrrVJ1mHZmGODW2Mj3bTOBg7Yy+aZ
	 YXIus07NgYJTXOhn52oumYjiSgnnzxmrOErAc8RAqqC2QDupm4LYy4ser6mn9VZ2tF
	 s9Dr+K1F5tRew==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wpKup-0000000AOpW-0q89;
	Thu, 30 Jul 2026 07:10:51 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v4 13/29] arm64: sysreg: Add NVHCR_EL2 description as a mirror of HCR_EL2
Date: Thu, 30 Jul 2026 08:10:06 +0100
Message-ID: <20260730071022.296811-14-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730071022.296811-1-maz@kernel.org>
References: <20260730071022.296811-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, yaoyuan@linux.alibaba.com, weilin.chang@arm.com, vladimir.murzin@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

FEAT_NV3 introduces a new register that contains the HCR_EL2 value
exposed to a NV guest. As such, it has the exact same layout as
HCR_EL2.

Describe NVHCR_EL2 as a mapping to HCR_EL2.

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 28755f70f0bf0..42839d2b15ae4 100644
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

