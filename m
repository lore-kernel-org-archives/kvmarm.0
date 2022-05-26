Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18C00C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 27 May 2022 07:33:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C59B4B288;
	Fri, 27 May 2022 03:33:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@quicinc.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 31yWLEGxYPGd; Fri, 27 May 2022 03:33:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF3054B356;
	Fri, 27 May 2022 03:32:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB8C949EED
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 May 2022 16:40:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yHlp7DTRrB1N for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 May 2022 16:40:38 -0400 (EDT)
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 61DF149EE8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 May 2022 16:40:38 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
 t=1653597638; x=1685133638;
 h=from:to:cc:subject:date:message-id:mime-version:
 content-transfer-encoding;
 bh=IJdm9DSkjzkpq4cQM5uzeP+0z5TWT/S2S0U1NnQ9ajs=;
 b=F4MNAOpBLyh9CE9Cy0xgHFfXj2lR/adgNWywjyrhah6G31noHL7oiPP7
 QixVEk1oLjlnTmuA1+bR++HMTIG3B7RlJlcuo4mLPAPaOZ4uEHq0q/xAf
 kHPPaamtgRE1G+gBKc5bmYw5jiNY24fHxprZOImt4l+CvrinjDHlAbqeI g=;
Received: from ironmsg08-lv.qualcomm.com ([10.47.202.152])
 by alexa-out.qualcomm.com with ESMTP; 26 May 2022 13:40:37 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
 by ironmsg08-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 26 May 2022 13:40:36 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Thu, 26 May 2022 13:40:36 -0700
Received: from ubuntu.qualcomm.com (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 26 May
 2022 13:40:34 -0700
From: Qian Cai <quic_qiancai@quicinc.com>
To: Marc Zyngier <maz@kernel.org>
Subject: [PATCH] KVM: arm64: Fix memory leaks from stage2 pagetable
Date: Thu, 26 May 2022 16:39:56 -0400
Message-ID: <20220526203956.143873-1-quic_qiancai@quicinc.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Mailman-Approved-At: Fri, 27 May 2022 03:32:58 -0400
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Qian Cai <quic_qiancai@quicinc.com>, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Running some SR-IOV workloads could trigger some leak reports from
kmemleak.

unreferenced object 0xffff080243cef500 (size 128):
  comm "qemu-system-aar", pid 179935, jiffies 4298359506 (age 1629.732s)
  hex dump (first 32 bytes):
    28 00 00 00 01 00 00 00 00 e0 4c 52 03 08 ff ff  (.........LR....
    e0 af a4 7f 7c d1 ff ff a8 3c b3 08 00 80 ff ff  ....|....<......
  backtrace:
     kmem_cache_alloc_trace
     kvm_init_stage2_mmu
     kvm_arch_init_vm
     kvm_create_vm
     kvm_dev_ioctl
     __arm64_sys_ioctl
     invoke_syscall
     el0_svc_common.constprop.0
     do_el0_svc
     el0_svc
     el0t_64_sync_handler
     el0t_64_sync

Since I yet to find a way to reproduce this at will, I just did a code
inspection and found this one spot that could happen. It is unlikely
that will fix my issue because I don't see mine went into the error
paths. But, we should fix it regardless.

If hardware_enable_all() or kvm_init_mmu_notifier() failed in
kvm_create_vm(), we ended up leaking stage2 pagetable memory from
kvm_init_stage2_mmu() because we will no longer call
kvm_arch_flush_shadow_all().

It seems that it is impossible to simply move kvm_free_stage2_pgd() from
kvm_arch_flush_shadow_all() into kvm_arch_destroy_vm() due to the issue
mentioned in the "Fixes" commit below. Thus, fixed it by freeing the
memory from kvm_arch_destroy_vm() only if the MMU notifier is not even
initialized.

Fixes: 293f293637b5 ("kvm-arm: Unmap shadow pagetables properly")
Signed-off-by: Qian Cai <quic_qiancai@quicinc.com>
---
 arch/arm64/kvm/arm.c | 3 +++
 arch/arm64/kvm/mmu.c | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 400bb0fe2745..7d12824f2034 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -180,6 +180,9 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
  */
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
+	if (!kvm->mmu_notifier.ops)
+		kvm_free_stage2_pgd(&kvm->arch.mmu);
+
 	bitmap_free(kvm->arch.pmu_filter);
 	free_cpumask_var(kvm->arch.supported_cpus);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index f5651a05b6a8..13a527656ba7 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1739,7 +1739,8 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	kvm_free_stage2_pgd(&kvm->arch.mmu);
+	if (kvm->mmu_notifier.ops)
+		kvm_free_stage2_pgd(&kvm->arch.mmu);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
-- 
2.32.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
