Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D8E26A1BE
	for <kvmarm@lists.linux.dev>; Tue, 24 Jun 2025 10:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750760880; cv=none; b=kR4bNyyt21V7kGGIlRP+XUgkTejqI1ReWev2BBUROTqi37EIxKzvwtQDx5Y1oA6dntYlESAhTjNKZ3QHkNH+hZDsaRTKFNR77/tTVo9R60b86kbip76f7Tv2P18REVMuVKnYC1G7inVIuxDHtQ0o4AA3MgD+g2ZZkfasArBEJPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750760880; c=relaxed/simple;
	bh=p1OjU6YIg8nbWOiOSNhQGKGurpfgAli/KsTjTdOO6vw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=MWmNEewqEqx/5+aZRBYZRdSMz9U6S7C0SoZocKNUViImi7SkBOD1DSXSaGe8ESEXpNKK/MxKQGmZQDHP986GnbbAuhYDUd4eCJAeNy16uWZxatZt1Rdm7Xh7mV/Un+LBLkJRUOpzqkzoUVl9SbL5Ibis/ajrVLKNc+z/NvXzris=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=nuxf4uHj; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="nuxf4uHj"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55O8htSV014586;
	Tue, 24 Jun 2025 10:27:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=gMJA6NAJR2A7pml2JJY+PM
	5teThKF5egGycriSbEEuA=; b=nuxf4uHjX8bbDtYrc9iVDIY3fYsQCe/ZpKZYCl
	S9RvlJHaIv9ojjc+BpTPTnGwE4MLe3OYoyqdH1vH3GfSaLG1VOzMn7NKwopymLbK
	NL05gVxAL7Bw87sZHP2ZQss6XlIpcRGgT4UJPxQHSUfPnDLx+H8fqrJVmz6ixg+o
	3AIbSCZFI9n9IGZ7ZZISXTK8kTv5DHERnmYPkiMAh6koHepvsm6QIExBrWlZj1wJ
	aqjt20oE2r4ifYiG+J0geHd2AkEPkQwNql2zz7gGsNqKi2BMjJZfy1zVrcX+0EwM
	LraMzzoafsgBIctHtej9Ah85LO9w4WjjqLxsJbBmawccBpTQ==
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 47f2rpuwu2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Jun 2025 10:27:35 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 55OARXHT005103
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Jun 2025 10:27:33 GMT
Received: from nsssdc-sh01-lnx.ap.qualcomm.com (10.80.80.8) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Tue, 24 Jun 2025 03:27:29 -0700
From: Luo Jie <quic_luoj@quicinc.com>
Date: Tue, 24 Jun 2025 18:26:59 +0800
Subject: [PATCH v5] coccinelle: misc: Add field_modify script
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250624-field_modify-v5-1-cd67127030e4@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAHJ9WmgC/2WO0QrCIBhGXyW8zpjO6dZV7xERpr/thzZLSxpj7
 55bFzG6PB+cwzeSCAEhkv1mJAESRvR9hmq7IabV/RUo2syEF7wqJOPUIdzsufMW3UC5YmXjpCr
 rmpGs3AM4fC+54ylzi/Hpw7DUE5vXb0gwtQ6lkhZUOtU0XGtnLurweKHB3uyM78icSuKn//1II
 usahFPCalFpudanafoA2nxjJukAAAA=
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1750760849; l=3729;
 i=quic_luoj@quicinc.com; s=20250209; h=from:subject:message-id;
 bh=p1OjU6YIg8nbWOiOSNhQGKGurpfgAli/KsTjTdOO6vw=;
 b=EvDaEMFMGqjUm9zmrAux1lHP3BkNmwfDspYAze/4BpA/c2GH1Z5Hyu2R+qLspqEbM5bk+GzO7
 k80tqlLBl2oCy/XIEys8rAN1Xas+bQDgH/xGJLUzmz/9xnuW4oPwOZy
X-Developer-Key: i=quic_luoj@quicinc.com; a=ed25519;
 pk=pzwy8bU5tJZ5UKGTv28n+QOuktaWuriznGmriA9Qkfc=
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Authority-Analysis: v=2.4 cv=NdDm13D4 c=1 sm=1 tr=0 ts=685a7d97 cx=c_pps
 a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8
 a=COk6AnOGAAAA:8 a=05oQ047nAAAA:8 a=kXShSgmZOANboR8bh70A:9 a=QEXdDO2ut3YA:10
 a=TjNXssC_j7lpFel5tvFf:22 a=vNAg3JWiabyzeNEprMgK:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI0MDA4OCBTYWx0ZWRfX7+gla0WLZTLw
 qQLIjXCkfOZkaS8Hn10W/G/bqpqNOaYtJn7i97I4Bna33DcYTdZwp2uNOIPk87z3U/K3SRM5xkV
 qWq1DebNRszuCuTAT5ajCaE4UaAJ9NvYBu5fAaXlAkIowyPuelYxhjPc9f97tuGPH6fvaT5SzBg
 JiOs4X1dYMWKt1A7t6W6aE2j5SVJYCPPmzHffAHzJIjy1FujXLS8Oent6GRuRH7YNbZbvlnssUw
 afEZ2C0wbaQPAgo+gXvFplZnEKHlbhlsGyOOiPJfEACjQtMk35drLEKpBAcAirxNdLmJM/R0Urf
 O0EhX4EoIlcyi+ULMIivKGl0fcZjPk3zQnI1pMAPGb1rVtGYSvqmoxSXzm8U9PCkKLU+rOuGmEI
 HMQHpd65VRtO4r+IDb+wLU4V/WNqBNwyzMyvHKB6Lse/YeO1mWuWF9RYRFd6shtflDX5XJa2
X-Proofpoint-ORIG-GUID: bBYdcg27e70Jt-qUd8paLk1p9Sens5aL
X-Proofpoint-GUID: bBYdcg27e70Jt-qUd8paLk1p9Sens5aL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-24_04,2025-06-23_07,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 mlxscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999 adultscore=0
 clxscore=1015 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506240088

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
 scripts/coccinelle/misc/field_modify.cocci | 60 ++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/scripts/coccinelle/misc/field_modify.cocci b/scripts/coccinelle/misc/field_modify.cocci
new file mode 100644
index 000000000000..7d4858c0a68d
--- /dev/null
+++ b/scripts/coccinelle/misc/field_modify.cocci
@@ -0,0 +1,60 @@
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
+msg="WARNING: Consider using FIELD_MODIFY helper on %s" % (x)
+msg_safe=msg.replace("[","@(").replace("]",")")
+coccilib.org.print_todo(p[0], msg_safe)

---
base-commit: 0bb71d301869446810a0b13d3da290bd455d7c78
change-id: 20250612-field_modify-27139f673881

Best regards,
-- 
Luo Jie <quic_luoj@quicinc.com>

