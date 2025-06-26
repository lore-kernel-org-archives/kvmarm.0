Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C02B2185AC
	for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 06:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750917789; cv=none; b=f/vbcN7zJg+kWKi+x6dYF49iRieDqd30BCKQfMI6TKGmpurEMrV2pmAKrkomPVdTDrBGP3mbK45W67K/FOOIqIXFjpC6sEhkAQfW8trl8WRAxoxFAc3Jodmqw2zYJnOIKaGQkAN5PvKuhRbRnPaqWgS4Fuh9ZSCbELof39jUfkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750917789; c=relaxed/simple;
	bh=ux/mTJ8E+wX+kajs9XBKrd9beBovgB6YKCu98nQUhUo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=Pm5azrct2Ivl7LARx7JpQJEultl7mx8iXWbOQOkZF+LbOThTQu4JH1t7Zo/10dw2UZbZZ48X7WMm2Z+2756nFs99Y16ll+VRvq97bdPZLHbkiRp6kI4QfPAaKLY0GLUYgKQkVeOp4e2n39wh0EeG/7TDlVgM0D0bI4ggPz6gK/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=UPbuRMVE; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="UPbuRMVE"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55Q4WonY010573;
	Thu, 26 Jun 2025 06:02:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=MpPYhArlXmWCgYgW4qeCuw
	s8Mpxw0BvsnQQWeZhvzM0=; b=UPbuRMVERhUxDEZzGrapMCXznkNIzr7w0yT8hW
	svXcbwZ+1vjukeeO55jUVfUuJ3S3sZ5aJV5kIHMmUBNl7I44nKfeE8ksB2anT1pa
	NCTO7jfz/So9qR72yn42knhuDxaNJcQ8xKKCmcGLqJsOnLFindpIrHCq+sLBNjuz
	FxbISy0eI+60M7rR9JUdX3GhLc4mjgis/JtbeXkNqxJzL3NdJtqGdAPWLVfCZLOU
	OrOtYzHpt8BjqVNRDmijQxhWSCM0JmV7kb67d91IxF/ZfTRi2QzOslZN6Cc+HCKP
	T3vPIgAWjKLwxAh1fZNUbr7MsfTjBk5VG0dhuF7FS37H+IPQ==
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 47g88fbw4c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Jun 2025 06:02:36 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 55Q62ZbK014364
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Jun 2025 06:02:35 GMT
Received: from nsssdc-sh01-lnx.ap.qualcomm.com (10.80.80.8) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Wed, 25 Jun 2025 23:02:30 -0700
From: Luo Jie <quic_luoj@quicinc.com>
Date: Thu, 26 Jun 2025 14:02:20 +0800
Subject: [PATCH v6] coccinelle: misc: Add field_modify script
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250626-field_modify-v6-1-200dffa38a07@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAGviXGgC/2XOSw6CMBSF4a2Qjq3pixYcuQ9jTO1DbiKgVBsJY
 e8WHCgyPDf5/twBBdeBC2iXDahzEQK0TRpykyFT6ebiMNi0ESMsJ5Iy7MFd7aluLfgeM0V56aX
 iRUFRIrfOeXjNucMx7QrCo+36uR7pdP2EBFXLUOSYYOlVWTKtvTmr/f0JBhqzNW2NplQUX776I
 4rEtRNeCatFruWa5z+ciT+eY4qNlYoyRThxYsnHcXwDlLj04SgBAAA=
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1750917750; l=3872;
 i=quic_luoj@quicinc.com; s=20250209; h=from:subject:message-id;
 bh=ux/mTJ8E+wX+kajs9XBKrd9beBovgB6YKCu98nQUhUo=;
 b=SeVIF7MxdkxmO2LE2JP0k/HUfsPK/T+wakKidgrx0NOm7aKMlpXxE9R7z5KxWkTvp24OxHmh6
 Qiyxud6avYeB9BngiBtHC1UwyTw3mxEhuf/qSKDCTlhD5eA/Iu23k0Q
X-Developer-Key: i=quic_luoj@quicinc.com; a=ed25519;
 pk=pzwy8bU5tJZ5UKGTv28n+QOuktaWuriznGmriA9Qkfc=
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI2MDA0NiBTYWx0ZWRfX/msli3c7dzzA
 pQfUlU6zJZDj6mqYCP5F3geXzxrFBwq+d/e1m6IGN017415Pn2T+OywwLY/ZtXJ0a4hBFLqN63K
 uo2Q2erLY99EF8jwveTACksI+K+i3HwgaCjSPO5xCpaQ8MWVfRcwyKzvi7zFaC9ElTKO7A/sdmz
 WELOZfjuJucj6vnl73EyfTS7yN3SlwbLfcSpj8ycF/tkeRHRtsuJUeXBuN5Lu3FNg56rQbspAS6
 Vv85XUTy6TmuU5DdmK/o/8pUmyPap4/QGhPmzglIis6l8hfFIRyoJuHPYV3AlVDfduLA7dsgGJU
 lUX0wdZ0iQTK0odQSfDWIbsEI94OsSavOfGUbIzYyXAfbk4gUta/rdtW3HlSmstkWjnjT8H1qxa
 vG0mUe0pk5gJpE35ckH2YzOzBXfsMrYWxG/JwqVCnDr9/lXMT4muAtX2aZHupt/KbTbXKZuj
X-Proofpoint-ORIG-GUID: zaYYXVueZahctmNJ9GD006cERxboO3-t
X-Proofpoint-GUID: zaYYXVueZahctmNJ9GD006cERxboO3-t
X-Authority-Analysis: v=2.4 cv=LNNmQIW9 c=1 sm=1 tr=0 ts=685ce27c cx=c_pps
 a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8
 a=COk6AnOGAAAA:8 a=05oQ047nAAAA:8 a=S47agHus8KO1I0bcMDsA:9 a=QEXdDO2ut3YA:10
 a=TjNXssC_j7lpFel5tvFf:22 a=vNAg3JWiabyzeNEprMgK:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-26_03,2025-06-25_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2506260046

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
index 000000000000..bdc5a65a1b53
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
+coccilib.report.print_report(p[0], "WARNING: Consider using FIELD_MODIFY helper on %s" % (x))
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

