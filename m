From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH] KVM: arm/arm64: Don't let userspace update CNTVOFF
 once guest is running
Date: Wed, 08 Jul 2015 17:37:25 +0100
Message-ID: <559D51C5.3070600@arm.com>
References: <1435157697-28579-1-git-send-email-marc.zyngier@arm.com> <20150625080457.GD28244@cbox> <558BC2F5.9010303@huawei.com> <CAFEAcA_RzWSppaYA9vuAaL-MO6sQV1SgpXf3w-LScUdaarpOEQ@mail.gmail.com> <558BC90B.4060806@huawei.com> <558CD9DE.3010609@web.de> <55917E5B.3030401@huawei.com> <CAFEAcA-vS8B8pJUSseFw0OaKJFPe-0rMT-XHxjNbSvyxaZ+9Tg@mail.gmail.com> <559D483A.40507@arm.com> <CAFEAcA-U1mEGy87ax4Cb1MLFcEP+sqc9BL_Q0hO6qg1J3FCMew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAFEAcA-U1mEGy87ax4Cb1MLFcEP+sqc9BL_Q0hO6qg1J3FCMew@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Claudio Fontana <claudio.fontana@huawei.com>, Jan Kiszka <jan.kiszka@web.de>, Christoffer Dall <christoffer.dall@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvm-devel <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 08/07/15 17:06, Peter Maydell wrote:
> On 8 July 2015 at 16:56, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> On 29/06/15 18:37, Peter Maydell wrote:
>>> On 29 June 2015 at 18:20, Claudio Fontana <claudio.fontana@huawei.com> wrote:
>>>> On 26.06.2015 06:49, Jan Kiszka wrote:
>>>>> QEMU has the concept of write-back levels: KVM_PUT_RUNTIME_STATE,
>>>>> KVM_PUT_RESET_STATE and KVM_PUT_FULL_STATE. I suspect this registers is
>>>>> just sorted into the wrong category, thus written as part of the
>>>>> RUNTIME_STATE. We had such bug patterns during the x86 maturing phase as
>>>>> well.
>>>
>>>> It seems that QEMU target-arm ignores the level parameter to
>>>> kvm_arch_put_registers completely.
>>>>
>>>> Is it intended?
>>>
>>> Yes, sort of. We don't in general know anything about the semantics
>>> of most of the system registers. It should always be safe to
>>> read them all out of the kernel and write them back...
>>
>> I'm not sure you can safely assume this for time related things, unless
>> you can guarantee that all vcpus are stopped. Claudio is seeing time
>> jumping in weird ways, and so have I, which would tend to show that QEMU
>> is introducing some jitter.
>>
>> Maybe not easily observable on real hardware, but the FastModel is
>> enough to show the issue.
>>
>> So unless someone has a better solution, I'm seriously considering
>> getting this patch merged.
> 
> I'd prefer it if somebody could investigate to see why QEMU
> is actually doing this -- so far we just have speculation.

I'd prefer that too, but so far people seem to be more comfortable
waiting for the issue to fix itself. In the meantime, VMs are broken in
weird and wonderful ways, and I don't think the current status-quo helps
anyone.

	M.
-- 
Jazz is not dead. It just smells funny...
