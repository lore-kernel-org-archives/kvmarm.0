From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v6 5/7] arm64: kvm: route synchronous external abort
 exceptions to el2
Date: Thu, 14 Sep 2017 19:12:06 +0800
Message-ID: <fb7da3e3-d0f7-7ac6-b088-888a563d7ee7@huawei.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com>
 <1503916701-13516-6-git-send-email-gengdongjiu@huawei.com>
 <59B17449.6010201@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <59B17449.6010201@arm.com>
Sender: linux-acpi-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, xiexiuqi@huawei.com, cov@codeaurora.org, david.daney@cavium.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, tbaicar@codeaurora.org, ard.biesheuvel@linaro.org, mingo@kernel.org, bp@suse.de, shiju.jose@huawei.com, zjzhang@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@acpica.org, mst@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

James,

On 2017/9/8 0:31, James Morse wrote:
> KVM already handles external aborts from lower exception levels, no more work
> needs doing for TEA.
If it is firmware first solution, that is SCR_EL3.EA=1, all SError interrupt and synchronous External
Abort exceptions are taken to EL3, so EL3 firmware will handle it, KVM no needs to handle it.

HCR_EL3.TEA is only for EL3 to check its value to decide to jump to hypervisor or kernel.

> 
> What happens when a guest access the RAS-Error-Record registers?
> 
> Before we can set HCR_EL2.TERR I think we need to add some minimal emulation for
> the registers it traps. Most of them should be RAZ/WI, so it should be
> straightforward. (I think KVMs default is to emulate an undef for unknown traps).
Today I added the support to do some minimal emulation for RAS-Error-Record registers, thanks
for the good suggestion.

> 
> Eventually we will want to back this with a page of memory that lets
> Qemu/kvmtool configure what the guest can see. (i.e. the emulated machine's
> errors for kernel-first handling.)




