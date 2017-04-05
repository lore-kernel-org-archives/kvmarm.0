From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v3 5/5] KVM: arm/arm64: Advertise support for
 KVM_CAP_ARM_USER_IRQ
Date: Wed,  5 Apr 2017 11:28:15 +0200
Message-ID: <20170405092815.22503-6-cdall@linaro.org>
References: <20170405092815.22503-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFA6940BC4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Apr 2017 05:26:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uLqeCIEyUV8F for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Apr 2017 05:26:08 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DAFA240430
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Apr 2017 05:26:07 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id o81so44972502wmb.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Apr 2017 02:28:21 -0700 (PDT)
In-Reply-To: <20170405092815.22503-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Pekka Enberg <penberg@iki.fi>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Now when we support both the virtual timer and PMU reporting interrupts
to userspace, we can advertise this support.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/arm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index f935383..b420aa9 100644
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
