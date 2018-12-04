From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH v2 00/23] KVM: arm64: Initial support for SVE guests
Date: Tue, 4 Dec 2018 15:50:36 +0000
Message-ID: <20181204155034.GS3505@e103592.cambridge.arm.com>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
 <875zwpi0sn.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41F164A1DE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Dec 2018 10:50:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F0UIFmh5pc9B for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Dec 2018 10:50:40 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DEAD54A1DD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Dec 2018 10:50:40 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <875zwpi0sn.fsf@linaro.org>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 22, 2018 at 03:34:16PM +0000, Alex Benn=E9e wrote:
> =

> Dave Martin <Dave.Martin@arm.com> writes:
> =

> > This series implements basic support for allowing KVM guests to use the
> > Arm Scalable Vector Extension (SVE).
> >
> > The patches are based on v4.19-rc5.
> >
> > The patches are also available on a branch for reviewer convenience. [1]
> >
> > This is a significant overhaul of the previous preliminary series [2],
> > with the major changes outlined below, and additional minor updates in
> > response to review feedback (see the individual patches for those).
> >
> > In the interest of getting this series out for review,
> > This series is **completely untested**.
> =

> Richard is currently working on VHE support for QEMU and we already have
> SVE system emulation support as of 3.1 so hopefully QEMU will be able to
> test this soon (and probably shake out a few of our own bugs ;-).

Awesome :)

Of course, there are no bugs on the kernel side... but if you find any
bugs that aren't there I'd like to know!

> > Reviewers should focus on the proposed API (but any other comments are
> > of course welcome!)
> <snip>
> =

> I've finished my pass for this revision. Sorry it took so long to get to
> it.

Much appreciated, thanks!

(I missed this mail when myself when going over responses.)

Cheers
---Dave
