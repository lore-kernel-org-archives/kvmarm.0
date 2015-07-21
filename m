From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 06/10] KVM: arm/arm64: vgic: Allow dynamic mapping
 of physical/virtual interrupts
Date: Tue, 21 Jul 2015 18:17:09 +0100
Message-ID: <55AE7E95.2020608@arm.com>
References: <1436378202-20224-1-git-send-email-marc.zyngier@arm.com> <1436378202-20224-7-git-send-email-marc.zyngier@arm.com> <20150717211105.GF14024@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150717211105.GF14024@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Eric Auger <eric.auger@linaro.org>, =?windows-1252?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 17/07/15 22:11, Christoffer Dall wrote:
> On Wed, Jul 08, 2015 at 06:56:38PM +0100, Marc Zyngier wrote:
>> In order to be able to feed physical interrupts to a guest, we need
>> to be able to establish the virtual-physical mapping between the two
>> worlds.
>>
>> The mappings are kept in a set of RCU lists, indexed by virtual interrupts.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm/kvm/arm.c     |   2 +
>>  include/kvm/arm_vgic.h |  25 +++++++++
>>  virt/kvm/arm/vgic.c    | 144 ++++++++++++++++++++++++++++++++++++++++++++++++-
>>  3 files changed, 170 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>> index 1583a34..d5ce5cc 100644
>> --- a/arch/arm/kvm/arm.c
>> +++ b/arch/arm/kvm/arm.c
>> @@ -125,6 +125,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>       if (ret)
>>               goto out_free_stage2_pgd;
>>
>> +     kvm_vgic_init(kvm);
>>       kvm_timer_init(kvm);
>>
>>       /* Mark the initial VMID generation invalid */
>> @@ -249,6 +250,7 @@ out:
>>
>>  void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>>  {
>> +     kvm_vgic_vcpu_postcreate(vcpu);
>>  }
>>
>>  void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index 4f9fa1d..32e57d2 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -159,6 +159,19 @@ struct vgic_io_device {
>>       struct kvm_io_device dev;
>>  };
>>
>> +struct irq_phys_map {
>> +     u32                     virt_irq;
>> +     u32                     phys_irq;
>> +     u32                     irq;
>> +     bool                    active;
>> +};
>> +
>> +struct irq_phys_map_entry {
>> +     struct list_head        entry;
>> +     struct rcu_head         rcu;
>> +     struct irq_phys_map     map;
>> +};
>> +
>>  struct vgic_dist {
>>       spinlock_t              lock;
>>       bool                    in_kernel;
>> @@ -256,6 +269,10 @@ struct vgic_dist {
>>       struct vgic_vm_ops      vm_ops;
>>       struct vgic_io_device   dist_iodev;
>>       struct vgic_io_device   *redist_iodevs;
>> +
>> +     /* Virtual irq to hwirq mapping */
>> +     spinlock_t              irq_phys_map_lock;
>> +     struct list_head        irq_phys_map_list;
>>  };
>>
>>  struct vgic_v2_cpu_if {
>> @@ -307,6 +324,9 @@ struct vgic_cpu {
>>               struct vgic_v2_cpu_if   vgic_v2;
>>               struct vgic_v3_cpu_if   vgic_v3;
>>       };
>> +
>> +     /* Protected by the distributor's irq_phys_map_lock */
>> +     struct list_head        irq_phys_map_list;
>>  };
>>
>>  #define LR_EMPTY     0xff
>> @@ -321,8 +341,10 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
>>  int kvm_vgic_hyp_init(void);
>>  int kvm_vgic_map_resources(struct kvm *kvm);
>>  int kvm_vgic_get_max_vcpus(void);
>> +void kvm_vgic_init(struct kvm *kvm);
>>  int kvm_vgic_create(struct kvm *kvm, u32 type);
>>  void kvm_vgic_destroy(struct kvm *kvm);
>> +void kvm_vgic_vcpu_postcreate(struct kvm_vcpu *vcpu);
>>  void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu);
>>  void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu);
>>  void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
>> @@ -331,6 +353,9 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
>>  void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
>>  int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
>>  int kvm_vgic_vcpu_active_irq(struct kvm_vcpu *vcpu);
>> +struct irq_phys_map *vgic_map_phys_irq(struct kvm_vcpu *vcpu,
>> +                                    int virt_irq, int irq);
>> +int vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
> 
> should these functions not have a kvm_ prefix?

Guess that'd be a good idea - VFIO will probably have to use them somehow.

>>  #define irqchip_in_kernel(k) (!!((k)->arch.vgic.in_kernel))
>>  #define vgic_initialized(k)  (!!((k)->arch.vgic.nr_cpus))
>> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
>> index 5bd1695..3424329 100644
>> --- a/virt/kvm/arm/vgic.c
>> +++ b/virt/kvm/arm/vgic.c
>> @@ -24,6 +24,7 @@
>>  #include <linux/of.h>
>>  #include <linux/of_address.h>
>>  #include <linux/of_irq.h>
>> +#include <linux/rculist.h>
>>  #include <linux/uaccess.h>
>>
>>  #include <asm/kvm_emulate.h>
>> @@ -82,6 +83,8 @@ static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu);
>>  static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu);
>>  static struct vgic_lr vgic_get_lr(const struct kvm_vcpu *vcpu, int lr);
>>  static void vgic_set_lr(struct kvm_vcpu *vcpu, int lr, struct vgic_lr lr_desc);
>> +static struct irq_phys_map *vgic_irq_map_search(struct kvm_vcpu *vcpu,
>> +                                             int virt_irq);
>>
>>  static const struct vgic_ops *vgic_ops;
>>  static const struct vgic_params *vgic;
>> @@ -1583,6 +1586,131 @@ static irqreturn_t vgic_maintenance_handler(int irq, void *data)
>>       return IRQ_HANDLED;
>>  }
>>
>> +static struct list_head *vgic_get_irq_phys_map(struct kvm_vcpu *vcpu,
>> +                                            int virt_irq)
>> +{
>> +     if (virt_irq < VGIC_NR_PRIVATE_IRQS)
>> +             return &vcpu->arch.vgic_cpu.irq_phys_map_list;
>> +     else
>> +             return &vcpu->kvm->arch.vgic.irq_phys_map_list;
>> +}
>> +
> 
> You know what I'm going to ask you for here, but let me help out with
> the framwork:
> 
> /**
>  * vgic_map_phys_irq - map a virtual IRQ to a physical IRQ
>  * @vcpu: The VCPU pointer
>  * @virt_irq: The virtual irq number
>  * @irq: The Linux IRQ number
>  *
>  *
>  */

You're making it to easy! ;-)

>> +struct irq_phys_map *vgic_map_phys_irq(struct kvm_vcpu *vcpu,
>> +                                    int virt_irq, int irq)
>> +{
>> +     struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>> +     struct list_head *root = vgic_get_irq_phys_map(vcpu, virt_irq);
>> +     struct irq_phys_map *map;
>> +     struct irq_phys_map_entry *entry;
>> +     struct irq_desc *desc;
>> +     struct irq_data *data;
>> +     int phys_irq;
>> +
>> +     desc = irq_to_desc(irq);
>> +     if (!desc) {
>> +             kvm_err("kvm_arch_timer: can't obtain interrupt descriptor\n");
> 
> arch_timer?  this is vgic code, no?

-ECUTnPASTE, I'll fix that.

>> +             return NULL;
>> +     }
>> +
>> +     data = irq_desc_get_irq_data(desc);
>> +     while (data->parent_data)
>> +             data = data->parent_data;
>> +
>> +     phys_irq = data->hwirq;
>> +
>> +     spin_lock(&dist->irq_phys_map_lock);
>> +
>> +     /* Try to match an existing mapping */
>> +     map = vgic_irq_map_search(vcpu, virt_irq);
>> +     if (map) {
>> +             /* Make sure this mapping matches */
>> +             if (map->phys_irq != phys_irq   ||
>> +                 map->irq      != irq)
> 
> when would this happen?  Is this something that should gracefully just
> be accepted or is it a bug?

This is definitely a bug, hence the NULL value being returned. There is
already an existing mapping for this virtual interrupt, and the caller
should handle the problem.

>> +                     map = NULL;
>> +
>> +             goto out;
>> +     }
>> +
>> +     /* Create a new mapping */
>> +     entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
> 
> is GFP_ATOMIC really warranted here?  The situatotion where you have an
> existing map is extremely rare, I suppose, and is in fact an error, so
> you could just pre-allocate and free on error.

Good point.

>> +     if (!entry)
> 
> Here you seem to be returning a valid value on an error?  Perhaps you
> should return ERR_PTR(-ENOMEM) and generally use ERR_PTR/PTR_ERR here.

Indeed, that'd be nicer.

>> +             goto out;
>> +
>> +     map           = &entry->map;
>> +     map->virt_irq = virt_irq;
>> +     map->phys_irq = phys_irq;
>> +     map->irq      = irq;
>> +
>> +     list_add_tail_rcu(&entry->entry, root);
>> +
>> +out:
>> +     spin_unlock(&dist->irq_phys_map_lock);
>> +     return map;
>> +}
>> +
>> +static struct irq_phys_map *vgic_irq_map_search(struct kvm_vcpu *vcpu,
>> +                                             int virt_irq)
>> +{
>> +     struct list_head *root = vgic_get_irq_phys_map(vcpu, virt_irq);
>> +     struct irq_phys_map_entry *entry;
>> +     struct irq_phys_map *map;
>> +
>> +     rcu_read_lock();
>> +
>> +     list_for_each_entry_rcu(entry, root, entry) {
>> +             map = &entry->map;
>> +             if (map->virt_irq == virt_irq) {
>> +                     rcu_read_unlock();
>> +                     return map;
>> +             }
>> +     }
>> +
>> +     rcu_read_unlock();
>> +
>> +     return NULL;
>> +}
>> +
>> +static void vgic_free_phys_irq_map_rcu(struct rcu_head *rcu)
>> +{
>> +     struct irq_phys_map_entry *entry;
>> +
>> +     entry = container_of(rcu, struct irq_phys_map_entry, rcu);
>> +     kfree(entry);
>> +}
>> +
>> +int vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map)
>> +{
>> +     struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>> +     struct irq_phys_map_entry *entry;
>> +
>> +     if (!map)
>> +             return -EINVAL;
>> +
>> +     entry = container_of(map, struct irq_phys_map_entry, map);
> 
> could this race with vgic_destroy_irq_phys_map, such that
> vgic_destroy_irq_phys_map removes the entry from the list while we're
> spinning on the lock, and then when we proceed we free the entry twice?

Hmmm. That's nasty. I guess that the only way around this is to parse
the list, looking for that particular entry. If destroy already
happened, we won't find it, catastrophy avoided.

>> +
>> +     spin_lock(&dist->irq_phys_map_lock);
>> +     list_del_rcu(&entry->entry);
>> +     call_rcu(&entry->rcu, vgic_free_phys_irq_map_rcu);
>> +     spin_unlock(&dist->irq_phys_map_lock);
>> +
>> +     return 0;
>> +}
>> +
>> +static void vgic_destroy_irq_phys_map(struct kvm *kvm, struct list_head *root)
>> +{
>> +     struct vgic_dist *dist = &kvm->arch.vgic;
>> +     struct irq_phys_map_entry *entry;
>> +
>> +     spin_lock(&dist->irq_phys_map_lock);
>> +
>> +     list_for_each_entry(entry, root, entry) {
>> +             list_del_rcu(&entry->entry);
>> +             call_rcu(&entry->rcu, vgic_free_phys_irq_map_rcu);
>> +     }
>> +
>> +     spin_unlock(&dist->irq_phys_map_lock);
>> +}
>> +
>>  void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
>>  {
>>       struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>> @@ -1591,6 +1719,7 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
>>       kfree(vgic_cpu->active_shared);
>>       kfree(vgic_cpu->pend_act_shared);
>>       kfree(vgic_cpu->vgic_irq_lr_map);
>> +     vgic_destroy_irq_phys_map(vcpu->kvm, &vgic_cpu->irq_phys_map_list);
>>       vgic_cpu->pending_shared = NULL;
>>       vgic_cpu->active_shared = NULL;
>>       vgic_cpu->pend_act_shared = NULL;
>> @@ -1627,6 +1756,12 @@ static int vgic_vcpu_init_maps(struct kvm_vcpu *vcpu, int nr_irqs)
>>       return 0;
>>  }
>>
>> +void kvm_vgic_vcpu_postcreate(struct kvm_vcpu *vcpu)
>> +{
>> +     struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>> +     INIT_LIST_HEAD(&vgic_cpu->irq_phys_map_list);
> 
> can you do this as part of vgic_init?

No, there is a horrible race with vgic_init which can be lazy (at least
with GICv2). In the interval, the timer code will try and register its
interrupt mapping. Pain will follow.

>> +}
>> +
>>  /**
>>   * kvm_vgic_get_max_vcpus - Get the maximum number of VCPUs allowed by HW
>>   *
>> @@ -1664,6 +1799,7 @@ void kvm_vgic_destroy(struct kvm *kvm)
>>       kfree(dist->irq_spi_target);
>>       kfree(dist->irq_pending_on_cpu);
>>       kfree(dist->irq_active_on_cpu);
>> +     vgic_destroy_irq_phys_map(kvm, &dist->irq_phys_map_list);
>>       dist->irq_sgi_sources = NULL;
>>       dist->irq_spi_cpu = NULL;
>>       dist->irq_spi_target = NULL;
>> @@ -1787,6 +1923,13 @@ static int init_vgic_model(struct kvm *kvm, int type)
>>       return 0;
>>  }
>>
>> +void kvm_vgic_init(struct kvm *kvm)
>> +{
>> +     spin_lock_init(&kvm->arch.vgic.lock);
>> +     spin_lock_init(&kvm->arch.vgic.irq_phys_map_lock);
>> +     INIT_LIST_HEAD(&kvm->arch.vgic.irq_phys_map_list);
> 
> why can we not do this as part of kvm_vgic_create?

For the same reason as above. The spinlock must be initialized early
enough for the timer (or any other subsystem) code to call the map
function and register its interrupts.

> at least we need to think about naming here or document clearly what the
> various init functions do; it is not clear what the difference between
> vgic_init and kvm_vgic_init is...

Agreed, this is a bit of a mess. I'll try to come up with a list of init
functions, their expected execution order, and what is guaranteed at
which stage.

>> +}
>> +
>>  int kvm_vgic_create(struct kvm *kvm, u32 type)
>>  {
>>       int i, vcpu_lock_idx = -1, ret;
>> @@ -1832,7 +1975,6 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>>       if (ret)
>>               goto out_unlock;
>>
>> -     spin_lock_init(&kvm->arch.vgic.lock);
>>       kvm->arch.vgic.in_kernel = true;
>>       kvm->arch.vgic.vgic_model = type;
>>       kvm->arch.vgic.vctrl_base = vgic->vctrl_base;
>> --
>> 2.1.4
>>
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
