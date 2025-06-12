Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5960246BD6
	for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 13:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749736024; cv=none; b=Si3czD5oVUHpCKx2gMybr+Thu8+IbR+HrYNPF9nGidd616/YQjbDd5bs0OyO4NfIpo0P4Ks42WfqDlKUItR/YdAoyPn2ti9YhngwcaUe0PjTxMBxI3/sqoHt5f0/HCVMIueoJ/nzwj/2sFKC+XuShyP7QwIK+chFBidxxl35PCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749736024; c=relaxed/simple;
	bh=W/ahaZ49s/QUKZlkADLnL22LdnI5S7Mvd9H7G4IoQdc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=OTmded4HoOLafZ5kHX4Zri5ruLAdnpkhjFbAsfZQUjUAdzhSdQculAD8OHFNuddnz81Nzy4IENNvOZ0F8kJCM0cgFgIDgejzwbwPnYmqX2oSrxQF2g7x8/5fyAGm1nY+bIPQudLVwZKs9AsP3ull4u5h54H2zfJ3UVcIoFFxL38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=DI+vGVfG; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="DI+vGVfG"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55C7t2tK029227;
	Thu, 12 Jun 2025 13:46:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	X8GgE2nPNPiJlYy8ohdXyvSbBqN//6odlSN5nqekQ1s=; b=DI+vGVfG2tsbpW7e
	c1Maclxn21evjKUoE3EtsxjIF7+zgCBH47M4CinLcXu8VQr22xo+yf2Wux3QoEV0
	PuOh4zglhd8v6+gZ6j+eJyw3g8EpKQMHW76MJsHSAL5QWT23Th7NLgjV8QzHiAe2
	yA0vhzTcdFFWV2IjlzEhrrZVpfBzUVGF2LcQBo8VrP2cRUuRv4pbdwC5AvSYpF3Z
	M43OXs801E/IQFFiI/THPmZH1LjyFjlhM4peUhT6DJMmq5Ad+Eq3gTr7Knbymh61
	2xXMZGkCHWECPt/imV0Cg56uCXci6Smtuzeo1matngyeEklowkVtzHuhmyf3cDHw
	o+ngbw==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 474dn6gq38-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Jun 2025 13:46:41 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 55CDkfF2008186
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Jun 2025 13:46:41 GMT
Received: from nsssdc-sh01-lnx.ap.qualcomm.com (10.80.80.8) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Thu, 12 Jun 2025 06:46:36 -0700
From: Luo Jie <quic_luoj@quicinc.com>
Date: Thu, 12 Jun 2025 21:46:12 +0800
Subject: [PATCH v4 5/5] arm64: mm: Convert the opencoded field modify
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250612-field_modify-v4-5-ae4f74da45a6@quicinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1749735973; l=1011;
 i=quic_luoj@quicinc.com; s=20250209; h=from:subject:message-id;
 bh=W/ahaZ49s/QUKZlkADLnL22LdnI5S7Mvd9H7G4IoQdc=;
 b=hel6wCcdA56WnGWVTAMEcD0oSXQ+ePCdhntzG9esVw3qUoy/BSILo7hV+c3qvZLRv3e5XgxZl
 XtsGVslBdZJDopMC5XZYgzgtQ76pihmggA6fVfcaWuuBKEtb5v/FH1y
X-Developer-Key: i=quic_luoj@quicinc.com; a=ed25519;
 pk=pzwy8bU5tJZ5UKGTv28n+QOuktaWuriznGmriA9Qkfc=
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEyMDEwNiBTYWx0ZWRfX8f2PlBQBhUyc
 jA6I1zp59iHWJ18qmXDABq2XSM+kvLWUmj1aDU76cEj4pD7xCFcRf1iF2DpkjUqXLKUEoEjUQCy
 7am7u0lIVsVQtqT5aqZbmdkyAkZlu1gPg90JKYqgOPsl0bBZSN9FZTElSOT5/vjCwX4fGXf/yDn
 /MKPQrhqU2QMJXsSFFX9kbzoQAMCWUDaxFK7O9c05mvMWoA6gknd+7rwR/DbpSo2a8MstYioH8N
 BPq1KzuUd4CdbjXEK8TmsamjxVbyf4ZKl3iaUyVucfmsycKyeT6+oVsq5QD/2nzSu0EgoLzdE4G
 wsoTuYUHlTriip12hTyXDz9bHu80JR5H83mziMPPFoTGyh0BlzpYqXh2wdLMj/PJbREk+RmDSLX
 aUy0NchoVJaX7E5KQVRPrYvpAqAId6/TQWcCGkUbJBeEbUdCP0iGMPHim+qdnDTqXr0ZASGg
X-Proofpoint-GUID: 8bi3BmivY8GHEm5ykXFVLbLnIhfr2nai
X-Authority-Analysis: v=2.4 cv=FaQ3xI+6 c=1 sm=1 tr=0 ts=684ada41 cx=c_pps
 a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=YgwN3AOMAAAA:8
 a=COk6AnOGAAAA:8 a=eT1jO_uuukyntfU6EpwA:9 a=QEXdDO2ut3YA:10
 a=ztR1XV6QG-NWxUt1dNgd:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: 8bi3BmivY8GHEm5ykXFVLbLnIhfr2nai
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_09,2025-06-12_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 adultscore=0
 mlxlogscore=621 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 classifier=spam authscore=0 authtc=n/a
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
 arch/arm64/mm/context.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index b2ac06246327..4fbac8e74149 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -361,8 +361,7 @@ void cpu_do_switch_mm(phys_addr_t pgd_phys, struct mm_struct *mm)
 		ttbr0 |= FIELD_PREP(TTBR_ASID_MASK, asid);
 
 	/* Set ASID in TTBR1 since TCR.A1 is set */
-	ttbr1 &= ~TTBR_ASID_MASK;
-	ttbr1 |= FIELD_PREP(TTBR_ASID_MASK, asid);
+	FIELD_MODIFY(TTBR_ASID_MASK, &ttbr1, asid);
 
 	cpu_set_reserved_ttbr0_nosync();
 	write_sysreg(ttbr1, ttbr1_el1);

-- 
2.34.1

