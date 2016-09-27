From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 28/50] arm: KVM: Add HYP async abort handler
Date: Tue, 27 Sep 2016 20:05:36 +0200
Message-ID: <20160927180558.14699-29-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E635849BB2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T1l0vuZfNAbq for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:56:54 -0400 (EDT)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 725BB49B21
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:51 -0400 (EDT)
Received: by mail-wm0-f42.google.com with SMTP id l132so26949855wmf.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:06:14 -0700 (PDT)
In-Reply-To: <20160927180558.14699-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

If we've exited the guest because it has triggered an asynchronous
abort, a possible course of action is to let it know it screwed up
by giving it a Virtual Abort to chew on.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/handle_exit.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
index 3f1ef0d..863fdf4 100644
--- a/arch/arm/kvm/handle_exit.c
+++ b/arch/arm/kvm/handle_exit.c
@@ -160,6 +160,9 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		exit_handler = kvm_get_exit_handler(vcpu);
 
 		return exit_handler(vcpu, run);
+	case ARM_EXCEPTION_DATA_ABORT:
+		kvm_inject_vabt(vcpu);
+		return 1;
 	default:
 		kvm_pr_unimpl("Unsupported exception type: %d",
 			      exception_index);
-- 
2.9.0
