Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFBCB13F43A
	for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 14:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407966; cv=none; b=OUoDRlKt5naTuR7Rynly6LfZjEDXCRp3tg2onOiNUX1w/TfgqU+KDOa9st3zbZqvUye4UYu40HZ8G7U8SXdkFhYKE0WZcrDgRa74YSP5EWQgx0i5/jVckbs7ze/5Ah16jtsPsRORhV0VxvNCY/GvYNSxyP7/a+b/7HvkLRgbEc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407966; c=relaxed/simple;
	bh=sCxDiVNbZjf7WMYy8fcgHxFMaXVXy0syheMXmm8C+dE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s58+nNkTlA4l+bhR11AewHG4EN/VqWbNBpdfFRs8uhe/FuM003UMnDGI0ZkiIJx3cuGSRFjU9ee6osEwSEtHn1YElIqSaqt9Duis6tgHzs/e5QdKWnG6f/RjACmxHnWRSq8b5Qpa5g7H+SnlpHQbKg6HNzRjm4hIh6r5f77WUu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 98972152B;
	Mon, 24 Feb 2025 06:39:37 -0800 (PST)
Received: from arm.com (unknown [10.1.32.142])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3D2C03F5A1;
	Mon, 24 Feb 2025 06:39:19 -0800 (PST)
Date: Mon, 24 Feb 2025 14:39:16 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Peter Collingbourne <pcc@google.com>
Subject: Re: [PATCH] KVM: arm64: Drop mte_allowed check during memslot
 creation
Message-ID: <Z7yElHKrJGn8XuPS@arm.com>
References: <20250224093938.3934386-1-aneesh.kumar@kernel.org>
 <Z7xSfVME4z2ComUm@arm.com>
 <86ldtvr0nl.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ldtvr0nl.wl-maz@kernel.org>

On Mon, Feb 24, 2025 at 12:24:14PM +0000, Marc Zyngier wrote:
> On Mon, 24 Feb 2025 11:05:33 +0000,
> Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Mon, Feb 24, 2025 at 03:09:38PM +0530, Aneesh Kumar K.V (Arm) wrote:
> > > This change is needed because, without it, users are not able to use MTE
> > > with VFIO passthrough (currently the mapping is either Device or
> > > NonCacheable for which tag access check is not applied.), as shown
> > > below (kvmtool VMM).
> > 
> > Another nit: "users are not able to user VFIO passthrough when MTE is
> > enabled". At a first read, the above sounded to me like one wants to
> > enable MTE for VFIO passthrough mappings.
> 
> What the commit message doesn't spell out is how MTE and VFIO are
> interacting here. I also don't understand the reference to Device or
> NC memory here.

I guess it's saying that the guest cannot turn MTE on (Normal Tagged)
for these ranges anyway since Stage 2 is Device or Normal NC. So we
don't break any use-case specific to VFIO.

> Isn't the issue that DMA doesn't check/update tags, and therefore it
> makes little sense to prevent non-tagged memory being associated with
> a memslot?

The issue is that some MMIO memory range that does not support MTE
(well, all MMIO) could be mapped by the guest as Normal Tagged and we
have no clue what the hardware does as tag accesses, hence we currently
prevent it altogether. It's not about DMA.

This patch still prevents such MMIO+MTE mappings but moves the decision
to user_mem_abort() and it's slightly more relaxed - only rejecting it
if !VM_MTE_ALLOWED _and_ the Stage 2 is cacheable. The side-effect is
that it allows device assignment into the guest since Stage 2 is not
Normal Cacheable (at least for now, we have some patches Ankit but they
handle the MTE case).

> My other concern is that this gives pretty poor consistency to the
> guest, which cannot know what can be tagged and what cannot, and
> breaks a guarantee that the guest should be able to rely on.

The guest should not set Normal Tagged on anything other than what it
gets as standard RAM. We are not changing this here. KVM than needs to
prevent a broken/malicious guest from setting MTE on other (physical)
ranges that don't support MTE. Currently it can only do this by forcing
Device or Normal NC (or disable MTE altogether). Later we'll add
FEAT_MTE_PERM to permit Stage 2 Cacheable but trap on tag accesses.

The ABI change is just for the VMM, the guest shouldn't be aware as
long as it sticks to the typical recommendations for MTE - only enable
on standard RAM.

Does any VMM rely on the memory slot being rejected on registration if
it does not support MTE? After this change, we'd get an exit to the VMM
on guest access with MTE turned on (even if it's not mapped as such at
Stage 1).

-- 
Catalin
