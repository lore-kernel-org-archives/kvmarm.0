Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58FE245023
	for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 13:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749736025; cv=none; b=rm3/8H1HvspJvkoXngyxOIL/YUVs3CxX58Vhs9tZO+JVmfPdhw9YNRhezAMBaIQgPr82HhRtGPPqR9FB8v2qgKliDt62Bk/4VmGxGTDzg+TIOGcbFKM7med+aPqZrOeawSYr5CWEURofxt1cP6LSSeJN4SQy8BwMStkfvCtpyDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749736025; c=relaxed/simple;
	bh=RQ6JRVRsPYGnPD/Etf5zFYsGdfK+yVXW3fMdn2fe+PA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=g/D4wpXL4+VRAWFRlmEN4zAkx84Dkm5w9+WC7P8airh2QEd4gaYaox2ZJz3nfuiLI1Ta7yB1DxgASKosHa9kwiayzmAPc1J8PgB8ogmyWT+LV712v5XMh1NCmeZUitxy4rOJDcKOWO3LakxOUZ5GRDm6S/B2LZZRsuczaTTxBWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=dZoZFanL; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="dZoZFanL"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55C7klnb019621;
	Thu, 12 Jun 2025 13:46:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	AtRFh0Ey70hl6l/1Ltvy8lBRLOlLz+gnmfGfYWjxjc8=; b=dZoZFanLuvbFrqGn
	nlshuUO+Fjc9ySmmkn4wfLXL//mXLFOQGubK39WKbEBheMRSur7xC1Wrnh18YAbX
	jUT4nA74pv5r641DAUfnKLy/w7aiVqKDvbxGbAYmOX69MVi/p7y+eZ/ZkIBW7A2i
	TgRlylq+5SENpBxkMxXtggorGcsRk2QS6bv3CNh9W3lA8vL0fK2xKL1uSlRG3A+1
	OSeFGA3nj+PweML5fB1gMny7BkUtaPDsRH1Cx6Y1voq6EXK3U2a253yEBd5ulhR2
	dR7c5bLq8YsJ2fDJVy5UwsCoXB2gdfSDENHPdijXI/+RoYQbY1qhtMf1tnQ5yqx0
	9cI+0w==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 474eqcrq9p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Jun 2025 13:46:32 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NALASPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 55CDkVpr030855
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Jun 2025 13:46:31 GMT
Received: from nsssdc-sh01-lnx.ap.qualcomm.com (10.80.80.8) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Thu, 12 Jun 2025 06:46:27 -0700
From: Luo Jie <quic_luoj@quicinc.com>
Date: Thu, 12 Jun 2025 21:46:10 +0800
Subject: [PATCH v4 3/5] arm64: nvhe: Convert the opencoded field modify
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250612-field_modify-v4-3-ae4f74da45a6@quicinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1749735973; l=1055;
 i=quic_luoj@quicinc.com; s=20250209; h=from:subject:message-id;
 bh=RQ6JRVRsPYGnPD/Etf5zFYsGdfK+yVXW3fMdn2fe+PA=;
 b=py8dXdWMApFsDGHzCOE0AYnCD+LUzkA/muQQlvUJ+EaQlNIZoez3TpPULkEfohxYbuOBf3qty
 kFUx4wH1c0kBVGx9VaRbm5yEKsI3AMjifEQNFYsElAby9wDyim1cdlI
X-Developer-Key: i=quic_luoj@quicinc.com; a=ed25519;
 pk=pzwy8bU5tJZ5UKGTv28n+QOuktaWuriznGmriA9Qkfc=
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEyMDEwNiBTYWx0ZWRfX3X8eZjf1IM2j
 +i7Jxhwn+k2R6uhBlqGl8860OQv4nlDvTaw0oOnlXb80b7zuU+hK5LwZwR7ZBywcr8ug4WcvfVf
 nUyTXYxvj7xt8Adffx6reBcpOFmEgJ+o40utzrPH+ktVDwDLXZ5Djo3gW8egwP+GQD70RyruSmS
 AsJMirRy5tt7xUDNfplcPwM8vQMdk1dmMpPYJl6PDGbl8Uojy1ph2SR53+a2u+plsQOrgvB3fO2
 hTVBu8abzTdGcbHHyw+o0S87Kg0NUpdQ995jrJ8aCCCNzd3aI6lVm4Oyti/ugUQLe2KZPHPchkt
 0J6gkWHJOIRC6JUBpdd7BPjn69bgKxlGF6SgwyHzDMdiFjHGF5DVUlEeNfjUipt7DLI4n7aDLXW
 DSatKW8VGAKBortwJ25DJjZMKg3+PqRN38O/+kT8TVzUP39iugvYJ4/sAUMaGwvFzuloftj2
X-Authority-Analysis: v=2.4 cv=Q7TS452a c=1 sm=1 tr=0 ts=684ada38 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=YgwN3AOMAAAA:8
 a=COk6AnOGAAAA:8 a=SCSGtF1BeqTgPpDbPWsA:9 a=QEXdDO2ut3YA:10
 a=ztR1XV6QG-NWxUt1dNgd:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: hWeRRxSRKAV1XyHXXPfUuaQiuUBA0QZT
X-Proofpoint-ORIG-GUID: hWeRRxSRKAV1XyHXXPfUuaQiuUBA0QZT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_09,2025-06-12_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 mlxscore=0 spamscore=0 mlxlogscore=434
 bulkscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2506120106

Replace below code with the wrapper FIELD_MODIFY(MASK, &reg, val)
- reg &= ~MASK;
- reg |= FIELD_PREP(MASK, val);
The semantic patch that makes this change is available
in scripts/coccinelle/misc/field_modify.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Luo Jie <quic_luoj@quicinc.com>
---
 arch/arm64/kvm/hyp/include/nvhe/memory.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index dee1a406b0c2..c1dbea320131 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -37,8 +37,7 @@ enum pkvm_page_state {
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

