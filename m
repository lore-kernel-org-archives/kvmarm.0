Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 699933F7AB4
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 11:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783596498; cv=none; b=jAkFYoRzYv87JUov5fCR9AJ9nbygn6YiEyRBd051rpA4w65kpVnJwBG320r5lUTxVdx8RKnjyVLIDUYxyxmrjRtK2iBUTk9I0UVZaLXRKqjH3MUoeYmzPuMCLO3hRt1l3uR14x8Wrab20MLsaf/eE030USJGFqaNPKV3S/j4vcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783596498; c=relaxed/simple;
	bh=b/16+LT0bK1iiXr4YXvyPrteGt8wl8xtRhIWB1SvV3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OK8t0L1BJ8W+qbw0q2zKjgkHecut495aCoJEA1HAvCOtZOK3FMYplZTJmYkPpQKCHJ/J+xChkrqFNKuhKq1AHeu4XW0k7z9g+da7/osjJcztCyzjq6s/wteEubRqv0OdEUArH4bLcyMqleoH5bwD60uUEX8YT4d19+AAEiBU+ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ves2DdBn; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ves2DdBn"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8F6D53570;
	Thu,  9 Jul 2026 04:28:12 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 135AE3FE53;
	Thu,  9 Jul 2026 04:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783596496; bh=b/16+LT0bK1iiXr4YXvyPrteGt8wl8xtRhIWB1SvV3o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ves2DdBn3M1Qj1o5f6NScbNz8DpkQqjsWCTasnt5qBWiFq/BeUS4FpX0s78D/zCnF
	 y/Rr9GpLv9cHdqhee4mpqDInSiNeo5JndsKim8JurUGQUBztk9xoXyiK0mB/lKz0Rg
	 yPa7JR34lyXodNdyhHTh8ONsbOtJrrbfzUsb8l9M=
Date: Thu, 9 Jul 2026 12:28:10 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v11 00/29] KVM: arm64: Implement support for SME
Message-ID: <ak-Fyvzpj9SkF75j@J2N7QTR9R3>
References: <20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org>
 <CA+EHjTyAxBx4jhGq-Gme5hPi1ZyDAkL2CP_U22ykkQemD1dUhg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTyAxBx4jhGq-Gme5hPi1ZyDAkL2CP_U22ykkQemD1dUhg@mail.gmail.com>

On Thu, Jul 09, 2026 at 11:26:41AM +0100, Fuad Tabba wrote:
> > base-commit: 4c45e14df2f4e77982ad70d6d8e3fe750edd4c37
> 
> I think this SHA is local to your tree. I can't locate it, and neither
> could Sashiko [1, 2]. 

That's the tagged commit for v7.2.-rc2. See:

  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4c45e14df2f4e77982ad70d6d8e3fe750edd4c37

I think that neither you nor sashiko have fetched mainline recently.

I have it locally after fetching from Linus's tree, as below.

Mark.

| [mark@lakrids:~/src/linux]% git describe 4c45e14df2f4e77982ad70d6d8e3fe750edd4c37
| v7.2-rc2
| [mark@lakrids:~/src/linux]% git show 4c45e14df2f4e77982ad70d6d8e3fe750edd4c37    
| tag v7.2-rc2
| Tagger:     Linus Torvalds <torvalds@linux-foundation.org>
| TaggerDate: Sun Jul 5 14:44:06 2026 -1000
| 
| Linux 7.2-rc2
| -----BEGIN PGP SIGNATURE-----
| 
| iQFSBAABCgA8FiEEq68RxlopcLEwq+PEeb4+QwBBGIYFAmpK+lYeHHRvcnZhbGRz
| QGxpbnV4LWZvdW5kYXRpb24ub3JnAAoJEHm+PkMAQRiGsv8H/Rn7Hr3Hp8t6au8B
| xQueZThJWjqQ4v8pyLnXF6OomKiDR24OTXMCrFgDkcmZ7RK2ALqowI3tQVwLUTuI
| yUN0qL2z2y+LyTcO0CYf3Lple8KlgLAXYMsv7pGLsOvhS7BW2jW97/bcbpUNxoHb
| eghxqbIEnyRImUbbyg+nW7VVk65RKdPUNkBPXfQ2NMVwe+SDE5Rl+NXNVqDNjGad
| soDTUBrD9yXkWX+4s0myleE62UzzH5nYgGPQeQgYmzWgq7LybH6WBlbQK9D7ODJR
| Cw3LCq1hwZZ2w04Yx+XwMHquGJYHW8L2pj77h95uhzksz8buKnM0AGwBCTC6RMoi
| AyUQvdc=
| =JUWl
| -----END PGP SIGNATURE-----
| 
| commit 8cdeaa50eae8dad34885515f62559ee83e7e8dda (HEAD, tag: v7.2-rc2, kernel-org-tip/locking/debug, kernel-org-stable/master, kernel-org-rw-pm/master, kernel-org-rw-pm/fixes, kernel-org-powerpc/topic/ppc-kvm, kernel-org-powerpc/next-test, kernel-org-powerpc/next, kernel-org-powerpc/fixes-test, kernel-org-powerpc/fixes, google-android-kvm/master)
| Author:     Linus Torvalds <torvalds@linux-foundation.org>
| AuthorDate: Sun Jul 5 14:44:06 2026 -1000
| Commit:     Linus Torvalds <torvalds@linux-foundation.org>
| CommitDate: Sun Jul 5 14:44:06 2026 -1000
| 
|     Linux 7.2-rc2
| 
| diff --git a/Makefile b/Makefile
| index b9c5792c79e01..b4035d3cef266 100644
| --- a/Makefile
| +++ b/Makefile
| @@ -2,7 +2,7 @@
|  VERSION = 7
|  PATCHLEVEL = 2
|  SUBLEVEL = 0
| -EXTRAVERSION = -rc1
| +EXTRAVERSION = -rc2
|  NAME = Baby Opossum Posse
|  
|  # *DOCUMENTATION*

