From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 0/5] arm/arm64: Making HYP vgic/timer save/restore
 common
Date: Tue, 9 Feb 2016 21:38:03 +0100
Message-ID: <20160209203803.GD5171@cbox>
References: <1453996565-19666-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1453996565-19666-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 28, 2016 at 03:56:00PM +0000, Marc Zyngier wrote:
> With the current state of the C conversion of arm and arm64 world
> switches, we are still unable to share some of the most obvious
> candidates (GIC and timer save/restore). In order to reduce the bloat,
> let's move these files to a common location (virt/kvm/arm/hyp).
> 
> The changes are extremely mechanical, with a small hack to deal with
> system register names on the 32bit side (I've decided to align on the
> 64bit names).
> 
> I'd like to know what people think of the common location. Does it
> makes sense to have a "hyp" subdirectory to indicate that this is not
> "normal" kernel code?
> 
> These patches are on top of 4.5-rc1, plus the VHE and 32bit WS rewrite
> patches, and I've pushed out a branch at
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/mov-hyp
> 

ack on this series, tested on TC2 and Mustang as well.

-Christoffer
