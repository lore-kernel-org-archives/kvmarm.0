From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 0/2] arm/arm64: KVM: Optimize arm64 fp/simd, saves
 30-50% on exits for non-VHE
Date: Thu, 16 Jul 2015 17:52:53 +0200
Message-ID: <20150716155253.GU7845@cbox>
References: <1436577547-5646-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436577547-5646-1-git-send-email-m.smarduch@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jul 10, 2015 at 06:19:05PM -0700, Mario Smarduch wrote:
> This is a followp to previous iteration but implemented on top of VHE patches. 
> Only non-VHE path is addressied by this patch. In second patch 32-bit handler 
> is updated to keep exit handling consistent with 64-bit code, and nothing
> has changed.
> 
Why not simply preserve this the way it was in v3 and have it merged
first - after all we have reviewed it and I thought it was more or less
ready to be merged - I suspect the VHE patches may have a way to go
still ?

-Christoffer
