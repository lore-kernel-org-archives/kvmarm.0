Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793363097;
	b=J/FvRxQqknVo+i0FlUGVT1fAkl/wMy+ORtCuw90zqsWJYl4GdoFQbFxTof3iIaiso2oN
	 iIqPm+xlsM+8Gjo7+FlbSap4Ye158kxmZisY4UQj1BugkRXb9FUA+/Q0/vlZkUJDz0L00
	 IrqYZZdFOe1n1uCnWwz0EMh7d5iZwQfr8UgJXK9CkCL8TooDQdtPttmy4GcGXTea5hYJU
	 LW0erIvmg9zIN5AEmE7dpGBmSXNIc1nQCVPKqd7CD6TG9ArTvrLaQZMf1cuUthkQuDMBn
	 uyiVgP0iy2ZH2uDHyOMvKNnUSmJywb8WyqLQihBarA2L7eT5KctlfhZQwcLI5uo/aag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793363097;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=BGYHEZ8/yGpunCTkOYvgRITEqUm5TYbCUQMtVfX6jU0=;
	b=4IAsTCotD+zi3Z4v5dvvgUOKHiBOY/MopdSGIKO9wOUafXTc1zDuPPYRaGk+E6tyNGsF
	 lrRtiliqCMpJVlVq/p6BK6G9rbs4YWWeXbb+qdJgfY8/ddE4nJg9kYWr3HwABH9BxBbPf
	 eEVZRwDQuYG2DNfhSYXmNhsbtcOnRw/JMsmTFYVoiKApfdPstUtRwBFICka28doo1FPz3
	 JISU3eC3RyR8iguE5bqxBajY92HREmjSXXCu9oYnzN/Lxais0djjOs/7ET5iPgrc64w+T
	 AzpdRN6hG4byYA5D6RfdEG+3LffJ7vtGalyWh6ftzm83OTPdwmEDR/rgsr/7Fb5Az0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=oTraL4TW;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A2D0606A325
	for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 12:24:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A2D0606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=oTraL4TW
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C4531682;
	Fri, 30 Oct 2026 05:24:52 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E26493F673;
	Fri, 30 Oct 2026 05:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793363095; bh=eGdbHVu74E1ReCplaksFUR7oTU7Slvjcv5W3BhCgOSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oTraL4TW6hdj6K6/eVqxzmeVe/O6RS5Hc/k5lTSA7nQwCWgUetERsiwu+MuBGb/M+
	 E5ipFfUb7SrTtrmTnveMAht6d2TA78URXg27fGnLANURPAclKI5Vxoo+8H4TvEnGgB
	 U3+Peb9gGg2q1ZA3QRpkBU3oaq2qWu1g5CGKx7b8=
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
Date: Fri, 30 Oct 2026 12:24:49 +0000
Message-ID: <auSMkdEhLI7k8QbV@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <009b13c6-f618-43fe-8a56-8519d31b239b@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com> <20260929103655.85107-6-zhengtian10@huawei.com> <at-WceRKAVM2kEnI@LeoBrasDK> <009b13c6-f618-43fe-8a56-8519d31b239b@huawei.com>
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

On Thu, Oct 29, 2026 at 10:02:10PM +0800, Tian Zheng wrote:
> 
> 
> On 10/27/2026 2:05 AM, Leonardo Bras wrote:
> > Hi Tian,
> > Sorry for the delay in reviewing...
> > 
> > On Tue, Sep 29, 2026 at 06:36:45PM +0800, Tian Zheng wrote:
> > > With VTCR_EL2.HD set, hardware promotes writable-clean descriptors to
> > > writable-dirty without any VM exit, and the only record of the write
> > > is the S2AP[1] bit in the stage-2 PTE. The write never passed through
> > > the host stage-1, and no unmap path reads the bit, so the record dies
> > > with the PTE and reclaim may discard written guest data (silent
> > > corruption).
> > 
> > Sorry, I didn't get what you are trying to achieve here.
> > 
> > On your patch, I see you marking backing pages dirty at wrprotect and unmap
> > walkers, and it's very confusing to me on why you are doing this.
> > 
> > IIUC, what you are trying to do is make sure a page does not lose it's
> > contents in case it is reclaimed by the OS.
> > 
> > IIUC, when a page is reclaimed, it will unmap the S2 PTE, and save it's
> > contents to swap, so when the guest read or write to that page will cause
> > it to fault.
> > 
> > The page can never be just unmaped, as if there was a single write to it,
> > the backing pages should be writable, and the contents need to be saved
> > somewhere.
> > 
> > So, if I was able to understand your suggestion, we don't need to worry
> > about this, and this patch wouldn't be necessary.
> > 
> > Did you hit this issue?
> > Can you please expand on your issue, if I could not describe it above?
> > 
> > Thanks!
> > Leo
> 
> Hi Leo,
> 
> Thanks for the review. I haven't hit this in practice, and based on your
> analysis the patch doesn't look necessary.
> 
> Reclaim only writes back folios whose PG_dirty flag is set; a clean
> folio is simply freed. A stage-2 write never touches the host
> stage-1, so the folio depends entirely on kvm_release_faultin_page()
> at fault-in to be marked as dirty; without it, the page stays clean from
> the host's perspective and reclaim drops the data.
> 

Oh, okay. IIUC it will be enough if PG_dirty flag is set once, right?

While on HAFDBS/HDBSS we will skip the fault for marking them dirty again, 
we always take the first fault for every PTE (or prefault them), so 
PG_dirty should always be set once the page is first wroten to.  


> Your **RFC v1** patch 2 changed that marking from writable to dirty:
> 
> ```
> - kvm_release_faultin_page(kvm, s2vi->page, !!ret, writable);
> + kvm_release_faultin_page(kvm, s2vi->page, !!ret, dirty);
> ```
> 
> During logging, a read fault maps the page as WC: the folio is not
> marked PG_dirty in kvm_s2_fault_map() and hardware promotes the PTE to
> WD on write without any fault, so reclaim frees the page without saving
> it (the folio was treated as clean).

Ah, I see your point.
During dirty-tracking guest reads a page, then HAFDBS promotes it to 
writable without marking it as dirty. Good catch!

But wouldn't a simpler solution be to change the conditions in the fault 
handler, so that it indeed marks it as dirty if dirty-tracking is on, even 
if it's just a read fault? 

Thanks! 
Leo

> 
> Therefore, **HDBSS v5** patch 2 reverted to marking the folio for any
> write-permitting mapping:
> 
> ```
> kvm_release_faultin_page(kvm, s2vi->page, !!ret, writable);
> ```
> 
> Together with the v5 scheme, this makes patch 5 unnecessary:
> 
> - kvm_s2_fault_compute_prot: always set PROT_W when map_writable
> - stage2_set_prot_attr: PROT_W -> DBM unconditionally
> 
> 
> ---------
> 
> On a related note, I'd like to discuss the next version of the DBM
> scheme, following Oliver's suggestion [1].

Just as a note for future readers: on another thread we agreed to wait for 
the discussion to reach a point we are all happy before rebasing 
everything.
