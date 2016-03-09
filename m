From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 79/95] ARM: KVM: Properly sort the invariant table
Date: Wed,  9 Mar 2016 07:31:13 +0000
Message-ID: <1457508689-19672-80-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C76D0412A6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:35:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EL+7qicq49xr for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:35:30 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9443A49BB8
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:35:30 -0500 (EST)
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Not having the invariant table properly sorted is an oddity, and
may get in the way of future optimisations. Let's fix it.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/coproc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index e3e86c4..9aa462e 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -645,6 +645,9 @@ static struct coproc_reg invariant_cp15[] = {
 	{ CRn( 0), CRm( 0), Op1( 0), Op2( 3), is32, NULL, get_TLBTR },
 	{ CRn( 0), CRm( 0), Op1( 0), Op2( 6), is32, NULL, get_REVIDR },
 
+	{ CRn( 0), CRm( 0), Op1( 1), Op2( 1), is32, NULL, get_CLIDR },
+	{ CRn( 0), CRm( 0), Op1( 1), Op2( 7), is32, NULL, get_AIDR },
+
 	{ CRn( 0), CRm( 1), Op1( 0), Op2( 0), is32, NULL, get_ID_PFR0 },
 	{ CRn( 0), CRm( 1), Op1( 0), Op2( 1), is32, NULL, get_ID_PFR1 },
 	{ CRn( 0), CRm( 1), Op1( 0), Op2( 2), is32, NULL, get_ID_DFR0 },
@@ -660,9 +663,6 @@ static struct coproc_reg invariant_cp15[] = {
 	{ CRn( 0), CRm( 2), Op1( 0), Op2( 3), is32, NULL, get_ID_ISAR3 },
 	{ CRn( 0), CRm( 2), Op1( 0), Op2( 4), is32, NULL, get_ID_ISAR4 },
 	{ CRn( 0), CRm( 2), Op1( 0), Op2( 5), is32, NULL, get_ID_ISAR5 },
-
-	{ CRn( 0), CRm( 0), Op1( 1), Op2( 1), is32, NULL, get_CLIDR },
-	{ CRn( 0), CRm( 0), Op1( 1), Op2( 7), is32, NULL, get_AIDR },
 };
 
 /*
-- 
2.1.4
