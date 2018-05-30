From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 2/6] arm64: KVM: Handle Set/Way CMOs as NOPs if FWB is
 present
Date: Wed, 30 May 2018 13:47:02 +0100
Message-ID: <20180530124706.25284-3-marc.zyngier@arm.com>
References: <20180530124706.25284-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180530124706.25284-1-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Set/Way handling is one of the ugliest corners of KVM. We shouldn't
have to handle that, but better safe than sorry.

Thankfully, FWB fixes this for us by not requiering any maintenance
whatsoever, which means we don't have to emulate S/W CMOs, and don't
have to track VM ops either.

We still have to trap S/W though, if only to prevent the guest from
doing something bad.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6e3b969391fd..9a740f159245 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -195,7 +195,13 @@ static bool access_dcsw(struct kvm_vcpu *vcpu,
 	if (!p->is_write)
 		return read_from_write_only(vcpu, p, r);
 
-	kvm_set_way_flush(vcpu);
+	/*
+	 * Only track S/W ops if we don't have FWB. It still indicates
+	 * that the guest is a bit broken...
+	 */
+	if (!cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
+		kvm_set_way_flush(vcpu);
+
 	return true;
 }
 
-- 
2.17.1
