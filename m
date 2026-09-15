Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 608934AA575
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 15:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789486311; cv=none; b=rWemwmQWRrOmrXRn3dW9+X23WfF7wkT2oHduQgaZZpbPVGq0sawf8pemDcbaDt5mg1Z7ShyVsNFvY4ojbtpeNgwxUg7krLvZPGl2z4/plNw8ZRTw0Tg/+gcy+BkL+yKlBeUqVzyJhoZ0Nhr62RSvUn5lf+X+O688x52haSaTuQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789486311; c=relaxed/simple;
	bh=mWQLtln8JqbVDxWmmM1gM2C1W+U+J79wvJLkPCMUbsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=lU+8b1pYTjlNyN8b+pNcIowAFmOBbMQZ3lLquJjosrOnVs1IvkBeoHkIXxPav9zwtj2v6SUse+ahwOsMjdAnoWz5ZGziJfd4VQfmOkXP742N4yjeLQlIc4umV804Y1XFBGUXw8WaVlx+qrwhlOeVDgoHAarXGQuGQ03HV54bfNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IyZL4wyq; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IyZL4wyq"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1000B1570;
	Tue, 15 Sep 2026 08:31:41 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (unknown [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 535D63F882;
	Tue, 15 Sep 2026 08:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789486304; bh=mWQLtln8JqbVDxWmmM1gM2C1W+U+J79wvJLkPCMUbsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IyZL4wyqQLgwyeFgfbXMZ6/AZ5Vx7sUqICfywxm2TJ0en2J04PaaVeSAiGOiHpcKC
	 r9MG8QNuZVXKL5gt0h1UVTA6bAs4B0uCvTejoQYitQkyI1Nlhghtdm0C0ug7v04xja
	 aRyVIPm5GXXYIsd5UFOH5OJDHf4tBqe/b/LNPmGU=
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
Subject: Re: [RFC PATCH 0/5] KVM: arm64: New PTE dirty-page encoding, HAFDBS new usage
Date: Tue, 15 Sep 2026 16:31:36 +0100
Message-ID: <aqlk2ApfQvHAs1j_@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <86cxui7j4k.wl-maz@kernel.org>
References: <20260901171558.2674031-1-leo.bras@arm.com> <86cxui7j4k.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sat, Sep 12, 2026 at 01:24:11PM +0100, Marc Zyngier wrote:
> On Tue, 01 Sep 2026 18:15:51 +0100,
> Leonardo Bras <leo.bras@arm.com> wrote:
> > 
> > This series have 2 main goals:
> > 
> > 1 - Patches #1,#2,#3 : Change the PTE descriptor to use WD/WC/RO encodings
> >     making use of the DBM bit, adapting all usages, and
> 
> What are WD and WC? I can sort of guess that this is write-dirty and
> write clean, but that's not exactly obvious. More importantly, you
> don't even explain *why* anything needs changing...
> 
> > 2 - Patches #4,#5 are an RFC on using HAFDBS on a guest to avoid resetting
> >     all PTEs to WC when dirty-logging starts, speeding-up startup.
> > 
> > (1) will also introduce a new walker for cleaning the dirty-bit, which will
> > clear the DBM bit if it's a block mapping (hugepage). This is needed as on
> > lazy-splitting we need to fault a write so we can do the lazy splitting.
> > This is needed for both the next patches, and for HDBSS & HACDBS
> > enablement.
> 
> Again, this is incredibly opaque to the reviewer. What is the problem
> you are trying to solve? This is what a cover letter is for.

Hi Marc, thanks for reviewing!

Okay, I will try to explain it better on the next version. What do you 
think of this text:

===================

This series have 2 main goals:
1 - Introduce a new PTE encoding (Patches #1, #2, #3)
2 - An idea to use HAFDBS on a guest to avoid resetting all PTEs to WC 
    when dirty-logging starts

Goal 1:

Patches #1, #2, #3: Before adding Stage-2 support to HAFDBS, HDBSS and 
HACDBS, we need to change the PTE descriptor encoding, as the DBM bit 
is required on mappings for those hardware engines to actually being 
able to update the PTEs. Currently what we have is:

- Read-Only  (RO): S2AP[1]=0
- Read-Write (RW): S2AP[1]=1 

and for them to work with the new features, we need to have: 

- Read-Only (RO):      DBM=0, S2AP[1]=0
- Writable-Clean (WC): DBM=1, S2AP[1]=0
- Writable-Dirty (WD): DBM=1, S2AP[1]=1

WC and WD are described in the Arm ARM, on R_XZFQH and R_BRFGY.

We also need to prepare for dealing with lazy splitting when HAFDBS is 
enabled: since it updates the PTE without taking a fault on guest write, it 
means we can't have lazy splitting if we mark all PTEs as WC. 
To address that, there is a suggestion to set, on dirty-track enable:

- All pages as WC, as they don't need splitting, and
- All blocks as RO, as they are required to fault to do lazy splitting

In order to have that, a new walker is introduced to have a different 
behavior depending on the entry's level.

This is needed for the Goal 2, as well as for HDBSS enablement.


Goal 2:

Patches #4,#5 are an RFC on using HAFDBS on a guest to avoid resetting
all PTEs to WC when dirty-logging starts, making it faster.

I really just want feedback to understand if it's worth pursuing. 

My main idea is that we can use HAFDBS _outside_ dirty-logging to only mark
dirty the pages that were actually written to. 

That is supposed to make it faster to transverse the pagetables when we 
need to clean the dirty-bit, as there is potentially less atomic writes to 
perform. 

The price paid for that is disabling HAFDBS on every vcpu before we can 
start cleaning the pages, during a dirty-track request.

Please let me know of what you think!

Thanks!
Leo
