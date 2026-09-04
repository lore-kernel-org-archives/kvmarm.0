Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4E2517BAD;
	Fri,  4 Sep 2026 17:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788544587; cv=none; b=pawN5wZjOCgV9+yuTxEGg7N68hUyF2CoQ8YasPekSrzi3ky7NEit6ZYl/JADBB1v+l/e/q5M4nAeVfssLI6YZlbqytoKJ/XPPBD5VdHqAsOXiIpHHZ0647SWO9Q1PK6KJ5KHHVzr38E/pl154ttTIOeyx2dpXRwrCKlz3xZUA6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788544587; c=relaxed/simple;
	bh=+z+Q6g558Gbao+bIpREaMco9bGw+CFXLVs+Xzp791Gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuoJAHhQw9WkcTBwUhLDy8mvB/iSMkhUHjrAjx9sP5G5XGpAg7uRqc+yj3uPNTiYB8Fza6dG+3hRW8Mczy6hpZ+Od0JkIQGjDTqMBRKVwxIa/oO4RUQcpRibt540oGL+a6JiOs/rCFUHKQXBaw6A4wdCF0G4M/ZBp1AF2PvIfKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IDmukJAE; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IDmukJAE"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 684GheAh335150;
	Fri, 4 Sep 2026 17:55:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=xaSri
	KdSChkYrc3CoUDpWe1qDz81hMBkBXk69kNddDY=; b=IDmukJAEHNo3lr7ldtCw2
	/Y5y88URUuGzYv5U0fO9j0gtnIt/ZBhLNYJQ7fUGv9zgGhNrJK9/c9ys9h7OLHg7
	z8HmQi3czXKe1zTgTiC8LOelvpJ6RL6itN/IC5bpjJbn419akapAU95iYgKijbzH
	PhMM1cfFAM8KClfdh9jlPL36QHMgo7CyeYiqReUO7dweBcxywmsKDDb7pRwfn/OT
	E6mgRqA8qGt4QI1ZlY1pUZFmwoCy8aGxZLRy9/nyA1mQqITApwLCTEJDSxVN1U3s
	yLWByfDKxt7myw0pVs8Nj8XxD+TdtJ/P9jJ2hDg9XqtXxdZ8dxpJ68raeWFcRT3g
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbqfcbcbd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Sep 2026 17:55:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 684HoYm3016157;
	Fri, 4 Sep 2026 17:55:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvv3682-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Sep 2026 17:55:54 +0000 (GMT)
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 684HrwmJ032217;
	Fri, 4 Sep 2026 17:55:53 GMT
Received: from donglzha-e6-vfio-setup.osdevelopmeniad.oraclevcn.com (donglzha-e6-vfio-setup.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.255.69])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4gbnvv366p-3;
	Fri, 04 Sep 2026 17:55:53 +0000 (GMT)
From: Dongli Zhang <dongli.zhang@oracle.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, loongarch@lists.linux.dev,
        kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev,
        joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
        yuzenghui@huawei.com, zhaotianrui@loongson.cn, maobibo@loongson.cn,
        chenhuacai@kernel.org, anup@brainfault.org, atish.patra@linux.dev,
        seanjc@google.com, pbonzini@redhat.com, shuah@kernel.org,
        dwmw2@infradead.org, joe.jin@oracle.com
Subject: [PATCH v2 2/4] KVM: Reset last_steal on vCPU pid change
Date: Fri,  4 Sep 2026 17:55:24 +0000
Message-ID: <20260904175550.430266-3-dongli.zhang@oracle.com>
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
X-Proofpoint-GUID: sCrpEqwJgf6UR4WNkyvL1u1UQZogZYkx
X-Proofpoint-ORIG-GUID: sCrpEqwJgf6UR4WNkyvL1u1UQZogZYkx
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA0MDE2MyBTYWx0ZWRfX7DNgAtYVnA/o
 5szuVIcKX5ja04UPJVsmBOL+g4EZEwIzDqIFnikOAoiTiwxF6ww5UgoaJE6wuJkXIGU1xW8lu2y
 TxVH8MPCikrSsRp5V+jgROpGQzXH2bGGCOFxaB4L7A1BGL0QJJ1R
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA0MDE2MyBTYWx0ZWRfX4g/mViLujzqM
 cHlCJBuW7BP5HFNWC2D8KGNUsbHrnZjM2Oc2R6Yx7AT+yAR8m6i8q6nTPpRvUaiwTqzBVu1yRDm
 6EoR39aSdusVpwFLP2ZscN9OgM4ae8sznYY4sP5juGmHWR5jOU4DneM9d0IBnLgwAVyNsNv/NBM
 kIejC/B5jNjCyMjDNezF1MAEn9bIlQS0RXOWIl2fAImX5BACV4Yjx7gtipm14d+i/Yx4RtsV++c
 kNdCp7I5ZUEda6CVZsgrOB+4SGO34Tmjjf1cgcI/ZB+Y1Q1N8janrl5sNeunx2NkAGbxc/mLBUg
 H9WSt6MYHaA/ujnWAIRQrb+NUvtImgZXHCyqQ1PivLdNv0T/GCVBY3JCM69Q50WAGZRp6mXfAQ7
 A+CEaVyYRDwiGeDBLE1r/WP5fSe2q2Y4ugNUQHmQcdG8D5UQAU0ZXbekHgLukBipf8rhI+RpwJ6
 pXHjW1Gu+ZrkplX1Y9UWynvoisdMCAmWzhxIDPbQ=
X-Authority-Analysis: v=2.4 cv=a9gAM0SF c=1 sm=1 tr=0 ts=6a9b062b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8
 a=gcm4F-h63GhBF9ddD6cA:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12101

KVM does not support vCPU hotplug. When a vCPU is removed, its
corresponding data structures are not freed by KVM. Instead, QEMU destroys
only the userspace state and the vCPU thread, while the KVM vCPU fd remains
open and parked in QEMU.

As a result, vcpu->last_steal is not reset.

If the same vCPU is later re-created by QEMU, last_steal retains its old
value, while current->sched_info.run_delay starts from zero since a new
vCPU thread is created. This causes
current->sched_info.run_delay - vcpu->last_steal to produce a large, bogus
value.

Fix this by resetting vcpu->last_steal to current->sched_info.run_delay
when KVM vCPU PID is changed.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
v1->v2:
  - Move from kvm_arch_vcpu_run_pid_change() to its caller.

 virt/kvm/kvm_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 65eb26a0520d..784f0d945b45 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4478,6 +4478,10 @@ static long kvm_vcpu_ioctl(struct file *filp,
 			if (r)
 				break;
 
+#ifdef CONFIG_HAVE_KVM_PV_STEAL_TIME
+			vcpu->last_steal = current->sched_info.run_delay;
+#endif
+
 			newpid = get_task_pid(current, PIDTYPE_PID);
 			write_lock(&vcpu->pid_lock);
 			vcpu->pid = newpid;
-- 
2.43.7

