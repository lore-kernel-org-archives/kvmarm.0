From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH] KVM: arm64: add esr_el2 and far_el2 to sysreg
Date: Mon, 07 Aug 2017 17:59:05 +0100
Message-ID: <59889C59.80207@arm.com>
References: <1502122117-6276-1-git-send-email-gengdongjiu@huawei.com> <9fe6aa3a-98f9-6cae-6932-054858b54744@arm.com> <b834276b-b47d-51fb-7661-3eb5a2f6a68d@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b834276b-b47d-51fb-7661-3eb5a2f6a68d@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, christoffer.dall@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 07/08/17 17:23, gengdongjiu wrote:
>   As James's suggestion, I move injection SEA Error logic to the user space(Qemu), Qemu sets the related guest OS esr/elr/pstate/spsr

(because for firmware-first its the CPER records that matter, and only QEMU
knows where it reserved the memory for these, and what it told the guest it
would use as the notification method).

> through IOCTL KVM_SET_ONE_REG. For the SEA, when Qemu sets the esr_el1.IL bit, it needs to refer to esr_el2.IL, else Qemu does not know the trapped
> instruction was a 16-bit or a 32-bit instruction, also it needs to set far_el1 using far_el2, because this is synchronization abort.

The 32bit kernel doesn't support ACPI firmware first, and aarch64 doesn't
support 16-bit instructions.


James
