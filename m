Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6281D1F92C
	for <kvmarm@lists.linux.dev>; Mon, 16 Oct 2023 11:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Fe5p6hKc"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39G6n1Hn020635;
	Mon, 16 Oct 2023 11:17:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-03-30; bh=cYZPT0kSHMpbU6o+Gjv3y0QqFO0FSp+3oDPiMrpGdm0=;
 b=Fe5p6hKcqIo+LTKxp6y/PDrOScAqipgVDKihlsCkZd+4/OsuJcVWk/mmqAiQZ0CPHV5a
 jLtyzBZz31iWY+a9DCapN+bKNA+jtJAVAaK2nOH0lcII67mFdyyPQv+GIfyIHBkBGfT9
 eCN0jnb3GMmab3XdOjLb0i8ZIt/oRzjD/fIV73oeGUhPUv81oD5rpzv5HLkrrhB+Ht6f
 RwxQkTf+yNjcqXhEydI0R2ztd55ThLfLCmPUPG/NCrZjARgMZkhFyKjaObszZGAnd3yQ
 pwUBnp3KLPWNh0YY8sBJ3tNIdNvxSyuNXd5i8IL4a29HzWx8CXb+UHwhI7Sr8oRV6+li MQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqkhu2ejb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Oct 2023 11:17:54 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39G9MUvh027313;
	Mon, 16 Oct 2023 11:17:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg529h23-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Oct 2023 11:17:53 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39GBHqS8040637;
	Mon, 16 Oct 2023 11:17:52 GMT
Received: from mlluis-mac.uk.oracle.com (dhcp-10-175-197-167.vpn.oracle.com [10.175.197.167])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3trg529gvb-1;
	Mon, 16 Oct 2023 11:17:52 +0000
From: Miguel Luis <miguel.luis@oracle.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
        Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, Jing Zhang <jingzhangos@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc: miguel.luis@oracle.com
Subject: [PATCH v4 0/3] arm64/kvm: Fine grain _EL2 system registers list that affect nested virtualization
Date: Mon, 16 Oct 2023 11:17:39 +0000
Message-Id: <20231016111743.30331-1-miguel.luis@oracle.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_04,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=898 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310160099
X-Proofpoint-GUID: 5lxFsOScxNx3QQFg_J_v-MIGfog1Ov3H
X-Proofpoint-ORIG-GUID: 5lxFsOScxNx3QQFg_J_v-MIGfog1Ov3H

The current HCR_EL2 description defines ranges of system register encodings in
which accesses should trap for NV. These ranges include encodings which aren't
defined in the reference manual. In order avoid this, let's rather implement a
more fine grained approach excluding those undefined.

v3 -> v4
 patch 2:
	Add BRBCR_EL2.
 patch 3:
	Handle BRBCR_EL2.
	Add Eric's R-b. Thanks!

v3: https://lore.kernel.org/kvmarm/20231011180103.91774-1-miguel.luis@oracle.com/
v2: https://lore.kernel.org/kvmarm/20230925162057.27548-1-miguel.luis@oracle.com/
v1: https://lore.kernel.org/kvmarm/20230913185209.32282-1-miguel.luis@oracle.com/

Miguel Luis (3):
  arm64: Add missing _EL12 encodings
  arm64: Add missing _EL2 encodings
  arm64/kvm: Fine grain _EL2 system registers list that affect nested
    virtualization

 arch/arm64/include/asm/sysreg.h | 50 ++++++++++++++++++
 arch/arm64/kvm/emulate-nested.c | 89 ++++++++++++++++++++++++++++++---
 2 files changed, 133 insertions(+), 6 deletions(-)

--
2.39.2

