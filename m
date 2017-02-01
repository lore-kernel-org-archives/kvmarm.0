From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v4 2/4] arm64: Work around Falkor erratum 1003
Date: Wed, 1 Feb 2017 17:36:09 +0000
Message-ID: <20170201173609.GE26507@e104818-lin.cambridge.arm.com>
References: <20170125155232.10277-1-cov@codeaurora.org>
 <20170125155232.10277-2-cov@codeaurora.org>
 <20170131123735.GD11191@leverpostej>
 <36478002-4cd8-7f1c-1a25-8bfe35022a47@codeaurora.org>
 <3cab36fb-984a-beae-64db-6ce830ba94f6@arm.com>
 <b4cf83d2-ae05-3362-bc23-2341d00516dc@codeaurora.org>
 <20170201163358.GG8177@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170201163358.GG8177@arm.com>
Sender: linux-doc-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Christopher Covington <cov@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Mark Langsdorf <mlangsdo@redhat.com>, kvm@vger.kernel.org, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, timur@codeaurora.org, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, shankerd@codeaurora.org, linux-arm-kernel@lists.infradead.org, Neil Leeder <nleeder@codeaurora.org>, Jon Masters <jcm@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 01, 2017 at 04:33:58PM +0000, Will Deacon wrote:
> On Wed, Feb 01, 2017 at 11:29:22AM -0500, Christopher Covington wrote:
> > On 01/31/2017 12:56 PM, Marc Zyngier wrote:
> > > Given that all ARMv8 CPUs can support SW_PAN, it is more likely to be
> > > enabled than the ARMv8.1 PAN. I'd vote for supporting the workaround in
> > > that case too, and hope that people do enable the HW version.
> > 
> > Okay, I'll do my best to add support for the SW PAN case. I rebased and
> > submitted v6 of the E1009 patch [1] so that it no longer depends on this
> > patch landing first, if you all are inclined to pick it up while work on
> > this E1003 patch continues.
> 
> The alternative is not enabling SW_PAN (at runtime) if this errata is
> present, along with a warning stating that hardware-PAN should be
> enabled in kconfig instead. Not sure what distributions will make of that
> though.

The problem with this patch is that when ARM64_SW_TTBR0_PAN is enabled
and in the absence of hardware PAN (or ARM64_PAN disabled),
cpu_do_switch_mm is no longer called for user process switching, so the
workaround is pretty much useless.

I'm ok with adding the Kconfig dependency below to
QCOM_FALKOR_ERRATUM_1003:

	depends on !ARM64_SW_TTBR0_PAN || ARM64_PAN

together with a run-time warning if ARM64_SW_TTBR0_PAN is being used.

I'm not keen on adding the workaround to the uaccess macros. They are
complex enough already and people who do want SW PAN (and single Image)
would end up with 6-8 extra unnecessary nops on each side of a uaccess
(and nops are not entirely free).

-- 
Catalin
