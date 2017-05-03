From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH v3 05/10] KVM: arm/arm64: don't clear exit request from caller
Date: Wed,  3 May 2017 18:06:30 +0200
Message-ID: <20170503160635.21669-6-drjones@redhat.com>
References: <20170503160635.21669-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB02140C2F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 12:03:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id If2ys52IDaKT for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 May 2017 12:03:46 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0233340B5B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 12:03:46 -0400 (EDT)
In-Reply-To: <20170503160635.21669-1-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: marc.zyngier@arm.com, cdall@linaro.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

VCPU requests that the receiver should handle should only be cleared
by the receiver. Not only does this properly implement the protocol,
but also avoids bugs where one VCPU clears another VCPU's request,
before the receiving VCPU has had a chance to see it.  ARM VCPUs
currently only handle one request, EXIT, and handling it is achieved
by checking pause to see if the VCPU should sleep.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm/kvm/arm.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 9174ed13135a..7be0d9b0c63a 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -553,7 +553,6 @@ void kvm_arm_resume_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
 
-	kvm_clear_request(KVM_REQ_VCPU_EXIT, vcpu);
 	vcpu->arch.pause = false;
 	swake_up(wq);
 }
@@ -625,7 +624,14 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 		update_vttbr(vcpu->kvm);
 
-		if (vcpu->arch.power_off || vcpu->arch.pause)
+		if (kvm_request_pending(vcpu)) {
+			if (kvm_check_request(KVM_REQ_VCPU_EXIT, vcpu)) {
+				if (vcpu->arch.pause)
+					vcpu_sleep(vcpu);
+			}
+		}
+
+		if (vcpu->arch.power_off)
 			vcpu_sleep(vcpu);
 
 		/*
-- 
2.9.3
