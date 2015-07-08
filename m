From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [RFC PATCH] KVM: arm/arm64: Don't let userspace update CNTVOFF
 once guest is running
Date: Wed, 8 Jul 2015 20:13:59 +0100
Message-ID: <CAFEAcA-rWf5UkiP+5UbtjYihfhDOVaY4hVpXNRGMnYEhNWqwSQ@mail.gmail.com>
References: <1435157697-28579-1-git-send-email-marc.zyngier@arm.com>
 <20150625080457.GD28244@cbox> <558BC2F5.9010303@huawei.com>
 <CAFEAcA_RzWSppaYA9vuAaL-MO6sQV1SgpXf3w-LScUdaarpOEQ@mail.gmail.com>
 <558BC90B.4060806@huawei.com> <558CD9DE.3010609@web.de> <55917E5B.3030401@huawei.com>
 <CAFEAcA-vS8B8pJUSseFw0OaKJFPe-0rMT-XHxjNbSvyxaZ+9Tg@mail.gmail.com>
 <559D483A.40507@arm.com> <CAFEAcA-U1mEGy87ax4Cb1MLFcEP+sqc9BL_Q0hO6qg1J3FCMew@mail.gmail.com>
 <559D51C5.3070600@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <559D51C5.3070600@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Claudio Fontana <claudio.fontana@huawei.com>, Jan Kiszka <jan.kiszka@web.de>, Christoffer Dall <christoffer.dall@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvm-devel <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 8 July 2015 at 17:37, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 08/07/15 17:06, Peter Maydell wrote:
>> I'd prefer it if somebody could investigate to see why QEMU
>> is actually doing this -- so far we just have speculation.
>
> I'd prefer that too, but so far people seem to be more comfortable
> waiting for the issue to fix itself. In the meantime, VMs are broken in
> weird and wonderful ways, and I don't think the current status-quo helps
> anyone.

Putting in a patch which might not be the right fix isn't
necessarily a good plan either...

Does has_run_once get cleared if we do a re-VCPU_INIT
of a CPU that's run before? (We need to allow rewriting
of guest state at that point so that "reset VM and
load migration state" behaves correctly.)

I suspect Jan is right and we really need to distinguish
the KVM_PUT_*_STATE levels in ARM QEMU. This probably
implies some kind of whitelist/override mechanism, since
by and large we neither know nor want to know the
semantics for system registers, we leave that up to the
kernel.

Q: if you have a running VM, and you pause it for
an hour, what should the CNTVCT register do? Presumably
it should not advance, but how do we arrange for that
to happen?

-- PMM
