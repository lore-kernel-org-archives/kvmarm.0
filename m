From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 23/38] KVM: arm64: Inject HVC exceptions to the virtual
 EL2
Date: Tue, 18 Jul 2017 11:58:49 -0500
Message-ID: <1500397144-16232-24-git-send-email-jintack.lim@linaro.org>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0192340D14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZXWic8881mFI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 12:59:26 -0400 (EDT)
Received: from mail-it0-f41.google.com (mail-it0-f41.google.com
 [209.85.214.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 29F9C49C52
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:26 -0400 (EDT)
Received: by mail-it0-f41.google.com with SMTP id h199so12465417ith.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 10:00:15 -0700 (PDT)
In-Reply-To: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, david.daney@cavium.com, catalin.marinas@arm.com, will.deacon@arm.com, stefan@hello-penguin.com, corbet@lwn.net, daniel.lezcano@linaro.org, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, andy.gross@linaro.org, cov@codeaurora.org, wcohen@redhat.com, mchehab@kernel.org, ard.biesheuvel@linaro.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, akpm@linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

Now that the psci call is done by the smc instruction when nested
virtualization is enabled, it is clear that all hvc instruction from the
VM (including from the virtual EL2) are supposed to handled in the
virtual EL2.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/kvm/handle_exit.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 6cf6b93..8b398b2 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -42,6 +42,12 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 			    kvm_vcpu_hvc_get_imm(vcpu));
 	vcpu->stat.hvc_exit_stat++;
 
+	/* Forward hvc instructions to the virtual EL2 if the guest has EL2. */
+	if (nested_virt_in_use(vcpu)) {
+		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
+		return 1;
+	}
+
 	ret = kvm_psci_call(vcpu);
 	if (ret < 0) {
 		kvm_inject_undefined(vcpu);
-- 
1.9.1
