From: linucherian@gmail.com
Subject: [PATCH V2 1/2] KVM: arm/arm64: Enable KVM_CAP_NR_MEMSLOTS on arm/arm64
Date: Wed,  8 Feb 2017 12:45:40 +0530
Message-ID: <1486538141-30627-2-git-send-email-linucherian@gmail.com>
References: <1486538141-30627-1-git-send-email-linucherian@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 662C440992
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Feb 2017 02:16:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7ERS7-IBE6Ib for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Feb 2017 02:16:08 -0500 (EST)
Received: from mail-pg0-f68.google.com (mail-pg0-f68.google.com [74.125.83.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8CEF740962
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Feb 2017 02:16:08 -0500 (EST)
Received: by mail-pg0-f68.google.com with SMTP id 75so14387181pgf.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Feb 2017 23:16:41 -0800 (PST)
In-Reply-To: <1486538141-30627-1-git-send-email-linucherian@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, rkrcmar@redhat.com
Cc: sunil.goutham@cavium.com, linu.cherian@cavium.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Linu Cherian <linu.cherian@cavium.com>

Return KVM_USER_MEM_SLOTS for userspace capability query on
NR_MEMSLOTS.

Signed-off-by: Linu Cherian <linu.cherian@cavium.com>
---
 arch/arm/kvm/arm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 9d74464..b64b47f 100644
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
1.9.1
