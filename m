From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH] KVM: ARM: updtae the VMID generation logic
Date: Fri, 30 Mar 2018 17:52:07 +0800
Message-ID: <5ABE08C7.3070105@huawei.com>
References: <1522335624-24332-1-git-send-email-zhaoshenglong@huawei.com>	<20180329152758.za6ppojjiw6ea52u@lakrids.cambridge.arm.com>	<861sg2su98.wl-marc.zyngier@arm.com>	<5ABD993A.8030100@huawei.com>
 <20180330100104.0a49c051@why.wild-wind.fr.eu.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020403030107030508000806"
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D414F402C7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Mar 2018 05:45:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 15ZjpsUZ6MKt for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Mar 2018 05:44:56 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 88F53401CD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Mar 2018 05:44:55 -0400 (EDT)
In-Reply-To: <20180330100104.0a49c051@why.wild-wind.fr.eu.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

--------------020403030107030508000806
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit



On 2018/3/30 17:01, Marc Zyngier wrote:
> On Fri, 30 Mar 2018 09:56:10 +0800
> Shannon Zhao <zhaoshenglong@huawei.com> wrote:
> 
>> On 2018/3/30 0:48, Marc Zyngier wrote:
>>> On Thu, 29 Mar 2018 16:27:58 +0100,
>>> Mark Rutland wrote:  
>>>>
>>>> On Thu, Mar 29, 2018 at 11:00:24PM +0800, Shannon Zhao wrote:  
>>>>> From: zhaoshenglong <zhaoshenglong@huawei.com>
>>>>>
>>>>> Currently the VMID for some VM is allocated during VCPU entry/exit
>>>>> context and will be updated when kvm_next_vmid inversion. So this will
>>>>> cause the existing VMs exiting from guest and flush the tlb and icache.
>>>>>
>>>>> Also, while a platform with 8 bit VMID supports 255 VMs, it can create
>>>>> more than 255 VMs and if we create e.g. 256 VMs, some VMs will occur
>>>>> page fault since at some moment two VMs have same VMID.  
>>>>
>>>> Have you seen this happen?
>>>>  
>> Yes, we've started 256 VMs on D05. We saw kernel page fault in some guests.
> 
> What kind of fault? Kernel configuration? Can you please share some
> traces with us? What is the workload? What happens if all the guests are
> running on the same NUMA node?
> 
> We need all the information we can get.
> 
All 256 VMs run without special workload. The testcase is just starting
256 VMs and then shutting down them. We found several VMs will not
shutdown since the guest kernel crash. While if we only start 255 VMs,
it works well.

We didn't run the testcase that pins all VMs to the same NUMA node. I'll
try.

The fault is
[ 2204.633871] Unable to handle kernel NULL pointer dereference at
virtual address 00000008
[ 2204.633875] Unable to handle kernel paging request at virtual address
a57f4a9095032

Please see the attachment for the detailed log.

>>
>>>> I beleive that update_vttbr() should prevent this. We intialize
>>>> kvm_vmid_gen to 1, and when we init a VM, we set its vmid_gen to 0. So
>>>> the first time a VM is scheduled, update_vttbr() will allocate a VMID,
>>>> and by construction we shouldn't be able to allocate the same VMID to
>>>> multiple active VMs, regardless of whether we overflow several
>>>> times.  
>>>
>>> I remember testing that exact scenario when we implemented the VMID
>>> rollover a (long) while back. Maybe we've introduced a regression, but
>>> we're supposed to support 255 VMs running at the same time (which is
>>> not the same as having 255 VMs in total).
>>>
>>> Shannon: if you have observed such regression, please let us know.
>>>   
>> Current approach could allow more than 255 VMs running at the same time.
> 
> How??? By definition, it can't.
> 
>> It doesn't prevent the extra VMs creating. So at some moment, this will
>> be a race that two VMs have same VMID when there are more than 255 VMs.
> 
> Creating additional VMs is not an issue as long as we properly:
> 
> 1) Get a new generation number
> 2) Stop all the guests
> 3) invalidate all TLBs
> 
> The above should prevent the reuse of a VMID, because all the running
> guests have a different generation number, and thus will grab a new one.
> 
> If you see two guests with the same VMID, then we have a bug in that
> logic somewhere.
> 
>>>>  
>>>>> This patch uses the bitmap to record which VMID used and available.
>>>>> Initialize the VMID and vttbr during creating the VM instead of VCPU
>>>>> entry/exit context. Also it will return error to user space if it wants
>>>>> to create VMs more than the supporting number.  
>>>>
>>>> This creates a functional regression for anyone creating a large number
>>>> of VMs.  
>>>
>>> Indeed, and I'm not buys that approach at all. As I said above, the
>>> intent is that we can have up to 2^VMID_SIZE-1 VMs running at the same
>>> time, and *any* number of VMs in the system.
>>>   
>> I think it should not allow more than 255 VMs to create since if there
>> are 256 VMs, the VMs will not running properly and will fall in the loop
>> to update VMID.
> 
> I think you're wrong.
> 
> You're trying to paper over a bug. The VMID allocation is designed to
> deal with an *infinite* number of VMs, with at most 255 of them running
> at any given time. Are you also planning to limit the number of
> processes to the ASID capacity? Because that's the exact same problem.
> 
> Let's get down to the bottom of the problem instead.
> 
>>
>>>> If VMID overflow is a real bottleneck, it would be vastly better to
>>>> improve the VMID allocator along the lines of the arm64 ASID allocator,
>>>> so that upon overflow we reserve the set of active VMIDs (and therefore
>>>> avoid expensive TLB + icache maintenance). That does not require a
>>>> global limit on the number of VMs.  
>>>
>>> +1.
>>>   
>> I'll look at the ASID allocator approach.
> 
> That's not a useful thing to do right now. The immediate need is to
> understand where the current algorithm fails, and to fix it. If the
> fixed version proves to be a bottleneck, then we'll investigate it.
> 
> In the meantime, fixing this issue should be the number one priority.
> 
> Thanks,
> 
> 	M.
> 

-- 
Shannon

--------------020403030107030508000806
Content-Type: text/plain; charset="gb18030"; name="VM-58-bt.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="VM-58-bt.txt"

PID: 0      TASK: ffff800000ff41f0  CPU: 0   COMMAND: "swapper/0"
 #0 [ffff800000fe3b00] _raw_spin_lock_irqsave at ffff8000009f5870
 #1 [ffff800000fe3b10] try_to_wake_up at ffff8000000fdb10
 #2 [ffff800000fe3b20] wake_up_process at ffff8000000fddf0
 #3 [ffff800000fe3b80] watchdog_timer_fn at ffff800000188f0c
 #4 [ffff800000fe3b90] __run_hrtimer at ffff80000013a5f8
 #5 [ffff800000fe3bf0] hrtimer_interrupt at ffff80000013aa98
 #6 [ffff800000fe3c30] arch_timer_handler_virt at ffff800000817c28
 #7 [ffff800000fe3cb0] handle_percpu_devid_irq at ffff800000126a10
 #8 [ffff800000fe3cc0] generic_handle_irq at ffff8000001218f0
 #9 [ffff800000fe3d00] __handle_domain_irq at ffff800000121c70
#10 [ffff800000fe3d20] gic_handle_irq at ffff800000081e5c
#11 [ffff800000fe3d60] el1_irq at ffff80000008301c
     PC: ffff800000085eac  [arch_cpu_idle+28]
     LR: ffff800000085ea8  [arch_cpu_idle+24]
     SP: ffff800000fe3ef0  PSTATE: 60000145
    X29: ffff800000fe3ef0  X28: ffff800000a0f000  X27: 0000000000000000
    X26: ffff8000010fb000  X25: ffff800000fe3f00  X24: ffff800000fb9d58
    X23: 0000000000000000  X22: ffff800000a0f7c0  X21: ffff800000fe7b30
    X20: ffff800000fe7000  X19: ffff800000fe0000  X18: 0000000000000005
    X17: 0000ffffa579cfc8  X16: ffff800000276068  X15: 001c759920000000
    X14: 0000000000000000  X13: 00000003e8000000  X12: 0000000000000018
    X11: 000000000007491c  X10: 000000005aaeb0c0   X9: ffff800000113fa0
     X8: ffff800000ff47a0   X7: 000000010007472d   X6: 000000007dffc000
     X5: 0000000000000000   X4: 0000000000000000   X3: 0000000000000000
     X2: 0000000000000001   X1: 0000000000000000   X0: 0000000000000000
    ORIG_X0: 0000000000000000  SYSCALLNO: ffff800000fe7000
#12 [ffff800000fe3f00] cpu_startup_entry at ffff800000113fa0
#13 [ffff800000fe3f10] rest_init at ffff8000009e6164
#14 [ffff800000fe3f90] start_kernel at ffff800000e3f9d8
--------------020403030107030508000806
Content-Type: text/plain; charset="gb18030"; name="VM-58-trace.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="VM-58-trace.txt"

[ 2204.623264] Unable to handle kernel paging request at virtual address 1403e291114089
[ 2204.623275] Unable to handle kernel paging request at virtual address 24600091014061
[ 2204.623281] Unable to handle kernel paging request at virtual address 24600091014061
[ 2204.623285] Unable to handle kernel paging request at virtual address 24600091014061
[ 2204.623289] Unable to handle kernel paging request at virtual address 24600091014061
[ 2204.623294] Unable to handle kernel paging request at virtual address 24600091014061
[ 2204.623299] Unable to handle kernel paging request at virtual address 24600091014061
[ 2204.623304] Unable to handle kernel paging request at virtual address 24600091014061
[ 2204.623309] Unable to handle kernel paging request at virtual address 24600091014061
[ 2204.623313] Unable to handle kernel paging request at virtual address 24600091014061
[ 2204.623318] Unable to handle kernel paging request at virtual address 24600091014061
[ 2204.623323] Unable to handle kernel paging request at virtual address 24600091014061
[ 2204.623327] Unable to handle kernel paging request at virtual address 24600091014061
[ 2204.623332] Unable to handle kernel paging request at virtual address 24600091014061
[ 2204.623336] Unable to handle kernel paging request at virtual address 24600091014061
[ 2204.623341] Unable to handle kernel paging request at virtual address 24600091014061
[ 2204.623345] Unable to handle kernel paging request at virtual address 24600091014061
[ 2204.623350] Unable to handle kernel paging request at virtual address 24600091014061
[ 2204.623354] Unable to handle kernel paging request at virtual address 24600091014061
[ 2204.623359] Unable to handle kernel paging request at virtual address 24600091014061
[ 2204.623364] Unable to handle kernel paging request at virtual address 24600091014061
[ 2204.623368] Unable to handle kernel paging request at virtual address 24600091014061
[ 2204.623373] Unable to handle kernel paging request at virtual address 24600091014061
[ 2204.623376] pgd = 72656b20656c646e
[ 2204.623435] Unable to handle kernel NULL pointer dereference at virtual address 000002c0
[ 2204.623440] Unable to handle kernel paging request at virtual address 363f7910cc061
[ 2204.623445] Unable to handle kernel paging request at virtual address 46bf9a9015433
[ 2204.623449] Unable to handle kernel paging request at virtual address 46bf9a9015433
[ 2204.623454] Unable to handle kernel paging request at virtual address 46bf9a9015433
[ 2204.623458] Unable to handle kernel paging request at virtual address 46bf9a9015433
[ 2204.623463] Unable to handle kernel paging request at virtual address 46bf9a9015433
[ 2204.623467] Unable to handle kernel paging request at virtual address 46bf9a9015433
[ 2204.623472] Unable to handle kernel paging request at virtual address 46bf9a9015433
[ 2204.623476] Unable to handle kernel paging request at virtual address 46bf9a9015433
[ 2204.623480] Unable to handle kernel paging request at virtual address 46bf9a9015433
[ 2204.623485] Unable to handle kernel paging request at virtual address 46bf9a9015433
[ 2204.623489] Unable to handle kernel paging request at virtual address 46bf9a9015433
[ 2204.623494] Unable to handle kernel paging request at virtual address 46bf9a9015433
[ 2204.623498] Unable to handle kernel paging request at virtual address 46bf9a9015433
[ 2204.623503] Unable to handle kernel paging request at virtual address 46bf9a9015433
[ 2204.623507] Unable to handle kernel paging request at virtual address 46bf9a9015433
[ 2204.623512] Unable to handle kernel paging request at virtual address 46bf9a9015433
[ 2204.623516] Unable to handle kernel paging request at virtual address 46bf9a9015433
[ 2204.623520] Unable to handle kernel paging request at virtual address 46bf9a9015433
[ 2204.623525] Unable to handle kernel paging request at virtual address 46bf9a9015433
[ 2204.623529] Unable to handle kernel paging request at virtual address 46bf9a9015433
[ 2204.623534] Unable to handle kernel paging request at virtual address 46bf9a9015433
[ 2204.623539] Unable to handle kernel paging request at virtual address 46bf9a9015433
[ 2204.623540] pgd = ffff8000011f6000
[ 2204.623542] [46bf9a9015433] *pgd=0000000000000000
[ 2204.623545] Internal error: Oops: 96000004 [#1] SMP
[ 2204.623550] kbox catch die event.
[ 2204.624441] collected_len = 14348, LOG_BUF_LEN_LOCAL = 16384
[ 2204.628542] [kbox drv] flush data done. addr: 0xffff80007f000000, size: 0x1000000
[ 2204.631311] [kbox drv] flush data done. addr: 0xffff80007f000000, size: 0x1000000
[ 2204.633820] [kbox drv] flush data done. addr: 0xffff80007f000000, size: 0x1000000
[ 2204.633822] kbox: notify die begin
[ 2204.633824] kbox: no notify die func register. no need to notify
[ 2204.633825] do nothing after die!
[ 2204.633857] Modules linked in: kboxdriver(OE) kbox(OE) crc32_arm64(E) aes_ce_blk(E) ablk_helper(E) cryptd(E) aes_ce_cipher(E) ghash_ce(E) sha2_ce(E) sha1_ce(E) sg(E) ofpart(E) virtio_balloon(E) cmdlinepart(E) virtio_net(E) shpchp(E) cfi_cmdset_0001(E) cfi_probe(E) cfi_util(E) gen_probe(E) physmap_of(E) map_funcs(E) chipreg(E) mtd(E) ip_tables(E) sr_mod(E) cdrom(E) virtio_gpu(E) drm_kms_helper(E) syscopyarea(E) sysfillrect(E) sysimgblt(E) fb_sys_fops(E) ttm(E) drm(E) dm_mirror(E) dm_region_hash(E) dm_log(E) dm_mod(E)
[ 2204.633861] CPU: -32768 PID: -1778384892 Comm: 3T...k. Tainted: G           OE   4.1.44-03.52.vhulk1711.1.1.aarch64 #1
[ 2204.633862] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
[ 2204.633871] Unable to handle kernel NULL pointer dereference at virtual address 00000008
[ 2204.633875] Unable to handle kernel paging request at virtual address a57f4a9095032
[ 2204.633879] Unable to handle kernel paging request at virtual address c67f8a90b6036
[ 2204.633882] Unable to handle kernel paging request at virtual address c67f8a90b6036
[ 2204.633885] Unable to handle kernel paging request at virtual address c67f8a90b6036
[ 2204.633888] Unable to handle kernel paging request at virtual address c67f8a90b6036
[ 2204.633892] Unable to handle kernel paging request at virtual address c67f8a90b6036
[ 2204.633895] Unable to handle kernel paging request at virtual address c67f8a90b6036
[ 2204.633898] Unable to handle kernel paging request at virtual address c67f8a90b6036
[ 2204.633901] Unable to handle kernel paging request at virtual address c67f8a90b6036
[ 2204.633905] Unable to handle kernel paging request at virtual address c67f8a90b6036
[ 2204.633908] Unable to handle kernel paging request at virtual address c67f8a90b6036
[ 2204.633911] Unable to handle kernel paging request at virtual address c67f8a90b6036
[ 2204.633915] Unable to handle kernel paging request at virtual address c67f8a90b6036
[ 2204.633918] Unable to handle kernel paging request at virtual address c67f8a90b6036
[ 2204.633921] Unable to handle kernel paging request at virtual address c67f8a90b6036
[ 2204.633925] Unable to handle kernel paging request at virtual address c67f8a90b6036
[ 2204.633928] Unable to handle kernel paging request at virtual address c67f8a90b6036
[ 2204.633931] Unable to handle kernel paging request at virtual address c67f8a90b6036
[ 2204.633934] Unable to handle kernel paging request at virtual address c67f8a90b6036
[ 2204.633938] Unable to handle kernel paging request at virtual address c67f8a90b6036
[ 2204.633941] Unable to handle kernel paging request at virtual address c67f8a90b6036
[ 2204.633944] Unable to handle kernel paging request at virtual address c67f8a90b6036
[ 2204.633948] Unable to handle kernel paging request at virtual address c67f8a90b6036
[ 2204.633951] Unable to handle kernel paging request at virtual address 31202028202060
[ 2204.633953] pgd = ffff8000011f6000
[ 2204.633954] [31202028202060] *pgd=0000000000000000
--------------020403030107030508000806
Content-Type: text/plain; charset="gb18030"; name="VM-236-bt.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="VM-236-bt.txt"

PID: 0      TASK: ffff800000ff41f0  CPU: 0   COMMAND: "swapper/0"
 #0 [ffff800000fe3730] _raw_spin_lock_irq at ffff8000009f58c4
 #1 [ffff800000fe3740] die at ffff80000008a81c
 #2 [ffff800000fe3750] __do_kernel_fault at ffff8000009eb3d8
 #3 [ffff800000fe3790] do_page_fault at ffff8000009f840c
 #4 [ffff800000fe37c0] do_translation_fault at ffff8000009f85d0
 #5 [ffff800000fe3820] do_mem_abort at ffff800000081b0c
 #6 [ffff800000fe3850] el1_da at ffff800000082e28
     PC: ffff80000010beac  [load_balance+284]
     LR: ffff80000010c724  [rebalance_domains+388]
     SP: ffff800000fe3a50  PSTATE: 80000145
    X29: ffff800000fe3a50  X28: 00ff81807a936bf8  X27: ffff800000fe6000
    X26: 0000000000000000  X25: ffff80007efbc3c0  X24: 0000000000000001
    X23: ffff800000fe7000  X22: ffff800000fe8cec  X21: 0000000000000000
    X20: 0000000000000000  X19: 000000010000ba1b  X18: 0000000000000005
    X17: 0000ffffa703efc8  X16: ffff800000276068  X15: 0025e53290000000
    X14: 00003d0900000000  X13: ffff800000a105a0  X12: 0000000000000000
    X11: 0000000000000000  X10: 0000000000000000   X9: 0000000000000000
     X8: ffff80007c07b540   X7: ffff80007efb5d28   X6: ffff80007c07b540
     X5: ffff800000fe3b58   X4: ffff800000fe3bf4   X3: 0000000000000018
     X2: ffff80007efb5d28   X1: 0000000000000000   X0: ffff80007c07b540
    ORIG_X0: 0000000000000000  SYSCALLNO: 100000000
 #7 [ffff800000fe3a60] rebalance_domains at ffff80000010c724
 #8 [ffff800000fe3b80] run_rebalance_domains at ffff80000010c99c
 #9 [ffff800000fe3c10] __do_softirq at ffff8000000d2058
#10 [ffff800000fe3c80] irq_exit at ffff8000000d24d4
#11 [ffff800000fe3d10] __handle_domain_irq at ffff800000121c74
#12 [ffff800000fe3d20] gic_handle_irq at ffff800000081e5c
#13 [ffff800000fe3d60] el1_irq at ffff80000008301c
     PC: ffff800000085eac  [arch_cpu_idle+28]
     LR: ffff800000085ea8  [arch_cpu_idle+24]
     SP: ffff800000fe3ef0  PSTATE: 60000145
    X29: ffff800000fe3ef0  X28: ffff800000a0f000  X27: 0000000000000000
    X26: ffff8000010fb000  X25: ffff800000fe3f00  X24: ffff800000fb9d58
    X23: 0000000000000000  X22: ffff800000a0f7c0  X21: ffff800000fe7b30
    X20: ffff800000fe7000  X19: ffff800000fe0000  X18: 0000000000000005
    X17: 0000ffffa703efc8  X16: ffff800000276068  X15: 0025e53290000000
    X14: 0000000000000000  X13: 00000003e8000000  X12: 0000000000000018
    X11: 000000000009b381  X10: 000000005aaeb0bc   X9: ffff800000113fa0
     X8: ffff800000ff47a0   X7: 0000000100007ec7   X6: 000000007dffc000
     X5: 0000000000000000   X4: 0000000000000000   X3: 0000000000000000
     X2: 0000000000000001   X1: 0000000000000000   X0: 0000000000000000
    ORIG_X0: 0000000000000000  SYSCALLNO: ffff800000fe7000
#14 [ffff800000fe3f00] cpu_startup_entry at ffff800000113fa0
#15 [ffff800000fe3f10] rest_init at ffff8000009e6164
#16 [ffff800000fe3f90] start_kernel at ffff800000e3f9d8
--------------020403030107030508000806
Content-Type: text/plain; charset="gb18030"; name="VM-236-trace.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="VM-236-trace.txt"

[  430.750851] Unable to handle kernel NULL pointer dereference at virtual address 000002c0
[  430.750858] pgd =           (null)
[  430.750864] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[  430.750865] pgd =           (null)
[  430.750870] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[  430.750871] pgd =           (null)
[  430.750875] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[  430.750876] pgd =           (null)
[  430.750881] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[  430.750881] pgd =           (null)
[  430.750885] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[  430.750886] pgd =           (null)
[  430.750890] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[  430.750891] pgd =           (null)
[  430.750895] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[  430.750896] pgd =           (null)
[  430.750900] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[  430.750901] pgd =           (null)
[  430.750906] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[  430.750907] pgd =           (null)
[  430.750911] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[  430.750911] pgd =           (null)
[  430.750916] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[  430.750917] pgd =           (null)
[  430.750921] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[  430.750922] pgd =           (null)
[  430.750926] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[  430.750927] pgd =           (null)
[  430.750931] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[  430.750932] pgd =           (null)
[  430.750936] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[  430.750937] pgd =           (null)
[  430.750941] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[  430.750942] pgd =           (null)
[  430.750946] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[  430.750947] pgd =           (null)
[  430.750951] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[  430.750952] pgd =           (null)
[  430.750956] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[  430.750957] pgd = ffff80007c07c3f0
[  430.750962] Unable to handle kernel paging request at virtual address ffffffc8
[  430.750997] pgd =           (null)
[  430.751003] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[  430.751006] pgd = 6e7978655f633269
[  430.751012] Unable to handle kernel paging request at virtual address 7978655f633269
[  430.751014] pgd = 007665645f633269
[  430.751020] Unable to handle kernel paging request at virtual address 7665645f6339e9
[  430.751022] pgd = 007665645f633269
[  430.751028] Unable to handle kernel paging request at virtual address 7665645f6338b9
[  430.751030] pgd = 007665645f633269
[  430.751035] Unable to handle kernel paging request at virtual address 7665645f6338b9
[  430.751037] pgd = 007665645f633269
[  430.751042] Unable to handle kernel paging request at virtual address 7665645f6338b9
[  430.751044] pgd = 007665645f633269
[  430.751049] Unable to handle kernel paging request at virtual address 7665645f6338b9
[  430.751051] pgd = 007665645f633269
[  430.751056] Unable to handle kernel paging request at virtual address 7665645f6338b9
[  430.751058] pgd = 007665645f633269
[  430.751063] Unable to handle kernel paging request at virtual address 7665645f6338b9
[  430.751066] pgd = 007665645f633269
[  430.751070] Unable to handle kernel paging request at virtual address 7665645f6338b9
[  430.751073] pgd = 007665645f633269
[  430.751078] Unable to handle kernel paging request at virtual address 7665645f6338b9
[  430.751080] pgd = 007665645f633269
[  430.751085] Unable to handle kernel paging request at virtual address 7665645f6338b9
[  430.751088] pgd = 007665645f633269
[  430.751093] Unable to handle kernel paging request at virtual address 7665645f6338b9
[  430.751095] pgd = 007665645f633269
[  430.751100] Unable to handle kernel paging request at virtual address 7665645f6338b9
[  430.751102] pgd = 007665645f633269
[  430.751108] Unable to handle kernel paging request at virtual address 7665645f6338b9
[  430.751110] pgd = 007665645f633269
[  430.751116] Unable to handle kernel paging request at virtual address 7665645f6338b9
[  430.751118] pgd = 007665645f633269
[  430.751123] Unable to handle kernel paging request at virtual address 7665645f6338b9
[  430.751125] pgd = 007665645f633269
[  430.751131] Unable to handle kernel paging request at virtual address 7665645f6338b9
[  430.751133] pgd = 007665645f633269
[  430.751138] Unable to handle kernel paging request at virtual address 7665645f6338b9
[  430.751141] pgd = 007665645f633269
[  430.751147] Unable to handle kernel paging request at virtual address 7665645f6338b9
[  430.751149] pgd = 007665645f633269
[  430.751154] Unable to handle kernel paging request at virtual address 7665645f6338b9
[  430.751156] pgd = 007665645f633269
[  430.751161] Unable to handle kernel paging request at virtual address 7665645f6338b9
[  430.751163] pgd = ffff80007c0782f0
[  430.751165] [7665645f6338b9] *pgd=203a6c656e72656b
[  430.751172] Unable to handle kernel paging request at virtual address ffffec652e726c88
[  430.751178] Unable to handle kernel paging request at virtual address ffffec652e726cc8
[  430.751186] Unable to handle kernel paging request at virtual address 31202028202060
[  430.751189] pgd = 796669746f6e6166
[  430.751194] Unable to handle kernel paging request at virtual address 6669746f6e6366
[  430.751196] pgd = 796669746f6e6166
[  430.751201] Unable to handle kernel paging request at virtual address 6669746f6e67f6
[  430.751203] pgd = 796669746f6e6166
[  430.751208] Unable to handle kernel paging request at virtual address 6669746f6e67f6
[  430.751210] pgd = 796669746f6e6166
[  430.751215] Unable to handle kernel paging request at virtual address 6669746f6e67f6
[  430.751216] pgd = 796669746f6e6166
[  430.751221] Unable to handle kernel paging request at virtual address 6669746f6e67f6
[  430.751223] pgd = 796669746f6e6166
[  430.751228] Unable to handle kernel paging request at virtual address 6669746f6e67f6
[  430.751231] pgd = 796669746f6e6166
[  430.751236] Unable to handle kernel paging request at virtual address 6669746f6e67f6
[  430.751239] pgd = 796669746f6e6166
[  430.751244] Unable to handle kernel paging request at virtual address 6669746f6e67f6
[  430.751246] pgd = 796669746f6e6166
[  430.751251] Unable to handle kernel paging request at virtual address 6669746f6e67f6
[  430.751253] pgd = 796669746f6e6166
[  430.751257] Unable to handle kernel paging request at virtual address 6669746f6e67f6
[  430.751260] pgd = 796669746f6e6166
[  430.751264] Unable to handle kernel paging request at virtual address 6669746f6e67f6
[  430.751267] pgd = 796669746f6e6166
[  430.751272] Unable to handle kernel paging request at virtual address 6669746f6e67f6
[  430.751274] pgd = 796669746f6e6166
[  430.751279] Unable to handle kernel paging request at virtual address 6669746f6e67f6
[  430.751281] pgd = 796669746f6e6166
[  430.751286] Unable to handle kernel paging request at virtual address 6669746f6e67f6
[  430.751289] pgd = 796669746f6e6166
[  430.751293] Unable to handle kernel paging request at virtual address 6669746f6e67f6
[  430.751296] pgd = 796669746f6e6166
[  430.751301] Unable to handle kernel paging request at virtual address 6669746f6e67f6
[  430.751303] pgd = 796669746f6e6166
[  430.751308] Unable to handle kernel paging request at virtual address 6669746f6e67f6
[  430.751312] pgd = 796669746f6e6166
[  430.751317] Unable to handle kernel paging request at virtual address 6669746f6e67f6
[  430.751320] pgd = 796669746f6e6166
[  430.751324] Unable to handle kernel paging request at virtual address 6669746f6e67f6
[  430.751327] pgd = 796669746f6e6166
[  430.751331] Unable to handle kernel paging request at virtual address 6669746f6e67f6
[  430.751334] pgd = 796669746f6e6166
[  430.751337] [6669746f6e67f6] *pgd=cb88537fdc8ba32c
[  430.751346] Internal error: Oops: 96000004 [#1] SMP
[  430.753278] Unable to handle kernel NULL pointer dereference at virtual address 000002c0
[  430.753281] pgd = ffff800070eea1e0
[  430.753283] [000002c0] *pgd=ffff800070eea1e0
[  430.754501] Unable to handle kernel NULL pointer dereference at virtual address 00000010
[  430.754504] pgd = ffff8000011f6000
[  430.754508] [00000010] *pgd=00000000bc887003, *pud=00000000bc888003, *pmd=00000000bc889003, *pte=00e8000008000707
--------------020403030107030508000806
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--------------020403030107030508000806--
