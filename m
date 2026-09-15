Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D904B4BB266
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 17:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789493610; cv=none; b=Oztl1BgSehXF0z4xSEJggoc3VkLpxiAZ2wdRENHy+E7AsKe4zkXtdIpeVlLYCleqlW8vkzL4bQ/IxDU5Jw0ej+NhuVm15mblbCG0bmDIh0r7Cly96OBNoZhAiQI2Klg8hyS0E9gobKCKfmkOyjGYb0aeVi4bv/hcgvYwU0a+SNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789493610; c=relaxed/simple;
	bh=/wWBh71FKUsFODK4w0sj0XMuvIkHLWs6/7O4iGiGBKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=V7/xkqEyQhALHYZNpI9nQwHiRaLvYp3mqYFiYEPa4txe9f7Y1fwujSMw6+FP70Li+XUU7Zxy9CrWThyzHx/9N2Wv54E4H2eyftT+vXsgGmJvBvmWm2ogabdsXLYA6PGZ421CFS59PXK1C3AONKLbJj52PgaLAK2btmrAIRiFR5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aUjCat8O; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aUjCat8O"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 772CA153B;
	Tue, 15 Sep 2026 10:33:24 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (unknown [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BA50C3F7B4;
	Tue, 15 Sep 2026 10:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789493608; bh=/wWBh71FKUsFODK4w0sj0XMuvIkHLWs6/7O4iGiGBKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aUjCat8OMGi/UwlPtErQ43yH9VypMnUbSmTWNPocpPm6e7I1TVgYOaKIcD495AVen
	 hDOKJxTPcUrE2FGdKZV4EfYBPhfy32JTWr++X+AZ+2WM0JQIpEMd5a0HhVrMSeEX7b
	 luo9N6b1nXMMeRmrJtRSuJyoyEzhgFJ0bAK1X86s=
From: Leonardo Bras <leo.bras@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>,
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
Subject: Re: [RFC PATCH 2/5] KVM: arm64: Add KVM_PGTABLE_PROT_DIRTY
Date: Tue, 15 Sep 2026 18:33:23 +0100
Message-ID: <aqmBY_v74r4GMttY@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <86a4pl7c1m.wl-maz@kernel.org>
References: <20260901171558.2674031-1-leo.bras@arm.com> <20260901171558.2674031-3-leo.bras@arm.com> <86a4pl7c1m.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sun, Sep 13, 2026 at 10:09:25AM +0100, Marc Zyngier wrote:
> On Tue, 01 Sep 2026 18:15:53 +0100,
> Leonardo Bras <leo.bras@arm.com> wrote:
> > 
> > Second step of changing the encoding for the Stage2 PTE descriptor,
> > introduce the concept of dirty page, so we can have a writable but not
> > dirty (WC) page, and a writable and dirty (WD) page.
> 
> Why should we care about *setting* the dirty bit in the PTE? Under
> what circumstance do we want to establish a mapping as being dirty?

We want a mapping to be dirty whenever it's writable and we don't want to 
track it being changed anymore.

A writable-dirty is for when a mapping can be written to, but still did not 
happen.

> 
> The whole point of DBM is to only set something dirty when it is
> written to, and this patch breaks this invariant.
> 
> Maybe you have a good reason to do so, but that's not explained.

Sorry it was not clear.
The idea of this patch is to introduce the dirty state, without causing 
any change in the behavior of the system.

Before patchset: 
- RW : S2AP = 1
- RO : S2AP = 0

After patch 1:
- RW = WD: S2AP = 1, DBM = 1
- RO     : S2AP = 0, DBM = 0

After patch 2:
- WD : S2AP = 1, DBM = 1
- WC : S2AP = 0, DBM = 1
- RO : S2AP = 0, DBM = 0

That splits the concept of writable and dirty from the previous RW state, 
so they can be independent.

We can mark a page writable, without it being dirty, which allows HAFDBS in 
the future to mark it dirty whenever it happens to receive a write. (and 
use HDBSS to register it on a buffer, and so on)

As of now there is no enablement of the HAFDBS, so up to this patch 
there should not be any impact to users, as the DBM bit is ignored if 
VTCR.HD=0.

Patch 5 introduces an possible use of this using HAFDBS when dirty-tracking 
is disabled to avoid marking all PTEs as clean at the dirty-track enable. 

Does it look more clear now?
Do you think adding parts of the above text in the commit message would 
help?

Thanks again!
Leo
