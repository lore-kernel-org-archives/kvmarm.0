From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH kvm-unit-tests] arm64: timer: Use correct counter for
 !pending_before
Date: Thu, 3 Aug 2017 15:09:25 +0200
Message-ID: <20170803130925.GB1015@flask>
References: <20170803062545.17533-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170803062545.17533-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Andrew Jones <drjones@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

2017-08-03 08:25+0200, Christoffer Dall:
> We were using the virtual counter to calculate a timer cval which is 10
> seconds in the future, but this obviously doesn't work for the physical
> timer which is bases on the physical counter.
> 
> Make sure we use a properly paired timer/counter pair.
> 
> Reported-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---

Applied, thanks.
