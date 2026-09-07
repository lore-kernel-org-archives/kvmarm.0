Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F06B379ECD
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 10:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778233; cv=none; b=bWNmPCHCKEBGw0PT8OebapTDIOua+cMt9PJSxZN/2PU+g8IV+XuIKLY8GdeXP6kBsW2DrKNqZDZf+mCShZRPv45Z/N5fTcAUdFWYcFzUTgYV7cMtkLtUrq0chLBykLi/6k3lBSSXvrn8jTMr50UnQqY6D/CSV8yCzJnoZtPgBzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778233; c=relaxed/simple;
	bh=xg/R0kc9AI6X9zQv/IwFhI4qYI+4FJFHdQgK4QRxg+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=GKfln/wQjrnd+IVNRCAaEDdRszQAipuO/fQJofhGo4zF+OJqzW7ZN4rIpMxa9GRvmvJj4H1LLzf9ohQPx8mht4dGbClgxwTZlWglyXuQ6+984O2oh9kYY+kOp4Q6DGu4OpqSaoCmyqXhF2CAebsYOPvlpqYEnnx0tH58ZNU6Bgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qfCcUQp+; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qfCcUQp+"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B7F721477;
	Mon,  7 Sep 2026 03:50:26 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 667B63F7B4;
	Mon,  7 Sep 2026 03:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788778230; bh=xg/R0kc9AI6X9zQv/IwFhI4qYI+4FJFHdQgK4QRxg+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qfCcUQp+s0PagXL636LsoBcv4v329fUXAZZ5PWD0ZSkVJuNDJiBSFUlfq5WKpgFbq
	 2L+qd+tmn0dJjubGcbJQmuRJiXidEhXnm9E5B+b8z0fWll8uH/bAtllqUc+kSFmuDy
	 Fc/z7vJghiT7UPA9iPncthAprKJmjS5JsQYlMApE=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	maz@kernel.org,
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
Subject: Re: [PATCH v4 3/6] KVM: arm64: Add auto DBM support for hardware dirty tracking
Date: Mon,  7 Sep 2026 11:50:21 +0100
Message-ID: <ap6W7bcSJ8I6lJup@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <9bbb0a97-7e3a-4815-9619-fd72129d4878@huawei.com>
References: <95f1ebd4-be04-4684-be68-388f752a1379@huawei.com> <anDCno9HdVI5UAls@LeoBrasDK> <2070002d-94aa-4a5b-8df1-e8e0f0fd265c@huawei.com> <anHIa5PDnF7r9EA4@LeoBrasDK> <3808f469-5403-4f2e-85f0-8c6ca13068bd@huawei.com> <anmvnclRTPS6an8e@LeoBrasDK> <aoh1vw0ZdWJf6T4q@LeoBrasDK> <ad48e628-d036-440e-955d-856c2539e568@huawei.com> <apcJ6bClZbX4BCpR@LeoBrasDK> <9bbb0a97-7e3a-4815-9619-fd72129d4878@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Sep 07, 2026 at 11:17:27AM +0800, Tian Zheng wrote:
> On 9/2/2026 1:22 AM, Leonardo Bras wrote:
> > Hi Tian,
> > 
> > It was already done here, but I got sidetracked and forgot to send before.
> > 
> > https://lore.kernel.org/kvmarm/20260901171558.2674031-1-leo.bras@arm.com/
> > 
> > The relevant parts for the RO/RW -> RO/WC/WD conversion are in patches #1,
> > #2 and #3.
> > 
> 
> Hi, Leo,
> 
> Oh, awesome!
> 
> The RO/RW -> RO/WC/WD conversion is much clearer now.
> 
> Which means when dirty logging is not active, all pages that were
> previously RW are now in the WD state.

Yes, that's how I thought the conversion would look simpler.

> The WC state only appears when
> dirty logging is actually enabled.

Correct! Note that for systems without enabled HAFDBS, both WC and RO will 
behave exactly the same, faulting when memory is wrote to. That's why the 
new helper keeps working :)

> 
> This makes the state machine much more intuitive, and I think it aligns
> well with Oliver's suggestion to decouple permission from dirty state at
> the page table level.

Awesome!

> 
> > > 
> > > v5 already implements this, and I'm about to send it out shortly.
> > > 
> > 
> > Oh, awesome!
> > Please verify it against the patchset above, just in case :)
> > 
> > Thanks!
> > Leo
> > 
> 
> I'll review the patches in detail and verify v5 against your series.

Just keep in mind that patch 5/5 is just there to try the idea, but it 
could lay some important base for HDBSS. 

> From what I've seen so far, performance with HDBSS looks great.
> 

Awesome!

Thanks,
Leo
