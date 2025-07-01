Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AC3273818
	for <kvmarm@lists.linux.dev>; Tue,  1 Jul 2025 12:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751373547; cv=none; b=Y+oBuGDmCP4jkzLYrJHa0nm6GWLgaGCWxSZzsbcylOwoQz2J59lwLB4/Foo2pq5XWnWskDGQ5vYfiVFmtbpQ917+RSZOhHcGZVpliTkkzL57343r/3Mw5rAwMy92+fnED1ihaNpJ46wQeA48/VSJozMU2fvyCZ+Pmybqlp0Ebx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751373547; c=relaxed/simple;
	bh=iQ35RxRMNQCWuVz6wds1TDAoTWkyLxSttohSUd9h/uw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=UJJaQq3MIaHYYOscTuKoFnUhKLBWZlPbl8RVhTdY5xgn1ilPt3TeWpLI0vHuiv+G1KJ34ra4R1aMzEowp4UirOVV9Sc7FolHxwl/kokiofB6ComuHYWJOnIFwgtEYh+LteCei4a/nDTCQRB9aQ3yakFhgS0Iaed+Bwk4QfwZzYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=JaAjpfC8; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="JaAjpfC8"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5619xE8R025936;
	Tue, 1 Jul 2025 12:38:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=D0xSXwHIHKslGMCqKYomGW
	DSUYjDlcHuSehLtkzTcd8=; b=JaAjpfC8Z25Yaw7qsM5+8bRvQXaiiyTL27ckxX
	wjtumROwd/TYVcv37ZAK2fxWoqIejY8K9RxlVb89t7ZSkVR5VFbi9r8k+owC+fhv
	aElLOueRIoRXBlee/4hlrJ+ybALxfzpwXTqVW7uVyKVxtxEfD8PUcrslCCE7EMMH
	mwbtuq9D52NbfJWQlphEeMgiZtFMosJnxTj64xHpyG6rpBpgdxKSdMFyh3DodX5w
	Z4Ehta0e2v5PoNktviGlHNRmsg0sOAArrxFHhXEYIcGPhrka6d9qYEI8NvG3TKW5
	mx1XAF1PrWGpAML7g4POcBMcWawWv3jJKtv4Yofw0+4iKB/g==
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 47kd64p4uy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Jul 2025 12:38:40 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 561CcchC006483
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 1 Jul 2025 12:38:38 GMT
Received: from nsssdc-sh01-lnx.ap.qualcomm.com (10.80.80.8) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 1 Jul 2025 05:38:34 -0700
From: Luo Jie <quic_luoj@quicinc.com>
Date: Tue, 1 Jul 2025 20:38:24 +0800
Subject: [PATCH v7] coccinelle: misc: Add field_modify script
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250701-field_modify-v7-1-eacf13f215b4@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAMDWY2gC/2XOTQrCMBCG4atI1kby10zrynuISEwyOqCtthos0
 rsbdaG2y2/geZkH62JLsWPL2YO1MVFHTZ0HzGfMH1y9j5xC3kwJVQgrFUeKx7A9NYGw5wqkrtC
 CLkvJMjm3Een+zq03eR+ouzZt/64n+bp+QkbCfyhpLrhFqCrlHPodrC438lT7hW9O7JVK5ssnf
 ySTuYsGwQRnCmenvPjhyox4wSX3wYJUILSIZsrtL7cjbjNXQgREp0snRs8Pw/AEiIY1/WcBAAA
 =
To: Yury Norov <yury.norov@gmail.com>,
        Rasmus Villemoes
	<linux@rasmusvillemoes.dk>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        "Nicolas
 Palix" <nicolas.palix@imag.fr>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton
	<oliver.upton@linux.dev>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose
	<suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
CC: <linux-kernel@vger.kernel.org>, <cocci@inria.fr>,
        <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
        <andrew@lunn.ch>, <quic_kkumarcs@quicinc.com>,
        <quic_linchen@quicinc.com>, <quic_leiwei@quicinc.com>,
        <quic_suruchia@quicinc.com>, <quic_pavir@quicinc.com>,
        <Markus.Elfring@web.de>, Luo Jie
	<quic_luoj@quicinc.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1751373513; l=4063;
 i=quic_luoj@quicinc.com; s=20250209; h=from:subject:message-id;
 bh=iQ35RxRMNQCWuVz6wds1TDAoTWkyLxSttohSUd9h/uw=;
 b=PJ4oIhaUHoma23HiPVd0lWXVogfovoMYZ7O6mYUHM1NF9N8vtT7r/NkoIBcsz/fhqchWHidRZ
 ADsLjFBjxmjBgoegKDUkjoc6PSGNJ7xucLDKfbGLga0p2AUFRvzW5kw
X-Developer-Key: i=quic_luoj@quicinc.com; a=ed25519;
 pk=pzwy8bU5tJZ5UKGTv28n+QOuktaWuriznGmriA9Qkfc=
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Authority-Analysis: v=2.4 cv=Z+PsHGRA c=1 sm=1 tr=0 ts=6863d6d0 cx=c_pps
 a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8
 a=COk6AnOGAAAA:8 a=05oQ047nAAAA:8 a=S47agHus8KO1I0bcMDsA:9 a=QEXdDO2ut3YA:10
 a=TjNXssC_j7lpFel5tvFf:22 a=vNAg3JWiabyzeNEprMgK:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAxMDA3OSBTYWx0ZWRfX1OqJOzwSyxTt
 KJOHDEbQ9y0kYIQU8Vjc0CjD50f9XGch41WwBGvcw4ccB19toIz6sS7Lw0H7ImoN8TfRsIr4MHj
 GVO1Fqg12GvZZkndtbU/EWRvixOyuvvwO4CZy16lDo7YD/JeKnlqJA/8dn5u3IHNBcM2DQit1JA
 +qol2OCuAJc46cciR4RBx4SLC2kEOpiwjoEUjvpxuvKirl4Ctccfe+4HHVIf4DowR2dj/6kRvBC
 tDbz4eQO7G2dEusTUuMVMepYKfsi2Zy2PpakjbHTHfUyZ9G1yDBfjrB79ge1NSnbG4/odJfJSNc
 XHGO8MgDg5hdPheL+xgcbcXMsZSHIX2IidAFpdFZO+o8ZaPXeBOQFoxGWEXtM1aK4j77spKE+7S
 UtFd6Q/TldBskckU6zemMRx+oWendbVk0+25abYcAd/W2aFugOu25/YVG0L3PLNbN3U633L2
X-Proofpoint-GUID: tO_1oIxOmqPMp9vNYDv0s4FdLkUaFSSS
X-Proofpoint-ORIG-GUID: tO_1oIxOmqPMp9vNYDv0s4FdLkUaFSSS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-01_02,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 malwarescore=0 mlxlogscore=999
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 bulkscore=0
 impostorscore=0 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507010079

Find and suggest conversions of opencoded field modify patterns with
the wrapper FIELD_MODIFY() API defined in include/linux/bitfield.h
for catching the possible parameter type error in the compile time.

Signed-off-by: Luo Jie <quic_luoj@quicinc.com>
---
Add the helper FIELD_MODIFY() to the FIELD_XXX family of bitfield
macros. It is functionally similar as xxx_replace_bits(), but adds
the compile time checking to catch incorrect parameter type errors.

This series also converts the four instances of opencoded FIELD_MODIFY()
that are found in the core kernel files, to instead use the new
FIELD_MODIFY() macro. This is achieved with Coccinelle, by adding
the script field_modify.cocci.

The changes are validated on IPQ9574 SoC which uses ARM64 architecture.
---
Changes in v7:
- Use a formatted string literal as the function parameter for the
  report mode.
- Link to v6: https://lore.kernel.org/r/20250626-field_modify-v6-1-200dffa38a07@quicinc.com

Changes in v6:
- Adopt the suggested code variant for the org mode.
- Link to v5: https://lore.kernel.org/r/20250624-field_modify-v5-1-cd67127030e4@quicinc.com

Changes in v5:
- Remove ARM64 patches based on the discussion in v3 and v4 versions of
  this series.
- Simplify the condition selections in coccinelle script.
- Link to v4: https://lore.kernel.org/r/20250612-field_modify-v4-0-ae4f74da45a6@quicinc.com

Changes in v4:
- Add org, report and context mode for coccinelle script.
- Fix other comments on coccinelle script patch.
- Remove the FIELD_MODIFY patch as it is merged.
- Link to v3: https://lore.kernel.org/r/20250417-field_modify-v3-0-6f7992aafcb7@quicinc.com

Changes in v3:
- Correct the order of header files included.
- Add the Coccinelle script field_modify.cocci..
- Convert the opencoded FIELD_MODIFY() variants inside arm64 directory,
  identified by field_modify.cocci.
- Link to v2: https://lore.kernel.org/all/20250410131048.2054791-1-quic_luoj@quicinc.com/

Changes in v2:
- Update the documented example for FIELD_MODIFY().
- Improve the commit message to describe the need for the change.
- Link to v1: https://lore.kernel.org/all/20250318071526.1836194-1-quic_luoj@quicinc.com/
---
 scripts/coccinelle/misc/field_modify.cocci | 59 ++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/scripts/coccinelle/misc/field_modify.cocci b/scripts/coccinelle/misc/field_modify.cocci
new file mode 100644
index 000000000000..3ed3739fdf10
--- /dev/null
+++ b/scripts/coccinelle/misc/field_modify.cocci
@@ -0,0 +1,59 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/// Replace below code with the wrapper FIELD_MODIFY(MASK, &reg, val)
+/// - reg &= ~MASK;
+/// - reg |= FIELD_PREP(MASK, val);
+//
+// Confidence: High
+// Author: Luo Jie <quic_luoj@quicinc.com>
+// Copyright: (C) 2025 Qualcomm Innovation Center, Inc.
+// Keywords: FIELD_PREP, FIELD_MODIFY
+// Options: --include-headers
+
+virtual context
+virtual patch
+virtual org
+virtual report
+
+@depends on context@
+identifier reg, val;
+constant mask;
+symbol FIELD_PREP;
+@@
+
+*reg &= ~mask;
+*reg |= FIELD_PREP(mask, val);
+
+@depends on patch@
+identifier reg, val;
+constant mask;
+symbol FIELD_PREP, FIELD_MODIFY;
+@@
+
+-reg &= ~mask;
+-reg |= FIELD_PREP(mask, val);
++FIELD_MODIFY(mask, &reg, val);
+
+@r depends on org || report@
+identifier reg, val;
+constant mask;
+symbol FIELD_PREP;
+position p;
+@@
+
+reg &= ~mask;
+reg |= FIELD_PREP@p(mask, val);
+
+@script:python depends on report@
+p << r.p;
+x << r.reg;
+@@
+
+coccilib.report.print_report(p[0], f"WARNING: Consider using FIELD_MODIFY helper on {x}")
+
+@script:python depends on org@
+p << r.p;
+x << r.reg;
+@@
+
+msg = f"WARNING: Consider using FIELD_MODIFY helper on {x}"
+coccilib.org.print_todo(p[0], msg.replace("[","@(").replace("]",")"))

---
base-commit: 0bb71d301869446810a0b13d3da290bd455d7c78
change-id: 20250612-field_modify-27139f673881

Best regards,
-- 
Luo Jie <quic_luoj@quicinc.com>

