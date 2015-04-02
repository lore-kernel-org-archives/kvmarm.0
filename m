From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 19/27] KVM: x86: remove now unneeded include directory from Makefile
Date: Thu,  2 Apr 2015 11:05:23 +0100
Message-ID: <1427969131-8445-20-git-send-email-marc.zyngier@arm.com>
References: <1427969131-8445-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1427969131-8445-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

virt/kvm was never really a good include directory for anything else
than locally included headers.
With the move of iodev.h there is no need anymore to add this
directory the compiler's include path, so remove it from the x86 kvm
Makefile.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/x86/kvm/Makefile | 2 +-
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
2.1.4

