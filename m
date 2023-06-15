Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C44EAC5
	for <kvmarm@lists.linux.dev>; Thu, 15 Jun 2023 17:26:17 +0000 (UTC)
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3409d944009so8225ab.1
        for <kvmarm@lists.linux.dev>; Thu, 15 Jun 2023 10:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686849976; x=1689441976;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cRdXnKf8UMK6tMvS0Fe+HRivY9zJhDo1MyqxnJgwxrw=;
        b=5dDLBI9MJ7+J3F+/51Jk1eM2fTbc71jazwc/vjucLDniC6v5D8G2m/r+D9PTqTg2Sx
         eg+Mda1zhKn1qCptaIExp9uboTwFeaGNh5b1+9ZlipMZWGhu8neyraXj2gk3cIfJILip
         mTdY1fqzoPFX7qrKZCDIoVRONKO+aBHWBBLnP0z8cT3QWE0yM/CkxnrBvEbmltkKmhiW
         ZOsEAgPxj4F2IYcB6AypIb12ZA0iDuwjTIuDt1Eavf/6zWdpVgh0C8KTCZue2TmIK8rr
         yG/Rr5sBVEWJ9gP81wH5Ulc0dlczEFzlfEu1G7foz9U6hAAjG1+NJCUFZ4ePs1yKFLAx
         jX1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686849976; x=1689441976;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cRdXnKf8UMK6tMvS0Fe+HRivY9zJhDo1MyqxnJgwxrw=;
        b=CWW2+gIYVk1iwht3pv4ZEGP3jX/QebiiSJBFw57puya8ILMJtn4WNNiW7NNrxowaAp
         jNumT5Jaq5FKDnfRAaOlFIXJbbe59UN0FZQOTeRE/ZYjOYT2QC7NTq8OuqMCBEEUrycG
         D5xEqcy4J9qdxyd3zM2qfhbFxO6RbRBXgpokVvstsxZi5FTUzvR7P6rAYXFKrVjqthDf
         E1v7in+RZbFHZdqDtjEymO1/3Rh92Pyq4dYdS7TkHonLHCQoP15UrS6p/3VPO2Lhvisv
         yBBtJhRLpfcwkn4XpqwPVzCwUz+Ys4mxDyQ3Z1V7eTktUpQytUl8nBgsHQwA3gaTqYDv
         SFJA==
X-Gm-Message-State: AC+VfDyS/ykzAWBWdig/T1nRxtZNQCOfg5uRCQ6yhgy/eDXPgtIebgW5
	mtJwUX/sVQTuU+ruisq55T9w28LeoZ4+0yI1Z4EvMg==
X-Google-Smtp-Source: ACHHUZ7i+zVDOKsralxa6sy+kgOs0tNjf0DvhW9vYedUAncnrn7M3olVN0eC2JjpQTd12kzS61i4W579j0NcVfgOLfQ=
X-Received: by 2002:a92:ca4f:0:b0:337:c28c:3d0f with SMTP id
 q15-20020a92ca4f000000b00337c28c3d0fmr110575ilo.6.1686849976378; Thu, 15 Jun
 2023 10:26:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230606192858.3600174-1-rananta@google.com> <ZImwRAuSXcVt3UPV@linux.dev>
 <CAJHc60wUSNpFLeESWcpEa5OmN4bJg9wBre-2k8803WHpn03LGw@mail.gmail.com>
 <ZIrONR6cSegiK1e2@linux.dev> <ZIscwv1NABW+wZ4J@google.com>
In-Reply-To: <ZIscwv1NABW+wZ4J@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 15 Jun 2023 10:26:05 -0700
Message-ID: <CAJHc60y523wJ0gZBm0o6vkYXdyus3QQC3t5W44LPDE+rN6CLzA@mail.gmail.com>
Subject: Re: [PATCH v5 0/7] KVM: arm64: Add support for FEAT_TLBIRANGE
To: Sean Christopherson <seanjc@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
	Colton Lewis <coltonlewis@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Allright, I'll resend the series along with David's patches.

Thank you.
Raghavendra

On Thu, Jun 15, 2023 at 7:14=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Jun 15, 2023, Oliver Upton wrote:
> > +cc Sean
> >
> > On Wed, Jun 14, 2023 at 06:57:01PM -0700, Raghavendra Rao Ananta wrote:
> > > On Wed, Jun 14, 2023 at 5:19=E2=80=AFAM Oliver Upton <oliver.upton@li=
nux.dev> wrote:
> > > >
> > > > Hi Raghavendra,
> > > >
> > > > On Tue, Jun 06, 2023 at 07:28:51PM +0000, Raghavendra Rao Ananta wr=
ote:
> > > > > The series is based off of upstream v6.4-rc2, and applied David
> > > > > Matlack's common API for TLB invalidations[1] on top.
> > > >
> > > > Sorry I didn't spot the dependency earlier, but this isn't helpful =
TBH.
> > > >
> > > > David's series was partially applied, and what remains no longer cl=
eanly
> > > > applies to the base you suggest. Independent of that, my *strong*
> > > > preference is that you just send out a series containing your patch=
es as
> > > > well as David's. Coordinating dependent efforts is the only sane th=
ing
> > > > to do. Also, those patches are 5 months old at this point which is
> > > > ancient history.
> > > >
> > > Would you rather prefer I detach this series from David's as I'm not
> > > sure what his plans are for future versions?
> > > On the other hand, the patches seem simple enough to rebase and give
> > > another shot at review, but may end up delaying this series.
> > > WDYT?
> >
> > In cases such as this you'd typically coordinate with the other
> > developer to pick up their changes as part of your series. Especially
> > for this case -- David's refactoring is _pointless_ without another
> > user for that code (i.e. arm64). As fun as it might be to antagonize
> > Sean, that series pokes x86 and I'd like an ack from on it.
> >
> > So, please post a combined series that applies cleanly to an early 6.4
> > rc of your choosing, and cc all affected reviewers/maintainers.
>
> +1
