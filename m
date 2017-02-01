From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v4 2/4] arm64: Work around Falkor erratum 1003
Date: Wed, 1 Feb 2017 18:34:01 +0000
Message-ID: <20170201183400.GA31652@arm.com>
References: <20170131123735.GD11191@leverpostej>
 <36478002-4cd8-7f1c-1a25-8bfe35022a47@codeaurora.org>
 <3cab36fb-984a-beae-64db-6ce830ba94f6@arm.com>
 <b4cf83d2-ae05-3362-bc23-2341d00516dc@codeaurora.org>
 <20170201163358.GG8177@arm.com>
 <20170201173609.GE26507@e104818-lin.cambridge.arm.com>
 <20170201174105.GK8177@arm.com>
 <20170201174934.GF26507@e104818-lin.cambridge.arm.com>
 <20170201175947.GL8177@arm.com>
 <20170201182244.GH26507@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D48540C41
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 13:33:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0VCncV0dxbOx for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Feb 2017 13:33:40 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2FE340C25
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 13:33:40 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20170201182244.GH26507@e104818-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Langsdorf <mlangsdo@redhat.com>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Jon Masters <jcm@redhat.com>, timur@codeaurora.org, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>, Neil Leeder <nleeder@codeaurora.org>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 01, 2017 at 06:22:44PM +0000, Catalin Marinas wrote:
> On Wed, Feb 01, 2017 at 05:59:48PM +0000, Will Deacon wrote:
> > On Wed, Feb 01, 2017 at 05:49:34PM +0000, Catalin Marinas wrote:
> > > On Wed, Feb 01, 2017 at 05:41:05PM +0000, Will Deacon wrote:
> > > > Maybe
> > > > just select ARM64_PAN if the erratum workaround is selected, then
> > > > runtime warning if we find that the h/w doesn't have PAN but does have
> > > > the erratum (which should never fire)?
> > > 
> > > You still need this workaround even if you don't want any PAN (both sw
> > > and hw PAN disabled). I wouldn't want to select ARM64_PAN since it's not
> > > a dependency. It's more like if you do need a PAN, make sure you only
> > > use the hw one.
> > 
> > True, in the case that all PAN options are disabled we still want this
> > to work. How about:
> > 
> >   select ARM64_PAN if ARM64_SW_TTBR0_PAN
> 
> As I replied to myself, the above would work for me as well, so let's go
> for this.
> 
> > In fact, what's the reason for supporting SW_PAN and ARM64_PAN as a
> > config combination? Why not just have "PAN" that enables them both and
> > uses the hardware feature if it's there?
> 
> Because SW PAN has a non-trivial performance hit. You would enable SW
> PAN only if you are paranoid about security. HW PAN, OTOH, is very cheap
> and I wouldn't want to miss enabling it in a single Image supporting
> ARMv8.0 and ARMv8.1 just because SW PAN is slow on ARMv8.0.
> 
> IOW, ARM64_PAN is default y while ARM64_SW_TTBR0_PAN is default n.

Ok, in that case, then how about another permutation: we make
ARM64_SW_TTBR0_PAN depend on ARM64_PAN? Then when you select "PAN Support"
you get a new menu option underneath it for the emulation? I think that
solves the erratum case and the use-case above.

Will
