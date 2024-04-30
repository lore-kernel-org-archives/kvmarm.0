Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487747F47A
	for <kvmarm@lists.linux.dev>; Tue, 30 Apr 2024 08:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714465806; cv=none; b=PWZEqZE5oTD+Z8CeH/iaB8XQljeNt5GAg8wwpW8Ql5G/E0WG0/Hvbz//uDSY703z1vmHzg5ULVHYbYJkZbextbMutOzof73QEUYzyc6MwoEUiu3UsbM88BlEF1W/ZDq1AEPPhUj0AMEGMLWWw5vR7kRPkP5YUkwdxOftgY95fHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714465806; c=relaxed/simple;
	bh=qyMMe6m/a33gbNCkbL/fdPdFeVZgPsX2Qz9eyfEN1n0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RgdV7AYYcvjRsqRleln2Ur12/BMUUaRFE9Vtp2sR65wM79N9nx/V2BPTDi+8AxYwt6WEIqYzqc40ydXg1Z3I13xTyNRK3yAsixG6b8Ek3ZJsGDsduGlV6lsjUTJLfPRlyXsMwso2dDzb1s2kZRPfy/VuLTY+BUnbw5QAcXim31A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gEh90WNz; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gEh90WNz"
Date: Tue, 30 Apr 2024 08:29:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714465802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b17x5/fRH9HdD4842DbJRZVUMCMwM1y1kKPeK/V3nWo=;
	b=gEh90WNzl63Zfkl6N2spnmWONCF7I066nTv339RJtf4xFagoO8Y6G2MzWBC3zQTF5kTkr3
	YsNH2dt+NXJnp+yqsRli+UCvwQZXc5ltXhpNSWc2UNG9yjdRhs8utNhiJxxIalqTrD8SIs
	11rDStCobyNLSx3rAaYRT0rtHD6oURU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	James Morse <james.morse@arm.com>,
	Alexander Potapenko <glider@google.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.9, part #2
Message-ID: <ZjCsBpcUslDk6vhI@linux.dev>
References: <ZilgAmeusaMd_UeZ@linux.dev>
 <ZjCo1Qj4k-mbNXtD@linux.dev>
 <D49302F0-B184-416D-AB26-49C5F14A1D94@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D49302F0-B184-416D-AB26-49C5F14A1D94@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 30, 2024 at 10:28:32AM +0200, Paolo Bonzini wrote:
> Hi Oliver,
> 
> I was on vacation, and unfortunately I saw it pretty much the day I left home. I will get it to Linus this afternoon.

No worries, thanks. Hope you had a good vacation!

> Il 30 aprile 2024 10:16:21 CEST, Oliver Upton <oliver.upton@linux.dev> ha scritto:
> >On Wed, Apr 24, 2024 at 12:39:46PM -0700, Oliver Upton wrote:
> >> Hi Paolo,
> >> 
> >> Single fix this time around for a rather straightforward NULL
> >> dereference in one of the vgic ioctls, along with a reproducer I've
> >> added as a testcase in selftests.
> >> 
> >> Please pull.
> >
> >Nudging this, Paolo do you plan to pick this up or shall I make other
> >arrangements for getting this in?
> >
> >> -- 
> >> Thanks,
> >> Oliver
> >> 
> >> The following changes since commit fec50db7033ea478773b159e0e2efb135270e3b7:
> >> 
> >>   Linux 6.9-rc3 (2024-04-07 13:22:46 -0700)
> >> 
> >> are available in the Git repository at:
> >> 
> >>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.9-2
> >> 
> >> for you to fetch changes up to 160933e330f4c5a13931d725a4d952a4b9aefa71:
> >> 
> >>   KVM: selftests: Add test for uaccesses to non-existent vgic-v2 CPUIF (2024-04-24 19:09:36 +0000)
> >> 
> >> ----------------------------------------------------------------
> >> KVM/arm64 fixes for 6.9, part #2
> >> 
> >> - Fix + test for a NULL dereference resulting from unsanitised user
> >>   input in the vgic-v2 device attribute accessors
> >> 
> >> ----------------------------------------------------------------
> >> Oliver Upton (2):
> >>       KVM: arm64: vgic-v2: Check for non-NULL vCPU in vgic_v2_parse_attr()
> >>       KVM: selftests: Add test for uaccesses to non-existent vgic-v2 CPUIF
> >> 
> >>  arch/arm64/kvm/vgic/vgic-kvm-device.c           |  8 ++--
> >>  tools/testing/selftests/kvm/aarch64/vgic_init.c | 49 +++++++++++++++++++++++++
> >>  2 files changed, 53 insertions(+), 4 deletions(-)
> >> 
> >
> 
> Paolo
> 

-- 
Thanks,
Oliver
