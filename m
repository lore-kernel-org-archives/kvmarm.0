From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [GIT PULL 2/6] KVM: arm/arm64: Fix memory leak if timer
 initialization fails
Date: Tue, 20 Oct 2015 18:19:03 +0200
Message-ID: <1445357947-6022-3-git-send-email-christoffer.dall@linaro.org>
References: <1445357947-6022-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E46D48A23
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Oct 2015 12:16:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QgFSwhcIm02E for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Oct 2015 12:16:07 -0400 (EDT)
Received: from mail-lf0-f48.google.com (mail-lf0-f48.google.com
 [209.85.215.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7164A48A2D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Oct 2015 12:16:07 -0400 (EDT)
Received: by lffy185 with SMTP id y185so8444718lff.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Oct 2015 09:18:39 -0700 (PDT)
In-Reply-To: <1445357947-6022-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Pavel Fedin <p.fedin@samsung.com>

Jump to correct label and free kvm_host_cpu_state

Reviewed-by: Wei Huang <wei@redhat.com>
Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index dc017ad..78b2869 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -1080,7 +1080,7 @@ static int init_hyp_mode(void)
 	 */
 	err = kvm_timer_hyp_init();
 	if (err)
-		goto out_free_mappings;
+		goto out_free_context;
 
 #ifndef CONFIG_HOTPLUG_CPU
 	free_boot_hyp_pgd();
-- 
2.1.2.330.g565301e.dirty
