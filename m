Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2A237F
	for <kvmarm@lists.linux.dev>; Wed, 13 Sep 2023 18:53:10 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38DEgRMn015891;
	Wed, 13 Sep 2023 18:52:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-03-30; bh=JRGnMOQ8ntcK/PfDsSVy77V2MwVKzovJtC/3PfUgqF0=;
 b=vJwvFj1mKF3fJfB9c+qk1T/OGhxxwm4fhu4rm8G3zADkmEkDUOKX2fiBsyIWAvUf0dvH
 H+CwxXd79O6m+a4+45rcviERG8oz6FKfSJh/8ufx4meYQG4Cvk6ZWhH5zOfCudA1+u19
 gyX1GP2Om5c/tASj5KPP4jYXTa1WXH0S3h8EjCELxqjPYtXAWr8OXTrnQoMLA/+LsYm9
 JLFEMxN6GQuSEGULNzb1D651yATFdYdEH/XNgW4JBnjREIKZ70Cff3yl8gt2xSe1iECT
 0tugg18F0dbgmn9RJgx9sA56Gmw8h0ooXHDVPH3sss0D/GJ5BGNBAwZpV0vN+VBjxPs4 1w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t37jr29vn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Sep 2023 18:52:50 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38DHZwc2033008;
	Wed, 13 Sep 2023 18:52:50 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t0wkgxr1f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Sep 2023 18:52:49 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38DIqnio015352;
	Wed, 13 Sep 2023 18:52:49 GMT
Received: from mlluis-mac.uk.oracle.com (dhcp-10-175-187-203.vpn.oracle.com [10.175.187.203])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3t0wkgxqyp-1;
	Wed, 13 Sep 2023 18:52:48 +0000
From: Miguel Luis <miguel.luis@oracle.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
        Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc: miguel.luis@oracle.com
Subject: [PATCH 0/3] Fine grain sysregs allowed to trap for nested virtualization
Date: Wed, 13 Sep 2023 18:52:05 +0000
Message-Id: <20230913185209.32282-1-miguel.luis@oracle.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-13_13,2023-09-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 spamscore=0 mlxlogscore=757 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309130158
X-Proofpoint-ORIG-GUID: VEH4FWHslC-6iaXHQS6OsuSWIdYxsL2P
X-Proofpoint-GUID: VEH4FWHslC-6iaXHQS6OsuSWIdYxsL2P

The current HCR_EL2 description includes _EL1 registers that are not affected
by NV. Let's exclude them from those ranges to implement a more fine grained
approach.

Miguel Luis (3):
  arm64: Add missing _EL12 encodings
  arm64/kvm: Fine grain _EL2 system registers list that affect nested
    virtualization
  KVM: arm64: nv: Handle all _EL02 and _EL12 registers

 arch/arm64/include/asm/sysreg.h | 11 +++++
 arch/arm64/kvm/emulate-nested.c | 79 ++++++++++++++++++++++++++++-----
 2 files changed, 80 insertions(+), 10 deletions(-)

--
2.39.2

