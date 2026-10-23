Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792756926;
	b=I8ptjhSMg/ILgs/lRrqq/V+oMXV3nrGozpZnjEMrALTVfk64fyO2DKvgzzjQIObk6Wyl
	 XtFthJDOMqyLMmW0Iw0tb2rUqw5ucX1Gwok7wKT6OBiS4y3qmK1yU/uhvxpcnJ7yiePT9
	 +cjSrotZdfcb2Ppu8zf9F2a2D+iHbuIicxZswwbqQIHwAxCnkiwzFhlcmFNKhuQEuG7hB
	 /u60uX2BKuDSnS7JDgw2VnG4vg3fkiDzRzGt3gBwi62vFNCCDqY9c+5acGITemMxvPNR6
	 ngfg/2+KHRNqN/hdTiCb0iUgccXfVncKl/14n0NdTF7RTYWpatbSKh55alk9K7mfImA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792756926;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=jctLZMa3CFFn1fL9CJJAY0fHDymjjHzSukwmoA365k8=;
	b=N+vDkRznBKsFqEhTkZbGiB3+1EnFtyTVGSDQ3z/0/MHYhmoKmcJf7Jn/tJRkaRBp47d4
	 FwLm4py4js1u/XDdnFklITx9jpzZZSXxVmG6JgcNGaTQFh8SuxWLTMpF6Li6jhXLZ74eq
	 ow1CKDwI2+fc8P7iUPwTMtZesmOGP6hpkNq0dzFfwZ+BBunzFJFAmBx33j2vSErMBs+m4
	 UXbsR1d3wbx9p/Lk+CpMoxQH80UN5sQekakHRof5mNg2xqD64FHkMzaj7OkM8Ge+df5Z0
	 5Px22fUiSzCBUq6Fjjmi29fr9of6QeeMZ6kuPjSd+W4FTg9BKEvFT+1y27G3lOlCmPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=bxRS2WXI;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4354606A31A
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 12:02:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4354606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=bxRS2WXI
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF2001691;
	Fri, 23 Oct 2026 05:02:00 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 18F3F3F7B4;
	Fri, 23 Oct 2026 05:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792756924; bh=WhP+2ZARQeBOK940ZZV2hQ7dkuiCr9Al+UuwIs63AhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bxRS2WXIeECIQ2k5nigxQE0z5PLaNETAUfEr+noV/i/NkRlOpHb0Vp+CcZr7aNDlk
	 PqIv9v832Zymbd8retio17UCU2P2YlX8mZzjXQeJaNBtTGU9zSmCVpzGDPyKopTwlw
	 hMK699uINLjrdnaCD2KwH1mEgasSdWo23WeKGCek=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
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
Date: Fri, 23 Oct 2026 13:01:57 +0100
Message-ID: <attMtUqxNsuPooix@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <3e464bef-8dfe-44a3-afea-3c276ae87cd8@huawei.com>
References: <20260901171558.2674031-1-leo.bras@arm.com> <20260901171558.2674031-6-leo.bras@arm.com> <aqneWnlsdpocLIl6@kernel.org> <aqqhDs3NyjtkZzXK@LeoBrasDK> <aqsl1_IqnV2r8kUL@kernel.org> <aqvt2gnlBZeNsaf4@LeoBrasDK> <as-mH36YSMxAosND@LeoBrasDK> <3e464bef-8dfe-44a3-afea-3c276ae87cd8@huawei.com>
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

On Fri, Oct 23, 2026 at 03:23:04PM +0800, Tian Zheng wrote:
> 
> 
> On 10/14/2026 11:56 PM, Leonardo Bras wrote:
> > On Thu, Sep 17, 2026 at 02:40:42PM +0100, Leonardo Bras wrote:
> > > On Wed, Sep 16, 2026 at 04:27:19PM -0700, Oliver Upton wrote:
> > > > On Wed, Sep 16, 2026 at 03:00:46PM +0100, Leonardo Bras wrote:
> > > > > On Tue, Sep 15, 2026 at 05:10:02PM -0700, Oliver Upton wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > On Tue, Sep 01, 2026 at 06:15:56PM +0100, Leonardo Bras wrote:
> > > > > > > When dirty-logging is disabled, even non-write faults make a page dirty,
> > > > > > > which avoids a second fault when the page is actually written to.
> > > > > > > 
> > > > > > > On dirty-logging enable, this approach causes all (writable) pages on the
> > > > > > > memslot to be marked clean, even if they were not written to, which can
> > > > > > > take a lot of time, while holding the MMU lock, doing atomic writes to
> > > > > > > PTEs.
> > > > > > 
> > > > > > Do you have any performance numbers for this? Enabling HAFDBS seems a
> > > > > > bit involved to avoid some stores on the first pass.
> > > > > 
> > > > > Not yet, but if the idea does not look too crazy I can find hardware and
> > > > > collect some data :)
> > > > 
> > > > TBH this looks like a micro-optimization so I'm not expecting the
> > > > performance gains to justify the behavior change.
> > > > 
> > > 
> > > Okay then, I will get a machine to figure the performance gains :)
> > 
> > Got the performance numbers here.
> > I tested both the case where all PTEs are dirty, and the case that 50% of
> > the PTEs are dirty.
> > 
> > For that test, actually patch #5 could make kvm_pgtable_stage2_wrprotect()
> > slower, which is counter-intuitive, in all platforms tested:
> > 
> > When we walk the S2 pagetable to wrprotect, using the new walker, the
> > write to the PTE itself is so cheap* that the cost of the branch
> > misprediction (write PTE or not) for the 50/50 case is significantly higher
> > than the cost of the 50% extra writes, which makes the 50/50 up to 60%
> > slower than the 100% dirty case. It is still slower in the '25% dirty' as
> > well, and starts to get even at '10% dirty'.
> > 
> > * (non-atomic, everything is in order, walker is small, cpu will probably
> > bundle it all in a single cacheline write)
> > 
> > Since the idea of patch #5 was to reduce PTE writes in the first wrprotect
> > walk, it becomes faster only if only a small portion (<10%) of the VM was
> > write-faulted while the remaining was read-faulted, which seems to be a
> > really reduced audience.
> > 
> > Since this comes with increased complexity, and also carry costs of
> > having HAFDBS itself enabled outside dirty-tracking, I don't think it's a
> > good idea to further pursue patch #5. It's only value is that it served as
> > a base for HDBSS implementation.
> > 
> > Thanks for reading!
> > Leo
> > 
> Hi Leo,
> 
> Thanks for running this, the numbers are really useful.
> 
> It means the hardware dirty mode (HD=1) should only be enabled while
> dirty logging is active with HDBSS support, and stays off otherwise.

Hi Tian,

Correct, it's actually counter-productive for it to stay on without HDBSS 
before dirty-logging.

> 
> With HD only enabled during dirty logging, we also keep the DBM-based
> encoding for the HD=0 case. On systems that support FEAT_HAFDBS, DBM
> remains the write bit and S2AP[1] the dirty bit even with HD=0. This
> works because kvm_s2_fault_compute_prot() maps any writable page of a
> non-tracked memslot writable-dirty (WD), including on read faults:
> 
> ```c
> if (s2vi->map_writable) {
>         *prot |= KVM_PGTABLE_PROT_W;
> 
>         if (s2vi->device ||
>             !memslot_is_logging(s2fd->memslot) ||
>             kvm_is_write_fault(s2fd->vcpu))
>                 *prot |= KVM_PGTABLE_PROT_DIRTY;
> }
> ```
> 
> So there is no WC entry for hardware to promote, and HD is simply not
> needed outside dirty logging.
> 
> In the next HDBSS version, we'll only turn on HD=1 when dirty logging
> is active.
> 

Right! 
I will also send a new version of the pre-patch (4 patches) for us to 
discuss. The first 2 patches will change meaning a bit, but should still 
work as they do today.

Thanks!
Leo
