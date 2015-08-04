From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 06/11] KVM: arm/arm64: vgic: Allow dynamic mapping of
 physical/virtual interrupts
Date: Tue, 4 Aug 2015 19:36:50 +0200
Message-ID: <20150804173650.GG29335@cbox>
References: <1437753309-17989-1-git-send-email-marc.zyngier@arm.com>
 <1437753309-17989-7-git-send-email-marc.zyngier@arm.com>
 <20150804130457.GA29335@cbox>
 <55C0D9C7.7060707@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55C0D9C7.7060707@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Eric Auger <eric.auger@linaro.org>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 04, 2015 at 04:27:03PM +0100, Marc Zyngier wrote:
> On 04/08/15 14:04, Christoffer Dall wrote:
> > On Fri, Jul 24, 2015 at 04:55:04PM +0100, Marc Zyngier wrote:
> >> In order to be able to feed physical interrupts to a guest, we need
> >> to be able to establish the virtual-physical mapping between the two
> >> worlds.
> >>
> >> The mappings are kept in a set of RCU lists, indexed by virtual interrupts.
> >>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  arch/arm/kvm/arm.c     |   2 +
> >>  include/kvm/arm_vgic.h |  26 +++++++
> >>  virt/kvm/arm/vgic.c    | 189 ++++++++++++++++++++++++++++++++++++++++++++++++-
> >>  3 files changed, 216 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> >> index f1bf418..ce404a5 100644
> >> --- a/arch/arm/kvm/arm.c
> >> +++ b/arch/arm/kvm/arm.c
> >> @@ -125,6 +125,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> >>       if (ret)
> >>               goto out_free_stage2_pgd;
> >>
> >> +     kvm_vgic_early_init(kvm);
> >>       kvm_timer_init(kvm);
> >>
> >>       /* Mark the initial VMID generation invalid */
> >> @@ -249,6 +250,7 @@ out:
> >>
> >>  void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
> >>  {
> >> +     kvm_vgic_vcpu_early_init(vcpu);
> >>  }
> >>
> >>  void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
> >> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> >> index a881e39..68212a1 100644
> >> --- a/include/kvm/arm_vgic.h
> >> +++ b/include/kvm/arm_vgic.h
> >> @@ -159,6 +159,20 @@ struct vgic_io_device {
> >>       struct kvm_io_device dev;
> >>  };
> >>
> >> +struct irq_phys_map {
> >> +     u32                     virt_irq;
> >> +     u32                     phys_irq;
> >> +     u32                     irq;
> >> +     bool                    deleted;
> >> +     bool                    active;
> >> +};
> >> +
> >> +struct irq_phys_map_entry {
> >> +     struct list_head        entry;
> >> +     struct rcu_head         rcu;
> >> +     struct irq_phys_map     map;
> >> +};
> >> +
> >>  struct vgic_dist {
> >>       spinlock_t              lock;
> >>       bool                    in_kernel;
> >> @@ -256,6 +270,10 @@ struct vgic_dist {
> >>       struct vgic_vm_ops      vm_ops;
> >>       struct vgic_io_device   dist_iodev;
> >>       struct vgic_io_device   *redist_iodevs;
> >> +
> >> +     /* Virtual irq to hwirq mapping */
> >> +     spinlock_t              irq_phys_map_lock;
> >> +     struct list_head        irq_phys_map_list;
> >>  };
> >>
> >>  struct vgic_v2_cpu_if {
> >> @@ -307,6 +325,9 @@ struct vgic_cpu {
> >>               struct vgic_v2_cpu_if   vgic_v2;
> >>               struct vgic_v3_cpu_if   vgic_v3;
> >>       };
> >> +
> >> +     /* Protected by the distributor's irq_phys_map_lock */
> >> +     struct list_head        irq_phys_map_list;
> >>  };
> >>
> >>  #define LR_EMPTY     0xff
> >> @@ -321,8 +342,10 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
> >>  int kvm_vgic_hyp_init(void);
> >>  int kvm_vgic_map_resources(struct kvm *kvm);
> >>  int kvm_vgic_get_max_vcpus(void);
> >> +void kvm_vgic_early_init(struct kvm *kvm);
> >>  int kvm_vgic_create(struct kvm *kvm, u32 type);
> >>  void kvm_vgic_destroy(struct kvm *kvm);
> >> +void kvm_vgic_vcpu_early_init(struct kvm_vcpu *vcpu);
> >>  void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu);
> >>  void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu);
> >>  void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
> >> @@ -331,6 +354,9 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
> >>  void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
> >>  int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
> >>  int kvm_vgic_vcpu_active_irq(struct kvm_vcpu *vcpu);
> >> +struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
> >> +                                        int virt_irq, int irq);
> >> +int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
> >>
> >>  #define irqchip_in_kernel(k) (!!((k)->arch.vgic.in_kernel))
> >>  #define vgic_initialized(k)  (!!((k)->arch.vgic.nr_cpus))
> >> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> >> index 5bd1695..c74d929 100644
> >> --- a/virt/kvm/arm/vgic.c
> >> +++ b/virt/kvm/arm/vgic.c
> >> @@ -24,6 +24,7 @@
> >>  #include <linux/of.h>
> >>  #include <linux/of_address.h>
> >>  #include <linux/of_irq.h>
> >> +#include <linux/rculist.h>
> >>  #include <linux/uaccess.h>
> >>
> >>  #include <asm/kvm_emulate.h>
> >> @@ -82,6 +83,8 @@ static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu);
> >>  static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu);
> >>  static struct vgic_lr vgic_get_lr(const struct kvm_vcpu *vcpu, int lr);
> >>  static void vgic_set_lr(struct kvm_vcpu *vcpu, int lr, struct vgic_lr lr_desc);
> >> +static struct irq_phys_map *vgic_irq_map_search(struct kvm_vcpu *vcpu,
> >> +                                             int virt_irq);
> >>
> >>  static const struct vgic_ops *vgic_ops;
> >>  static const struct vgic_params *vgic;
> >> @@ -1583,6 +1586,166 @@ static irqreturn_t vgic_maintenance_handler(int irq, void *data)
> >>       return IRQ_HANDLED;
> >>  }
> >>
> >> +static struct list_head *vgic_get_irq_phys_map_list(struct kvm_vcpu *vcpu,
> >> +                                                 int virt_irq)
> >> +{
> >> +     if (virt_irq < VGIC_NR_PRIVATE_IRQS)
> >> +             return &vcpu->arch.vgic_cpu.irq_phys_map_list;
> >> +     else
> >> +             return &vcpu->kvm->arch.vgic.irq_phys_map_list;
> >> +}
> >> +
> >> +/**
> >> + * kvm_vgic_map_phys_irq - map a virtual IRQ to a physical IRQ
> >> + * @vcpu: The VCPU pointer
> >> + * @virt_irq: The virtual irq number
> >> + * @irq: The Linux IRQ number
> >> + *
> >> + * Establish a mapping between a guest visible irq (@virt_irq) and a
> >> + * Linux irq (@irq). On injection, @virt_irq will be associated with
> >> + * the physical interrupt represented by @irq.
> >> + *
> >> + * Returns a valid pointer on success, and an error pointer otherwise
> >> + */
> >> +struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
> >> +                                        int virt_irq, int irq)
> >> +{
> >> +     struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> >> +     struct list_head *root = vgic_get_irq_phys_map_list(vcpu, virt_irq);
> >> +     struct irq_phys_map *map;
> >> +     struct irq_phys_map_entry *entry;
> >> +     struct irq_desc *desc;
> >> +     struct irq_data *data;
> >> +     int phys_irq;
> >> +
> >> +     desc = irq_to_desc(irq);
> >> +     if (!desc) {
> >> +             kvm_err("kvm_vgic_map_phys_irq: no interrupt descriptor\n");
> > 
> > super over-ridiculous nit:
> > if you respin you could consider "%s: no...", __FUNC__
> 
> Sure.
> 
> > 
> >> +             return ERR_PTR(-EINVAL);
> >> +     }
> >> +
> >> +     data = irq_desc_get_irq_data(desc);
> >> +     while (data->parent_data)
> >> +             data = data->parent_data;
> >> +
> >> +     phys_irq = data->hwirq;
> >> +
> >> +     /* Create a new mapping */
> >> +     entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> >> +     if (!entry)
> >> +             return ERR_PTR(-ENOMEM);
> >> +
> >> +     spin_lock(&dist->irq_phys_map_lock);
> >> +
> >> +     /* Try to match an existing mapping */
> >> +     map = vgic_irq_map_search(vcpu, virt_irq);
> >> +     if (map) {
> >> +             /* Make sure this mapping matches */
> > 
> > why do we need to check that it matches?  Is it ever allowed to have
> > multiple mappings of a virtual interrupt?
> > 
> 
> Multiple *different* mappings, no. What you can have though is issuing
> requests for the *same* mapping repeatedly. This is what happens with
> the timer, for example: kvm_timer_vcpu_reset is going to be called more
> than once over the lifetime of a VM, requesting a mapping each time
> without necessarily destroying the previous one.
> 
> >> +             if (map->phys_irq != phys_irq   ||
> >> +                 map->irq      != irq)
> >> +                     map = ERR_PTR(-EINVAL);
> >> +
> >> +             goto out;
> > 
> > why is this a valid situation?  Shouldn't you return -EEXIST or
> > something instead?  (that would also simplify the error-checking free
> > routine below).
> > 
> > If you want it to be valid to map the same virq to irq multiple times
> > (to free the caller from some bookkeeping, I presume?) then that should
> > be part of the function documentation, and I think we should add a
> > "found existing mapping" comment above the goto out statement.
> 
> Fair enough. I'll add some comments to that effect.
> 

thanks!

> >> +     }
> >> +
> >> +     map           = &entry->map;
> >> +     map->virt_irq = virt_irq;
> >> +     map->phys_irq = phys_irq;
> >> +     map->irq      = irq;
> >> +
> >> +     list_add_tail_rcu(&entry->entry, root);
> >> +
> >> +out:
> >> +     spin_unlock(&dist->irq_phys_map_lock);
> >> +     /* If we've found a hit in the existing list, free the useless
> >> +      * entry */
> >> +     if (IS_ERR(map) || map != &entry->map)
> >> +             kfree(entry);
> >> +     return map;
> >> +}
> >> +
> >> +static struct irq_phys_map *vgic_irq_map_search(struct kvm_vcpu *vcpu,
> >> +                                             int virt_irq)
> >> +{
> >> +     struct list_head *root = vgic_get_irq_phys_map_list(vcpu, virt_irq);
> >> +     struct irq_phys_map_entry *entry;
> >> +     struct irq_phys_map *map;
> >> +
> >> +     rcu_read_lock();
> >> +
> >> +     list_for_each_entry_rcu(entry, root, entry) {
> >> +             map = &entry->map;
> >> +             if (map->virt_irq == virt_irq && !map->deleted) {
> >> +                     rcu_read_unlock();
> >> +                     return map;
> >> +             }
> >> +     }
> >> +
> >> +     rcu_read_unlock();
> >> +
> >> +     return NULL;
> >> +}
> >> +
> >> +static void vgic_free_phys_irq_map_rcu(struct rcu_head *rcu)
> >> +{
> >> +     struct irq_phys_map_entry *entry;
> >> +
> >> +     entry = container_of(rcu, struct irq_phys_map_entry, rcu);
> >> +     kfree(entry);
> >> +}
> >> +
> >> +/**
> >> + * kvm_vgic_unmap_phys_irq - Remove a virtual to physical IRQ mapping
> >> + * @vcpu: The VCPU pointer
> >> + * @map: The pointer to a mapping obtained through kvm_vgic_map_phys_irq
> >> + *
> >> + * Remove an existing mapping between virtual and physical interrupts.
> >> + */
> >> +int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map)
> >> +{
> >> +     struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> >> +     struct irq_phys_map_entry *entry;
> >> +     struct list_head *root;
> >> +
> >> +     if (!map)
> >> +             return -EINVAL;
> >> +
> >> +     root = vgic_get_irq_phys_map_list(vcpu, map->virt_irq);
> >> +
> >> +     spin_lock(&dist->irq_phys_map_lock);
> >> +
> >> +     list_for_each_entry(entry, root, entry) {
> >> +             if (&entry->map == map && !map->deleted) {
> >> +                     map->deleted = true;
> > 
> > why do you need the 'deleted' flag?  You now search the list only after
> > holding the lock, so the race I pointed out before doesn't exist
> > anymore.  Is there an additional issue that the deleted flag is taking
> > care of?
> 
> This could still race with a destroy occuring before we take the lock,
> and before we get get RCU to do the cleanup (the list would still be
> populated).
> 

That's not how I understand list_del_rcu; I think it deletes the entry
immediately with the right memory barriers.  It is only the free
operation that happens on rcu sync and can be/is deferred.

So I'm pretty sure that when you search the list after holding the lock,
there is no race.

> > 
> >> +                     list_del_rcu(&entry->entry);
> >> +                     call_rcu(&entry->rcu, vgic_free_phys_irq_map_rcu);
> >> +                     break;
> >> +             }
> >> +     }
> >> +
> >> +     spin_unlock(&dist->irq_phys_map_lock);
> >> +
> >> +     return 0;
> >> +}
> >> +
> >> +static void vgic_destroy_irq_phys_map(struct kvm *kvm, struct list_head *root)
> >> +{
> >> +     struct vgic_dist *dist = &kvm->arch.vgic;
> >> +     struct irq_phys_map_entry *entry;
> >> +
> >> +     spin_lock(&dist->irq_phys_map_lock);
> >> +
> >> +     list_for_each_entry(entry, root, entry) {
> >> +             if (!entry->map.deleted) {
> >> +                     entry->map.deleted = true;
> >> +                     list_del_rcu(&entry->entry);
> >> +                     call_rcu(&entry->rcu, vgic_free_phys_irq_map_rcu);
> >> +             }
> >> +     }
> >> +
> >> +     spin_unlock(&dist->irq_phys_map_lock);
> >> +}
> >> +
> >>  void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
> >>  {
> >>       struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> >> @@ -1591,6 +1754,7 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
> >>       kfree(vgic_cpu->active_shared);
> >>       kfree(vgic_cpu->pend_act_shared);
> >>       kfree(vgic_cpu->vgic_irq_lr_map);
> >> +     vgic_destroy_irq_phys_map(vcpu->kvm, &vgic_cpu->irq_phys_map_list);
> >>       vgic_cpu->pending_shared = NULL;
> >>       vgic_cpu->active_shared = NULL;
> >>       vgic_cpu->pend_act_shared = NULL;
> >> @@ -1628,6 +1792,17 @@ static int vgic_vcpu_init_maps(struct kvm_vcpu *vcpu, int nr_irqs)
> >>  }
> >>
> >>  /**
> >> + * kvm_vgic_vcpu_early_init - Earliest possible per-vcpu vgic init stage
> > 
> > earliest possible... oh how I love the vgic code.
> > 
> 
> You must be the only one! ;-)
> 
> > If you have the energy and context to write a comment in the beginning
> > of this file describing the init flow, I think that would be useful...
> > 
> 
> How about starting with this?
> 
> <quote>
> There are multiple stages to the vgic initialization, both for the
> distributor and the CPU interfaces.
> 
> Distributor:
> 
> - kvm_vgic_early_init(): initialization of static data that doesn't
> depend on any sizing information or emulation type. No allocation is
> allowed there.
> 
> - vgic_init(): allocation and initialization of the generic data
> structures that depend on sizing information (number of CPUs, number of
> interrupts). Also initializes the vcpu specific data structures. Can be
> executed lazily for GICv2. [to be renamed to kvm_vgic_init??]
> 
> CPU Interface:
> 
> - kvm_vgic_cpu_early_init(): initialization of static data that doesn't
> depend on any sizing information or emulation type. No allocation is
> allowed there.
> </quote>
> 
> I'm sure we can expand it as we go...
> 

yes, this is great, it made me feel comfortable with the whole thing.
Thanks!

> >> + *
> >> + * No memory allocation should be performed here, only static init.
> >> + */
> >> +void kvm_vgic_vcpu_early_init(struct kvm_vcpu *vcpu)
> >> +{
> >> +     struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> >> +     INIT_LIST_HEAD(&vgic_cpu->irq_phys_map_list);
> >> +}
> >> +
> >> +/**
> >>   * kvm_vgic_get_max_vcpus - Get the maximum number of VCPUs allowed by HW
> >>   *
> >>   * The host's GIC naturally limits the maximum amount of VCPUs a guest
> >> @@ -1664,6 +1839,7 @@ void kvm_vgic_destroy(struct kvm *kvm)
> >>       kfree(dist->irq_spi_target);
> >>       kfree(dist->irq_pending_on_cpu);
> >>       kfree(dist->irq_active_on_cpu);
> >> +     vgic_destroy_irq_phys_map(kvm, &dist->irq_phys_map_list);
> >>       dist->irq_sgi_sources = NULL;
> >>       dist->irq_spi_cpu = NULL;
> >>       dist->irq_spi_target = NULL;
> >> @@ -1787,6 +1963,18 @@ static int init_vgic_model(struct kvm *kvm, int type)
> >>       return 0;
> >>  }
> >>
> >> +/**
> >> + * kvm_vgic_early_init - Earliest possible vgic initialization stage
> >> + *
> >> + * No memory allocation should be performed here, only static init.
> >> + */
> >> +void kvm_vgic_early_init(struct kvm *kvm)
> >> +{
> >> +     spin_lock_init(&kvm->arch.vgic.lock);
> > 
> > so here we're initializing the data structures even before the vgic is
> > created, right?  So therefore it's safe to move the vgic.lock init up
> > here?
> 
> Yes. The distributor structure is part of the struct kvm, hence safe to
> poke early on. This doesn't depend on any form of sizing or emulation
> type either.
> 

ok, slight warm fuzzy feeling.

Thanks,
-Christoffer
