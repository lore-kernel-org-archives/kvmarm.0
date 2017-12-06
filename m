From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 04/18] arm64: alternatives: Enforce alignment of struct
 alt_instr
Date: Wed, 6 Dec 2017 10:18:56 -0500
Message-ID: <20171206151856.GH28074@char.us.oracle.com>
References: <20171206143839.29223-1-marc.zyngier@arm.com>
 <20171206143839.29223-5-marc.zyngier@arm.com>
 <20171206144847.GA28074@char.us.oracle.com>
 <dd8995ce-3065-3aba-2d93-9ed91de5cd50@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0285949D6A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Dec 2017 10:15:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V4KFVdYV7qyo for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Dec 2017 10:15:55 -0500 (EST)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3D464406D0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Dec 2017 10:15:55 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <dd8995ce-3065-3aba-2d93-9ed91de5cd50@arm.com>
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Dec 06, 2017 at 02:57:29PM +0000, Marc Zyngier wrote:
> On 06/12/17 14:48, Konrad Rzeszutek Wilk wrote:
> > On Wed, Dec 06, 2017 at 02:38:25PM +0000, Marc Zyngier wrote:
> >> We're playing a dangerous game with struct alt_instr, as we produce
> >> it using assembly tricks, but parse them using the C structure.
> >> We just assume that the respective alignments of the two will
> >> be the same.
> >>
> >> But as we add more fields to this structure, the alignment requirements
> >> of the structure may change, and lead to all kind of funky bugs.
> >>
> >> TO solve this, let's move the definition of struct alt_instr to its
> >> own file, and use this to generate the alignment constraint from
> >> asm-offsets.c. The various macros are then patched to take the
> >> alignment into account.
> > 
> > Would it be better to use .p2align as on 32-bit ARM you must
> > have it 4-byte aligned. Or at least have and BUILD_BUG_ON
> > to make sure the size can be divided by four??
> > 
> > Oh wait. You are not even touching ARM-32, how come? The alternative
> > code can run on ARM-32 ...
> 
> How? Given that I haven't written yet, I'd be grateful if you could
> share your time machine...

Oh! I assumed it would be there as the Xen variant runs on ARM-32 and
it borrowed a bunch of code from Linux. 

Please disregard my comment. I will go back to tweaking the time machine.
> 
> Thanks,
> 
> 	M.
> -- 
> Jazz is not dead. It just smells funny...
