Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF8AC383992
	for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 11:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781090305; cv=none; b=fnUakli8Zm8Le70iw6vATan5vIxjRV+WksiR+HAtTGlAK2aPGPhK+sE6KHIypkbpLnbElhq/nSQG3UYnb4sG+6DuTd0M9lT/3ZFKUXPwYKt/GSoFwsWxR9Y1iOC2+OxZMJJvEqJkfgBPjD9LhYEyOrRUV3tFcsEo80bwCimfuWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781090305; c=relaxed/simple;
	bh=AzG4LvHEextF6DXdNd0eKaKqq3FmpNFo5UAqM/SdSFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k/TE2kGoZRjhOk+9GBLwEKSolaW2W914yUhBAZbKcaQP+iOJCD6JCUAUEfmwwBliM6nzOcel4zsjmnEA4oxRfmIOJWdqBp3t2Dj7/5+K/kHDdPYmmpOlbmusCfWI0m3DbdBYDjaplS9K4iBjQ1g3k8hG+MgPXRGn8oUnEfvqphk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fT3yf83Z; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fT3yf83Z"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 185DA2574;
	Wed, 10 Jun 2026 04:18:17 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 262AA3FD88;
	Wed, 10 Jun 2026 04:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781090301; bh=AzG4LvHEextF6DXdNd0eKaKqq3FmpNFo5UAqM/SdSFE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fT3yf83Zy8Vkni+513U1IbyE2eD1a4dVhI6H5GXA/oPmEEkPJh5q2rXudN9QPJE2A
	 F9l1QSbVoyDQxVZ/j7HzDpM7YCDvvwRkFD1SR9AVzl1IZXTeZQmqQ4SwVAvcAyCNeD
	 IOChS/nCzHaCUdrlAENH2EfJXHrS8DKpgE1EgIUk=
Date: Wed, 10 Jun 2026 12:18:09 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>, 
	Leonardo Bras <leo.bras@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Replace memslot_is_logging() with
 kvm_slot_dirty_track_enabled()
Message-ID: <qjktov4btc6zv2ctldh4j5wvolruxhv744wwvgrnbkkpsjth25@6s7il6rt2ypf>
References: <20260605153248.2412064-1-weilin.chang@arm.com>
 <20260605153248.2412064-2-weilin.chang@arm.com>
 <aibmALTEbc7gzSZj@devkitleo>
 <aig_xcTZKzux0OaS@devkitleo>
 <aiky6H02ArbFpwGZ@raptor>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiky6H02ArbFpwGZ@raptor>

On Wed, Jun 10, 2026 at 10:48:24AM +0100, Alexandru Elisei wrote:
> Hi Leo,
> 
> Just FYI, write faults on read-only memslots are handled as MMIO accesses in
> kvm_handle_guest_abort() (gfn_to_hva_memslot_prot() sets @writable to false).

Thanks! I also missed this...

With this it looks like the behavior of the condition at the third callsite
will be the same regardless of using memslot_is_logging() or
kvm_slot_dirty_track_enabled().

For the second, s2vi->map_writable can only be true if the memslot is not RO.
So no behavior changes there, in terms of the extra RO check in
memslot_is_logging().

Thanks,
Wei-Lin Chang

> 
> Thanks,
> Alex
> 
> On Tue, Jun 09, 2026 at 05:31:01PM +0100, Leonardo Bras wrote:
> > On Mon, Jun 08, 2026 at 04:55:45PM +0100, Leonardo Bras wrote:
> > > Hi Wei Lin,
> > > 
> > > On Fri, Jun 05, 2026 at 04:32:47PM +0100, Wei-Lin Chang wrote:
> > > > When checking whether a memslot has dirty logging enabled, the
> > > > KVM_MEM_LOG_DIRTY_PAGES flag is the source of truth. Previously we were
> > > > using memslot_is_logging() which only tests dirty bitmap and did not
> > > > consider dirty ring. This was not detected because
> > > > KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP was introduced together with KVM
> > > > arm64 dirty ring, and users need to enable it to ensure dirty
> > > > information is not lost for the case of VGIC LPI/ITS table changes.
> > > > 
> > > > Fix this by using kvm_slot_dirty_track_enabled() instead which checks
> > > > KVM_MEM_LOG_DIRTY_PAGES.
> > > > 
> > > > Note that memslot_is_logging() also treats a memslot as not logging if
> > > > KVM_MEM_READONLY is set, hence a memslot with both dirty logging and
> > > > read only would be seen as not logging for memslot_is_logging(), but
> > > > logging for kvm_slot_dirty_track_enabled(). This allows a read only
> > > > mapping of size > PAGE_SIZE to be built when memslot_is_logging() is
> > > > used, leading to a better read performance compared to
> > > > kvm_slot_dirty_track_enabled(). However memslots that have both
> > > > KVM_MEM_LOG_DIRTY_PAGES and KVM_MEM_READONLY set do not really make
> > > > sense as dirty logging is essentially nop for a read only memslot, so
> > > > this shouldn't affect real workloads much.
> > > 
> > > 
> > > It worries me a bit that we are ignoring the KVM_MEM_READONLY flag... 
> > > I have not yet gone through the whole s2_mmu code but IIUC we can have 
> > > scenarios on which a memslot can be read-only and have dirty-logging 
> > > enabled. 
> > 
> > 
> > > If a memslot is not faulted yet, IIUC it is marked as read-only 
> > > (so it can be mapped on write fault), and we can have dirty-logging 
> > > enabled for it as well (as the VMM has no idea). 
> > > 
> > 
> > Ignore above bit, I confused memslot with block/page entry.
> > 
> > Looking a bit more, my viewpoint is that:
> > - Due to dirty_ring, checking memslot.dirty_bitmap should be done only to 
> >   detect the existence of a dirty_bitmap, not the migration process.
> > - This changes how detection works, in regardas to read-only blocks:
> >   memslot_is_logging() -> Checks dirty-bitmap + read-only memslot
> >   kvm_slot_dirty_track_enabled()  -> Checks only memslot flag
> > - As a simpler change, we could have:
> > 
> > ~~~
> > -   return memslot->dirty_bitmap && !(memslot->flags & KVM_MEM_READONLY);
> > +   return kvm_slot_dirty_track_enabled(memslot) && !(memslot->flags & KVM_MEM_READONLY);
> > ~~~
> > 
> > Both are cheking memslot->flags, so it will be probably optimized by the 
> > compiler as:
> > 
> > ~~~
> > return memslot->flags & 3 == 1
> > ~~~
> > 
> > My main worry was that in the curent patch we are changing the behavior 
> > on skipping read-only memslots. So going through the users, we can see:
> > 
> > > > 
> > > > Fixes: 9cb1096f8590 ("KVM: arm64: Enable ring-based dirty memory tracking")
> > > > Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> > > > ---
> > > > It took me a long investigation to acquire the context needed to
> > > > understand this change, however the reason for this problem not being
> > > > detected is an educated guess. Please let me know if this is wrong or
> > > > if there are other issues, thanks!
> > > > 
> > > >  arch/arm64/kvm/mmu.c | 11 +++--------
> > > >  1 file changed, 3 insertions(+), 8 deletions(-)
> > > > 
> > > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > > index 4da9281312eb..06c46124d3e7 100644
> > > > --- a/arch/arm64/kvm/mmu.c
> > > > +++ b/arch/arm64/kvm/mmu.c
> > > > @@ -161,11 +161,6 @@ static int kvm_mmu_split_huge_pages(struct kvm *kvm, phys_addr_t addr,
> > > >  	return ret;
> > > >  }
> > > >  
> > > > -static bool memslot_is_logging(struct kvm_memory_slot *memslot)
> > > > -{
> > > > -	return memslot->dirty_bitmap && !(memslot->flags & KVM_MEM_READONLY);
> > > > -}
> > > > -
> > > >  /**
> > > >   * kvm_arch_flush_remote_tlbs() - flush all VM TLB entries for v7/8
> > > >   * @kvm:	pointer to kvm structure.
> > > > @@ -1748,7 +1743,7 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
> > > >  {
> > > >  	short vma_shift;
> > > >  
> > > > -	if (memslot_is_logging(s2fd->memslot)) {
> > > > +	if (kvm_slot_dirty_track_enabled(s2fd->memslot)) {
> > > >  		s2vi->max_map_size = PAGE_SIZE;
> > > >  		vma_shift = PAGE_SHIFT;
> > > >  	} else {
> > 
> > On the case dirty_track is enabled in a read-only slot, it will resolve to 
> > a smaller vma_size. The fault granule will be smaller here. This could be 
> > bad for performance, so maybe we could add a check for read-only block 
> > here:
> > 
> > ~~~
> > -   if (memslot_is_logging(s2fd->memslot)) {
> > +   if (kvm_slot_dirty_track_enabled(s2fd->memslot) &&
> > +       !memslot_is_readonly(s2fd->memslot) {
> > ~~~
> > 
> > 
> > > > @@ -1953,7 +1948,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
> > > >  	*prot = KVM_PGTABLE_PROT_R;
> > > >  
> > > >  	if (s2vi->map_writable && (s2vi->device ||
> > > > -				   !memslot_is_logging(s2fd->memslot) ||
> > > > +				   !kvm_slot_dirty_track_enabled(s2fd->memslot) ||
> > > >  				   kvm_is_write_fault(s2fd->vcpu)))
> > > >  		*prot |= KVM_PGTABLE_PROT_W;
> > > >
> > 
> > 
> > On the same scenario (dirty_track enabled on readonly memslot):
> > This one should be safe, as kvm_is_write_fault() will check if the memslot 
> > is readonly and return false in this case. But then, it will have to 
> > actually call kvm_is_write_fault(), as the previous version would not even 
> > call it in that scenario.
> > 
> > Not sure how would that impact perforformance, though.
> > 
> > > > @@ -2084,7 +2079,7 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
> > > >  	 * and a write fault needs to collapse a block entry into a table.
> > > >  	 */
> > > >  	memcache = get_mmu_memcache(s2fd->vcpu);
> > > > -	if (!perm_fault || (memslot_is_logging(s2fd->memslot) &&
> > > > +	if (!perm_fault || (kvm_slot_dirty_track_enabled(s2fd->memslot) &&
> > > >  			    kvm_is_write_fault(s2fd->vcpu))) {
> > > >  		ret = topup_mmu_memcache(s2fd->vcpu, memcache);
> > > >  		if (ret)
> > 
> > Same thing, if memslot is tracking and is readonly, topup_*() would be 
> > called with the new patch, but not with the old behavior. 
> > 
> > All of that depends on how the VMM uses dirty_tracking: does it enable for 
> > all memory, or only for memory that is writable?
> > 
> > I could not find anything that would prevent user from enabling 
> > dirty_tracking on read-only memslots, so we can either ignore this 
> > scenario, apply those patches and let those users carry the extra overhead, 
> > or do an extra test to make sure it's doing the same thing as before.
> > 
> > Thanks!
> > Leo
> > 
