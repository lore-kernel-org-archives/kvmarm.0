Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6D61DD541
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 17:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728323184; cv=none; b=k5mE6U6SUT0U6f9xUj5lXn1Mdj60dBlsk2K8qboS57m13rPVdzQ1nvlXNVPFLIWPPkD5ewlcAUNy7tngyVAV4mN18im3TVJcRb+FWL8HD7wnTHNvv/KzY9h+fMAADUhS3y63r1IyQ/fzUDgBo2bXUCP3qDEBITkwEGX16mGzH/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728323184; c=relaxed/simple;
	bh=8jZz8b8vNsRbHhGXi8AqlrCIMdG2vd2Ay6wwA6WM21Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YpgcQjslhFrU50EPw0atlPqmWxwPPUkS2xFFreCpFwa1cMLG7XWIozoHiBQmNSdlRAv8Iv3tLf5hBeeC+c7rWtuQsauUmylsbCiOmppFjymY8gMHoosMxBu7afmpl4NT8Sr8yoTqQJb07asbT77MAQWkQ3fWT2HlhZ1Y+AfxMOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X17pkfIo; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X17pkfIo"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728323181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rYYZPdVnSGkDtNM+ZvpDStatIyKxq3GMWyNVbkCAv9g=;
	b=X17pkfIoBPPSB4dST8Xf6GtBnmEoAZLUvY8C38hdDDCNF4g8WgL7J+XiKm5ZgJrMnYUGj2
	DlQysyQGMDGQni1ibEQETqHY14mteIR61eEHJLXFf73qpfkeGFiSWMeUDvybXIQXTuE1RC
	yZ1UXDDA/PuDj6+2EK2BC0oipKSoL9E=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 03/17] arm64: sysreg: Add missing definitions for ID_AA64DFR0_EL1
Date: Mon,  7 Oct 2024 17:45:45 +0000
Message-ID: <20241007174559.1830205-4-oliver.upton@linux.dev>
In-Reply-To: <20241007174559.1830205-1-oliver.upton@linux.dev>
References: <20241007174559.1830205-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Align the field definitions of ID_AA64DFR0_EL1 with the current state of
the architecture, and opportunistically mark MTPMU as signed.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/tools/sysreg | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 0cb381c7e582..cfbd5473516d 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1200,7 +1200,7 @@ UnsignedEnum	55:52	BRBE
 	0b0001	IMP
 	0b0010	BRBE_V1P1
 EndEnum
-Enum	51:48	MTPMU
+SignedEnum	51:48	MTPMU
 	0b0000	NI_IMPDEF
 	0b0001	IMP
 	0b1111	NI
@@ -1226,9 +1226,15 @@ UnsignedEnum	35:32	PMSVer
 	0b0101	V1P4
 EndEnum
 Field	31:28	CTX_CMPs
-Res0	27:24
+UnsignedEnum	27:24	SEBEP
+	0b0000	NI
+	0b0001	IMP
+EndEnum
 Field	23:20	WRPs
-Res0	19:16
+UnsignedEnum	19:16	PMSS
+	0b0000	NI
+	0b0001	IMP
+EndEnum
 Field	15:12	BRPs
 UnsignedEnum	11:8	PMUVer
 	0b0000	NI
-- 
2.47.0.rc0.187.ge670bccf7e-goog

