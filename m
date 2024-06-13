Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D531137901
	for <kvmarm@lists.linux.dev>; Thu, 13 Jun 2024 06:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718261586; cv=none; b=IIzV/zw3BVe8HJZufVKIIQA3y8rvqk94k1zc4G7i1yvQmbf9CmqvYS5nkM9u/eHhT7AAQRMGQd8n6GkjSO/TSidMpPO7nOVZvRXCsjw9oaoUpIWPVspxTeTyVGvfA74OLecPqP/ONQLA/q7LeLZsthJ5/fYAiKROrRkou2ZSTuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718261586; c=relaxed/simple;
	bh=yraTjogu4eOqUCyxiyu0hsjap40zvHzUuM2vZuXA884=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lfEqcQnX8QeKa1sYOnNi6ZICyoO+aob98z/r7ZncLO9EqUGc6nhK4FcbV3osfaf9nlH8o835Rp0hBSrQdzR+wTmZn7gXeIU5KqLaAc9ZlDNSJeeFeX28rIR/RIUCIzVdSwXY/h+arkn28z3+EwA8aBO2JRruiBriSLNfoHYJlTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=E2YkpHhg; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="E2YkpHhg"
X-Envelope-To: seanjc@google.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718261582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pob+bbjOFf7h6fV5Z73fEIqJzbiI/6j+uQH9c0cAzHg=;
	b=E2YkpHhg9Fmt6ybwKMqAQ8YYVGNLeh+hnNDYUUgtnxXsZt8FPeY8y4asORfx9UtpBGDdgW
	f89IxPl8BPGmssOaYtFNoF4Ne/Nort9q7LMc+MCYF/csuZLtAUXsUTYi9NWg2lq3NtdWXS
	n7jRAHCQzaqnHvPxkt9oahMQUtNWoPk=
X-Envelope-To: jthoughton@google.com
X-Envelope-To: yuzhao@google.com
X-Envelope-To: akpm@linux-foundation.org
X-Envelope-To: pbonzini@redhat.com
X-Envelope-To: ankita@nvidia.com
X-Envelope-To: axelrasmussen@google.com
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: dmatlack@google.com
X-Envelope-To: rientjes@google.com
X-Envelope-To: james.morse@arm.com
X-Envelope-To: corbet@lwn.net
X-Envelope-To: maz@kernel.org
X-Envelope-To: rananta@google.com
X-Envelope-To: ryan.roberts@arm.com
X-Envelope-To: shahuang@redhat.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: weixugc@google.com
X-Envelope-To: will@kernel.org
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: linux-doc@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: linux-mm@kvack.org
Date: Wed, 12 Jun 2024 23:52:54 -0700
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: James Houghton <jthoughton@google.com>, Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v5 4/9] mm: Add test_clear_young_fast_only MMU notifier
Message-ID: <ZmqXRhFSoE38foh6@linux.dev>
References: <20240611002145.2078921-1-jthoughton@google.com>
 <20240611002145.2078921-5-jthoughton@google.com>
 <CAOUHufYGqbd45shZkGCpqeTV9wcBDUoo3iw1SKiDeFLmrP0+=w@mail.gmail.com>
 <CADrL8HVHcKSW3hiHzKTit07gzo36jtCZCnM9ZpueyifgNdGggw@mail.gmail.com>
 <ZmidYAWKU1HANKU6@linux.dev>
 <ZmiqXUwMXtUGanQc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmiqXUwMXtUGanQc@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 11, 2024 at 12:49:49PM -0700, Sean Christopherson wrote:
> On Tue, Jun 11, 2024, Oliver Upton wrote:
> > On Tue, Jun 11, 2024 at 09:49:59AM -0700, James Houghton wrote:
> > > I think consolidating the callbacks is cleanest, like you had it in
> > > v2. I really wasn't sure about this change honestly, but it was my
> > > attempt to incorporate feedback like this[3] from v4. I'll consolidate
> > > the callbacks like you had in v2.
> > 
> > My strong preference is to have the callers expectations of the
> > secondary MMU be explicit. Having ->${BLAH}_fast_only() makes this
> > abundantly clear both at the callsite and in the implementation.
> 
> Partially agreed.  We don't need a dedicated mmu_notifier API to achieve that
> for the callsites, e.g. ptep_clear_young_notify() passes fast_only=false, and a
> new ptep_clear_young_notify_fast_only() does the obvious.
> 
> On the back end, odds are very good KVM is going to squish the "fast" and "slow"
> paths back into a common helper, so IMO having dedicated fast_only() APIs for the
> mmu_notifier hooks doesn't add much value in the end.
> 
> I'm not opposed to dedicated hooks, but I after poking around a bit, I suspect
> that passing a fast_only flag will end up being less cleaner for all parties.

Yeah, I think I'm headed in the same direction after actually reading
the MM side of this, heh.

-- 
Thanks,
Oliver
