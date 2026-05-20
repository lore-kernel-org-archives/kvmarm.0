Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8282F349AFF;
	Wed, 20 May 2026 17:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299250; cv=none; b=tgRmMn0FBWBvoYvqsahmp5G87StIP44JP/7qVzLSVIKksjBt3d5ELF155Sof+A35m3dc+1HbNYqyuW4nKvj9ueps/DltMs04wwru5GiYapiLkfV7LCRtk8Uzb2A4qtMSUrps0WsnI25K7Z8+y963necESgRzcQCw0OL099DweRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299250; c=relaxed/simple;
	bh=azrcSc5fBS9EAkI43k4N+bdBeogc36tuyCa1/SG/oas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uIDZrbMD5tzdTo/hXSEaEa8gvA1aRnBGY1iBBaeZnI1SBNP6FMsKiH73kWfZlA0E6AShtK7V0tjESA8EIiUE7WQ3yw3QOvPLVcX+fSP/+uyXO6HIFT+jBbpLfkqYcV061byCxKoNDmsfEn8R5kBy9NFvMqaaQ/nJb/94pjgy1iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E+KqHORQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E+KqHORQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8F31F000E9;
	Wed, 20 May 2026 17:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779299249;
	bh=ViRW9Nz3r6hXUk4I8QEt3nB7VpqxM71bV390oMtx5Ug=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E+KqHORQPEi2v/ovg1wnEqFr8oDWY997yhhY4R1PG1PuSPUJYkhb8VagSOppZB+Rr
	 A0FKrrZGSqhwUfPDPtXnkAmbqErhn1IZufP64ETA4qqpXvH0pe86apDIE60MBNjwEw
	 RUfd9pOaiDymD8/T/FWXj7CZcBRvZOPScWM1lK0JYwdnAeWm7tQE1Tsmsl9tTiCRFI
	 3siFught71zBG4B2SLyJfjVwSEg4UUGfukHiuNBzw5P/8kKwSKZ4x2cHIxbPEaZHgh
	 C1XP0RZ0Sepvw0ts72eLscxXwx0QJPfuGnmsqMkMRKBDOTHd1f1hMZbWHQJHylmkgs
	 J70Laujzm+ZXA==
Date: Wed, 20 May 2026 10:47:27 -0700
From: Oliver Upton <oupton@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, kvm <kvm@vger.kernel.org>,
	Linux Doc Mailing List <linux-doc@vger.kernel.org>,
	"Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Jim Mattson <jmattson@google.com>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Eric Auger <eric.auger@redhat.com>, Kees Cook <kees@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	kvmarm@lists.linux.dev,
	linux-kselftest <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH] Documentation: KVM: Document guest-visible compatibility
 expectations
Message-ID: <ag3zr7-11FO3k-Wv@kernel.org>
References: <cf429f2082e863571595f74d1d3dedc3e6a82964.camel@infradead.org>
 <CABgObfacAYexR25SMi1kSZMRnHx3EDGj8=E84V1DumER66ibnQ@mail.gmail.com>
 <86qzn7wp3y.wl-maz@kernel.org>
 <593a782c50f3c8656e13b36dfb975a67d43a908e.camel@infradead.org>
 <CABgObfbS-z3OphDna5W_JQPvw+OK=yXJurVMHp1ANZ5uGEgVhQ@mail.gmail.com>
 <9d0429ddbe4d8c6993e74237c4395697f80092d6.camel@infradead.org>
 <agzR2kaJsNa8X9lF@kernel.org>
 <1243d375846c4f4e20c229a6f09300126188fc8b.camel@infradead.org>
 <agzq5kwzuJvd7Mh5@kernel.org>
 <add71b6f61edc6357e1fddad83273b2cba697d10.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <add71b6f61edc6357e1fddad83273b2cba697d10.camel@infradead.org>

On Wed, May 20, 2026 at 12:33:52AM +0100, David Woodhouse wrote:
> On Tue, 2026-05-19 at 15:57 -0700, Oliver Upton wrote:
> > What ifs and maybes do not meet the bar, in my opinion, for preserving
> > bug emulation in KVM. Of course there could be a little flexibility with
> > that but we need to have some way of discriminating between bug fixes
> > and genuine guest expectations around the behavior of virtual hardware.
> 
> I believe you have this completely backwards.

No, I really don't.

Leaving every bugfix that could _possibly_ have a guest-visible impact
subject to drive-by scrutiny many years after the dust has settled is
not an acceptable working dynamic. Especially since it would appear
that the rest of the ecosystem has long since moved on from this
particular issue.

If this matters to you so deeply then please, be part of the solution
instead. You may find that reviewing patches leads to better outcomes
than getting belligerent with the arm64 folks every time you guys
decide to rebase your kernel. Hell, hypotheticals actually have a lot
more weight in the context of a review. And if your testing is extensive
enough to catch these sort of subtleties, don't you think it's better
done against mainline?

Maybe it's just me but I am left feeling disappointed that we all
haven't found a productive way of working together. I've tried to bridge
the gap here; we obviously need to do something that at least fixes the
UAPI breakage. Although apparently we don't even care to meet that low
of bar.

> A stable and mature platform doesn't get to play in its ivory tower and
> randomly inflict breakage on guests because they "deserve it".

Really? Aren't you asking for us to emulate something completely broken
for you?

Thanks,
Oliver
