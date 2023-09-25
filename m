Received: from out-203.mta1.migadu.com (out-203.mta1.migadu.com [95.215.58.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159F0266A5
	for <kvmarm@lists.linux.dev>; Mon, 25 Sep 2023 23:43:26 +0000 (UTC)
Date: Mon, 25 Sep 2023 23:43:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1695685405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NrzQOH1Ox8XxW6NlDhLwmmwu2aR6fzGDNpeuN200bvE=;
	b=PmAfTnh4xkBzPeUzbcb68rsxMXjIr4FaUqQKKc7y0Ux1UaxXGt4Bb7wJ1BmBuCDSI/mLo9
	lUAMJLVj22ChFQjL9DklPGAsqD5eFsb1yAIpoSN+V8lKVkNcXL35aDMsxqEKYcqsCfseR5
	gUbXX5lXL0QlnYfkCcTMgZQmcPl0ReQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vipin Sharma <vipinsh@google.com>,
	Jing Zhang <jingzhangos@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Always invalidate TLB for stage-2 permission
 faults
Message-ID: <ZRIbGe1hvf6kbu4s@linux.dev>
References: <20230922223229.1608155-1-oliver.upton@linux.dev>
 <ZQ4eZcWRO/nHnGc4@linux.dev>
 <87ttrj5181.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ttrj5181.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sun, Sep 24, 2023 at 11:12:30AM +0100, Marc Zyngier wrote:
> On Sat, 23 Sep 2023 00:08:21 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > On Fri, Sep 22, 2023 at 10:32:29PM +0000, Oliver Upton wrote:
> > > It is possible for multiple vCPUs to fault on the same IPA and attempt
> > > to resolve the fault. One of the page table walks will actually update
> > > the PTE and the rest will return -EAGAIN per our race detection scheme.
> > > KVM elides the TLB invalidation on the racing threads as the return
> > > value is nonzero.
> > > 
> > > Before commit a12ab1378a88 ("KVM: arm64: Use local TLBI on permission
> > > relaxation") KVM always used broadcast TLB invalidations when handling
> > > permission faults, which had the convenient property of making the
> > > stage-2 updates visible to all CPUs in the system. However now we do a
> > > local invalidation, and TLBI elision leads to vCPUs getting stuck in a
> > > permission fault loop. Remember that the architecture permits the TLB to
> > > cache translations that precipitate a permission fault.
> > 
> > The effects of this are slightly overstated (got ahead of myself).
> > EAGAIN only crops up if the cmpxchg() fails, we return 0 if the PTE
> > didn't need to be updated.
> > 
> > On the subsequent permission fault we'll do the right thing and
> > invalidate the TLB, so this change is purely an optimization rather than
> > a correctness issue.
> 
> Can you measure the actual effect of this change? In my (limited)
> experience, I had to actually trick the guest into doing this, and
> opportunistically invalidating TLBs didn't have any significant
> benefit.

Sure. We were debugging some issues of vCPU hangs during post-copy
migration but that's more likely to be an issue with our VMM + out of
tree code.

Marginal improvements be damned, I'm still somewhat keen on doing the
TLB invalidation upon race detection anyway. Going back to the guest is
pointless, since in all likelihood we will hit the TLB entry that led to
the permission fault in the first place.

-- 
Thanks,
Oliver
