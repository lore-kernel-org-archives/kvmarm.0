From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Simplify active_change_prepare and plug
 race
Date: Wed, 10 May 2017 11:23:06 +0100
Message-ID: <ab9a2195-6940-63ab-2ea6-a7a314253f2c@arm.com>
References: <20170510100118.4189-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170510100118.4189-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>, Andrew Jones <drjones@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 10/05/17 11:01, Christoffer Dall wrote:
> We don't need to stop a specific VCPU when changing the active state,
> because private IRQs can only be modified by a running VCPU for the
> VCPU itself and it is therefore already stopped.
> 
> However, it is also possible for two VCPUs to be modifying the active
> state of SPIs at the same time, which can cause the thread being stuck
> in the loop that checks other VCPU threads for a potentially very long
> time, or to modify the active state of a running VCPU.  Fix this by
> serializing all accesses to setting and clearing the active state of
> interrupts using the KVM mutex.
> 
> Reported-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
