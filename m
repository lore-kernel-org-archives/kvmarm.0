Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D079222E015
	for <kvmarm@lists.linux.dev>; Thu, 17 Apr 2025 10:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744886885; cv=none; b=R/FP4eG95CVBuyQPUAr4ZxCY/1USYW1OuDi8uAa6sNMNve2FlUSrhX9UYFnGUBsAd5YqFbN3x6VQXMV/UI+pQwPeeGkEaRC0zBi6isvfnIa3wANS8JKNLr9Z12qmiPQMz6PZD/7S/cNpJEbS89+ANnVwfbcOFZk3NUFHbd31chE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744886885; c=relaxed/simple;
	bh=BTrhh55yMb7cCbPZyADxkhifxyh70Jy6fVzDF7gg+Go=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=k57DqYNeSh6ZiQlc5F1MrnTIfAwp1OlqZg2dIsf9gUNnsseAQxuBKiHFYQ8JgvF3VBHOCAdfVwhxUc203fLvzsBxw+UftzeY0bmnLDOiGHGTh24rrb+Pn6mBRZO3xJACPZhG1K4JizvXX1MY5PaUNb/Mi97khy81h6HImB5BR30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=FQMLOvU6; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="FQMLOvU6"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53H5l4b0009289;
	Thu, 17 Apr 2025 10:47:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	2vUtnJERmDPMRwfb9WPRiqeU5l4lGHI2IYPwOWBEt0Q=; b=FQMLOvU6JaUT+O2F
	Cpxl96N85uMFfEvZs8UsynDIb1V5Lwjftw3Oc2ZQSU/OvMaSc0mkzRxJ75t6lV5K
	uDjRksZzL4zkVR+/HgPTzahrAUDP9ejSfwIYjF+WLYy/opS2litjlIWpd/FTDkI1
	7on2leP6WzcuaHHKipzObOVP10k2s8Zkt7wuYYjH9IqfHjLL5uidf2+5hQB/JGgV
	xcydMZe9+ItMzlPDyKzjUHO+syMnohg+jTewlU7gcWOX333uWtpAxKnyfH9nibkY
	Z5IUvy74PLqVIAxYHk5w0j/C5PhYpsa+VUDKAPXKALKkW5pSU+Q3Tx6FinR/4Mqb
	wLg3Nw==
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4628rvbuw8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Apr 2025 10:47:45 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 53HAliWc013807
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Apr 2025 10:47:44 GMT
Received: from nsssdc-sh01-lnx.ap.qualcomm.com (10.80.80.8) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Thu, 17 Apr 2025 03:47:40 -0700
From: Luo Jie <quic_luoj@quicinc.com>
Date: Thu, 17 Apr 2025 18:47:12 +0800
Subject: [PATCH v3 5/6] arm64: kvm: Convert the opencoded field modify
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250417-field_modify-v3-5-6f7992aafcb7@quicinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744886837; l=1186;
 i=quic_luoj@quicinc.com; s=20250209; h=from:subject:message-id;
 bh=BTrhh55yMb7cCbPZyADxkhifxyh70Jy6fVzDF7gg+Go=;
 b=1gr9ETSiHP3k6QWOSYu135b7vjV0vFrWM2/Ustgl5P5f0ECA/OXVDu3t5wuXJO6lJzCe0zJcQ
 LsIs71XfDeWDAb3/qKUu5c5biObRUw18F/vqMqTSj7RNady0wTT17pv
X-Developer-Key: i=quic_luoj@quicinc.com; a=ed25519;
 pk=pzwy8bU5tJZ5UKGTv28n+QOuktaWuriznGmriA9Qkfc=
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: g1EP1rhd-Txj9pSSyCiq3labrXcTMZHR
X-Authority-Analysis: v=2.4 cv=RbSQC0tv c=1 sm=1 tr=0 ts=6800dc51 cx=c_pps a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=ZOzjf2MOAAAA:8 a=COk6AnOGAAAA:8 a=UT3M8-a78LFy_Dz9DhAA:9
 a=QEXdDO2ut3YA:10 a=1Mhi-5-LkjG4w5oc0yAU:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: g1EP1rhd-Txj9pSSyCiq3labrXcTMZHR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-17_03,2025-04-15_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=719
 suspectscore=0 adultscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 phishscore=0 priorityscore=1501 spamscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2504170080

Replaced below code with the wrapper FIELD_MODIFY(MASK, &reg, val)
- reg &= ~MASK;
- reg |= FIELD_PREP(MASK, val);
The semantic patch that makes this change is available
in scripts/coccinelle/misc/field_modify.cocci.

More information about semantic patching is available at
https://coccinelle.gitlabpages.inria.fr/website

Signed-off-by: Luo Jie <quic_luoj@quicinc.com>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index ae4c0593d114..946db5b3500f 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -123,10 +123,8 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
 			val &= ~GICD_CTLR_nASSGIreq;
 
 		/* Dist stays enabled? nASSGIreq is RO */
-		if (was_enabled && dist->enabled) {
-			val &= ~GICD_CTLR_nASSGIreq;
-			val |= FIELD_PREP(GICD_CTLR_nASSGIreq, is_hwsgi);
-		}
+		if (was_enabled && dist->enabled)
+			FIELD_MODIFY(GICD_CTLR_nASSGIreq, &val, is_hwsgi);
 
 		/* Switching HW SGIs? */
 		dist->nassgireq = val & GICD_CTLR_nASSGIreq;

-- 
2.34.1

