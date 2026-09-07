Received: from esa4.hc1455-7.c3s2.iphmx.com (esa4.hc1455-7.c3s2.iphmx.com [68.232.139.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0F32D879E
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 21:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788816303; cv=none; b=RslEASfw0TD04XCMsg+z5A5ogQwVe+8N8M/tIXje/g779FlXt6fYC5qVy2tvWxXxioRD0dhFsop+zrqbf9ihtkHWfQZo94pPm5AIow0JxCL50I1uyCXjM/5e2rGYLpNNqaFiqME/0bsITGcyoktjDFQP3wQt7qn2zTYKi0BMMSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788816303; c=relaxed/simple;
	bh=sP6TqseWnq6F/rMwkPdxmagtSOyUxPFFpE+5Nu3dPv0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O71pJC4FN/Vmpp0uMnVR1p/feIGiVKND/y3kMvTR56BdXfM6CUG403AIwwHXbL7hyYlZM+rlULSNDMXGVgC7rq4YMt6EwzCYnNhO1P2ymwLhEtWOiOQdEMR5D8orM53Qukt37WGIp35rKYf5bvGtXlllVSpD3joyO0ADeJfZ5Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=NWRqyEC0; arc=none smtp.client-ip=68.232.139.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="NWRqyEC0"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1788816306; x=1820352306;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sP6TqseWnq6F/rMwkPdxmagtSOyUxPFFpE+5Nu3dPv0=;
  b=NWRqyEC0IJc3e+2rAXnuJAO8u3P1H/ouScmoVXzxEATQfPaDlkS8n6og
   2ar3ZjFhObiAhqZJyTSkm6N0d14GEPpTzvyWZOLqSCctowPuAx3fj4LW3
   KXux3miKLdJEvBiYanc/O8WHE31ERO7bCBjc4wKIEp7AbRmpoNykl3wCH
   qsK33dxI3JeNqpiL9Slb/mESmEWNEvP+mwHciybW67KJMGdo0LCZpJju1
   Ranvc9dJL+2HKzuV78hy+UBqGLshzn6dY81PwUE3S7ERABq6y8r3ZitL8
   oDBaw/jQ6t6Qo+wJNePYxKqMbljnKB7mXAalfwgoW0LElU8D9uw6zrN8f
   w==;
X-CSE-ConnectionGUID: oNC++1q8TP+xpiq1NJgZbw==
X-CSE-MsgGUID: BrbrQ6paRfuoNDvSaJHoCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11899"; a="253728455"
X-IronPort-AV: E=Sophos;i="6.25,268,1779116400"; 
   d="scan'208";a="253728455"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa4.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2026 06:24:58 +0900
Received: from az2uksmgm3.o.css.fujitsu.com (unknown [10.151.22.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id F1989C020D9
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 21:24:53 +0000 (UTC)
Received: from az2uksmom1.o.css.fujitsu.com (unknown [10.151.22.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm3.o.css.fujitsu.com (Postfix) with ESMTPS id 9FBDAC00767
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 21:24:53 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmom1.o.css.fujitsu.com (Postfix) with ESMTPS id 641E81800170;
	Mon,  7 Sep 2026 21:24:48 +0000 (UTC)
Date: Tue, 8 Sep 2026 06:24:45 +0900
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Takayuki Okamoto <tokamoto@fujitsu.com>
Subject: Re: [PATCH 2/2] KVM: selftests: arm64: Add 52-bit VA guest modes
Message-ID: <ap8rnTINMJQqfYGL@sm-arm-grace07>
References: <20260826-arm64-52bit-va-v1-0-14ec98211363@fujitsu.com>
 <20260826-arm64-52bit-va-v1-2-14ec98211363@fujitsu.com>
 <CA+EHjTyJpPd8HjaWBw0V6pHF9UR0w2UFmaKDe7U3O+Sj8wiyPg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTyJpPd8HjaWBw0V6pHF9UR0w2UFmaKDe7U3O+Sj8wiyPg@mail.gmail.com>

Hi Fuad,
On Fri, Sep 04, 2026 at 09:45:30AM +0100, Fuad Tabba wrote:
> Hi Itaru,
> 
> On Tue, 25 Aug 2026 at 22:18, Itaru Kitayama <itaru.kitayama@fujitsu.com> wrote:
> ...
> > diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
> > index 9108e14a9b5b..bcdf670c9eb8 100644
> > --- a/tools/testing/selftests/kvm/lib/arm64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
> > @@ -46,7 +46,7 @@ static u64 pud_index(struct kvm_vm *vm, gva_t gva)
> >         u64 mask = (1UL << (vm->page_shift - 3)) - 1;
> >
> >         TEST_ASSERT(vm->mmu.pgtable_levels >= 4,
> > -                   "Mode %d does not have at least 4 page table levels",
> > +                   "Mode %d does not have >= 4 page table levels",
> 
> Patch 1 added this string one commit earlier. Could it go in with the
> final wording there?

Surely, will fix in v2.

> 
> ...
> 
> > @@ -298,10 +304,14 @@ struct kvm_vm *____vm_create(struct vm_shape shape)
> >
> >         /* Setup mode specific traits. */
> >         switch (vm->mode) {
> > +       case VM_MODE_P52V52_4K:
> > +               vm->mmu.pgtable_levels = 5;
> > +               break;
> 
> This is now the deepest mode, so page_fault_test.c's sizing is stale:
> 
>    * VM_MODE_P48V48_4K is the mode with most PT pages; let's use
>    * twice that just in case.
>   pt_size = 26 * guest_page_size;
> 
> The margin still covers it. Could pt_size come from vm->mmu.pgtable_levels?

I'm not the author of the page_fault_test.c for arm64, but so I'm
guessing here; per the comment in the test, I dont think total number of
levels determines pt_size, rather by the addresses prepared for the
test.

This stress test does not require high virtual addresses, though should
we update the comment while at it?

Thanks,
Itaru.

> 
> Cheers,
> /fuad
> 
> 
> >         case VM_MODE_P52V48_4K:
> >                 vm->mmu.pgtable_levels = 4;
> >                 break;
> >         case VM_MODE_P52V48_64K:
> > +       case VM_MODE_P52V52_64K:
> >                 vm->mmu.pgtable_levels = 3;
> >                 break;
> >         case VM_MODE_P48V48_4K:
> > @@ -322,6 +332,7 @@ struct kvm_vm *____vm_create(struct vm_shape shape)
> >         case VM_MODE_P48V48_16K:
> >         case VM_MODE_P40V48_16K:
> >         case VM_MODE_P36V48_16K:
> > +       case VM_MODE_P52V52_16K:
> >                 vm->mmu.pgtable_levels = 4;
> >                 break;
> >         case VM_MODE_P47V47_16K:
> >
> > --
> > 2.43.0
> >
> 
