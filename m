From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [RFC PATCH] KVM: arm/arm64: Don't let userspace update CNTVOFF
 once guest is running
Date: Thu, 25 Jun 2015 10:10:04 +0100
Message-ID: <CAFEAcA_RzWSppaYA9vuAaL-MO6sQV1SgpXf3w-LScUdaarpOEQ@mail.gmail.com>
References: <1435157697-28579-1-git-send-email-marc.zyngier@arm.com>
 <20150625080457.GD28244@cbox> <558BC2F5.9010303@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <558BC2F5.9010303@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Claudio Fontana <claudio.fontana@huawei.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvm-devel <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 25 June 2015 at 09:59, Claudio Fontana <claudio.fontana@huawei.com> wrote:
> Once the VM is created, I think QEMU should not request kvm to
> change the virtual offset of the VM anymore: maybe an unexpected
> consequence of QEMU's target-arm/kvm64.c::kvm_arch_put_registers ?

Hmm. In general we assume that we can:
 * stop the VM
 * read all the guest system registers
 * write those values back again
 * restart the VM

if we need to. Is that what's happening here, or are we doing
something odder?

-- PMM
