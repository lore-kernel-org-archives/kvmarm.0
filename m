From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 00/21] arm64: Virtualization Host Extension support
Date: Mon, 25 Jan 2016 17:26:17 +0100
Message-ID: <1602215.WjO3PgfQ53@wuerfel>
References: <1453737235-16522-1-git-send-email-marc.zyngier@arm.com>
 <2703557.vyWRuMlGU2@wuerfel> <56A64C09.4060702@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76597400E9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2016 11:21:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C6LOolBWqP5Y for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Jan 2016 11:21:35 -0500 (EST)
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 27EB840F90
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2016 11:21:34 -0500 (EST)
In-Reply-To: <56A64C09.4060702@arm.com>
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Monday 25 January 2016 16:23:37 Marc Zyngier wrote:
> On 25/01/16 16:15, Arnd Bergmann wrote:
> > On Monday 25 January 2016 15:53:34 Marc Zyngier wrote:
> >> host and guest, reducing the overhead of virtualization.
> >>
> >> In order to have the same kernel binary running on all versions of the
> >> architecture, this series makes heavy use of runtime code patching.
> >>
> >> The first 20 patches massage the KVM code to deal with VHE and enable
> >> Linux to run at EL2. The last patch catches an ugly case when VHE
> >> capable CPUs are paired with some of their less capable siblings. This
> >> should never happen, but hey...
> >>
> >> I have deliberately left out some of the more "advanced"
> >> optimizations, as they are likely to distract the reviewer from the
> >> core infrastructure, which is what I care about at the moment.
> > 
> > One question: as you mention that you use a lot of runtime code patching
> > to make this work transparently, how does this compare to runtime patching
> > the existing kernel to run in EL2 mode without VHE? Is that even possible?
> 
> I haven't explored that particular avenue - by the look of it, this
> would require a lot more work, as v8.0 EL2 lacks a number of features
> that Linux currently requires (like having two TTBRs, for example).

Ok, I see.

> > My interpretation so far as always been "that's too complicated to
> > do because it would require a lot of runtime patching", but now we seem
> > to get that anyway because we want to run a hypervisor-enabled kernel in
> > either EL1 or EL2 depending on the presence of another feature.
> 
> The kernel itself is mostly untouched (what runs at EL1 also runs at EL2
> without any patching, because the new EL2 is now a superset of EL1). It
> is the hypervisor code that gets a beating with the code-patching stick.

Thanks for the explanation, makes sense.

	Arnd
