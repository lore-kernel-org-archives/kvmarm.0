From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v11 6/6] target-arm: kvm64: Handle SError interrupt for
 the guest OS
Date: Mon, 11 Sep 2017 17:39:03 +0100
Message-ID: <CAFEAcA8J5wZ23kQypzcbUScUResjWnN6rDG0b0idD1rv7F5Fsw@mail.gmail.com>
References: <0184EA26B2509940AA629AE1405DD7F2015FE17F@DGGEMA503-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0184EA26B2509940AA629AE1405DD7F2015FE17F@DGGEMA503-MBX.china.huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Igor Mammedov <imammedo@redhat.com>, Zhaoshenglong <zhaoshenglong@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, QEMU Developers <qemu-devel@nongnu.org>, qemu-arm <qemu-arm@nongnu.org>, kvm-devel <kvm@vger.kernel.org>, "edk2-devel@lists.01.org" <edk2-devel@lists.01.org>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ingo Molnar <mingo@kernel.org>, "bp@suse.de" <bp@suse.de>, Shiju Jose <shiju.jose@huawei.com>, "zjzhang@codeaurora.org" <zjzhang@codeaurora.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvmarm@
List-Id: kvmarm@lists.cs.columbia.edu

On 11 September 2017 at 16:17, gengdongjiu <gengdongjiu@huawei.com> wrote:
>> On 18 August 2017 at 15:23, Dongjiu Geng <gengdongjiu@huawei.com> wrote:
>> > +static int kvm_inject_arm_sei(CPUState *cs) {
>> > +    ARMCPU *cpu = ARM_CPU(cs);
>> > +    CPUARMState *env = &cpu->env;
>> > +
>> > +    unsigned long syndrome = env->exception.vaddress;
>> > +    /* set virtual SError syndrome */
>> > +    if (arm_feature(env, ARM_FEATURE_RAS_EXTENSION)) {
>> > +        syndrome = syndrome & ARM_EL_ISS_MASK;
>> > +    } else {
>> > +        syndrome = 0;
>> > +    }
>> > +
>> > +    return  kvm_vcpu_ioctl(CPU(cpu), KVM_ARM_SEI, &syndrome);
>>
>> This looks odd. If we don't have the RAS extension why do we need to do anything at all here ?
>
> This is because Qemu may need to support non-RAS extension as discussed with ARM James before.
> That is to say host hardware CPU does not support RAS, but guest supports.
> That is under discussion.
> When host hardware supports RAS, specify the syndrome to a valid value, otherwise, set it to 0.

If the guest CPU doesn't support the RAS extension then we have
no mechanism for delivering it a notification about the
memory problem at all, so setting the syndrome to anything
doesn't make sense.

I'm not sure what you should do in the case of "host
supports telling us about a memory problem and has
done so, but guest does not support being told about it",
but I'm pretty sure it shouldn't be this.

thanks
-- PMM
