Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7432951990C;
	Fri,  4 Sep 2026 17:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788544589; cv=none; b=dqSW0V0RYPuXZpLS0uwAkAp2kLSgmFs3K5gxEDUFe1HDmtTZC5wR8AhoWRAfm+R+FHbd5jludX+9VZGkiD3S6vjYk+j5G8hjN/9Q+gLa7x85qUDzUYgBwXEXcSM6FmENEL8X/+PicwKTIdN4xpvHb0Zk8/GAz8sL3emL/+1lhOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788544589; c=relaxed/simple;
	bh=iPojDadhs7jRZqSVeoQ7ARmCCB1xlJ7viqP4eGAcvOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5WoANnXvGh6tnB4QZBuUpcNuFNwK+rVLNkBIZUVYZhge0Gw7deh40VtbrgMW0SDgZ5jhwBB3yggpDQJxFH0QW86PUk3Zbev+GPQpfqJSqE16xw9G/CCB3Y7ScCGq36/S3NQctY1FZphhK3TlB9KcQv/w5sLuWgxitbU487NDUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aez0rP6g; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aez0rP6g"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 684GlMkj3750877;
	Fri, 4 Sep 2026 17:55:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=6iXgM
	xHD3EX0uxPlPF+/kWo8h4vhjuK3982RDel46+Y=; b=aez0rP6guOp31/pF7piym
	Ks0t/R8THgGLN/pzybHskW0NxTWkCQzX/m4RVhZbJfjMnFaa0fgu5ZA2QKHOATXj
	dqusLuB9x5qN495za0nXylZxvpbNpbXNFJN8iB0UdAoCaUdJu65g9lfNgMLYvLSo
	S6w3oOUnlar1OWuGo0udB/tu68vyJsNjPOsmBlPtjVKDuYgQNSvsofsaMk01qXvn
	oCb5SgwKsVdFVvdQG+lJ9NHaK/2r7QyQVtUqD6JDwdODmn/0Nai0QjMjo2VG77l7
	Heyup6hbWJ9P2hfp+ZlRcdcGJ9TrLrQxyJPdsdDR2ClwVbr6D5J1vWj7I/gJARAc
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbpbb3b45-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Sep 2026 17:55:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 684HoXOG016069;
	Fri, 4 Sep 2026 17:55:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvv367k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Sep 2026 17:55:53 +0000 (GMT)
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 684HrwmH032217;
	Fri, 4 Sep 2026 17:55:53 GMT
Received: from donglzha-e6-vfio-setup.osdevelopmeniad.oraclevcn.com (donglzha-e6-vfio-setup.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.255.69])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4gbnvv366p-2;
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
Subject: [PATCH v2 1/4] KVM: Move last_steal to common struct kvm_vcpu
Date: Fri,  4 Sep 2026 17:55:23 +0000
Message-ID: <20260904175550.430266-2-dongli.zhang@oracle.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA0MDE2MyBTYWx0ZWRfX9afD0e8BUuSL
 8Pw9fO/WPp5iZGPyco+E2o+QoUqPdjsOC4Rqw8c/IHBvOZeK0hGonAOh4H+vajeWMMFzSPeVzG2
 AfQr3Url04Ucqhu3yvaJuuLSljmHVUFuHp7W9fuiy6/I+ES7zo4y
X-Proofpoint-ORIG-GUID: bYRsaz571kuc6JEDqC_MsyCbC6FIMUMs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA0MDE2MyBTYWx0ZWRfX3BTJZPgvKLT2
 cZgqEKyOvbD2m0ree4dNDl/WAfE0MwySpUU7Y2diZQ38mBwFW8slILhUQDlUNLZi8AT/0FsjtjN
 cehTr/zeZjgTxzoBKT/+TPt3klI4N2ojKQsciOsbhwBjhhl8ivjWPYvKkxqm8vbtq6oGREDu4zn
 UttDG6XFVone6hER59bPyM3QpqeZbDC6xfXQnFlLUwB4ebPhhRVrot7yLeC6A/UKt82xQc1wVAw
 0F+ZLUPTibgroqld6jE9AHjGzN6lI6tBwM0XJJ1Pqok89CEXZd7rU+x0w+KIcq4pycAOYdJXNwe
 mNYcgYj68bvarY2vxt+07UqZSAzu7PKyF1lHiOWc5fhvLO7NedzA7DZ3k+eLNVwzYPCRwypfYq0
 YG6Whj4QOaSY/1n2oGbA7Gxn7CJ+o+XZ8Sc8uV+rl54cu7w2uwYzcm6lFgYqgv893OLX89fz6H7
 mECL5+TQapBgjB9O27NXKj2xB+0YRIeqFh9Xrzrs=
X-Authority-Analysis: v=2.4 cv=DMi/JSNb c=1 sm=1 tr=0 ts=6a9b062b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=BuLvuczXJ8S_3_ykL7AA:9 a=ml6Odv02XoMIxi_K:21 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12101
X-Proofpoint-GUID: bYRsaz571kuc6JEDqC_MsyCbC6FIMUMs

KVM caches per-vCPU host task's run_delay in per-architecture struct
kvm_vcpu_arch at last_steal.

Move the cache to struct kvm_vcpu and convert x86, arm64, riscv, and
loongarch to use the common field.

Add HAVE_KVM_PV_STEAL_TIME so last_steal is used only for architectures
that implement KVM stealtime.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
Marc suggested reusing CONFIG_HAVE_PV_STEAL_CLOCK_GEN, but I introduced
HAVE_KVM_PV_STEAL_TIME instead.

As I have access to only x86 and arm64 KVM hosts, I created and validated
the selftest on those two architectures only.

 arch/arm64/include/asm/kvm_host.h     |  1 -
 arch/arm64/kvm/Kconfig                |  1 +
 arch/arm64/kvm/pvtime.c               |  8 ++++----
 arch/loongarch/include/asm/kvm_host.h |  1 -
 arch/loongarch/kvm/Kconfig            |  1 +
 arch/loongarch/kvm/exit.c             |  2 +-
 arch/loongarch/kvm/vcpu.c             |  6 +++---
 arch/riscv/include/asm/kvm_host.h     |  1 -
 arch/riscv/kvm/Kconfig                |  1 +
 arch/riscv/kvm/vcpu_sbi_sta.c         | 10 +++++-----
 arch/x86/include/asm/kvm_host.h       |  1 -
 arch/x86/kvm/Kconfig                  |  1 +
 arch/x86/kvm/x86.c                    |  5 ++---
 include/linux/kvm_host.h              |  4 ++++
 virt/kvm/Kconfig                      |  3 +++
 15 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 27fe0cd5b2d7..36cb7dee988c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -937,7 +937,6 @@ struct kvm_vcpu_arch {
 
 	/* Guest PV state */
 	struct {
-		u64 last_steal;
 		gpa_t base;
 	} steal;
 
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 449154f9a485..f5855bfc681c 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -34,6 +34,7 @@ menuconfig KVM
 	select HAVE_KVM_IRQ_BYPASS
 	select HAVE_KVM_READONLY_MEM
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
+	select HAVE_KVM_PV_STEAL_TIME
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
 	select KVM_GUEST_MEMFD
diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index 4ceabaa4c30b..a67d93845d79 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -14,7 +14,7 @@ void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
 	u64 base = vcpu->arch.steal.base;
-	u64 last_steal = vcpu->arch.steal.last_steal;
+	u64 last_steal = vcpu->last_steal;
 	u64 offset = offsetof(struct pvclock_vcpu_stolen_time, stolen_time);
 	u64 steal = 0;
 	int idx;
@@ -25,8 +25,8 @@ void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
 	idx = srcu_read_lock(&kvm->srcu);
 	if (!kvm_get_guest(kvm, base + offset, steal)) {
 		steal = le64_to_cpu(steal);
-		vcpu->arch.steal.last_steal = READ_ONCE(current->sched_info.run_delay);
-		steal += vcpu->arch.steal.last_steal - last_steal;
+		vcpu->last_steal = READ_ONCE(current->sched_info.run_delay);
+		steal += vcpu->last_steal - last_steal;
 		kvm_put_guest(kvm, base + offset, cpu_to_le64(steal));
 	}
 	srcu_read_unlock(&kvm->srcu, idx);
@@ -61,7 +61,7 @@ gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
 	 * Start counting stolen time from the time the guest requests
 	 * the feature enabled.
 	 */
-	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
+	vcpu->last_steal = current->sched_info.run_delay;
 	kvm_write_guest_lock(kvm, base, &init_values, sizeof(init_values));
 
 	return base;
diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 23cfbecebbd7..14514a25b261 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -253,7 +253,6 @@ struct kvm_vcpu_arch {
 	/* paravirt steal time */
 	struct {
 		u64 guest_addr;
-		u64 last_steal;
 		struct gfn_to_hva_cache cache;
 		u8  preempted;
 	} st;
diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
index 15da2d88c0c1..4996ec9c07f9 100644
--- a/arch/loongarch/kvm/Kconfig
+++ b/arch/loongarch/kvm/Kconfig
@@ -26,6 +26,7 @@ config KVM
 	select HAVE_KVM_MSI
 	select HAVE_KVM_READONLY_MEM
 	select KVM_COMMON
+	select HAVE_KVM_PV_STEAL_TIME
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_MMIO
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index 4f58e6e2cf86..56ae6b18f8c1 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -773,7 +773,7 @@ static long kvm_save_notify(struct kvm_vcpu *vcpu)
 		if (!(data & KVM_STEAL_PHYS_VALID))
 			return 0;
 
-		vcpu->arch.st.last_steal = current->sched_info.run_delay;
+		vcpu->last_steal = current->sched_info.run_delay;
 		kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
 		return 0;
 	default:
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index ed9e092c97ba..728d29eba8e0 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -187,8 +187,8 @@ static void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
 	smp_wmb();
 
 	unsafe_get_user(steal, &st->steal, out);
-	steal += current->sched_info.run_delay - vcpu->arch.st.last_steal;
-	vcpu->arch.st.last_steal = current->sched_info.run_delay;
+	steal += current->sched_info.run_delay - vcpu->last_steal;
+	vcpu->last_steal = current->sched_info.run_delay;
 	unsafe_put_user(steal, &st->steal, out);
 
 	smp_wmb();
@@ -1205,7 +1205,7 @@ static int kvm_loongarch_pvtime_set_attr(struct kvm_vcpu *vcpu,
 
 	if (!ret) {
 		vcpu->arch.st.guest_addr = gpa;
-		vcpu->arch.st.last_steal = current->sched_info.run_delay;
+		vcpu->last_steal = current->sched_info.run_delay;
 		kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
 	}
 
diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index a30600579231..305875301c04 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -273,7 +273,6 @@ struct kvm_vcpu_arch {
 	/* SBI steal-time accounting */
 	struct {
 		gpa_t shmem;
-		u64 last_steal;
 	} sta;
 };
 
diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
index ec2cee0a39e0..1ff07a904a02 100644
--- a/arch/riscv/kvm/Kconfig
+++ b/arch/riscv/kvm/Kconfig
@@ -26,6 +26,7 @@ config KVM
 	select HAVE_KVM_READONLY_MEM
 	select HAVE_KVM_DIRTY_RING_ACQ_REL
 	select KVM_COMMON
+	select HAVE_KVM_PV_STEAL_TIME
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_MMIO
diff --git a/arch/riscv/kvm/vcpu_sbi_sta.c b/arch/riscv/kvm/vcpu_sbi_sta.c
index 60e50296a008..9a77d3bde7c7 100644
--- a/arch/riscv/kvm/vcpu_sbi_sta.c
+++ b/arch/riscv/kvm/vcpu_sbi_sta.c
@@ -19,13 +19,13 @@
 static void kvm_riscv_vcpu_sbi_sta_reset(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.sta.shmem = INVALID_GPA;
-	vcpu->arch.sta.last_steal = 0;
+	vcpu->last_steal = 0;
 }
 
 void kvm_riscv_vcpu_record_steal_time(struct kvm_vcpu *vcpu)
 {
 	gpa_t shmem = vcpu->arch.sta.shmem;
-	u64 last_steal = vcpu->arch.sta.last_steal;
+	u64 last_steal = vcpu->last_steal;
 	__le32 __user *sequence_ptr;
 	__le64 __user *steal_ptr;
 	__le32 sequence_le;
@@ -67,8 +67,8 @@ void kvm_riscv_vcpu_record_steal_time(struct kvm_vcpu *vcpu)
 
 	if (!WARN_ON(get_user(steal_le, steal_ptr))) {
 		steal = le64_to_cpu(steal_le);
-		vcpu->arch.sta.last_steal = READ_ONCE(current->sched_info.run_delay);
-		steal += vcpu->arch.sta.last_steal - last_steal;
+		vcpu->last_steal = READ_ONCE(current->sched_info.run_delay);
+		steal += vcpu->last_steal - last_steal;
 		WARN_ON(put_user(cpu_to_le64(steal), steal_ptr));
 	}
 
@@ -115,7 +115,7 @@ static int kvm_sbi_sta_steal_time_set_shmem(struct kvm_vcpu *vcpu)
 		return SBI_ERR_INVALID_ADDRESS;
 
 	vcpu->arch.sta.shmem = shmem;
-	vcpu->arch.sta.last_steal = current->sched_info.run_delay;
+	vcpu->last_steal = current->sched_info.run_delay;
 
 	return 0;
 }
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 683bb8bf43a9..ebdd8526ae12 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -872,7 +872,6 @@ struct kvm_vcpu_arch {
 	struct {
 		u8 preempted;
 		u64 msr_val;
-		u64 last_steal;
 		struct gfn_to_hva_cache cache;
 	} st;
 
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 538ed1e80332..b2aea8058841 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -40,6 +40,7 @@ config KVM_X86
 	select HAVE_KVM_MSI
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
 	select HAVE_KVM_NO_POLL
+	select HAVE_KVM_PV_STEAL_TIME
 	select VIRT_XFER_TO_GUEST_WORK
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_VFIO
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 79468ddfe473..927c8b1ed83d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2129,9 +2129,8 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	smp_wmb();
 
 	unsafe_get_user(steal, &st->steal, out);
-	steal += current->sched_info.run_delay -
-		vcpu->arch.st.last_steal;
-	vcpu->arch.st.last_steal = current->sched_info.run_delay;
+	steal += current->sched_info.run_delay - vcpu->last_steal;
+	vcpu->last_steal = current->sched_info.run_delay;
 	unsafe_put_user(steal, &st->steal, out);
 
 	version += 1;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 03bfc92864b6..ff9d423b6a7c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -398,6 +398,10 @@ struct kvm_vcpu {
 	 */
 	struct kvm_memory_slot *last_used_slot;
 	u64 last_used_slot_gen;
+
+#ifdef CONFIG_HAVE_KVM_PV_STEAL_TIME
+	u64 last_steal;
+#endif
 };
 
 /*
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index c3c0ee253fc7..f42a3a0fc5ba 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -82,6 +82,9 @@ config HAVE_KVM_IRQ_BYPASS
 config HAVE_KVM_VCPU_RUN_PID_CHANGE
        bool
 
+config HAVE_KVM_PV_STEAL_TIME
+       bool
+
 config HAVE_KVM_NO_POLL
        bool
 
-- 
2.43.7

