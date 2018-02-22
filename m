From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v3] arm64: Add support for new control bits CTR_EL0.DIC
 and CTR_EL0.IDC
Date: Thu, 22 Feb 2018 11:38:19 +0000
Message-ID: <20180222113818.6cknpwfbed2ab2nd@lakrids.cambridge.arm.com>
References: <1519220946-13901-1-git-send-email-shankerd@codeaurora.org>
 <20180221150929.hkvtwu4fgfeis5cy@salmiak>
 <5be4684b-e2d8-1b3b-4c96-03c7dae0b619@codeaurora.org>
 <0eb2d23b-cf96-c7ff-9820-16ed113f4862@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <0eb2d23b-cf96-c7ff-9820-16ed113f4862@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Robin Murphy <robin.murphy@arm.com>
Cc: Philip Elcan <pelcan@codeaurora.org>, Vikram Sethi <vikrams@codeaurora.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, shankerd@codeaurora.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 21, 2018 at 04:51:40PM +0000, Robin Murphy wrote:
> On 21/02/18 16:14, Shanker Donthineni wrote:
> [...]
> > > > @@ -1100,6 +1114,20 @@ static int cpu_copy_el2regs(void *__unused)
> > > >   		.enable = cpu_clear_disr,
> > > >   	},
> > > >   #endif /* CONFIG_ARM64_RAS_EXTN */
> > > > +#ifdef CONFIG_ARM64_SKIP_CACHE_POU
> > > > +	{
> > > > +		.desc = "DCache clean to POU",
> > > 
> > > This description is confusing, and sounds like it's describing DC CVAU, rather
> > > than the ability to ellide it. How about:
> > 
> > Sure, I'll take your suggestion.
> 
> Can we at least spell "elision" correctly please? ;)

Argh. Yes.

> Personally I read DIC and IDC as "D-cache to I-cache coherency" and "I-cache
> to D-cache coherency" respectively (just my interpretation, I've not looked
> into the spec work for any hints of rationale), but out loud those do sound
> so poorly-defined that keeping things in terms of the required maintenance
> probably is better.

So long as we have (IDC) and (DIC) in the text to avoid ambiguity, I'm
not that worried either way.

Thanks,
Mark.
