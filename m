From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PULL 00/28] KVM/ARM Changes for v4.16
Date: Wed, 31 Jan 2018 18:16:03 +0100
Message-ID: <20180131171602.GA26944@flask>
References: <20180131093507.22219-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180131093507.22219-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

2018-01-31 10:34+0100, Christoffer Dall:
> Hi Paolo and Radim,
> 
> Apologies for getting this pull request to you rather late; there were a
> number of issues that I wanted to make sure we could fix properly before
> including some of the changes in this pull request.
> 
> The changes for this version include icache invalidation optimizations
> (improving VM startup time), support for forwarded level-triggered
> interrupts (improved performance for timers and passthrough platform
> devices), a small fix for power-management notifiers, and some cosmetic
> changes.

Pulled, thanks.
