Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F9F220F2A
	for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 13:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749736318; cv=none; b=PYCbcQ4qSSaX4NJOjks2hnwtFqQzljY7zKWR/EDsIaB1dYROZKIA0qblR+uI8+fgB4GLiSLUzsjeI6HdyFupHdxewvVhe5+uokja/uYfUGxFKtE5ftnMnU1w8EgQjVbxGdVXFjHKhH468X5igokVgNjiwIc95rn9185Sw4Bg8Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749736318; c=relaxed/simple;
	bh=iUjNUxN1xIpBV8h+1ymERj2J0ETvO565u+bdg94CNuw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=qNoirAHjgHAw8hAfAh95sURP59fGkErUMe73YdGP0i9plvW9ssIBR6bX4fCCSupL6lhp4g/dT4yv/7YitQp9yB44hRuLqt0UqoLHaPAo7aYwOxpRVFjmgqNsEzGnancvU7rUpXAccn2Sto50paPitSoPQWF5dMCVqr+nR8Gy4jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=NY7Ih6hX; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="NY7Ih6hX"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55C7p1oH029232;
	Thu, 12 Jun 2025 13:46:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	tmk++c2mkcJELsKXVxVYZLuqg2o3nAxMrCB7YLxsRv4=; b=NY7Ih6hXYb4q4aUl
	T7DCkzP1NaC6tHihZKVsvVoj2zj18kcTjB+R8ARPs3c88rF6R2seGrubyAvwHXIG
	pZ/bftZtSSnKBk4srW3OEkuudg3gI5kNvkKWxn8r34izLD4VyyYJzQET/q162iAL
	vxQ3rokzKNYNRu6BpQx6d/P2OWskB/7XfnnnFPiGRErCCqy9vK5UboLp4GT2XCwz
	8g84HA+9fHR9L+35BLs1YF43WtO9b3OyYgrmdhrJTwgb1IAFd2IU8+4nkYAD1nhE
	gjmKBANWC0RQxDI6ROEscwOyMev7f5ecCLDzP9FxNrxPgdcRlBB+gnmzAJ4OYZiB
	0RprXg==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 474dn6gq2y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Jun 2025 13:46:36 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 55CDkaoC007559
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Jun 2025 13:46:36 GMT
Received: from nsssdc-sh01-lnx.ap.qualcomm.com (10.80.80.8) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Thu, 12 Jun 2025 06:46:31 -0700
From: Luo Jie <quic_luoj@quicinc.com>
Date: Thu, 12 Jun 2025 21:46:11 +0800
Subject: [PATCH v4 4/5] arm64: kvm: Convert the opencoded field modify
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250612-field_modify-v4-4-ae4f74da45a6@quicinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1749735973; l=1164;
 i=quic_luoj@quicinc.com; s=20250209; h=from:subject:message-id;
 bh=iUjNUxN1xIpBV8h+1ymERj2J0ETvO565u+bdg94CNuw=;
 b=Rl/McSDJhXaLrhpJ0frxvIhIfvp4v21iFTJNHsQn3oCpHpvZ7M8UNZbO5IH81vMeAfKUvO89l
 gY9neAwYxBmBqcFuZzRyP/hcmI7vRbga2VnXux64d/LdbO8KZ2cnmIi
X-Developer-Key: i=quic_luoj@quicinc.com; a=ed25519;
 pk=pzwy8bU5tJZ5UKGTv28n+QOuktaWuriznGmriA9Qkfc=
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEyMDEwNiBTYWx0ZWRfXz+dJ0Eg/kmV6
 IkjDE3jTwrQvyd5ADMggW5TOhrbScj2wcenOOXIP4M9vQEjgp30TJCO+o0rhASugfHVPkHRgDOq
 IdPPg6KrFbiBVtbWAY1K77H4iWe59CPkYuB+P8m84X6VxfbWibrDMVDwcy4Jv6LYeCGO4sbVXIp
 /jNz1YCWsa+wTvscwVHoT15Z0L7TCc+8SgTcXmzkGCQ3Au/8PJinX+Bs+XakkfssEbSINBYBL6Q
 4tazH1o4O4WU561Dh4tAZJP6xMiMK0RFMuFueAQxDl3agaRgMTfOf57SgONWQzRtBEi5BoN4H0f
 lxyZdtJ1hE0hmbE9b+03W3SKMnnzbJS8x1PJgv3fn1IMvQBviSjGV2IHvQbueV8v7TrS7bzbqPW
 p3n2ERo0pfJo2oIU+dTN0qJOWSGEfvNQl+KWZj1C1NKuUTtDNlBsmEJhGjz9pZIb0+DbrRRg
X-Proofpoint-GUID: 9eXI8tMV2ghSaD5ylQpNtXpLf2lL_h-b
X-Authority-Analysis: v=2.4 cv=FaQ3xI+6 c=1 sm=1 tr=0 ts=684ada3c cx=c_pps
 a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=YgwN3AOMAAAA:8
 a=COk6AnOGAAAA:8 a=8vQftXNygbJtpsvDVS4A:9 a=QEXdDO2ut3YA:10
 a=ztR1XV6QG-NWxUt1dNgd:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: 9eXI8tMV2ghSaD5ylQpNtXpLf2lL_h-b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_09,2025-06-12_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 adultscore=0
 mlxlogscore=754 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
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

