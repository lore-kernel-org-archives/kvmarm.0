Return-Path: <SRS0=hjn/=55=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB0EC2BA19
	for <kvmarm@archiver.kernel.org>; Mon, 13 Apr 2020 09:10:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A7B8420731
	for <kvmarm@archiver.kernel.org>; Mon, 13 Apr 2020 09:09:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A7B8420731
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 281794B1CF;
	Mon, 13 Apr 2020 05:09:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LXGBQ2fhIyiI; Mon, 13 Apr 2020 05:09:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 591AE4B1D2;
	Mon, 13 Apr 2020 05:09:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B79EB4B0A0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 12 Apr 2020 23:45:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3HmxOZ4vZTBb for <kvmarm@lists.cs.columbia.edu>;
 Sun, 12 Apr 2020 23:45:29 -0400 (EDT)
Received: from out30-132.freemail.mail.aliyun.com
 (out30-132.freemail.mail.aliyun.com [115.124.30.132])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 59B254A51D
 for <kvmarm@lists.cs.columbia.edu>; Sun, 12 Apr 2020 23:45:29 -0400 (EDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R771e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01f04397;
 MF=tianjia.zhang@linux.alibaba.com; NM=1; PH=DS; RN=20; SR=0;
 TI=SMTPD_---0TvK0H1G_1586749524; 
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com
 fp:SMTPD_---0TvK0H1G_1586749524) by smtp.aliyun-inc.com(127.0.0.1);
 Mon, 13 Apr 2020 11:45:24 +0800
From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To: pbonzini@redhat.com, sean.j.christopherson@intel.com, vkuznets@redhat.com,
 wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, maz@kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Subject: [PATCH] KVM: Optimize kvm_arch_vcpu_ioctl_run function
Date: Mon, 13 Apr 2020 11:45:23 +0800
Message-Id: <20200413034523.110548-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
X-Mailman-Approved-At: Mon, 13 Apr 2020 05:09:56 -0400
Cc: linux-kernel@vger.kernel.org, tianjia.zhang@linux.alibaba.com,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

kvm_arch_vcpu_ioctl_run() is only called in the file kvm_main.c,
where vcpu->run is the kvm_run parameter, so it has been replaced.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 arch/x86/kvm/x86.c | 8 ++++----
 virt/kvm/arm/arm.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3bf2ecafd027..70e3f4abbd4d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8726,18 +8726,18 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		r = -EAGAIN;
 		if (signal_pending(current)) {
 			r = -EINTR;
-			vcpu->run->exit_reason = KVM_EXIT_INTR;
+			kvm_run->exit_reason = KVM_EXIT_INTR;
 			++vcpu->stat.signal_exits;
 		}
 		goto out;
 	}
 
-	if (vcpu->run->kvm_valid_regs & ~KVM_SYNC_X86_VALID_FIELDS) {
+	if (kvm_run->kvm_valid_regs & ~KVM_SYNC_X86_VALID_FIELDS) {
 		r = -EINVAL;
 		goto out;
 	}
 
-	if (vcpu->run->kvm_dirty_regs) {
+	if (kvm_run->kvm_dirty_regs) {
 		r = sync_regs(vcpu);
 		if (r != 0)
 			goto out;
@@ -8767,7 +8767,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 out:
 	kvm_put_guest_fpu(vcpu);
-	if (vcpu->run->kvm_valid_regs)
+	if (kvm_run->kvm_valid_regs)
 		store_regs(vcpu);
 	post_kvm_run_save(vcpu);
 	kvm_sigset_deactivate(vcpu);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 48d0ec44ad77..ab9d7966a4c8 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -659,7 +659,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		return ret;
 
 	if (run->exit_reason == KVM_EXIT_MMIO) {
-		ret = kvm_handle_mmio_return(vcpu, vcpu->run);
+		ret = kvm_handle_mmio_return(vcpu, run);
 		if (ret)
 			return ret;
 	}
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
