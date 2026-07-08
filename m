Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A994D43F4CB
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 17:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783530027; cv=none; b=LPaKPKxj74bX9hNHVq6vVwWHgY1Q81oEqTe5pSP3o92Oh4cZewEgrQRRpWoR1uWbRoA5ebXm1gEJa4XbjEef5KTdLQO8TZdcowVjUZSY/0XJ+VnaQX0CVb6Kz6EXTDN5ecunT0hqqEgg2IB3IPK3KTbDkf9KOV5g/DpM+9t5orA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783530027; c=relaxed/simple;
	bh=cfr+dPlXU3RH6R71sBVR+lg3TvtZzuQin7cnXsJOpN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=L02k6MTzroOdygx91j4ubwy6stOyiEx9Tyh+X+Nkf5A7Xyb14Jysh3mgDKTkuasDCm+AqpSOMQX9FzDd5IuTBHRpRWqXfDPh+pbvbGg/CHxRpW0MmYaRChj0QFbKrFZT6HCUCqN1UKc00f3hDd3yZp2qQHBOpjbglMg5FY50yj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Pq+8oaDk; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Pq+8oaDk"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 571C71D14;
	Wed,  8 Jul 2026 10:00:20 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F10AE3F7B4;
	Wed,  8 Jul 2026 10:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783530024; bh=cfr+dPlXU3RH6R71sBVR+lg3TvtZzuQin7cnXsJOpN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pq+8oaDkeXoQ71qDYisedxETmd1HbvAj5vViUMd6MuR6hyiF6ruvC+QvM7UCNiKz4
	 j2JEIUr4Iz3K1+/wgoWOITAQyfw0CWCirp6sPN0EoVFJmj/tE+602UJxK/KHkgrw/A
	 COdzQ4BYhIQEyLWi3AuFlC/PoaiuIizLMOmsOgH4=
From: Leonardo Bras <leo.bras@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] KVM: arm64: Avoid re-testing walk_continue
Date: Wed,  8 Jul 2026 18:00:21 +0100
Message-ID: <ak6CJWdhPaIYj2GU@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <8733xt77tq.wl-maz@kernel.org>
References: <20260708134101.2514759-1-leo.bras@arm.com> <20260708134101.2514759-2-leo.bras@arm.com> <8733xt77tq.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jul 08, 2026 at 05:41:05PM +0100, Marc Zyngier wrote:
> On Wed, 08 Jul 2026 14:40:57 +0100,
> Leonardo Bras <leo.bras@arm.com> wrote:
> > 
> > In __kvm_pgtable_visit(), a couple tests for kvm_pgtable_walk_continue()
> > will 'goto out' if it should not continue. This means the same test will be
> > ran again before returning ret, which is unnecessary.
> > 
> > Return ret directly instead.
> > This will simplify next patch.
> 
> This reads quite badly, and doesn't explain what you are trying to do.
> How about something like:
> 
> "__kvm_pgtable_visit() performs a bunch of calls to
>  kvm_pgtable_walk_continue() to find out whether the walk can continue
>  further, and if not, falls back to an 'goto out' which retests the
>  possibility of continuing the walk.
> 
>  Given that there is no reason why the situation would have changed
>  between the two checks, turn this goto into an early return,
>  simplifying the code and paving the way for further rework."
> 

Agree, your version looks better.
Will try to be more clear, and reuse some of your version, in my next 
version.

Thanks!
Leo
