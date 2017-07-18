From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH kvm-unit-tests 2/3] arm64: timer: Fix test on APM X-Gene
Date: Tue, 18 Jul 2017 12:05:03 +0200
Message-ID: <20170718100503.crn2dgqlalrirzqw@kamzik.brq.redhat.com>
References: <20170713192009.10069-1-cdall@linaro.org>
 <20170713192009.10069-3-cdall@linaro.org>
 <a58bfe11-19a0-aa92-5166-2c33e4cb8981@arm.com>
 <20170714154512.GC1535@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170714154512.GC1535@lvm>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Alexander Graf <agraf@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Jintack Lim <jintack@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jul 14, 2017 at 08:45:12AM -0700, Christoffer Dall wrote:
> On Fri, Jul 14, 2017 at 09:04:10AM +0100, Marc Zyngier wrote:
> > On 13/07/17 20:20, Christoffer Dall wrote:
> > > When running the vtimer test on an APM X-Gene, setting the timer value
> > > to (2^64 - 1) apparently results in the timer always firing, even
> > > thought the counter is mich lower than the cval.
> > 
> > Note that the system counter is only guaranteed to be at least 56 bit
> > wide (see DDI0487B.a G5.1.2), and I seem to remember that X-Gene only
> > has the minimum. This could explain why setting the comparator to a
> > value greater than (2^56 - 1) leads to a firing timer (the comparator
> > appears to be in the past).

Ah, that explains why when I tried setting it to ~0 on my mustang, and
then reading it back, it was always 2^56 - 1 instead. However my mustang
still also requires me to clear bit 31, otherwise the vcpu hangs.

> 
> Thanks for pointing that out, that makes good sense.  So then we should
> definitely fix the test.
> 
> We could either set it to 2^56 - 1 instead, or just keep the 10s as used
> in this patch, because the whole test times out after 2s anyway.

With the 10s version the test runs and passes on my mustang, so on one
hand I prefer it. OTOH, testing to the spec, by using 2^56 - 1, seems
more correct and allows one to find issues like the one I have on my
mustang, i.e. a vcpu hang when bit 31 isn't clear.

I guess I lean more towards testings to the spec, but not enough to
ask for a v2 of the patch. It's up to you.

Thanks,
drew
