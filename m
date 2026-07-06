Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21C15221546;
	Mon,  6 Jul 2026 14:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783346412; cv=none; b=NTwyt8V1xvxF2bMm5YCrDD887IaEFUq4pf14CSBYke56/ZIFWSXaR7cvCMsYyzfTt2VITjI1gGiFIarQ7N4htXQAqDDVbHWlt941KcUeCLwY2NUym4Pcrix6Y+EUzYiK/TrTo8fwXLjQT3tr6dPiFfqH9nUGqSViGAxLXAVETHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783346412; c=relaxed/simple;
	bh=0IHjigNQVuWH8FJItunSiwUT7hqvFU6sp0qDNhFrMMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=mjc6ZprZkS8cYrJPIPgiBAynJ/KUgcqgn0KD4H5/u41PgbQQM3wAsP5855HA6L2rvZYWaNS7i1IKlR+tj0YyFMdLhMXQwGbT2j4AOxBgwuHLaezUnbNIvoQRD+s//VmZVIWAN1dJwsiGcUw2e7EZlQaUsjx+Db2+GwVWIS5WQ+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KXNZZZH/; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KXNZZZH/"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 30B082BCB;
	Mon,  6 Jul 2026 07:00:06 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F4783F7B4;
	Mon,  6 Jul 2026 07:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783346410; bh=0IHjigNQVuWH8FJItunSiwUT7hqvFU6sp0qDNhFrMMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KXNZZZH/ijAkS5T+1ucBprA8Ax42iKrV0F3y/YbtiYI4SxeDpGDyTvZy8GyMokYy6
	 d/MAYS4WTruCHJBSA4TmsCHqsbWv/n1I3ywVAV0rcJAw3PtX00432h+bde7Nm28kgS
	 XskbjS2TEEUh+nT/ybneP66UWgRRduKgIAmeqvXY=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	sashiko-reviews@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v2 02/13] KVM: arm64: Enable eager hugepage splitting if HDBSS is available
Date: Mon,  6 Jul 2026 15:00:07 +0100
Message-ID: <aku05wJ9WQcpIh4n@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <akTv39bQdbxFbzhk@LeoBrasDK>
References: <20260629111820.1873540-1-leo.bras@arm.com> <20260629111820.1873540-3-leo.bras@arm.com> <20260629113645.BE6801F000E9@smtp.kernel.org> <akKFlzAdB43lRpi1@LeoBrasDK> <akKmHqRaZEUjN3zY@kernel.org> <akO9iHJmKN7MzTjM@LeoBrasDK> <akPkVASjWWYQpkx1@kernel.org> <akP4ZDjZIu2_CfVF@LeoBrasDK> <akQONWoRRZXu1-56@kernel.org> <akTv39bQdbxFbzhk@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jul 01, 2026 at 11:45:52AM +0100, Leonardo Bras wrote:
> On Tue, Jun 30, 2026 at 11:43:01AM -0700, Oliver Upton wrote:
> > On Tue, Jun 30, 2026 at 06:09:56PM +0100, Leonardo Bras wrote:
> > > On Tue, Jun 30, 2026 at 08:44:20AM -0700, Oliver Upton wrote:
> > > > On Tue, Jun 30, 2026 at 01:58:48PM +0100, Leonardo Bras wrote:
> > > > > On Mon, Jun 29, 2026 at 10:06:38AM -0700, Oliver Upton wrote:
> > > > > > > But this raises a topic I would like to understand:
> > > > > > > - Do we actually need this to be a block_size to assure correctness? or is 
> > > > > > >   it just about efficiency?
> > > > > > 
> > > > > > What value is there in having a chunk size larger than the largest
> > > > > > possible block mapping? The whole UAPI is deliberately tied up with page
> > > > > > table geometry.
> > > > > 
> > > > > Not larger, possibly smallerv My concern was the difference in pages to 
> > > > > split between 4k, 16k and 64k.
> > > > 
> > > > Ok, well in any case the upper bound is going to be the largest possible
> > > > block mapping for a given page granule.
> > > >
> > > 
> > > Sure, we can do this.
> > 
> > I'm describing the UAPI behavior of what we already have. Please do not
> > change anything and continue to leave userspace in charge of eager
> > splitting / chunk size.
> > 
> > > > > > 
> > > > > > Overall, I'm not buying the argument for changing the behavior of
> > > > > > KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE. There are very good reasons for
> > > > > > *not* eagerly splitting the entire address space, especially if you know
> > > > > > the working set of the VM is small.
> > > > > > 
> > > > > > You can still use HDBSS without eagerly splitting, so long as block
> > > > > > mappings are {DBM, S2AP_W} = {0, 0} and leaf mappings (which have
> > > > > > a writable PFN) are {1, 0}.
> > > > > > 
> > > > > 
> > > > > Block mappings being read-only, and leaf mappings being writable-clean, 
> > > > > then? Could you please ellaborate on why does not it need eager-split?
> > > > 
> > > > Read-only translations will continue to generate permission faults
> > > > whereas writable-clean descriptors can be updated by hardware. You get
> > > > the opportunity to split a block mapping lazily while preserving
> > > > hardware dirty tracking for page mappings.
> > > > 
> > > 
> > > So you suggest we only enable DBM bit after we split the block, that will 
> > > happen only after a block is dirtied for the first time after dirty-log 
> > > starts? 
> > 
> > If the VMM wants to do lazy splitting, yes. Otherwise this would happen
> > as part of eager page splitting for block mappings that are known to be
> > writable.
> > 
> > > > The approach I think we may need is:
> > > > 
> > > >  - Use a software bit in the PTE to stash whether or not a PFN is
> > > >    'software-writable' when constructing the stage-2. By this I mean
> > > >    we've already faulted it in for write from the primary MMU.
> > > > 
> > > >  - At the time of write protection, reap the hardware-writable state
> > > >    from all PTEs but preserve the software-writable bit.
> > > > 
> > > >  - Whenever splitting a block mapping, set the DBM bit in the page-level
> > > >    PTEs if the block was software-writable and HDBSS is present.
> > > > 
> > > > That way you'd have sufficient metadata in the PTE to safely set DBM.
> > > 
> > > I remember that, for some reason I can't recall, it would not be great to 
> > > set DBM during dirty-log start, and instead we should have it since VM 
> > > creation. Maybe it had to do with part of the pagetable using the old 
> > > encoding (no DBM), and the other part using the new one.
> > > 
> > > IIRC, only blocks that are backed by writable memory (S1) were supposed to 
> > > receive the DBM bit. We could use that info for deciding what to split, 
> > > then.
> > 
> > That's why I'm saying to use a software bit. We can't leave DBM=1 on
> > block mappings and set VTCR_EL2.HD=1 for obvious reasons.
> >
> 
> I am failing to see the reason for above.
> 
> IIUC, one option would be to:
> - When constructing S2
>   - Set DBM on every writable block, put them in writable-clean
>   - Enable VTCR_EL2.HD=1 (HAFDBS will update dirty-state in HW)
> - When dirty-logging starts
>   - Set VTCR_EL2.HDBSS=1 (any new dirtying gets logged to HDBSS)
>     - On every vcpu
>   - Write-protect everything (with HACDBS possibly)
>   - Split everything

(everything -> every block that have DBM=1) 

> 
> What am I missing?
> (above case is considering manual protect = off, but the same idea goes 
> for the manual_protect_and_init_set, but cleaning is on-demand)
>  

IIUC, what we get from your software write bit suggestion is to 
avoid doing the splitting if we know the page will not be written to, which 
makes sense.
Using the DBM bit as suggested above should have the same effect.

> > > Another option would be to split when we are collecting a dirty-entry from 
> > > HDBSS, but for live migration that would mean we have to transfer the whole 
> > > block (possibly a large LEVEL1 block), because we have no idea which part 
> > > of it got dirty.
> > 
> > We need to do dirty tracking at page granularity. The only scenario
> > where we have writable block mappings while dirty logging is enabled on
> > a memslot is if the VMM enabled KVM_DIRTY_LOG_INITIALLY_SET.
> 
> Agree
> 
> Thanks!
> Leo

