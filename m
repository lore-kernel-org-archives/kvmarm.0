Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82E6185E
	for <kvmarm@lists.linux.dev>; Thu, 10 Nov 2022 10:46:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DFA5C433D6;
	Thu, 10 Nov 2022 10:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668077179;
	bh=zoF9eW1NJnxp6NvTOasLQrApPq3gLiET4Xnl6HJ4PW0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q7yrCBYaMVt5lQUJck43cNgkEMT+tC1Nw66t1auZNSnh//Yylt2VOd8unkP88N97q
	 43FJPjDH/nBQbzrXLZqFovxD+orcb8Q0HL4ILi3Z98noryk44P4Z0JrByTmaL1+nTO
	 8VfNXxVODjqV5SgaebFtb6OAu3iLTg9KdtVelNBwAOFguVj24a06Zqi20epeupTnzO
	 CRCWGg9+Pe5/feaoe4BkM54g3hZ3KB6TFDVORI0hrODNK5Wbnc9PPx0zkwHz0yx/7p
	 hcYpy1zmwG7sek/QC4vDqiEs6y5uO5UrBsfOg4L8DgPiJeM2vuOxAv5jX3e4G/tL5b
	 arKH2PscveFkw==
Date: Thu, 10 Nov 2022 10:46:13 +0000
From: Will Deacon <will@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Quentin Perret <qperret@google.com>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Redefine pKVM memory transitions in
 terms of source/target
Message-ID: <20221110104612.GB26282@willie-the-truck>
References: <20221028083448.1998389-1-oliver.upton@linux.dev>
 <20221028083448.1998389-3-oliver.upton@linux.dev>
 <Y1uncNq2oyc5wALG@google.com>
 <Y1utqG5f0lRrNwlI@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1utqG5f0lRrNwlI@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Message-ID: <20221110104613.uZWfwRk2zP7539fr-hrSPY--MtD2Jazi0aaup6yQev0@z>

On Fri, Oct 28, 2022 at 10:23:36AM +0000, Oliver Upton wrote:
> On Fri, Oct 28, 2022 at 09:57:04AM +0000, Quentin Perret wrote:
> > On Friday 28 Oct 2022 at 08:34:48 (+0000), Oliver Upton wrote:
> > > Perhaps it is just me, but the 'initiator' and 'completer' terms are
> > > slightly confusing descriptors for the addresses involved in a memory
> > > transition. Apply a rename to instead describe memory transitions in
> > > terms of a source and target address.
> > 
> > Just to provide some rationale for the initiator/completer terminology,
> > the very first implementation we did of this used 'sender/recipient (or
> > something along those lines I think), and we ended up confusing
> > ourselves massively. The main issue is that memory doesn't necessarily
> > 'flow' in the same direction as the transition. It's all fine for a
> > donation or a share, but reclaim and unshare become funny. 'The
> > recipient of an unshare' can be easily misunderstood, I think.
> > 
> > So yeah, we ended up with initiator/completer, which may not be the
> > prettiest terminology, but it was useful to disambiguate things at
> > least.
> 
> I see, thanks for the background :) If I've managed to re-ambiguate the
> language here then LMK. Frankly, I'm more strongly motivated on the
> first patch anyway.

Having been previously tangled up in the confusion mentioned by Quentin, I'm
also strongly in favour of leaving the terminology as-is for the time being.
Once we have some of the more interesting memory transitions (i.e.
approaching the cross-product of host/guest/hyp/trustzone doing
share/unshare/donate) then I think we'll be in a much better position to
improve the naming, but whatever we change now is very unlikely to stick and
the patches as we have them now are at least consistent.

I replied separately on the first patch, as I don't really have a strong
opinion on that one.

Will
