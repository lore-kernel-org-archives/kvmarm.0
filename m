Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F6BF43634B
	for <kvmarm@lists.linux.dev>; Tue,  7 Jul 2026 16:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783443535; cv=none; b=uuFnie3CirEE9zkPvS3A3UnrgB5a5SmhCh5m1cpciPxfmKeTu61VcKSZfVicVsfQulL2LpM7DZ32mX4+3RrB41TaiNqIOiSPiNRH2fl159YfWyWXOeY90TYd5zOiURtM6oIbl8WUOpA9feLdRHOjsbqTilVRwUllGce95kMKUCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783443535; c=relaxed/simple;
	bh=TOgYj5FZmDTqeFNBMSEMqRwvGMSyqgNulD31bewyFas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AnKiNsVhylk+uBt+RSbk4c5DEqNG0R0ByqN9HuAr47ppAYzF04OAtPaKGS58H6sujH2YyNqqoL5d6FxAgxzr1WHqdCL3TYH+y2oV/FsOGtC4HomomB6OLNcYFOYgR5sKyIhxqe2Kg8eN8HYPpuJqJFxDcS9Dfe5qG92jiG+BdkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qDnPSKMX; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qDnPSKMX"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 38C881595;
	Tue,  7 Jul 2026 09:58:49 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B1B283F7B4;
	Tue,  7 Jul 2026 09:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783443533; bh=TOgYj5FZmDTqeFNBMSEMqRwvGMSyqgNulD31bewyFas=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qDnPSKMXMBWbehXuepC1F6L3ke/tSK7hxcPEZ0meUJ+6xmGFl3GZVE6mMMq+luYdD
	 8zIH24dQZY+2siwB/tY4ZevQ0toknhOllwVTHcPsQp79/0JuqTZ8r78j+Ajrgg49RA
	 UOKD6n4ng/Z9QFdYT6xQ274xgz5ql+ciUFeKFbKM=
Date: Tue, 7 Jul 2026 17:58:49 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, david.hildenbrand@arm.com,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	fuad.tabba@linux.dev, mark.rutland@arm.com
Subject: Re: [RFC PATCH 0/3] KVM: Dirty page logging for guest_memfd-only
 memslots
Message-ID: <ak0wSQ1133O7B96D@raptor>
References: <20260702142912.6395-1-alexandru.elisei@arm.com>
 <akxOrMnlNga-vtQv@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akxOrMnlNga-vtQv@google.com>

Hi Sean,

On Mon, Jul 06, 2026 at 05:56:12PM -0700, Sean Christopherson wrote:
> On Thu, Jul 02, 2026, Alexandru Elisei wrote:
> > The memory represented by guest_memfd-only memslots
> > (kvm_memslot_is_gmem_only() is true) is shared with userspace, which can
> > freely mmap it and access it. The only thing that is preventing dirty page
> > logging for such memslots is that KVM doesn't allow slots backed by
> > guest_memfd to have their flags changed; they can only be created and
> > deleted.
> 
> Please (publicly) document *why*  you want to add dirty-logging support.  It's
> all but impossible to review new uAPI without knowing the use case.

Of course, my mistake, I was so deep in this that I didn't realise that
there might be different perspectives.

My thinking was that since guest_memfd created with GUEST_MEMFD_FLAG_MMAP +
GUEST_MEMFD_FLAG_INIT_SHARED is extremely similar from a userspace point of
view to using an anonymous file (created with memfd_create()), that
supporting dirty page logging and migration would be a natural next step
and would expand the usefulness of guest_memfd. It has nothing to do with
confidential compute.

As to why I'm working on it now, it's because of an arm64 feature that
requires that memory remains mapped at stage 2, called Statistical
Profiling Extension (SPE), similar to Intel's PEBS or AMD's IBS. Exposing
the feature to a guest requires that memory remains mapped at stage 2
outside of userspace explicitely unmapping it, and guest_memfd, with the
patch to ignore the MMU notifiers [1], has this property.  I wanted to
expand the functionality of guest_memfd to support migration of virtual
machines when that arm64 feature is exposed to guests.

[1] https://lore.kernel.org/kvmarm/20260625130902.258331-1-alexandru.elisei@arm.com/

Thanks,
Alex
