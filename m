Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3F5226D00
	for <kvmarm@lists.linux.dev>; Thu, 17 Apr 2025 10:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744886884; cv=none; b=b46KmHjLE5GP0AWlVBJ3tKBmXEMIaidyAzffeQTkDRhhXW4PUqmNMwA0OK+3jCz8hNKEyFe/9KX0cpWYS8fMJNveMfL3NJNnBcAPUBcI6yD6Aa8uh65fnGDLth+HrZzog0PqeMNFZvsUPOH9La99dO4te7P9oaLgmdc6CWj+ooA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744886884; c=relaxed/simple;
	bh=cvVlxw6voFepum5B3j7VuYklAnJvwlbit3ZxBrFCeuY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=s7Bullhb8XaAEqjyshVOyELFPx30yfNAdtMhEmIll/GYhR3V/jTGFJvfKWdSsy1QSZInECBjoSJaMPkPHqBW1vrHIsXrNJOmMN68TyQ6HMKbX5DH4Q4vrlG8O5JLNNbbWYmxmEjohYk+uONP2KhvDPszkWXmqLw1dG45yvWHO4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=cplR2MAF; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="cplR2MAF"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53H5l3CY022761;
	Thu, 17 Apr 2025 10:47:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fl2qado12sJSasEZ85EejccDkasGJOzdpdf5GWKzGqc=; b=cplR2MAFgNtv3jkf
	m+BRgiGkeT9kLkC1/OH+hhbQKyLBSzNrn1MhJdBy+nxwG2iwbYCCKRpAO4hnIChy
	JDqapvRlSx7n7zRMn7R3XpNfi9rqPyl99jxj7t3+fWo/+aDsYApOMVLQptPohpJU
	hqhf2V1SQKKemmR8heOEpRj4eCJwBbGif+/YYOduQZBqtnuURg2tqntSmmTsX694
	eUij9Fo2ZHzG46/MR0L1VJqV/JHxlwD/DNz9hLd+GEzvytwlbQhS5FjaRN1YdO4f
	B/YN5o9cGmb86vURCxL6GqTuaty60SnOwqxk+0H/fBDNV0q0otTroBX1oFxu0ZSZ
	4nTTbA==
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45ygj9ek0e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Apr 2025 10:47:41 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 53HAleh0018259
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Apr 2025 10:47:40 GMT
Received: from nsssdc-sh01-lnx.ap.qualcomm.com (10.80.80.8) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Thu, 17 Apr 2025 03:47:35 -0700
From: Luo Jie <quic_luoj@quicinc.com>
Date: Thu, 17 Apr 2025 18:47:11 +0800
Subject: [PATCH v3 4/6] arm64: nvhe: Convert the opencoded field modify
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250417-field_modify-v3-4-6f7992aafcb7@quicinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744886837; l=1077;
 i=quic_luoj@quicinc.com; s=20250209; h=from:subject:message-id;
 bh=cvVlxw6voFepum5B3j7VuYklAnJvwlbit3ZxBrFCeuY=;
 b=GTL0dCoHat+xXHUQb1fat8JsWpoJ4Y5akSpsWuWFztDiVKGbhBiItuLWg0KHJfcY3W7NleQZM
 qh+d+klpWIfDh0G12O8Y+QNqzV0cvncGSj5hNd48sXgS2CAjsQzaQyL
X-Developer-Key: i=quic_luoj@quicinc.com; a=ed25519;
 pk=pzwy8bU5tJZ5UKGTv28n+QOuktaWuriznGmriA9Qkfc=
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: 5C9jqgUTuZmSpnBBeYGCWvUM3h1fRkyj
X-Authority-Analysis: v=2.4 cv=PruTbxM3 c=1 sm=1 tr=0 ts=6800dc4d cx=c_pps a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=ZOzjf2MOAAAA:8 a=COk6AnOGAAAA:8 a=SCSGtF1BeqTgPpDbPWsA:9
 a=QEXdDO2ut3YA:10 a=1Mhi-5-LkjG4w5oc0yAU:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: 5C9jqgUTuZmSpnBBeYGCWvUM3h1fRkyj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-17_03,2025-04-15_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 adultscore=0 lowpriorityscore=0
 impostorscore=0 clxscore=1015 spamscore=0 mlxscore=0 mlxlogscore=421
 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
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
 arch/arm64/kvm/hyp/include/nvhe/memory.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index 34233d586060..b2af748964d0 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -30,8 +30,7 @@ enum pkvm_page_state {
 static inline enum kvm_pgtable_prot pkvm_mkstate(enum kvm_pgtable_prot prot,
 						 enum pkvm_page_state state)
 {
-	prot &= ~PKVM_PAGE_STATE_PROT_MASK;
-	prot |= FIELD_PREP(PKVM_PAGE_STATE_PROT_MASK, state);
+	FIELD_MODIFY(PKVM_PAGE_STATE_PROT_MASK, &prot, state);
 	return prot;
 }
 

-- 
2.34.1

