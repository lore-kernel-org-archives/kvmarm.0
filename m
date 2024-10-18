Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CE71878
	for <kvmarm@lists.linux.dev>; Fri, 18 Oct 2024 18:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729277569; cv=none; b=fAesfBFqcdlbal4eCD0lspLZ2KihCya9Nj6eaRsBHprM9Md2bNZnjkE5WW+VrLP/Qyn+sXxUXVSCBlkH+yuUWokevh0hq6fqyQ5zcAgmln4UpvsJb5P2R6btgnR4qdkaLzX0ynxw2ztB8P/McShqPyCVx9kSnKUHsK2UETJqiMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729277569; c=relaxed/simple;
	bh=Y7ylzhQmjvzNyd0DCwPs06aVnk1f1xBX46x3fiyQQjg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rIGohAYAD+g6iDa+pOG4IuGbOL3Os94mY275nV4X6+lOA3Ja9MtniF33M9lVOHnq5eQo6dDFpQuMuR0Cg670ltEWz3ut05aJztvCqcRj3YprEZkd/m9l5ViF6OBUPwSawFGL9uTfX/ZfkQCMonxEWMCrdDO+pSdJvQPPDo7Blc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ls1aEg3m; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ls1aEg3m"
Date: Fri, 18 Oct 2024 11:52:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729277564;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N7gGee0VoX3/3pvOl5YQTwO9KIrTBzmVncNX5uAOKK0=;
	b=ls1aEg3mc1hFdNhE7b/nh+s9QFEDJy4/74kbOZG0dZJ56Ynjs8L1KtVT/eGx1MINgZA4je
	6f4gU1PLfAcf299w6NyuR+V9uLWCBKfk6N/Vx5RNyr4hUI+UmqXLt9XQtpXq5EvTuqzZ7D
	POGiWC3oj2KHu4IBs8OoasQ2u56P+CY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: eric.auger@redhat.com, Cornelia Huck <cohuck@redhat.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>,
	yuzenghui <yuzenghui@huawei.com>,
	"Wangzhou (B)" <wangzhou1@hisilicon.com>,
	jiangkunkun <jiangkunkun@huawei.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Anthony Jebson <anthony.jebson@huawei.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Linuxarm <linuxarm@huawei.com>
Subject: Re: [RFC PATCH 0/6] KVM: arm64: Errata management for VM Live
 migration
Message-ID: <ZxKudSBRKfM1OkMK@linux.dev>
References: <20241011075053.80540-1-shameerali.kolothum.thodi@huawei.com>
 <86jzef53iz.wl-maz@kernel.org>
 <3f4469c49625413f9ab2c224d0d3fbea@huawei.com>
 <86ikty6f1b.wl-maz@kernel.org>
 <ZwlADbp-HjkijElX@linux.dev>
 <08261a41b9644f5ab49063824e4060c3@huawei.com>
 <87bjziraou.fsf@redhat.com>
 <7df21c56-0b07-4112-839e-ef90c5999fcd@redhat.com>
 <86frot4kki.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86frot4kki.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Oct 18, 2024 at 02:17:17PM +0100, Marc Zyngier wrote:
> On Thu, 17 Oct 2024 18:16:04 +0100,
> Eric Auger <eric.auger@redhat.com> wrote:
> > 
> > Hi Shameer,
> > 
> > On 10/17/24 17:49, Cornelia Huck wrote:
> 
> > > Speaking of QEMU: Do you maybe already have some prototype code that
> > > tries to do something with the setup here? (I don't think QEMU currently
> > > mucks around with MIDR and friends when running with KVM; I wonder what
> > > it should provide to the guest and if it should care to set something as
> > > a base level that gives guests not using the hypercall a chance to work
> > > properly.)
> > >
> > As discussed during the KVM forum we are working on a qemu integration
> > for writable ID regs. The first goal is to be able to specialize the
> > host passthrough model (custom host model). Maybe this will trigger more
> > discussions on named models too. This is complementary to the
> > MIDR/REVIDR problematic and I hope we will be able to consolidate our
> > works at some point.
> 
> Complementary to the MIDR/REVIDR work, I would also like to make
> MIDR/REVIDR writable when this scheme is available. Ideally reporting
> a synthetic CPU description (with MIDR_EL1.Implementer returning 0,
> and the rest being VMM-specific, but with a clear definition for the
> IMPDEF fields so that we can version the ABI).

When the VMM is using the hypercall mechanism to describe
implementations, 100% agree.

> Thoughts?

I think we should go a step further and allow userspace full control of
known fields in these registers, even for a nonzero Implementer code.

We're already affording userspace full control of what implementation(s)
the guest sees anyway via hypercalls, so there isn't much left for KVM
to enforce.

Ignoring errata, it'd let folks spoof an old implementation on newer
hardware for testing, especially when dealing w/ older software.

-- 
Thanks,
Oliver
