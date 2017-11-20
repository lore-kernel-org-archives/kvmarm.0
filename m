From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 0/3] KVM: arm64: single step emulation instructions
Date: Mon, 20 Nov 2017 16:41:31 +0100
Message-ID: <20171120154131.GO28855@cbox>
References: <20171116153921.21991-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171116153921.21991-1-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: julien.thierry@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Alex,

On Thu, Nov 16, 2017 at 03:39:18PM +0000, Alex Bennée wrote:
> Hi,
> 
> This is rev 3 of the series, practically the same than rev 2 but fixed
> a return 1->0 in the kvm_run loop that Julien caught. I've added his
> r-b tags to the other patches.
> 
> As usual revision details bellow the --- in each patch.

Thanks for taking care of this.

I have applied the series and slightly tweaked the commit messages and
commentary.

Did we simply decide to not worry about exiting to userspace if we do
fast-path emulation, such as for the errata workaround and GIC
mashaling in switch.c ?

Thanks,
-Christoffer

> 
> Alex Bennée (3):
>   kvm: arm debug: introduce helper for single-step
>   kvm: arm64: handle single-stepping trapped instructions
>   kvm: arm64: handle single-step of userspace mmio instructions
> 
>  arch/arm/include/asm/kvm_host.h   |  5 +++++
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/kvm/debug.c            | 22 ++++++++++++++++++
>  arch/arm64/kvm/handle_exit.c      | 47 +++++++++++++++++++++++++++------------
>  virt/kvm/arm/arm.c                |  3 +++
>  5 files changed, 64 insertions(+), 14 deletions(-)
> 
> -- 
> 2.15.0
> 
