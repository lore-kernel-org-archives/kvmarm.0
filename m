Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096902DFA42
	for <kvmarm@lists.linux.dev>; Thu, 17 Apr 2025 10:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744886873; cv=none; b=Ker8flG5eigB+t6y9nTFT+aB9M31Eg3NLsFErwqLOwhxMvqlBVKx1xFqWwVg0TLZmiA3mKi/ClLAXn6TI8rVuITUDxzGW4eyEAaynVw4AE7AEhAHYYZWgHp+LQ9SmeuCnXV5rQSUB3WIAkts07W1wPpcMwoShomVPvh6ohOnsK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744886873; c=relaxed/simple;
	bh=XqzeltOC1Zkgsh2BrcPOXdm5N2R/wIhJqoHDe6dtw+Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=lzisD7MQY/Nps7yOZhgHZA2vUqgxRLCK/Mot1nzTcmz0lJxC6ZtUyJzHsaDIwqE4jyNh8junBOVs/apN/AfcAIs3ERHPXVU++6C5ZfWgoic2SljhSHCCF1CGdj7NB33xdRMVsG8FpfMKIq77qaTgbbtkU20tmNK/20n9/KYlNsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=Efl2sYz2; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Efl2sYz2"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53H5l3db022746;
	Thu, 17 Apr 2025 10:47:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	yiVm/qo8c+x7rGClKcN3itMCXTg6zKC2txm6G5ApZjA=; b=Efl2sYz2bdcXONUA
	BdxahmYJbO+DPxQkmjEDvG5L0Wud+P5kxdFhRFLzu9HXk0PjKEbS7Te2ZD4cvAxs
	Q7RBhyhq27cH/GTtw6kga+3mpS6FHKEEtf7v34K0ujq5CuuzftNcSGtoXlzfaC7Z
	FutZXe0RQ/M+21i0gVXlaXUTXnkMQ5ZBWJNort4U2VIqkQO1GEBaYol2l6/6hHdB
	QC7hrL9dUTTXsKTTzGdPw6NDiqy2vx/vRLlew04z0N5iri0SOzCECW9KhQ+zBnhW
	nr8trckcGgN48MNS+JoE5P8JS6EBNL80uavQPCqo7FZB4Ehepe/ySYH6YX+82gZv
	dO+X3A==
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45ygj9ek03-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Apr 2025 10:47:27 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 53HAlQ9I019727
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Apr 2025 10:47:26 GMT
Received: from nsssdc-sh01-lnx.ap.qualcomm.com (10.80.80.8) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Thu, 17 Apr 2025 03:47:22 -0700
From: Luo Jie <quic_luoj@quicinc.com>
Date: Thu, 17 Apr 2025 18:47:08 +0800
Subject: [PATCH v3 1/6] bitfield: Add FIELD_MODIFY() helper
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250417-field_modify-v3-1-6f7992aafcb7@quicinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744886837; l=2268;
 i=quic_luoj@quicinc.com; s=20250209; h=from:subject:message-id;
 bh=XqzeltOC1Zkgsh2BrcPOXdm5N2R/wIhJqoHDe6dtw+Y=;
 b=9IzZjSlW5yjd7751JIfknwqV1vLuyiGlF+29QONHWIKVYOwVHAUF2BXkXXd1I3uJJL+SY5ijZ
 I4dTJYHzh5kCs81yntSxU2bVyECkiVc3YvIx6GZCLd+5CPFa0yqx1Dx
X-Developer-Key: i=quic_luoj@quicinc.com; a=ed25519;
 pk=pzwy8bU5tJZ5UKGTv28n+QOuktaWuriznGmriA9Qkfc=
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: 7jZWPg1HNGZFTxuXBfHc0Cpmo5p70edG
X-Authority-Analysis: v=2.4 cv=PruTbxM3 c=1 sm=1 tr=0 ts=6800dc3f cx=c_pps a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=COk6AnOGAAAA:8 a=bpWgvMM22m3vV3Jt9xMA:9 a=QEXdDO2ut3YA:10
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: 7jZWPg1HNGZFTxuXBfHc0Cpmo5p70edG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-17_03,2025-04-15_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 adultscore=0 lowpriorityscore=0
 impostorscore=0 clxscore=1015 spamscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2504170080

Add a helper for replacing the contents of bitfield in memory
with the specified value.

Even though a helper xxx_replace_bits() is available, it is not
well documented, and only reports errors at the run time, which
will not be helpful to catch possible overflow errors due to
incorrect parameter types used.

Add the helper FIELD_MODIFY() to the FIELD_XXX family of bitfield
macros. It is functionally similar as xxx_replace_bits(), and in
addition adds the compile time type checking.

FIELD_MODIFY(REG_FIELD_C, &reg, c) is the wrapper of the code below.
reg &= ~REG_FIELD_C;
reg |= FIELD_PREP(REG_FIELD_C, c);

Signed-off-by: Luo Jie <quic_luoj@quicinc.com>
---
 include/linux/bitfield.h | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
index 63928f173223..2eaefa76f759 100644
--- a/include/linux/bitfield.h
+++ b/include/linux/bitfield.h
@@ -8,6 +8,7 @@
 #define _LINUX_BITFIELD_H
 
 #include <linux/build_bug.h>
+#include <linux/typecheck.h>
 #include <asm/byteorder.h>
 
 /*
@@ -38,8 +39,7 @@
  *	  FIELD_PREP(REG_FIELD_D, 0x40);
  *
  * Modify:
- *  reg &= ~REG_FIELD_C;
- *  reg |= FIELD_PREP(REG_FIELD_C, c);
+ *  FIELD_MODIFY(REG_FIELD_C, &reg, c);
  */
 
 #define __bf_shf(x) (__builtin_ffsll(x) - 1)
@@ -156,6 +156,23 @@
 		(typeof(_mask))(((_reg) & (_mask)) >> __bf_shf(_mask));	\
 	})
 
+/**
+ * FIELD_MODIFY() - modify a bitfield element
+ * @_mask: shifted mask defining the field's length and position
+ * @_reg_p: pointer to the memory that should be updated
+ * @_val: value to store in the bitfield
+ *
+ * FIELD_MODIFY() modifies the set of bits in @_reg_p specified by @_mask,
+ * by replacing them with the bitfield value passed in as @_val.
+ */
+#define FIELD_MODIFY(_mask, _reg_p, _val)				\
+	({								\
+		typecheck_pointer(_reg_p);				\
+		__BF_FIELD_CHECK(_mask, *(_reg_p), _val, "FIELD_MODIFY: ");		\
+		*(_reg_p) &= ~(_mask);							\
+		*(_reg_p) |= (((typeof(_mask))(_val) << __bf_shf(_mask)) & (_mask));	\
+	})
+
 extern void __compiletime_error("value doesn't fit into mask")
 __field_overflow(void);
 extern void __compiletime_error("bad bitfield mask")

-- 
2.34.1

