From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm64: Decode basic HYP fault information
Date: Mon, 31 Aug 2015 11:49:27 +0200
Message-ID: <20150831094927.GL24113@cbox>
References: <00aa01d0d408$1ba96ea0$52fc4be0$@samsung.com>
 <20150830174434.GG24113@cbox>
 <012d01d0e3b6$fa327c30$ee977490$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <012d01d0e3b6$fa327c30$ee977490$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Aug 31, 2015 at 09:33:40AM +0300, Pavel Fedin wrote:
>  Hello!
> 
> > my overall concern with this patch is that it adds complexity to an
> > already really bad situation, and potentially increases the likelihood
> > of not seeing any debug info at all.
> 
>  Why? In this case we currently already drop into C code. I do the same, with some more useful
> printout. What is fundamentally changed?
> 
Fundamentally what's changed is that you now run more custom code in C
code.

I'll think about it.

-Christoffer
