From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/1] ARM: KVM: Correctly order SGI register entries in the
 cp15 array
Date: Tue,  9 Oct 2018 13:26:11 +0100
Message-ID: <20181009122611.85534-2-marc.zyngier@arm.com>
References: <20181009122611.85534-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A0CE4A2B2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Oct 2018 08:26:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XMB61QL4iZ4J for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Oct 2018 08:26:24 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C9A14A1DC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Oct 2018 08:26:24 -0400 (EDT)
In-Reply-To: <20181009122611.85534-1-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The ICC_ASGI1R and ICC_SGI0R register entries in the cp15 array
are not correctly ordered, leading to a BUG() at boot time.

Move them to their natural location.

Fixes: 3e8a8a50c7ef ("KVM: arm: vgic-v3: Add support for ICC_SGI0R and ICC_ASGI1R accesses")
Reported-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
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
2.19.1
