From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH kvm-unit-tests 0/3] Add physical timer test
Date: Tue, 18 Jul 2017 12:17:07 +0200
Message-ID: <20170718101707.54zw5jbonyfaqadx@kamzik.brq.redhat.com>
References: <20170713192009.10069-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170713192009.10069-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Alexander Graf <agraf@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Jintack Lim <jintack@cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jul 13, 2017 at 09:20:06PM +0200, Christoffer Dall wrote:
> Add a test for the vtimer. I've tested on
>  accel=tcg
>  accel=kvm                     : on seattle, and mustang
>  accel=kvm,kernel-irqchip=off  : on mustang
> 
> I first fix two issues I had running the basic timer test on APM mustang
> on using TCG.  I wonder why the vtimer tests worked using TCG for Drew,
> since they didn't work for me, and I don't see how they would have
> without patch 1.

That's weird. I just tested again with a latest qemu master pull and it
still works for me without patch 1. However, as you and Marc discussed,
it's the right thing to do with regards to the spec.

> 
> Then I introduce a test for the physical timer.  If you run the ptimer
> test on a kernel before support for the physical timers was added you
> get a nice error message plus some spamming in your kernel log.

Thanks for contributing to kvm-unit-tests!

drew
