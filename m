From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 07/20] KVM: arm/arm64: Make timer_arm and timer_disarm helpers more generic
Date: Wed, 25 Oct 2017 14:49:14 +0100
Message-ID: <86bmkvcp7p.fsf@arm.com>
References: <20171020114939.12554-1-christoffer.dall@linaro.org>
        <20171020114939.12554-8-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171020114939.12554-8-christoffer.dall@linaro.org> (Christoffer
        Dall's message of "Fri, 20 Oct 2017 13:49:26 +0200")
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Shih-Wei Li <shihwei@cs.columbia.edu>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 20 2017 at  1:49:26 pm BST, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> From: Christoffer Dall <cdall@linaro.org>
>
> We are about to add an additional soft timer to the arch timer state for
> a VCPU and would like to be able to reuse the functions to program and
> cancel a timer, so we make them slightly more generic and rename to make
> it more clear that these functions work on soft timers and not the
> hardware resource that this code is managing.
>
> The armed flag on the timer state is only used to assert a condition,
> and we don't rely on this assertion in any meaningful way, so we can
> simply get rid of this flack and slightly reduce complexity.
>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
