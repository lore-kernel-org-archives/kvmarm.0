Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E13BE74
	for <kvmarm@lists.linux.dev>; Mon, 22 May 2023 11:48:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB92C4339E;
	Mon, 22 May 2023 11:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684756116;
	bh=NzR3rfiy7f5V0ScGu5MX86EgFxP2+8yHRS3RbtMxm7Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NnzFrLryQl107wIEufOQBoCxHcJsMFQFqCl+Gs3y+Zmt5meebwefkMm8HjqEgXMaz
	 ZYkWPb+x0jBiPEjGvKEK+gFE4STBAGnrfFZgspje+8tWWmpVPPZ2v2T0dPvuWbFFMC
	 zaAPeo5jIIZuy74mqzSG3eZTShzv8pzMNlqilTcCKY/TNJ0D+2VbcF6t6Vbcb/dt51
	 wyhq48VVUx4vWosq+IXeJ8nupzQ/AjDuLILE2fPZIY4HmoSatnedthNv7j/kMfHgMo
	 SZ6W3IMWcwThomJOS2ZU1sYBRzekO9FTiY0zg4Bxww3Nupe2eXyuikS0gueSYXWuvu
	 WbU+Gb9EsWxCA==
Date: Mon, 22 May 2023 12:48:30 +0100
From: Will Deacon <will@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org,
	Quentin Perret <qperret@google.com>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev,
	kernel-team@android.com, Andrew Walbran <qwandor@google.com>
Subject: Re: [PATCH v2 04/10] KVM: arm64: Handle FFA_RXTX_MAP and
 FFA_RXTX_UNMAP calls from the host
Message-ID: <20230522114829.GB5965@willie-the-truck>
References: <20230419122051.1341-1-will@kernel.org>
 <20230419122051.1341-5-will@kernel.org>
 <ZFwDnwLdxjG/XCcM@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZFwDnwLdxjG/XCcM@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hey Oliver,

On Wed, May 10, 2023 at 08:50:39PM +0000, Oliver Upton wrote:
> On Wed, Apr 19, 2023 at 01:20:45PM +0100, Will Deacon wrote:
> > Handle FFA_RXTX_MAP and FFA_RXTX_UNMAP calls from the host by sharing
> > the host's mailbox memory with the hypervisor and establishing a
> > separate pair of mailboxes between the hypervisor and the SPMD at EL3.
> > 
> > Co-developed-by: Andrew Walbran <qwandor@google.com>
> > Signed-off-by: Andrew Walbran <qwandor@google.com>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 184 ++++++++++++++++++++++++++++++++++
> >  include/linux/arm_ffa.h       |   8 ++
> >  2 files changed, 192 insertions(+)

[...]

> > +static int spmd_map_ffa_buffers(u64 ffa_page_count)
> > +{
> > +	struct arm_smccc_res res;
> > +
> > +	arm_smccc_1_1_smc(FFA_FN64_RXTX_MAP,
> > +			  hyp_virt_to_phys(hyp_buffers.tx),
> > +			  hyp_virt_to_phys(hyp_buffers.rx),
> > +			  ffa_page_count,
> > +			  0, 0, 0, 0,
> > +			  &res);
> > +
> > +	return res.a0 == FFA_SUCCESS ? FFA_RET_SUCCESS : res.a2;
> > +}
> > +
> > +static int spmd_unmap_ffa_buffers(void)
> > +{
> > +	struct arm_smccc_res res;
> > +
> > +	arm_smccc_1_1_smc(FFA_RXTX_UNMAP,
> > +			  HOST_FFA_ID,
> > +			  0, 0, 0, 0, 0, 0,
> > +			  &res);
> > +
> > +	return res.a0 == FFA_SUCCESS ? FFA_RET_SUCCESS : res.a2;
> > +}
> 
> </snip>
> 
> I understand SPMD is significant in the context of the whole FF-A spec,
> but I don't think the degree of precision is necessary to get the point
> across for someone coming at this from a more KVM-centric background.
> 
> So, for the sake of readability, could these helpers be named
> ffa_map_hyp_buffers()/ffa_unmap_hyp_buffers() (or similar)? Sticking
> 'hyp' in there somewhere helps the reader understand exactly what is
> getting mapped, since there are both hyp and host buffers.
> 
> Apologies for bikeshedding, but I want to make sure folks w/o knowledge
> of FF-A can at least grasp some of the mechanics here.

It's no skin off my back, we can name them whatever you like!

The only thing I ask is that we're consistent, so if it's ok with you,
I'll rename all the 'spmd_' functions to 'ffa_'.

> > +static void do_ffa_rxtx_map(struct arm_smccc_res *res,
> > +			    struct kvm_cpu_context *ctxt)
> 
> This could do with some clarifying comments as well, since there is
> rather significant interaction between host MAP calls and how we handle
> host/hyp buffers.

Is there something in particular you think needs to be clarified? The
function looks pretty straightforward to me, but then I'm used to it by
now. I'd just like to avoid writing a comment that basically describes
how the code works because that doesn't help anybody.

Will
