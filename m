Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21797145B16;
	Mon,  8 Sep 2025 18:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757354680; cv=none; b=HifaYPggA6sauSirnKqiB9XcBNokfgYZP3wDNhuDhTNTN618wxJO050g9MZhNWIstYmwVx3HscNuG5q/rBSpoRAk8EFzT/tUbAWgXPp8R9I/VpprW3fUV5gaSCRi31+S7Oua/rqm5xZA5PSlY0+3zsyt/pZd5aPf5nlXeboxOnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757354680; c=relaxed/simple;
	bh=CXyhYW8x/bV3wwNvRcSBJG3Rf+qaaGEaieFwPcKjB/8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LSRWZrrkrN+0bE2dl+vp5MifeQcP3RnB4d01vvvJQXgQRrmp6KPtBuUAEP4QK6L8wDz76iP7XvXe07js4gI6QgdkDxq2xkKOMxTTvec+6MYV3T4OO2kbCSeXbqx41jrUlbhIP9CAmwqkA1fvAvm4ED2FCa4cFrWZi6wa5E11uN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HmlB72x3; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HmlB72x3"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588Hg5FR018214;
	Mon, 8 Sep 2025 18:04:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=Gvfc1Iz0nE71iFyrDfLCzdho+9INv
	h3b39JFa+yZSCg=; b=HmlB72x3mAG2OTF+mpFYTPWxWJAedUblKs0adiSA/9+FV
	Eq032MZm7ZQHamSMLi2+11tSrTARtNIZ73cZBGGreh9CjWQajTVommebx+Ts4zyB
	4Z2x2KtFPAkYBp6jMGux8zfFFncWMBSAvWXS90r+vovBjYPDSHg9sl5B9YSlAkIK
	8NgY5Hmi1Eai9C/0tdHj0IXLkevpLlyoqjK8/+oR8W1w/nwqturpMeyD93ti5R3X
	jhx3iHpmZ55ZRX3LoKuYBAckanzmNQUS//DTRLIScxcEiD2uBRpmL9gsI6jb2UUj
	kKzM9mf5gFSrZ1u3xoAh5mfxT4vUgo++MN5Ps4J6Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921pe8bd4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 18:04:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 588GfmaV030651;
	Mon, 8 Sep 2025 18:04:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bd8hetg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 18:04:17 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 588I4GZh026431;
	Mon, 8 Sep 2025 18:04:16 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 490bd8hesq-1;
	Mon, 08 Sep 2025 18:04:16 +0000
From: Alok Tiwari <alok.a.tiwari@oracle.com>
To: julien.thierry@arm.com, marc.zyngier@arm.com, jintack@cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org, oliver.upton@linux.dev,
        joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: alok.a.tiwari@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: arm64: vgic: fix incorrect spinlock API usage
Date: Mon,  8 Sep 2025 11:04:11 -0700
Message-ID: <20250908180413.3655546-1-alok.a.tiwari@oracle.com>
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
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509080179
X-Proofpoint-GUID: FW9NxWmtgJYneDA1syrnrDHum9ilFNl9
X-Proofpoint-ORIG-GUID: FW9NxWmtgJYneDA1syrnrDHum9ilFNl9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MiBTYWx0ZWRfX1vkUAsbAZHAR
 8uD8FsEVyUc+aywSroPjXmMDYlWgwX+nmT1PWjNI9flpbQwmsYceTrUOKMbFjHBXPPe7eymXY/M
 0ucDTo42rK3jwhpXEXy7fPq/mg/13FWT0/GM1oZiFGGuIqGG0GvL7N84moIL7MwqgrCkYnUPy6Y
 /HY2TrMFnsFhSf6kZXD5RvkS0qEO/iB1HVo2w4O4XxqBMdqz/OTmn0TSjtYykT4ZoIRyfZY8NXc
 AQSlTIlTOaM+WPRLdph7xPQbEy772cXsWat9O+yHea1mkC4DVJDKxvBZz3Bw/Gq5YmO/6M7Cf+W
 rrY0s5eAtxbzjX9Msn4+JvW6NLRPSN5SH+CxVuIucGa9E7imICW3pwUvvoIDZH6kM1U0oCtti9m
 0OtVFDre
X-Authority-Analysis: v=2.4 cv=b9Oy4sGx c=1 sm=1 tr=0 ts=68bf1aa1 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=gWKObWcHZHFoBn1Bvp0A:9

The function vgic_flush_lr_state() is calling _raw_spin_unlock()
instead of the proper raw_spin_unlock().

_raw_spin_unlock() is an internal low-level API and should not
be used directly; using raw_spin_unlock() ensures proper locking
semantics in the vgic code.

Fixes: 8fa3adb8c6be ("KVM: arm/arm64: vgic: Make vgic_irq->irq_lock a raw_spinlock")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Acked-by: Marc Zyngier <maz@kernel.org>
---
v1 -> v2
Dropped extra paragraph and added Acked-by Marc
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

