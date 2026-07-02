Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5A331B824;
	Thu,  2 Jul 2026 16:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008184; cv=none; b=Fuw6BUz7fH832qKhk059PJ9l0bq1FZSanY51Foc97/WqZHe7OcaYcR7v3xR/iUHtiJJ1owwR8VlkS/Rcpwed4KmPcO6vZ/6EXK3ncUCTteumRO4jo3BE0CMFfqmLlv69oDQvdNRYyUN5SXJaQFFTKf7+VCUzAyBgIWAcykk+aYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008184; c=relaxed/simple;
	bh=oS0X5gZHA61g9Vf/fBgFVeC3lnQswW3HRCPJyt8UPk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZlOio7QMHMKVS0ue3qBIJpmqjcqnjo8vEP63M+icW4r9zwYQj+39Jy4Cn7VZAh4pVIqypYnVAGmqGe6iVybkie8OXq/WLYxvYx+6iLQtwnI51YiyKb0wRdK23Jjk+CzIn0ba0HJsCe4xKIie60i+alBqdy/N7v25HnRkiu1PQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UAxa94T7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UAxa94T7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F2D1F00A3F;
	Thu,  2 Jul 2026 16:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783008182;
	bh=RtXDFqw6p2zDy0q9A7tS+b3EKzCFjxgTHXGegH5U6qY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UAxa94T7EmbepHPVbK6oa+R/OCZ/xrqasAzsNAlbLogWczaesIDkunCXlbZeAmywy
	 vx5F/dY7D1a7stzMIi+9+SWQVixDdmeSnDQ7gS5rNijSa4kty1ErCqhC0Awt85hMGL
	 JjH2rbdPPVJ/KzSfFllSbggdJFhbhQAy13yxR7BGATyBJL7R38kV8WhR7X+kwIJfzF
	 b5Mt4X8Bj/k0w7OOVzQl+5WjT382r5F1RiaNfE8A1PnzamrYzrtvyfL2YKsbLkHzZ6
	 BAhJNiVqJ+Q76MsZhOmtgVmyairfAmJ/7GhIrOFNc2dtHrPE/U5Wdt3IceMuGtiCLn
	 aeARJfuuPvPrQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wfJsS-00000000ojd-422v;
	Thu, 02 Jul 2026 16:03:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 14/28] arm64: sysreg: Add HCRX_EL2 bits related to FEAT_NV3
Date: Thu,  2 Jul 2026 17:02:34 +0100
Message-ID: <20260702160248.1377250-15-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702160248.1377250-1-maz@kernel.org>
References: <20260702160248.1377250-1-maz@kernel.org>
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

FEAT_NV3 introduces 4 new HCRX_EL2 control bits. Describe them
in the sysreg file.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 31e4ea455a9ce..afe9337851a2e 100644
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

