Received: from esa5.hc1455-7.c3s2.iphmx.com (esa5.hc1455-7.c3s2.iphmx.com [68.232.139.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535A02F6931;
	Fri, 11 Sep 2026 02:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789092594; cv=none; b=Mgva2bNmZjcOOZ5V11G17sImGeESkfoBZ332TiToho0b0nnvF+sV9I4oUwDEfEMZfmfQRVnJt6vQ4NrHNhEcO1hpQ2e5Np9nzDfUZh5HP8CG+NHM9v1Tthb2TBzbToxlR4Si7wfruHUzz3hJWfOtaQjVG5KMDzqSAVxpfjusF14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789092594; c=relaxed/simple;
	bh=AaXl/L7lLDt00UQl/RtkISnRqi4t27mRDo6Utp1VaFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KeoTcjnLWusI5ni/vR/+82GB53K3OYJXFd2zfUDk/MMsJNYQGHnKbyv/yj9ilize0atTIFpYKuD7n8s0HBPPdlzaYFAHhEAJbtiSD62FKzxtgK6w9Ruz6xE5JlRJvpoWq1fQmewn/XaiKjpOzAMZNwfqFJjmh8xu9wsMd4skRy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=LcCRJ2KP; arc=none smtp.client-ip=68.232.139.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="LcCRJ2KP"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1789092597; x=1820628597;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AaXl/L7lLDt00UQl/RtkISnRqi4t27mRDo6Utp1VaFI=;
  b=LcCRJ2KPh7rU/mBVH6KD5cY/Zwri9v8m76U82IQLyXGvnQMSG75oHS21
   jShvQX60m1l223BEi0bwt99Ii1vSwF1byIvQaDwAeMVNHwQOEv0jvwcl/
   spLcWP9KS3LGDb/mS84Qc0iFNk+rVo2Dhsg79dDX/B5bwnB4K5s90bPUB
   z/csHxy4MEmtVhXaJTg/lhNvmLXY4UNaTec8qSCyj+qn5JAKAs4a/KFkI
   +92UjlYdtJp7zrJsoexqLBfX837U6Qxy9nsFQyo0bx1ftjeZNI2SEnSBG
   4nxSMc4UHCBIdLx96qkH3K9JXO/2uw4Gyp7QsEMv97ZXZeJbZmuwAXDHE
   Q==;
X-CSE-ConnectionGUID: QfYO9zGDTBm9khxcELFgbQ==
X-CSE-MsgGUID: rzjh66tlTDGF4KRNZL+orA==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="252853758"
X-IronPort-AV: E=Sophos;i="6.27,96,1786978800"; 
   d="scan'208";a="252853758"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa5.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 11:08:45 +0900
Received: from az2nlsmgm4.fujitsu.com (unknown [10.150.26.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 233C71C00665;
	Fri, 11 Sep 2026 02:08:41 +0000 (UTC)
Received: from az2uksmom2.o.css.fujitsu.com (unknown [10.151.22.203])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm4.fujitsu.com (Postfix) with ESMTPS id C21C4100137D;
	Fri, 11 Sep 2026 02:08:40 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmom2.o.css.fujitsu.com (Postfix) with ESMTPS id 7F15A14000E9;
	Fri, 11 Sep 2026 02:08:31 +0000 (UTC)
Date: Fri, 11 Sep 2026 11:08:28 +0900
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Atish Patra <atish.patra@linux.dev>,
	Alexandre Ghiti <alex@ghiti.fr>,
	David Hildenbrand <david@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, loongarch@lists.linux.dev,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 12/20] KVM: selftests: Add APIs to override memory
 region types with custom memslots
Message-ID: <aqNinDKVoKUSNwXe@sm-arm-grace07>
References: <20260902164123.2546762-1-seanjc@google.com>
 <20260902164123.2546762-13-seanjc@google.com>
 <5x0d1hj1.ritesh.list@gmail.com>
 <aqLZrk6m3NgugzBU@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqLZrk6m3NgugzBU@google.com>

On Thu, Sep 10, 2026 at 09:24:14AM -0700, Sean Christopherson wrote:
> On Thu, Sep 10, 2026, Ritesh Harjani wrote:
[...]
> > May I suggest few changes in the naming of these APIs:
> > 
> > static inline void vm_override_mem_region(struct kvm_vm *vm,
> > 					      enum kvm_mem_region_type type,
> > 					      u32 slot)
> > {
> > 	TEST_ASSERT(vm->memslots[type] == KVM_INVALID_MEMSLOT,
> > 		    "Memory region type '%u' was already overridden with slot=%u",
> > 		    type, vm->memslots[type]);
> > 
> > 	vm->memslots[type] = slot;
> > }
> > 
> > static inline void vm_override_add_mem_region_flags(struct kvm_vm *vm,
> > 					    enum kvm_mem_region_type type,
> > 					    enum vm_mem_backing_src_type src_type,
> > 					    gpa_t gpa, u32 slot, u64 npages,
> > 					    u32 flags)
> > {
> > 	vm_override_mem_region(vm, type, slot);
> > 	vm_userspace_mem_region_add(vm, src_type, gpa, slot, npages, flags);
> > }
> > 
> > static inline void vm_override_add_mem_region(struct kvm_vm *vm,
> > 					  enum kvm_mem_region_type type,
> > 					  enum vm_mem_backing_src_type src_type,
> > 					  gpa_t gpa, u32 slot, u64 npages)
> > {
> > 	vm_override_add_mem_region_flags(vm, type, src_type, gpa, slot, npages, 0);
> > }
> > 
> > Those "_add_" and "_flags" in the function names easily gives away
> > the difference in the APIs, rather than differentiating via "__".
> 
> I am strongly against postfixes like "_flags".  We do use postfixes for the VM
> creation APIs, e.g. vm_create_barebones(), vm_create_with_vcpus(), etc., but only
> because there are so many possible combinations that differentiating through
> underscores is completely infeasible (unless we forced callers to regurgitate
> huge amounts of boilerplace and/or had an absurd number of params), and because
> the collection of APIs is tree-like, as opposed to a single linear chain of APIs.
> 
> For this, there is a much more finite set of possibilities, and the set of APIs
> is a direct liner chain (no underscores => __ => ____).
> 
> I agree that not capturing that {,__}vm_override_mem_region() adds a userspace
> memory region isn't ideal, but due to the term "memory region" already being
> somewhat overloaded, I don't want to have "add" in the name as I think that will
> make it harder to differentiate between the "enum kvm_mem_region_type" APIs and
> the "userspace memory region" APIs.
> 
> And IMO it's totally fine for a function name to express what the API does at a
> higher level, without capturing the exact operations in explicit detail.  E.g.
> __vm_create() (and even ____vm_create()) obviously does a lot more than literally
> KVM_VM_CREATE.

As I have been looking at the direct liner chain of vm_create() for some
time, I agree with Sean. To create with a non-default guest mode ID, we have to
start with those underscored functions, but I still prefer short function
names.

Thanks,
Itaru.
