From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH for-4.5] arm/kvm: fix ioctl error handling
Date: Sun, 28 Feb 2016 17:32:07 +0200
Message-ID: <1456673397-23625-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 451F74852C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Feb 2016 10:25:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yv-O09vtNpmt for <kvmarm@lists.cs.columbia.edu>;
 Sun, 28 Feb 2016 10:25:15 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0AC1C419D1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Feb 2016 10:25:14 -0500 (EST)
Content-Disposition: inline
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Dan Carpenter <dan.carpenter@oracle.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Calling return copy_to_user(...) in an ioctl will not
do the right thing if there's a pagefault:
copy_to_user returns the number of bytes not copied
in this case.

Fix up kvm to do
	return copy_to_user(...)) ?  -EFAULT : 0;

everywhere.

Cc: stable@vger.kernel.org
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Compiled only.

 arch/arm/kvm/guest.c   | 2 +-
 arch/arm64/kvm/guest.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
index 5fa69d7..99361f1 100644
--- a/arch/arm/kvm/guest.c
+++ b/arch/arm/kvm/guest.c
@@ -161,7 +161,7 @@ static int get_timer_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	u64 val;
 
 	val = kvm_arm_timer_get_reg(vcpu, reg->id);
-	return copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id));
+	return copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)) ? -EFAULT : 0;
 }
 
 static unsigned long num_core_regs(void)
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index fcb7788..9e54ad7 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -194,7 +194,7 @@ static int get_timer_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	u64 val;
 
 	val = kvm_arm_timer_get_reg(vcpu, reg->id);
-	return copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id));
+	return copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)) ? -EFAULT : 0;
 }
 
 /**
-- 
MST
