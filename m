From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2] arm64: Add support for new control bits CTR_EL0.DIC
 and CTR_EL0.IDC
Date: Wed, 21 Feb 2018 13:12:04 +0000
Message-ID: <20180221131203.GB7614@arm.com>
References: <1519095546-24420-1-git-send-email-shankerd@codeaurora.org>
 <20180221111233.gylb6v4yxqnn6gyj@localhost>
 <23d70753-a628-f2e4-84df-39e4021337f5@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <23d70753-a628-f2e4-84df-39e4021337f5@codeaurora.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Shanker Donthineni <shankerd@codeaurora.org>
Cc: Philip Elcan <pelcan@codeaurora.org>, Vikram Sethi <vikrams@codeaurora.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, Thomas Speier <tspeier@codeaurora.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 21, 2018 at 07:10:34AM -0600, Shanker Donthineni wrote:
> On 02/21/2018 05:12 AM, Catalin Marinas wrote:
> > However, my worry is that in an implementation with DIC set, we also
> > skip the DSB/ISB sequence in the invalidate_icache_by_line macro. For
> > example, in an implementation with transparent PoU, we could have:
> > 
> > 	str	<some instr>, [addr]
> > 	// no cache maintenance or barrier
> > 	br	<addr>
> > 
> 
> Thanks for pointing out the missing barriers. I think it make sense to follow
> the existing barrier semantics in order to avoid the unknown things.
>  
> > Is an ISB required between the instruction store and execution? I would
> > say yes but maybe Will has a better opinion here.
> > 
> Agree, an ISB is required especially for self-modifying code. I'll include in v3 patch. 

I'd have thought you'd need a DSB too, before the ISB.

Will
