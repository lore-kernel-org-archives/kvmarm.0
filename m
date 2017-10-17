From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 06/11] KVM: arm/arm64: vgic-its: Check GITS_CBASER validity
 before processing commands
Date: Tue, 17 Oct 2017 09:10:04 +0200
Message-ID: <1508224209-15366-7-git-send-email-eric.auger@redhat.com>
References: <1508224209-15366-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC1F240795
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 03:09:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QnOKrPMUlVMX for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Oct 2017 03:09:54 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D616949D54
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 03:09:53 -0400 (EDT)
In-Reply-To: <1508224209-15366-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@linaro.org, peter.maydell@linaro.org, andre.przywara@arm.com, wanghaibin.wang@huawei.com
Cc: wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

At the moment vgic_its_process_commands() does not
check the CBASER is valid before processing any command.
Let's fix that.

Also rename cbaser local variable into cbaser_pa to avoid
any confusion with the full register.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 3b539d4..e18f1e4 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1301,17 +1301,20 @@ static void vgic_mmio_write_its_cbaser(struct kvm *kvm, struct vgic_its *its,
 /* Must be called with the cmd_lock held. */
 static void vgic_its_process_commands(struct kvm *kvm, struct vgic_its *its)
 {
-	gpa_t cbaser;
+	gpa_t cbaser_pa;
 	u64 cmd_buf[4];
 
-	/* Commands are only processed when the ITS is enabled. */
-	if (!its->enabled)
+	/*
+	 * Commands are only processed when the ITS is enabled and
+	 * CBASER is valid
+	 */
+	if (!its->enabled || (!(its->cbaser & GITS_CBASER_VALID)))
 		return;
 
-	cbaser = CBASER_ADDRESS(its->cbaser);
+	cbaser_pa = CBASER_ADDRESS(its->cbaser);
 
 	while (its->cwriter != its->creadr) {
-		int ret = kvm_read_guest(kvm, cbaser + its->creadr,
+		int ret = kvm_read_guest(kvm, cbaser_pa + its->creadr,
 					 cmd_buf, ITS_CMD_SIZE);
 		/*
 		 * If kvm_read_guest() fails, this could be due to the guest
-- 
2.5.5
