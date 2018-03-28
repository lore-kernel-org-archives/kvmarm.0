From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [RFC v2 11/12] KVM: arm/arm64: Implement KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
Date: Wed, 28 Mar 2018 19:55:24 +0100
Message-ID: <CAFEAcA_zXwS6EygjwPO9e-Ouy=seDdZt5i62itGP-W7VHugYTQ@mail.gmail.com>
References: <1522159456-10419-1-git-send-email-eric.auger@redhat.com> <1522159456-10419-12-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522159456-10419-12-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: Eric Auger <eric.auger.pro@gmail.com>, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@kernel.org>, Andre Przywara <andre.przywara@arm.com>, Andrew Jones <drjones@redhat.com>, Wei Huang <wei@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 27 March 2018 at 15:04, Eric Auger <eric.auger@redhat.com> wrote:
> Now all the internals are ready to handle multiple redistributor
> regions, let's allow the userspace to register them.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  virt/kvm/arm/vgic/vgic-kvm-device.c | 40 +++++++++++++++++++++++++++++++++++--
>  virt/kvm/arm/vgic/vgic-mmio-v3.c    |  4 ++--
>  virt/kvm/arm/vgic/vgic.h            |  9 ++++++++-
>  3 files changed, 48 insertions(+), 5 deletions(-)
>
> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> index e7b5a86..a2b99e4 100644
> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> @@ -65,7 +65,8 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
>  {
>         int r = 0;
>         struct vgic_dist *vgic = &kvm->arch.vgic;
> -       phys_addr_t *addr_ptr, alignment;
> +       phys_addr_t *addr_ptr = NULL;
> +       phys_addr_t alignment;
>         uint64_t undef_value = VGIC_ADDR_UNDEF;
>
>         mutex_lock(&kvm->lock);
> @@ -92,7 +93,7 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
>                 if (r)
>                         break;
>                 if (write) {
> -                       r = vgic_v3_set_redist_base(kvm, *addr);
> +                       r = vgic_v3_set_redist_base(kvm, 0, *addr, 0);
>                         goto out;
>                 }
>                 rdreg = list_first_entry(&vgic->rd_regions,
> @@ -103,6 +104,40 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
>                         addr_ptr = &rdreg->base;
>                 break;
>         }
> +       case KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION:
> +       {
> +               struct vgic_redist_region *rdreg;
> +               uint8_t index;
> +
> +               r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V3);
> +               if (r)
> +                       break;
> +
> +               index = *addr & KVM_VGIC_V3_RDIST_INDEX_MASK;
> +
> +               if (write) {
> +                       gpa_t base = *addr & KVM_VGIC_V3_RDIST_BASE_MASK;
> +                       uint32_t count = (*addr & KVM_VGIC_V3_RDIST_COUNT_MASK)
> +                                       >> KVM_VGIC_V3_RDIST_COUNT_SHIFT;
> +                       uint8_t flags = (*addr & KVM_VGIC_V3_RDIST_FLAGS_MASK)
> +                                       >> KVM_VGIC_V3_RDIST_FLAGS_SHIFT;
> +
> +                       if (!count || flags)
> +                               r = -EINVAL;
> +                       else
> +                               r = vgic_v3_set_redist_base(kvm, index,
> +                                                           base, count);
> +                       goto out;
> +               }
> +
> +               rdreg = vgic_v3_rdist_region_from_index(kvm, index);
> +               if (!rdreg)
> +                       r = -ENODEV;

Here you check whether rdreg is NULL...

> +
> +               *addr_ptr = rdreg->base & index &

...but here you dereference it anyway. Missing "goto out"/break/other
control flow?

> +                       (uint64_t)rdreg->count << KVM_VGIC_V3_RDIST_COUNT_SHIFT;
> +               break;
> +       }

I was looking for the code which checked "EINVAL if you
already used KVM_VGIC_V3_ADDR_TYPE_REDIST", but couldn't
see it. Is that handled by one of the helper functions?

>         default:
>                 r = -ENODEV;
>         }
> @@ -674,6 +709,7 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
>                 switch (attr->attr) {
>                 case KVM_VGIC_V3_ADDR_TYPE_DIST:
>                 case KVM_VGIC_V3_ADDR_TYPE_REDIST:
> +               case KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION:
>                         return 0;
>                 }
>                 break;
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index 89faadc..45287a0 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -766,11 +766,11 @@ static int vgic_v3_insert_redist_region(struct kvm *kvm, uint32_t index,
>         return ret;
>  }
>
> -int vgic_v3_set_redist_base(struct kvm *kvm, u64 addr)
> +int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count)
>  {
>         int ret;
>
> -       ret = vgic_v3_insert_redist_region(kvm, 0, addr, 0);
> +       ret = vgic_v3_insert_redist_region(kvm, index, addr, count);
>         if (ret)
>                 return ret;

thanks
-- PMM
