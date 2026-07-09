Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C0B3D16FB;
	Thu,  9 Jul 2026 20:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783629215; cv=none; b=cAjzx95S7g+Y7DjI2dQwFivGVCaMWn92mwmZ81MIEExU5uP/mfFPaCT3vbnl/xrZAf0tK4QlIWXFPjMRs/sj9G5+M4iDeiGzzwDcQA01K3m3J/rzIZqmWq3PJxvo6IhaSOGAovSmjoUSNZbnCNco5m+zaU5msKnN+bD18YKL5es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783629215; c=relaxed/simple;
	bh=5XLUSjo9f+m/g+adaAiK4fuzGZo41zT1cScw0AsmnqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rTXbX2d+AqU70zCN5P9rLxAkXu2AaMJzxaHN/ldrX9E3p7D9E++YNn3+g1SXP1lmkFmonRgIQDN3RbDAonnFZ2eMH6L0Zgl+f6qwaVJ9Rstto8CE7OrxqSVr/TcqSbdKBJi8TfohZXBdybd1nZ2ZPgCORSKQjr+ayVecryAFTts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n/2GuPIy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n/2GuPIy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE471F000E9;
	Thu,  9 Jul 2026 20:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783629212;
	bh=b/KG7TIcBpiZiS4el0LE+iYccTuVv/lNii4KjbUfLL0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n/2GuPIy58VJVIIU1zKh5qySaCHdgamXriRoUFBqoKkaRGjPaM3dGXmEGkwVF6UVn
	 snC9P4KEKbCoetvivfNhSiKy7tzw0MNAEXzI4nn8aWyr0942zZ7I56qAyLsHdC91vB
	 2GQSaaJA+U8w4zbSwaUuT50IO2PdLuVZST6PFbCzIWvthi77nuJC36mhFNS3cgnFzq
	 2HFhcm3oKTidQO3FIT8xOEQkwH3v2iWXrtTl7TYSHQm5twnVUiDXEluK45ZWPjceCx
	 zrhGDTX+JyY47GBo52d2ypfw420234eFXAzbfsX/dm75ZKHxCQBfDLgXU1aG5X/hDr
	 QtEuFMFGVm/9Q==
Date: Thu, 9 Jul 2026 13:33:30 -0700
From: Oliver Upton <oupton@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
	kvm@vger.kernel.org, david.hildenbrand@arm.com, maz@kernel.org,
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, fuad.tabba@linux.dev, mark.rutland@arm.com
Subject: Re: [RFC PATCH 0/3] KVM: Dirty page logging for guest_memfd-only
 memslots
Message-ID: <alAFmiAsNf6Xm49_@kernel.org>
References: <20260702142912.6395-1-alexandru.elisei@arm.com>
 <akxOrMnlNga-vtQv@google.com>
 <ak0wSQ1133O7B96D@raptor>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak0wSQ1133O7B96D@raptor>

On Tue, Jul 07, 2026 at 05:58:49PM +0100, Alexandru Elisei wrote:
> Hi Sean,
> 
> On Mon, Jul 06, 2026 at 05:56:12PM -0700, Sean Christopherson wrote:
> > On Thu, Jul 02, 2026, Alexandru Elisei wrote:
> > > The memory represented by guest_memfd-only memslots
> > > (kvm_memslot_is_gmem_only() is true) is shared with userspace, which can
> > > freely mmap it and access it. The only thing that is preventing dirty page
> > > logging for such memslots is that KVM doesn't allow slots backed by
> > > guest_memfd to have their flags changed; they can only be created and
> > > deleted.
> > 
> > Please (publicly) document *why*  you want to add dirty-logging support.  It's
> > all but impossible to review new uAPI without knowing the use case.
> 
> Of course, my mistake, I was so deep in this that I didn't realise that
> there might be different perspectives.
> 
> My thinking was that since guest_memfd created with GUEST_MEMFD_FLAG_MMAP +
> GUEST_MEMFD_FLAG_INIT_SHARED is extremely similar from a userspace point of
> view to using an anonymous file (created with memfd_create()), that
> supporting dirty page logging and migration would be a natural next step
> and would expand the usefulness of guest_memfd. It has nothing to do with
> confidential compute.
> 
> As to why I'm working on it now, it's because of an arm64 feature that
> requires that memory remains mapped at stage 2, called Statistical
> Profiling Extension (SPE), similar to Intel's PEBS or AMD's IBS. Exposing
> the feature to a guest requires that memory remains mapped at stage 2
> outside of userspace explicitely unmapping it, and guest_memfd, with the
> patch to ignore the MMU notifiers [1], has this property.  I wanted to
> expand the functionality of guest_memfd to support migration of virtual
> machines when that arm64 feature is exposed to guests.

Can you please expand a bit on how you actually expect dirty tracking to
work with SPE? Taking write permission faults seem to be at odds with
"thou shalt not fault".

Seems to me like you'd need hardware dirty state and the "noabort"
flavor of BBML2 to actually get things down to page mappings. Oh, and an
SPE implementation that actually respects write permissions... Is there
even an implementation out there where the stars align?

Fixing rotten architecture would be a more appropriate starting point :-/

Thanks,
Oliver
