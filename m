From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v6 0/7] Add RAS virtualization support for SEA/SEI
 notification type in KVM
Date: Mon, 28 Aug 2017 18:38:14 +0800
Message-ID: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, james.morse@arm.com, xiexiuqi@huawei.com, cov@codeaurora.org, david.daney@cavium.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, tbaicar@codeaurora.org, ard.biesheuvel@linaro.org, mingo@kernel.org, bp@suse.de, shiju.jose@huawei.com, zjzhang@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@acpica.org, mst@redhat.com, john.garry@huawei.com, jonathan.cameron@huawei.com, shameerali.kolot
Cc: zhengqiang10@huawei.com, wuquanming@huawei.com, huangshaoyu@huawei.com, linuxarm@huawei.com, gengdongjiu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

In the firmware-first RAS solution, corrupt data is detected in a
memory location when guest OS application software executing at EL0
or guest OS kernel El1 software are reading from the memory. The
memory node records errors in an error record accessible using
system registers.

Because SCR_EL3.EA is 1, then CPU will trap to El3 firmware, EL3
firmware records the error to APEI table through reading system
register.

Because the error was taken from a lower Exception level, if the
exception is SEA/SEI and HCR_EL2.TEA/HCR_EL2.AMO is 1, firmware
sets ESR_EL2/FAR_EL2 to fake a exception trap to EL2, then
transfers to hypervisor.

For the synchronous external abort(SEA), Hypervisor calls the
ghes_handle_memory_failure() to deal with this error,
ghes_handle_memory_failure() function reads the APEI table and 
callls memory_failure() to decide whether it needs to deliver
SIGBUS signal to user space, the advantage of using SIGBUS signal
to notify user space is that it can be compatible with Non-Kvm users.

For the SError Interrupt(SEI),KVM firstly classified the error.
Not call memory_failure() to handle it. Because the error address recorded
by APEI is not accurated, so can not identify the address to hwpoison
memory. If the SError error comes from guest user mode and is not propagated,
then signal user space to handle it, otherwise, directly injects virtual
SError, or panic if the error is fatal. when user space handles the error,
it will specify syndrome for the injected virtual SError. This syndrome value
is set to the VSESR_EL2. VSESR_EL2 is a new ARMv8.2 RAS extensions register
which provides the syndrome value reported to software on taking a virtual
SError interrupt exception.

Dongjiu Geng (5):
  acpi: apei: remove the unused code
  arm64: kvm: support user space to query RAS extension feature
  arm64: kvm: route synchronous external abort exceptions to el2
  KVM: arm64: allow get exception information from userspace
  arm64: kvm: handle SEI notification and pass the virtual syndrome

James Morse (1):
  KVM: arm64: Save ESR_EL2 on guest SError

Xie XiuQi (1):
  arm64: cpufeature: Detect CPU RAS Extentions

 arch/arm/include/asm/kvm_host.h      |  2 ++
 arch/arm/kvm/guest.c                 |  9 ++++++
 arch/arm64/Kconfig                   | 16 +++++++++++
 arch/arm64/include/asm/barrier.h     |  1 +
 arch/arm64/include/asm/cpucaps.h     |  3 +-
 arch/arm64/include/asm/esr.h         | 11 +++++++
 arch/arm64/include/asm/kvm_arm.h     |  2 ++
 arch/arm64/include/asm/kvm_emulate.h | 17 +++++++++++
 arch/arm64/include/asm/kvm_host.h    |  2 ++
 arch/arm64/include/asm/sysreg.h      |  5 ++++
 arch/arm64/include/asm/system_misc.h |  1 +
 arch/arm64/include/uapi/asm/kvm.h    |  5 ++++
 arch/arm64/kernel/cpufeature.c       | 13 +++++++++
 arch/arm64/kernel/process.c          |  3 ++
 arch/arm64/kvm/guest.c               | 50 ++++++++++++++++++++++++++++++++
 arch/arm64/kvm/handle_exit.c         | 56 ++++++++++++++++++++++++++++++++----
 arch/arm64/kvm/hyp/switch.c          | 29 +++++++++++++++++--
 arch/arm64/kvm/reset.c               |  3 ++
 arch/arm64/mm/fault.c                | 34 ++++++++++++++++++++++
 drivers/acpi/apei/ghes.c             | 14 ---------
 include/uapi/linux/kvm.h             |  3 ++
 virt/kvm/arm/arm.c                   |  7 +++++
 22 files changed, 263 insertions(+), 23 deletions(-)

-- 
2.14.1
