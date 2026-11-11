Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794391341;
	b=e9cdtu22mHqF+d6LOTNUQMCI1TtW9fxkU0K4ckGOulIIfNF1XCCkchJyoooF9KBt1jzb
	 KoVvE970syK8xDhX7KspTChs/qHay+oUSjNTm1Pc4hhLJ4GR4zrQXnIQ3+16wxsn2VcBg
	 YRwfMBZddd2BHTZPwV2AkSTEwAf5cDZXFuorYToGhPZp454kDbvJcU14T1h9xdSBhdZGi
	 ZXKDpHkp1P4FDyNq3hzRcsofQIqZsYsPRUfC+Ehx1NJl044kgmY0DCV0Uivzh1O0EFctD
	 y4HuTZdmXER5GzWIV3Sxdp4DTCoFbrrMR20l9w//DiQ7lbz3gaqgG+XCHhCxG4GXUQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794391341;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=/008Nq1DBBEIqx5PPz70GiPaNVyQI+eFBJTDZljb44Q=;
	b=AQQIxBybiT2I5q8aytXUvvMnBVDrf+2wEB6jxbbnDYgzTJwEDtBqCI4hmPS98p/2ZrcC
	 NFNGIummogK3xDNIbp4S5G51ePBK/yo3U2nREjyxw8qlbZA3FRo+saWEcY0UuhsLNGJo5
	 IB6R+mkDSHP0uHf54zQQk5QPaaFBz5dT1XkcVmkDivU7/46ulAGx6nX38PX8FKKATKe88
	 tV6d5kM8SGnb+PbfvbqYTtMJugBwiAb59yePErYjBLwu+fZlWZ/hY6Zt5bG0r0AmuPtej
	 lN+pswXBH/hIn4O1d4MN7SHct1Ybsby6dkOESioj/F16huHgPA+c4Ke1tBD3QgJP10A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=O6IdHv3P;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 066F960A261B
	for <kvmarm@lists.linux.dev>; Wed, 11 Nov 2026 10:02:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 066F960A261B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=O6IdHv3P
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A8041576;
	Wed, 11 Nov 2026 02:02:16 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D8B973F673;
	Wed, 11 Nov 2026 02:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794391339; bh=iBX7/caJMXnRG4auS6ChraoO4dSo/zwj7eCa2+s/N48=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O6IdHv3Pa6BF4W/gj+tmwDWoCPsjfXKjFP32FDKfEVDMDMDI8b+AdWLJIeDX4vXWL
	 5tTlEk8MizP4FV96CYNLY32LXX4mXYgk+F1dgumoIHRXhgBBrmbT7eHPSDKAQZbgOE
	 L/w7KjxCQz+kqbd4w3gQ9WrqNb468FzIICjG6R/k=
Date: Wed, 11 Nov 2026 10:02:14 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
	Wei-Lin Chang <weilin.chang@arm.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH 2/2] KVM: selftests: Test KVM_PRE_FAULT_MEMORY against a
 full dirty ring
Message-ID: <avQ9Jhsnq7e3KPw-@raptor>
References: <20261110110724.3614412-1-fuad.tabba@linux.dev>
 <20261110110724.3614412-3-fuad.tabba@linux.dev>
 <avMoubwqgXbpflwM@gremlin>
 <CA+EHjTxT_9NghyLSZmOOi_oQboQw-g+6z9WxwaF=-7RdaGbMNw@mail.gmail.com>
 <avM9_7aWUDJSL3Lq@seanjc-mac.roam.internal>
 <avM_FXXF9oBkderF@gremlin>
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
In-Reply-To: <avM_FXXF9oBkderF@gremlin>

Hi all,

On Tue, Nov 10, 2026 at 04:02:21PM +0000, Lorenzo Stoakes (ARM) wrote:
> On Tue, Nov 10, 2026 at 07:53:35AM -0800, Sean Christopherson wrote:
> > On Tue, Nov 10, 2026, Fuad Tabba wrote:
> > > Hi Lorenzo,
> > >
> > > On Tue, 10 Nov 2026 14:38:27 +0000, "Lorenzo Stoakes (ARM)"
> > > <ljs@kernel.org> wrote:
> > > > On Tue, Nov 10, 2026 at 11:07:24AM +0000, Fuad Tabba wrote:
> > > > > Pre-fault more populated, dirty-logged pages than the vCPU's dirty ring
> > > > > holds, and check that each call stops before the ring overflows, that a
> > > > > retry returns ENOSPC without progress, and that the harvested entries
> > > > > are the pages in order. A read pre-fault can map a page read-only, or
> > > >
> > > > Are we asserting an invariant that prefaulting happens in address order
> > > > here?  Is that explicitly presumed in the prefault API, or just how it
> > > > happens to pan out?
> > > >
> > > > I wonder if we might decide for whatever reason in future to do things
> > > > differently there. Bit nitty I know, but wonder if it's asserting an
> > > > implementation detail?
> > >
> > > Yes, the API doesn't guarantee an order. I'll assert that every page
> > > is reported exactly once instead.
> > >
> > > [...]
> > > > > diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
> > > [...]
> > > > > +static void test_pre_fault_dirty_ring(void)
> > > [...]
> > > > > +    /* Populate the pages, so that pre-faulting can map them writable. */
> > > >
> > > > Reviewed below, but I wonder how x86 could then read fault these?
> > >
> > > KVM_PRE_FAULT_MEMORY is defined as a read fault, but x86 maps the page
> > > writable when the host page is, and marks it dirty, unless it falls
> > > back to access tracking (below). Populating the pages makes sure they
> > > aren't backed by the zero page.
> >
> > Before we effectively solidify the behavior, I think we should have an explicit
> > discussion about the desired behavior of KVM_PRE_FAULT_MEMORY when dirty logging
> > is enabled.  E.g. the only reason I kept the existing behavior in my auto-prefault
> > series was because I couldn't think of a good reason to change it.  But we never
> > made a concious decision in the first place, i.e. we never considered what would
> > happen if prefaulting collided with dirty logging (as evidenced by this bug).
> 
> Yeah, I do worry about implicit assumptions (also commented re: ordering).
> 
> I guess what makes sense, given the general approach for prefaulting = injecting
> a synthetic read fault, is for the expectation to be that it matches the
> behaviour of an ordinary read fault.

Unfortunately, what happens in this case is not as obvious as it sounds,
because a read fault on a memslot backed by guest_memfd maps the GPA with
read *and* write permission on arm64 (if the memslot is not readonly,
haven't checked what x86 does).

Thanks,
Alex

> 
> Or do you feel that it makes sense for the pre-faulting to do something special
> in these cases and establish a sensible invariant?
> 
> If the pre-faulting does indeed dirty the pages, you'd need the dirty logging to
> do its usual thing (not familiar with the code, so I'm guessing logging the page
> :) though right?
> 
> --
> Cheers, Lorenzo
> 
