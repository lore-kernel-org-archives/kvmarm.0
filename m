From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC v3 02/10] KVM: arm/arm64: Move cntvoff to each timer context
Date: Thu, 2 Feb 2017 11:03:39 +0100
Message-ID: <20170202100339.GA27852@cbox>
References: <1485970990-13775-1-git-send-email-jintack@cs.columbia.edu>
 <1485970990-13775-3-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1485970990-13775-3-git-send-email-jintack@cs.columbia.edu>
Sender: kvm-owner@vger.kernel.org
To: Jintack Lim <jintack@cs.columbia.edu>
Cc: pbonzini@redhat.com, rkrcmar@redhat.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, andre.przywara@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 01, 2017 at 12:43:02PM -0500, Jintack Lim wrote:
> Make cntvoff per each timer context. This is helpful to abstract kvm
> timer functions to work with timer context without considering timer
> types (e.g. physical timer or virtual timer).
> 
> This also would pave the way for ever doing adjustments of the cntvoff
> on a per-CPU basis if that should ever make sense.
> 
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
