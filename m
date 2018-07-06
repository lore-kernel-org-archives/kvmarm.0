From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH 00/16] KVM: arm64: Initial support for SVE guests
Date: Fri, 6 Jul 2018 10:05:36 +0100
Message-ID: <20180706090534.GD26019@e103592.cambridge.arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <87h8lc93jc.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B63D449F8C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jul 2018 04:53:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ijn7e0-ZjoP2 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Jul 2018 04:53:08 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86AAE408B1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jul 2018 04:53:08 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <87h8lc93jc.fsf@linaro.org>
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

On Fri, Jul 06, 2018 at 09:22:47AM +0100, Alex Benn=E9e wrote:
> =

> Dave Martin <Dave.Martin@arm.com> writes:
> =

> <snip>
> >
> > This series is somewhat tested on Arm Juno r0 and the Arm Fast Model
> > (with/without SVE support).  arch/arm builds, but I've not booted
> > it -- only some trivial refactoring in this series affects arch/arm.
> =

> Now that QEMU linux-user SVE support is pretty much complete we've also
> got preliminary patches for system emulation mode. However we currently
> don't have VHE implemented so I guess we need to do that first before we
> can test under QEMU.

Qemu can use this as a KVM client without invasive changes, right?

For kvmtool, it's just a question of checking/setting a feature flag
in KVM_ARM_PREFERRED_TARGET and KVM_ARM_VCPU_INIT, and (eventually)
doing at ioctl() to set the set of permitted vector lengths (not yet,
this will come in a follow-up series).

Cheers
---Dave
