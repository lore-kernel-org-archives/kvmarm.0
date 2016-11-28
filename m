From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Access CNTHCTL_EL2 bit fields correctly
Date: Mon, 28 Nov 2016 17:43:15 +0000
Message-ID: <d04fd17e-9157-07fe-4daa-9dbab149b5e6@arm.com>
References: <1480351570-11648-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1480351570-11648-1-git-send-email-jintack@cs.columbia.edu>
Sender: kvm-owner@vger.kernel.org
To: Jintack Lim <jintack@cs.columbia.edu>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, christoffer.dall@linaro.org, will.deacon@arm.com, catalin.marinas@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, julien.grall@arm.com, andre.przywara@arm.com, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jintack,

On 28/11/16 16:46, Jintack Lim wrote:
> Bit positions of CNTHCTL_EL2 are changing depending on HCR_EL2.E2H bit.
> EL1PCEN and EL1PCTEN are 1st and 0th bits when E2H is not set, but they
> are 11th and 10th bits respectively when E2H is set.  Current code is
> unintentionally setting wrong bits to CNTHCTL_EL2 with E2H set, which
> may allow guest OS to access physical timer. So, fix it.
> 
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> ---
>  arch/arm/include/asm/kvm_timer.h     | 33 +++++++++++++++++++
>  arch/arm64/include/asm/kvm_timer.h   | 62 ++++++++++++++++++++++++++++++++++++
>  include/clocksource/arm_arch_timer.h |  6 ++--
>  virt/kvm/arm/hyp/timer-sr.c          |  8 ++---
>  4 files changed, 103 insertions(+), 6 deletions(-)
>  create mode 100644 arch/arm/include/asm/kvm_timer.h
>  create mode 100644 arch/arm64/include/asm/kvm_timer.h
> 
> diff --git a/arch/arm/include/asm/kvm_timer.h b/arch/arm/include/asm/kvm_timer.h
> new file mode 100644
> index 0000000..d19d4b3
> --- /dev/null
> +++ b/arch/arm/include/asm/kvm_timer.h
> @@ -0,0 +1,33 @@
> +/*
> + * Copyright (C) 2016 - Columbia University
> + * Author: Jintack Lim <jintack@cs.columbia.edu>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef __ARM_KVM_TIMER_H__
> +#define __ARM_KVM_TIMER_H__
> +
> +#include <clocksource/arm_arch_timer.h>
> +
> +static inline u32 __hyp_text get_el1pcten(void)
> +{
> +	return CNTHCTL_EL1PCTEN_NVHE;
> +}
> +
> +static inline u32 __hyp_text get_el1pcen(void)
> +{
> +	return CNTHCTL_EL1PCEN_NVHE;
> +}
> +
> +#endif	/* __ARM_KVM_TIMER_H__ */
> diff --git a/arch/arm64/include/asm/kvm_timer.h b/arch/arm64/include/asm/kvm_timer.h
> new file mode 100644
> index 0000000..153f3da
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_timer.h
> @@ -0,0 +1,62 @@
> +/*
> + * Copyright (C) 2016 - Columbia University
> + * Author: Jintack Lim <jintack@cs.columbia.edu>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef __ARM64_KVM_TIMER_H__
> +#define __ARM64_KVM_TIMER_H__
> +
> +#include <asm/kvm_hyp.h>
> +#include <clocksource/arm_arch_timer.h>
> +
> +static inline u32 __hyp_text get_el1pcten_vhe(void)
> +{
> +	return CNTHCTL_EL1PCTEN_VHE;
> +}
> +
> +static inline u32 __hyp_text get_el1pcten_nvhe(void)
> +{
> +	return CNTHCTL_EL1PCTEN_NVHE;
> +}
> +
> +static hyp_alternate_select(get_el1pcten_arch,
> +			    get_el1pcten_nvhe, get_el1pcten_vhe,
> +			    ARM64_HAS_VIRT_HOST_EXTN);

This is pretty horrid ;-)

First, the inline qualifier doesn't apply here, as the whole 
hyp_alternate_select hack relies on thing not being inlined (it 
actually creates a function pointer).

Then, this gets potentially instantiated in any compilation unit that 
will include this file. GCC is probably clever enough to eliminate it 
if not used, but not without a well deserved warning.

> +
> +static inline u32 __hyp_text get_el1pten_vhe(void)
> +{
> +	return CNTHCTL_EL1PTEN_VHE;
> +}
> +
> +static inline u32 __hyp_text get_el1pcen_nvhe(void)
> +{
> +	return CNTHCTL_EL1PCEN_NVHE;
> +}
> +
> +static hyp_alternate_select(get_el1pcen_arch,
> +			    get_el1pcen_nvhe, get_el1pten_vhe,
> +			    ARM64_HAS_VIRT_HOST_EXTN);
> +
> +static inline u32 __hyp_text get_el1pcten(void)
> +{
> +	return get_el1pcten_arch()();
> +}
> +
> +static inline u32 __hyp_text get_el1pcen(void)
> +{
> +	return get_el1pcen_arch()();
> +}
> +
> +#endif	/* __ARM64_KVM_TIMER_H__ */
> diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
> index caedb74..4094529 100644
> --- a/include/clocksource/arm_arch_timer.h
> +++ b/include/clocksource/arm_arch_timer.h
> @@ -23,8 +23,10 @@
>  #define ARCH_TIMER_CTRL_IT_MASK		(1 << 1)
>  #define ARCH_TIMER_CTRL_IT_STAT		(1 << 2)
>  
> -#define CNTHCTL_EL1PCTEN		(1 << 0)
> -#define CNTHCTL_EL1PCEN			(1 << 1)
> +#define CNTHCTL_EL1PCTEN_NVHE		(1 << 0)
> +#define CNTHCTL_EL1PCEN_NVHE		(1 << 1)
> +#define CNTHCTL_EL1PCTEN_VHE		(1 << 10)
> +#define CNTHCTL_EL1PTEN_VHE		(1 << 11)
>  #define CNTHCTL_EVNTEN			(1 << 2)
>  #define CNTHCTL_EVNTDIR			(1 << 3)
>  #define CNTHCTL_EVNTI			(0xF << 4)
> diff --git a/virt/kvm/arm/hyp/timer-sr.c b/virt/kvm/arm/hyp/timer-sr.c
> index 798866a..f3feee0 100644
> --- a/virt/kvm/arm/hyp/timer-sr.c
> +++ b/virt/kvm/arm/hyp/timer-sr.c
> @@ -15,11 +15,11 @@
>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>   */
>  
> -#include <clocksource/arm_arch_timer.h>
>  #include <linux/compiler.h>
>  #include <linux/kvm_host.h>
>  
>  #include <asm/kvm_hyp.h>
> +#include <asm/kvm_timer.h>
>  
>  /* vcpu is already in the HYP VA space */
>  void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
> @@ -37,7 +37,7 @@ void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
>  
>  	/* Allow physical timer/counter access for the host */
>  	val = read_sysreg(cnthctl_el2);
> -	val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
> +	val |= get_el1pcten() | get_el1pcen();
>  	write_sysreg(val, cnthctl_el2);
>  
>  	/* Clear cntvoff for the host */
> @@ -55,8 +55,8 @@ void __hyp_text __timer_restore_state(struct kvm_vcpu *vcpu)
>  	 * Physical counter access is allowed
>  	 */
>  	val = read_sysreg(cnthctl_el2);
> -	val &= ~CNTHCTL_EL1PCEN;
> -	val |= CNTHCTL_EL1PCTEN;
> +	val &= ~get_el1pcen();
> +	val |= get_el1pcten();
>  	write_sysreg(val, cnthctl_el2);
>  
>  	if (timer->enabled) {
> 

Trying to solve this myself, I came up with an alternative approach,
which is ugly in its own way (#define in common code, random shifts):

diff --git a/virt/kvm/arm/hyp/timer-sr.c b/virt/kvm/arm/hyp/timer-sr.c
index 798866a..5cacfa8 100644
--- a/virt/kvm/arm/hyp/timer-sr.c
+++ b/virt/kvm/arm/hyp/timer-sr.c
@@ -21,11 +21,41 @@
 
 #include <asm/kvm_hyp.h>
 
+#ifdef CONFIG_ARM64
+static unsigned int __hyp_text get_cnthclt_shift_nvhe(void)
+{
+	return 0;
+}
+
+static unsigned int __hyp_text get_cnthclt_shift_vhe(void)
+{
+	return 10;
+}
+
+static hyp_alternate_select(__get_cnthclt_shift,
+			    get_cnthclt_shift_nvhe, get_cnthclt_shift_vhe,
+			    ARM64_HAS_VIRT_HOST_EXTN)
+
+#define cnthclt_shift()		__get_cnthclt_shift()()
+#else
+#define cnthclt_shift()		(0)
+#endif
+
+static inline void __hyp_text cnthctl_rmw(u32 clr, u32 set)
+{
+	u32 val;
+	int shift = cnthclt_shift();
+
+	val = read_sysreg(cnthctl_el2);
+	val &= ~clr << shift;
+	val |= set << shift;
+	write_sysreg(val, cnthctl_el2);
+}
+
 /* vcpu is already in the HYP VA space */
 void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
-	u64 val;
 
 	if (timer->enabled) {
 		timer->cntv_ctl = read_sysreg_el0(cntv_ctl);
@@ -36,9 +66,7 @@ void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
 	write_sysreg_el0(0, cntv_ctl);
 
 	/* Allow physical timer/counter access for the host */
-	val = read_sysreg(cnthctl_el2);
-	val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
-	write_sysreg(val, cnthctl_el2);
+	cnthctl_rmw(0, CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN);
 
 	/* Clear cntvoff for the host */
 	write_sysreg(0, cntvoff_el2);
@@ -48,16 +76,12 @@ void __hyp_text __timer_restore_state(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
-	u64 val;
 
 	/*
 	 * Disallow physical timer access for the guest
 	 * Physical counter access is allowed
 	 */
-	val = read_sysreg(cnthctl_el2);
-	val &= ~CNTHCTL_EL1PCEN;
-	val |= CNTHCTL_EL1PCTEN;
-	write_sysreg(val, cnthctl_el2);
+	cnthctl_rmw(CNTHCTL_EL1PCEN, CNTHCTL_EL1PCTEN);
 
 	if (timer->enabled) {
 		write_sysreg(kvm->arch.timer.cntvoff, cntvoff_el2);

We could make it nicer (read "faster") by introducing a
hyp_alternate_select construct that only returns a value instead
of calling a function. I remember writing something like that
at some point, and dropping it...

Thoughts?

	M.
-- 
Jazz is not dead. It just smells funny...
