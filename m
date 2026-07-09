Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D8441A76A
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 11:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783597816; cv=none; b=pExNxTwFLXmURkL7oU/KeN6X8Winw2rMlLRBvn0elbVpCN2w5oIQWOzWWndry5fuXbpRYe5S9CUYHQ7PbGHY/AVHr+YjvvrhPWD6QnmodUdhXW6Fp1dskpd5xGKWubNHBeoyMSMiFgCEb7dB5KNrzQtNZGZEgLXDmS39vAKYdjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783597816; c=relaxed/simple;
	bh=ZWYDTPt2INsfrfjekJ9+Fr6OaUFIO4TQs4dluGhiECQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h7nN68kd7M/+nJVreJcybowM8zEHHoVyENSokEj4CMr6wGtxXIthcpM9FN8/5GawnaF53XsBrcznZTBrFXE9U3CYB8OOiZHgr2Wb9bDI6wKP1eDq59Y9aOLXGNWBhk05rXcbuwvUYg4xMn0eh/f6zAF+AS8mwRWImsxYDrr5P0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=INLRqR+i; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="INLRqR+i"
X-Forwarded-Encrypted: i=1; AHgh+Rqx3TeqOuqo52c+Nz1RcjMlTL4F+cKvZI8OQogU9b5Oi/vUtoQRPmmiWtrh/gnO6WuuZ694xQY=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783597812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L3SuTrK7ua1jSt5ecvosiLTOXicZe+1p9rD4HzyC/xI=;
	b=INLRqR+ieSjA/N84vwt70/AkodsDk59oUdDJXLo/ukPq3Nsz/FSJAmlxUbkz+PlD2GyMvN
	GXrTUJbU94wBXw077Tn2cgFBscdib9y+NqbypA045nGWKdHbT0rGDkyVhSVYJHreFYg/nX
	4yrtKVAQ2GYItIOOV7J5oxe7+rVZ0oY=
X-Gm-Message-State: AOJu0YyFQ2d4QjWH5mPfvUS5xpWl/h5dV5uhgJ7vNbYXgM7LAW07iLWS
	33/Qsope9if3O0NmF3msG5hHW4FpHRWuxCR7hEh3DLJzyM41t5gKXSDyMNJCtqicMB9WZK5dAxN
	bRuDxiw7TKN7q+EmYEUJfuKU033HDZJXP0FUe0FYq
X-Received: by 2002:ac8:7f0d:0:b0:51c:6b7:d3de with SMTP id
 d75a77b69052e-51c9c573e75mr5591691cf.5.1783597796410; Thu, 09 Jul 2026
 04:49:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org>
 <CA+EHjTyAxBx4jhGq-Gme5hPi1ZyDAkL2CP_U22ykkQemD1dUhg@mail.gmail.com> <4b2fb0ef-4d3e-4a1f-8d33-177bb4af2005@sirena.org.uk>
In-Reply-To: <4b2fb0ef-4d3e-4a1f-8d33-177bb4af2005@sirena.org.uk>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 9 Jul 2026 12:49:19 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyhRFMa+diHpWyKcCuB8DrTH4p1bvraiaQnO0Fru74cHw@mail.gmail.com>
X-Gm-Features: AUfX_myGvG9GzTq40K-onGYQvIqSeZZ7bcchUs-KHtoNqS1WCKCcF98we18uqCM
Message-ID: <CA+EHjTyhRFMa+diHpWyKcCuB8DrTH4p1bvraiaQnO0Fru74cHw@mail.gmail.com>
Subject: Re: [PATCH v11 00/29] KVM: arm64: Implement support for SME
To: Mark Brown <broonie@kernel.org>
Cc: Konstantin Ryabitsev <konstantin@linuxfoundation.org>, Marc Zyngier <maz@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	Jean-Philippe Brucker <jpb@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Peter Maydell <peter.maydell@linaro.org>, Eric Auger <eric.auger@redhat.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, tools@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Thu, 9 Jul 2026 at 12:36, Mark Brown <broonie@kernel.org> wrote:
>
> On Thu, Jul 09, 2026 at 11:26:41AM +0100, Fuad Tabba wrote:
> > > base-commit: 4c45e14df2f4e77982ad70d6d8e3fe750edd4c37
>
> > I think this SHA is local to your tree. I can't locate it, and neither
> > could Sashiko [1, 2]. For a series this big and complex, it would be
> > good to get Sashiko to review it. Could you please fix that?
>
> That is the v7.2-rc2 tag, copying in Konstantin since this probably
> wants fixing in b4 and Roman for sashiko since this might bite others.
> I told b4 the code was based on v7.2-rc2 (which it is) by specifiying it
> as "v7.2-rc2" in --edit-deps and it's translated that into the git
> object hash for the tag and dropped that in there rather than the hash
> of the commit that was signed.

I figured out what the issue is in Sashiko and submitted a fix:
https://github.com/sashiko-dev/sashiko/pull/317

It wasn't advancing the local HEAD after fetching.

Cheers,
/fuad

>
> Probably if b4 is going to resolve deps into hashes it should make sure
> to resolve them into a commit object in case users aren't pulling tags
> (which I'm guessing is what's affected both Sashiko and you here).
> Either that or just keep the text (which would make it more obvious
> what's happened but doesn't actually fix anything if it's automation
> that's impacted).
>
> Unless someone objects I'll resend with the dependency specified as the
> commit object for Sashiko's benefit :/
>
> FWIW:
>
> $ git show 4c45e14df2f4e77982ad70d6d8e3fe750edd4c37
> tag v7.2-rc2
> Tagger: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sun Jul 5 14:44:06 2026 -1000
>
> Linux 7.2-rc2
> -----BEGIN PGP SIGNATURE-----
>
> iQFSBAABCgA8FiEEq68RxlopcLEwq+PEeb4+QwBBGIYFAmpK+lYeHHRvcnZhbGRz
> QGxpbnV4LWZvdW5kYXRpb24ub3JnAAoJEHm+PkMAQRiGsv8H/Rn7Hr3Hp8t6au8B
> xQueZThJWjqQ4v8pyLnXF6OomKiDR24OTXMCrFgDkcmZ7RK2ALqowI3tQVwLUTuI
> yUN0qL2z2y+LyTcO0CYf3Lple8KlgLAXYMsv7pGLsOvhS7BW2jW97/bcbpUNxoHb
> eghxqbIEnyRImUbbyg+nW7VVk65RKdPUNkBPXfQ2NMVwe+SDE5Rl+NXNVqDNjGad
> soDTUBrD9yXkWX+4s0myleE62UzzH5nYgGPQeQgYmzWgq7LybH6WBlbQK9D7ODJR
> Cw3LCq1hwZZ2w04Yx+XwMHquGJYHW8L2pj77h95uhzksz8buKnM0AGwBCTC6RMoi
> AyUQvdc=
> =JUWl
> -----END PGP SIGNATURE-----
>
> commit 8cdeaa50eae8dad34885515f62559ee83e7e8dda
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sun Jul 5 14:44:06 2026 -1000
>
>     Linux 7.2-rc2
>
> diff --git a/Makefile b/Makefile
> index b9c5792c79e0..b4035d3cef26 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -2,7 +2,7 @@
>  VERSION = 7
>  PATCHLEVEL = 2
>  SUBLEVEL = 0
> -EXTRAVERSION = -rc1
> +EXTRAVERSION = -rc2
>  NAME = Baby Opossum Posse
>
>  # *DOCUMENTATION*
