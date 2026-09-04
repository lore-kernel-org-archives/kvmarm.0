Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7427451990B;
	Fri,  4 Sep 2026 17:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788544588; cv=none; b=aqUPaYEXlRtpWYPt5AMhf1X+3DF4A/2WH35C3UEKA43QH4GJ4ArjEAq62dX97SJHdUucMqoQiFZfjRIsPnX+n4X9g2KFgFfvK5d6mkc9ngl4cHNiiMceKrPK5KNpWRkcqDTmmGIflxiPWVBjwn0Y+ON+e74F/t0eXmA+GdfJiDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788544588; c=relaxed/simple;
	bh=YT5vHejrt6qS8wu067Am15Z0cFyfczDuhrILWpw3wB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DlR/CpC7MsTbF4/cBFHf6bTDVbdLMZ2blZDBRn+Gl/P98kLgj/G0oOY+eiXNwNsdvdx63X45mtFz9Rp0c/Gajc6ELR/q+c5bAiCURTkVi4KQJSurD1sH7CPPmapOi3lQpYDTj+173VF2f0ylCsRptYabR/+x3cv996aSysnAmBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pMCLqrqW; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pMCLqrqW"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 684GlMYX3750885;
	Fri, 4 Sep 2026 17:55:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=vP42R
	s0oMl1Zy8aOwSKJvKZO7d2MtYGhluAoCdfaWAU=; b=pMCLqrqW//o74DBQ4cs0X
	0RI2/TeyBPOh3UWk3uAzE43x+/FbUqUPgHW2HdHZtyTm1twhAe2JIO/HWzklfri2
	F3+i2pM4+O4uvX6vcCoXDTmJf+6svYzWOoLtRHopYKHE9cYL0MamMCVf7xdUa2iX
	kqvreDzHmBtqJ3O9NxWLGhRldPVj6t0H1TmiUGn4u/AeQ7HcRFTkAZ/zwofyjP09
	zjssFGsR/zbqEpbGavVKve/egsNaGk4oFwyaytPQGJedfYJRoVRPDvj9bgcJ9nYt
	vNY/VHpMCL6JIbkljP4tBzYc6ggudt5rn7gY41AkuyoHPv3hFBoJlL6OydBqe2PU
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbpbb3b46-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Sep 2026 17:55:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 684HoW4B015964;
	Fri, 4 Sep 2026 17:55:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvv368n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Sep 2026 17:55:55 +0000 (GMT)
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 684HrwmN032217;
	Fri, 4 Sep 2026 17:55:55 GMT
Received: from donglzha-e6-vfio-setup.osdevelopmeniad.oraclevcn.com (donglzha-e6-vfio-setup.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.255.69])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4gbnvv366p-5;
	Fri, 04 Sep 2026 17:55:55 +0000 (GMT)
From: Dongli Zhang <dongli.zhang@oracle.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, loongarch@lists.linux.dev,
        kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev,
        joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
        yuzenghui@huawei.com, zhaotianrui@loongson.cn, maobibo@loongson.cn,
        chenhuacai@kernel.org, anup@brainfault.org, atish.patra@linux.dev,
        seanjc@google.com, pbonzini@redhat.com, shuah@kernel.org,
        dwmw2@infradead.org, joe.jin@oracle.com
Subject: [PATCH v2 4/4] KVM: selftests: Add arm64 coverage for steal time pid changes
Date: Fri,  4 Sep 2026 17:55:26 +0000
Message-ID: <20260904175550.430266-5-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260904175550.430266-1-dongli.zhang@oracle.com>
References: <20260904175550.430266-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-04_05,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2609040163
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA0MDE2MyBTYWx0ZWRfXzgrEmRxwsBzR
 CFJRbQDS/qiKKociCZOSlEBbzLZb4OVlG1zTxiPdbAej91DpEaZEhvX/jvnUE8N55DRqh+36jKQ
 A+BR/vEtnPJtoH9iLGmppkj9ZYbhzlS2rQ1TB+6+5iC6SXqjxS5T
X-Proofpoint-ORIG-GUID: o5TZUvJeLq5Mi2gmlFWNpZb1R6ATx88g
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA0MDE2MyBTYWx0ZWRfX5OA3o5aP3GRT
 TgdPJIsJrx0Is6v21ud5b7I7tgqzV8IACNsgN03vZUHAKdeaLFYCnSZhyavlEZbVdu7N8HwAR+m
 rWW2xImZoekn1HBGLHZDmOAVlyYBTXk8puv904bGov5tjxUfNMbuNY+fpSyhi0yGgPLPCvTeuCv
 t5NRZ2+F+qFOIn/nBGTk4axNWgZy1+6zFdqKnre+3xSYD+ia+dX1OQGyiuV2dilItg3sSac5XSC
 2WLmG3iGHyTJkDZj5uyVVBPIrnCt/3+spxm4vDIgR02w9nGPmIulIwSWym6vDJMhY3Lw0O9uGW4
 TBgpLLjxfYHNHzl5d5hqaFQGlacBBoKIDQcwCI1dxyOc7Ho8PgnN4TOumNQfjxczmx7MHnusHD5
 7RFzc1E+TGaVwNzucsK/WUktm2uGTWa0ZwWRSYH3WHM9kMxruWyVYFG3KFVl0JpNfbBDRxes7Ld
 Hz6s7JmT0G1epXZTun8fs3XMtXMw1mR9Es+lfsHs=
X-Authority-Analysis: v=2.4 cv=DMi/JSNb c=1 sm=1 tr=0 ts=6a9b062d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8 a=zoPMrToQ-1bC4j5_0E8A:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12101
X-Proofpoint-GUID: o5TZUvJeLq5Mi2gmlFWNpZb1R6ATx88g

The previous patch added the common steal_time_change_pid test with x86
support. Add the arm64 support so the same test also covers arm64.

Use KVM_ARM_VCPU_PVTIME_IPA to enable the steal time shared page from
userspace, and use the PV_TIME_ST SMCCC call in the guest to retrieve and
read that page.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
As I have access to only x86 and arm64 KVM hosts, I created and validated
the selftest on those two architectures only.

 tools/testing/selftests/kvm/Makefile.kvm      |  1 +
 .../selftests/kvm/steal_time_change_pid.c     | 54 +++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 036c28849f84..1de13c0017e4 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -205,6 +205,7 @@ TEST_GEN_PROGS_arm64 += guest_memfd_test
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
2.43.7

