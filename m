Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B698979FB
	for <kvmarm@lists.linux.dev>; Mon, 14 Nov 2022 18:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5655CC4314E;
	Mon, 14 Nov 2022 18:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668450004;
	bh=CD83SZx2AI5bChI77ue3CZ0IPIH2kxQlAWgz+MlsjTU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YZAnv8ydk7//8upX12rjHE1xKI8Ny5ESoTwjMY3bbKfJeaZtfds1epVNCEqll0pik
	 wP3PFAIVGCbMeK0ldBArv5pXENbjtuzn+yYXqr+XiX2zI5lXLNIi8MGnBV5ySEgkIo
	 IviBQBxvvM2mUSjMVGEtKiWxwFB2HYbI+vnAfSXLvCEb6HNKxgGtzMcQHYbkyGgYgY
	 fT48uv++b/yuNtm+1CmFi+vOTDJOulj716/D3JS7rLn2PWpZyX+MHyeY2iNzjPNxc8
	 z2J2v3+XoKcGUfYT7cA9u4XEYd2nSKiYtVlsd5/RWpjCWLCfj/4nkCjB9RduzYyjLD
	 6/4bISUHQJ0zA==
Date: Mon, 14 Nov 2022 18:19:57 +0000
From: Will Deacon <will@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	James Morse <james.morse@arm.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Quentin Perret <qperret@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
	kernel-team@android.com, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 00/26] KVM: arm64: Introduce pKVM hyp VM and vCPU
 state at EL2
Message-ID: <20221114181956.GD31476@willie-the-truck>
References: <20221110190259.26861-1-will@kernel.org>
 <86edu9ph3d.wl-maz@kernel.org>
 <Y26ltgCIObKpRTWx@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y26ltgCIObKpRTWx@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hey Oliver,

On Fri, Nov 11, 2022 at 07:42:46PM +0000, Oliver Upton wrote:
> On Fri, Nov 11, 2022 at 04:54:14PM +0000, Marc Zyngier wrote:
> > On Thu, 10 Nov 2022 19:02:33 +0000,
> > Will Deacon <will@kernel.org> wrote:
> > > 
> > > Hi all,
> > > 
> > > This is version six of the pKVM EL2 state series, extending the pKVM
> > > hypervisor code so that it can dynamically instantiate and manage VM
> > > data structures without the host being able to access them directly.
> > > These structures consist of a hyp VM, a set of hyp vCPUs and the stage-2
> > > page-table for the MMU. The pages used to hold the hypervisor structures
> > > are returned to the host when the VM is destroyed.
> > > 
> > > Previous versions are archived at:
> > > 
> > >   Mega-patch: https://lore.kernel.org/kvmarm/20220519134204.5379-1-will@kernel.org/
> > >   v2: https://lore.kernel.org/all/20220630135747.26983-1-will@kernel.org/
> > >   v3: https://lore.kernel.org/kvmarm/20220914083500.5118-1-will@kernel.org/
> > >   v4: https://lore.kernel.org/kvm/20221017115209.2099-1-will@kernel.org/
> > >   v5: https://lore.kernel.org/r/20221020133827.5541-1-will@kernel.org
> > > 
> > > The changes since v5 include:
> > > 
> > >   * Fix teardown ordering so that the host 'kvm' structure remains pins
> > >     while the memcache is being filled.
> > > 
> > >   * Fixed a kerneldoc typo.
> > > 
> > >   * Included a patch from Oliver to rework the 'pkvm_mem_transition'
> > >     structure and it's handling of the completer address.
> > > 
> > >   * Tweaked some commit messages and added new R-b tags.
> > > 
> > > As before, the final patch is RFC since it illustrates a very naive use
> > > of the new hypervisor structures and subsequent changes will improve on
> > > this once we have the guest private memory story sorted out.
> > > 
> > > Oliver: I'm pretty sure we're going to need to revert your completer
> > > address cleanup as soon as we have guest-host sharing. We want to keep
> > > the 'pkvm_mem_transition' structure 'const', but we will only know the
> > > host address (PA) after walking the guest stage-2 and so we're going to
> > > want to track that separately. Anyway, I've included it here at the end
> > > so Marc can decide what he wants to do!
> > 
> > Thanks, I guess... :-/
> > 
> > If this patch is going to be reverted, I'd rather not take it (without
> > guest/host sharing, we don't have much of a hypervisor).
> 
> +1, I'm more than happy being told my patch doesn't work :)
> 
> Having said that, if there are parts of the design that I've whined
> about that are intentional then please educate me. Some things haven't
> been quite as obvious, but I know you folks have been working on this
> feature for a while.

Oh sure, I replied on your patches previously:

https://lore.kernel.org/r/20221110104215.GA26282@willie-the-truck

But here's some more detail...

If a guest issues a SHARE hypercall to share a page with the host, then
we'll end up in a situation where we have the guest as the initiator and
the host as the completer of the share operation. At the point at which
we populate the initial (const) 'pkvm_mem_transition' structure, all we
will have in our hand is the guest IPA of the page being shared. We can't
determine the host (completer) address from this without first walking the
guest stage-2 page-table, which happens as part of the guest initiate_share
code, so that's why the completer address is decoupled from the rest of the
structure -- essentially, it's determine by the initiator after it performs
its check.

Please do shout if there's something else you're not sure about or if the
above is unclear.

> I probably need to give the full patch-bomb another read to get all the
> context too.

We'll probably drop another one of those once 6.2 is out, although we're
going to need the guest private memory story to be resolved before we can
progress much there, I think.

Will
