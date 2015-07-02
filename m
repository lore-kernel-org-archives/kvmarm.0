From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 0/2] arm/arm64: KVM: Optimize arm64 fp/simd, saves
 30-50% on exits
Date: Thu, 2 Jul 2015 22:58:43 +0200
Message-ID: <20150702205843.GA29818@cbox>
References: <1435190652-5831-1-git-send-email-m.smarduch@samsung.com>
 <20150701094910.GF11332@cbox>
 <5595798F.5060307@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5595798F.5060307@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jul 02, 2015 at 10:49:03AM -0700, Mario Smarduch wrote:
> On 07/01/2015 02:49 AM, Christoffer Dall wrote:
> > On Wed, Jun 24, 2015 at 05:04:10PM -0700, Mario Smarduch wrote:
> >> Currently we save/restore fp/simd on each exit. Fist  patch optimizes arm64
> >> save/restore, we only do so on Guest access. hackbench and
> >> several lmbench tests show anywhere from 30% to above 50% optimzation
> >> achieved.
> >>
> >> In second patch 32-bit handler is updated to keep exit handling consistent
> >> with 64-bit code.
> > 
> > 30-50% of what?  The overhead or overall performance?
> 
> Yes, so considering all exits to Host KVM anywhere from 30 to 50%
> didn't require an fp/simd switch.
> 
> Anything else you like to see added here?

No, I'm good with them.  Marc is handling the tree these days so I'll
leave it up to him if we want to adjust patch 1 or what to do.

Thanks!
-Christoffer
