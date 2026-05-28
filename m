Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E998128727D
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 17:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779987654; cv=none; b=UqrfZbvokx88/ItQi87X++kSEMU0Za9uvbGKXiuTw9ggl/p+vtdRNKTFk8e9kIv96NtV1eJ/Xc9MFwlS4gRdR06JhmYBE1PBzs+kL+OYUtJIyMrU7alKR5P5hpSnOOx13U0IXOGBJCtpO2f7T+zMK2LqvR0WCSRteAY3t1NjLF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779987654; c=relaxed/simple;
	bh=CTP15c6ZTQAbPUo//xK8LqjektCEHBQDQm+RD2xFupM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=ZheMHnh7ZsHT/Mblg4tP4r6Yexyq2PtEvIytICSCkZTdX6zysLTS9XfLelxQAxfkrJKQQovmwHwskINXEIK9atHTdLL9tQTHDxktP/WrL8o+8ms+D4oh48pVChQtjg9t4jdUF18kZcvF9iTf00NUSgCNKB+8QMracrR+8kl2Ydk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pylq86ay; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pylq86ay"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 62CD14617;
	Thu, 28 May 2026 10:00:47 -0700 (PDT)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 845303F905;
	Thu, 28 May 2026 10:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779987652; bh=CTP15c6ZTQAbPUo//xK8LqjektCEHBQDQm+RD2xFupM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pylq86ayT02MasE10PueW9vf56oVo+Exa5ofT6xhS0uiZ8K+FNNhPU7eYE7Y0ubja
	 88FRnwjfHOPwRRPlUJrc5mgKuSn1mY6YrrGWkL2UPzyHuEUpHv8pd65cIsOQPqIfrb
	 GajKq0iNr6IBPXKC2tsc2UuWgbovFAWWMwak9W98=
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
Date: Thu, 28 May 2026 18:00:48 +0100
Message-ID: <ahh0wOamCIKbmQqp@devkitleo>
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
> access to one of these mythical arm64 toys. Measure things from
> userspace, not from the kernel, so that you have all the overheads.
> Don't add console output, because that will make things far worse.
> 
> I'm sure you can hack one of the selftests for this purpose.

Hello Marc,

I have ran some tests in real hardware (AmpereOne) and calling from 
userspace as you suggested.

The tests create a 64GB VM, using either regular pages (no split needed), 
THP backed memory or Hugetlb. 

Those tests measured the times for the whole syscall that happens to do
eager page splitting, in this case,
1 - Manual protect and init set: On every KVM_CLEAR_DIRTY_LOG, if the page
    was requested to be cleaned, it is also split.
2 - Otherwise, on dirty log enable (aka KVM_SET_USER_MEMORY_REGION2 with
    KVM_MEM_LOG_DIRTY_PAGES set in flags), for the whole memslot is split
    at once.

Tests reflect new suggestions I got in this patchset: instead of using 
return values, I am using flags to skip whole levels, or skipping children 
nodes. I tested those 2 kernels, on top of vanilla:
a - Skip levels
b - Skip levels, and skip children node

Results averaged across 4k, 16k and 64k pages, a percentage of time 
saved, compared to vanilla kernel. More is better.

For (1), we have
regular pages:	26.7% (a) and 25.3% (b)
THP:		13.2% (a) and 11.9% (b)
Hugetlb:	14.3% (a) and 13.2% (b)

For (2), we have:
regular pages:	33.1% (a) and 35.0% (b)
THP:		11.9% (a) and 10.7% (b)
Hugetlb:	13.4% (a) and 13.2% (b)

On above results, I could notice about 1% overhead showing that skipping 
child nodes (testing flag) ends up being counter-productive compared to 
just skipping levels. The only case this does not happen is (2a), but it's 
not clear on why that happens.

Based on that, I plan to remove the skip_child patch, and send a v2 with a 
flag-based mechanism, which results are shown above.

Please let me know of any thoughts, suggestions or ideas you might have 
about it.

Thanks!
Leo

