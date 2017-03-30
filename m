From: Ye Xiaolong <xiaolong.ye@intel.com>
Subject: Re: [kbuild-all] [PATCH v4 13/22] KVM: arm64: ITS:
 KVM_DEV_ARM_VGIC_GRP_ITS_TABLES group
Date: Thu, 30 Mar 2017 10:21:59 +0800
Message-ID: <20170330022159.GB15042@yexl-desktop>
References: <201703272354.OaYhCMvV%fengguang.wu@intel.com>
 <0d43e874-c443-7d55-b741-ce27bd103cb5@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0d43e874-c443-7d55-b741-ce27bd103cb5@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: kbuild test robot <lkp@intel.com>, peter.maydell@linaro.org, drjones@redhat.com, christoffer.dall@linaro.org, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, marc.zyngier@arm.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, vijayak@caviumnetworks.com, kbuild-all@01.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi, Eric

On 03/27, Auger Eric wrote:
>Hi,
>
>On 27/03/2017 17:04, kbuild test robot wrote:
>> Hi Eric,
>> 
>> [auto build test ERROR on kvmarm/next]
>> [also build test ERROR on v4.11-rc4 next-20170327]
>> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>> 
>> url:    https://github.com/0day-ci/linux/commits/Eric-Auger/vITS-save-restore/20170327-195443
>> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
>> config: arm64-defconfig (attached as .config)
>> compiler: aarch64-linux-gnu-gcc (Debian 6.1.1-9) 6.1.1 20160705
>> reproduce:
>>         wget https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>>         chmod +x ~/bin/make.cross
>>         # save the attached .config to linux build tree
>>         make.cross ARCH=arm64 
>> 
>> All errors (new ones prefixed by >>):
>> 
>>    arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-its.c: In function 'vgic_its_has_attr':
>>>> arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-its.c:1766:33: error: 'its' undeclared (first use in this function)
>>       return vgic_its_table_restore(its);
>
>I think this is due to the fact the series is applied on KVM: arm/arm64:
>Emulate the EL1 phys timer registers (kvmarm-for-4.11).
>
>Please apply it to (kvmarm/queue, kvmarm/next, kvm_next) KVM: arm/arm64:
>vgic: Improve sync_hwstate performance  (255905e)
>I also checked it compiles on 4.11-rc4.

Hmm, we did apply your series on top of kvarm/next, judging from the function
code below, I can't see the 'its' declaration. 

static int vgic_its_has_attr(struct kvm_device *dev,
                             struct kvm_device_attr *attr)
{
        switch (attr->group) {
        case KVM_DEV_ARM_VGIC_GRP_ADDR:
                switch (attr->attr) {
                case KVM_VGIC_ITS_ADDR_TYPE:
                        return 0;
                }
                break;
        case KVM_DEV_ARM_VGIC_GRP_CTRL:
                switch (attr->attr) {
                case KVM_DEV_ARM_VGIC_CTRL_INIT:
                        return 0;
                }
                break;
        case KVM_DEV_ARM_VGIC_GRP_ITS_REGS: {
                u64 __user *uaddr = (u64 __user *)(long)attr->addr;
                u64 reg;

                if (get_user(reg, uaddr))
                        return -EFAULT;

                return vgic_its_attr_regs_access(dev, attr, &reg, true);
        }
        case KVM_DEV_ARM_VGIC_GRP_ITS_TABLES:
                if (attr->attr)
                        return -EINVAL;
                return vgic_its_table_restore(its);
        }
        return -ENXIO;
}

Thanks,
Xiaolong

>
>Please let me know if I got something wrong.
>
>Thanks
>
>Eric
>>                                     ^~~
>>    arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-its.c:1766:33: note: each undeclared identifier is reported only once for each function it appears in
>> 
>> vim +/its +1766 arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-its.c
>> 
>>   1750			case KVM_DEV_ARM_VGIC_CTRL_INIT:
>>   1751				return 0;
>>   1752			}
>>   1753			break;
>>   1754		case KVM_DEV_ARM_VGIC_GRP_ITS_REGS: {
>>   1755			u64 __user *uaddr = (u64 __user *)(long)attr->addr;
>>   1756			u64 reg;
>>   1757	
>>   1758			if (get_user(reg, uaddr))
>>   1759				return -EFAULT;
>>   1760	
>>   1761			return vgic_its_attr_regs_access(dev, attr, &reg, true);
>>   1762		}
>>   1763		case KVM_DEV_ARM_VGIC_GRP_ITS_TABLES:
>>   1764			if (attr->attr)
>>   1765				return -EINVAL;
>>> 1766			return vgic_its_table_restore(its);
>>   1767		}
>>   1768		return -ENXIO;
>>   1769	}
>>   1770	
>>   1771	static int vgic_its_set_attr(struct kvm_device *dev,
>>   1772				     struct kvm_device_attr *attr)
>>   1773	{
>>   1774		struct vgic_its *its = dev->private;
>> 
>> ---
>> 0-DAY kernel test infrastructure                Open Source Technology Center
>> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
>> 
>> 
>> 
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>> 
>_______________________________________________
>kbuild-all mailing list
>kbuild-all@lists.01.org
>https://lists.01.org/mailman/listinfo/kbuild-all
