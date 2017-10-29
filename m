From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v5 02/20] arm64: Implement arch_counter_get_cntpct to
 read the physical counter
Date: Sun, 29 Oct 2017 02:51:27 +0100
Message-ID: <20171029015127.GG2166@lvm>
References: <1509093281-15225-1-git-send-email-cdall@linaro.org>
 <1509093281-15225-3-git-send-email-cdall@linaro.org>
 <20171027105323.hvbewckytr5gbpph@armageddon.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171027105323.hvbewckytr5gbpph@armageddon.cambridge.arm.com>
Sender: kvm-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, Eric Auger <eric.auger@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 27, 2017 at 11:53:24AM +0100, Catalin Marinas wrote:
> On Fri, Oct 27, 2017 at 10:34:23AM +0200, Christoffer Dall wrote:
> > From: Christoffer Dall <christoffer.dall@linaro.org>
> > 
> > As we are about to use the physical counter on arm64 systems that have
> > KVM support, implement arch_counter_get_cntpct() and the associated
> > errata workaround functionality for stable timer reads.
> > 
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will.deacon@arm.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> 
> Just in case you need an ack for the arch/arm64/ hunks:
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks Catalin!
-Christoffer
