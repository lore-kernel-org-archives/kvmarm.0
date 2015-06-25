From: Claudio Fontana <claudio.fontana@huawei.com>
Subject: Re: [RFC PATCH] KVM: arm/arm64: Don't let userspace update CNTVOFF
 once guest is running
Date: Thu, 25 Jun 2015 11:25:31 +0200
Message-ID: <558BC90B.4060806@huawei.com>
References: <1435157697-28579-1-git-send-email-marc.zyngier@arm.com> <20150625080457.GD28244@cbox> <558BC2F5.9010303@huawei.com> <CAFEAcA_RzWSppaYA9vuAaL-MO6sQV1SgpXf3w-LScUdaarpOEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAFEAcA_RzWSppaYA9vuAaL-MO6sQV1SgpXf3w-LScUdaarpOEQ@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvm-devel <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 25.06.2015 11:10, Peter Maydell wrote:
> On 25 June 2015 at 09:59, Claudio Fontana <claudio.fontana@huawei.com> wrote:
>> Once the VM is created, I think QEMU should not request kvm to
>> change the virtual offset of the VM anymore: maybe an unexpected
>> consequence of QEMU's target-arm/kvm64.c::kvm_arch_put_registers ?
> 
> Hmm. In general we assume that we can:
>  * stop the VM
>  * read all the guest system registers
>  * write those values back again
>  * restart the VM
> 
> if we need to. Is that what's happening here, or are we doing
> something odder?
> 
> -- PMM
> 

What I guess could be happening by looking at the code in linux

virt/kvm/arm/arch_timer.c::kvm_arm_timer_set_reg

is that QEMU tries to set the KVM_REG_ARM_TIMER_CNT register from exactly the previous value,
but just because of the fact that the set function is called, cntvoff is updated,
since the value provided by the user is apparently assumed to be _relative_ to the physical timer.

This is apparent to me in the code in that function which says:

case KVM_REG_ARM_TIMER_CNT: {
/* ... */
    u64 cntvoff = kvm_phys_timer_read() - value;
/* ... */
}

And this is matched by the corresponding get function kvm_arm_timer_get_reg where it says:

case KVM_REG_ARM_TIMER_CNT:
   return kvm_phys_timer_read() - vcpu->kvm->arch.timer.cntvoff;

The time difference between when the GET is issued by QEMU and when the PUT is issued then would account for the difference.

Thanks,

Claudio

