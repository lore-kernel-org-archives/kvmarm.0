Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 960343FBEAF
	for <kvmarm@lists.linux.dev>; Fri, 17 Jul 2026 13:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784294538; cv=none; b=uz5Ywt5w0gbdkQF+WVPmWoAp+/1P+zyenIzFYAEDi4f6Wy0IB+3xwLlmLNlDSoSrzZux2h0mFxgFU4ddjubG6xbeEjsA0AIniXRYYaCUH5RHOnKBnkjK0D6tD6hXYNi3NqGPz704r3AVw1sEZZqYnRxMHYk6/HAP9rCwvj7TnjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784294538; c=relaxed/simple;
	bh=ZpoCI9ofx2p/ua+KhEMRhGi82OXdAYlebI0ztnF7GEI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oNtqnyyoMf5dd6iKx6KIuigUgnuGnxylTKmfSbrdaBbMD8MgSo5b/AHb4HbsHevGbSAVzNqUrjiCvxEFQ7uEkaZ64Le0jN81ltvXXWvoWihx7nY4chZmguDc0tJbjYIbjP0ZTtCxext5cy31dYIdg0yl9YugZ7dUIbCgBoM0mxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=K6AyEy3S; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="K6AyEy3S"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6F3231476;
	Fri, 17 Jul 2026 06:22:11 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 060EE3F7D8;
	Fri, 17 Jul 2026 06:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784294535; bh=ZpoCI9ofx2p/ua+KhEMRhGi82OXdAYlebI0ztnF7GEI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K6AyEy3StxJcwPLr/m61NkJzXizkRu07Wyuz+kg41HvvKbPRzZqm+z8Wm0ev8hoxp
	 OyjIi/WvIUkh3uwZOORa4hYvZ6Idk9ltbu1Ve2kAUkf/IiuFVW4JH1CDAgs8CstcX0
	 KFIJXYHoTIb3Gq6WTIH4HCNgywrD0MHc3LdKI6H4=
Date: Fri, 17 Jul 2026 14:22:07 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
	maz@kernel.org, oupton@kernel.org, tabba@google.com,
	will@kernel.org
Subject: Re: [PATCH 17/18] arm64: fpsimd: Move SME save/restore inline
Message-ID: <alosf_mrqeX668xC@J2N7QTR9R3>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-18-mark.rutland@arm.com>
 <ahWpST4K3rbMbjWK@J2N7QTR9R3>
 <08e5ce52-be74-4fc5-a0b2-8f405a5eff99@arm.com>
 <ahW8Eba3SNqfVDdk@J2N7QTR9R3>
 <ahXMkPEpgaZQf_Nk@J2N7QTR9R3>
 <ahlYC2qgqzNQxggP@J2N7QTR9R3>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahlYC2qgqzNQxggP@J2N7QTR9R3>

On Fri, May 29, 2026 at 10:10:35AM +0100, Mark Rutland wrote:
> On Tue, May 26, 2026 at 05:38:40PM +0100, Mark Rutland wrote:
> > On Tue, May 26, 2026 at 04:28:17PM +0100, Mark Rutland wrote:
> > > On Tue, May 26, 2026 at 03:39:56PM +0100, Vladimir Murzin wrote:
> > > > I suspect you are intentionally not using "Ucj" constrain to limit register allocator,
> > > > if so I'm wondering why?
> > > 
> > > Thanks for the suggestion; that was ignorance rather than intent.
> > > 
> > > I was not aware of "Ucj" as it doesn't appear on the public GCC
> > > documentation:
> > > 
> > >   https://gcc.gnu.org/onlinedocs/gcc/Machine-Constraints.html
> > > 
> > > Looking at the machine description file, that's marked with '@internal',
> > > so IIUC GCC folk don't seem to expect/want people to use it. That said,
> > > LLVM seems to support it.
> > > 
> > > I'll go check that all relevant toolchains support this, and poke GCC
> > > folk to see if they're happy to promote that to a public constraint.
> > 
> > GCC folk seem happy to make this public, which is great! I'll cross-link
> > a thread here if/when patches appear.
> 
> Alex Coplan sent a patch for GCC to make this public:
> 
>   https://gcc.gnu.org/pipermail/gcc-patches/2026-May/718560.html

Just for posterity, that was merged in GCC commit:

  090f3e78a10b5ce14fd80de82d3e8dda8af1cae6 ("aarch64: Make Uc[ij] constraints public")

... which can be found at:

  https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=090f3e78a10b5ce14fd80de82d3e8dda8af1cae6

... so we should be able to use that in future once our minimum
supported toolchains are GCC 14.1.0+ and and LLVM 18.1.0+.

Mark.
