Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3A5437F72F
	for <kvmarm@lists.linux.dev>; Thu, 16 Jul 2026 16:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784219151; cv=none; b=ceoU+SC+0TFKtd1rRQUDngnm9SfP7gWYsR4u3bcWGyeSzeVfPbolQIsWJmBg/OF95MVKoPn7qQTW+NHaIPxBBbVo/V4Ool8FkC5YipCL/H174nm/zEn6P8gQZClJHvxbYfxNn7ojFj7evQdc/gdvVZEqaOfQB4BMr7T8RA0GITk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784219151; c=relaxed/simple;
	bh=Ol8RXOW90RspxBYRMmqnn0Jm2Hs0leRmgMXzEwXKFD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QIQGJfKXBz0pQ86uaBiSdiL77VgP6tTMk757rexoDf/sPMFjydyBxChXTJu3JLlUNnJ73S6XqFp3i5078boApsKGxCK6kfbX8GS6kuGBBfvbOpssVsGCuoB+T9AQGFDil7PJ7vslM8i6BFm5G2FU+FUFRQThchhAL25i16cIy6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=raNF62Kx; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="raNF62Kx"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0C9EC1476;
	Thu, 16 Jul 2026 09:25:44 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 82C643F7B4;
	Thu, 16 Jul 2026 09:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784219148; bh=Ol8RXOW90RspxBYRMmqnn0Jm2Hs0leRmgMXzEwXKFD8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=raNF62Kx5WvhyNd24QVTbfe3UNmBnNDsaz2hDB854T686iwGoDmD1Q76W9cl87vQf
	 2WkwOr2MkN3IA/qi+kAK120l+veNSgVsXwL5OC9IUAL9eIktErZkN+rZEthLO6sfU7
	 Db8SDOyDxLNHQPxFWUjqW8dUqhYwXjx8ExXTB+bo=
Date: Thu, 16 Jul 2026 17:25:35 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Itaru Kitayama <itaru.kitayama@fujitsu.com>, 
	Sebastian Ene <sebastianene@google.com>
Subject: Re: [PATCH v4 3/6] KVM: arm64: nv: Add nested revmap broken
 tracepoint
Message-ID: <clbxsg4rvtgsg3eqnuolj6q5ckmo6ltigujfzawko2r662ebbw@fnx3ommt457j>
References: <20260714115926.2044757-1-weilin.chang@arm.com>
 <20260714115926.2044757-4-weilin.chang@arm.com>
 <alh98Zz42OdWo-jp@kernel.org>
 <867bmvnwhq.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867bmvnwhq.wl-maz@kernel.org>

On Thu, Jul 16, 2026 at 09:56:33AM +0100, Marc Zyngier wrote:
> On Thu, 16 Jul 2026 07:45:05 +0100,
> Oliver Upton <oupton@kernel.org> wrote:
> > 
> > Hi Wei-Lin,
> > 
> > On Tue, Jul 14, 2026 at 12:59:22PM +0100, Wei-Lin Chang wrote:
> > > Add a tracepoint to track when a nested reverse map becomes broken. This
> > > makes it easier to detect NV performance degradation caused by full
> > > shadow stage-2 unmaps.
> > > 
> > > Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> > 
> > I'm not too excited about making a tracepoint out of this, especially
> > since a 'broken' reverse map is more of a KVM implementation detail
> > (that could change) than anything else.
> > 
> > BPF is quite popular at this point, do you think it's reasonable to
> > instead expect the curious KVM developer to attach a kprobe and inspect
> > the state of the nested MMU?
> 
> I was the one asking for a way to report this stuff. I'd be completely
> fine with BPF as long as we give the recipe for this so that people
> can readily look at this.

Cool, I'll drop the tracepoint in the next iteration.

> 
> Even better, find a way not to have a broken rmap the first place ;-).

One possible way is to not do the shadow stage-2 map if maple tree store
fails, please see the response for patch 2 for details!

Thanks,
Wei-Lin Chang

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
