From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 0/7]  arm64: KVM: vgic-v2: Allow unsafe GICV accesses
Date: Tue, 6 Sep 2016 13:14:50 +0200
Message-ID: <20160906111450.GN30513@cbox>
References: <1473150527-4729-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1473150527-4729-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Peter Maydell <peter.maydell@linaro.org>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Sep 06, 2016 at 09:28:40AM +0100, Marc Zyngier wrote:
> In a number of cases, KVM cannot give access direct access to the
> GICv2 GICV region, either because GICV is not page aligned, or its
> size is not a multiple of the page size. This is especially visible
> with 16kB/64kB pages and the original GIC-400 layout where each region
> is only 4k aligned.
> 
> Instead of disabling KVM altogether (which is the current behaviour),
> there is some value in trapping each guest GICV access, performing the
> access as quickly as possible at EL2, and resuming the guest. This
> allows us to keep KVM enabled on this HW.
> 
> Implementation wise, this is done with a static key controlling the
> workaround being enabled, hence coming at zero cost (well, an extra
> nop on the exit hot path) for unaffected platforms. On the affected
> HW, I've measured a 10 to 15% overhead for a self-IPI test, which is
> pretty bad, but still much better than not having a GIC at all.
> 
> There is two pending issues:
> 
> - A failed write to GICV ends up being forwarded to userspace. This
>   will be addressed in a follow-up series where we deal with injecting
>   vSError in the guest
> 
> - Skipping instructions (as we do when emulating anything) breaks
>   things like guest single-step and watchpoints. This is a long
>   standing problem, and someone should probably have a look at
>   it. Alex?
> 
> Tested on Juno-r1 with 64kB pages.

I also tested this on TC2 to ensure we didn't regress the 32-bit side.

Applied the series.
-Christoffer
