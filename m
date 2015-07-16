From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 0/2] arm/arm64: KVM: Optimize arm64 fp/simd, saves
 30-50% on exits for non-VHE
Date: Thu, 16 Jul 2015 21:05:29 +0200
Message-ID: <20150716190529.GA14369@cbox>
References: <1436577547-5646-1-git-send-email-m.smarduch@samsung.com>
 <20150716155253.GU7845@cbox>
 <55A7F68C.6020903@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55A7F68C.6020903@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jul 16, 2015 at 11:23:08AM -0700, Mario Smarduch wrote:
> On 07/16/2015 08:52 AM, Christoffer Dall wrote:
> > On Fri, Jul 10, 2015 at 06:19:05PM -0700, Mario Smarduch wrote:
> >> This is a followp to previous iteration but implemented on top of VHE patches. 
> >> Only non-VHE path is addressied by this patch. In second patch 32-bit handler 
> >> is updated to keep exit handling consistent with 64-bit code, and nothing
> >> has changed.
> >>
> > Why not simply preserve this the way it was in v3 and have it merged
> > first - after all we have reviewed it and I thought it was more or less
> > ready to be merged - I suspect the VHE patches may have a way to go
> > still ?
> 
> Definitely, that's a better path. After looking at VHE patches,
> I would probably leave V3 the way it is (keeping deactivate_xxxx:
> symmetric). Marc has Reviewed V3 and you commented either way was
> fine with you, so V3 should be ok.

Yes, but there was a comment in the assembly file to fix up IIRC.

Can you do a quick respin with that commentary changed and then Marc
can queue that if he agrees?

Thanks,
-Christoffer
