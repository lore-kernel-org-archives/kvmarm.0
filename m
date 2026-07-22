Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769F047043A;
	Wed, 22 Jul 2026 07:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784706181; cv=none; b=ejyo3GoZvmPvW2IPp5RByQ1tsU7aR4xso9pb3AGx3239vfzI0r463oUSejQRw7GlhxbO9+3L4LM16HD+oR16q83N9d1GVAOWbKxZp3GWL4e/nv3YLM1jdsX6jbkv6cCA0/DRXyhiJ8mTfTEkaezstULUt3D1ZpbLZfm99//5YpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784706181; c=relaxed/simple;
	bh=JKWpO2aGs6TofEB7lS/zufW/A4iGavXEIGzsMdT1zsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kErilhJok2eT5zL/qGGnWyzsnpX3P7xoMQ49REzirLOZpXRa/2jwj2VvsA92uoomxAkfD6g1fiLPtOyXudx2CBbHezNjbMorWbZphzoaT5OYAqzx35s3Fw3wqid/B1cDBZhyRhQvApYP9ftng7t+davJ7o1S4NmfMUbsO3bSrA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VaBIkWag; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VaBIkWag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA701F01559;
	Wed, 22 Jul 2026 07:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784706179;
	bh=iSyY+XJ+vex+b5WS1ha+pHt3rgbtzPLgz50hKTgc/ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VaBIkWagdi9jUKBkDpd3H+YV6GJ8iKY9o2YYPK0Wb+/Anedfmte6kjvi6TKpeQUhB
	 M2E/M5v2DOJkwiwsi2VkqgTa91SCl0k8GLLBgNuVbJ9NZ9gaT6/MBRaXZ7LjEYvSRa
	 8NnepteZpbCXCufJXpzrFHgbqTC/5Maw0CXaChfKf/8/OgP6kBI6RNmSpPymsE9qWD
	 T3r5eVZpWiX+hVsgzVCpCq/4qAHTQu+RaWo3rF9Eui/zNr0n4lKg/rgJCZhD5lzry5
	 Nxbdzga5SYSSCJ2/IdpSNhC8MAkex9QfUC47EYrOMzAkJupXKTlatKwMWAiopL1Bon
	 09Jw+oSs0itEg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmRbV-00000007VfN-1Z42;
	Wed, 22 Jul 2026 07:42:57 +0000
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
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v3 14/28] arm64: sysreg: Add HCRX_EL2 bits related to FEAT_NV3
Date: Wed, 22 Jul 2026 08:42:20 +0100
Message-ID: <20260722074234.3330999-15-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722074234.3330999-1-maz@kernel.org>
References: <20260722074234.3330999-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, yaoyuan@linux.alibaba.com, weilin.chang@arm.com
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

