From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 30/31] MAINTAINERS: add git URL for KVM/ARM
Date: Thu, 24 Dec 2015 11:12:38 +0000
Message-ID: <1450955559-15639-31-git-send-email-marc.zyngier@arm.com>
References: <1450955559-15639-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A487341145
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Dec 2015 06:12:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2HsK4i1wZ7nC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Dec 2015 06:12:34 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A630498A3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Dec 2015 06:12:34 -0500 (EST)
In-Reply-To: <1450955559-15639-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jisheng Zhang <jszhang@marvell.com>, kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, David Binderman <dcb314@hotmail.com>, Fengguang Wu <fengguang.wu@intel.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Fengguang Wu <fengguang.wu@intel.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9bff63c..8e92b45 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6102,6 +6102,7 @@ M:	Marc Zyngier <marc.zyngier@arm.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	kvmarm@lists.cs.columbia.edu
 W:	http://systems.cs.columbia.edu/projects/kvm-arm
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git
 S:	Supported
 F:	arch/arm/include/uapi/asm/kvm*
 F:	arch/arm/include/asm/kvm*
-- 
2.1.4
