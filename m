Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E2639945
	for <kvmarm@lists.linux.dev>; Wed, 11 Oct 2023 18:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yqNFdm5k"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39BHEYmG030258;
	Wed, 11 Oct 2023 18:02:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=2mZcSGe3FzfHE/vlEIGzQ9dh0t3lEx4SdkFt3rsMtnA=;
 b=yqNFdm5kz1bG5w28LHy082VBxDjHC0PuG20YKGHfcfZasAIP9JnuKD8l7vC+MJEdpsW2
 YFtgKxBD6hCNATTQK4nE7EVinUPQozLa+MI3lacW3FctXD2pkuPdovjHd82d+IQdnhNY
 kU5/a4lwUTeRaqgKt9nwrwOhTZVSiT6/fMwLH1zBOJST4Y6aX1Ab7pFsk0Xgi8pL7E+n
 li/lqko7I2OxpGCqABxsFc0uVHVAjmCve/UlkrHRlWLxnbyLcAxngzPVNm9qapsGtam3
 0yDg1xUY7c8jJpZvB3MPMXfqfXZi9mevUatzSCLcpyFu7BgnDK8Zwy7EzcrDrpEnIwht CQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tmh90xce9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Oct 2023 18:02:11 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39BGjvv1002533;
	Wed, 11 Oct 2023 18:02:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tjwsedscr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Oct 2023 18:02:10 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39BI1eE4029797;
	Wed, 11 Oct 2023 18:02:09 GMT
Received: from mlluis-mac.uk.oracle.com (dhcp-10-175-192-63.vpn.oracle.com [10.175.192.63])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3tjwsedrg7-3;
	Wed, 11 Oct 2023 18:02:09 +0000
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
Subject: [PATCH v3 2/3] arm64: Add missing _EL2 encodings
Date: Wed, 11 Oct 2023 18:01:01 +0000
Message-Id: <20231011180103.91774-3-miguel.luis@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231011180103.91774-1-miguel.luis@oracle.com>
References: <20231011180103.91774-1-miguel.luis@oracle.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-11_12,2023-10-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310110159
X-Proofpoint-GUID: 4mRDZMXkyKRdbzeZ77U61UijCAnSsfbs
X-Proofpoint-ORIG-GUID: 4mRDZMXkyKRdbzeZ77U61UijCAnSsfbs

Some _EL2 encodings are missing. Add them.

Signed-off-by: Miguel Luis <miguel.luis@oracle.com>
---
 arch/arm64/include/asm/sysreg.h | 37 +++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index ba5db50effec..d8e8607c9de8 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -484,6 +484,7 @@
 
 #define SYS_SCTLR_EL2			sys_reg(3, 4, 1, 0, 0)
 #define SYS_ACTLR_EL2			sys_reg(3, 4, 1, 0, 1)
+#define SYS_SCTLR2_EL2			sys_reg(3, 4, 1, 0, 3)
 #define SYS_HCR_EL2			sys_reg(3, 4, 1, 1, 0)
 #define SYS_MDCR_EL2			sys_reg(3, 4, 1, 1, 1)
 #define SYS_CPTR_EL2			sys_reg(3, 4, 1, 1, 2)
@@ -497,6 +498,10 @@
 #define SYS_VTCR_EL2			sys_reg(3, 4, 2, 1, 2)
 
 #define SYS_TRFCR_EL2			sys_reg(3, 4, 1, 2, 1)
+#define SYS_SDER32_EL2			sys_reg(3, 4, 1, 3, 1)
+#define SYS_VNCR_EL2			sys_reg(3, 4, 2, 2, 0)
+#define SYS_VSTTBR_EL2			sys_reg(3, 4, 2, 6, 0)
+#define SYS_VSTCR_EL2			sys_reg(3, 4, 2, 6, 2)
 #define SYS_HAFGRTR_EL2			sys_reg(3, 4, 3, 1, 6)
 #define SYS_SPSR_EL2			sys_reg(3, 4, 4, 0, 0)
 #define SYS_ELR_EL2			sys_reg(3, 4, 4, 0, 1)
@@ -514,6 +519,18 @@
 
 #define SYS_MAIR_EL2			sys_reg(3, 4, 10, 2, 0)
 #define SYS_AMAIR_EL2			sys_reg(3, 4, 10, 3, 0)
+#define SYS_MPAMHCR_EL2			sys_reg(3, 4, 10, 4, 0)
+#define SYS_MPAMVPMV_EL2		sys_reg(3, 4, 10, 4, 1)
+#define SYS_MPAM2_EL2			sys_reg(3, 4, 10, 5, 0)
+#define __SYS__MPAMVPMx_EL2(x)		sys_reg(3, 4, 10, 6, x)
+#define SYS_MPAMVPM0_EL2		__SYS__MPAMVPMx_EL2(0)
+#define SYS_MPAMVPM1_EL2		__SYS__MPAMVPMx_EL2(1)
+#define SYS_MPAMVPM2_EL2		__SYS__MPAMVPMx_EL2(2)
+#define SYS_MPAMVPM3_EL2		__SYS__MPAMVPMx_EL2(3)
+#define SYS_MPAMVPM4_EL2		__SYS__MPAMVPMx_EL2(4)
+#define SYS_MPAMVPM5_EL2		__SYS__MPAMVPMx_EL2(5)
+#define SYS_MPAMVPM6_EL2		__SYS__MPAMVPMx_EL2(6)
+#define SYS_MPAMVPM7_EL2		__SYS__MPAMVPMx_EL2(7)
 
 #define SYS_VBAR_EL2			sys_reg(3, 4, 12, 0, 0)
 #define SYS_RVBAR_EL2			sys_reg(3, 4, 12, 0, 1)
@@ -562,9 +579,29 @@
 
 #define SYS_CONTEXTIDR_EL2		sys_reg(3, 4, 13, 0, 1)
 #define SYS_TPIDR_EL2			sys_reg(3, 4, 13, 0, 2)
+#define SYS_SCXTNUM_EL2			sys_reg(3, 4, 13, 0, 7)
+
+#define __AMEV_op2(m)			(m & 0x7)
+#define __AMEV_CRm(n, m)		(n | ((m & 0x8) >> 3))
+#define __SYS__AMEVCNTVOFF0n_EL2(m)	sys_reg(3, 4, 13, __AMEV_CRm(0x8, m), __AMEV_op2(m))
+#define SYS_AMEVCNTVOFF0n_EL2(m)	__SYS__AMEVCNTVOFF0n_EL2(m)
+#define __SYS__AMEVCNTVOFF1n_EL2(m)	sys_reg(3, 4, 13, __AMEV_CRm(0xA, m), __AMEV_op2(m))
+#define SYS_AMEVCNTVOFF1n_EL2(m)	__SYS__AMEVCNTVOFF1n_EL2(m)
 
 #define SYS_CNTVOFF_EL2			sys_reg(3, 4, 14, 0, 3)
 #define SYS_CNTHCTL_EL2			sys_reg(3, 4, 14, 1, 0)
+#define SYS_CNTHP_TVAL_EL2		sys_reg(3, 4, 14, 2, 0)
+#define SYS_CNTHP_CTL_EL2		sys_reg(3, 4, 14, 2, 1)
+#define SYS_CNTHP_CVAL_EL2		sys_reg(3, 4, 14, 2, 2)
+#define SYS_CNTHV_TVAL_EL2		sys_reg(3, 4, 14, 3, 0)
+#define SYS_CNTHV_CTL_EL2		sys_reg(3, 4, 14, 3, 1)
+#define SYS_CNTHV_CVAL_EL2		sys_reg(3, 4, 14, 3, 2)
+#define SYS_CNTHVS_TVAL_EL2		sys_reg(3, 4, 14, 4, 0)
+#define SYS_CNTHVS_CTL_EL2		sys_reg(3, 4, 14, 4, 1)
+#define SYS_CNTHVS_CVAL_EL2		sys_reg(3, 4, 14, 4, 2)
+#define SYS_CNTHPS_TVAL_EL2		sys_reg(3, 4, 14, 5, 0)
+#define SYS_CNTHPS_CTL_EL2		sys_reg(3, 4, 14, 5, 1)
+#define SYS_CNTHPS_CVAL_EL2		sys_reg(3, 4, 14, 5, 2)
 
 /* VHE encodings for architectural EL0/1 system registers */
 #define SYS_BRBCR_EL12			sys_reg(2, 5, 9, 0, 0)
-- 
2.39.2

