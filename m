From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v6 6/7] KVM: arm64: allow get exception information from
 userspace
Date: Wed, 13 Sep 2017 15:32:10 +0800
Message-ID: <2a42d1ea-3456-2873-c9ea-d8a027b59789@huawei.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com>
 <1503916701-13516-7-git-send-email-gengdongjiu@huawei.com>
 <59B17438.5070501@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <59B17438.5070501@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>, peter.maydell@linaro.org
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, xiexiuqi@huawei.com, cov@codeaurora.org, david.daney@cavium.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, tbaicar@codeaurora.org, ard.biesheuvel@linaro.org, mingo@kernel.org, bp@suse.de, shiju.jose@huawei.com, zjzhang@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@acpica.org, mst@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,


On 2017/9/8 0:30, James Morse wrote:
> Hi Dongjiu Geng,
> 
> On 28/08/17 11:38, Dongjiu Geng wrote:
>> when userspace gets SIGBUS signal, it does not know whether
>> this is a synchronous external abort or SError,
> 
> Why would Qemu/kvmtool need to know if the original notification (if there was
> one) was synchronous or asynchronous? This is between firmware and the kernel.
there are two reasons:

1. Let us firstly discuss the SEA and SEI, there are different workflow for the two different Errors.
2. when record the CPER in the user space, it needs to know the error type, because SEA and SEI are different Error source,
   so they have different offset in the APEI table, that is to say they will be recorded to different place of the APEI table.


         etc/acpi/tables                               etc/hardware_errors
        ====================                    ==========================================
    + +--------------------------+            +------------------+
    | | HEST                     |            |    address       |              +--------------+
    | +--------------------------+            |    registers     |              | Error Status |
    | | GHES0                    |            | +----------------+              | Data Block 0 |
    | +--------------------------+ +--------->| |status_address0 |------------->| +------------+
    | | .................        | |          | +----------------+              | |  CPER      |
    | | error_status_address-----+-+ +------->| |status_address1 |----------+   | |  CPER      |
    | | .................        |   |        | +----------------+          |   | |  ....      |
    | | read_ack_register--------+-+ |        |  .............   |          |   | |  CPER      |
    | | read_ack_preserve        | | |        +------------------+          |   | +-+------------+
    | | read_ack_write           | | | +----->| |status_address10|--------+ |   | Error Status |
    + +--------------------------+ | | |      | +----------------+        | |   | Data Block 1 |
    | | GHES1                    | +-+-+----->| | ack_value0     |        | +-->| +------------+
    + +--------------------------+   | |      | +----------------+        |     | |  CPER      |
    | | .................        |   | | +--->| | ack_value1     |        |     | |  CPER      |
    | | error_status_address-----+---+ | |    | +----------------+        |     | |  ....      |
    | | .................        |     | |    | |  ............. |        |     | |  CPER      |
    | | read_ack_register--------+-----+-+    | +----------------+        |     +-+------------+
    | | read_ack_preserve        |     |   +->| | ack_value10    |        |     | |..........  |
    | | read_ack_write           |     |   |  | +----------------+        |     | +------------+
    + +--------------------------|     |   |                              |     | Error Status |
    | | ...............          |     |   |                              |     | Data Block 10|
    + +--------------------------+     |   |                              +---->| +------------+
    | | GHES10                   |     |   |                                    | |  CPER      |
    + +--------------------------+     |   |                                    | |  CPER      |
    | | .................        |     |   |                                    | |  ....      |
    | | error_status_address-----+-----+   |                                    | |  CPER      |
    | | .................        |         |                                    +-+------------+
    | | read_ack_register--------+---------+
    | | read_ack_preserve        |
    | | read_ack_write           |
    + +--------------------------+

> 
> 
> I think I can see why you need this: to choose whether to emulate SEA or SEI,
emulating SEA or SEI is one reason, another reason is that the CPER will be recorded to different place of APEI.


> but what if the guest wasn't running? Or the guest was running, but it wasn't
> guest-memory that is affected.
If the guest was not running, host firmware will directly notify EL1 host kernel to handle the error, not notify hypervisor
only if the guest was running host firmware can notify the Error to hypervisor.

If the user space is Qemu, and the error is from Qemu, and guest-memory is not involve.
I will not handle it, please see the code for arm64.

void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
{
    ram_addr_t ram_addr;
    hwaddr paddr;

    ARMCPU *cpu = ARM_CPU(c);
    CPUARMState *env = &cpu->env;
    assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);
    if (addr) {
        ram_addr = qemu_ram_addr_from_host(addr);
        if (ram_addr != RAM_ADDR_INVALID &&
            kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
            kvm_cpu_synchronize_state(c);
            kvm_hwpoison_page_add(ram_addr);
            if (is_abort_sea(env->exception.syndrome)) {
                ghes_update_guest(ACPI_HEST_NOTIFY_SEA, paddr);
                kvm_inject_arm_sea(c);
            } else if (is_abort_sei(env->exception.syndrome)) {
                ghes_update_guest(ACPI_HEST_NOTIFY_SEI, paddr);
                kvm_inject_arm_sei(c);
            }
            return;
        }
        fprintf(stderr, "Hardware memory error for memory used by "
                "QEMU itself instead of guest system!\n");
    }

    if (code == BUS_MCEERR_AR) {
        fprintf(stderr, "Hardware memory error!\n");
        exit(1);
    }
}


For the x86, it also does not handle it, it only print "Hardware memory error for memory used by QEMU itself instead of guest system!"

void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
{
    X86CPU *cpu = X86_CPU(c);
    CPUX86State *env = &cpu->env;
    ram_addr_t ram_addr;
    hwaddr paddr;

    /* If we get an action required MCE, it has been injected by KVM
     * while the VM was running.  An action optional MCE instead should
     * be coming from the main thread, which qemu_init_sigbus identifies
     * as the "early kill" thread.
     */
    assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);

    if ((env->mcg_cap & MCG_SER_P) && addr) {
        ram_addr = qemu_ram_addr_from_host(addr);
        if (ram_addr != RAM_ADDR_INVALID &&
            kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
            kvm_hwpoison_page_add(ram_addr);
            kvm_mce_inject(cpu, paddr, code);
            return;
        }

        fprintf(stderr, "Hardware memory error for memory used by "
                "QEMU itself instead of guest system!\n");
    }

    if (code == BUS_MCEERR_AR) {
        hardware_memory_error();
    }

    /* Hope we are lucky for AO MCE */
}


> 
> What happens if the dram-scrub hardware spots an error in guest memory, but the
> guest wasn't running? KVM won't have a relevant ESR value to give you.
if the dram-scrub hardware spots an error in guest memory, it will generate
IRQ in DDR controller, not SEA or SEI exception. I still do not consider the GSIV.
For GSIV, may be we can only handle it in the host OS.


> 
> What happens if we start swapping a page of guest memory to disk, and discover
> the memory is corrupt. This is synchronous, but it wasn't the guest, and KVM
> still can't give you an ESR.
I think this Error is reported by IRQ(GSIV), GSIV is not SEA/SEI, we should not give the ESR to them.


> 
> What about CPER records discovered through the polled interface? What happens if
> I write a PFN into the corrupt-pfn sysfs interface?
I do not understand this question.
I think in the process it should report SEA notification when CPU consume the error page.


> 
> 
> I think what you need is some way of knowing if the BUS_MCEERR_A* was directly
> caused by a user-space (or guest) access, and if so was it a data or instruction
when user space received the signal, it will judge whether the memory address is user-space (or guest) address


> fetch. These can become SEA notifications.
In fact, it can be SEI, not always SEA, why it will always SEA notifications?
If the memory properties of data is device type, it may become SEI notification.


> 
> KVM's user-space shouldn't be a special-case where the kernel behaves
> differently: if we tinker with this it needs to make sense for all user space
> processes and mean something on all architectures.
> 
> I think this information could be useful to other users of these signals, e.g. a
> JVM could silently regenerate/reload code/data for a non-direct-access fault
> instead of exit-ing (or throwing an exception) for a direct access.
> 
> For BUS_MCEERR_A* from memory_failure() we can't know if they are caused by an
> access or not. When the mm code gets -EHWPOISON when trying to resolve a

Because of that, so I allow  userspace getting exception information

> user-space fault we know it was due to a direct-access. (I don't know if/how x86
> can know if it was code or data). Faulting guest accesses through KVM are just a
> special version of this where KVM fixes-up stage2.
> 
> ... but for any of this to work we need the address of the corrupt memory.
> (-> cover letter)
> 
> 
> Thanks,
> 
> James
> 
> .
> 
