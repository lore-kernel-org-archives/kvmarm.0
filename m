From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [kvm-unit-tests PATCH] arm/arm64: introduce is_aarch32
Date: Wed, 16 Nov 2016 17:45:44 +0000
Message-ID: <20161116174544.GE11228@leverpostej>
References: <1479307116-6355-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1479307116-6355-1-git-send-email-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, pbonzini@redhat.com, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 16, 2016 at 03:38:36PM +0100, Andrew Jones wrote:
> ARMv7-A isn't exactly the same as ARMv8-A32 (AArch32). This
> function allows unit tests to make the distinction.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> 
> ---
> I'm actually unsure if there's a feature bit or not that I could
> probe instead. It'd be nice if somebody can confirm. Thanks, drew

> +/*
> + * ARMv7-A isn't exactly the same as ARMv8-A32 (AArch32). This
> + * function allows unit tests to make the distinction.
> + */

What do you want this for, specifically?

Since the CPUID registers were introduced, the architecture goes to
great lengths to not expose a version, and trying to guess from software
is a losing battle.

So I don't think we should try to distinguish ARMv8-A AArch32 from
ARMv7-A. We should test individual features, or if that's not possible,
group them in the same bucket.

Thanks,
Mark.
