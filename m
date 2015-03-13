From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 04/12] KVM: x86: remove now unneeded include directory from
 Makefile
Date: Fri, 13 Mar 2015 16:10:04 +0000
Message-ID: <1426263012-22935-5-git-send-email-andre.przywara@arm.com>
References: <1426263012-22935-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6FAD48C40
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Mar 2015 12:03:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lSzsu6-J1c9G for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Mar 2015 12:03:49 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 58C0948C35
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Mar 2015 12:03:48 -0400 (EDT)
In-Reply-To: <1426263012-22935-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, pbonzini@redhat.com
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

virt/kvm was never really a good include directory for anything else
than locally included headers.
With the move of iodev.h there is no need anymore to add this
directory the compiler's include path, so remove it from the x86 kvm
Makefile.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arch/x86/kvm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 08f790d..16e8f96 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -1,5 +1,5 @@
 
-ccflags-y += -Ivirt/kvm -Iarch/x86/kvm
+ccflags-y += -Iarch/x86/kvm
 
 CFLAGS_x86.o := -I.
 CFLAGS_svm.o := -I.
-- 
1.7.9.5
