Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5557A18C933
	for <kvmarm@lists.linux.dev>; Sun, 16 Aug 2026 05:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786858888; cv=none; b=a1wE50TpWpK5IBXXTbLZ73e+lB1dDSnQhxPIUVxeBtS7RLGTxXYwXxeALSXRBjdMmfhSeYPXzsP007sHT9njqUJE6BA9DojX06e8jC9TD2APDY3joYuINqHs5+7DBKKmkKKSALttFAJFLod0b7gyo2ADAXM+3z8KIhavGDRe2ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786858888; c=relaxed/simple;
	bh=5nzLa1/IjgFGwHvpkMMcWFoTfKxcDovrnBnmzt48Ias=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1yaOHoz8lR1jH0FJsATiMASzoUI+l/lii82xUALbIfenosqu/rKc0PlLcqReOXOtOiGSFr46Q4BOOQ9dwt8W3ju7D8Eba8Bw85Ur/67PkhMMjH2yOOuzbTWOAKwJnXjZttITWa4cdLL0u+DXUgDYYpqTD3sFJfVHIOkZS0SEw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Brq0GIJ+; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Brq0GIJ+"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67G5FYJS1547265;
	Sun, 16 Aug 2026 05:40:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=CcCoJ
	nmGr7A2rPibgyIxfI9G6Wu7ebLWcr2cfop2j58=; b=Brq0GIJ+KHovuldPahFEF
	7043ZiIYioAS7GPXSAJf878S6gYEJXe/UrNfzANBNzITbeIU1mOaXwPv7QqeDy+m
	vTl65+VBp9t8/EnNt0+Ap6WXjO5tHqCFpWfIBAp6UWXAz92wsCEkRTVo1TNoEixA
	bR0d7iZOkCWt1caiFqV8OafCNloccTSa73uiv8RwpUizijr0m31C3IYzDKvrHHr/
	WBLCRUS02HQKiVTXO+HLrO1wxtUZXVe/mIo6a24p90xWUkzSPtkpha/4kQOK6dqc
	COqgQKTeEUyL1caz1BsJThLlcYvPqHCZnnZXes6EYCsvrHnqCshNhts96zPlQc37
	g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4g2epy10yb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 16 Aug 2026 05:40:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67G5e9w8010974;
	Sun, 16 Aug 2026 05:40:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4g2ejammc0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 16 Aug 2026 05:40:54 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 67G5ereV012353;
	Sun, 16 Aug 2026 05:40:54 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4g2ejammbp-2;
	Sun, 16 Aug 2026 05:40:54 +0000 (GMT)
From: Dongli Zhang <dongli.zhang@oracle.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-kselftest@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, maz@kernel.org, oupton@kernel.org,
        fuad.tabba@linux.dev, joey.gouly@arm.com, seiden@linux.ibm.com,
        suzuki.poulose@arm.com, yuzenghui@huawei.com, dwmw2@infradead.org,
        joe.jin@oracle.com
Subject: [PATCH 1/4] KVM: x86: Reset last_steal on vCPU pid change
Date: Sat, 15 Aug 2026 22:33:02 -0700
Message-ID: <20260816053630.527528-2-dongli.zhang@oracle.com>
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
X-Proofpoint-GUID: Rc4XRtgyggpCeWmJ58vn7PszBwYVTPcl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE2MDAzOSBTYWx0ZWRfX+8pT09+NWa5T
 X3e6Kry1fHWIY5K1niPoS9QHCe51vvk4hFtC8RHUpVrPDnSRELCutLlzqcHW/7I+OZ6IBZHKZCY
 nuSyjBcYjmVuZ2/5xGXOEah5vEYTc1c0DAz2iAF31lx+t1W24/7xbPo/+Y8chuRwKjmJieNvQ5n
 PtNVxDKQYDthuHPjhjqxzCg1w8vBA6Ml5VoRrR1iJPKdH0liUNH8Q+p9NfYLxGuNcFtTVbwSXXr
 5I04wQS0UTH7LAEPIXANUYPDIZ4Q6xj8ZHoqk4LZh6Vn1xRBeoqWu5JjZCdWcxFX4IParuuA0+i
 4JiT+eH84WlocdfYGoegt61I0iysw0K6alNv2QzHPu10zkPqBNJBS4Fv0J2CJt6N/I1hVkvUrgi
 ELJO06c3dYFccrdfepcCeedN5vIqbxSoXgRZBDDwhEjSEJr5lPfdHuA3JauvW40fzPX3xEAVpVx
 zbD8Ajspll3Zm4DGrsQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE2MDAzOSBTYWx0ZWRfXyn1OPQl4+yfH
 eq0NPjrhFzABmQ+c4avr7Uor1j0pBlJ3PXfJLRcJ5u5iUxvyDCrXRmvnkLtzBb7OEcdBA6otlVy
 WnIGeuGREhypS9HGI3TzYi6jcRtRIdOpBpOHTPGC1ZDltJ77XfUp
X-Proofpoint-ORIG-GUID: Rc4XRtgyggpCeWmJ58vn7PszBwYVTPcl
X-Authority-Analysis: v=2.4 cv=EP02FVZC c=1 sm=1 tr=0 ts=6a814d67 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=JTYwcDXl0W004yyQ3KQA:9

KVM does not support vCPU hotplug. When a vCPU is removed, its
corresponding data structures are not freed by KVM. Instead, QEMU destroys
only the userspace state and the vCPU thread, while the KVM vCPU fd remains
open and parked in QEMU.

As a result, vcpu->arch.st.last_steal is not reset.

If the same vCPU is later re-created by QEMU, last_steal retains its old
value, while current->sched_info.run_delay starts from zero since a new
vCPU thread is created. This causes
current->sched_info.run_delay - vcpu->arch.st.last_steal to produce a
large, bogus value.

Fix this by resetting vcpu->arch.st.last_steal unconditionally to
current->sched_info.run_delay when KVM vCPU PID is changed.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 arch/x86/kvm/Kconfig | 1 +
 arch/x86/kvm/x86.c   | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 801bf9e520db..b7cb2ceda6d9 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -40,6 +40,7 @@ config KVM_X86
 	select HAVE_KVM_MSI
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
 	select HAVE_KVM_NO_POLL
+	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select VIRT_XFER_TO_GUEST_WORK
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_VFIO
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 47cb9eba113b..33be45eec32b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3717,6 +3717,13 @@ void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_service_local_tlb_flush_requests);
 
+int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.st.last_steal = current->sched_info.run_delay;
+
+	return 0;
+}
+
 static void record_steal_time(struct kvm_vcpu *vcpu)
 {
 	struct gfn_to_hva_cache *ghc = &vcpu->arch.st.cache;
-- 
2.43.5

