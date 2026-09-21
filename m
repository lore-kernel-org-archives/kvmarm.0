Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A44624A3F1D
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 14:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790000152; cv=none; b=Ty4KX4Fc8JHBcFFa/qaLhD3KxwT2kUFqlRqALhK4/yf1WMS2vD0pyQcgV1hmpU7osTT+BVBoLkaxtLbv2SY/YYmzo1s9fnukbW58H3pxtHFy1kizm8C7utSTPMwiI5qQbxMUPQ2baDXQ11rVCYNc3AiD71SVApMew6vwcrEWHPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790000152; c=relaxed/simple;
	bh=GFF0q4XjecnXvt26SXMCNpoTC+BgSNXJBJ9ZFMXMeO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=AyvQjLyfoj+cvoiCWKWXAxmaQiDHWf0EsWZ6gc0eGfp66lqyIejdG/jyEx2PhZmxeQ5W/VqigtQkp+BsBME09hPQr6pmzRlUjsfWz0/6rn5G1ZMfvUyfkjKEpM4dX4Q+3m+E3Irl69slHRRc9CS2uhUjy12M3rE3wS9inlAn9fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nJ1MVoEu; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nJ1MVoEu"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 84FB819F0;
	Mon, 21 Sep 2026 07:15:45 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 144EF3F86C;
	Mon, 21 Sep 2026 07:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790000149; bh=GFF0q4XjecnXvt26SXMCNpoTC+BgSNXJBJ9ZFMXMeO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nJ1MVoEuIS2S2b3v4/MsCYgyL3+L2ycb3tuEcEo4wIdwkIxtUqibdbHbl0md3gOCh
	 3PyPr7xV34llOnb87+K4KMB0JoLyNNke5iONl/pyL2ruV30zfjjnm1GsPfscv3Pxeu
	 QqOiQ4/zuG+aHIQBG4xBv2zHFfN8u6UEEBIRa7Ac=
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
Subject: Re: [RFC PATCH 1/5] KVM: arm64: pgtables: Change write bit from S2AP_W to DBM
Date: Mon, 21 Sep 2026 15:15:44 +0100
Message-ID: <arE8EOPh1-NWtFIU@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <eb629070-a02f-426a-92ee-b2c8f9e2aa9a@huawei.com>
References: <20260901171558.2674031-1-leo.bras@arm.com> <20260901171558.2674031-2-leo.bras@arm.com> <86bja17cg7.wl-maz@kernel.org> <aql8jY4o8SzjJuFU@LeoBrasDK> <aqnku2TcFzIKhjQl@kernel.org> <aqp73SxO78o7LJTs@LeoBrasDK> <eb629070-a02f-426a-92ee-b2c8f9e2aa9a@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Sep 18, 2026 at 05:39:17PM +0800, Tian Zheng wrote:
> 
> 
> On 9/16/2026 7:22 PM, Leonardo Bras wrote:
> > On Tue, Sep 15, 2026 at 05:37:15PM -0700, Oliver Upton wrote:
> > > On Tue, Sep 15, 2026 at 06:12:45PM +0100, Leonardo Bras wrote:
> > > > > Yes, the HW should ignore it. But we have also
> > > > > seen quite a few broken designs in this area...
> > > > > 
> > > > 
> > > > I lack experience on what bad thing could happen. So I will expand on what
> > > > I belive to understand up to here:
> > > > 
> > > > - The PTE is in memory, so the DBM bit can be set regardless of being RES0
> > > > - For SW pagetable walking, I don't think 'bit 51 == 0' is checked
> > > > - For HW pagetable walking, maybe some faulty implementation may rely on
> > > >    bit51 being RES0, and fault otherwise.
> > > > 
> > > > If that's the case, then we would have to actually support both encodings,
> > > > and only enable the new one if HAFDBS is available in the system.
> > > > 
> > > > I just wonder how high are the chances to have such a broken design,
> > > > or other broken designs did not come to my mind, and if we have to start
> > > > with that multiple-encoding option.
> > > 
> > > FWIW, the host stage-1 already uses the DBM bit unconditionally,
> > > treating it as a software bit on implementations without HAFDBS.
> > > Although given the quality of any garden variety Arm MMU I understand
> > > where Marc is coming from.
> > > 
> > > I don't think the HAFDBS enablement is complicated enough to be done in
> > > a separate series without any meaningful users, nor would I really be
> > > interested in taking it without, say, HDBSS.
> > > 
> > > Can you please work with Tian to get a combined series out for this?
> > > 
> > 
> > Hi Oliver, thanks for reviewing!
> > 
> > Sure, one of the reasons I sent like this is so Tian could use it as a base
> > for his next version.
> > 
> > 
> 
> Hi Oliver, Leo,
> 
> Works for us. I plan to send HDBSS v5 maybe next week with this series
> merged in. Both dirty-tracking consumers are already built on top of the
> DBM approach: dirty ring and dirty bitmap.
> 
> Leo, with your blessing, I'd like to pick patches 1-4 into the HDBSS
> tree with your Signed-off-by preserved and mine added on top, plus some
> bug fixes on top of this RFC series.

Yeah, no problem on my side. I would just observe the maintainers' comments 
on those before merging them.

> 
> For patch 5, I'd like to rework it into a derived hardware dirty mode
> that replaces both kvm_set_hafdbs() and our earlier HDBSS enable/disable
> hooks, so the whole thing lands as one series.
> 

My intention when I wrote that patch was to add a base so you could add 
HDBSS on kvm_arch_commit_memory_region() with new patch such as:

	/* Disable HAFDBS when dirty-logging starts */
	if (kvm_supports_hafdbs(kvm))
		kvm_set_hafdbs(kvm, 0);
+	else
+		kvm_enable_hdbss(kvm);
...

	/* If dirty-logging was canceled, set HAFDBS back on */
	if (kvm_supports_hafdbs(kvm) &&
	    atomic_read(&kvm->nr_memslots_dirty_logging) == 0)
		kvm_set_hafdbs(kvm, 1);
+	else
+		kvm_disable_hdbss(kvm);


That being said, I need to run tests to make sure the usage of HAFDBS 
outside of dirty_tracking makes any sense in terms of performance, but if 
that's not the case, it would be fine to rework it so it does not 
enable/disable HAFDBS there.

> Performance looks good in both dirty ring and dirty bitmap scenarios so
> far.
> 

Awesome!

Thanks!
Leo
