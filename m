Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3BB397
	for <kvmarm@lists.linux.dev>; Wed, 13 Sep 2023 18:53:26 +0000 (UTC)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38DFWIsp029849;
	Wed, 13 Sep 2023 18:53:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=WvnFDh8VGVX/yU+Sr+zbmMR9RVMpMl1pTRBM4gjviOE=;
 b=NMuwXlq9NfKpmcXFVR1MMSbr/Y1axUS9esvC1WZNAahpB9wmgXZr76nj2xCcGI7HWEx/
 u4VzQ21ybwDHnD0lk4fyujfGfoVrR3XZUwQgjw04JFukpktw7qIhvluUeKRAcoxs0Ie6
 qMwXZ1PEXQJGHtJNvoukrmzs6zCUN/Yz1MCgZxQNJGktQEYfU5oNrW2X0IKKQZLHVeDD
 SZrLtuIjgr7ZkjGv1utvL1wBE5XUUlboo9/G2sS7UjYtj6Sk36e4OgVI6aeB6KubIJ/8
 h96pA42lSFXMP+/rqw/3FiJ5YjqRH58aTATJc1ZLfdewZg5hH/GUxKyoVfHHljb4IuFe aA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t2y7rb2f7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Sep 2023 18:53:11 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38DHhnGB033088;
	Wed, 13 Sep 2023 18:53:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t0wkgxrep-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Sep 2023 18:53:11 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38DIqniu015352;
	Wed, 13 Sep 2023 18:53:10 GMT
Received: from mlluis-mac.uk.oracle.com (dhcp-10-175-187-203.vpn.oracle.com [10.175.187.203])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3t0wkgxqyp-4;
	Wed, 13 Sep 2023 18:53:10 +0000
From: Miguel Luis <miguel.luis@oracle.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
        Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc: miguel.luis@oracle.com
Subject: [PATCH 3/3] KVM: arm64: nv: Handle all _EL02 and _EL12 registers
Date: Wed, 13 Sep 2023 18:52:08 +0000
Message-Id: <20230913185209.32282-4-miguel.luis@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230913185209.32282-1-miguel.luis@oracle.com>
References: <20230913185209.32282-1-miguel.luis@oracle.com>
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
 spamscore=0 mlxlogscore=919 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309130158
X-Proofpoint-ORIG-GUID: NESHB0hhIH2rACbKdDapKjxhrgfZITx3
X-Proofpoint-GUID: NESHB0hhIH2rACbKdDapKjxhrgfZITx3

Specify both _EL02 and _EL12 system registers.

Signed-off-by: Miguel Luis <miguel.luis@oracle.com>
---
 arch/arm64/kvm/emulate-nested.c | 35 +++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 9aa1c06abdb7..957afd97e488 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -690,10 +690,37 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_RANGE_TRAP(sys_reg(3, 4, 14, 0, 3),
 			sys_reg(3, 4, 14, 5, 2), CGT_HCR_NV),
 	/* All _EL02, _EL12 registers */
-	SR_RANGE_TRAP(sys_reg(3, 5, 0, 0, 0),
-		      sys_reg(3, 5, 10, 15, 7), CGT_HCR_NV),
-	SR_RANGE_TRAP(sys_reg(3, 5, 12, 0, 0),
-		      sys_reg(3, 5, 14, 15, 7), CGT_HCR_NV),
+	SR_TRAP(SYS_SCTLR_EL12,		CGT_HCR_NV),
+	SR_TRAP(SYS_CPACR_EL12,		CGT_HCR_NV),
+	SR_TRAP(SYS_SCTLR2_EL12,	CGT_HCR_NV),
+	SR_TRAP(SYS_ZCR_EL12,		CGT_HCR_NV),
+	SR_TRAP(SYS_TRFCR_EL12,		CGT_HCR_NV),
+	SR_TRAP(SYS_SMCR_EL12,		CGT_HCR_NV),
+	SR_TRAP(SYS_TTBR0_EL12,		CGT_HCR_NV),
+	SR_TRAP(SYS_TTBR1_EL12,		CGT_HCR_NV),
+	SR_TRAP(SYS_TCR_EL12,		CGT_HCR_NV),
+	SR_TRAP(SYS_TCR2_EL12,		CGT_HCR_NV),
+	SR_TRAP(SYS_SPSR_EL12,		CGT_HCR_NV),
+	SR_TRAP(SYS_ELR_EL12,		CGT_HCR_NV),
+	SR_TRAP(SYS_AFSR0_EL12,		CGT_HCR_NV),
+	SR_TRAP(SYS_AFSR1_EL12,		CGT_HCR_NV),
+	SR_TRAP(SYS_ESR_EL12,		CGT_HCR_NV),
+	SR_TRAP(SYS_TFSR_EL12,		CGT_HCR_NV),
+	SR_TRAP(SYS_FAR_EL12,		CGT_HCR_NV),
+	SR_TRAP(SYS_BRBCR_EL12,		CGT_HCR_NV),
+	SR_TRAP(SYS_PMSCR_EL12,		CGT_HCR_NV),
+	SR_TRAP(SYS_MAIR_EL12,		CGT_HCR_NV),
+	SR_TRAP(SYS_AMAIR_EL12,		CGT_HCR_NV),
+	SR_TRAP(SYS_VBAR_EL12,		CGT_HCR_NV),
+	SR_TRAP(SYS_CONTEXTIDR_EL12,	CGT_HCR_NV),
+	SR_TRAP(SYS_SCXTNUM_EL12,	CGT_HCR_NV),
+	SR_TRAP(SYS_CNTKCTL_EL12,	CGT_HCR_NV),
+	SR_TRAP(SYS_CNTP_TVAL_EL02,	CGT_HCR_NV),
+	SR_TRAP(SYS_CNTP_CTL_EL02,	CGT_HCR_NV),
+	SR_TRAP(SYS_CNTP_CVAL_EL02,	CGT_HCR_NV),
+	SR_TRAP(SYS_CNTV_TVAL_EL02,	CGT_HCR_NV),
+	SR_TRAP(SYS_CNTV_CTL_EL02,	CGT_HCR_NV),
+	SR_TRAP(SYS_CNTV_CVAL_EL02,	CGT_HCR_NV),
 	SR_TRAP(OP_AT_S1E2R,		CGT_HCR_NV),
 	SR_TRAP(OP_AT_S1E2W,		CGT_HCR_NV),
 	SR_TRAP(OP_AT_S12E1R,		CGT_HCR_NV),
-- 
2.39.2

