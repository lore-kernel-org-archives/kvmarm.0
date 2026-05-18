Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2040481FCB
	for <kvmarm@lists.linux.dev>; Mon, 18 May 2026 13:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779111973; cv=none; b=pbCgS5Auzp4lQPenpFgwdAhj+uvuE5ipiLT933+W5L3JmOl5syC+qCAvx9dRbwautP54TcaBmoUnCQyPan5pQvThHlG9Z7c9T8iGLiXlnx9tO3WIycQid5pdLlR8yDkUbrfp3Mrw14dr/87NfqnkVt/jpm4jFZpATLCqo5Aa7O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779111973; c=relaxed/simple;
	bh=fhdGtklIFTyvTEj9H05WIHW2CNgFWJkbGWF6iw7PZzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=b8F5RwcYQXKl708aHxlf5+LXF42/sbzwa1Pd0kUz6ojziYJPNtVz3lqFMw+DFJUmsuCJCAjHEsRIpnWj2ubfGx1xPE07Ji4JtuYRcWVkw0s/om3BxM1txbz4UHT+lBQzjCJG948ccwZ+j4NxYkV3qbnxEIZ8d32CxdzkPyxe7vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=beTSK4+W; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="beTSK4+W"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4E9711C14;
	Mon, 18 May 2026 06:46:03 -0700 (PDT)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4EE3F3F7B4;
	Mon, 18 May 2026 06:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779111968; bh=fhdGtklIFTyvTEj9H05WIHW2CNgFWJkbGWF6iw7PZzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=beTSK4+WHg0cuF6W9ehQ1y809SqkXFak9EQbi6G8zWnRsR/8ytwO07ZgN//Hv7643
	 k+CJRIzOwfYsYD4592NwkXss+qG3ninaFAf/Dz04n9BHZr3c0L4ehe0lmU8hG24QSb
	 9jeD793DfqECw3hAjWyw+Y896oRD5BmF6wzwQ0yI=
From: Leonardo Bras <leo.bras@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] KVM: arm64: Introduce S2 walker SKIP return options
Date: Mon, 18 May 2026 14:45:59 +0100
Message-ID: <agsYF-Dav2bpxWK4@devkitleo>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <agrTQMw4QJX6HGrm@willie-the-truck>
References: <20260515195904.2466381-1-leo.bras@arm.com> <20260515195904.2466381-2-leo.bras@arm.com> <agq-RyKhBy4CIThm@kernel.org> <agrTQMw4QJX6HGrm@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hello Oliver, Will,
Thanks for reviewing!

On Mon, May 18, 2026 at 09:52:16AM +0100, Will Deacon wrote:
> On Mon, May 18, 2026 at 12:22:47AM -0700, Oliver Upton wrote:
> > On Fri, May 15, 2026 at 08:59:02PM +0100, Leonardo Bras wrote:
> > > Introduce S2 walker return values:
> > > - SKIP_CHILDREN: skip walking the children of the current node
> > > - SKIP_SIBLINGS: skip waling the siblings of the current node
> > > 
> > > Also, modify __kvm_pgtable_visit() to fulfil the hing on above return
> > > values. Current walkers should not be impacted
> > 
> > I'd rather see something based around new walk flags than introducing an
> > entirely new mechanic around return values.
> > 
> > e.g. you could split the LEAF flag into separate flags for blocks v.
> > pages:
> > 
> > 	KVM_PGTABLE_WALK_PAGE,
> > 	KVM_PGTABLE_WALK_BLOCK,
> > 	KVM_PGTABLE_WALK_LEAF	= KVM_PGTABLE_WALK_PAGE |
> > 				  KVM_PGTABLE_WALK_BLOCK,
> > 
> > and then let __kvm_pgtable_visit() decide how to steer the walk. You may
> > need some special handling to get the address arithmetic right when
> > skipping over a table of page descriptors.

I am probably not getting the whole inner workings of this solution, but 
IIUC the idea would be to walk the blocks, but not the pages, right?

Blocks meaning level2- and pages being level3?
 
> I was wondering along similar lines, but maybe it would be useful just
> to pass a maximum level to the walker logic? That feels like the most
> general case without complicating the existing logic.

This proposal seems simpler for me to understand, and indeed looks like a 
better solution than what I have proposed, taking care of  the 
'already split' case with better performance, as it don't even walk a 
single level-3 entry. 

On the 'splitting' case, it also works flawlessly if the memory is given in 
level-2 blocks. There is only one case that I would like to address here:

- Memory given in level-1 blocks (say 1GB)
- Walker flag says 'walk down to level-2 only'
- Split Walker on level-1 will break page down to (up to) level-3 entries.
- Walker will continue to be called on level-2 entries, even though it's 
  not necessary.

To solve this, I would like to suggest a new flag, that skips a table 
that has just been created. This could be easily implemented in 
__kvm_page_visit() on top of the max level flags suggested.

enum kvm_pgtable_walk_flags {
[...]
	KVM_PGTABLE_WALK_SKIP_LEVEL3		= BIT(7),
	KVM_PGTABLE_WALK_SKIP_LEVEL2		= BIT(8),
	KVM_PGTABLE_WALK_SKIP_LEVEL1		= BIT(9),
	KVM_PGTABLE_WALK_SKIP_NEW_TABLE		= BIT(10),
};

How does that sound?

Thanks!
Leo
