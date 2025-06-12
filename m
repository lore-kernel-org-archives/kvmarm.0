Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B744F245023
	for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 13:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749736022; cv=none; b=mbO2nw4UkXwEhqp36/hkKKUqzhI5G8+ldCSPWEGxLBTuHZPtZdBTXL/vadyU4/8mAvA6bxHcNISG7UwuI4ENuaw0VsiclMtha03y4VVoWVgoFF/NO5zx5JFN7st6qZMXdb3YQZ9VwMQRMxMLv8j5M5NruJxz8SmvCEMpvIVgdmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749736022; c=relaxed/simple;
	bh=67KHPK0ryj5WYDYDXexeSpchGNbTFtE5nDzepjRpz2w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=NU1zrPl/sFgJeoD9ai4O7anr6n2OP/9lU0FBkKlWW14kJ+XT3NbKbuFYk8HX3rjzkRjClQ1k/ePZOT7GDEyhPfUD2ejn9bYm9lZNdB7ouIR46r4iZLaQMf6ck4WPvLepBLdUcZ6W8jagF697luDopJOVFjjEWqkS5LQns4Ld24o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=RQ6PsOvP; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="RQ6PsOvP"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55C7emFn026020;
	Thu, 12 Jun 2025 13:46:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	x1aM1/RH/pAvF5wMxosW5xMQEnEHvU9V8b+/IGhMbko=; b=RQ6PsOvPbmUc2k63
	MpaiDqoVd+/4Ms7pv7QZ9CEB+A2PSsbkfhBO0L8H5rhO3GOE+znwNsvfiyuZ3xbY
	IiWpS/OR7M/tbz67azpmbIot2y7DTfOc5+yxcxpr0fVpFt0RoFin+NRcPHAzYq91
	a4Qolrx1D4/zcqkndchg+oVoLLnDkSqdog7ri4WJlsRdj4BDjuzwysAYMsXr0owi
	J/6dlv25/CbbDCqTmGz6GDCQrev8sE9OKxbCvT22Nt/1lX+I3N/knjgQxqrf0upw
	JlTZvifj/xU73mlhmu1XsjZ8OQIrwpU1RGVm5796k6g4bmgNDEUzPGp9+cagrUJ0
	bmstMA==
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 475v2ybhe8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Jun 2025 13:46:23 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NALASPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 55CDkMTi030294
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Jun 2025 13:46:22 GMT
Received: from nsssdc-sh01-lnx.ap.qualcomm.com (10.80.80.8) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Thu, 12 Jun 2025 06:46:18 -0700
From: Luo Jie <quic_luoj@quicinc.com>
Date: Thu, 12 Jun 2025 21:46:08 +0800
Subject: [PATCH v4 1/5] coccinelle: misc: Add field_modify script
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250612-field_modify-v4-1-ae4f74da45a6@quicinc.com>
References: <20250612-field_modify-v4-0-ae4f74da45a6@quicinc.com>
In-Reply-To: <20250612-field_modify-v4-0-ae4f74da45a6@quicinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1749735973; l=2080;
 i=quic_luoj@quicinc.com; s=20250209; h=from:subject:message-id;
 bh=67KHPK0ryj5WYDYDXexeSpchGNbTFtE5nDzepjRpz2w=;
 b=MynC0pYX9Gv44FXGa3PgGdulk7VDm8uFk33/XLd0kf5RVAs3oe7amKe2dYFqLnvfyUx8W/sO7
 coZ/hJ2Y+6NDMnBRlz8KI5Rv00X/ldzEzE+OETZwsIwzNRQF3sppunv
X-Developer-Key: i=quic_luoj@quicinc.com; a=ed25519;
 pk=pzwy8bU5tJZ5UKGTv28n+QOuktaWuriznGmriA9Qkfc=
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEyMDEwNSBTYWx0ZWRfX9fjypbZRF9us
 TSdivsvAB3bdNAS/dxa3k/4waJ8PLm46wEH5ll9rscH0cPBNAm0qpQaSyq9lgMCjbVPc50L0yan
 3H2TzimlAdE4ZR2p3bJuBlteOc55c+S79y0VpU4swAbb/On/+nzuZu8kpX5BV4wVskOWbM/m2Em
 cEo2ztZ33frACuREuAeeIoO30RjEAY5G0odY+oHdvVq57zTo6vvY6w27GOeBTRZKMEivQDzD/vB
 DlH3VNKvg6f/hHorTbQH7bWnEA80VCyDbqThyRRL/ISqU1OAckF5WDuYnIcdkT3zWAlRfRqsokY
 H96EOxoC8aLjgCeao/C357UZGg6XExEp+SpWeEU9McpNIqg7SM1Mj9G0j0NjqJoUzF4huvJUiz9
 T5lEUkC87MRY9PwQbks7ZYBhRPTcOZTfwX+46GTc+7SztAUVBJmPrsRNnZ3qfS5KXAc4RcFD
X-Proofpoint-GUID: F-nCuB_1zsCz5ribdNyO6PeJKsI-5Y3m
X-Proofpoint-ORIG-GUID: F-nCuB_1zsCz5ribdNyO6PeJKsI-5Y3m
X-Authority-Analysis: v=2.4 cv=f+BIBPyM c=1 sm=1 tr=0 ts=684ada2f cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=COk6AnOGAAAA:8
 a=05oQ047nAAAA:8 a=l05NuDNGqYqV5CF8ttEA:9 a=QEXdDO2ut3YA:10
 a=TjNXssC_j7lpFel5tvFf:22 a=vNAg3JWiabyzeNEprMgK:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_09,2025-06-12_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506120105

Find and suggest conversions of opencoded field modify patterns with
the wrapper FIELD_MODIFY() API defined in include/linux/bitfield.h
for catching the possible parameter type error in the compile time.

Signed-off-by: Luo Jie <quic_luoj@quicinc.com>
---
 scripts/coccinelle/misc/field_modify.cocci | 61 ++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/scripts/coccinelle/misc/field_modify.cocci b/scripts/coccinelle/misc/field_modify.cocci
new file mode 100644
index 000000000000..48b00194a265
--- /dev/null
+++ b/scripts/coccinelle/misc/field_modify.cocci
@@ -0,0 +1,61 @@
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
+@ depends on context && !patch && !org && !report@
+identifier reg, val;
+constant mask;
+symbol FIELD_PREP;
+@@
+
+* reg &= ~mask;
+* reg |= FIELD_PREP(mask, val);
+
+@ depends on !context && patch && !org && !report @
+identifier reg, val;
+constant mask;
+symbol FIELD_PREP, FIELD_MODIFY;
+@@
+
+-reg &= ~mask;
+-reg |= FIELD_PREP(mask, val);
++FIELD_MODIFY(mask, &reg, val);
+
+@r depends on !context && !patch && (org || report)@
+identifier reg, val;
+constant mask;
+symbol FIELD_PREP;
+position p;
+@@
+
+ reg &= ~mask;
+ reg |= FIELD_PREP@p(mask, val);
+
+@script:python depends on report@
+p << r.p;
+x << r.reg;
+@@
+
+msg="WARNING: Consider using FIELD_MODIFY helper on %s" % (x)
+coccilib.report.print_report(p[0], msg)
+
+@script:python depends on org@
+p << r.p;
+x << r.reg;
+@@
+
+msg="WARNING: Consider using FIELD_MODIFY helper on %s" % (x)
+msg_safe=msg.replace("[","@(").replace("]",")")
+coccilib.org.print_todo(p[0], msg_safe)

-- 
2.34.1

