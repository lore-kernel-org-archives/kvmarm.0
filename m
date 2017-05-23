From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 2/9] KVM: arm: Handle VCPU device attributes in guest.c
Date: Tue, 23 May 2017 17:53:09 +0100
Message-ID: <e7327872-fc8e-e0d8-d2be-d52106c7ec7b@arm.com>
References: <20170516184556.26785-1-cdall@linaro.org>
 <20170516184556.26785-3-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170516184556.26785-3-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Alexander Graf <agraf@suse.de>
List-Id: kvmarm@lists.cs.columbia.edu

On 16/05/17 19:45, Christoffer Dall wrote:
> As we are about to support VCPU attributes to set the timer IRQ numbers
> in guest.c, move the static inlines for the VCPU attributes handlers
> from the header file to guest.c.
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
