From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC v3 03/10] KVM: arm/arm64: Decouple kvm timer functions from
 virtual timer
Date: Thu, 2 Feb 2017 11:04:23 +0100
Message-ID: <20170202100423.GB27852@cbox>
References: <1485970990-13775-1-git-send-email-jintack@cs.columbia.edu>
 <1485970990-13775-4-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1485970990-13775-4-git-send-email-jintack@cs.columbia.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Jintack Lim <jintack@cs.columbia.edu>
Cc: pbonzini@redhat.com, rkrcmar@redhat.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, andre.przywara@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 01, 2017 at 12:43:03PM -0500, Jintack Lim wrote:
> Now that we have a separate structure for timer context, make functions
> generic so that they can work with any timer context, not just the
> virtual timer context.  This does not change the virtual timer
> functionality.
> 
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
