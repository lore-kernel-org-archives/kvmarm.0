Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDCD426ECF;
	Mon, 24 Aug 2026 13:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787578211; cv=none; b=IlkUOw9ptk62e1dKNQuh44BeeyFeG9bVkVjC2qIrP4k09clbHQq97aIeuWYWg/5J5DjB4FU6xhmtah4rQw22NcaPlV750+p7jCAebgoJAopjusgfLkeqKBkD7vG4lHU59MdaW8/SYIzpkoQG/Vw+8zOFYeH0VuvYhrzpOdUfSbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787578211; c=relaxed/simple;
	bh=bePwG7qrj+6EUsfa2B1lnsBXP/jX9QZcgLPZbVAgzsA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BqrSS0YAOgPvmRNVU8n7HDiBD9IHpc8vh3sYZVt217oN1LuWhK+5GB5ke810G2SB6WFqloHfQmHIoZvQknY7hkRQjSRFdCcH1Kl6KUcBEW9BfGKXMK/o/5XG3cnsRjnHL9VacsBOM3Ptm0hOeW2BDEsNAyYOr55ig/V1em0/jZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gdcKIYQL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gdcKIYQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987D81F000E9;
	Mon, 24 Aug 2026 13:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787578209;
	bh=iDn1o2DLL+y0sd22jeA5t6tGJEqFYhPXPnftrfb3MMM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gdcKIYQLI5HeVyXSM2OirRq2RIF0UF0dCL/O3mP/vsUNEeHf8rogh7W5b5tsJmPe6
	 NVqMzKfWLFtxBjl5Tj+xuyECb4p8kzVDDFyXvNA47tYycOpvzlvir47tSmEQRZZ0+0
	 /FzuZ7AzJYpJs0F+xIVB4lNdCpZMF1YfpEln3kfMHZnhloiTZG28ValSOYheFKVbVj
	 jExroxeuXDXK42Ma+1vtxiyqTqJ964htlRa/CmUUdAnmXCd2fdS/oR9epj83dKmMss
	 GKzBKqLpw2Sd2dmQBeW4krCm8NmWEXJ53YQwH00S3k/0+ksUTXdxgrpx/dM1LiLojN
	 FrZ8KiFolO3aA==
Date: Mon, 24 Aug 2026 14:30:02 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Wei-Lin Chang <weilin.chang@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
	Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Dev Jain <dev.jain@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Matt Fleming <matt@codeblueprint.co.uk>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ene <sebastianene@google.com>
Subject: Re: [PATCH v3 0/2] arm64: ptdump flush fixes
Message-ID: <aoxHWvUwgzqzg_cQ@willie-the-truck>
References: <20260814222458.584906-1-weilin.chang@arm.com>
 <87h5klno04.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h5klno04.wl-maz@kernel.org>

On Sun, Aug 23, 2026 at 11:13:15AM +0100, Marc Zyngier wrote:
> On Fri, 14 Aug 2026 23:24:56 +0100,
> Wei-Lin Chang <weilin.chang@arm.com> wrote:
> > 
> > Hi,
> > 
> > This series fixes two problems around ptdumps:
> > 
> > 1. note_page_flush(), which flushes out the last row of ptdumps, does
> >    not account for address spaces that have IA < 64. Other than making
> >    the last region extremely huge, the attributes of the last region
> >    within the address spaces appear to extend all the way to 1 << 64.
> > 
> > 2. KVM/arm64's stage-2 ptdump missed calling note_page_flush().
> > 
> > To address Will's comment [1], I have created an end_address field for
> > struct ptdump_pg_state, and initialized it with the end address of the
> > ptdumps. It follows the same convention as the last range->end:
> > exclusive end, except for the case where the address space ends at
> > 1 << 64. In that case it is set as ULONG_MAX.
> > 
> > Caching the end address avoids duplicating the range iteration in
> > note_page_flush(), at the cost of duplicating state in ptdump_pg_state.
> > 
> > Series is based on v7.2-rc5.
> 
> Reviewed-by: Marc Zyngier <maz@kernel.org>
> 
> Will, if you're OK with patch #1, do you want the whole thing to go
> via the arm64 or the kvmarm tree?

I can pick 'em both up, as I already have some other fixes on my radar
for -rc1.

Cheers,

Will
