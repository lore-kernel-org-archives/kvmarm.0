From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 2/5] arm64: alternative: Allow immediate branch as
 alternative instruction
Date: Thu, 26 Mar 2015 22:31:51 +0000
Message-ID: <20150326223150.GD23836@arm.com>
References: <1426773576-14062-1-git-send-email-marc.zyngier@arm.com>
 <1426773576-14062-3-git-send-email-marc.zyngier@arm.com>
 <20150326220323.GA23836@arm.com> <20150326221955.4b8fe6f0@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A07AD49DD9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 18:24:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pE4A5cZkd6cU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Mar 2015 18:24:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 03D3B49DD8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 18:24:53 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20150326221955.4b8fe6f0@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Andre Przywara <Andre.Przywara@arm.com>, Dave P Martin <Dave.Martin@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Catalin Marinas <Catalin.Marinas@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 26, 2015 at 10:19:55PM +0000, Marc Zyngier wrote:
> On Thu, 26 Mar 2015 22:03:23 +0000
> Will Deacon <will.deacon@arm.com> wrote:
> > On Thu, Mar 19, 2015 at 01:59:33PM +0000, Marc Zyngier wrote:
> > > +		for (i = 0; i < alt->alt_len; i += sizeof(insn)) {
> > > +			insn = get_alt_insn(origptr + i, replptr + i);
> > > +			*(u32 *)(origptr + i) = insn;
> > 
> > My brain's not firing on all cylinders right now, but do you need a
> > cpu_to_le32 here?
> 
> I'm not 100% awake myself (probably some acute form of firmwaritis),
> but I suspect you're quite right (get_alt_insn calls aarch64_insn_read,
> which does a le32_to_cpu). Obviously, we need to revert the conversion
> when writing the instruction back.
> 
> Do you want a fixup on top of this, or would you prefer me to respin
> the series?

Please respin and add my acks.

Will
