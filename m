From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v6 5/7] arm64: kvm: route synchronous external abort exceptions
 to el2
Date: Thu, 07 Sep 2017 17:31:05 +0100
Message-ID: <59B17449.6010201@arm.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com> <1503916701-13516-6-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503916701-13516-6-git-send-email-gengdongjiu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dongjiu Geng <gengdongjiu@huawei.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, xiexiuqi@huawei.com, cov@codeaurora.org, david.daney@cavium.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, tbaicar@codeaurora.org, ard.biesheuvel@linaro.org, mingo@kernel.org, bp@suse.de, shiju.jose@huawei.com, zjzhang@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@acpica.org, mst@redhat.com, john.garry@huawei.com, jonathan.cameron@huawei.com, shameerali.kolot
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dongjiu Geng,

On 28/08/17 11:38, Dongjiu Geng wrote:
> ARMv8.2 adds a new bit HCR_EL2.TEA which controls to
> route synchronous external aborts to EL2, and adds a
> trap control bit HCR_EL2.TERR which controls to
> trap all Non-secure EL1&0 error record accesses to EL2.
>
> This patch enables the two bits for the guest OS.
> when an synchronous abort is generated in the guest OS,

> it will trap to EL3 firmware, EL3 firmware will check the
> HCR_EL2.TEA value to decide to jump to hypervisor or host
> OS.

(This is what you are using this for, the patch has nothing to do with EL3.)


> Enabling HCR_EL2.TERR makes error record access
> from guest trap to EL2.


KVM already handles external aborts from lower exception levels, no more work
needs doing for TEA.

What happens when a guest access the RAS-Error-Record registers?

Before we can set HCR_EL2.TERR I think we need to add some minimal emulation for
the registers it traps. Most of them should be RAZ/WI, so it should be
straightforward. (I think KVMs default is to emulate an undef for unknown traps).

Eventually we will want to back this with a page of memory that lets
Qemu/kvmtool configure what the guest can see. (i.e. the emulated machine's
errors for kernel-first handling.)


Thanks,

James
