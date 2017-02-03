From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v2 5/5] KVM: arm/arm64: Advertise support for
 KVM_CAP_ARM_USER_IRQ
Date: Fri,  3 Feb 2017 15:56:55 +0100
Message-ID: <20170203145655.15007-6-cdall@linaro.org>
References: <20170203145655.15007-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9203140A3C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Feb 2017 09:56:44 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SyS0csBHlrZe for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Feb 2017 09:56:42 -0500 (EST)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 77CF340A7E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Feb 2017 09:56:40 -0500 (EST)
Received: by mail-wm0-f52.google.com with SMTP id c85so32684592wmi.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Feb 2017 06:57:05 -0800 (PST)
In-Reply-To: <20170203145655.15007-1-cdall@linaro.org>
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
index 92f38f6..71cf78e 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -226,6 +226,13 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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
