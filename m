Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73887386C1A
	for <kvmarm@lists.linux.dev>; Wed,  4 Mar 2026 08:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772614165; cv=none; b=ZwGE9dXiKOh4F6WIaQTXDBD3cWNfMUL3d608bXWj5bWjX2V48UIZ7H7SAKmRlSV5Vfs2aMqAuGbyaQiWk0TDmUPdsU4Kp4w8ohpFDXNrV8PtN/vrh5Q3wIJciG5r2YlwOhnr0Ci4cql0PEuhAh1wgs1JGwZjYqDpK+i0zv+VRno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772614165; c=relaxed/simple;
	bh=5SMJ1R7Er2L+59VYFAl6rbBXfy6Oo4tSMMsf8oF3Az4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ipJm4O+ZpUBFXldkpqo3H/rEMHGsDdVcKxOaqIPUufH1bTbK7NPMwR4jx820KY5Tz07ta1MGIGgtmYSWtvCHLELJjr0Xsphd2fJoEbbyIl347VHR8Bd4CGuurXmmlJAn7dC9Q2jtl2fM7u73GPZ9plLnySFhdHBGZGJXMp2jrFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 77349339;
	Wed,  4 Mar 2026 00:49:17 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C377C3F7BD;
	Wed,  4 Mar 2026 00:49:21 -0800 (PST)
Date: Wed, 4 Mar 2026 08:49:19 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: Linus Walleij <linusw@kernel.org>, Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	James Clark <james.clark2@arm.com>
Subject: Re: [PATCH] arm64: Implement clear_pages()
Message-ID: <aafyD6G_Moz8tg1A@arm.com>
References: <20260303-aarch64-clear-pages-v1-1-ad0c3ee9a555@kernel.org>
 <aab0SvA0dU0R0pnl@willie-the-truck>
 <CAD++jLnhe_k1-eU90KjOi_Aj57S53a9GJoCZ-LTE0fz-TVSqvg@mail.gmail.com>
 <87v7fcuij3.fsf@oracle.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87v7fcuij3.fsf@oracle.com>

On Wed, Mar 04, 2026 at 12:05:04AM -0800, Ankur Arora wrote:
> Linus Walleij <linusw@kernel.org> writes:
> > On Tue, Mar 3, 2026 at 3:46 PM Will Deacon <will@kernel.org> wrote:
> >> If we have CPUs that are this sensitive to branches, perhaps we'd be
> >> better off taking the opposite approach and moving more code into C
> >> so that the compiler can optimise the control flow for us?
> >
> > Hm! That would be to create a default clear_page() in
> > <linux/mm.h> and simply delete the existing lib/clear_page.S
> > and let the default kick in.
> >
> > Right now every arch is implementing it custom.
> > Maybe for no reason in some cases, I could try it!
> >
> > I doubt the compiler would emit this part though:
> >
> > #ifdef CONFIG_AS_HAS_MOPS
> > (...)
> > alternative_else_nop_endif
> >         setpn   [x0]!, x1!, xzr
> >         setmn   [x0]!, x1!, xzr
> >         seten   [x0]!, x1!, xzr
> >         ret

It won't generate it. It wouldn't be a pure C but have some inline asm.

Anyway, I'm fine with the .S file, I just wonder whether the DCZID_EL0
read inside the inner loop is causing problems (not the FEAT_MOPS
variant).

> > Three instructions to clear all pages. But maybe that is not good
> > if this is a gigabyte, and the per-page loop provides a good breather
> > preemption point in that case, and then we just shouldn't touch
> > anything.
> 
> The code in folio_zero_user (clear_contig_highpages()) takes care of
> chunking up the clearing based on preemption model.
> The idea being that if you are running with preempt=none or voluntary
> then you might want to call cond_resched(), say every 32MB or so.
> 
> If you are running with preempt=full or preempt=lazy, then it would
> just clear a full GB page.
> 
> That would need the set[mpe]n instructions to be interruptible though.
> (Seems to me that that is true but maybe someone could confirm.)

Yes, they are interruptible (the SETM). The x0, x1 register are left in
a state that the SETM can be restarted from where it was interrupted.

-- 
Catalin
