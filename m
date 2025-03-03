Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC7B78F3A
	for <kvmarm@lists.linux.dev>; Mon,  3 Mar 2025 21:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741038596; cv=none; b=jum9zOI3+sc5lRP1tN9ArRXiSfRaV4HxrB5HMuIeqaOafbyzoVOXe3MdzGa6G1A/LzP8GmNtnKC/KvPtD4qPkb9nbQHv+qGRn41O7cjwtyBRpf669avwDZEzIKirSCsyt0FmDlGP68wPtz3S4pB6dNYEGS0w2GALHkIaA6dBAxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741038596; c=relaxed/simple;
	bh=ALl48r6anu62p/kIZEp7WsaiglCB7bM580oIvR2O5OE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H+TvdeSRQW7PWI9YoS8RUlG/O65We8dXUvJhF8k1i0EAqP4QZTp3QtIJsT6DDX+kYGDBXhZC8mpVQ6tveAfMFFTvuOEkg94xNzWdRoEViCYEAslDGFwPvZzDucBXkdC3EtulUczP8N2JR1vMD5RfuRrZvxylPzwuKgyLSoK36X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jWIZ0Kng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jWIZ0Kng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4BAC4CED6;
	Mon,  3 Mar 2025 21:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741038595;
	bh=ALl48r6anu62p/kIZEp7WsaiglCB7bM580oIvR2O5OE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jWIZ0KngcSAXcOeweP07+DdJh1gp/KBc4UGaIKuJJhv2OU+lUjCHkVH64IHuPPTni
	 2TPwlG4d4Tfe3R0CfuQ+wDoNygvw4yiDPq4++A2P9n4OrJKl+jW6rHH/R8oT0fxpfk
	 txfO6GRqBGGVIKky1Fl+S2WZEl5/PcWZj+zk+sj9PWGEaB2kecs2VM6G/VenyRgm+S
	 YBAkaS/zsuAcWtxZbgntV3Dj/NErFYNxPflOSa12U5YLCdt8/t9TFieZJU9sBfsSje
	 OMwDDrAR+mZ6WBMnWQkU9ockiZv3fwAe3c5Wa93PIdvRmYI54gMPDa/UhbRUJsamI3
	 HSjQhAWehhJiA==
Date: Mon, 3 Mar 2025 21:49:50 +0000
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: Quentin Perret <qperret@google.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	oliver.upton@linux.dev, mark.rutland@arm.com, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, broonie@kernel.org, vdonnefort@google.com
Subject: Re: [PATCH v2 3/4] KVM: arm64: Factor out pKVM hyp vcpu creation to
 separate function
Message-ID: <20250303214947.GA30619@willie-the-truck>
References: <20250226215520.1759218-1-tabba@google.com>
 <20250226215520.1759218-4-tabba@google.com>
 <Z8ISLxQRcsx2uuHw@google.com>
 <CA+EHjTympdi0wei2Qx=hF2cYvHpzE0sWto2ypcJB3ddmonTROg@mail.gmail.com>
 <20250303191811.GA30361@willie-the-truck>
 <CA+EHjTySqDHDpOy=Vix5ZaNKWg61coySvV3Yk=+i0p8vg3mXTQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTySqDHDpOy=Vix5ZaNKWg61coySvV3Yk=+i0p8vg3mXTQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Mar 03, 2025 at 07:21:33PM +0000, Fuad Tabba wrote:
> On Mon, 3 Mar 2025 at 19:18, Will Deacon <will@kernel.org> wrote:
> > On Mon, Mar 03, 2025 at 07:57:00AM +0000, Fuad Tabba wrote:
> > > On Fri, 28 Feb 2025 at 19:44, Quentin Perret <qperret@google.com> wrote:
> > > > On Wednesday 26 Feb 2025 at 21:55:19 (+0000), Fuad Tabba wrote:
> > > > >  static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
> > > > >  {
> > > > > -     size_t pgd_sz, hyp_vm_sz, hyp_vcpu_sz;
> > > > > +     size_t pgd_sz, hyp_vm_sz;
> > > > >       struct kvm_vcpu *host_vcpu;
> > > > > -     pkvm_handle_t handle;
> > > > >       void *pgd, *hyp_vm;
> > > > >       unsigned long idx;
> > > > >       int ret;
> > > > > @@ -161,33 +178,12 @@ static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
> > > > >       if (ret < 0)
> > > > >               goto free_vm;
> > > > >
> > > > > -     handle = ret;
> > > > > +     WRITE_ONCE(host_kvm->arch.pkvm.handle, ret);
> > > >
> > > > What's the reason to make this a WRITE_ONCE? Does it mean we should
> > > > update the readers to be READ_ONCE()?
> > >
> > > I don't remember the original reason, to be honest. In this case, it
> > > was to make it consistent with downstream code in Android. That said,
> > > I plan on revising all of these soon and fixing this (and related
> > > code) in light of Will's comment regarding potential specter gadgets:
> > >
> > > https://lore.kernel.org/all/20250218092705.GA17030@willie-the-truck/
> >
> > I'm not sure the spectre stuff changes the concurrency aspects here, so
> > Quentin's question presumably still stands even after that.
> >
> > Looking at the Android code, this WRITE_ONCE() pairs with a READ_ONCE()
> > in pkvm_is_hyp_created() which is called without the config_lock held
> > by kvm_arch_prepare_memory_region(). However, given that
> > pkvm_is_hyp_created() is only testing against 0, I don't think the
> > _ONCE() accessors are doing anything useful in that case.
> >
> > The more confusing stuff is where 'kvm->arch.pkvm.handle' is read
> > directly without the 'config_lock' held. The MMU notifiers look like
> > they can do that, so I wonder if there's a theoretical race where they
> > can race with first run and issue TLB invalidation with the wrong handle?
> > That would apply equally to the upstream code, I think.
> 
> Would using _ONCE accessors with the MMU notifiers be enough to avoid
> the race, or do we need to reconsider the lock protecting the handle
> and apply it to the notifiers?

I'm not entirely sure... if we used _ONCE() then we'd get either the
correct handle or zero, but we presumably need to order that against the
page-table somehow. The 'mmu_lock' looks like it gives us that, but I
don't think the notifiers are expecting an uninitialised handle in the
case where the page-table is empty (i.e. if they fire before first run).

Given that the handle is necessary for TLB invalidation, I'd be inclined
to make sure that the handle is allocated and published _before_ the
kvm_pgtable pointer checked by the notifiers is set, but that means
moving the handle allocation into kvm_arch_init_vm(). Is that do-able?

Will
