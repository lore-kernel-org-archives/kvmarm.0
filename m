Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC7822E414
	for <kvmarm@lists.linux.dev>; Thu, 17 Apr 2025 10:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744886879; cv=none; b=rhNhB1iPAB2yKsoTrioXM6D+D1XRSXLJd9LuTFbfQSatGBDnVuNnJfRycmuvovKhJFqvY8+ma6xtfiffaxVPsThi2wxGMdZP3UnpfP4nK0TcGYRUIpv2Xhg4FqeqjXBsYH65s9iyQUxk/UCGGmWJIPY3cGt05/GV2f4gtGbcROk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744886879; c=relaxed/simple;
	bh=FsqgMOWA6HwEOqiI8oCsrw/0ONab4Rl0yNuVIkWVLF0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=cnF9MhC00QaNoFjVmrxKcU2FFx9bpWHaS44FAbZhSmOHbIFOes8yJD2+psvVvnPLjj+s0ALEag3p+TjmLqWOhu9bjgVketFkBybskhHHWtnTiRGjSA62jyFY3NQ7eKD2FVJ8qKruOpP+FjzpJxfu6+mfuD/sytAjU91dnsieRAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=Jx69SiQH; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Jx69SiQH"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53H5l5mI026055;
	Thu, 17 Apr 2025 10:47:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	joqHxGXRXWUcgQSeYf7DKuVd+np3iIts6YQmP7x6K7c=; b=Jx69SiQHMpE/wWCt
	zhJ7k3NwYmTdkSiwCAe9wp/l2NVyo3Vn/tIaZGuDvqDpaJHvHj6YUajRZ/2feNxe
	dgy+a0tRZ4VvJVEPnnlO1R2XCZ6VgLHqXZQH8tydryExXh0ldcGWhJwPMLT3CIbR
	bBanSofECfTj1oukWwpflMg6sLZ1oS3l3EF+dBJSelUEhnVoJQR5wJRbGef/dpJr
	5yzb9Pk3SvtGDOmwwxPHuTWG65awKm4GZ02bNNdeTGpn5KNefs0ma6FLkks5F6zq
	t3Ri59TvQZyFRqehnC41obrUdIvNOsQbXv80J279glP6GuCFRJPfWt+76ZHzB+HC
	fBswoA==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45yg8wpmhy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Apr 2025 10:47:32 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 53HAlVik011151
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Apr 2025 10:47:31 GMT
Received: from nsssdc-sh01-lnx.ap.qualcomm.com (10.80.80.8) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Thu, 17 Apr 2025 03:47:26 -0700
From: Luo Jie <quic_luoj@quicinc.com>
Date: Thu, 17 Apr 2025 18:47:09 +0800
Subject: [PATCH v3 2/6] coccinelle: misc: Add field_modify script
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250417-field_modify-v3-2-6f7992aafcb7@quicinc.com>
References: <20250417-field_modify-v3-0-6f7992aafcb7@quicinc.com>
In-Reply-To: <20250417-field_modify-v3-0-6f7992aafcb7@quicinc.com>
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
        Luo Jie <quic_luoj@quicinc.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744886837; l=1254;
 i=quic_luoj@quicinc.com; s=20250209; h=from:subject:message-id;
 bh=FsqgMOWA6HwEOqiI8oCsrw/0ONab4Rl0yNuVIkWVLF0=;
 b=fd62gXaWDF5y19XxQ7te/YJZc6YSFjACMSUUigIxJUXrnJdk7ngf0rnpLQ5LMdJDvnN3vkrw3
 bVNw2Sd2LhICLPbxvNh48NxeuuRY/IGya097fHXozJxW9ubsHf/9YHq
X-Developer-Key: i=quic_luoj@quicinc.com; a=ed25519;
 pk=pzwy8bU5tJZ5UKGTv28n+QOuktaWuriznGmriA9Qkfc=
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Authority-Analysis: v=2.4 cv=E9TNpbdl c=1 sm=1 tr=0 ts=6800dc44 cx=c_pps a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=ZOzjf2MOAAAA:8 a=COk6AnOGAAAA:8 a=V_falgm8geQyOEPxdJ4A:9
 a=QEXdDO2ut3YA:10 a=1Mhi-5-LkjG4w5oc0yAU:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: Frky8NHfJUnkO57daYP_0bmOxq9dDigo
X-Proofpoint-GUID: Frky8NHfJUnkO57daYP_0bmOxq9dDigo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-17_03,2025-04-15_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxscore=0 bulkscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=730 spamscore=0 priorityscore=1501
 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2504170080

This script finds and suggests conversions of opencoded field
modify patterns with the wrapper FIELD_MODIFY() API defined in
include/linux/bitfield.h for better readability.

Signed-off-by: Luo Jie <quic_luoj@quicinc.com>
---
 scripts/coccinelle/misc/field_modify.cocci | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/scripts/coccinelle/misc/field_modify.cocci b/scripts/coccinelle/misc/field_modify.cocci
new file mode 100644
index 000000000000..9022c1b23291
--- /dev/null
+++ b/scripts/coccinelle/misc/field_modify.cocci
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0-only
+///
+/// Replaced below code with the wrapper FIELD_MODIFY(MASK, &reg, val)
+/// - reg &= ~MASK;
+/// - reg |= FIELD_PREP(MASK, val);
+//
+// Confidence: High
+// Author: Luo Jie <quic_luoj@quicinc.com>
+// Copyright (C) 2025 Qualcomm Innovation Center, Inc.
+// URL: https://coccinelle.gitlabpages.inria.fr/website
+// Keywords: FIELD_PREP, FIELD_MODIFY
+// Options: --include-headers
+
+virtual patch
+
+@depends on patch@
+identifier reg, val;
+constant mask;
+symbol FIELD_PREP, FIELD_MODIFY;
+@@
+
+- reg &= ~mask;
+- reg |= FIELD_PREP(mask, val);
++ FIELD_MODIFY(mask, &reg, val);

-- 
2.34.1

