From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v2 32/54] KVM: arm/arm64: vgic-new: Add GICv3 MMIO
 handling framework
Date: Fri, 29 Apr 2016 15:04:32 +0100
Message-ID: <572369F0.20704@arm.com>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
 <1461861973-26464-33-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1461861973-26464-33-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

On 28/04/16 17:45, Andre Przywara wrote:
> +int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t redist_base_address)
> +{
> +	int nr_vcpus = atomic_read(&kvm->online_vcpus);
> +	struct kvm_vcpu *vcpu;
> +	struct vgic_io_device *devices, *device;
> +	int c, ret = 0;
> +
> +	devices = kmalloc(sizeof(struct vgic_io_device) * nr_vcpus * 2,
> +			  GFP_KERNEL);
> +	if (!devices)
> +		return -ENOMEM;
> +
> +	device = devices;
> +	kvm_for_each_vcpu(c, vcpu, kvm) {
> +		kvm_iodevice_init(&device->dev, &kvm_io_gic_ops);
> +		device->base_addr = redist_base_address;
> +		device->regions = vgic_v3_redist_registers;
> +		device->nr_regions = ARRAY_SIZE(vgic_v3_redist_registers);
> +		device->redist_vcpu = vcpu;
> +
> +		mutex_lock(&kvm->slots_lock);
> +		ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS,
> +					      redist_base_address,
> +					      SZ_64K, &device->dev);
> +		mutex_unlock(&kvm->slots_lock);
> +
> +		if (ret)
> +			break;
> +
> +		device++;
> +		kvm_iodevice_init(&device->dev, &kvm_io_gic_ops);
> +		device->base_addr = redist_base_address + SZ_64K;
> +		device->regions = vgic_v3_private_registers;
> +		device->nr_regions = ARRAY_SIZE(vgic_v3_private_registers);
> +		device->redist_vcpu = vcpu;
> +
> +		mutex_lock(&kvm->slots_lock);
> +		ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS,
> +					      redist_base_address + SZ_64K,
> +					      SZ_64K, &device->dev);
> +		mutex_unlock(&kvm->slots_lock);
> +		if (ret) {
> +			kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
> +						  &devices[c * 2].dev);
> +			break;
> +		}
> +		device++;
> +		redist_base_address += 2 * SZ_64K;
> +	}

Can we put cond_resched() somewhere in kvm_for_each_vcpu to avoid
complains with CONFIG_PREEMPT_NONE=y and many many cpus been used?

>   # lkvm run -k gic-test.flat.a64 -m 316 -c 255 --name guest-727
>   Info: Loaded kernel to 0x80080000 (69624 bytes)
>   Info: Placing fdt at 0x8fe00000 - 0x8fffffff
>   # Warning: The maximum recommended amount of VCPUs is 4
>   Info: virtio-mmio.devices=0x200@0x10000:36
> 
>   Info: virtio-mmio.devices=0x200@0x10200:37
> 
>   Info: virtio-mmio.devices=0x200@0x10400:38
> 
>   Info: virtio-mmio.devices=0x200@0x10600:39
> 
> INFO: rcu_sched self-detected stall on CPU
>  0-...: (5249 ticks this GP) idle=589/140000000000001/0 softirq=393/393 fqs=5244 
>   (t=5250 jiffies g=-166 c=-167 q=0)
> Task dump for CPU 0:
> kvm-vcpu-0      R  running task        0   735      1 0x00000002
> Call trace:
> [<ffffff8008088cc4>] dump_backtrace+0x0/0x194
> [<ffffff8008088e6c>] show_stack+0x14/0x1c
> [<ffffff80080d4dd0>] sched_show_task+0xa4/0xe8
> [<ffffff80080d6ddc>] dump_cpu_task+0x40/0x4c
> [<ffffff80080fd398>] rcu_dump_cpu_stacks+0xa8/0xdc
> [<ffffff8008100214>] rcu_check_callbacks+0x28c/0x7a4
> [<ffffff80081034a8>] update_process_times+0x3c/0x68
> [<ffffff8008111820>] tick_sched_handle.isra.15+0x50/0x60
> [<ffffff8008111874>] tick_sched_timer+0x44/0x7c
> [<ffffff8008103bf8>] __hrtimer_run_queues+0xc8/0x150
> [<ffffff8008104110>] hrtimer_interrupt+0x9c/0x1b0
> [<ffffff80083b8b74>] arch_timer_handler_phys+0x2c/0x38
> [<ffffff80080f6d14>] handle_percpu_devid_irq+0x78/0x98
> [<ffffff80080f2a2c>] generic_handle_irq+0x24/0x38
> [<ffffff80080f2d98>] __handle_domain_irq+0x84/0xa8
> [<ffffff80080825e0>] gic_handle_irq+0x74/0x178
> Exception stack(0xffffffc0173e3830 to 0xffffffc0173e3950)
> 3820:                                   ffffffc0165ac038 ffffffc0165ac080
> 3840: 0000000000000018 0000000000000004 0000000000000014 000000000000003f
> 3860: ffffffc0165aeea8 ffffffc000010000 ffffffc017ef5af0 ffffffc0173ecd28
> 3880: 000000003fef0000 cfdfdfdf00010000 ffffffc0173ecd50 000000003ff00000
> 38a0: cfdfdfdf00010000 0000000000000000 ffffff80081acaf0 0000000000000000
> 38c0: 0000000000000000 00000000000000f0 ffffffc0165ac008 0000000000000018
> 38e0: ffffff80080992e8 0000000000000078 ffffff8008276b54 0000000000002970
> 3900: 0000000000000018 ffffffc0165ac080 ffffffc0165ac038 ffffffc0173e3950
> 3920: ffffff8008276d8c ffffffc0173e3950 ffffff8008276b58 0000000020000145
> 3940: 0000000000000000 0000000000000001
> [<ffffff8008084f20>] el1_irq+0xa0/0x100
> [<ffffff8008276b58>] generic_swap+0x4/0x28
> [<ffffff800809e108>] kvm_io_bus_register_dev+0xc8/0x110
> [<ffffff80080ab054>] vgic_register_redist_iodevs+0xd8/0x20c
> [<ffffff80080a98f8>] vgic_v3_map_resources+0x98/0xec
> [<ffffff80080a8cd8>] kvm_vgic_map_resources+0x4c/0x6c
> [<ffffff80080a06d4>] kvm_arch_vcpu_ioctl_run+0x68/0x424
> [<ffffff800809bc98>] kvm_vcpu_ioctl+0x1b4/0x6f8
> [<ffffff80081aca98>] do_vfs_ioctl+0x708/0x760
> [<ffffff80081acb4c>] SyS_ioctl+0x5c/0x8c
> [<ffffff8008085630>] el0_svc_naked+0x24/0x28

Cheers
Vladimir
