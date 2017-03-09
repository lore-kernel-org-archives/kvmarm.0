From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 08/10] KVM: arm/arm64: Enable KVM_CAP_NR_MEMSLOTS on arm/arm64
Date: Thu,  9 Mar 2017 09:55:37 +0000
Message-ID: <20170309095539.14512-9-marc.zyngier@arm.com>
References: <20170309095539.14512-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EEB9E40A42
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 04:55:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pOvkpbH2jvEi for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Mar 2017 04:55:16 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D8EB40625
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 04:55:16 -0500 (EST)
In-Reply-To: <20170309095539.14512-1-marc.zyngier@arm.com>
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
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Linu Cherian <linu.cherian@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Linu Cherian <linu.cherian@cavium.com>

Return KVM_USER_MEM_SLOTS for userspace capability query on
NR_MEMSLOTS.

Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Linu Cherian <linu.cherian@cavium.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/arm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index c9a2103faeb9..96dba7cd8be7 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -221,6 +221,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;
 		break;
+	case KVM_CAP_NR_MEMSLOTS:
+		r = KVM_USER_MEM_SLOTS;
+		break;
 	case KVM_CAP_MSI_DEVID:
 		if (!kvm)
 			r = -EINVAL;
-- 
2.11.0
