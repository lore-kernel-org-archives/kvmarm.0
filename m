From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v4 13/22] KVM: arm64: ITS: KVM_DEV_ARM_VGIC_GRP_ITS_TABLES
 group
Date: Mon, 27 Mar 2017 20:29:07 +0200
Message-ID: <0d43e874-c443-7d55-b741-ce27bd103cb5@redhat.com>
References: <201703272354.OaYhCMvV%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44E0F40AF5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 14:27:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BHa4qnflm8Or for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Mar 2017 14:27:17 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0F43940A66
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 14:27:16 -0400 (EDT)
In-Reply-To: <201703272354.OaYhCMvV%fengguang.wu@intel.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kbuild test robot <lkp@intel.com>
Cc: kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, marc.zyngier@arm.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, vijayak@caviumnetworks.com, kbuild-all@01.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 27/03/2017 17:04, kbuild test robot wrote:
> Hi Eric,
> 
> [auto build test ERROR on kvmarm/next]
> [also build test ERROR on v4.11-rc4 next-20170327]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Eric-Auger/vITS-save-restore/20170327-195443
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
> config: arm64-defconfig (attached as .config)
> compiler: aarch64-linux-gnu-gcc (Debian 6.1.1-9) 6.1.1 20160705
> reproduce:
>         wget https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=arm64 
> 
> All errors (new ones prefixed by >>):
> 
>    arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-its.c: In function 'vgic_its_has_attr':
>>> arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-its.c:1766:33: error: 'its' undeclared (first use in this function)
>       return vgic_its_table_restore(its);

I think this is due to the fact the series is applied on KVM: arm/arm64:
Emulate the EL1 phys timer registers (kvmarm-for-4.11).

Please apply it to (kvmarm/queue, kvmarm/next, kvm_next) KVM: arm/arm64:
vgic: Improve sync_hwstate performance  (255905e)
I also checked it compiles on 4.11-rc4.

Please let me know if I got something wrong.

Thanks

Eric
>                                     ^~~
>    arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-its.c:1766:33: note: each undeclared identifier is reported only once for each function it appears in
> 
> vim +/its +1766 arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-its.c
> 
>   1750			case KVM_DEV_ARM_VGIC_CTRL_INIT:
>   1751				return 0;
>   1752			}
>   1753			break;
>   1754		case KVM_DEV_ARM_VGIC_GRP_ITS_REGS: {
>   1755			u64 __user *uaddr = (u64 __user *)(long)attr->addr;
>   1756			u64 reg;
>   1757	
>   1758			if (get_user(reg, uaddr))
>   1759				return -EFAULT;
>   1760	
>   1761			return vgic_its_attr_regs_access(dev, attr, &reg, true);
>   1762		}
>   1763		case KVM_DEV_ARM_VGIC_GRP_ITS_TABLES:
>   1764			if (attr->attr)
>   1765				return -EINVAL;
>> 1766			return vgic_its_table_restore(its);
>   1767		}
>   1768		return -ENXIO;
>   1769	}
>   1770	
>   1771	static int vgic_its_set_attr(struct kvm_device *dev,
>   1772				     struct kvm_device_attr *attr)
>   1773	{
>   1774		struct vgic_its *its = dev->private;
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
