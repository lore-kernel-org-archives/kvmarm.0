From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 0/5] KVM/ARM: Fixes for 4.12-rc1
Date: Mon, 15 May 2017 11:33:27 +0200
Message-ID: <20170515093327.GI9309@cbox>
References: <20170502133041.10980-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170502133041.10980-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On Tue, May 02, 2017 at 02:30:36PM +0100, Marc Zyngier wrote:
> Here's a handful of random fixes I've queued locally that didn't have
> a chance to make it in 4.11.
> 
> The first two patches avoid stack-protector messing with the HYP code,
> as this ends up being a complete disaster.
> 
> The following two patches fix a bug introduced in the new vgic, where
> we may queue HW interrupts with the Pending+Active state, which is
> illegal.
> 
> The final patch fixes a misinterpretation of the spec, where we
> compute the number of APxRn register based on the number of priorities
> instead of using the number of preemption levels.
> 
> I've tagged the first 4 patches for stable, given that we're doing
> something potentially harmful. The last patch is more of a theoretical
> issue at this stage, so probably need for a backport.

I've applied these to kvmarm/master including the initial patches to
disable the stack-protecter for EL2/HYP.

Once you figure out what to do with -fpic/-fpie/-mcmodel=small we can
deal with that as follow-up patches.

Thanks,
-Christoffer
