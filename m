From: wanghaibin <wanghaibin.wang@huawei.com>
Subject: [PATCH 4/4] kvm: arm/arm64: vgic: clean up vGICv3 ICC_APRn sysreg
 uaccess
Date: Wed, 5 Jul 2017 19:23:29 +0800
Message-ID: <1499253809-17584-5-git-send-email-wanghaibin.wang@huawei.com>
References: <1499253809-17584-1-git-send-email-wanghaibin.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78EB640D8B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jul 2017 07:23:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AZ9cHpCfFKvB for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jul 2017 07:23:58 -0400 (EDT)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4ABF940CA7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jul 2017 07:23:56 -0400 (EDT)
In-Reply-To: <1499253809-17584-1-git-send-email-wanghaibin.wang@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: cdall@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
Cc: wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

The vGICv3 ICC_APRn sysreg uaccess should call the APR access common
interface.

Signed-off-by: wanghaibin <wanghaibin.wang@huawei.com>
---
 arch/arm64/kvm/vgic-sys-reg-v3.c | 25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
index 6260b69..0f7fbcd 100644
--- a/arch/arm64/kvm/vgic-sys-reg-v3.c
+++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
@@ -188,23 +188,6 @@ static bool access_gic_grpen1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
-static void vgic_v3_access_apr_reg(struct kvm_vcpu *vcpu,
-				   struct sys_reg_params *p, u8 apr, u8 idx)
-{
-	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
-	uint32_t *ap_reg;
-
-	if (apr)
-		ap_reg = &vgicv3->vgic_ap1r[idx];
-	else
-		ap_reg = &vgicv3->vgic_ap0r[idx];
-
-	if (p->is_write)
-		*ap_reg = p->regval;
-	else
-		p->regval = *ap_reg;
-}
-
 static bool access_gic_aprn(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			    const struct sys_reg_desc *r, u8 apr)
 {
@@ -218,19 +201,21 @@ static bool access_gic_aprn(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	 */
 	switch (vgic_v3_cpu->num_pri_bits) {
 	case 7:
-		vgic_v3_access_apr_reg(vcpu, p, apr, idx);
 		break;
 	case 6:
 		if (idx > 1)
 			goto err;
-		vgic_v3_access_apr_reg(vcpu, p, apr, idx);
 		break;
 	default:
 		if (idx > 0)
 			goto err;
-		vgic_v3_access_apr_reg(vcpu, p, apr, idx);
 	}
 
+	if (p->is_write)
+		vgic_set_apr(vcpu, apr, idx, p->regval);
+	else
+		p->regval = vgic_get_apr(vcpu, apr, idx);
+
 	return true;
 err:
 	if (!p->is_write)
-- 
1.8.3.1
