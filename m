From: Tomasz Nowicki <tnowicki@caviumnetworks.com>
Subject: Re: [PATCH v3 00/41] Optimize KVM/ARM for VHE systems
Date: Mon, 22 Jan 2018 14:40:29 +0100
Message-ID: <bff8c9e3-6821-0ad3-4a7d-804f13027569@caviumnetworks.com>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180115141423.5qho7xvmikq27jvs@yury-thinkpad>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180115141423.5qho7xvmikq27jvs@yury-thinkpad>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Yury Norov <ynorov@caviumnetworks.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Sunil Goutham <Sunil.Goutham@cavium.com>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Yury,

On 15.01.2018 15:14, Yury Norov wrote:
> Hi Christoffer,
> 
> [CC Sunil Goutham <Sunil.Goutham@cavium.com>]
> 
> On Fri, Jan 12, 2018 at 01:07:06PM +0100, Christoffer Dall wrote:
>> This series redesigns parts of KVM/ARM to optimize the performance on
>> VHE systems.  The general approach is to try to do as little work as
>> possible when transitioning between the VM and the hypervisor.  This has
>> the benefit of lower latency when waiting for interrupts and delivering
>> virtual interrupts, and reduces the overhead of emulating behavior and
>> I/O in the host kernel.
>>
>> Patches 01 through 06 are not VHE specific, but rework parts of KVM/ARM
>> that can be generally improved.  We then add infrastructure to move more
>> logic into vcpu_load and vcpu_put, we improve handling of VFP and debug
>> registers.
>>
>> We then introduce a new world-switch function for VHE systems, which we
>> can tweak and optimize for VHE systems.  To do that, we rework a lot of
>> the system register save/restore handling and emulation code that may
>> need access to system registers, so that we can defer as many system
>> register save/restore operations to vcpu_load and vcpu_put, and move
>> this logic out of the VHE world switch function.
>>
>> We then optimize the configuration of traps.  On non-VHE systems, both
>> the host and VM kernels run in EL1, but because the host kernel should
>> have full access to the underlying hardware, but the VM kernel should
>> not, we essentially make the host kernel more privileged than the VM
>> kernel despite them both running at the same privilege level by enabling
>> VE traps when entering the VM and disabling those traps when exiting the
>> VM.  On VHE systems, the host kernel runs in EL2 and has full access to
>> the hardware (as much as allowed by secure side software), and is
>> unaffected by the trap configuration.  That means we can configure the
>> traps for VMs running in EL1 once, and don't have to switch them on and
>> off for every entry/exit to/from the VM.
>>
>> Finally, we improve our VGIC handling by moving all save/restore logic
>> out of the VHE world-switch, and we make it possible to truly only
>> evaluate if the AP list is empty and not do *any* VGIC work if that is
>> the case, and only do the minimal amount of work required in the course
>> of the VGIC processing when we have virtual interrupts in flight.
>>
>> The patches are based on v4.15-rc3, v9 of the level-triggered mapped
>> interrupts support series [1], and the first five patches of James' SDEI
>> series [2].
>>
>> I've given the patches a fair amount of testing on Thunder-X, Mustang,
>> Seattle, and TC2 (32-bit) for non-VHE testing, and tested VHE
>> functionality on the Foundation model, running both 64-bit VMs and
>> 32-bit VMs side-by-side and using both GICv3-on-GICv3 and
>> GICv2-on-GICv3.
>>
>> The patches are also available in the vhe-optimize-v3 branch on my
>> kernel.org repository [3].  The vhe-optimize-v3-base branch contains
>> prerequisites of this series.
>>
>> Changes since v2:
>>   - Rebased on v4.15-rc3.
>>   - Includes two additional patches that only does vcpu_load after
>>     kvm_vcpu_first_run_init and only for KVM_RUN.
>>   - Addressed review comments from v2 (detailed changelogs are in the
>>     individual patches).
>>
>> Thanks,
>> -Christoffer
>>
>> [1]: git://git.kernel.org/pub/scm/linux/kernel/git/cdall/linux.git level-mapped-v9
>> [2]: git://linux-arm.org/linux-jm.git sdei/v5/base
>> [3]: git://git.kernel.org/pub/scm/linux/kernel/git/cdall/linux.git vhe-optimize-v3
> 
> I tested this v3 series on ThunderX2 with IPI benchmark:
> https://lkml.org/lkml/2017/12/11/364
> 
> I tried to address your comments in discussion to v2, like pinning
> the module to specific CPU (with taskset), increasing the number of
> iterations, tuning governor to max performance. Results didn't change
> much, and are pretty stable.
> 
> Comparing to vanilla guest, Norml IPI delivery for v3 is 20% slower.
> For v2 it was 27% slower, and for v1 - 42% faster. What's interesting,
> the acknowledge time is much faster for v3, so overall time to
> deliver and acknowledge IPI (2nd column) is less than vanilla
> 4.15-rc3 kernel.
> 
> Test setup is not changed since v2: ThunderX2, 112 online CPUs,
> guest is running under qemu-kvm, emulating gic version 3.
> 
> Below is test results for v1-3 normalized to host vanilla kernel
> dry-run time.
> 
> Yury
> 
> Host, v4.14:
> Dry-run:          0         1
> Self-IPI:         9        18
> Normal IPI:      81       110
> Broadcast IPI:    0      2106
> 
> Guest, v4.14:
> Dry-run:          0         1
> Self-IPI:        10        18
> Normal IPI:     305       525
> Broadcast IPI:    0      9729
> 
> Guest, v4.14 + VHE:
> Dry-run:          0         1
> Self-IPI:         9        18
> Normal IPI:     176       343
> Broadcast IPI:    0      9885
> 
> And for v2.
> 
> Host, v4.15:
> Dry-run:          0         1
> Self-IPI:         9        18
> Normal IPI:      79       108
> Broadcast IPI:    0      2102
>                          
> Guest, v4.15-rc:
> Dry-run:          0         1
> Self-IPI:         9        18
> Normal IPI:     291       526
> Broadcast IPI:    0     10439
> 
> Guest, v4.15-rc + VHE:
> Dry-run:          0         2
> Self-IPI:        14        28
> Normal IPI:     370       569
> Broadcast IPI:    0     11688
> 
> And for v3.
> 
> Host 4.15-rc3					
> Dry-run:	  0	    1
> Self-IPI:	  9	   18
> Normal IPI:	 80	  110
> Broadcast IPI:	  0	 2088
> 		
> Guest, 4.15-rc3	
> Dry-run:	  0	    1
> Self-IPI:	  9	   18
> Normal IPI:	289	  497
> Broadcast IPI:	  0	 9999
> 		
> Guest, 4.15-rc3	+ VHE
> Dry-run:	  0	    2
> Self-IPI:	 12	   24
> Normal IPI:	347	  490
> Broadcast IPI:	  0	11906

As I reported here:
https://patchwork.kernel.org/patch/10125537/
this might be because of WFI exits storm. Can you please check KVM exits 
stats for completely idle VM ? Also, wait time from kvm_vcpu_wakeup() 
trace point will be useful. I got lots of these:
kvm_vcpu_wakeup: poll time 0 ns, polling valid

Thanks,
Tomasz
