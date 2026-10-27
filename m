Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793101592;
	b=jKLDSWsjKOGvv/Tk3ekzm+vj8cl5xg5uL+v0eZp1YwGwYnxySL89RaCTP/3tCcd1MMGh
	 SQk26QmkjtAklAOp3IQgXg7nlDzrM/R0KjgUIqcxlFUo57V9G4XC22VEPbdvFFOjVNOK3
	 6+vwr+DmcvOzUaRAnDxcTijhBHmVecIVZt26z21eRdt4kbfLlPKsU9nuIkn5fq4z+4Aq2
	 NSuAbuk4Ov/0lrPh7xLBUHe+8IB0z5iJMOd2WeRaXkeRby0gMI/3UeqILMnofIE7S9svu
	 AhzNT52wUt/iXcIz3b+x2+ka5OfpN1OZWGkt5BFXUgJ7WgAGMAGNiJmg6hz1zBEimDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793101592;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=6fRga4PLyhDvRmvdApHZbO2HfBP0tzzKD/rmKO+880Q=;
	b=3ZptGzLOLCaBj4dqs7b/ES4Dm3ecCRapG7JB/9TMUn4BR+Ai5vrtLF2F49uMSAzWc5Pp
	 zkh5SbW2fRYubQu850gGFt6yCnLiiFB0dWs+I4MLXigaYqDO156Xlvoj0Ki9W5mT+SdGX
	 dnXd9v41ZQ2q+bWu2ZzzTUdG/8ESzIiCW1ZQis8Kiz3mh4U9miCQs0vBYcBMP3Yn3zRIR
	 yJ95BK+vvKcTkEQ+WrT4FrWRfIGZuQlUzVq8qCVcAfffHqk/juyttt3nxrTXUGFFhOY5E
	 H75z0o2tiPyZovUg80SxpM+zSIPFaHCZGjN1X9T4mNsGsvv2fN4+VdTROb1f7H/yhaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=l2ojKu3I;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E63FF606A7DA
	for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 11:46:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E63FF606A7DA
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=l2ojKu3I
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E5AF815A1;
	Tue, 27 Oct 2026 04:46:26 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EA94F3F59E;
	Tue, 27 Oct 2026 04:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793101590; bh=aQvS8xrI1rrJ9Ub2g0brfCcZrqaYMf0KkHjzaD4o2l4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l2ojKu3IKqobyHKB3LWMy3WiBjkW12rVYJUpa1k/psGeIhNTfHyav5r2NPSl/+/gl
	 A+NfM4qPgmjBtML5qis6lFJRMSoN/YfDBbY1m4Nh3/mQVFrxTZLhmTO9IaCpYyABAn
	 n6+ccYnLMvahZSsY8PmmJIE+l8vaJnRCogV8Gn4s=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	liuyonglong <liuyonglong@huawei.com>,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 5/5] KVM: arm64: Enable HAFDBS for guests not on migration
Date: Tue, 27 Oct 2026 11:46:25 +0000
Message-ID: <auCPEQmnFwWldTaM@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <8eaaba87-7881-49c4-a76a-51dec2f29ffc@huawei.com>
References: <20260901171558.2674031-1-leo.bras@arm.com> <20260901171558.2674031-6-leo.bras@arm.com> <aqneWnlsdpocLIl6@kernel.org> <aqqhDs3NyjtkZzXK@LeoBrasDK> <aqsl1_IqnV2r8kUL@kernel.org> <aqvt2gnlBZeNsaf4@LeoBrasDK> <as-mH36YSMxAosND@LeoBrasDK> <3e464bef-8dfe-44a3-afea-3c276ae87cd8@huawei.com> <attMtUqxNsuPooix@LeoBrasDK> <8eaaba87-7881-49c4-a76a-51dec2f29ffc@huawei.com>
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
Content-Transfer-Encoding: 8bit

On Tue, Oct 27, 2026 at 10:02:55AM +0800, Tian Zheng wrote:
> 
> 
> On 10/23/2026 8:01 PM, Leonardo Bras wrote:
> > On Fri, Oct 23, 2026 at 03:23:04PM +0800, Tian Zheng wrote:
> > > 
> > > 
> > > On 10/14/2026 11:56 PM, Leonardo Bras wrote:
> > > > On Thu, Sep 17, 2026 at 02:40:42PM +0100, Leonardo Bras wrote:
> > > > > On Wed, Sep 16, 2026 at 04:27:19PM -0700, Oliver Upton wrote:
> > > > > > On Wed, Sep 16, 2026 at 03:00:46PM +0100, Leonardo Bras wrote:
> > > > > > > On Tue, Sep 15, 2026 at 05:10:02PM -0700, Oliver Upton wrote:
> > > > > > > > Hi,
> > > > > > > > 
> > > > > > > > On Tue, Sep 01, 2026 at 06:15:56PM +0100, Leonardo Bras wrote:
> > > > > > > > > When dirty-logging is disabled, even non-write faults make a page dirty,
> > > > > > > > > which avoids a second fault when the page is actually written to.
> > > > > > > > > 
> > > > > > > > > On dirty-logging enable, this approach causes all (writable) pages on the
> > > > > > > > > memslot to be marked clean, even if they were not written to, which can
> > > > > > > > > take a lot of time, while holding the MMU lock, doing atomic writes to
> > > > > > > > > PTEs.
> > > > > > > > 
> > > > > > > > Do you have any performance numbers for this? Enabling HAFDBS seems a
> > > > > > > > bit involved to avoid some stores on the first pass.
> > > > > > > 
> > > > > > > Not yet, but if the idea does not look too crazy I can find hardware and
> > > > > > > collect some data :)
> > > > > > 
> > > > > > TBH this looks like a micro-optimization so I'm not expecting the
> > > > > > performance gains to justify the behavior change.
> > > > > > 
> > > > > 
> > > > > Okay then, I will get a machine to figure the performance gains :)
> > > > 
> > > > Got the performance numbers here.
> > > > I tested both the case where all PTEs are dirty, and the case that 50% of
> > > > the PTEs are dirty.
> > > > 
> > > > For that test, actually patch #5 could make kvm_pgtable_stage2_wrprotect()
> > > > slower, which is counter-intuitive, in all platforms tested:
> > > > 
> > > > When we walk the S2 pagetable to wrprotect, using the new walker, the
> > > > write to the PTE itself is so cheap* that the cost of the branch
> > > > misprediction (write PTE or not) for the 50/50 case is significantly higher
> > > > than the cost of the 50% extra writes, which makes the 50/50 up to 60%
> > > > slower than the 100% dirty case. It is still slower in the '25% dirty' as
> > > > well, and starts to get even at '10% dirty'.
> > > > 
> > > > * (non-atomic, everything is in order, walker is small, cpu will probably
> > > > bundle it all in a single cacheline write)
> > > > 
> > > > Since the idea of patch #5 was to reduce PTE writes in the first wrprotect
> > > > walk, it becomes faster only if only a small portion (<10%) of the VM was
> > > > write-faulted while the remaining was read-faulted, which seems to be a
> > > > really reduced audience.
> > > > 
> > > > Since this comes with increased complexity, and also carry costs of
> > > > having HAFDBS itself enabled outside dirty-tracking, I don't think it's a
> > > > good idea to further pursue patch #5. It's only value is that it served as
> > > > a base for HDBSS implementation.
> > > > 
> > > > Thanks for reading!
> > > > Leo
> > > > 
> > > Hi Leo,
> > > 
> > > Thanks for running this, the numbers are really useful.
> > > 
> > > It means the hardware dirty mode (HD=1) should only be enabled while
> > > dirty logging is active with HDBSS support, and stays off otherwise.
> > 
> > Hi Tian,
> > 
> > Correct, it's actually counter-productive for it to stay on without HDBSS
> > before dirty-logging.
> > 
> > > 
> > > With HD only enabled during dirty logging, we also keep the DBM-based
> > > encoding for the HD=0 case. On systems that support FEAT_HAFDBS, DBM
> > > remains the write bit and S2AP[1] the dirty bit even with HD=0. This
> > > works because kvm_s2_fault_compute_prot() maps any writable page of a
> > > non-tracked memslot writable-dirty (WD), including on read faults:
> > > 
> > > ```c
> > > if (s2vi->map_writable) {
> > >          *prot |= KVM_PGTABLE_PROT_W;
> > > 
> > >          if (s2vi->device ||
> > >              !memslot_is_logging(s2fd->memslot) ||
> > >              kvm_is_write_fault(s2fd->vcpu))
> > >                  *prot |= KVM_PGTABLE_PROT_DIRTY;
> > > }
> > > ```
> > > 
> > > So there is no WC entry for hardware to promote, and HD is simply not
> > > needed outside dirty logging.
> > > 
> > > In the next HDBSS version, we'll only turn on HD=1 when dirty logging
> > > is active.
> > > 
> > 
> > Right!
> > I will also send a new version of the pre-patch (4 patches) for us to
> > discuss. The first 2 patches will change meaning a bit, but should still
> > work as they do today.
> > 
> > Thanks!
> > Leo
> > 
> Hi Leo,
> 
> OK, I've seen the new DBM RFC patchset. HDBSS v6 will be based on it.


Hi Tian, thanks for reading it, and for accepting it in your series!

Before rebasing, please wait for the ongoing discussion on it's 
correctness. Maybe I will have to send new versions before it can be used.

Thanks!
Leo
