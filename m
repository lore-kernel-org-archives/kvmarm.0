From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 0/2] plug KVM ARMv7 debug leakage
Date: Mon, 15 May 2017 14:30:00 +0200
Message-ID: <20170515123000.GB18755@cbox>
References: <20170511124612.11212-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170511124612.11212-1-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 11, 2017 at 01:46:10PM +0100, Alex Bennée wrote:
> Hi,
> 
> This is pretty much v1 + comments from Marc and a minor re-factor of
> the trap path to make it cleaner w.r.t. cp14/cp15 trapping.

Thanks for these.

I've applied them to kvmarm/master and cc'ed the first one to stable.

-Christoffer
