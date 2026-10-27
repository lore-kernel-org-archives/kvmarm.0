Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793104581;
	b=SIwsD3a+ABg6FbMlFdpIGHJvsbqTyhaAXSB76x18K6RDA40Tl2E14XdmkuyHNC3stDaf
	 NcGt7NFgQ/z5QuAAhRCqHplb9rnYkHylm2nl3EYOBrzVnljojMywwafLBJogbw2Ke66oC
	 k6ohyoGP9JsgV1KJpW/mQUAy3VZzgKXCx6DaNXtqD/ecCv5EjBewY4JOseAzKR9XWPTmZ
	 iw0Levh6JV43mA8B92AxaRvLZctOsG6jCYiV4aqx8DuRtyvKYRCYsd6hVZ6hdaUoegj0i
	 ZTz2x63qLHE0+rsrYHDD4BSX7JHRzpbL1C9hhWqRGymz5p7QQV8zWeZ+De78QCzcb+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793104581;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=6U6ukWtJS8Ibwot9neAzAfooQ69RGsnjUX/d7S/uqMM=;
	b=EnuAHeVodX89AALxHtD8cmUnmp83QM9KaEW50yWlBLpQvqe05NbMA9R/t1iNpawBzZsl
	 IZXkQZ3yaDL/++gk8yLWjYlE+mhNf19yVMLDBwgJ9PfQdVXGIGio7lr+WYSfC/speHpEt
	 0Uvqvo7v2e56cZUMI2CDkJSRO97a2pUPSVve4GmNJUACkoK0sc1Quu3JfPgYmBNxTAalW
	 SA0N1JTo5XZGAw758u3re1wLjLJAggoDq14f4Xmno/XZETVd2Rm+X3E+I/Z8so0mJyu+U
	 f4AS3IMoO2UiC+qEsGbf1/PI4jaq+eTk4TimOF+KzI1E5YFVvWswcYcdzyW8POoOj/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="S8vG/Rdf";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8D9B606A323
	for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 12:36:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8D9B606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=S8vG/Rdf
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 08D2A15A1;
	Tue, 27 Oct 2026 05:36:16 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9D9063F7B4;
	Tue, 27 Oct 2026 05:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793104579; bh=HF9mtcjcyXbLfac05vPyf9/ddhhqUEYPjy2TFsm4o6k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S8vG/RdfKAp3mrTU24tsu1+AvwXvDJXh/3pGzvtcrDobvdvAFaasDGuudwYnXYpU9
	 oh+CiuR4qh3TXwjU1uPdtdAVK1rB02wyOTJ1mWXqismrYaSKGMnTX8DSFgefBBZ4cP
	 BmbTu8nTjAt76sVM8SE9Ixb2QC0ThhEK8P/H7kjs=
Date: Tue, 27 Oct 2026 12:36:08 +0000
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>, 
	Leo Soares Passos <Leo.Bras@arm.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Replace memslot_is_logging() with
 kvm_slot_dirty_track_enabled()
Message-ID: <3gewc54nkhrdyof75ijpyv3f2gbd7isc7sx2foqdk5yo2bjpgx@hoxbbo3n3ayn>
References: <20260605153248.2412064-1-weilin.chang@arm.com>
 <20260605153248.2412064-2-weilin.chang@arm.com>
 <CA+EHjTwK092o8YZjV0vzBDLSY=cesOvhqj39zDd1MF-toOVTwA@mail.gmail.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTwK092o8YZjV0vzBDLSY=cesOvhqj39zDd1MF-toOVTwA@mail.gmail.com>

Hi Fuad,

Sorry for the late reply, I was focusing on something else.

On Wed, Oct 14, 2026 at 02:18:29PM +0100, Fuad Tabba wrote:
> Hi Wei-Lin,
> 
> On Fri, 05 Jun 2026 16:32:47 +0100, Wei-Lin Chang <weilin.chang@arm.com> wrote:
> > When checking whether a memslot has dirty logging enabled, the
> > KVM_MEM_LOG_DIRTY_PAGES flag is the source of truth. Previously we were
> > using memslot_is_logging() which only tests dirty bitmap and did not
> > consider dirty ring. This was not detected because
> > KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP was introduced together with KVM
> > arm64 dirty ring, and users need to enable it to ensure dirty
> > information is not lost for the case of VGIC LPI/ITS table changes.
> 
> I ran into the same bug while testing the arm64 KVM_PRE_FAULT_MEMORY
> series, and then found that you'd already fixed it.
> 
> It might be worth mentioning the impact in the commit message: with
> the ring and no bitmap, a logged memslot still gets block mappings, so
> guest writes to most of a block are never logged and a migration can
> copy stale memory. That would also make the case for a Cc: stable.

That makes sense, thanks for the suggestion!

> 
> > Note that memslot_is_logging() also treats a memslot as not logging if
> > KVM_MEM_READONLY is set, hence a memslot with both dirty logging and
> > read only would be seen as not logging for memslot_is_logging(), but
> > logging for kvm_slot_dirty_track_enabled(). This allows a read only
> > mapping of size > PAGE_SIZE to be built when memslot_is_logging() is
> > used, leading to a better read performance compared to
> > kvm_slot_dirty_track_enabled(). However memslots that have both
> > KVM_MEM_LOG_DIRTY_PAGES and KVM_MEM_READONLY set do not really make
> > sense as dirty logging is essentially nop for a read only memslot, so
> > this shouldn't affect real workloads much.
> 
> FWIW, I'd go with Leo's suggestion of keeping the KVM_MEM_READONLY
> check, so those memslots keep their block mappings.

Okay, then I'll not remove memslot_is_logging(), just use
kvm_slot_dirty_track_enabled() within it. This makes it even easier to
rebase & backport.

> 
> [...]
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> [...]
> > @@ -2084,7 +2079,7 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
> >          * and a write fault needs to collapse a block entry into a table.
> >          */
> >         memcache = get_mmu_memcache(s2fd->vcpu);
> > -       if (!perm_fault || (memslot_is_logging(s2fd->memslot) &&
> > +       if (!perm_fault || (kvm_slot_dirty_track_enabled(s2fd->memslot) &&
> >                             kvm_is_write_fault(s2fd->vcpu))) {
> 
> FYI, this no longer applies to kvmarm/fixes or kvmarm/next, where the
> condition now ends in memslot_is_logging() ||
> is_protected_kvm_enabled().

Ack.

> 
> I tested the series on v7.3-rc7 (with that conflict resolved) in QEMU,
> with dirty_log_test changed to back the memslot with THP. In ring-only
> mode it fails on the first iteration without the series and passes
> with it. I'll send the test change later.
> 
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Thanks for the tags!
Wei-Lin Chang

> 
> Cheers,
> /fuad
