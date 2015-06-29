From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [RFC PATCH] KVM: arm/arm64: Don't let userspace update CNTVOFF
 once guest is running
Date: Mon, 29 Jun 2015 18:37:33 +0100
Message-ID: <CAFEAcA-vS8B8pJUSseFw0OaKJFPe-0rMT-XHxjNbSvyxaZ+9Tg@mail.gmail.com>
References: <1435157697-28579-1-git-send-email-marc.zyngier@arm.com>
 <20150625080457.GD28244@cbox> <558BC2F5.9010303@huawei.com>
 <CAFEAcA_RzWSppaYA9vuAaL-MO6sQV1SgpXf3w-LScUdaarpOEQ@mail.gmail.com>
 <558BC90B.4060806@huawei.com> <558CD9DE.3010609@web.de> <55917E5B.3030401@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55917E5B.3030401@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Claudio Fontana <claudio.fontana@huawei.com>
Cc: Jan Kiszka <jan.kiszka@web.de>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvm-devel <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 29 June 2015 at 18:20, Claudio Fontana <claudio.fontana@huawei.com> wrote:
> On 26.06.2015 06:49, Jan Kiszka wrote:
>> QEMU has the concept of write-back levels: KVM_PUT_RUNTIME_STATE,
>> KVM_PUT_RESET_STATE and KVM_PUT_FULL_STATE. I suspect this registers is
>> just sorted into the wrong category, thus written as part of the
>> RUNTIME_STATE. We had such bug patterns during the x86 maturing phase as
>> well.

> It seems that QEMU target-arm ignores the level parameter to
> kvm_arch_put_registers completely.
>
> Is it intended?

Yes, sort of. We don't in general know anything about the semantics
of most of the system registers. It should always be safe to
read them all out of the kernel and write them back...

-- PMM
