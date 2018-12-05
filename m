From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH v2 23/23] KVM: arm64/sve: Document KVM API extensions
 for SVE
Date: Wed, 5 Dec 2018 17:59:57 +0000
Message-ID: <20181205175955.GT3505@e103592.cambridge.arm.com>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
 <1538141967-15375-24-git-send-email-Dave.Martin@arm.com>
 <877eh5i0wo.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 961A44A2E4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Dec 2018 13:00:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qYjajoV1cbxg for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Dec 2018 13:00:02 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81E354A1DE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Dec 2018 13:00:02 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <877eh5i0wo.fsf@linaro.org>
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

On Thu, Nov 22, 2018 at 03:31:51PM +0000, Alex Benn=E9e wrote:
> =

> Dave Martin <Dave.Martin@arm.com> writes:
> =

> > This patch adds sections to the KVM API documentation describing
> > the extensions for supporting the Scalable Vector Extension (SVE)
> > in guests.
> >
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---
> >  Documentation/virtual/kvm/api.txt | 142 ++++++++++++++++++++++++++++++=
+++++++-
> >  1 file changed, 139 insertions(+), 3 deletions(-)
> >
> > diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/=
kvm/api.txt
> > index a58067b..b8257d4 100644
> > --- a/Documentation/virtual/kvm/api.txt
> > +++ b/Documentation/virtual/kvm/api.txt
> > @@ -2054,13 +2054,21 @@ Specifically:
> >    0x6030 0000 0010 004c SPSR_UND    64  spsr[KVM_SPSR_UND]
> >    0x6030 0000 0010 004e SPSR_IRQ    64  spsr[KVM_SPSR_IRQ]
> >    0x6060 0000 0010 0050 SPSR_FIQ    64  spsr[KVM_SPSR_FIQ]
> > -  0x6040 0000 0010 0054 V0         128  fp_regs.vregs[0]
> > -  0x6040 0000 0010 0058 V1         128  fp_regs.vregs[1]
> > +  0x6040 0000 0010 0054 V0         128  fp_regs.vregs[0]    (*)
> > +  0x6040 0000 0010 0058 V1         128  fp_regs.vregs[1]    (*)
> >      ...
> > -  0x6040 0000 0010 00d0 V31        128  fp_regs.vregs[31]
> > +  0x6040 0000 0010 00d0 V31        128  fp_regs.vregs[31]   (*)
> >    0x6020 0000 0010 00d4 FPSR        32  fp_regs.fpsr
> >    0x6020 0000 0010 00d5 FPCR        32  fp_regs.fpcr
> >
> > +(*) These encodings are not accepted for SVE-enabled vcpus.  See
> > +    KVM_ARM_SVE_CONFIG for details of how SVE support is configured for
> > +    a vcpu.
> > +
> > +    The equivalent register content can be accessed via bits [2047:0]
> > of
> =

> You mean [127:0] I think.

Good spot.  Yes.

Possibly I meant "through the first slice of the corresponding Zn",
though [127:0] should make it clear both which slice and which bits
within the slice to look at.

[...]

Cheers
---Dave
