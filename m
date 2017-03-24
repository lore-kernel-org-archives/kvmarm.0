From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 00/28] arm/arm64: KVM: Rework the hyp-stub API
Date: Fri, 24 Mar 2017 15:36:08 +0100
Message-ID: <20170324143608.GF25903@cbox>
References: <20170321192058.9300-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170321192058.9300-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Russell King <linux@arm.linux.org.uk>, Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Keerthy <j-keerthy@ti.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On Tue, Mar 21, 2017 at 07:20:30PM +0000, Marc Zyngier wrote:
> As noticed by RMK in this thread[1], the hyp-stub API on 32bit ARM
> could do with some TLC (it cannot perform a soft-restart at HYP, and
> has holes in the hyp-stub support in a number of places). In general,
> it would be desirable for the 32bit behaviour to align on 64bit, if
> only to ease maintenance.
> 
> This series implements the following:
> - Add HVC_[GS]ET_VECTORS and HVC_SOFT_RESTART to the 32bit code
> - Add HVC_RESET_VECTORS to both arm and arm64, removing the need for
>   __hyp_reset_vectors
> - Implement add the stub entry points in the KVM init code, which
>   didn't implement any so far
> - Convert the HYP code to use the init code stubs directly
> - Some general cleanup as a result of these changes (which includes
>   killing HVC_GET_VECTORS)
> - Add some API documentation that covers the above
> 
> Patches 12 to 14 would be better squashed into 10 and 11, but I've
> kept them separate so that I can take the blame for everything I've
> broken.
> 
> I've tested this on arm (Cubietruck, Jetson TK1) and arm64 (Seattle),
> both as host and guest. Keerthy has been kind enough to test the 32bit
> code on DRA7-EVM, AM57XX-EVM and KEYSTONE-K2E-EVM.


For the series, except where I had some minor questions:

Acked-by: Christoffer Dall <cdall@linaro.org>


Thanks,
-Christoffer
