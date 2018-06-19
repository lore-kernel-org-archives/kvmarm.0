From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 2/2] KVM: arm64: Prevent KVM_COMPAT from being selected
Date: Tue, 19 Jun 2018 10:42:51 +0100
Message-ID: <20180619094251.8586-3-marc.zyngier@arm.com>
References: <20180619094251.8586-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180619094251.8586-1-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Christoffer Dall <christoffer.dall@arm.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

There is very little point in trying to support the 32bit KVM/arm API
on arm64, and this was never an anticipated use case.

Let's make it clear by not selecting KVM_COMPAT.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 72143cfaf6ec..ea434ddc8499 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -47,7 +47,7 @@ config KVM_GENERIC_DIRTYLOG_READ_PROTECT
 
 config KVM_COMPAT
        def_bool y
-       depends on KVM && COMPAT && !S390
+       depends on KVM && COMPAT && !(S390 || ARM64)
 
 config HAVE_KVM_IRQ_BYPASS
        bool
-- 
2.17.1
