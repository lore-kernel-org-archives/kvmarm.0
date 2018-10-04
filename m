From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: kernel BUG at arch/arm/kvm/coproc.c:1406!
Date: Thu, 4 Oct 2018 09:19:45 +0100
Message-ID: <3d719d5f-d7b9-9bba-4fa8-61175a9b05a9@arm.com>
References: <6b134030-f9a4-1983-caac-5cfcc2be9776@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6b134030-f9a4-1983-caac-5cfcc2be9776@gmail.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Fainelli <f.fainelli@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kvmarm@lists.cs.columbia.edu, linux ARM <linux-arm-kernel@lists.infradead.org>, Russell King <linux@armlinux.org.uk>, christoffer.dall@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Florian,

On 04/10/18 04:02, Florian Fainelli wrote:
> Hi,
> 
> Seeing the following BUG_ON() being triggered on a Lamobo R1
> (SUN7I/Cortex-A7), did not have the time to run a bisection since I was
> chasing another regression. My guess would be that
> 3e8a8a50c7ef1a4f71921731f0e1748a7f70ddaa ("KVM: arm: vgic-v3: Add
> support for ICC_SGI0R and ICC_ASGI1R accesses") is the culprit since it
> does add new entries to cp15_regs[].

OK, this is quite embarrassing. I remember fixing that exact bug before
the 4.19 merge window, and was 100% convinced that I had merged the fix.

Turns out I didn't. 

Can you verify that the following patch works for you?

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
 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
