Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 797023F8899
	for <kvmarm@lists.linux.dev>; Mon, 18 May 2026 14:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779113382; cv=none; b=ttqoGKj5zY5Uu/E28UjCihul6PB+SV4SU93xvVQ/V0UXpJTduMyevVMx8BsLDVd/PqSOtGJJrs5aHjt4DPf4+21jSyi4teywtIfEHNBpkkMFKnCG52BrB2nTS18nk75b0Uob8jPk2tBBQz/4xLVqVnABdrOk5qsLByPO+OOcupY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779113382; c=relaxed/simple;
	bh=l/Qlu3Hv8DU45+5xpV6c4Ys2pdhcs0h9f9qT0mq7CAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=SPZwzQF/Uh7YcNdhoPiRGP/8A464D+tXJMuIJNl7w2R8+DjHlxDCCjaSQTmGZj0Fokl64pImk/00fgdIu+7JkZ1UBP8ROInK5vaXXslSflOMqjIO+lvcPiZuUdkMYLCC3pVLokaz9NSAvDr+S17rWSG2W5Yjk4K71LnnR8F5oG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fF0Rbl+3; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fF0Rbl+3"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AC9641D6F;
	Mon, 18 May 2026 07:09:35 -0700 (PDT)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BF0FB3F85F;
	Mon, 18 May 2026 07:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779113380; bh=l/Qlu3Hv8DU45+5xpV6c4Ys2pdhcs0h9f9qT0mq7CAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fF0Rbl+3+beUy/Z/uEmudgn3t5s4SroQO42yF9HRXheF6oLVt9/UdhuMxyo5YJYem
	 061Y/QZdP51yOHhLMIL9Lmv6zQ4EaLf5wxtJaWug/AmesDsc8mD/rQEkGe+uQIVYsO
	 V2VQnzwfK/BX+w+nZ/E1KWe2awZTmPh4Q84ZHVEA=
From: Leonardo Bras <leo.bras@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Optimize S2 page splitting
Date: Mon, 18 May 2026 15:09:36 +0100
Message-ID: <agsdoBEpPLx38lkI@devkitleo>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <87o6ifaf5z.wl-maz@kernel.org>
References: <20260515195904.2466381-1-leo.bras@arm.com> <87o6ifaf5z.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sat, May 16, 2026 at 10:15:36AM +0100, Marc Zyngier wrote:
> On Fri, 15 May 2026 20:59:01 +0100,
> Leonardo Bras <leo.bras@arm.com> wrote:
> > 
> > While playing with dirty-bit tracking, I decided to take a look on how page
> > splitting works. Found out all entries are walked, even though we can infer,
> > for instance that:
> > - If a level-3 entry is walked, it means the parent level-2 entry is split
> > - If a split just succeeded in an table entry, it means all children nodes
> >   are already split
> > 
> > So I tried to optimize it in a way that it does not break other users.
> > 
> > My main idea is to introduce positive return values that hint to the
> > pagetable walking mechanism that either siblings or children can be 
> > skipped. That should be contained to the visitor function, that returns
> > zero if no error was detected.
> > 
> > Numbers on above optimization are promising:
> > A 1GB VM, running on the model, splitting all at the beginning 
> > (no manual protect):
> > - Memory was already split (4k pages): 	-97.33% runtime (-172ms) - 20 runs
> > - THP backed memory: 			-19.82% runtime (-153ms) - 10 runs
> > - 1x1GB hugetlb memory:			-20.65% runtime (-150ms) - 10 runs
> >
> 
> I haven't looked at the changes in details, but the methodology is
> quite flawed. For a start, measuring anything on a software model
> (QEMU or FVP) doesn't mean anything performance-wise. The trade-offs
> are completely different from a HW implementation, and even the notion
> of time is pretty inconsistent.
> 
> Please run this on actual HW. I'm sure your employer can give you
> access to one of these mythical arm64 toys.

Ok, will use real hardware next.

> Measure things from
> userspace, not from the kernel, so that you have all the overheads.
> Don't add console output, because that will make things far worse.
> 
> I'm sure you can hack one of the selftests for this purpose.

I think the dirty_log_perf_test should have an config I can use for that 
without introducing any change. 

Thanks!
Leo
