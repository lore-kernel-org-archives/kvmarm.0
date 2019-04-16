Return-Path: <SRS0=JhHZ=SS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84BE1C10F13
	for <kvmarm@archiver.kernel.org>; Tue, 16 Apr 2019 12:42:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0C02A205ED
	for <kvmarm@archiver.kernel.org>; Tue, 16 Apr 2019 12:42:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C02A205ED
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F47C4A4FF;
	Tue, 16 Apr 2019 08:42:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZpwyQ6VvA6xa; Tue, 16 Apr 2019 08:42:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EAFF14A511;
	Tue, 16 Apr 2019 08:42:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 033424A506
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Apr 2019 08:42:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fw0QoAXF6mH6 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Apr 2019 08:42:48 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F9E04A4FF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Apr 2019 08:42:48 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 030E6EBD;
 Tue, 16 Apr 2019 05:42:48 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1184E3F706;
 Tue, 16 Apr 2019 05:42:45 -0700 (PDT)
Date: Tue, 16 Apr 2019 13:42:43 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 13/14] KVM: Clarify KVM_{SET,GET}_ONE_REG error code
 documentation
Message-ID: <20190416124243.GP3567@e103592.cambridge.arm.com>
References: <1555086498-26691-1-git-send-email-Dave.Martin@arm.com>
 <1555086498-26691-14-git-send-email-Dave.Martin@arm.com>
 <20190415152132.avwkmmuwolh7juhy@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190415152132.avwkmmuwolh7juhy@kamzik.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>,
 Christoffer Dall <cdall@kernel.org>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190416124243.tqQjQscirFHA5hGfAOce2OZ3jgtTrhQ1ovGh-VlHzwk@z>

On Mon, Apr 15, 2019 at 05:21:32PM +0200, Andrew Jones wrote:
> On Fri, Apr 12, 2019 at 05:28:17PM +0100, Dave Martin wrote:
> > The current error code documentation for KVM_GET_ONE_REG and
> > KVM_SET_ONE_REG could be read as implying that all architectures
> > implement these error codes, or that KVM guararntees which error
> =

> guarantees
> =

> > code is returned in a particular situation.
> > =

> > Because this is not really the case, this patch waters down the
> > documentation explicitly to remove such guarantees.
> > =

> > EPERM is marked as arm64-specific, since for now arm64 really is
> > the only architecture that yields this error code for the
> > finalization-required case.  Keeping this as a distinct error code
> > is useful however for debugging due to the statefulness of the API
> > in this instance.
> > =

> > No functional change.
> > =

> > Suggested-by: Andrew Jones <drjones@redhat.com>
> > Fixes: 395f562f2b4c ("KVM: Document errors for KVM_GET_ONE_REG and KVM_=
SET_ONE_REG")
> > Fixes: 50036ad06b7f ("KVM: arm64/sve: Document KVM API extensions for S=
VE")
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---
> >  Documentation/virtual/kvm/api.txt | 14 +++++++++-----
> >  1 file changed, 9 insertions(+), 5 deletions(-)
> > =

> > diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/=
kvm/api.txt
> > index b115b23..74c51c7 100644
> > --- a/Documentation/virtual/kvm/api.txt
> > +++ b/Documentation/virtual/kvm/api.txt
> > @@ -1873,8 +1873,10 @@ Parameters: struct kvm_one_reg (in)
> >  Returns: 0 on success, negative value on failure
> >  Errors:
> >   =A0ENOENT: =A0=A0no such register
> > - =A0EPERM: =A0=A0=A0register access forbidden for architecture-depende=
nt reasons
> > - =A0EINVAL: =A0=A0other errors, such as bad size encoding for a known =
register
> > + =A0EINVAL: =A0=A0invalid register ID, or no such register
> > + =A0EPERM: =A0=A0=A0(arm64) register access not allowed before vcpu fi=
nalization
> > +(These error codes are indicative only: do not rely on a specific error
> > +code being returned in a specific situation.)
> >  =

> >  struct kvm_one_reg {
> >         __u64 id;
> > @@ -2258,10 +2260,12 @@ Architectures: all
> >  Type: vcpu ioctl
> >  Parameters: struct kvm_one_reg (in and out)
> >  Returns: 0 on success, negative value on failure
> > -Errors:
> > +Errors include:
> >   =A0ENOENT: =A0=A0no such register
> > - =A0EPERM: =A0=A0=A0register access forbidden for architecture-depende=
nt reasons
> > - =A0EINVAL: =A0=A0other errors, such as bad size encoding for a known =
register
> > + =A0EINVAL: =A0=A0invalid register ID, or no such register
> > + =A0EPERM: =A0=A0=A0(arm64) register access not allowed before vcpu fi=
nalization
> > +(These error codes are indicative only: do not rely on a specific error
> > +code being returned in a specific situation.)
> >  =

> >  This ioctl allows to receive the value of a single register implemented
> >  in a vcpu. The register to read is indicated by the "id" field of the
> > -- =

> > 2.1.4
> >
> =

> Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
