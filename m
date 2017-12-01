From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 10/37] KVM: arm64: Slightly improve debug save/restore
 functions
Date: Fri, 1 Dec 2017 16:19:38 +0100
Message-ID: <20171201151938.GA6615@lvm>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-11-christoffer.dall@linaro.org>
 <e9b8d6b8-6dfa-3e6d-6e8f-c16a1882651f@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 45AC549D19
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Dec 2017 10:16:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MstbOqQBCApn for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Dec 2017 10:16:53 -0500 (EST)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CFEFB40D25
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Dec 2017 10:16:52 -0500 (EST)
Received: by mail-wm0-f65.google.com with SMTP id n138so4136113wmg.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Dec 2017 07:19:52 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <e9b8d6b8-6dfa-3e6d-6e8f-c16a1882651f@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Thierry <julien.thierry@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Julien,

On Tue, Nov 14, 2017 at 04:42:13PM +0000, Julien Thierry wrote:
> On 12/10/17 11:41, Christoffer Dall wrote:
> >The debug save/restore functions can be improved by using the has_vhe()
> >static key instead of the instruction alternative.  Using the static key
> >uses the same paradigm as we're going to use elsewhere, it makes the
> >code more readable, and it generates slightly better code (no
> >stack setups and function calls unless necessary).
> >
> >We also use a static key on the restore path, because it will be
> >marginally faster than loading a value from memory.
> >
> >Finally, we don't have to conditionally clear the debug dirty flag if
> >it's set, we can just clear it.
> >
> >Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >---
> >  arch/arm64/kvm/hyp/debug-sr.c | 22 +++++++++-------------
> >  1 file changed, 9 insertions(+), 13 deletions(-)
> >
> >diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
> >index 0fc0758..a2291b6 100644
> >--- a/arch/arm64/kvm/hyp/debug-sr.c
> >+++ b/arch/arm64/kvm/hyp/debug-sr.c
> >@@ -75,11 +75,6 @@
> >  #define psb_csync()		asm volatile("hint #17")
> >-static void __hyp_text __debug_save_spe_vhe(u64 *pmscr_el1)
> >-{
> >-	/* The vcpu can run. but it can't hide. */
> >-}
> >-
> >  static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
> >  {
> >  	u64 reg;
> >@@ -109,10 +104,6 @@ static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
> >  	dsb(nsh);
> >  }
> >-static hyp_alternate_select(__debug_save_spe,
> >-			    __debug_save_spe_nvhe, __debug_save_spe_vhe,
> >-			    ARM64_HAS_VIRT_HOST_EXTN);
> >-
> >  static void __hyp_text __debug_restore_spe(u64 pmscr_el1)
> >  {
> >  	if (!pmscr_el1)
> >@@ -174,17 +165,22 @@ void __hyp_text __debug_cond_save_host_state(struct kvm_vcpu *vcpu)
> >  {
> >  	__debug_save_state(vcpu, &vcpu->arch.host_debug_state.regs,
> >  			   kern_hyp_va(vcpu->arch.host_cpu_context));
> >-	__debug_save_spe()(&vcpu->arch.host_debug_state.pmscr_el1);
> >+
> >+	/* Non-VHE: Disable and flush SPE data generation
> >+	 * VHE: The vcpu can run. but it can't hide. */
> >+	if (!has_vhe())
> >+		__debug_save_spe_nvhe(&vcpu->arch.host_debug_state.pmscr_el1);
> >  }
> >  void __hyp_text __debug_cond_restore_host_state(struct kvm_vcpu *vcpu)
> >  {
> >-	__debug_restore_spe(vcpu->arch.host_debug_state.pmscr_el1);
> >+	if (!has_vhe())
> >+		__debug_restore_spe(vcpu->arch.host_debug_state.pmscr_el1);
> 
> For consistency, would it be worth naming that function
> '__debug_restore_spe_nvhe' ?

Yes.

> 
> Also, looking at __debug_save_spe_nvhe, I'm not sure how we guarantee that
> we might not end up using stale data during the restore_spe (though, if this
> is an issue, it existed before this change).
> The save function might exit without setting a value to saved pmscr_el1.
> 
> Basically I'm wondering if the following scenario (in non VHE) is possible
> and/or whether it is problematic:
> 
> - save spe
> - restore spe
> - host starts using spi -> !(PMBLIMITR_EL1 & PMBLIMITR_EL1_E)

spi ?

> - save spe -> returns early without setting pmscr_el1
> - restore spe with old save instead of doing nothing
> 

I think I see what you mean.  Basically you're asking if we need this:

diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index 4112160..8ab3510 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -106,7 +106,7 @@ static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
 
 static void __hyp_text __debug_restore_spe_nvhe(u64 &pmscr_el1)
 {
-	if (!pmscr_el1)
+	if (*pmscr_el1 != 0)
 		return;
 
 	/* The host page table is installed, but not yet synchronised */
@@ -114,6 +114,7 @@ static void __hyp_text __debug_restore_spe_nvhe(u64 &pmscr_el1)
 
 	/* Re-enable data generation */
 	write_sysreg_s(pmscr_el1, PMSCR_EL1);
+	*pmscr_el1 = 0;
 }
 
 void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,

I think we do, and I think this is a separate fix.  Would you like to
write a patch and cc Will and Marc (original author and committer) to
fix this?  Probably worth a cc stable as well.

Thanks,
-Christoffer
