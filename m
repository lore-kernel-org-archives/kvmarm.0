From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 3/5] arm64: KVM: Demote SVE and LORegion warnings to debug only
Date: Fri, 20 Apr 2018 17:07:11 +0100
Message-ID: <20180420160713.17884-4-marc.zyngier@arm.com>
References: <20180420160713.17884-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180420160713.17884-1-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Stefano Stabellini <sstabellini@kernel.org>, Christoffer Dall <cdall@kernel.org>, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

While generating a message about guests probing for SVE/LORegions
is a useful debugging tool, considering it an error is slightly
over the top, as this is the only way the guest can find out
about the presence of the feature.

Let's turn these message into kvm_debug so that they can only
be seen if CONFIG_DYNAMIC_DEBUG, and kept quiet otherwise.

Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 806b0b126a64..6e3b969391fd 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -996,14 +996,12 @@ static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
 
 	if (id == SYS_ID_AA64PFR0_EL1) {
 		if (val & (0xfUL << ID_AA64PFR0_SVE_SHIFT))
-			pr_err_once("kvm [%i]: SVE unsupported for guests, suppressing\n",
-				    task_pid_nr(current));
+			kvm_debug("SVE unsupported for guests, suppressing\n");
 
 		val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
 	} else if (id == SYS_ID_AA64MMFR1_EL1) {
 		if (val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))
-			pr_err_once("kvm [%i]: LORegions unsupported for guests, suppressing\n",
-				    task_pid_nr(current));
+			kvm_debug("LORegions unsupported for guests, suppressing\n");
 
 		val &= ~(0xfUL << ID_AA64MMFR1_LOR_SHIFT);
 	}
-- 
2.14.2
