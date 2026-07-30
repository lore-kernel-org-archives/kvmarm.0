Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7C63BA241;
	Thu, 30 Jul 2026 07:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785395465; cv=none; b=WUsC01ud2X6EqJaoKEPVzZM31Kwk0yPY0MQQ4XssMWbErr/ZSv5C0uDV2mDy11epzILVlWI36T98+pNWD1lDZsSWojmIUc4UmHT4NgIv7wcrLsfHaD1sDe+5aGwiW2OgmhLV4J00/vji6qFyKiWAxmeqf5kdwKrdQzvFwvCFEaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785395465; c=relaxed/simple;
	bh=JKWpO2aGs6TofEB7lS/zufW/A4iGavXEIGzsMdT1zsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gpVEwTwuZ6Ea/tG17P8URIlPQPL/xxzBsSpTCAw4R5UFYkbgO2lGfMr1YrPARf+xy/jp2ycbwcGBCm7PgfsCdWkHSheiE8i1X16UsQOyAMBNF8JKCzPnepYRTui/zW3eLORGvAvCwvRqsHrr3BM7USgIIZcEvr2Q/xdiKFhvYvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ac+uGqri; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ac+uGqri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BBE41F0155A;
	Thu, 30 Jul 2026 07:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785395453;
	bh=iSyY+XJ+vex+b5WS1ha+pHt3rgbtzPLgz50hKTgc/ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ac+uGqriQl3sWUIwg9xLwe3IxcFPvWlgGzq2R95IfpdJpBjt+oJ4gQv0MTAhK2ZyL
	 in28UU48cc8AcyMpzuRCwv8WMDISOMYlGON2DuHXZc1orYJE2i0YhS5oCF+xikiJnf
	 a5BEydrD8U/Rwi/ai8T8BpEoFy6Rn+KlyIfBRvLwyGs8fb+bpHxm9i6/vyoWqLUJH4
	 LDi3rsSwfWf2sbL1Y/cC8Ir2fO4wcRy/jEzT3KNNP3Sz3EJ4Qbi+f94m96OmGuUM53
	 EmdICX6zDxfKvml7XNt4xvtzhefqd/JrRYzcvkAJWlpdU0aNAaPlFA2M71PzCB+DcR
	 Yn6PaY942c8Ug==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wpKup-0000000AOpW-1jsT;
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
Subject: [PATCH v4 14/29] arm64: sysreg: Add HCRX_EL2 bits related to FEAT_NV3
Date: Thu, 30 Jul 2026 08:10:07 +0100
Message-ID: <20260730071022.296811-15-maz@kernel.org>
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

FEAT_NV3 introduces 4 new HCRX_EL2 control bits. Describe them
in the sysreg file.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 42839d2b15ae4..67d013b376a3c 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -4548,7 +4548,12 @@ Fields	ZCR_ELx
 EndSysreg
 
 Sysreg	HCRX_EL2	3	4	1	2	2
-Res0	63:27
+Res0	63:35
+Field	34	NVnTTLBOS
+Field	33	NVnTTLBIS
+Field	32	NVnTTLB
+Res0	31:28
+Field	27	NVTGE
 Field	26	SRMASKEn
 Res0	25
 Field	24	PACMEn
-- 
2.47.3

