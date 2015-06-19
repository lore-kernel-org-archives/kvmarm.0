From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 04/12] kvm: remove one useless check extension
Date: Fri, 19 Jun 2015 13:53:08 +0100
Message-ID: <1434718396-13110-5-git-send-email-marc.zyngier@arm.com>
References: <1434718396-13110-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35383561D0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jun 2015 08:43:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ArMXyyPHDbE4 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Jun 2015 08:43:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1E4E5617D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jun 2015 08:43:01 -0400 (EDT)
In-Reply-To: <1434718396-13110-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kvm@vger.kernel.org, Firo Yang <firogm@gmail.com>, linux-arm-kernel@lists.infradead.org, Andre Przywara <andre.przywara@arm.com>, Tiejun Chen <tiejun.chen@intel.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Tiejun Chen <tiejun.chen@intel.com>

We already check KVM_CAP_IRQFD in generic once enable CONFIG_HAVE_KVM_IRQFD,

kvm_vm_ioctl_check_extension_generic()
    |
    + switch (arg) {
    +   ...
    +   #ifdef CONFIG_HAVE_KVM_IRQFD
    +       case KVM_CAP_IRQFD:
    +   #endif
    +   ...
    +   return 1;
    +   ...
    + }
    |
    + kvm_vm_ioctl_check_extension()

So its not necessary to check this in arch again, and also fix one typo,
s/emlation/emulation.

Signed-off-by: Tiejun Chen <tiejun.chen@intel.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/arm.c       | 1 -
 include/uapi/linux/kvm.h | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index e41cb11..7e82330 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -171,7 +171,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	int r;
 	switch (ext) {
 	case KVM_CAP_IRQCHIP:
-	case KVM_CAP_IRQFD:
 	case KVM_CAP_IOEVENTFD:
 	case KVM_CAP_DEVICE_CTRL:
 	case KVM_CAP_USER_MEMORY:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 75bd9f7..cbfd1ac 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -895,7 +895,7 @@ struct kvm_xen_hvm_config {
  *
  * KVM_IRQFD_FLAG_RESAMPLE indicates resamplefd is valid and specifies
  * the irqfd to operate in resampling mode for level triggered interrupt
- * emlation.  See Documentation/virtual/kvm/api.txt.
+ * emulation.  See Documentation/virtual/kvm/api.txt.
  */
 #define KVM_IRQFD_FLAG_RESAMPLE (1 << 1)
 
-- 
2.1.4
