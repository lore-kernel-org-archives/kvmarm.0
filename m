Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D2AF20E315
	for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 16:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750956124; cv=none; b=lyjZRc51yL4kY9O/jaga7Vc7CJM7HJtpp4DcZjl1sYIeE2xxE5Km7NQmzNlzyJ9x1lee+6ucJJLvrSBXW3dKlYWleIl1V2/AfdNwinbX8rnsuwv/FE12jGU/OutoEuOh+8qLbu4PvC5mvCWATGrFM7yS0vql7cOD7f8oVd1Z0No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750956124; c=relaxed/simple;
	bh=PVrnLNF3Fh0Lq6Rnr3e7tRA/OEuWKwmtG+Rwoc3RHis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JLo5wCbDUkOvK+xfxUS4EAzbf6qnrO6MGQIusj2ydyt7H0NqXLwRgmnpu96MEUY5fARCRzPlMK6XOYYYmq+Ci1RunLTi4bUgEEdGYmfaMkuqqgL4QdqWtuq4OFSCTvzq3PWq3PC+KTuw05kn9baRBwK7RNjvNycEoCRsQA9mo50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4C4361758;
	Thu, 26 Jun 2025 09:41:44 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 90A683F66E;
	Thu, 26 Jun 2025 09:41:57 -0700 (PDT)
Date: Thu, 26 Jun 2025 17:41:54 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com,
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
	david@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
	oliver.upton@linux.dev, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joey.gouly@arm.com, andre.przywara@arm.com,
	shahuang@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 05/13] scripts: Add 'kvmtool_params' to
 test definition
Message-ID: <aF14UnQYBR9Knv4-@raptor>
References: <20250625154813.27254-1-alexandru.elisei@arm.com>
 <20250625154813.27254-6-alexandru.elisei@arm.com>
 <20250626-536c0af00aa655d6e647df44@orel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250626-536c0af00aa655d6e647df44@orel>

Hi Drew,

On Thu, Jun 26, 2025 at 05:34:05PM +0200, Andrew Jones wrote:
> On Wed, Jun 25, 2025 at 04:48:05PM +0100, Alexandru Elisei wrote:
> > arm/arm64 supports running tests under kvmtool, but kvmtool's syntax for
> > running and configuring a virtual machine is different to qemu. To run
> > tests using the automated test infrastructure, add a new test parameter,
> > 'kvmtool_params'. The parameter serves the exact purpose as 'qemu_params',
> > but using kvmtool's syntax.
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> > 
> > Changes v3->v4:
> > 
> > * Added params_name in scripts/common.bash::for_each_unittest() to avoid
> > checking for $TARGET when deciding to parse kvmtool_params or
> > {qemu,extra}_params.
> > * Dropped factoring out parse_opts() in for_each_unittest().
> > 
> >  arm/unittests.cfg   | 24 ++++++++++++++++++++++++
> >  docs/unittests.txt  |  8 ++++++++
> >  scripts/common.bash | 11 +++++++----
> >  scripts/vmm.bash    | 16 ++++++++++++++++
> >  4 files changed, 55 insertions(+), 4 deletions(-)
[..]
> > +function vmm_unittest_params_name()
> > +{
> > +	# shellcheck disable=SC2155
> > +	local target=$(vmm_get_target)
> > +
> > +	case "$target" in
> > +	qemu)
> > +		echo "extra_params|qemu_params"
> > +		;;
> > +	*)
> > +		echo "$0 does not support '$target'"
> > +		exit 2
> > +		;;
> 
> It seems a bit odd that we've introduced kvmtool_params and applied it to
> arm in this patch, but we still don't support it. Not a huge deal, though.

Originally it was part of a huge patch that added everything in one go, it
was this patch and the next 6 or 7 patches combined. The feedback I got at
the time was to split it into more manageable chunks, which is very
understandable. So this is how I ended up with this patch, to make the
series easier to digest.

> 
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks for the review!

Alex
