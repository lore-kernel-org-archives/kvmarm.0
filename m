From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 00/26] KVM: arm64: SVE guest support
Date: Tue, 26 Mar 2019 11:28:43 +0000
Message-ID: <20190326112841.GQ3567@e103592.cambridge.arm.com>
References: <1553017938-710-1-git-send-email-Dave.Martin@arm.com>
 <20190325163249.rkk6vvnzex5d4z7k@kamzik.brq.redhat.com>
 <CAFEAcA8K8Q969=3YyeuQso=0Y-MiPnyCCz1DhjtjV9UTc2p0Og@mail.gmail.com>
 <20190325164956.srlnsw6likpnfozl@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 751514A37D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Mar 2019 07:28:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3VtqSP5Zzhxy for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Mar 2019 07:28:49 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20A524A2E5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Mar 2019 07:28:49 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20190325164956.srlnsw6likpnfozl@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 25, 2019 at 05:49:56PM +0100, Andrew Jones wrote:
> On Mon, Mar 25, 2019 at 04:38:03PM +0000, Peter Maydell wrote:
> > On Mon, 25 Mar 2019 at 16:33, Andrew Jones <drjones@redhat.com> wrote:
> > >
> > > On Tue, Mar 19, 2019 at 05:51:51PM +0000, Dave Martin wrote:
> > > > This series implements support for allowing KVM guests to use the Arm
> > > > Scalable Vector Extension (SVE), superseding the previous v5 series [1].
> > 
> > > Hi Dave and Peter,
> > >
> > > Do either of you know if anyone has picked up the QEMU side of this?
> > > If not, then I'll take it.
> > 
> > Nobody has yet, so feel free.
> >
> 
> OK, hopefully I'll get something sent by the end of next week.

If one of you guys can review the patches with QEMU in mind in the
meantime, that would be very helpful.

Just looking at the documentation updates would be a good place to
start.

Cheers
---Dave
