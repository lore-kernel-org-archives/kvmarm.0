Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAB03403E3
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 12:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783598963; cv=none; b=DEm+cAv2vsX5mTIOqSnPaoiSeOEaaYslCFX8lHLaEFxA53EDQC15aoBoEA6ZNc+YprUsKSJcIX1j6LkxFIZVG1MPiJiJzqIf5lvobmN33rwpDaAgVkuhPL3u1FkcQ5KlTKbvl9qhYIeu1+JbA6mMuPbi2bQ2eq9UZJZpyHzMZjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783598963; c=relaxed/simple;
	bh=3a9pgwxWrLLuvuTwQFg/tCaqfqW0jQ0Y87hVWHCHY+A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dZ0wvrgVyipsWp8al0bTfLYFMLFv8p1FOyHFdtsIpugf8JbTLZqvkFHsWfp16nVS2WM86FQkjF8m13/n+PNrG+aCUsDKt2w8IXeUeMpIzLPOPuZ+Fib2KJ/8op78xMZrpwb3mkNol18rUd0CrWgVbvHJXEPFgNGVFBwHhp/f2J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Jcqzet28; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Jcqzet28"
X-Forwarded-Encrypted: i=1; AHgh+RpsJI9lL5jtLjxaIwUBqO7oshV+/Kp43fS0WoLw0QcarlSSEQb/YYRo/3TYqMmldxjb9LwZgvs=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783598960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BmsvLtE51JsvqUb4kaVyH7ncNDCmu7y58Wka6Jpy3e4=;
	b=Jcqzet28XfpFYOkvH7raURLnkqShUvuaBmSYDlF+oN1Sm7kHsTSftVL8PUvULpQuXqx2G7
	I8cMVyfwuvudppTkluhrti+XAwdZFel8SeSfNkEmrKzOn0H9USBcpe1JA5cTXd41UUQ/NY
	i3nkTa5jJfRiOEHFOwUs4j9viODw/pc=
X-Gm-Message-State: AOJu0YxmQTtG0mHa/BkW0ueqGLiakKLyJNjxQKZsyQpJ53Cmu78m1Z8E
	QR1FN/Lkm7LJLtlb5Uq97hshlwVcPzWDitbHnnYHmL3vqGunBBj2QrduVR0VefhJanmbgcluW2A
	5ZT/4a5kr2kh8vRYD57BAjoO8YvIfx6NAepTDpCS5
X-Received: by 2002:a05:622a:1f0d:b0:51c:d16:b48e with SMTP id
 d75a77b69052e-51c9a8c1f20mr7564121cf.22.1783598945046; Thu, 09 Jul 2026
 05:09:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org>
 <CA+EHjTyAxBx4jhGq-Gme5hPi1ZyDAkL2CP_U22ykkQemD1dUhg@mail.gmail.com>
 <ak-Fyvzpj9SkF75j@J2N7QTR9R3> <CA+EHjTydGzbgi9FwWQaFjuRNqUFC_HeOfHggZAHhPL4FfLYBog@mail.gmail.com>
 <ak-Kzyv0eXq05QQA@J2N7QTR9R3>
In-Reply-To: <ak-Kzyv0eXq05QQA@J2N7QTR9R3>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 9 Jul 2026 13:08:28 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxzKJ=UxdvPmboNSo6KBppDtr88z3_BdqghJ-6f_ttqMA@mail.gmail.com>
X-Gm-Features: AUfX_myJfL1pQLx--A1TjYYVTKJyGE6cEnwXXwo5heMGbxsjfkRXSVoLh7fWFO8
Message-ID: <CA+EHjTxzKJ=UxdvPmboNSo6KBppDtr88z3_BdqghJ-6f_ttqMA@mail.gmail.com>
Subject: Re: [PATCH v11 00/29] KVM: arm64: Implement support for SME
To: Mark Rutland <mark.rutland@arm.com>
Cc: Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Ben Horgan <ben.horgan@arm.com>, Jean-Philippe Brucker <jpb@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>, 
	Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

Hi Mark and Mark,

On Thu, 9 Jul 2026 at 12:49, Mark Rutland <mark.rutland@arm.com> wrote:
>
> On Thu, Jul 09, 2026 at 12:31:45PM +0100, Fuad Tabba wrote:
> > On Thu, 9 Jul 2026 at 12:28, Mark Rutland <mark.rutland@arm.com> wrote:
> > >
> > > On Thu, Jul 09, 2026 at 11:26:41AM +0100, Fuad Tabba wrote:
> > > > > base-commit: 4c45e14df2f4e77982ad70d6d8e3fe750edd4c37
> > > >
> > > > I think this SHA is local to your tree. I can't locate it, and neit=
her
> > > > could Sashiko [1, 2].
> > >
> > > That's the tagged commit for v7.2.-rc2. See:
> > >
> > >   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3D4c45e14df2f4e77982ad70d6d8e3fe750edd4c37
> > >
> > > I think that neither you nor sashiko have fetched mainline recently.
> >
> > Thanks, I have 7.2-rc2, but `git show
> > 4c45e14df2f4e77982ad70d6d8e3fe750edd4c37` gives me `fatal: bad object
> > 4c45e14df2f4e77982ad70d6d8e3fe750edd4c37` . The SHA for rc2 is
> > 8cdeaa50eae8dad34885515f62559ee83e7e8dda (which is what shows in the
> > link above, not sure what ID is, which is the part that matches your
> > SHA.
>
> Sorry, 4c45e14df2f4e77982ad70d6d8e3fe750edd4c37 is the tag object for
> v7.2-rc2, which points to commit object
> 8cdeaa50eae8dad34885515f62559ee83e7e8dda.
>
> The odd thing is that we see different behaviour; for me (with git
> 2.30.2) running:
>
>         git show 4c45e14df2f4e77982ad70d6d8e3fe750edd4c37
>
> ... gives me the description of the tag as per the example in the
> context below.
>
> I'm surprised that git show doesn't find that for you.
>
> > That's what confused both Sashiko and I, since it's used as the base-co=
mmit SHA.
>
> Sure; I'm just surprised as above that git show doesn't find the tag
> object.

Two different issues that manifested in the same way:
- Sashiko wasn't advancing HEAD after fetch (
https://github.com/sashiko-dev/sashiko/pull/317 )
- Neither Sashiko nor I were fetching tags

Thanks for this, and sorry for the noise.

Cheers,
/fuad

>
> Mark.
>
> >
> > Cheers,
> > /fuad
> >
> > >
> > > I have it locally after fetching from Linus's tree, as below.
> > >
> > > Mark.
> > >
> > > | [mark@lakrids:~/src/linux]% git describe 4c45e14df2f4e77982ad70d6d8=
e3fe750edd4c37
> > > | v7.2-rc2
> > > | [mark@lakrids:~/src/linux]% git show 4c45e14df2f4e77982ad70d6d8e3fe=
750edd4c37
> > > | tag v7.2-rc2
> > > | Tagger:     Linus Torvalds <torvalds@linux-foundation.org>
> > > | TaggerDate: Sun Jul 5 14:44:06 2026 -1000
> > > |
> > > | Linux 7.2-rc2
> > > | -----BEGIN PGP SIGNATURE-----
> > > |
> > > | iQFSBAABCgA8FiEEq68RxlopcLEwq+PEeb4+QwBBGIYFAmpK+lYeHHRvcnZhbGRz
> > > | QGxpbnV4LWZvdW5kYXRpb24ub3JnAAoJEHm+PkMAQRiGsv8H/Rn7Hr3Hp8t6au8B
> > > | xQueZThJWjqQ4v8pyLnXF6OomKiDR24OTXMCrFgDkcmZ7RK2ALqowI3tQVwLUTuI
> > > | yUN0qL2z2y+LyTcO0CYf3Lple8KlgLAXYMsv7pGLsOvhS7BW2jW97/bcbpUNxoHb
> > > | eghxqbIEnyRImUbbyg+nW7VVk65RKdPUNkBPXfQ2NMVwe+SDE5Rl+NXNVqDNjGad
> > > | soDTUBrD9yXkWX+4s0myleE62UzzH5nYgGPQeQgYmzWgq7LybH6WBlbQK9D7ODJR
> > > | Cw3LCq1hwZZ2w04Yx+XwMHquGJYHW8L2pj77h95uhzksz8buKnM0AGwBCTC6RMoi
> > > | AyUQvdc=3D
> > > | =3DJUWl
> > > | -----END PGP SIGNATURE-----
> > > |
> > > | commit 8cdeaa50eae8dad34885515f62559ee83e7e8dda (HEAD, tag: v7.2-rc=
2, kernel-org-tip/locking/debug, kernel-org-stable/master, kernel-org-rw-pm=
/master, kernel-org-rw-pm/fixes, kernel-org-powerpc/topic/ppc-kvm, kernel-o=
rg-powerpc/next-test, kernel-org-powerpc/next, kernel-org-powerpc/fixes-tes=
t, kernel-org-powerpc/fixes, google-android-kvm/master)
> > > | Author:     Linus Torvalds <torvalds@linux-foundation.org>
> > > | AuthorDate: Sun Jul 5 14:44:06 2026 -1000
> > > | Commit:     Linus Torvalds <torvalds@linux-foundation.org>
> > > | CommitDate: Sun Jul 5 14:44:06 2026 -1000
> > > |
> > > |     Linux 7.2-rc2
> > > |
> > > | diff --git a/Makefile b/Makefile
> > > | index b9c5792c79e01..b4035d3cef266 100644
> > > | --- a/Makefile
> > > | +++ b/Makefile
> > > | @@ -2,7 +2,7 @@
> > > |  VERSION =3D 7
> > > |  PATCHLEVEL =3D 2
> > > |  SUBLEVEL =3D 0
> > > | -EXTRAVERSION =3D -rc1
> > > | +EXTRAVERSION =3D -rc2
> > > |  NAME =3D Baby Opossum Posse
> > > |
> > > |  # *DOCUMENTATION*
> > >
