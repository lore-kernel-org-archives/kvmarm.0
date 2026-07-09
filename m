Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com [209.85.167.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369D5386572
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 22:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783636637; cv=none; b=KjVMBEwbHcfIcSatHmka/RLRcAHnvvB3u8RyzZLpSljtLq8MfaIp49fnHiZWM5/QfEqppVhyoygQYU1s+p+pLhuOLHTvb1pLT4Zp+9RjeraQBBIjJclpbyBrSYSJDutu9xima2Q2Ywfe4WM6zBOvzkjkhW+JQF+rvakvK8wY+p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783636637; c=relaxed/simple;
	bh=AHjoK9vEXc/x2kH5t/vxAjKWX/gAycwwhcHLRoN8MY0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=njyBUP7XRabAZGQPdDp0Axbvn9L7HTJliCynHn5Yi9WzW/SqtZQuTpZgE7+eR2rJ2i6KEz+BttCc4Buh/dd3puU5Q2+NsxQpuV8ksCx2RD8SxAWiAfLH7dAk7bW5QNUI0fHuQdRmOT7rHFGEB6J0xQ9cI7ggDhAu7AQE0IxdZs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IL5xOZW7; arc=none smtp.client-ip=209.85.167.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IL5xOZW7"
Received: by mail-oi1-f201.google.com with SMTP id 5614622812f47-48f680bda84so348924b6e.1
        for <kvmarm@lists.linux.dev>; Thu, 09 Jul 2026 15:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783636635; x=1784241435; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r6N75Ip0e2UbcuvkSUVcoFLBJD3su3VCJTRAaxl2PPE=;
        b=IL5xOZW72dCs4oBk2o5QkihkdcbWbKW+bIWyCRKUPfZK18KU+ehzGxJ1tQIXlSMT8S
         TyDVI/LZ7PwIoxcFG+8WQuhkBvWzpGLk+IgzutwXXdPESwKXn05JPkwjz5ez9dkmmLwl
         sh00hWrNFF1/Sl2wC+XwAMs6dDqqV9oDyW1obIFTX3Lt91sUNdQDDT3OyrQhYk60FsnQ
         hS99ktMJKonUzWTwJVpeekm/qTd0dwN036bHP1UkDuK/c+IP/4bxP9ZJkeldCL5+X8zz
         ojx8NAvaQx1yqGzmk8BErYYuSMQBfZmg2C/8UR2s8l8DJazQAvLNVdVlMsZvdXHLEXIU
         tJtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783636635; x=1784241435;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r6N75Ip0e2UbcuvkSUVcoFLBJD3su3VCJTRAaxl2PPE=;
        b=QgjVnYjbWotR3WbD0VsAbQJXKB509vLoguxn2tiXy7kDU0dQKOu9H0OBBv2aYj66PV
         fbVq+N9pkdONztaSMJHYCc5NJiMFRTFZnzTbVHob8igitrOuy3wStAeoR+BL4ezxWhAQ
         aVOrgDLCdZe6n7B+sBvO5dm3kZG2gJMBRj1upplOeI1z6AV+TTtmto9fnQoBV7uVaQbL
         lpks+X7GudbjKwTL1gF3nSrW7//Qjw+wYE1mevjTptsQGO80txZ23xVQBcCw7PSIXa07
         NbZs8T0OcsQ9Q+y3O766qV1cZDsmIt1fQAC5Uy86GeHZTwYY8mbDR7yax+3MfglGJG6G
         9LFQ==
X-Forwarded-Encrypted: i=1; AFNElJ87JUn7TRV7jcMKFT+vEjpAzEpSjM8eiN8K0AmJ4mGKJQOK8bIcZzN7bM3OjkZaoZzDXYDPLxo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/AZVfa72Vis9x/jORPVSNYA1hkHJJIZOW9CPtNdPF+EsRPiBx
	Y10D3u4Ka9qeEYxNKOZKoQGQnFeXNGLqlT7yUyFltVgFimQDxeZnGCMIU7Os8itixcnHf7TYlDc
	tjv7JUfhkx9RGPw5iBU9sdAjjBQ==
X-Received: from jadk1.prod.google.com ([2002:a05:6638:1401:b0:5e7:1c51:6f8b])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1206:b0:495:e997:528d with SMTP id 5614622812f47-4a201bf3c63mr5975498b6e.3.1783636634820;
 Thu, 09 Jul 2026 15:37:14 -0700 (PDT)
Date: Thu,  9 Jul 2026 22:35:58 +0000
In-Reply-To: <20260709223604.12934-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260709223604.12934-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260709223604.12934-2-coltonlewis@google.com>
Subject: [PATCH 6.6 v3 1/6] arm64: sysreg: Add layout for ID_AA64MMFR4_EL1
From: Colton Lewis <coltonlewis@google.com>
To: stable@vger.kernel.org
Cc: oliver.upton@linux.dev, sashal@kernel.org, gregkh@linuxfoundation.org, 
	mizhang@google.com, catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, ahmed.genidi@arm.com, leo.yan@arm.com, 
	miguel.luis@oracle.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit cfc680bb04c54e61faa51a34d8383a0aa25b583f ]

ARMv9.5 has infroduced ID_AA64MMFR4_EL1 with a bunch of new features.
Add the corresponding layout.

This is extracted from the public ARM SysReg_xml_A_profile-2023-09
delivery, timestamped d55f5af8e09052abe92a02adf820deea2eaed717.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
Link: https://lore.kernel.org/r/20240122181344.258974-5-maz@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/tools/sysreg | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 76ce150e7347e..f7180d391f829 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1669,6 +1669,43 @@ UnsignedEnum	3:0	TCRX
 EndEnum
 EndSysreg
 
+Sysreg	ID_AA64MMFR4_EL1	3	0	0	7	4
+Res0	63:40
+UnsignedEnum	39:36	E3DSE
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Res0	35:28
+SignedEnum	27:24	E2H0
+	0b0000	IMP
+	0b1110	NI_NV1
+	0b1111	NI
+EndEnum
+UnsignedEnum	23:20	NV_frac
+	0b0000	NV_NV2
+	0b0001	NV2_ONLY
+EndEnum
+UnsignedEnum	19:16	FGWTE3
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	15:12	HACDBS
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	11:8	ASID2
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+SignedEnum	7:4	EIESB
+	0b0000	NI
+	0b0001	ToEL3
+	0b0010	ToELx
+	0b1111	ANY
+EndEnum
+Res0	3:0
+EndSysreg
+
 Sysreg	SCTLR_EL1	3	0	1	0	0
 Field	63	TIDCP
 Field	62	SPINTMASK
-- 
2.55.0.795.g602f6c329a-goog

