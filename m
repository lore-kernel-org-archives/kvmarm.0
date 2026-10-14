Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 374312D063E
	for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 15:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791993381; cv=none; b=ozGTDUlc9APYul6OqsRL0GZ6BAQdcexqjTuweGbXCD3NHwZt1vc4cCHFFVxvV4DcaeqRgYEEy02fFeZSXOr2kf7O1QXxlmAkb2RxTah2GFxnt6qFfnK3KDXh5Xmi3KhCUB1tNUi57M69IfnoULxzhPyVoeXC171UXwLA1ColKmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791993381; c=relaxed/simple;
	bh=va13RaM/sanuKVZ3CaYPU08d6tBndpG5IAYdTqJH6Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=L5yl/J1TDPONV3GaKSwhqz1zTFduj3/9T7J2SKbyc+qj40fZoDp/XyywsqmGsnT3RCvN3aGyQu05E2nOkfXGBtQTsnD1GUlhDNhBJJ3d8R4K03+qR054eGsZrMVehMIVR5FvDYiVmCuJac6Tccv4GlVHA/8j4NNekt1o+g5mWVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=J3j8A+o7; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="J3j8A+o7"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 43B3D14BF;
	Wed, 14 Oct 2026 08:56:16 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 890BA3F7B4;
	Wed, 14 Oct 2026 08:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791993379; bh=va13RaM/sanuKVZ3CaYPU08d6tBndpG5IAYdTqJH6Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J3j8A+o7YMnGQzWRo3Z55LcdGh0AeUHPrlQxrh+yhl6FsnnpzMxM6D9BXg0A0gTAg
	 C1Ab0IcjTSRIDPSFmfs7zaufoifA+gC2NpOekh0hFjItW/wNaTum6HLrjMfY9BL8ej
	 cd+J+gOyOsf8XLF2oRHGcSe54kVXiZjIQ+TjmUZk=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Tian Zheng <zhengtian10@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 5/5] KVM: arm64: Enable HAFDBS for guests not on migration
Date: Wed, 14 Oct 2026 16:56:15 +0100
Message-ID: <as-mH36YSMxAosND@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <aqvt2gnlBZeNsaf4@LeoBrasDK>
References: <20260901171558.2674031-1-leo.bras@arm.com> <20260901171558.2674031-6-leo.bras@arm.com> <aqneWnlsdpocLIl6@kernel.org> <aqqhDs3NyjtkZzXK@LeoBrasDK> <aqsl1_IqnV2r8kUL@kernel.org> <aqvt2gnlBZeNsaf4@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Sep 17, 2026 at 02:40:42PM +0100, Leonardo Bras wrote:
> On Wed, Sep 16, 2026 at 04:27:19PM -0700, Oliver Upton wrote:
> > On Wed, Sep 16, 2026 at 03:00:46PM +0100, Leonardo Bras wrote:
> > > On Tue, Sep 15, 2026 at 05:10:02PM -0700, Oliver Upton wrote:
> > > > Hi,
> > > > 
> > > > On Tue, Sep 01, 2026 at 06:15:56PM +0100, Leonardo Bras wrote:
> > > > > When dirty-logging is disabled, even non-write faults make a page dirty,
> > > > > which avoids a second fault when the page is actually written to.
> > > > > 
> > > > > On dirty-logging enable, this approach causes all (writable) pages on the
> > > > > memslot to be marked clean, even if they were not written to, which can
> > > > > take a lot of time, while holding the MMU lock, doing atomic writes to
> > > > > PTEs.
> > > > 
> > > > Do you have any performance numbers for this? Enabling HAFDBS seems a
> > > > bit involved to avoid some stores on the first pass.
> > > 
> > > Not yet, but if the idea does not look too crazy I can find hardware and 
> > > collect some data :)
> > 
> > TBH this looks like a micro-optimization so I'm not expecting the
> > performance gains to justify the behavior change.
> > 
> 
> Okay then, I will get a machine to figure the performance gains :)

Got the performance numbers here. 
I tested both the case where all PTEs are dirty, and the case that 50% of 
the PTEs are dirty.

For that test, actually patch #5 could make kvm_pgtable_stage2_wrprotect() 
slower, which is counter-intuitive, in all platforms tested:

When we walk the S2 pagetable to wrprotect, using the new walker, the 
write to the PTE itself is so cheap* that the cost of the branch 
misprediction (write PTE or not) for the 50/50 case is significantly higher 
than the cost of the 50% extra writes, which makes the 50/50 up to 60% 
slower than the 100% dirty case. It is still slower in the '25% dirty' as 
well, and starts to get even at '10% dirty'. 

* (non-atomic, everything is in order, walker is small, cpu will probably 
bundle it all in a single cacheline write) 

Since the idea of patch #5 was to reduce PTE writes in the first wrprotect 
walk, it becomes faster only if only a small portion (<10%) of the VM was 
write-faulted while the remaining was read-faulted, which seems to be a 
really reduced audience.

Since this comes with increased complexity, and also carry costs of 
having HAFDBS itself enabled outside dirty-tracking, I don't think it's a 
good idea to further pursue patch #5. It's only value is that it served as 
a base for HDBSS implementation.

Thanks for reading!
Leo
