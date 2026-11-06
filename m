Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793966691;
	b=eCWOiVVTDt6yCLgqi3k3ZpiJQVToMgrK8XElg+UIh8oUOi+krpgF8v9exDNk/e8lDFoY
	 2VYEpwI0QRu4/aleHARR2lCTp6sRmBXijvXm3pTMrwaAwuB8wL2ltGMgqxezu+T20Mreo
	 /A5Lb9Fm1elhw9iLms7pvLbxl2qdIo9VubyFLFEPHltuurmuWQRPBWYtv1SQf95xLjKIM
	 Tp6vfY56RdqU3XJdmBB32cMCaTbCZ1dHaGH7KcyoZgMDBZ2Ct0tIfuaqDtH83MdUq86or
	 hwuuL7YhNrw8U3Uh2NmPrYY9RjZp9fFMnrf6R8gJxNdQpfyNFUinBDhi2ND1WS87CqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793966691;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=ohw14vtNVpaw39MdfleV/FhLdxvIV9Kq8xUs5QaqRDg=;
	b=mS3zXxtBQPO7Od+zxWinWdm30iBXcjei+0Fsc4AVqZxqkpqCPAIATsfL6bUaYI79akGs
	 NoHX7FDUgp266dKIClD3JYiwZDKbLPZo4WLer7ZPHJTWgqKK0q4ZXcup9LUYCtKqAvcFW
	 1jsdXmmnmzocs+eSnrted4ZwJvCcJMQFHf8+QKE7xZxKAJYjPZf7gWVlcJ8jWnpteXyOf
	 hjuR2qaivQ4q32N6LpJ3g7fukAfJL2HJlxWtmgqooTo84GNyGKUyqahWhZPmvEQPx6neG
	 RVvX806kqDIgV8YzxlBnbf34yyfH031eEaDBULC5d56ZfjN5+ClbI237tMosMF5enaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ldB0NtAV;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC0DD606D81B
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 12:04:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC0DD606D81B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ldB0NtAV
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0AD421650;
	Fri,  6 Nov 2026 04:04:47 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 80A033F673;
	Fri,  6 Nov 2026 04:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793966690; bh=Zk/2kelxGIV5QGQC43f9+FkeyB8IVun3MQkt4kAhXew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ldB0NtAV2HVZnAg2jAEn+stYKx+gAkfesFtazHTN2zlnLvpRzjaG4ep0uDtF9IOBV
	 jjBom9QwOUlIrdLnEMGo3ZfaDpap1h8TCmN5qVfsjPNvk6U5DLKBj2ZYEaWPSFWvic
	 poo7mVDjHXiGApAzxgxtVbYj+omuROC9n/KaBclw=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	maz@kernel.org,
	oupton@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	corbet@lwn.net,
	pbonzini@redhat.com,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	yangjinqian1@huawei.com,
	caijian11@h-partners.com,
	liuyonglong@huawei.com,
	tangchengchang@huawei.com,
	yezhenyu2@huawei.com,
	yubihong@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	fuad.tabba@linux.dev,
	mark.rutland@arm.com,
	seanjc@google.com,
	rdunlap@infradead.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	skhan@linuxfoundation.org
Subject: Re: [PATCH v5 05/15] KVM: arm64: Harvest stage-2 dirty state into the host folio account
Date: Fri,  6 Nov 2026 12:04:29 +0000
Message-ID: <au3CTZBpfN0VtO3_@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <6e6fb626-d3d4-46f7-93ac-94e3d243eb69@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com> <20260929103655.85107-6-zhengtian10@huawei.com> <at-WceRKAVM2kEnI@LeoBrasDK> <009b13c6-f618-43fe-8a56-8519d31b239b@huawei.com> <auSMkdEhLI7k8QbV@LeoBrasDK> <6e6fb626-d3d4-46f7-93ac-94e3d243eb69@huawei.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Nov 06, 2026 at 11:16:33AM +0800, Tian Zheng wrote:
> 
> 
> On 10/30/2026 8:24 PM, Leonardo Bras wrote:
> > On Thu, Oct 29, 2026 at 10:02:10PM +0800, Tian Zheng wrote:
> > > 
> > > 
> > > On 10/27/2026 2:05 AM, Leonardo Bras wrote:
> > > > Hi Tian,
> > > > Sorry for the delay in reviewing...
> > > > 
> > > > On Tue, Sep 29, 2026 at 06:36:45PM +0800, Tian Zheng wrote:
> > > > > With VTCR_EL2.HD set, hardware promotes writable-clean descriptors to
> > > > > writable-dirty without any VM exit, and the only record of the write
> > > > > is the S2AP[1] bit in the stage-2 PTE. The write never passed through
> > > > > the host stage-1, and no unmap path reads the bit, so the record dies
> > > > > with the PTE and reclaim may discard written guest data (silent
> > > > > corruption).
> > > > 
> > > > Sorry, I didn't get what you are trying to achieve here.
> > > > 
> > > > On your patch, I see you marking backing pages dirty at wrprotect and unmap
> > > > walkers, and it's very confusing to me on why you are doing this.
> > > > 
> > > > IIUC, what you are trying to do is make sure a page does not lose it's
> > > > contents in case it is reclaimed by the OS.
> > > > 
> > > > IIUC, when a page is reclaimed, it will unmap the S2 PTE, and save it's
> > > > contents to swap, so when the guest read or write to that page will cause
> > > > it to fault.
> > > > 
> > > > The page can never be just unmaped, as if there was a single write to it,
> > > > the backing pages should be writable, and the contents need to be saved
> > > > somewhere.
> > > > 
> > > > So, if I was able to understand your suggestion, we don't need to worry
> > > > about this, and this patch wouldn't be necessary.
> > > > 
> > > > Did you hit this issue?
> > > > Can you please expand on your issue, if I could not describe it above?
> > > > 
> > > > Thanks!
> > > > Leo
> > > 
> > > Hi Leo,
> > > 
> > > Thanks for the review. I haven't hit this in practice, and based on your
> > > analysis the patch doesn't look necessary.
> > > 
> > > Reclaim only writes back folios whose PG_dirty flag is set; a clean
> > > folio is simply freed. A stage-2 write never touches the host
> > > stage-1, so the folio depends entirely on kvm_release_faultin_page()
> > > at fault-in to be marked as dirty; without it, the page stays clean from
> > > the host's perspective and reclaim drops the data.
> > > 
> > 
> > Oh, okay. IIUC it will be enough if PG_dirty flag is set once, right?
> > 
> > While on HAFDBS/HDBSS we will skip the fault for marking them dirty again,
> > we always take the first fault for every PTE (or prefault them), so
> > PG_dirty should always be set once the page is first wroten to.
> > 
> > 
> > > Your **RFC v1** patch 2 changed that marking from writable to dirty:
> > > 
> > > ```
> > > - kvm_release_faultin_page(kvm, s2vi->page, !!ret, writable);
> > > + kvm_release_faultin_page(kvm, s2vi->page, !!ret, dirty);
> > > ```
> > > 
> > > During logging, a read fault maps the page as WC: the folio is not
> > > marked PG_dirty in kvm_s2_fault_map() and hardware promotes the PTE to
> > > WD on write without any fault, so reclaim frees the page without saving
> > > it (the folio was treated as clean).
> > 
> > Ah, I see your point.
> > During dirty-tracking guest reads a page, then HAFDBS promotes it to
> > writable without marking it as dirty. Good catch!
> > 
> > But wouldn't a simpler solution be to change the conditions in the fault
> > handler, so that it indeed marks it as dirty if dirty-tracking is on, even
> > if it's just a read fault?
> > 
> > Thanks!
> > Leo
> > 
> Hi Leo,
> 
> Yes, that's exactly the simpler fix, and it's what I already did in
> HDBSS v5 patch 2 — the folio is marked dirty for any write-permitting
> mapping, so a read fault on a tracked memslot also marks it.
> 
> Since patch 2 covers this, patch 5 isn't needed. I'll drop it in the next
> version.
> 
> Thanks,
> Tian
> 

Awesome, thanks!
Leo
