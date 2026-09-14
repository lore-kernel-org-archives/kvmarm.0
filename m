Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0712D4279FE
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 09:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789377842; cv=none; b=KJAhjE/qebeuHtGrLfH6Y1riuiz2Tlu2GBoZTHaJM3LvKOlgSzNe0x0rqfc5VWu/AP0te8mlcbdByJmWlkwG6T9aNT8DJ4MFXCxbf4r2uT0I3LerUhw2HLlCOIlZ1OO4s3PpKmRbhRbxAiVnXJ2jpc0vQIgsr2MAyXpJPDnO5i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789377842; c=relaxed/simple;
	bh=ubJkUjiuJkItTSWUqe/0/qWR0nEqNxYSRzNn1sapfZc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZdRRotUZSxyIq9r6IrbUQHgrWNUDYKuRWuxCrLxMc9dhuf9VW0nw3fiW+SO3V6Wc/LvP7VHrnOOPF3WUYwmmNx/RjP/VWq8k8vbQEw0JYhsHtJ+I+6Cqv5/op0HGhp0r5s9in232OtwjM97Lh7Jn4xsy2muKNu2hW+sz/rwVdCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jv61bvEN; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jv61bvEN"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E4EBC152B;
	Mon, 14 Sep 2026 02:23:50 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BD7B53F59E;
	Mon, 14 Sep 2026 02:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789377834; bh=ubJkUjiuJkItTSWUqe/0/qWR0nEqNxYSRzNn1sapfZc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jv61bvENQKNeoY/UARjTQmluM6TO6CJ5tqD4HIUC62zheGXchy4HCmSr4YGp5F3IR
	 R462b3Rh50WC0vhuWtYhY2LowIC3Ty3dn/SzPFnYqEXdmLsI9ibA9NX+eqA45iHaXo
	 GeUI1x1EvAnUgnwB+bq27h1cW4cN+D/KbfPXnXqc=
Date: Mon, 14 Sep 2026 10:23:49 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Wang Han <wanghan@linux.alibaba.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH 1/4] KVM: arm64: pgtable: Add Stage-2 unmap without TLBI
 primitive
Message-ID: <aqe9JUQVK-8KlUdm@J2N7QTR9R3>
References: <20260912104834.3093878-1-maz@kernel.org>
 <20260912104834.3093878-2-maz@kernel.org>
 <aqe0w0myu7iIT_tR@J2N7QTR9R3>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqe0w0myu7iIT_tR@J2N7QTR9R3>

On Mon, Sep 14, 2026 at 09:48:03AM +0100, Mark Rutland wrote:
> On Sat, Sep 12, 2026 at 11:48:31AM +0100, Marc Zyngier wrote:
> > kvm_pgtable_stage2_unmap() iterates over a range, unmapping whatever is
> > within the range, and always guarantees that that the corresponding TLBs
> > are invalidated when the function returns.
> > 
> > While this is safe, it means that iterating over empty range on a system
> > that supports range invalidation results in a TLBI per largest block
> > mapping size (1GB, 32MB or 512MB, depending on the base granule size).
> > 
> > This can be pretty expensive in situation where the whole address space
> > is being torn down, as it happens with NV (where S2 MMUs are recycled
> > regularly), and it would be more efficient to elide the per-subrange
> > TLBIs to solely rely on a VMID-wide TLBI.
> > 
> > For this, provide a kvm_pgtable_stage2_unmap_notlbi() helper that elides
> > all TLBIs, and relies on the caller to do the work.
> > 
> > Note that for  pKVM case, no additional helper is provided, and we
> > fallback on the TLBI-aware version.
> 
> Just to check: I assume that before this is called, we have somehow
> ensured that the S2 being torn down isn't live on any PE, and cannot
> become live on any PE? I asssume that's a natural part of S2 lifetime
> management, but I couldn't figure that out from a quick skim of the hyp
> pgtable code.
>
> Assuming so, it might be worth mentioning that in the commit message,
> since it explains why it's safe to invalidate *after* intermediate
> tables are freed by stage2_unmap_walker() calling mm_ops->put_page(). We
> might also be able to add some test/assertion in
> kvm_pgtable_stage2_unmap_notlbi() to ensure it is not called where the
> tables could be live on a PE.

I see Shuai Xue said something in this area, but just to elaborate:

If it's possible that some PE is performing a translation table walk of
the tables being freed, and if a page for an intermediate table gets
freed and reallocated/reused before the TLBI is executed, then HW might
read a garbage value when trying to read a decriptor from that page.
That could lead to a variety of problems (e.g. permit a guest to access
an arbitrary PA, or cause a HW walk to access an arbitrary PA).

Above I had assumed that the S2 table being unmapped+freed weren't live
(e.g. not programmed into any PE's VTTBR) at the time we performed this
invalidation, and hence kvm_pgtable_stage2_unmap_notlbi() could check
some refcount or something to verify that.

If that is the case, all's good, and you can ignore the rest of this
mail. If that is not the case, read on.

If the tables are potentially live on some PE, then it is not safe to
defer the TLB invalidation. However, we can still reduce the TLBIs with
a slightly more elaborate sequence:

(1) Make a temporary copy of the root table (whatever VTTBR points to)
    for the S2 being invalidated.

(2) Clear the entries from the root table (leaving any child
    intermediate/leaf tables as-is).

(3) Perform TLB invalidation for the entire VMID. This will ensure HW
    can't walk to any of the child tables.

(4) Walk the temporary copy of the root table to free the child tables,
    without any TLB invalidation.

(5) Free the temporary copy of the root table.

Mark.
