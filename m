Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556AE33F385
	for <kvmarm@lists.linux.dev>; Sun, 16 Aug 2026 05:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786858889; cv=none; b=UHQO9j23ssDtWOyVBpz9tTQGO4XjO5kGxKDAV2uZ879U/vZ+LG+EghxTRagJ7jhm5x5IHqCsEv26pd+YvL/CgJQcZCpE+3Z8h84AVKTEmmskLFa2/m3RFMdOQKEftltj2Brq5LvjYw+wg+WuaYiaf9j7M+oFIwHwqp8oJ2gMEdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786858889; c=relaxed/simple;
	bh=71qx901NP5znNCL55eXoXzQKy4vn9gygTZ064laOfjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kv6UwR2N/kvnT/+BlxnWo2KI/sHQj8Nis+AHKnNk+vzeAcWKOFwtnPl3TW1Wu1ahZ30c/ZUaKPzjsunuxxGO85MNf6BMMbFr/gUC5wr++ytXYZw850yG8hKw7RII16rGVXqRXF2KlO/73KtbXH1hkR0OHfABW2BEYKMYKaGstmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=O7CKfUJs; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O7CKfUJs"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67G2qdQ91226642;
	Sun, 16 Aug 2026 05:40:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=s8QlB
	fyxDAgxpcYzn7aRIVOJ3c9bBC13AW9S5D3E7YM=; b=O7CKfUJsWX58jqm99mbxt
	W6GiY30tzi8aGFxIfXV5V5+VH7vI6GvsBTLSL1lWtI3eF8TTAKm2LJSu2RjdCxP7
	tgJCvQ59jCti9CcX9nUnACQgM4IzTn3mELP6ghY84jZw/E9NrKl+5im8OdkmhMPz
	DVipd6vDi38vxp8/oe6A/zMvigs0sjYkisEnYuXXnmQLXi3/LjKqh6OlLHKGh0B2
	1/AVYOXij84N1EygSxBG6E73xcXzl0ywSB5l/GIhWeDC/s7A3ZXZ3KbNYECyK3u5
	LcgZ23M4sgeb5zYemM37e+tu6d9wCVhFAlB78QiIUII0l04L+qg6VHBqFF51Xp4q
	A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4g2gns0re8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 16 Aug 2026 05:40:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67G5e9Vw011009;
	Sun, 16 Aug 2026 05:40:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4g2ejammc6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 16 Aug 2026 05:40:55 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 67G5ereX012353;
	Sun, 16 Aug 2026 05:40:55 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4g2ejammbp-3;
	Sun, 16 Aug 2026 05:40:55 +0000 (GMT)
From: Dongli Zhang <dongli.zhang@oracle.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-kselftest@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, maz@kernel.org, oupton@kernel.org,
        fuad.tabba@linux.dev, joey.gouly@arm.com, seiden@linux.ibm.com,
        suzuki.poulose@arm.com, yuzenghui@huawei.com, dwmw2@infradead.org,
        joe.jin@oracle.com
Subject: [PATCH 2/4] KVM: arm64: Reset last_steal on vCPU pid change
Date: Sat, 15 Aug 2026 22:33:03 -0700
Message-ID: <20260816053630.527528-3-dongli.zhang@oracle.com>
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
X-Proofpoint-GUID: FuSAHudijJ0NAHrvwvrL189mIsVXTURu
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE2MDAzOSBTYWx0ZWRfXx6t0ynGQnlqH
 CWwSvYra8+dtvi4HoaY+flXw6tUlTLpINq1ipnZxKlJ8OY9Lox3uQqNkm6WqEDjh8+xBVgmAsIo
 oep3AfNDCN67RGYGukMah4Fswe7ximhYjJ3ZI1+IL+4b3EM1AwVC
X-Proofpoint-ORIG-GUID: FuSAHudijJ0NAHrvwvrL189mIsVXTURu
X-Authority-Analysis: v=2.4 cv=a8UAM0SF c=1 sm=1 tr=0 ts=6a814d68 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=R7If_T99NTk8TUeNlqIA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE2MDAzOSBTYWx0ZWRfXxBMRNzKEVwhh
 1/VanQ35L8Z9LgwulZNTOferDABmGBRLtj/y7Ff7CJqt8THjuCaWvGEvqHTppxalxAJ4knRT0Vw
 0cLKguA7fPN1pfp3q6lTIqf5TsE8b9cgvpGM4+3m4vKP83bNRm7Q4SJxsa/LuYG3a21h+65nINk
 MLWl35f+FspiHt4HOdudA2S073CZCXjecGh/sMz9zixIr0E/Kw0bLCRr+dTi6tbkT5P9YzJb8oh
 /+Emo+e7AnOXwGHlCBxpp5ybVdvVOKS2dwUqqATX//RD8QBABwZv6KFAZHZJqXrslnRE1yDYdr/
 cdvcqo9wUk7il2gilFI7qEqgXIeBeaikqxFG98CYnOqAciOEN47Ty/4n2cq95rhGmjycgTOLzbb
 bmXvtRkkeAL7XWBAMJqdXFMW5eA4ahf+lqJ6LEe1ZBnFqCMSQu40iAEiDy+ZrcisOWc1ZjJQwtl
 cxU1HzPIHCjSdtfCNRg==

The previous commit resets x86 steal time accounting when the vCPU PID is
changed. Do the same for arm64.

KVM keeps a vCPU fd alive when userspace hot-unplugs a vCPU. If the fd is
later reused from a new vCPU thread, vcpu->arch.steal.last_steal still
reflects the old task's run_delay, while current->sched_info.run_delay
belongs to the new task.

Reset vcpu->arch.steal.last_steal from kvm_arch_vcpu_run_pid_change()
unconditionally so the next stolen time update computes its delta against
the new task's run_delay.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/arm.c              | 2 ++
 arch/arm64/kvm/pvtime.c           | 5 +++++
 3 files changed, 8 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bae2c4f92ef5..4607f956e787 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1339,6 +1339,7 @@ static inline bool kvm_arch_pmi_in_guest(struct kvm_vcpu *vcpu)
 long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu);
 gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu);
 void kvm_update_stolen_time(struct kvm_vcpu *vcpu);
+void kvm_reset_stolen_time(struct kvm_vcpu *vcpu);
 
 bool kvm_arm_pvtime_supported(void);
 int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9a6c72a18672..0f6e63eace21 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -929,6 +929,8 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 	if (!kvm_arm_vcpu_is_finalized(vcpu))
 		return -EPERM;
 
+	kvm_reset_stolen_time(vcpu);
+
 	if (likely(vcpu_has_run_once(vcpu)))
 		return 0;
 
diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index 4ceabaa4c30b..000bf49cc0fd 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -32,6 +32,11 @@ void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
+void kvm_reset_stolen_time(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
+}
+
 long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
 {
 	u32 feature = smccc_get_arg1(vcpu);
-- 
2.43.5

