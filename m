Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5B922FADE
	for <kvmarm@lists.linux.dev>; Tue, 18 Feb 2025 09:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739870833; cv=none; b=ufPHwBc21skFG4qWrTDjkGyTts2QgjJcSr5p2ZagVGK4O/zzgV2pqcrArYur8iZUDwzxl1HRl/D4zOHvOkBt++m8IsL6y+OuYUnnHtcI1KOw2e5moH4P14PooM6tqsnLtliEDkY+XPqOXdnNMgu9gE9+AxiC6gTtigphp+T0PLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739870833; c=relaxed/simple;
	bh=JrYbhojwammNTDB88kS1BUeIuQnP9/YVGBIojkvxi2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B9b9NGX2IDZOkq74Sou/VXpdYoMSIdeVz49s113zBLzi7Z14LNzLTNDczNTRJOZKBKX/uUTkBtL43IvXwr+wcmfS9aVKu9EmFmb6hv4Wn+K/hV0xVaRrHtwlBltmSm0r05T2bwNsXbCjMVXJ+/5mMjITq7oXt03+zuT83SZvs+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ma/AH0zR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ma/AH0zR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C550C4CEE2;
	Tue, 18 Feb 2025 09:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739870832;
	bh=JrYbhojwammNTDB88kS1BUeIuQnP9/YVGBIojkvxi2I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ma/AH0zRhGFf9Ao4DzuLTR+VTa/9xUo0Nve+1JDMxuL9EML4AHklxkuVG39To+fV2
	 qOvhwMCK+IffyMXbnN0c02EylqqY3jewSaVCmo89zTTs0x7onPC1ECHRrOD1VADyBm
	 r7xOF5Y6huD6AWm1LXU1d0/qeDMGapXJbpWhplZJxo+rpfGsuGJCb4Hh1T8qWosTYP
	 v9YtuqgpNo6eh7wRxzwh5pMjz8zvjDsUXA69Dan7I50goAl1Oe588Ucu6+4Kz9jKRk
	 QPvNTYOjZypRU6WFoBFYbBSP8GQ3nGbh5X6/Vx824Z27OOXvUL7w+2MP8m4oqesmC7
	 nANU4/nDoi29Q==
Date: Tue, 18 Feb 2025 09:27:06 +0000
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, mark.rutland@arm.com,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, broonie@kernel.org, qperret@google.com,
	vdonnefort@google.com
Subject: Re: [PATCH v1 3/3] KVM: arm64: Create each pKVM hyp vcpu after its
 corresponding host vcpu
Message-ID: <20250218092705.GA17030@willie-the-truck>
References: <20250214150258.464798-1-tabba@google.com>
 <20250214150258.464798-4-tabba@google.com>
 <20250217153031.GA16398@willie-the-truck>
 <CA+EHjTyOk_VpcTaD-VsH9X7KjpPKWu-HyVE3EEV+rzhnHar84A@mail.gmail.com>
 <CA+EHjTzLW1HiiPr+=vStMYJcYEHUBFcEy_YMT3uJuLRA3zDzEw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTzLW1HiiPr+=vStMYJcYEHUBFcEy_YMT3uJuLRA3zDzEw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Feb 17, 2025 at 03:56:53PM +0000, Fuad Tabba wrote:
> On Mon, 17 Feb 2025 at 15:41, Fuad Tabba <tabba@google.com> wrote:
> > On Mon, 17 Feb 2025 at 15:30, Will Deacon <will@kernel.org> wrote:
> > >
> > > On Fri, Feb 14, 2025 at 03:02:58PM +0000, Fuad Tabba wrote:
> > > > Instead of creating and initializing _all_ hyp vcpus in pKVM when
> > > > the first host vcpu runs for the first time, initialize _each_
> > > > hyp vcpu in conjunction with its corresponding host vcpu.
> > > >
> > > > Some of the host vcpu state (e.g., system registers and traps
> > > > values) are not initialized until the first time the host vcpu is
> > > > run. Therefore, initializing a hyp vcpu before its corresponding
> > > > host vcpu has run for the first time might not view the complete
> > > > host state of these vcpus.
> > > >
> > > > Additionally, this behavior is inline with non-protected modes.
> > > >
> > > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > > ---
> > > >  arch/arm64/include/asm/kvm_host.h      |  2 +
> > > >  arch/arm64/include/asm/kvm_pkvm.h      |  1 +
> > > >  arch/arm64/kvm/arm.c                   |  4 ++
> > > >  arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  6 ---
> > > >  arch/arm64/kvm/hyp/nvhe/pkvm.c         | 54 +++++++++++++++-----------
> > > >  arch/arm64/kvm/pkvm.c                  | 28 ++++++-------
> > > >  6 files changed, 53 insertions(+), 42 deletions(-)
> > >
> > > [...]
> > >
> > > >  static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
> > > >                             struct pkvm_hyp_vm *hyp_vm,
> > > > -                           struct kvm_vcpu *host_vcpu,
> > > > -                           unsigned int vcpu_idx)
> > > > +                           struct kvm_vcpu *host_vcpu)
> > > >  {
> > > >       int ret = 0;
> > > >
> > > >       if (hyp_pin_shared_mem(host_vcpu, host_vcpu + 1))
> > > >               return -EBUSY;
> > > >
> > > > -     if (host_vcpu->vcpu_idx != vcpu_idx) {
> > > > -             ret = -EINVAL;
> > > > -             goto done;
> > > > -     }
> > > > -
> > > >       hyp_vcpu->host_vcpu = host_vcpu;
> > > >
> > > >       hyp_vcpu->vcpu.kvm = &hyp_vm->kvm;
> > > >       hyp_vcpu->vcpu.vcpu_id = READ_ONCE(host_vcpu->vcpu_id);
> > > > -     hyp_vcpu->vcpu.vcpu_idx = vcpu_idx;
> > > > +     hyp_vcpu->vcpu.vcpu_idx = READ_ONCE(host_vcpu->vcpu_idx);
> > > >
> > > >       hyp_vcpu->vcpu.arch.hw_mmu = &hyp_vm->kvm.arch.mmu;
> > > >       hyp_vcpu->vcpu.arch.cflags = READ_ONCE(host_vcpu->arch.cflags);
> > > > @@ -687,27 +689,28 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
> > > >               goto unlock;
> > > >       }
> > > >
> > > > -     idx = hyp_vm->nr_vcpus;
> > > > +     ret = init_pkvm_hyp_vcpu(hyp_vcpu, hyp_vm, host_vcpu);
> > > > +     if (ret)
> > > > +             goto unlock;
> > > > +
> > > > +     idx = hyp_vcpu->vcpu.vcpu_idx;
> > > >       if (idx >= hyp_vm->kvm.created_vcpus) {
> > > >               ret = -EINVAL;
> > > >               goto unlock;
> > > >       }
> > > >
> > > > -     ret = init_pkvm_hyp_vcpu(hyp_vcpu, hyp_vm, host_vcpu, idx);
> > > > -     if (ret)
> > > > +     if (hyp_vm->vcpus[idx]) {
> > > > +             ret = -EINVAL;
> > > >               goto unlock;
> > > > +     }
> > >
> > > I'm not sure how much we care at EL2, but it looks like there's a
> > > potential spectre gadget here given that 'idx' is now untrusted.
> > > Perhaps chuck something like:
> > >
> > >         idx = array_index_nospec(idx, hyp_vm->kvm.created_vcpus);
> > >
> > > before indexing into 'hyp_vm->vcpus[]'?
> >
> > I'll add that when I respin.
> 
> pKVM is riddled with these kinds of accesses (e.g.,
> get_vm_by_handle(). It might be better if I address this in a separate
> series.

Yeah, makes sense to me. Like I said, I'm not entirely sure how much we
care about spectre at EL2, given that it's using a separate translation
regime, but having a series to fix up some of the potential issues might
provide a useful basis for discussion.

Will
