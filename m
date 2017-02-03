From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2 2/5] KVM: arm/arm64: Add ARM user space interrupt
 signaling ABI
Date: Fri, 3 Feb 2017 17:51:18 +0000
Message-ID: <CAFEAcA-HMZnjbnhDC-13rWuQP-X2pk-W-6DvSR8n9_f-e4R=cA@mail.gmail.com>
References: <20170203145655.15007-1-cdall@linaro.org> <20170203145655.15007-3-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170203145655.15007-3-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Alexander Graf <agraf@suse.de>, Pekka Enberg <penberg@iki.fi>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 3 February 2017 at 14:56, Christoffer Dall <cdall@linaro.org> wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
>
> We have 2 modes for dealing with interrupts in the ARM world. We can
> either handle them all using hardware acceleration through the vgic or
> we can emulate a gic in user space and only drive CPU IRQ pins from
> there.
>
> Unfortunately, when driving IRQs from user space, we never tell user
> space about events from devices emulated inside the kernel, which may
> result in interrupt line state changes, so we lose out on for example
> timer and PMU events if we run with user space gic emulation.
>
> Define an ABI to publish such device output levels to userspace.
>
> Signed-off-by: Alexander Graf <agraf@suse.de>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>


Acked-by: Peter Maydell <peter.maydell@linaro.org>

for the userspace ABI/docs part.

thanks
-- PMM
