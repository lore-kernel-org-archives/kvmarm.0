From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 00/14] KVM: arm64: SVE cleanups
Date: Thu, 25 Apr 2019 14:05:14 +0100
Message-ID: <20190425130514.GB3567@e103592.cambridge.arm.com>
References: <1555603631-8107-1-git-send-email-Dave.Martin@arm.com>
 <875zr2w9cj.fsf@zen.linaroharston>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAFC84A369
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 09:05:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LuZo6z3nFUS4 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Apr 2019 09:05:19 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 893DF4A32E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 09:05:19 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <875zr2w9cj.fsf@zen.linaroharston>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 25, 2019 at 01:35:56PM +0100, Alex Benn=E9e wrote:
> =

> Dave Martin <Dave.Martin@arm.com> writes:
> =

> > This series contains some cleanups applicable to the SVE KVM support
> > patches merged into kvmarm/next.  These arose from Andrew Jones'
> > review.
> >
> > Apart from some minor changes to error codes and checking, these are
> > mostly cosmetic / sytlistic changes only.
> >
> > The patches are based on
> > git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
> > 5d8d4af24460 ("arm64: KVM: Fix system register enumeration")
> >
> > This series in git:
> > git://linux-arm.org/linux-dm.git sve-kvm-fixes/v2/head
> > http://linux-arm.org/git?p=3Dlinux-dm.git;a=3Dshortlog;h=3Drefs/heads/s=
ve-kvm-fixes/v2/head
> >
> > Tested with qemu and kvmtool on ThunderX2, and with kvmtool on the Arm
> > Fast model (to exercise SVE support).
> =

> These all look good to me:
> =

> Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>

Thanks for the review!

Cheers
---Dave
