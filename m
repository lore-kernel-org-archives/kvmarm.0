Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5522244A411
	for <kvmarm@lists.linux.dev>; Tue, 11 Aug 2026 14:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786459718; cv=none; b=XCXSScaMqgxnRzlVF5ytLTcNblyaMHW2oULE8AHSKhbC1Wj2QQYg2g+XjRa1oxB1F+Vjl9NtTtgizUhiFCWG1xeuNIlmlkHkXN7/ndzmXhfjcU6qv4aBdaBjtOt1I5Dsm/+1Hhd5uekZ2I1TvvxK6ONavV3QZ5e10CXoIaVrblw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786459718; c=relaxed/simple;
	bh=kC6mE8NpGgNSd4MwTOaZbaSstSPzKrQUvf1uS76/vyk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SInOC7JgfVNeBPcE9dOFYhDUqMmHdKBX/lDVYUNySNk2//ravs4o/PDjBz7aACq5qSWlpTrLu0Fwwc8gk5jxDf3z3jqmNGMM8iJT1gliAW5jKXwM7c9AxvzvonfjLrvgVmBZf3XT/ZHziva2wy1nWkdob/RpDrs6DjN7sYltC48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jnuSsJxn; arc=none smtp.client-ip=209.85.214.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jnuSsJxn"
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cc7e86e7c5so55977705ad.3
        for <kvmarm@lists.linux.dev>; Tue, 11 Aug 2026 07:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786459715; x=1787064515; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rVhz6t6uiOZc1DDgF6HOTd7wvK1RF7/iSTLQV7TuFds=;
        b=jnuSsJxnLdTuCm1YK/oZrlgMESQkgrXr21wNDVfHOjLlZJ+n+5xh26XdIh5iM+yd9y
         TnX5A4Ax9GYJdWoY5YsLgKhE7hIYmTZJKg8Ya4VCU4fPTSQfEPPgcvqqqcHqQY5ideoi
         RDpciAyioKHXAfIyB6Bq99YsLJ37Jn3WOb4uhzks2LnFwCo4PCgtC+klGPcSflSPnKKY
         tKCwMyekh81hTWCDuRi4NJ7baByaXS/26quUGrvhpsOSZJ5y/UlKgJD47ctV+wEOYDWI
         S/0Vyutv6KUwyqJOrPFPpfGXsO1acBBfqfboMvVrMDzo88oyIJVNKz9ydTk+hZ+Lghl9
         OhRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786459715; x=1787064515;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rVhz6t6uiOZc1DDgF6HOTd7wvK1RF7/iSTLQV7TuFds=;
        b=rpWRuANwMXGB2GxWjJrt87JW9tv3VSEytPLk2kf9WdS3eFyrOLNDErPOUCxWNqWBo8
         tqp8xJUSWco2BEpnQYGFSto09N6OJnQsLW1Y969QX6iyAyLzOkiA2qrW4H4LBLtEvaTZ
         OI/VXy2C/wFeRdfueXO3kmtWe5A+Q7QKj5ajYEiWhjzU1hNjLxd/jwlR+qbpW4gfbCjN
         lezZcoyIYCzOHoou80HkXJpa0LJFMsRwcKs/vea3b1CMA8Dl7D0+5CGSCeR0H5+PQQDT
         yp80vn6RKp8X70d/+fpEZXu6Ewe1GRUD6j4TSZRHJMU0k7P5S/RswXTNe3c6VDmZhCKq
         e/lA==
X-Forwarded-Encrypted: i=1; AHgh+RrkenlE3GNECaF6wGjOxFurpMxGpHueNPdwVh575xrqfOPniVtL5WjTrzI1WYXw16dvq8ZyrNc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyQrnWrU5m57wmUI1q6S3zStwl8Pw02Hw7W1MdE76203XJIPpCb
	A3TztfkpmIlfGThJ+DhlPiS/fWM08TkiOfDmyqNajvb0ty+aEnw9d7n7FHeyxn+l+HAuuJsh6ny
	EZJ5Ehw==
X-Received: from plbje14.prod.google.com ([2002:a17:903:264e:b0:2ca:eea9:9845])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d488:b0:2d1:1a18:4d0a
 with SMTP id d9443c01a7336-2d3177a2163mr42800725ad.9.1786459715153; Tue, 11
 Aug 2026 07:48:35 -0700 (PDT)
Date: Tue, 11 Aug 2026 07:48:34 -0700
In-Reply-To: <9huzqzk4zt3n.fsf@tarunix.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-2-tarunsahu@google.com> <anpXjM_lg_UTpl0q@google.com> <9huzqzk4zt3n.fsf@tarunix.c.googlers.com>
Message-ID: <ans2Qvo0453cc_DD@google.com>
Subject: Re: [PATCH v4 01/11] liveupdate: Add LIVEUPDATE_GUEST_MEMFD config option
From: Sean Christopherson <seanjc@google.com>
To: tarunsahu@google.com
Cc: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	linux-kselftest@vger.kernel.org, andre.przywara@arm.com, michael.roth@amd.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, will@kernel.org, 
	vannapurve@google.com, maz@kernel.org, fvdl@google.com, kvm@vger.kernel.org, 
	oliver.upton@linux.dev, kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	skhawaja@google.com, aneesh.kumar@kernel.org, linux-doc@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, kexec@lists.infradead.org, 
	suzuki.poulose@arm.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 11, 2026, tarunsahu@google.com wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Tue, Jul 28, 2026, Tarun Sahu wrote:
> >> Introduce the LIVEUPDATE_GUEST_MEMFD Kconfig option. This option
> >> enables live update support for KVM guest_memfd files, enabling
> >> guest_memfd-backed memory preservation across kernel upgrades.
> >> 
> >> Currently this support only guest_memfd files that are full-shared
> >> (INIT_SHARED and no support for private_mem).
> >
> > Why?  Specifically, why do we need/want a separate Kconfig for guest_memfd
> > liveupdate versus KVM liveupdate?  I can _maybe_ see a KVM-wide Kconfig, but
> > even that seems like a stretch given that (AFAIK) hypervisors are the one and
> > only use-case for liveupdate.
> 
> LIVEUPDATE is used in many subsystem. It is possible to enable
> liveupdate and kvm without enabling KVM_GUEST_MEMFD. So GUEST_MEMFD
> preservation must depend on CONFIG_LIVEUPDATE and KVM_GUEST_MEMFD both.
> LIVEUPDATE_GUEST_MEMFD Kconfig is wrapper on both of them. It need not
> to be visible in menu, So I can make it hidden. WDYT?
> 
> Also, KVM VM_FILE preservation and GUEST_MEMFD preservation both depends
> on LIVEUPDATE_GUEST_MEMFD in this patch series. [PATCH 05/11]*
> Which is wrong. So I will update KVM VM_FILE preservation to depend only
> on CONFIG_LIVEUPDATE.

Or just handle it all in the makefile?  E.g.

diff --git virt/kvm/Makefile.kvm virt/kvm/Makefile.kvm
index d047d4cf58c9..e6f098498795 100644
--- virt/kvm/Makefile.kvm
+++ virt/kvm/Makefile.kvm
@@ -13,3 +13,8 @@ kvm-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
 kvm-$(CONFIG_HAVE_KVM_DIRTY_RING) += $(KVM)/dirty_ring.o
 kvm-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
 kvm-$(CONFIG_KVM_GUEST_MEMFD) += $(KVM)/guest_memfd.o
+
+ifdef CONFIG_LIVEUPDATE
+kvm-y += $(KVM)/kvm_luo.o
+kvm-$(CONFIG_KVM_GUEST_MEMFD) += $(KVM)/guest_memfd_luo.o
+endif

