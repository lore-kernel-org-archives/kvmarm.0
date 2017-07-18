From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 05/38] KVM: arm64: Allow userspace to set PSR_MODE_EL2x
Date: Tue, 18 Jul 2017 11:58:31 -0500
Message-ID: <1500397144-16232-6-git-send-email-jintack.lim@linaro.org>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04E9449C13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:58:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pUGgXaE+Qumz for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 12:58:55 -0400 (EDT)
Received: from mail-it0-f53.google.com (mail-it0-f53.google.com
 [209.85.214.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 410D149C07
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:58:54 -0400 (EDT)
Received: by mail-it0-f53.google.com with SMTP id 188so16941164itx.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 09:59:43 -0700 (PDT)
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

From: Christoffer Dall <christoffer.dall@linaro.org>

We were not allowing userspace to set a more privileged mode for the VCPU
than EL1, but now that we support nesting with a virtual EL2 mode, do
allow this!

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/guest.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 5c7f657..5e673ae 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -117,6 +117,8 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		case PSR_MODE_EL0t:
 		case PSR_MODE_EL1t:
 		case PSR_MODE_EL1h:
+		case PSR_MODE_EL2h:
+		case PSR_MODE_EL2t:
 			break;
 		default:
 			err = -EINVAL;
-- 
1.9.1
