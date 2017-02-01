From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v4 2/4] arm64: Work around Falkor erratum 1003
Date: Wed, 1 Feb 2017 18:22:44 +0000
Message-ID: <20170201182244.GH26507@e104818-lin.cambridge.arm.com>
References: <20170125155232.10277-2-cov@codeaurora.org>
 <20170131123735.GD11191@leverpostej>
 <36478002-4cd8-7f1c-1a25-8bfe35022a47@codeaurora.org>
 <3cab36fb-984a-beae-64db-6ce830ba94f6@arm.com>
 <b4cf83d2-ae05-3362-bc23-2341d00516dc@codeaurora.org>
 <20170201163358.GG8177@arm.com>
 <20170201173609.GE26507@e104818-lin.cambridge.arm.com>
 <20170201174105.GK8177@arm.com>
 <20170201174934.GF26507@e104818-lin.cambridge.arm.com>
 <20170201175947.GL8177@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170201175947.GL8177@arm.com>
Sender: linux-doc-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Mark Langsdorf <mlangsdo@redhat.com>, kvm@vger.kernel.org, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, Jon Masters <jcm@redhat.com>, timur@codeaurora.org, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, shankerd@codeaurora.org, Christopher Covington <cov@codeaurora.org>, Neil Leeder <nleeder@codeaurora.org>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 01, 2017 at 05:59:48PM +0000, Will Deacon wrote:
> On Wed, Feb 01, 2017 at 05:49:34PM +0000, Catalin Marinas wrote:
> > On Wed, Feb 01, 2017 at 05:41:05PM +0000, Will Deacon wrote:
> > > On Wed, Feb 01, 2017 at 05:36:09PM +0000, Catalin Marinas wrote:
> > > > On Wed, Feb 01, 2017 at 04:33:58PM +0000, Will Deacon wrote:
> > > > > On Wed, Feb 01, 2017 at 11:29:22AM -0500, Christopher Covington wrote:
> > > > > > On 01/31/2017 12:56 PM, Marc Zyngier wrote:
> > > > > > > Given that all ARMv8 CPUs can support SW_PAN, it is more likely to be
> > > > > > > enabled than the ARMv8.1 PAN. I'd vote for supporting the workaround in
> > > > > > > that case too, and hope that people do enable the HW version.
> > > > > > 
> > > > > > Okay, I'll do my best to add support for the SW PAN case. I rebased and
> > > > > > submitted v6 of the E1009 patch [1] so that it no longer depends on this
> > > > > > patch landing first, if you all are inclined to pick it up while work on
> > > > > > this E1003 patch continues.
> > > > > 
> > > > > The alternative is not enabling SW_PAN (at runtime) if this errata is
> > > > > present, along with a warning stating that hardware-PAN should be
> > > > > enabled in kconfig instead. Not sure what distributions will make of that
> > > > > though.
> > > > 
> > > > The problem with this patch is that when ARM64_SW_TTBR0_PAN is enabled
> > > > and in the absence of hardware PAN (or ARM64_PAN disabled),
> > > > cpu_do_switch_mm is no longer called for user process switching, so the
> > > > workaround is pretty much useless.
> > > 
> > > Oh, I see what you mean now.
> > > 
> > > > I'm ok with adding the Kconfig dependency below to
> > > > QCOM_FALKOR_ERRATUM_1003:
> > > > 
> > > > 	depends on !ARM64_SW_TTBR0_PAN || ARM64_PAN
> > > > 
> > > > together with a run-time warning if ARM64_SW_TTBR0_PAN is being used.
> > > 
> > > That makes it look like hardware-PAN is the cause of the erratum.
> > 
> > With the right Kconfig comment we could make this clearer.
> 
> It's not just a comment though, the kconfig option for the workaround
> will disappear from menuconfig as long as the dependencies aren't met.
> The dependency is really that SW_PAN depends on !ERRATUM_1003, but that
> doesn't work for the distributions.

I agree.

> > > Maybe
> > > just select ARM64_PAN if the erratum workaround is selected, then
> > > runtime warning if we find that the h/w doesn't have PAN but does have
> > > the erratum (which should never fire)?
> > 
> > You still need this workaround even if you don't want any PAN (both sw
> > and hw PAN disabled). I wouldn't want to select ARM64_PAN since it's not
> > a dependency. It's more like if you do need a PAN, make sure you only
> > use the hw one.
> 
> True, in the case that all PAN options are disabled we still want this
> to work. How about:
> 
>   select ARM64_PAN if ARM64_SW_TTBR0_PAN

As I replied to myself, the above would work for me as well, so let's go
for this.

> In fact, what's the reason for supporting SW_PAN and ARM64_PAN as a
> config combination? Why not just have "PAN" that enables them both and
> uses the hardware feature if it's there?

Because SW PAN has a non-trivial performance hit. You would enable SW
PAN only if you are paranoid about security. HW PAN, OTOH, is very cheap
and I wouldn't want to miss enabling it in a single Image supporting
ARMv8.0 and ARMv8.1 just because SW PAN is slow on ARMv8.0.

IOW, ARM64_PAN is default y while ARM64_SW_TTBR0_PAN is default n.

-- 
Catalin
