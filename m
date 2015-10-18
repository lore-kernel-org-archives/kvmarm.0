From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFT - PATCH v2 0/2] KVM/arm64: add fp/simd lazy switch support
Date: Sun, 18 Oct 2015 23:07:38 +0200
Message-ID: <20151018210738.GF7531@cbox>
References: <1442964843-11953-1-git-send-email-m.smarduch@samsung.com>
 <20151005154540.GJ9011@cbox>
 <561BDFE3.5060403@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <561BDFE3.5060403@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 12, 2015 at 09:29:23AM -0700, Mario Smarduch wrote:
> Hi Christoffer, Marc -
>   I just threw this test your way without any explanation.

I'm confused.  Did you send me something somewhere already?

> 
> The test loops, does fp arithmetic and checks the truncated result.
> It could be a little more dynamic have an initial run to
> get the sum to compare against while looping, different fp
> hardware may come up with a different sum, but truncation is
> to 5'th decimal point.
> 
> The rationale is that if there is any fp/simd corruption
> one of these runs should fail. I think most likely scenario
> for that is a world switch in midst of fp operation. I've
> instrumented (basically add some tracing to vcpu_put()) and
> validated vcpu_put gets called thousands of time (for v7,v8)
> for an over night test running two guests/host crunching
> fp operations.
> 
> Other then that not sure how to really catch any problems
> with the patches applied. Obviously this is a huge issues, if this has
> any problems. If you or Marc have any other ideas I'd be happy
> to enhance the test.

I think it's important to run two VMs at the same time, each with some
floating-point work, and then run some floating point on the host at the
same time.

You can make that even more interesting by doing 32-bit guests at the
same time as well.

I believe Marc was running Panranoia
(http://www.netlib.org/paranoia/paranoia.c) to test the last lazy
series.

Thanks,
-Christoffer
