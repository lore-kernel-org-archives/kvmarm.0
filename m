From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: The GIC is dead, long live the GIC
Date: Sun, 3 Jul 2016 23:10:04 +0200
Message-ID: <20160703211004.GA12608@cbox>
References: <1467394713-21772-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1467394713-21772-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On Fri, Jul 01, 2016 at 06:38:33PM +0100, Marc Zyngier wrote:
> I don't think any single piece of the KVM/ARM code ever generated
> as much hatred as the GIC emulation.
> 
> It was written by someone who had zero experience in modeling
> hardware (me), was riddled with design flaws, should have been
> scrapped and rewritten from scratch long before having a remote
> chance of reaching mainline, and yet we supported it for a good
> three years. No need to mention the names of those who suffered,
> the git log is singing their praises.
> 
> Thankfully, we now have a much more maintainable implementation,
> and we can safely put the grumpy old GIC to rest.
> 
> Fellow hackers, please raise your glass in memory of the GIC:
> 
> 	The GIC is dead, long live the GIC!

Hear hear!

Applied to queue.

Thanks,
-Christoffer

> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/kvm/Kconfig                    |    7 -
>  arch/arm/kvm/Makefile                   |    6 -
>  arch/arm64/kvm/Kconfig                  |    7 -
>  arch/arm64/kvm/Makefile                 |    8 -
>  include/kvm/{vgic/vgic.h => arm_vgic.h} |    6 +-
>  virt/kvm/arm/hyp/vgic-v2-sr.c           |   15 +-
>  virt/kvm/arm/vgic-v2-emul.c             |  856 -----------
>  virt/kvm/arm/vgic-v2.c                  |  274 ----
>  virt/kvm/arm/vgic-v3-emul.c             | 1074 --------------
>  virt/kvm/arm/vgic-v3.c                  |  279 ----
>  virt/kvm/arm/vgic.c                     | 2440 -------------------------------
>  virt/kvm/arm/vgic.h                     |  140 --
>  12 files changed, 7 insertions(+), 5105 deletions(-)
>  rename include/kvm/{vgic/vgic.h => arm_vgic.h} (98%)
>  delete mode 100644 virt/kvm/arm/vgic-v2-emul.c
>  delete mode 100644 virt/kvm/arm/vgic-v2.c
>  delete mode 100644 virt/kvm/arm/vgic-v3-emul.c
>  delete mode 100644 virt/kvm/arm/vgic-v3.c
>  delete mode 100644 virt/kvm/arm/vgic.c
>  delete mode 100644 virt/kvm/arm/vgic.h
> 
> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
> index 02abfff..95a0005 100644
> --- a/arch/arm/kvm/Kconfig
> +++ b/arch/arm/kvm/Kconfig
> @@ -46,13 +46,6 @@ config KVM_ARM_HOST
>  	---help---
>  	  Provides host support for ARM processors.
>  
> -config KVM_NEW_VGIC
> -	bool "New VGIC implementation"
> -	depends on KVM
> -	default y
> -	---help---
> -	  uses the new VGIC implementation
> -
>  source drivers/vhost/Kconfig
>  
>  endif # VIRTUALIZATION
> diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
> index a596b58..5e28df8 100644
> --- a/arch/arm/kvm/Makefile
> +++ b/arch/arm/kvm/Makefile
> @@ -22,7 +22,6 @@ obj-y += kvm-arm.o init.o interrupts.o
>  obj-y += arm.o handle_exit.o guest.o mmu.o emulate.o reset.o
>  obj-y += coproc.o coproc_a15.o coproc_a7.o mmio.o psci.o perf.o
>  
> -ifeq ($(CONFIG_KVM_NEW_VGIC),y)
>  obj-y += $(KVM)/arm/vgic/vgic.o
>  obj-y += $(KVM)/arm/vgic/vgic-init.o
>  obj-y += $(KVM)/arm/vgic/vgic-irqfd.o
> @@ -30,9 +29,4 @@ obj-y += $(KVM)/arm/vgic/vgic-v2.o
>  obj-y += $(KVM)/arm/vgic/vgic-mmio.o
>  obj-y += $(KVM)/arm/vgic/vgic-mmio-v2.o
>  obj-y += $(KVM)/arm/vgic/vgic-kvm-device.o
> -else
> -obj-y += $(KVM)/arm/vgic.o
> -obj-y += $(KVM)/arm/vgic-v2.o
> -obj-y += $(KVM)/arm/vgic-v2-emul.o
> -endif
>  obj-y += $(KVM)/arm/arch_timer.o
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index c4f26ef..aa2e34e 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -54,13 +54,6 @@ config KVM_ARM_PMU
>  	  Adds support for a virtual Performance Monitoring Unit (PMU) in
>  	  virtual machines.
>  
> -config KVM_NEW_VGIC
> -	bool "New VGIC implementation"
> -	depends on KVM
> -	default y
> -        ---help---
> -          uses the new VGIC implementation
> -
>  source drivers/vhost/Kconfig
>  
>  endif # VIRTUALIZATION
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index a7a958c..f00b2cd 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -20,7 +20,6 @@ kvm-$(CONFIG_KVM_ARM_HOST) += emulate.o inject_fault.o regmap.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
>  
> -ifeq ($(CONFIG_KVM_NEW_VGIC),y)
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-init.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-irqfd.o
> @@ -30,12 +29,5 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v2.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v3.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-kvm-device.o
> -else
> -kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic.o
> -kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v2.o
> -kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v2-emul.o
> -kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v3.o
> -kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v3-emul.o
> -endif
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
>  kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/arm_vgic.h
> similarity index 98%
> rename from include/kvm/vgic/vgic.h
> rename to include/kvm/arm_vgic.h
> index 3fbd175..1264037 100644
> --- a/include/kvm/vgic/vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -13,8 +13,8 @@
>   * You should have received a copy of the GNU General Public License
>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>   */
> -#ifndef __ASM_ARM_KVM_VGIC_VGIC_H
> -#define __ASM_ARM_KVM_VGIC_VGIC_H
> +#ifndef __KVM_ARM_VGIC_H
> +#define __KVM_ARM_VGIC_H
>  
>  #include <linux/kernel.h>
>  #include <linux/kvm.h>
> @@ -243,4 +243,4 @@ static inline int kvm_vgic_get_max_vcpus(void)
>  	return kvm_vgic_global_state.max_gic_vcpus;
>  }
>  
> -#endif /* __ASM_ARM_KVM_VGIC_VGIC_H */
> +#endif /* __KVM_ARM_VGIC_H */
> diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
> index 3a3a699..7cffd93 100644
> --- a/virt/kvm/arm/hyp/vgic-v2-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
> @@ -21,18 +21,11 @@
>  
>  #include <asm/kvm_hyp.h>
>  
> -#ifdef CONFIG_KVM_NEW_VGIC
> -extern struct vgic_global kvm_vgic_global_state;
> -#define vgic_v2_params kvm_vgic_global_state
> -#else
> -extern struct vgic_params vgic_v2_params;
> -#endif
> -
>  static void __hyp_text save_maint_int_state(struct kvm_vcpu *vcpu,
>  					    void __iomem *base)
>  {
>  	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
> -	int nr_lr = (kern_hyp_va(&vgic_v2_params))->nr_lr;
> +	int nr_lr = (kern_hyp_va(&kvm_vgic_global_state))->nr_lr;
>  	u32 eisr0, eisr1;
>  	int i;
>  	bool expect_mi;
> @@ -74,7 +67,7 @@ static void __hyp_text save_maint_int_state(struct kvm_vcpu *vcpu,
>  static void __hyp_text save_elrsr(struct kvm_vcpu *vcpu, void __iomem *base)
>  {
>  	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
> -	int nr_lr = (kern_hyp_va(&vgic_v2_params))->nr_lr;
> +	int nr_lr = (kern_hyp_va(&kvm_vgic_global_state))->nr_lr;
>  	u32 elrsr0, elrsr1;
>  
>  	elrsr0 = readl_relaxed(base + GICH_ELRSR0);
> @@ -93,7 +86,7 @@ static void __hyp_text save_elrsr(struct kvm_vcpu *vcpu, void __iomem *base)
>  static void __hyp_text save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
>  {
>  	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
> -	int nr_lr = (kern_hyp_va(&vgic_v2_params))->nr_lr;
> +	int nr_lr = (kern_hyp_va(&kvm_vgic_global_state))->nr_lr;
>  	int i;
>  
>  	for (i = 0; i < nr_lr; i++) {
> @@ -147,7 +140,7 @@ void __hyp_text __vgic_v2_restore_state(struct kvm_vcpu *vcpu)
>  	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
>  	struct vgic_dist *vgic = &kvm->arch.vgic;
>  	void __iomem *base = kern_hyp_va(vgic->vctrl_base);
> -	int nr_lr = (kern_hyp_va(&vgic_v2_params))->nr_lr;
> +	int nr_lr = (kern_hyp_va(&kvm_vgic_global_state))->nr_lr;
>  	int i;
>  	u64 live_lrs = 0;
>  
> diff --git a/virt/kvm/arm/vgic-v2-emul.c b/virt/kvm/arm/vgic-v2-emul.c
> deleted file mode 100644
> index 1b0bee0..0000000
> diff --git a/virt/kvm/arm/vgic-v2.c b/virt/kvm/arm/vgic-v2.c
> deleted file mode 100644
> index 334cd7a..0000000
> diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
> deleted file mode 100644
> index e661e7f..0000000
> diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
> deleted file mode 100644
> index 75b02fa..0000000
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> deleted file mode 100644
> index c3bfbb9..0000000
> diff --git a/virt/kvm/arm/vgic.h b/virt/kvm/arm/vgic.h
> deleted file mode 100644
> index 0df74cb..0000000
> -- 
> 2.1.4
> 
