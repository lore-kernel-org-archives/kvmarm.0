Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386F61DE3C8
	for <kvmarm@lists.linux.dev>; Thu, 17 Apr 2025 10:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744886869; cv=none; b=g+Hgv6RWYwq5T9fTcw/yC/ddksJQ3v8jwsJ6T3I9Kg+26CKy7YcYWJHtwXV1zugOf+keYGA8cEJMR3cQBJ+YWsHuOmC8LFnmdhowYfz+OcY4ODJe/s0g1tgNKqXf9SCyLjiJRZYgDeh+ixGcTx3T3I3CJeUwzm1Ol5wv0Xf6Zyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744886869; c=relaxed/simple;
	bh=sNPOlKWxoa2d3Xd6pXHYvrfVZgt6hORR+j95PnalnKo=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type:To:CC; b=Mo7iNUY00YO7K9fcRZZ1MIrWiBw8bF76bKbVl32iAhhNHqGKCdaO7LtGG61J8AYVmdpx7Q52Ojy/ShsbyxA44mO47uX5nldi745gzY/OFG1ln55nwFO+FlF6YEpTdAiNu2aXEO8szQG/2SePaI2GhyCa/Vujw17ENwgx7HiHyrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=JRdC/+It; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="JRdC/+It"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53H5l7QW003036;
	Thu, 17 Apr 2025 10:47:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=LRMHmsRiXieBj8psfApOLY
	0gCKvwS9nBg3+ZVQMAHlQ=; b=JRdC/+Ito+q1oHGhzzSVYYd8uvr0eiRG7HqYhu
	RkXq1ET6mbVzecWa30fNAS03efvXsIsjc9VX4odMxk1PJgIrKJMPv0JejYk3Z+Nl
	vTmnqgzfZ3je6kS1l0pINMfvfhOiwAeVJoqNeJg3iBKd0J2oQDRhNGE9u8LcdOBf
	BmSSIBdIzq0+4vcHsnsIe3rp3M4JPhGhpVsqFKNJ7kz3eGX7vVZIEMu0+E0xJ7J+
	Q3bkfCY1M0vD9IAM3V0DyHlOlE6YpkLoDItLgeKfwgn2gU9lOvr2LuqQCwCAS00C
	Glz5JtL2DBxFLKR3MjBlSb+HbxpZB2gA8U9j96r4kYGaMKAg==
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45ygxk6fm9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Apr 2025 10:47:22 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 53HAlMZp013519
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Apr 2025 10:47:22 GMT
Received: from nsssdc-sh01-lnx.ap.qualcomm.com (10.80.80.8) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Thu, 17 Apr 2025 03:47:17 -0700
From: Luo Jie <quic_luoj@quicinc.com>
Subject: [PATCH v3 0/6] Add FIELD_MODIFY() helper
Date: Thu, 17 Apr 2025 18:47:07 +0800
Message-ID: <20250417-field_modify-v3-0-6f7992aafcb7@quicinc.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACvcAGgC/x2MwQ6DIBAFf8XsuTSCYKCn/kdjGoGlblLFQmtqj
 P9e6nHey8wGGRNhhku1QcKFMsWpQHOqwA399EBGvjCIWqhacs4C4dPfx+gprEw3VmlvjSkvFGV
 OGOh75G5d4YHyO6b1qC/8v4JXAdHolnHlWiZlj8zW2jIt0HApFRohrq8POZrc2cURun3ff+MRm
 DKnAAAA
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744886837; l=2029;
 i=quic_luoj@quicinc.com; s=20250209; h=from:subject:message-id;
 bh=sNPOlKWxoa2d3Xd6pXHYvrfVZgt6hORR+j95PnalnKo=;
 b=BHLO3JJmTWuhCBY6yr0kCXOSkZrQy9MK+KEJ1RAfExjyoxi7m7VCsE4uEpkPi53uqWpWVhD3v
 5WdVAxpbsIxCWjcCqsroD9l/TllAID7lBKVr2cQoznmU2MXZ/n8MGbP
X-Developer-Key: i=quic_luoj@quicinc.com; a=ed25519;
 pk=pzwy8bU5tJZ5UKGTv28n+QOuktaWuriznGmriA9Qkfc=
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Authority-Analysis: v=2.4 cv=WecMa1hX c=1 sm=1 tr=0 ts=6800dc3a cx=c_pps a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=VwQbUJbxAAAA:8 a=COk6AnOGAAAA:8 a=cHbbWd92-npjkAukGjkA:9
 a=QEXdDO2ut3YA:10 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: -f_gB-2QlCjIYT6UaquToRoAO_Mpl07q
X-Proofpoint-ORIG-GUID: -f_gB-2QlCjIYT6UaquToRoAO_Mpl07q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-17_03,2025-04-15_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 adultscore=0 clxscore=1011 lowpriorityscore=0 phishscore=0 mlxscore=0
 impostorscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 priorityscore=1501 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2504170080

Add the helper FIELD_MODIFY() to the FIELD_XXX family of bitfield
macros. It is functionally similar as xxx_replace_bits(), but adds
the compile time checking to catch incorrect parameter type errors.

This series also converts the four instances of opencoded FIELD_MODIFY()
that are found in the core kernel files, to instead use the new
FIELD_MODIFY() macro. This is achieved with Coccinelle, by adding
the script field_modify.cocci.

The changes are validated on IPQ9574 SoC which uses ARM64 architecture.

Signed-off-by: Luo Jie <quic_luoj@quicinc.com>
---
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
Luo Jie (6):
      bitfield: Add FIELD_MODIFY() helper
      coccinelle: misc: Add field_modify script
      arm64: tlb: Convert the opencoded field modify
      arm64: nvhe: Convert the opencoded field modify
      arm64: kvm: Convert the opencoded field modify
      arm64: mm: Convert the opencoded field modify

 arch/arm64/include/asm/tlbflush.h          |  3 +--
 arch/arm64/kvm/hyp/include/nvhe/memory.h   |  3 +--
 arch/arm64/kvm/vgic/vgic-mmio-v3.c         |  6 ++----
 arch/arm64/mm/context.c                    |  3 +--
 include/linux/bitfield.h                   | 21 +++++++++++++++++++--
 scripts/coccinelle/misc/field_modify.cocci | 24 ++++++++++++++++++++++++
 6 files changed, 48 insertions(+), 12 deletions(-)
---
base-commit: 0af2f6be1b4281385b618cb86ad946eded089ac8
change-id: 20250411-field_modify-83b58db99025

Best regards,
-- 
Luo Jie <quic_luoj@quicinc.com>

