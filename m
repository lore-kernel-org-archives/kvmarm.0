Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D970397E9F
	for <kvmarm@lists.linux.dev>; Tue,  7 Apr 2026 09:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775554930; cv=none; b=Oext7BiaFt0v4EOSjOXf13299uCPtn4yckhZeZvABg2Xsc0xAcrTt8QL2QxPVWD28i0yzOjE/zy+2u+4k8/svUwr0OgWC4h/EdewMxEfxPYBvfziElB8GoHonv7/0SPPgd9nTr9MQoe476KMLuA5yajxjyid9tnVCknbytrDUWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775554930; c=relaxed/simple;
	bh=QVk2QexSDpe+HZEkpL5txOUhT8aKVmwKMv7KrU8GZYw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pt/43JURGy+Idihmgnt63BbhFqTqNjV6Z+K8Otgj6A82fxW2LcVkrBmIWV347uzaU7UQ1P0yVC4JnmRQ24Twy54JSoMe+P+L4i2t6m3dy9GPV2iGpzTTv0s0mDqkDFk7DYknrKK7pnNAwSyWI2YgYZgzK2jLT8EgjZItN+bh0pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Heitlxxq; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Heitlxxq"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D2DCC1AED;
	Tue,  7 Apr 2026 02:42:02 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 343DD3F7D8;
	Tue,  7 Apr 2026 02:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775554928; bh=QVk2QexSDpe+HZEkpL5txOUhT8aKVmwKMv7KrU8GZYw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HeitlxxqEEoi85H89/Tmtj+HglpzvFQbeg676fzYA2REer9MbUo2rw03SiyfWhKDG
	 5lJlvZvIcBdZoAZfgEzfclew8VklDpARacR/KV5jdVPRUNUAZmanmXdQD32keuWyVn
	 khMGOW4mOujv7+8+GoDRwxy5Yl7QutLWQ0sMktms=
Date: Tue, 7 Apr 2026 10:42:00 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Walleij <linusw@kernel.org>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH] arm64: clear_page[s] using memset
Message-ID: <adTRaKB4zqxEUkEE@arm.com>
References: <20260306-aarch64-clear-pages-c-v1-1-77c1bb0f1c21@kernel.org>
 <ac7YJPo4Np2zxxEp@arm.com>
 <CAD++jL=G81=ueo7djqUETToE459kpFGniWvBwnYbJtmXrm8MFw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD++jL=G81=ueo7djqUETToE459kpFGniWvBwnYbJtmXrm8MFw@mail.gmail.com>

On Tue, Apr 07, 2026 at 11:25:55AM +0200, Linus Walleij wrote:
> On Thu, Apr 2, 2026 at 10:57 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Fri, Mar 06, 2026 at 09:57:50AM +0100, Linus Walleij wrote:
> > > There is no need to try to second-guess the compiler when
> > > clearing memory. Just call memset() like everyone else.
> >
> > Hmm, that "like everyone else" made me think - why not move this to
> > generic code and only the 1-2 platforms that need their own should
> > override it? Could we do the same with copy_page()?
> >
> > Sorry, more work all of a sudden ;).
> 
> I actually had that planned, I just wanted to know if this would
> be fine for arm64 first so that there is a user.
> 
> It seems you are on board so I will send a 2-patch series
> next.

We might as well merge the arm64 patch first and do the cross-arch
cleanup separately, queued via akpm's tree.

> > > While at it, implement the shorthand for directly calling
> > > the new prototype clear_pages() for larger page chunks.
> > >
> > > No performance regressions can be seen, the fastpath
> > > benchmarks differences are in the noise.
> >
> > I assume the benchmarks ran on real hardware (had to ask, last time you
> > mentioned qemu ;)).
> 
> Quoting my own commit message hehe:
> 
> > No performance regressions can be seen, the fastpath
> > benchmarks differences are in the noise.
> 
> This was tested on hardware with Ryan Robert's fastpath tool.

It wasn't clear to me where the fastpath tool ran ;).

Thanks.

-- 
Catalin
