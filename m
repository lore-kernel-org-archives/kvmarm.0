From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 74/79] KVM: arm/arm64: Advertise support for
 KVM_CAP_ARM_USER_IRQ
Date: Sun, 23 Apr 2017 19:09:24 +0200
Message-ID: <20170423170929.27334-75-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFE9949DAF
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:08:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8FGvfioaa5yL for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:08:07 -0400 (EDT)
Received: from mail-wr0-f174.google.com (mail-wr0-f174.google.com
 [209.85.128.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 18F5049D8C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:08:05 -0400 (EDT)
Received: by mail-wr0-f174.google.com with SMTP id w50so55839784wrc.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:10:51 -0700 (PDT)
In-Reply-To: <20170423170929.27334-1-cdall@linaro.org>
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

From: Christoffer Dall <christoffer.dall@linaro.org>

Now that we support both timers and PMU reporting interrupts
to userspace, we can advertise this support.

Reviewed-by: Alexander Graf <agraf@suse.de>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/arm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 9eda293..7941699 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -229,6 +229,13 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		else
 			r = kvm->arch.vgic.msis_require_devid;
 		break;
+	case KVM_CAP_ARM_USER_IRQ:
+		/*
+		 * 1: EL1_VTIMER, EL1_PTIMER, and PMU.
+		 * (bump this number if adding more devices)
+		 */
+		r = 1;
+		break;
 	default:
 		r = kvm_arch_dev_ioctl_check_extension(kvm, ext);
 		break;
-- 
2.9.0
