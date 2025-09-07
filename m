Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADE01CDFAC;
	Sun,  7 Sep 2025 20:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276098; cv=none; b=onsjP+/Heof/i3BOc8nOcvi9nfXvjxhKvPBRfmBWq8Ddd/30bu+8PuSBjCVCnZ8ebwdmdqL9GeyuXylps0mp70U9+5HS+U47gh74jlsOd3UJCXke4XMgFWxb25rFhAmswC6dJBQnB9UtYpn+hG3pf+1OlaLVEumWwc46TN+rcfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276098; c=relaxed/simple;
	bh=DHVsgq3EZ4dBzOun/+E5oVCv9xOjuvlbvo+5NkfxOgI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pfAmc3p7BuO2G2WbuDbdTYROnS6f7TtytxdzoGg5SxgDcmbq2i3DV8BUEYpEHheA8PFWOf6JwtSXf/1NdWLhSgQYoqMZDWp/hdFuwz4Qna5/WFNas9kVftESUL5lLXQWkXM/JeXcP1ocaUWT/idpoQJU0gzfHqg+kHxcAZBt9gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CRZOsZs4; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CRZOsZs4"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 587K9g7B011397;
	Sun, 7 Sep 2025 20:14:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=yM0Vnuw61hBJNTZ8/foS1QpgJsoSP
	iaVg+C7UGUfKdo=; b=CRZOsZs4Umaab65N2HvsFSoHdkfOaQ6YwDhOXPIdXOe5j
	qptWipHdo//n6l3CVevCRK59/ulPtqqhOfDXBR9aqbDfMPN/I6ymJeUax5rm2hcn
	Whxy1tjZ8gwWWfRsCge67y0XysHaa33jcwHFgKd3TiLMq7OYssiiQugTpIteiABN
	/71sgU6klI3Fa3EqL3lTzz+58MsF7vbyALFPJYfIFXkUFgnCU8qV7Qvc5WptiElG
	P7IJrTnFrAwwSf3Wc3kafONU4kPBCV13+lwbkVHAFTfEzDfiieIpJhOoCWdP9ZPV
	Tk2jhxGwjgruskcI03GbsQOKQXar4u+1kb5jq/TxA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 491gua801u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 07 Sep 2025 20:14:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 587EFFwd030698;
	Sun, 7 Sep 2025 20:14:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bd7cyuy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 07 Sep 2025 20:14:25 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 587KEOmf039410;
	Sun, 7 Sep 2025 20:14:24 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 490bd7cyus-1;
	Sun, 07 Sep 2025 20:14:24 +0000
From: Alok Tiwari <alok.a.tiwari@oracle.com>
To: julien.thierry@arm.com, marc.zyngier@arm.com, jintack@cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org, oliver.upton@linux.dev,
        joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: alok.a.tiwari@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: vgic: fix incorrect spinlock API usage
Date: Sun,  7 Sep 2025 13:14:13 -0700
Message-ID: <20250907201421.3612784-1-alok.a.tiwari@oracle.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-07_08,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509070211
X-Authority-Analysis: v=2.4 cv=UatRSLSN c=1 sm=1 tr=0 ts=68bde7a2 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=WX6EjEeCYAaawmOpSx8A:9
X-Proofpoint-GUID: vn0JFs1aucJtM4zfA_naB14cPmViid_P
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA3MDIxMCBTYWx0ZWRfXyi7y69tKHa/g
 OdCGom5mn8xjL4lwkli87rAIotIGbro6CPGkq69LNDmEjn5Z6d+qpjiIdE8wb83bNPFX5aX4f2K
 22UNd2JS2hu51WMCLPaROobhkZb/LE6E/48T6hK6UFjKmE8YWG/4fuv3q8cFsY4dYplrqwaR3Ok
 3fLbMUMu+JE10plW+ShEL/83BpWO2oATFbNPYAiRCtOvr3+lXmF5qTLSjRduPwPuVVM2sfyQ7fS
 CwccXkZXhBkA11jETac59OMenO/1CnWV4prAo9XrgLx7938XzjNNgphDcgif5SeYO+0uaoU60UJ
 FDVypMuGuBQkQVOHaPo/CjwEbatVxJwWT6HG4wh1hCmUeOFF9K1NpmE4uDInpj5ZQ11Qa8joMDZ
 bXL8fhbz
X-Proofpoint-ORIG-GUID: vn0JFs1aucJtM4zfA_naB14cPmViid_P

The function vgic_flush_lr_state() was calling _raw_spin_unlock()
instead of the proper raw_spin_unlock().

_raw_spin_unlock() is an internal low-level API and should not
be used directly; using raw_spin_unlock() ensures proper locking
semantics in the vgic code.

This change replaces low-level API usage with the general kernel
spinlock API, avoiding misuse of internal functions and aligning
with kernel locking conventions.

Fixes: 8fa3adb8c6be ("KVM: arm/arm64: vgic: Make vgic_irq->irq_lock a raw_spinlock")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
---
 arch/arm64/kvm/vgic/vgic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index f5148b38120a..c74d6120a12c 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -818,7 +818,7 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 		 * the AP list has been sorted already.
 		 */
 		if (multi_sgi && irq->priority > prio) {
-			_raw_spin_unlock(&irq->irq_lock);
+			raw_spin_unlock(&irq->irq_lock);
 			break;
 		}
 
-- 
2.50.1

