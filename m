Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3211C18C933
	for <kvmarm@lists.linux.dev>; Sun, 16 Aug 2026 05:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786858930; cv=none; b=OOjNuDaXOxrSu78ic2ny2Jhl/fTSVvgG6UB+Lzs/LAMLoZcb0kIe+FyJvjW4n4coRVfZtrcHLZ01A+JZlJQDaM2lGQHxVSjo3A6CVp1a/42qT4jNW/JJvlxhK7KUmklQYEDMtn6Vof8ihKJBTQ8cnuqLtN36PkrjElnPV8Ok1ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786858930; c=relaxed/simple;
	bh=k6aanD4kl87vFIzOM9YpBe892YlmwR2hZh4pu48dqPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTSBb93zFIz0huZEvoKfgJfBHmqgJfuUWbIpMNl6wL4/gqNsz1oziTN9BoFt0mc/WMIZGc5prCA8R2eFTmWRA0/bGO+vtIVvoc0kJ6HuSw1GQ/Uxv+SsLvaqGnxUKuGffdUgNFdGsBvtv/pDRBZ+bH884t4na6Wkf88xD5I1Yd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AMdQU54a; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AMdQU54a"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67G5F1Ta1815786;
	Sun, 16 Aug 2026 05:40:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=U3pic
	kv5tVeCDO59K2fiJcHyW63tAnxfs8LPzfOdtoI=; b=AMdQU54a7oWqbTdaZCnoq
	9knFgopvtp4UgzxYuj81IQKGOxSn3iJ1ZcBNoOxUAVSvydxJRu5luYKl2Ont1/cC
	66a0OiRKk6EZQuADMVlfJGh18aks3JscqJgmqz4MLf+Nkb5i3gOWa0gVQU0oxo2P
	RcOTPToOJ3G1kxVJOfWRCVxk7lZUzpnUhHFl6qQOQKRjTOspVI/y2k4TVubU26r0
	vedm3zzj5aG3+cBhGQ9IzYlSl6ITvdEquwhb4FZBzxd9+jXnyP/UeKqo6OF9YwAL
	gxZb6ZSx5YGRt5JnqVHWFd5Ji5T7syyS44V+HUM3S/caub5QNcEfX3n7+fttNKu6
	Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4g2g07gs62-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 16 Aug 2026 05:40:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67G5eAtY011059;
	Sun, 16 Aug 2026 05:40:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4g2ejammck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 16 Aug 2026 05:40:57 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 67G5ereb012353;
	Sun, 16 Aug 2026 05:40:56 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4g2ejammbp-5;
	Sun, 16 Aug 2026 05:40:56 +0000 (GMT)
From: Dongli Zhang <dongli.zhang@oracle.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-kselftest@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, maz@kernel.org, oupton@kernel.org,
        fuad.tabba@linux.dev, joey.gouly@arm.com, seiden@linux.ibm.com,
        suzuki.poulose@arm.com, yuzenghui@huawei.com, dwmw2@infradead.org,
        joe.jin@oracle.com
Subject: [PATCH 4/4] KVM: selftests: Add arm64 coverage for steal time pid changes
Date: Sat, 15 Aug 2026 22:33:05 -0700
Message-ID: <20260816053630.527528-5-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260816053630.527528-1-dongli.zhang@oracle.com>
References: <20260816053630.527528-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-16_01,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608160039
X-Proofpoint-GUID: qq1JtjJTPG1EyDjHFGSygFBLem78LP4I
X-Authority-Analysis: v=2.4 cv=Hu9G3UTS c=1 sm=1 tr=0 ts=6a814d6a cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=Sb3boAvBcC-Fi6NWb5QA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE2MDAzOSBTYWx0ZWRfX2r1SXnPWUKBH
 xOKWGO9NkMKr2XjxJDFDZQ1ma7DRuHB6+9G2K8ySSQWJyy+7ykvxkNFh6E6/gZ8N030TodPG2Bq
 iHpE3LEEEe9raJ48WRewMq+DldfgSSnhNssSdMcVWpEGfdMGga8B
X-Proofpoint-ORIG-GUID: qq1JtjJTPG1EyDjHFGSygFBLem78LP4I
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE2MDAzOSBTYWx0ZWRfX20IvJoZGijSt
 v/i60LQUJm7lshNsJWHPjfweeCfYVRUatUwNqT0/ZTVpucTpkzYl1o9GLUkpNM0iRpqFO/JrQju
 PONgPUgeVTp9m9C2Tx8moA7HJoHswpdQaqeTja7YoOHHA2ai4gl9trWJXA8dMJ972lhknwoMjYY
 QLMCC1czo1jQccC5RKfb2XDgSa+LRAToQ2jU4kapNgXiUO3hts67jL3P9clp89eZWEUC5Vgvsa7
 mYbFBZePQDJ1WLOmVp4dDUsy2OQVpVcOiSZmKaYii5wCq7qHPu5i2MSHWJFRqPOqbPeAFmn2vF/
 ma57qiBV1fMab6qJvisU95blkQAli5sVdJfvcro1TbvnypxRch78/RUSf4tt2rbki5Mcmrdqv+Q
 S1Zaidg0raOo1Huq045HGFDbzAO5+e9AGYBgUKUOgIVHq+wHngA3TjSO87fYBQoFB7whJSKnPAy
 MTrydrCUcrpaji9oLjg==

The previous patch added the common steal_time_change_pid test with x86
support. Add the arm64 support so the same test also covers arm64.

Use KVM_ARM_VCPU_PVTIME_IPA to enable the steal time shared page from
userspace, and use the PV_TIME_ST SMCCC call in the guest to retrieve and
read that page.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |  1 +
 .../selftests/kvm/steal_time_change_pid.c     | 54 +++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index c8ce17851561..b01a3403d602 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -199,6 +199,7 @@ TEST_GEN_PROGS_arm64 += guest_memfd_test
 TEST_GEN_PROGS_arm64 += mmu_stress_test
 TEST_GEN_PROGS_arm64 += rseq_test
 TEST_GEN_PROGS_arm64 += steal_time
+TEST_GEN_PROGS_arm64 += steal_time_change_pid
 
 TEST_GEN_PROGS_s390 = $(TEST_GEN_PROGS_COMMON)
 TEST_GEN_PROGS_s390 += s390/memop
diff --git a/tools/testing/selftests/kvm/steal_time_change_pid.c b/tools/testing/selftests/kvm/steal_time_change_pid.c
index 3c39594db398..12d4927d1c01 100644
--- a/tools/testing/selftests/kvm/steal_time_change_pid.c
+++ b/tools/testing/selftests/kvm/steal_time_change_pid.c
@@ -46,6 +46,60 @@ static void steal_time_enable(struct kvm_vcpu *vcpu)
 		     (ulong)st_gva | KVM_MSR_ENABLED);
 }
 
+#elif defined(__aarch64__)
+
+#define STEAL_TIME_SIZE	((sizeof(struct st_time) + 63) & ~63)
+
+#define PV_TIME_ST	0xc5000021
+
+struct st_time {
+	u32 rev;
+	u32 attr;
+	u64 st_time;
+};
+
+static void guest_code(void)
+{
+	struct arm_smccc_res res;
+	struct st_time *st;
+
+	do_smccc(PV_TIME_ST, 0, 0, 0, 0, 0, 0, 0, &res);
+	GUEST_ASSERT_NE(res.a0, -1);
+	GUEST_ASSERT_EQ(res.a0, (ulong)st_gva);
+
+	st = (struct st_time *)res.a0;
+	WRITE_ONCE(guest_stolen_time, READ_ONCE(st->st_time));
+	GUEST_SYNC(0);
+
+	WRITE_ONCE(guest_stolen_time, READ_ONCE(st->st_time));
+	GUEST_SYNC(1);
+
+	WRITE_ONCE(guest_stolen_time, READ_ONCE(st->st_time));
+	GUEST_DONE();
+}
+
+static bool steal_time_supported(struct kvm_vcpu *vcpu)
+{
+	struct kvm_device_attr dev = {
+		.group = KVM_ARM_VCPU_PVTIME_CTRL,
+		.attr = KVM_ARM_VCPU_PVTIME_IPA,
+	};
+
+	return !__vcpu_ioctl(vcpu, KVM_HAS_DEVICE_ATTR, &dev);
+}
+
+static void steal_time_enable(struct kvm_vcpu *vcpu)
+{
+	u64 st_ipa = (ulong)st_gva;
+	struct kvm_device_attr dev = {
+		.group = KVM_ARM_VCPU_PVTIME_CTRL,
+		.attr = KVM_ARM_VCPU_PVTIME_IPA,
+		.addr = (u64)&st_ipa,
+	};
+
+	vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &dev);
+}
+
 #else
 #error "steal_time_change_pid is not implemented on this architecture"
 #endif
-- 
2.43.5

