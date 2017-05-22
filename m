From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 1/3] KVM: arm/arm64: Allow GICv2 to supply a uaccess
 register function
Date: Mon, 22 May 2017 16:21:38 +0100
Message-ID: <2d277bff-da18-f996-8cf3-88dc9b8abf61@arm.com>
References: <20170516100431.4101-1-cdall@linaro.org>
 <20170516100431.4101-2-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170516100431.4101-2-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>, Andrew Jones <drjones@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 16/05/17 11:04, Christoffer Dall wrote:
> We are about to differentiate between writes from a VCPU and from
> userspace to the GIC's GICD_ISACTIVER and GICD_ICACTIVER registers due
> to different synchronization requirements.
> 
> Expand the macro to define a register description for the GIC to take
> uaccess functions as well.
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
