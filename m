Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDC423D295
	for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 13:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749736026; cv=none; b=AVeU0DtR0l0Mdf3ayJiWQg3d4w6ydfPVpqXDYyMI2FXWBBRh2DhJ/HryGqK4Rdn7gZuLmKIJq+XH/fdyT2nKAi8kJNhE3nnTN17DpCWSLpDfGivhY7TSIWuFzgxNfIEPzqXbF1eDF+o9NaE39UuFyMGNJu1bsDx8JttR2ct7dhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749736026; c=relaxed/simple;
	bh=0hd3Xbu/1BPf0k75pV/Vg9Nmx0tY6XisEeYKWmsaInw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=rmhsdBDyp3fBS1CXeTBwe042O7/Fp84vprnksfKygCh5HunSwJfjgQf1PlYC7ZepfYKNI1unbn6BXsyo+JoukpDhknjlUxN7sH6GrnY4T6ibiNODrQoIcsU6qrXMC3tfwkJ7iDQ9/yVFNHIthlqNSa/YppaaSpF0Pwq5H60ixN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=Qpayt6fD; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Qpayt6fD"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55C7qdJV026026;
	Thu, 12 Jun 2025 13:46:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	4UZaUurOrt1AA6JlidBnCXvptFMXwOUkDYNh/JmFBZE=; b=Qpayt6fDpRwqs5IN
	QfrYHcEju6B6ZpFnGfEsdHYk+XBSoB5zqvMPDR4vuk0zL0JPGQDnnrhgzD9X1V/Y
	9/H9SxGRc1n7ZoqBbnTMtP0F/ZPYgTxvooOLZC5gYSqj+4LjS4+R3evBS95W2s5z
	DdiJdN4L794EKFG8kSMcn00O8/kPFu99CihdpWpQMjdd6nVrya3DGmAIJuC62P/l
	Hvj27wsIDiJGzyQiOJBNuYnJi8bcJrtLR7LUw75uaL5fL2X0IM22389QTeEQC6tO
	pefzhazr/K/uK+nbETJBM/Qv1SdY3/ukciN53pY1GQ5DsrZX5qv3yfVPDXUS0h0E
	niSDmg==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 475v2ybhed-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Jun 2025 13:46:28 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 55CDkRnp007216
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Jun 2025 13:46:27 GMT
Received: from nsssdc-sh01-lnx.ap.qualcomm.com (10.80.80.8) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Thu, 12 Jun 2025 06:46:22 -0700
From: Luo Jie <quic_luoj@quicinc.com>
Date: Thu, 12 Jun 2025 21:46:09 +0800
Subject: [PATCH v4 2/5] arm64: tlb: Convert the opencoded field modify
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250612-field_modify-v4-2-ae4f74da45a6@quicinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1749735973; l=1049;
 i=quic_luoj@quicinc.com; s=20250209; h=from:subject:message-id;
 bh=0hd3Xbu/1BPf0k75pV/Vg9Nmx0tY6XisEeYKWmsaInw=;
 b=MN4Ir/SPSOB8/z6pPsHFnzrQnIsWWBsWdoSc5igPk/5BO651bKFmoL5zTSlDlLiUdAHPXXMZ4
 vBPoLggVWK2BomicbhBfkt28p+7RgruSjgaOkwBcL+/lr/vvTfsC/ws
X-Developer-Key: i=quic_luoj@quicinc.com; a=ed25519;
 pk=pzwy8bU5tJZ5UKGTv28n+QOuktaWuriznGmriA9Qkfc=
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEyMDEwNSBTYWx0ZWRfX9OVNPTYq5/fQ
 WkpnNqIAs8aif9RKa9JaAhPX7mhCVvZyQfYblBUBsXEvEiBmm0Y4pVP4QVhFbA5f4dnHWGAlCsG
 nOI13mR4wpofG1paHE2y3nxUMaxRzwkLWaa+Tqdevj15kyNM6+hJ5TOtAAEENnECtfQo0NJ6Uh3
 nTNnZeqwoxGzxTj/ypH3HQIiZzL+e92xKt8/RdjYoT90CFjzc28+jupqJD4DJyTMaki5De4cUd9
 yyNJdF6y1Gb6m4u1ydXUECHgKtAb7ZX0UIwxoUSaWfNQmbiSM4Bup5FiU4TnPlnikG2kZTzr7BS
 gNSRa2CfRaCHeJE+7Nba2eckEYS1mJ5ZtHZfNa5p2uwor/p9uxEuufCjjRLGPjpCfNVza6ix3gp
 0OZ06PXEKdGLydTLwngKtFf5ttjmyvqCackEh2I/mR5fQ+RwLrK4WzFp7UxB0YzxntXY+jda
X-Proofpoint-GUID: 95-X0mNwDG0cKiO8OxADInFGJISH4C46
X-Proofpoint-ORIG-GUID: 95-X0mNwDG0cKiO8OxADInFGJISH4C46
X-Authority-Analysis: v=2.4 cv=f+BIBPyM c=1 sm=1 tr=0 ts=684ada34 cx=c_pps
 a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=YgwN3AOMAAAA:8
 a=COk6AnOGAAAA:8 a=C2vL1j-_i977Atbg1qQA:9 a=QEXdDO2ut3YA:10
 a=ztR1XV6QG-NWxUt1dNgd:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_09,2025-06-12_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 mlxlogscore=579 bulkscore=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506120105

Replace below code with the wrapper FIELD_MODIFY(MASK, &reg, val)
- reg &= ~MASK;
- reg |= FIELD_PREP(MASK, val);
The semantic patch that makes this change is available
in scripts/coccinelle/misc/field_modify.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Luo Jie <quic_luoj@quicinc.com>
---
 arch/arm64/include/asm/tlbflush.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index aa9efee17277..cdcee05bdf6d 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -112,8 +112,7 @@ static inline unsigned long get_trans_granule(void)
 	    level >= 0 && level <= 3) {					\
 		u64 ttl = level & 3;					\
 		ttl |= get_trans_granule() << 2;			\
-		arg &= ~TLBI_TTL_MASK;					\
-		arg |= FIELD_PREP(TLBI_TTL_MASK, ttl);			\
+		FIELD_MODIFY(TLBI_TTL_MASK, &arg, ttl);			\
 	}								\
 									\
 	__tlbi(op, arg);						\

-- 
2.34.1

