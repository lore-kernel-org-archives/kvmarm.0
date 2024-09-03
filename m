Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 288C3143748
	for <kvmarm@lists.linux.dev>; Tue,  3 Sep 2024 14:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725375260; cv=none; b=mVu8Q5ZUUdxUD7yBJ/pFRxy+Ps4IDVGs94OKhj7xD20h3eGhvaZiVuP/y3Vt39PCZ4zrgk/Q6QEWHtv+LJ/BlYCPrbOzAEtEzstiE+hmAZID9z1MbDsWucBsSyUGt6vzFJAxfn86ks0aj3qAGC62nGT1dH+T0EBfARrj5ld3WfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725375260; c=relaxed/simple;
	bh=PFZQ6NWqaKynv8f2IgqmAWzdtFGU8hY07DRimKSgbSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YHQfWomAdhfKERMWd5zOshO6u6tBPc+E/5ybJpi/KVzNwoHZHdoXO8G/fWUk1drJoALh5MZRRwQq+8ci2y4fbckGTG+TnYeGdJPbgCNNeI8Qpto6jkoGld3072rASwrM+iuDcpgEztH5GBKub8RMZOd3Zhbr3GWvRf6AsU1TNd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E4FE4FEC;
	Tue,  3 Sep 2024 07:54:44 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 37AF13F66E;
	Tue,  3 Sep 2024 07:54:15 -0700 (PDT)
Date: Tue, 3 Sep 2024 15:54:13 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	nd@arm.com, akpm@linux-foundation.org, aneesh.kumar@kernel.org,
	aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com, bp@alien8.de,
	broonie@kernel.org, christophe.leroy@csgroup.eu,
	dave.hansen@linux.intel.com, hpa@zytor.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, maz@kernel.org, mingo@redhat.com,
	mpe@ellerman.id.au, naveen.n.rao@linux.ibm.com, npiggin@gmail.com,
	oliver.upton@linux.dev, shuah@kernel.org, skhan@linuxfoundation.org,
	szabolcs.nagy@arm.com, tglx@linutronix.de, x86@kernel.org,
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 06/30] arm64: context switch POR_EL0 register
Message-ID: <20240903145413.GB3669886@e124191.cambridge.arm.com>
References: <20240822151113.1479789-1-joey.gouly@arm.com>
 <20240822151113.1479789-7-joey.gouly@arm.com>
 <20240823144531.GH32156@willie-the-truck>
 <Zsi7ovLOfuFdfuuz@arm.com>
 <20240823170835.GA1181@willie-the-truck>
 <ZsjXtE7Kg0LQwNAL@arm.com>
 <20240827113803.GB4318@willie-the-truck>
 <ZtYNGBrcE-j35fpw@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtYNGBrcE-j35fpw@arm.com>

On Mon, Sep 02, 2024 at 08:08:08PM +0100, Catalin Marinas wrote:
> On Tue, Aug 27, 2024 at 12:38:04PM +0100, Will Deacon wrote:
> > On Fri, Aug 23, 2024 at 07:40:52PM +0100, Catalin Marinas wrote:
> > > On Fri, Aug 23, 2024 at 06:08:36PM +0100, Will Deacon wrote:
> > > > On Fri, Aug 23, 2024 at 05:41:06PM +0100, Catalin Marinas wrote:
> > > > > On Fri, Aug 23, 2024 at 03:45:32PM +0100, Will Deacon wrote:
> > > > > > On Thu, Aug 22, 2024 at 04:10:49PM +0100, Joey Gouly wrote:
> > > > > > > +static void permission_overlay_switch(struct task_struct *next)
> > > > > > > +{
> > > > > > > +	if (!system_supports_poe())
> > > > > > > +		return;
> > > > > > > +
> > > > > > > +	current->thread.por_el0 = read_sysreg_s(SYS_POR_EL0);
> > > > > > > +	if (current->thread.por_el0 != next->thread.por_el0) {
> > > > > > > +		write_sysreg_s(next->thread.por_el0, SYS_POR_EL0);
> > > > > > > +		/* ISB required for kernel uaccess routines when chaning POR_EL0 */
> > > > > >
> > > > > > nit: typo "chaning".
> > > > > >
> > > > > > But more substantially, is this just to prevent spurious faults in the
> > > > > > context of a new thread using a stale value for POR_EL0?
> > > > >
> > > > > Not just prevent faults but enforce the permissions from the new
> > > > > thread's POR_EL0. The kernel may continue with a uaccess routine from
> > > > > here, we can't tell.
> [...]
> > > > So what do we actually gain by having the uaccess routines honour this?
> > >
> > > I guess where it matters is more like not accidentally faulting because
> > > the previous thread had more restrictive permissions.
> >
> > That's what I wondered initially, but won't the fault handler retry in
> > that case?
>
> Yes, it will retry and this should be fine (I assume you are only
> talking about the dropping ISB in the context switch).
>
> For the case of running with a more permissive stale POR_EL0, arguably it's
> slightly more predictable for the user but, OTOH, some syscalls like
> readv() could be routed through GUP with no checks. As with MTE, we
> don't guarantee uaccesses honour the user permissions.
>
> That said, at some point we should sanitise this path anyway and have a
> single ISB at the end. In the meantime, I'm fine with dropping the ISB
> here.
>

commit 3141fb86bee8d48ae47cab1594dad54f974a8899
Author: Joey Gouly <joey.gouly@arm.com>
Date:   Tue Sep 3 15:47:26 2024 +0100

    fixup! arm64: context switch POR_EL0 register

diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index a3a61ecdb165..c224b0955f1a 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -515,11 +515,8 @@ static void permission_overlay_switch(struct task_struct *next)
                return;

        current->thread.por_el0 = read_sysreg_s(SYS_POR_EL0);
-       if (current->thread.por_el0 != next->thread.por_el0) {
+       if (current->thread.por_el0 != next->thread.por_el0)
                write_sysreg_s(next->thread.por_el0, SYS_POR_EL0);
-               /* ISB required for kernel uaccess routines when chaning POR_EL0 */
-               isb();
-       }
 }

 /*

Will, do you want me to re-send the series with this and the permissions diff from the other thread [1],
or you ok with applying them when you pull it in?

Thanks,
Joey

[1] https://lore.kernel.org/all/20240903144823.GA3669886@e124191.cambridge.arm.com/
