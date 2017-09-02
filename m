From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH 3/4] KVM: arm/arm64: Rearrange kvm_vgic_[un]map_phys code in vgic.c
Date: Sat, 02 Sep 2017 12:14:28 +0100
Message-ID: <86y3pxtkrv.fsf@arm.com>
References: <20170829093902.15379-1-cdall@linaro.org>
        <20170829093902.15379-4-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170829093902.15379-4-cdall@linaro.org> (Christoffer Dall's
        message of "Tue, 29 Aug 2017 11:39:01 +0200")
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, Eric Auger <eric.auger@redhat.com>, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 29 2017 at 11:39:01 am BST, Christoffer Dall <cdall@linaro.org> wrote:
> The small indirection of a static function made the locking very obvious
> but becomes pretty ugly as we start passing function pointer around.
> Let's inline these two functions first to make the following patch more
> readable.
>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
