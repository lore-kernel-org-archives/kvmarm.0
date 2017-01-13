From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 2/3] KVM: arm64: Access CNTHCTL_EL2 bit fields correctly
 on VHE systems
Date: Fri, 13 Jan 2017 14:46:23 +0000
Message-ID: <20170113144622.GC2472@leverpostej>
References: <1484307093-29153-1-git-send-email-marc.zyngier@arm.com>
 <1484307093-29153-3-git-send-email-marc.zyngier@arm.com>
 <20170113123612.GA31994@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170113123612.GA31994@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 13, 2017 at 01:36:12PM +0100, Christoffer Dall wrote:
> On Fri, Jan 13, 2017 at 11:31:32AM +0000, Marc Zyngier wrote:

> Further, are we guaranteed that the static branch gets compiled into
> something that doesn't actually look at cpu_hwcap_keys, which is not
> mapped in hyp mode?

The fact that this might happen silently seems to be a larger problem.

Can we do something like the EFI stub, and ensure that (unintentional)
references to symbols outside of the hyp-stub will fail to link? That's
ensrue by some symbol mangling in drivers/firmware/efi/libstub/Makefile.

I think this may have come up before; I can't recall if there was some
reason that was problematic.

Thanks,
Mark.
