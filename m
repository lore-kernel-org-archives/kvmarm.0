From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] ARM: KVM: Correctly order SGI register entries in the cp15
 array
Date: Thu,  4 Oct 2018 10:29:46 +0100
Message-ID: <20181004092946.59836-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 899774A1D7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Oct 2018 05:30:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pYo8esUXQmhE for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Oct 2018 05:30:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56C8D40A6E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Oct 2018 05:30:00 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, Florian Fainelli <f.fainelli@gmail.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The ICC_ASGI1R and ICC_SGI0R register entries in the cp15 array
are not correctly ordered, leading to a BUG() at boot time.

Move them to their natural location.

Fixes: 3e8a8a50c7ef ("KVM: arm: vgic-v3: Add support for ICC_SGI0R and ICC_ASGI1R accesses")
Reported-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
Paolo, Radim,

Could you please send this patch directly to Greg so that it makes it
into 4.19? I thought I had it fixed long before the merge window, and
obviously didn't...

Thanks,

	M.

 arch/arm/kvm/coproc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index 450c7a4fbc8a..cb094e55dc5f 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -478,15 +478,15 @@ static const struct coproc_reg cp15_regs[] = {
 
 	/* ICC_SGI1R */
 	{ CRm64(12), Op1( 0), is64, access_gic_sgi},
-	/* ICC_ASGI1R */
-	{ CRm64(12), Op1( 1), is64, access_gic_sgi},
-	/* ICC_SGI0R */
-	{ CRm64(12), Op1( 2), is64, access_gic_sgi},
 
 	/* VBAR: swapped by interrupt.S. */
 	{ CRn(12), CRm( 0), Op1( 0), Op2( 0), is32,
 			NULL, reset_val, c12_VBAR, 0x00000000 },
 
+	/* ICC_ASGI1R */
+	{ CRm64(12), Op1( 1), is64, access_gic_sgi},
+	/* ICC_SGI0R */
+	{ CRm64(12), Op1( 2), is64, access_gic_sgi},
 	/* ICC_SRE */
 	{ CRn(12), CRm(12), Op1( 0), Op2(5), is32, access_gic_sre },
 
-- 
2.19.0
