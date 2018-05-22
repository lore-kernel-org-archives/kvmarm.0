From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v7 08/13] KVM: arm/arm64: Remove kvm_vgic_vcpu_early_init
Date: Tue, 22 May 2018 14:22:15 +0200
Message-ID: <b03bedea-5eac-ef9b-7e6f-d200509d8535@redhat.com>
References: <1526851372-13009-9-git-send-email-eric.auger@redhat.com>
 <201805221850.wnnX64nq%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201805221850.wnnX64nq%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@arm.com, peter.maydell@linaro.org, andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 05/22/2018 02:10 PM, kbuild test robot wrote:
> Hi Eric,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on kvmarm/next]
> [also build test WARNING on v4.17-rc6 next-20180517]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Eric-Auger/KVM-arm-arm64-Allow-multiple-GICv3-redistributor-regions/20180522-004717
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
> config: arm-axm55xx_defconfig (attached as .config)
> compiler: arm-linux-gnueabi-gcc (Debian 7.2.0-11) 7.2.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=arm 
> 
> Note: it may well be a FALSE warning. FWIW you are at least aware of it now.
> http://gcc.gnu.org/wiki/Better_Uninitialized_Warnings
> 
> All warnings (new ones prefixed by >>):
> 
>    arch/arm/kvm/../../../virt/kvm/arm/vgic/vgic-init.c: In function 'kvm_vgic_vcpu_init':
>>> arch/arm/kvm/../../../virt/kvm/arm/vgic/vgic-init.c:199:9: warning: 'ret' may be used uninitialized in this function [-Wmaybe-uninitialized]
>      int i, ret;

Fixed in v8, sent this morning. Sorry for the inconvenience.

Thanks

Eric
>             ^~~
> 
> vim +/ret +199 arch/arm/kvm/../../../virt/kvm/arm/vgic/vgic-init.c
> 
>    185	
>    186	/**
>    187	 * kvm_vgic_vcpu_init() - Initialize static VGIC VCPU data
>    188	 * structures and register VCPU-specific KVM iodevs
>    189	 *
>    190	 * @vcpu: pointer to the VCPU being created and initialized
>    191	 *
>    192	 * Only do initialization, but do not actually enable the
>    193	 * VGIC CPU interface
>    194	 */
>    195	int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
>    196	{
>    197		struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>    198		struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>  > 199		int i, ret;
>    200	
>    201		INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
>    202		spin_lock_init(&vgic_cpu->ap_list_lock);
>    203	
>    204		/*
>    205		 * Enable and configure all SGIs to be edge-triggered and
>    206		 * configure all PPIs as level-triggered.
>    207		 */
>    208		for (i = 0; i < VGIC_NR_PRIVATE_IRQS; i++) {
>    209			struct vgic_irq *irq = &vgic_cpu->private_irqs[i];
>    210	
>    211			INIT_LIST_HEAD(&irq->ap_list);
>    212			spin_lock_init(&irq->irq_lock);
>    213			irq->intid = i;
>    214			irq->vcpu = NULL;
>    215			irq->target_vcpu = vcpu;
>    216			irq->targets = 1U << vcpu->vcpu_id;
>    217			kref_init(&irq->refcount);
>    218			if (vgic_irq_is_sgi(i)) {
>    219				/* SGIs */
>    220				irq->enabled = 1;
>    221				irq->config = VGIC_CONFIG_EDGE;
>    222			} else {
>    223				/* PPIs */
>    224				irq->config = VGIC_CONFIG_LEVEL;
>    225			}
>    226		}
>    227	
>    228		if (!irqchip_in_kernel(vcpu->kvm))
>    229			return 0;
>    230	
>    231		/*
>    232		 * If we are creating a VCPU with a GICv3 we must also register the
>    233		 * KVM io device for the redistributor that belongs to this VCPU.
>    234		 */
>    235		if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
>    236			mutex_lock(&vcpu->kvm->lock);
>    237			ret = vgic_register_redist_iodev(vcpu);
>    238			mutex_unlock(&vcpu->kvm->lock);
>    239		}
>    240		return ret;
>    241	}
>    242	
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 
