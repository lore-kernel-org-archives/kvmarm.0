From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 06/20] KVM: arm/arm64: Check that system supports split eoi/deactivate
Date: Wed, 25 Oct 2017 14:47:03 +0100
Message-ID: <86fua7cpbc.fsf@arm.com>
References: <20171020114939.12554-1-christoffer.dall@linaro.org>
        <20171020114939.12554-7-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171020114939.12554-7-christoffer.dall@linaro.org> (Christoffer
        Dall's message of "Fri, 20 Oct 2017 13:49:25 +0200")
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Shih-Wei Li <shihwei@cs.columbia.edu>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 20 2017 at  1:49:25 pm BST, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> From: Christoffer Dall <cdall@linaro.org>
>
> Some systems without proper firmware and/or hardware description data
> don't support the split EOI and deactivate operation.
>
> On such systems, we cannot leave the physical interrupt active after the
> timer handler on the host has run, so we cannot support KVM with an
> in-kernel GIC with the timer changes we are about to introduce.
>
> This patch makes sure that trying to initialize the KVM GIC code will
> fail on such systems.
>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
