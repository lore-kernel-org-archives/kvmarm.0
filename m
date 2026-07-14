Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EBD3364949
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 10:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784024386; cv=none; b=Jdua3LfQWnIpI1o9P58y8cKGQffKkMfZTTEzaHcO1hR8qslbRoodbXlaS43Hrpl3hdfS9N+Zap/J5kr2DMtADhMrUR7Ys47zJlZLnDuABsUmqRZNZqHG0NMHGGO6orZr6EMpqKJ4BQ6Bt9ezQ8CGNBcdWM7G2AcGtrFbwiN8L6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784024386; c=relaxed/simple;
	bh=YXLhgjk9qd3m9U6QCUpLlON7Ad8A3ET8lcvFZ6qIMes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=luNFgDZR8RmiUUKIRzx5QqQUNd2RVodpaegj63DfdEhCHoaBE0F7ssAxTPnyNl/R+Xe3RSXH4m4Ix1cUJ+bZGxHNQ+EUVyA0t3UZr5EdVFrVUYUX+9lP8ie6y9z3eyEzZyptmWOvT0wrgFnHD9/3Ac+JofxKeNH2u3L17CCnRUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UZUoTvPw; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UZUoTvPw"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 28155497;
	Tue, 14 Jul 2026 03:19:40 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0CBD93F7B4;
	Tue, 14 Jul 2026 03:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784024384; bh=YXLhgjk9qd3m9U6QCUpLlON7Ad8A3ET8lcvFZ6qIMes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UZUoTvPwGqlDB68l3l4SN2HegcOjxbVpbmWb6j65q6WMuws3Xp5XyfHNrGeIRirFN
	 ojqapaCRtuGNjw31KWxhtYif9PPHWr0AzM/3WiUjgCJFAngyCz4gFSkWKAwHkbIFlX
	 JDX5RXkrsr8o9/77EP/yLoHz/8tqH9LkKhyJNgZM=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	maz@kernel.org,
	oupton@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	yangjinqian1@huawei.com,
	caijian11@h-partners.com,
	liuyonglong@huawei.com,
	yezhenyu2@huawei.com,
	yubihong@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com
Subject: Re: [PATCH v4 0/6] Support the FEAT_HDBSS introduced in Armv9.5
Date: Tue, 14 Jul 2026 11:19:38 +0100
Message-ID: <alYNOg7lREtdVE29@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <8757dfcf-aae4-4716-9ff1-c3140d4cc63e@huawei.com>
References: <20260709104026.2612599-1-zhengtian10@huawei.com> <alS-kcwvlASwPIzL@LeoBrasDK> <8757dfcf-aae4-4716-9ff1-c3140d4cc63e@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jul 14, 2026 at 05:37:58PM +0800, Tian Zheng wrote:
> 
> On 7/13/2026 6:31 PM, Leonardo Bras wrote:
> > On Thu, Jul 09, 2026 at 06:40:20PM +0800, Tian Zheng wrote:
> > > This series of patches add support to the Hardware Dirty state tracking
> > > Structure (HDBSS) feature, which is introduced by the ARM architecture
> > > in the DDI0601 (ID121123) version.
> > > 
> > > The HDBSS feature is an extension to the architecture that enhances
> > > tracking translation table descriptors' dirty state, identified as
> > > FEAT_HDBSS. This feature utilizes hardware assistance to achieve dirty
> > > page tracking, aiming to significantly reduce the overhead of scanning
> > > for dirty pages.
> > > 
> > > The purpose of this feature is to make the execution overhead of live
> > > migration lower to both the guest and the host, compared to existing
> > > approaches (write-protect or search stage-2 tables).
> > > 
> > > The required sysreg definitions for FEAT_HDBSS have been merged into
> > > arm64 /sysregs:
> > >    [1/5] arm64/sysreg: Add HDBSS related register information
> > >          https://git.kernel.org/arm64/c/72f7be0c2e30
> > > 
> > > 
> > > After these patches, the kernel automatically enables HDBSS when dirty
> > > logging is enabled on any memslot, and disables HDBSS when dirty logging
> > > is disabled on all memslots. This series does not support dirty ring
> > > mode.
> > > 
> > > Depends-on: "KVM: arm64: Enable eager hugepage splitting if HDBSS is available"
> > > 	https://lore.kernel.org/linux-arm-kernel/20260629111820.1873540-3-leo.bras@arm.com/
> > On this, FYI, there have been some discussion on this:
> > https://lore.kernel.org/all/alETGFD2Ogx6N0HB@LeoBrasDK/
> > 
> > Oliver's suggestion is that we don't automatically enable eager splitting,
> > but instead we have different behaviours if the user enables it.
> > 
> > This is still under discussion there, but I think it can be useful reading.
> 
> 
> Thanks for the pointer — I've read through the discussion between you and
> Oliver, and it's very helpful.
> 
> 
> If I understand correctly, the proposed approach is to support both modes,
> with DBM behavior depending
> 
> on the user's eager split setting:

I am still waiting for his feedback on that, but I suppose that's what he 
meant.


> 
> - If users enable eager splitting (chunk_size != 0): use the v4 approach —
> DBM is set globally.
> 
> - If users do NOT enable eager splitting (chunk_size == 0, i.e., lazy split
> mode): use the v3 approach — DBM
> 
> is set lazily in user_mem_abort on the first write fault.
> 
> 
> This makes sense to me. It gives users the flexibility to choose.
> 

Yes, agree

> 
> As I mentioned in my patch 6/6 reply (https://lore.kernel.org/all/6e8b23bc-d420-4f5a-a921-5a5d64d84200@huawei.com/),
> 
> I do think the lazy DBM approach is safer overall if the first-fault
> overhead is acceptable — it avoids accidentally marking
> 
> special mappings and naturally handles lazy split.
> 

I remember a previous discussion in which was concluded that lazy marking 
DBM carried some issues. I have to go back on that and check if we can take 
care of that now.  

> 
> I'll keep an eye on the discussion and follow up once a conclusion is
> reached.
> 

Thanks!
Leo
