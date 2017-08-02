From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Use READ_ONCE fo cmpxchg
Date: Wed, 2 Aug 2017 17:51:05 +0100
Message-ID: <20170802165104.pscynj55n7wm35no@armageddon.cambridge.arm.com>
References: <20170802142842.9494-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170802142842.9494-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 02, 2017 at 04:28:42PM +0200, Christoffer Dall wrote:
> There is a small chance that the compiler could generate separate loads
> for the dist->propbaser which could be modified from another CPU.  As we
> want to make sure we atomically update the entire value, and don't race
> with other updates, guarantee that the cmpxchg operation compares
> against the original value.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>

FWIW:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
