From: Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>
Subject: Re: [PATCH v2 11/12] KVM: arm/arm64: rework MMIO abort handling to
 use KVM MMIO bus
Date: Mon, 23 Mar 2015 23:43:12 +0200
Message-ID: <CADDJ2=PTpuy5-CSrtFwL-_79fWCpgXGphKYrMi7B-+1NcDDTZg@mail.gmail.com>
References: <1427126309-11223-1-git-send-email-andre.przywara@arm.com> <1427126309-11223-12-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1427126309-11223-12-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Eric Auger <eric.auger@linaro.org>, "open list:KERNEL VIRTUAL MA..." <kvm@vger.kernel.org>, "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>, VirtualOpenSystems Technical Team <tech@virtualopensystems.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 23, 2015 at 5:58 PM, Andre Przywara <andre.przywara@arm.com> wrote:
>
> Currently we have struct kvm_exit_mmio for encapsulating MMIO abort
> data to be passed on from syndrome decoding all the way down to the
> VGIC register handlers. Now as we switch the MMIO handling to be
> routed through the KVM MMIO bus, it does not make sense anymore to
> use that structure already from the beginning. So we put the data into
> kvm_run very early and use that encapsulation till the MMIO bus call.
> Then we fill kvm_exit_mmio in the VGIC only, making it a VGIC private
> structure. On that way we replace the data buffer in that structure
> with a pointer pointing to a single location in kvm_run, so we get
> rid of some copying on the way.
> I didn't bother to rename kvm_exit_mmio (to vgic_mmio or something),
I would vote for the renaming.

Otherwise the patch looks much cleaner and straightforward than what
it was before.

Nikolay Nikolaev

> because that touches a lot of code lines without any good reason.
>
> This is based on an original patch by Nikolay.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Cc: Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>
> ---
>  arch/arm/include/asm/kvm_mmio.h   |   22 --------------
>  arch/arm/kvm/mmio.c               |   60 ++++++++++++++++++++++++++-----------
>  arch/arm64/include/asm/kvm_mmio.h |   22 --------------
>  include/kvm/arm_vgic.h            |    3 --
>  virt/kvm/arm/vgic.c               |   18 +++--------
>  virt/kvm/arm/vgic.h               |    8 +++++
>  6 files changed, 55 insertions(+), 78 deletions(-)
>
> diff --git a/arch/arm/include/asm/kvm_mmio.h b/arch/arm/include/asm/kvm_mmio.h
> index 3f83db2..d8e90c8 100644
> --- a/arch/arm/include/asm/kvm_mmio.h
> +++ b/arch/arm/include/asm/kvm_mmio.h
> @@ -28,28 +28,6 @@ struct kvm_decode {
>         bool sign_extend;
>  };
>
> -/*
> - * The in-kernel MMIO emulation code wants to use a copy of run->mmio,
> - * which is an anonymous type. Use our own type instead.
> - */
> -struct kvm_exit_mmio {
> -       phys_addr_t     phys_addr;
> -       u8              data[8];
> -       u32             len;
> -       bool            is_write;
> -       void            *private;
> -};
> -
> -static inline void kvm_prepare_mmio(struct kvm_run *run,
> -                                   struct kvm_exit_mmio *mmio)
> -{
> -       run->mmio.phys_addr     = mmio->phys_addr;
> -       run->mmio.len           = mmio->len;
> -       run->mmio.is_write      = mmio->is_write;
> -       memcpy(run->mmio.data, mmio->data, mmio->len);
> -       run->exit_reason        = KVM_EXIT_MMIO;
> -}
> -
>  int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
>                  phys_addr_t fault_ipa);
> diff --git a/arch/arm/kvm/mmio.c b/arch/arm/kvm/mmio.c
> index 5d3bfc0..bb2ab44 100644
> --- a/arch/arm/kvm/mmio.c
> +++ b/arch/arm/kvm/mmio.c
> @@ -122,7 +122,7 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  }
>
>  static int decode_hsr(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> -                     struct kvm_exit_mmio *mmio)
> +                     struct kvm_run *run)
>  {
>         unsigned long rt;
>         int len;
> @@ -148,9 +148,9 @@ static int decode_hsr(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         sign_extend = kvm_vcpu_dabt_issext(vcpu);
>         rt = kvm_vcpu_dabt_get_rd(vcpu);
>
> -       mmio->is_write = is_write;
> -       mmio->phys_addr = fault_ipa;
> -       mmio->len = len;
> +       run->mmio.is_write = is_write;
> +       run->mmio.phys_addr = fault_ipa;
> +       run->mmio.len = len;
>         vcpu->arch.mmio_decode.sign_extend = sign_extend;
>         vcpu->arch.mmio_decode.rt = rt;
>
> @@ -162,23 +162,49 @@ static int decode_hsr(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         return 0;
>  }
>
> +/**
> + * handle_kernel_mmio - handle an in-kernel MMIO access
> + * @vcpu:      pointer to the vcpu performing the access
> + * @run:       pointer to the kvm_run structure
> + *
> + * returns true if the MMIO access has been performed in kernel space,
> + * and false if it needs to be emulated in user space.
> + */
> +static bool handle_kernel_mmio(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +{
> +       int ret;
> +
> +       if (run->mmio.is_write) {
> +               ret = kvm_io_bus_write(vcpu, KVM_MMIO_BUS, run->mmio.phys_addr,
> +                                      run->mmio.len, run->mmio.data);
> +
> +       } else {
> +               ret = kvm_io_bus_read(vcpu, KVM_MMIO_BUS, run->mmio.phys_addr,
> +                                     run->mmio.len, run->mmio.data);
> +       }
> +       if (!ret) {
> +               kvm_handle_mmio_return(vcpu, run);
> +               return true;
> +       }
> +
> +       return false;
> +}
> +
>  int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
>                  phys_addr_t fault_ipa)
>  {
> -       struct kvm_exit_mmio mmio;
>         unsigned long data;
>         unsigned long rt;
>         int ret;
>
>         /*
> -        * Prepare MMIO operation. First stash it in a private
> -        * structure that we can use for in-kernel emulation. If the
> -        * kernel can't handle it, copy it into run->mmio and let user
> -        * space do its magic.
> +        * Prepare MMIO operation. First put the MMIO data into run->mmio.
> +        * Then try if some in-kernel emulation feels responsible, otherwise
> +        * let user space do its magic.
>          */
>
>         if (kvm_vcpu_dabt_isvalid(vcpu)) {
> -               ret = decode_hsr(vcpu, fault_ipa, &mmio);
> +               ret = decode_hsr(vcpu, fault_ipa, run);
>                 if (ret)
>                         return ret;
>         } else {
> @@ -188,21 +214,21 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
>
>         rt = vcpu->arch.mmio_decode.rt;
>
> -       if (mmio.is_write) {
> +       if (run->mmio.is_write) {
>                 data = vcpu_data_guest_to_host(vcpu, *vcpu_reg(vcpu, rt),
> -                                              mmio.len);
> +                                              run->mmio.len);
>
> -               trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, mmio.len,
> +               trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, run->mmio.len,
>                                fault_ipa, data);
> -               mmio_write_buf(mmio.data, mmio.len, data);
> +               mmio_write_buf(run->mmio.data, run->mmio.len, data);
>         } else {
> -               trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, mmio.len,
> +               trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, run->mmio.len,
>                                fault_ipa, 0);
>         }
>
> -       if (vgic_handle_mmio(vcpu, run, &mmio))
> +       if (handle_kernel_mmio(vcpu, run))
>                 return 1;
>
> -       kvm_prepare_mmio(run, &mmio);
> +       run->exit_reason = KVM_EXIT_MMIO;
>         return 0;
>  }
> diff --git a/arch/arm64/include/asm/kvm_mmio.h b/arch/arm64/include/asm/kvm_mmio.h
> index 9f52beb..889c908 100644
> --- a/arch/arm64/include/asm/kvm_mmio.h
> +++ b/arch/arm64/include/asm/kvm_mmio.h
> @@ -31,28 +31,6 @@ struct kvm_decode {
>         bool sign_extend;
>  };
>
> -/*
> - * The in-kernel MMIO emulation code wants to use a copy of run->mmio,
> - * which is an anonymous type. Use our own type instead.
> - */
> -struct kvm_exit_mmio {
> -       phys_addr_t     phys_addr;
> -       u8              data[8];
> -       u32             len;
> -       bool            is_write;
> -       void            *private;
> -};
> -
> -static inline void kvm_prepare_mmio(struct kvm_run *run,
> -                                   struct kvm_exit_mmio *mmio)
> -{
> -       run->mmio.phys_addr     = mmio->phys_addr;
> -       run->mmio.len           = mmio->len;
> -       run->mmio.is_write      = mmio->is_write;
> -       memcpy(run->mmio.data, mmio->data, mmio->len);
> -       run->exit_reason        = KVM_EXIT_MMIO;
> -}
> -
>  int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
>                  phys_addr_t fault_ipa);
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index d6705f4..14853d8 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -314,7 +314,6 @@ struct vgic_cpu {
>  struct kvm;
>  struct kvm_vcpu;
>  struct kvm_run;
> -struct kvm_exit_mmio;
>
>  int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
>  int kvm_vgic_hyp_init(void);
> @@ -330,8 +329,6 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
>  void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
>  int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
>  int kvm_vgic_vcpu_active_irq(struct kvm_vcpu *vcpu);
> -bool vgic_handle_mmio(struct kvm_vcpu *vcpu, struct kvm_run *run,
> -                     struct kvm_exit_mmio *mmio);
>
>  #define irqchip_in_kernel(k)   (!!((k)->arch.vgic.in_kernel))
>  #define vgic_initialized(k)    (!!((k)->arch.vgic.nr_cpus))
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 9cbb55f4..2598fe8 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -758,7 +758,6 @@ static bool call_range_handler(struct kvm_vcpu *vcpu,
>                                unsigned long offset,
>                                const struct vgic_io_range *range)
>  {
> -       u32 *data32 = (void *)mmio->data;
>         struct kvm_exit_mmio mmio32;
>         bool ret;
>
> @@ -775,18 +774,12 @@ static bool call_range_handler(struct kvm_vcpu *vcpu,
>         mmio32.private = mmio->private;
>
>         mmio32.phys_addr = mmio->phys_addr + 4;
> -       if (mmio->is_write)
> -               *(u32 *)mmio32.data = data32[1];
> +       mmio32.data = &((u32 *)mmio->data)[1];
>         ret = range->handle_mmio(vcpu, &mmio32, offset + 4);
> -       if (!mmio->is_write)
> -               data32[1] = *(u32 *)mmio32.data;
>
>         mmio32.phys_addr = mmio->phys_addr;
> -       if (mmio->is_write)
> -               *(u32 *)mmio32.data = data32[0];
> +       mmio32.data = &((u32 *)mmio->data)[0];
>         ret |= range->handle_mmio(vcpu, &mmio32, offset);
> -       if (!mmio->is_write)
> -               data32[0] = *(u32 *)mmio32.data;
>
>         return ret;
>  }
> @@ -873,23 +866,20 @@ static int vgic_handle_mmio_access(struct kvm_vcpu *vcpu,
>         mmio.phys_addr = addr;
>         mmio.len = len;
>         mmio.is_write = is_write;
> -       if (is_write)
> -               memcpy(mmio.data, val, len);
> +       mmio.data = val;
>         mmio.private = iodev->redist_vcpu;
>
>         spin_lock(&dist->lock);
>         offset -= range->base;
>         if (vgic_validate_access(dist, range, offset)) {
>                 updated_state = call_range_handler(vcpu, &mmio, offset, range);
> -               if (!is_write)
> -                       memcpy(val, mmio.data, len);
>         } else {
>                 if (!is_write)
>                         memset(val, 0, len);
>                 updated_state = false;
>         }
>         spin_unlock(&dist->lock);
> -       kvm_prepare_mmio(run, &mmio);
> +       run->exit_reason = KVM_EXIT_MMIO;
>         kvm_handle_mmio_return(vcpu, run);
>
>         if (updated_state)
> diff --git a/virt/kvm/arm/vgic.h b/virt/kvm/arm/vgic.h
> index 28fa3aa..fc73103 100644
> --- a/virt/kvm/arm/vgic.h
> +++ b/virt/kvm/arm/vgic.h
> @@ -59,6 +59,14 @@ void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
>  bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq);
>  void vgic_unqueue_irqs(struct kvm_vcpu *vcpu);
>
> +struct kvm_exit_mmio {
> +       phys_addr_t     phys_addr;
> +       void            *data;
> +       u32             len;
> +       bool            is_write;
> +       void            *private;
> +};
> +
>  void vgic_reg_access(struct kvm_exit_mmio *mmio, u32 *reg,
>                      phys_addr_t offset, int mode);
>  bool handle_mmio_raz_wi(struct kvm_vcpu *vcpu, struct kvm_exit_mmio *mmio,
> --
> 1.7.9.5
>
