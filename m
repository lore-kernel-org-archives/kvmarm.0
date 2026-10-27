Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793101465;
	b=eQu8huzNHSNpUU2oyRaGlQwatGCSHToG79YCE5pF9J/6PWpVVRMSXFPXA9Rnf0jpwtjj
	 tIbVkSvKIEGWVJYT1SbSbzE742e25yV9OZuFb4r/+T6ZFKKGSnwWeM7ZEg76fu2SXENPx
	 popMFwcBr29/QJxoFuy7UtZt4mLHhzdT3ldZ3Pf40RRE1OvpgcY785vWgzfYmVoWRtgxV
	 yUpg9ApCK7osGrmowFLGp0KWFuM9pMSU5sg5TmnuKHPWjGUdyVI8vPhuG8p06GGp9IXIJ
	 eB8Z9AVhxDtYIcSdT/eRIvaIvT4kF4gQ6srtNrqF4NXr1SQSNtvlJhXZJWBQWZ/F82Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793101465;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=/NltYmfxcgCAYT9YXitMAMuU2GI9OVYf0NS3EireCBQ=;
	b=VB3Qp1hVQ1Lbt6p4aDA6su8PzwpKb9iTWtNq8kbyvw0J1Hr7rnDTvoOYEp4p5c+qZhBy
	 gOikZJyOIF111mxFWMCazTmjzksPKdbbwLtuMogsy3aFiF9xbC25i31GZAULTP8XSuqEv
	 tSSwKd2Kqn+XD2bpWoIpaTWIQ+I0SwnUczgP/fQaPAbamosbWMe4SE+QYLcPiFRYq+4QJ
	 skfoafOJb0TH6Qu+/MLRF3gNG0Iyq/fUxSCUVwMgOmeKAEU5gF1o6lFLQkD121T7tshuc
	 qEM10w+bpCvH9Z+FWIMVNfLJBJQxIowGJxSn0k4f+3Wjp62rfP6t8EkQNG1HIFWrNbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=rOp2K4ZL;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E919F606A334
	for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 11:44:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E919F606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=rOp2K4ZL
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0308815A1;
	Tue, 27 Oct 2026 04:44:20 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 214FC3F59E;
	Tue, 27 Oct 2026 04:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793101463; bh=bBS51vaKu4N9Eu53pEXiAwZopzCyxiYFMo+QzWCX0iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOp2K4ZLaAGVLhbHEZh6GbKmrqveQL3g1Pn8k3ESCBGZjUol4AOfSQ1NOMxajxgGl
	 kZ9GCFvIBLAcypc7g/kZET88q4NgnMA9+3fFRJg+W4CqI9NX+y5q5RPJxu8fLPHzU5
	 QLS7umXxUPkoaeATmf95y1jMQAtj2a01kkWBcc44=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
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
	Tian Zheng <zhengtian10@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/3] Set DBM bit on writable pages
Date: Tue, 27 Oct 2026 11:44:15 +0000
Message-ID: <auCOj9dgk42AE1WX@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <at-lSy7H-K60LhCB@kernel.org>
References: <20261026144413.441566-1-leo.bras@arm.com> <at-lSy7H-K60LhCB@kernel.org>
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

On Mon, Oct 26, 2026 at 12:08:59PM -0700, Oliver Upton wrote:
> On Mon, Oct 26, 2026 at 02:44:06PM +0000, Leonardo Bras wrote:
> > When HAFDBS is enabled (VTCR_EL2.{HA,HD}={1,1}), having a DBM bit allows 
> > hardware to promote a non-writable page to writable by setting (S2AP[1]=1),
> > without having to take a fault.
> > 
> > The reason for this patchset is to add the DBM bit when setting-up writable 
> > pages, so the code is prepared for future patches that make use of 
> > HDBSS/HACDBS to accelerate dirty-tracking. Write-bit detection still 
> > happens based only in S2AP[1], so no change in that aspect.
> > 
> > Having DBM set on block entries is undesired, as we benefit from the first 
> > fault for splitting it in PAGE_SIZE entries, which is the granularity used 
> > to track the dirty pages in KVM. So introduce a new walker that, on top of 
> > clearing S2AP[1] for every entry, also clear DBM for block entries.
> > 
> > Also introduce a new VCPU request to reload Stage2, as it will be needed on 
> > future HDBSS/HAFDBS patchsets. 
> > 
> > Please let me know of what do you think!
> 
> I'm pretty sure I shared this feedback before, but patches that enable
> DBM do not make sense in isolation. We need a single series that
> contains the DBM enablement as well as the corresponding HDBSS support.
>

Right, 
My reasoning is that we can discuss this new version, and make the needed 
changes, so Tian could pick this for his own patch series for the next 
version. I do not intend to get this merged by itself.

Next time I will make sure to state this in the cover letter so it's clear.
 
> > Changes since RFCv1:
> > - Dropped patch #5 on enabling HAFDBS on non-dirty-tracking guests, as it 
> >   proved to be counter-productive on wrprotect, contrary to expectations
> > - No more moving writable-bit to DBM. That does not seem to be the intended 
> >   use. It makes sense and it's easier to convert code to new DBM approach.
> 
> Sorry, where was this concluded?
> 

Sorry, this is my viewpoint after re-reading the documentation and 
being really pedantic while trying to get a proper answer from the people 
responsible for keeping/improving it. 

> The abstract permission flags need to have a WRITE an DIRTY state, which
> we then map to hardware based on the capabilities of the system.
> 
> !FEAT_HAFDBS:
> 
> 	DIRTY	=> S2AP[1]
> 	WRITE	=> S2AP[1]
> 
> FEAT_HAFDBS:
> 
> 	DIRTY	=> S2AP[1]
> 	WRITE	=> DBM
> 

I agree that it could work, and my first version was based on that.

But looks weird to me that we have to decide the writable bit based on 
having a feature enabled.

Take in account that we can only have DBM being the writable bit while 
HAFDBS is enabled (not only present), and that it is just enabled during 
dirty-tracking. 

It means we would need to convert the whole pagetable between DIRTY=S2AP[1] 
and DIRTY=DBM every time we enable or disable dirty-tracking.

My suggestion with this series is to have WRITE=DIRTY=S2AP[1] at all 
times, and have DBM to act as a "can be promoted to writable on write" bit.
This way we don't actually need to convert between encodings, and it still 
works and complies with the architecture.

> Beyond making the whole HAFDBS easy to reason about, I want this for
> FEAT_S2PIE which reimagines bit 7 as a literal dirty bit that can be
> managed by software or hardware.

Humm, and would not that work with the above suggested approach?
I mean, bit 7 (Dirty, S2AP[1]) will both mean WRITE/DIRTY, but it will be 
able to get promoted (nonW->W, or clean->dirty) based on the indirect 
permissions.

What do you think?

Thanks for reviewing,
Leo
