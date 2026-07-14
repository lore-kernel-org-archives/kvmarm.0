Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23B743B3FF
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 08:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784019418; cv=none; b=KogI+ccnO1NLjymvUZ6oW6j7ru8OiW7JeQqRMXE4xjbS5p4P/2//Wsv2496cD3larMu7A1WNHSrFHSYbb24+xXWOhpTCPRCIMqRH8ulIrlDreYMMqvo5mkTZ9D9j3h/gnGd5ugB/TmdSnXWp95De41YMSt58TpdZK2AC9OW+Zl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784019418; c=relaxed/simple;
	bh=Bzdu5b5y55NorpL/qYxPJhHOrlRCKuhOC+OyuSYeTXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OnjjH45aPxOH4DJGA7HYG+Bc15llpMonZznG1dulYB1YdeXRXIRS2HX+14gblnNd5FzS/Qw1bHiE0Qhroez9vHOI/ej7c//3r/D2N2QFZlYijzkpKZ8qJGmxiJaaWe1mCYpt0WjXkSfr98CLNGTbW48TiFAnYh/+u1ZNaIVPQ7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K0lAVd4Y; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K0lAVd4Y"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-493b8d99342so40605e9.1
        for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 01:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784019415; x=1784624215; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QyZuaZgVMmJscBeBh04gUUQoTYZ+pKlntaOnTL9z2uQ=;
        b=K0lAVd4Y3oPghYqS6FR3C2OjEW7e8wVg5zaG4muLP0kYfDrNfJos/v0cs3xghN6gDZ
         obTQ8pnptuILZQokAjdo8KMqn7p6KbVKZWiTYzqp9q9Bh43gxRAPa6HCRXHN8gMMWsXW
         LKDQBx/TkTZ8OaMpwO9aEjqMRzC70XDChMWgaVf2uir5K1Zy58Ub9l7n4pqyQxB1QERC
         b6Uv9xi4KaiJTF3VktWLWvMzLoo1IaaoW4h5n/HKnuTxKhF3p4T/Q9X4PHxsM9NwwjjS
         yHKFc0Hm2GMN481/xeiGfWddq9IfkW7Cmz5lslSAxx4xF8L6+J0VYMuEou6Wkz1dtJCs
         F03A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784019415; x=1784624215;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QyZuaZgVMmJscBeBh04gUUQoTYZ+pKlntaOnTL9z2uQ=;
        b=rhhHHT60E38Acstb8w7oKB6UKpIvws4IaH2zUjO4mZUtjc2SbxeohBeQgpR+uYlRVh
         plYO4+jmznqU6EK5Xihc5WH2pXgcwlpn9XOaQ0G+WNgEW6DwPehzKUU0oCsm3AJfWEjv
         drCSMwbWQzl0RYOdaEJMZlDW2yp0rJzxMQ/+eZuxrF54G/Bq10yEz3faCi8EB8r4sXRP
         AHSpbLUWx96DT0pS6FM7ZfV5DrfyDsCBUcCkYB5XrCOxQvJVxJq3Io5htgp3gSA/exIZ
         oUP0u++YgFd98U0sOIUrVMw9yOQagugsqW6Vb7DE2F5RJwAgoHugCOSQeXJ/dJFOBIYO
         vkPQ==
X-Forwarded-Encrypted: i=1; AHgh+RqGHkj9iNUqZRDMKRHSHd7OV3CfjuMcaV0JpB4fKslI9ObsRmx0wseJ9cwRTOzDoYm5vKn01M4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzFRodWtiGbjL1AlKh+JRgy6YfFlntOlNcKLGq+VnTYII812c5N
	olvF//5croaKVFwrEWTkW2wIHLqQvcsgRAJODAwy61mzUikfxx8sb9iLnLaI4Y//Uw==
X-Gm-Gg: AfdE7ckjWt+nx71VCNjo3M7WljiTblWE8NZqG3OO8M3eN11wOMTL8BCscR8dWYecv9C
	+PX/zKxvi77wZ/N0UHab8awf4UvTmMeVnlvVtJ/0CQ4KafbbEH+/nZZtO1UlTHe5k1WUM8k3HO9
	Tc60oFI30WpCviiefuFXAV+NNqFNS1m+tt+C15+eIk38+ZTENAEFKFPql15c/t2THJ3HBmzpWzC
	Lqmjx129svsxgitivDUT2Ei9pFzwKVjp9jdb0dzw+PpwB2FJR0tTmk8jOxcIlSLydKxzanbh1iI
	GbRi86wb0boxWAb9VBhqDZNyVrAl3RU97xI1m4cOD8dREkTsKKLqtwf+yu1g0Ti5Tt/pQxCm091
	UcjpTCYsDaVpZbGC20vAjOfdsBJTOILvvGXWLv8FMVor+RrxpCq6F/zPau8Hk6ILER57BINBqFk
	iL+WDnfGxKTz1GVh4rOAbtVPYBkEN0ZHP/ufc+VlVerGoJkBvP
X-Received: by 2002:a05:600c:8b6f:b0:492:668f:410c with SMTP id 5b1f17b1804b1-494688928b1mr1719985e9.10.1784019414601;
        Tue, 14 Jul 2026 01:56:54 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4950a2f9402sm64121965e9.13.2026.07.14.01.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 01:56:53 -0700 (PDT)
Date: Tue, 14 Jul 2026 08:56:50 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	jgg@ziepe.ca, mark.rutland@arm.com, qperret@google.com,
	tabba@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 08/25] KVM: arm64: iommu: Shadow host stage-2 page
 table
Message-ID: <alX50s8IglxiEHMB@google.com>
References: <20260501111928.259252-9-smostafa@google.com>
 <alTnAy7jvjUamwUA@google.com>
 <alTvf7iiOWn4PKE8@google.com>
 <alUA7zsJO1FGnss-@google.com>
 <alUJa5cbjjqZ8n72@google.com>
 <alUMVU7DYcrvgAYi@google.com>
 <alUsLFBQ5qKFOgwQ@google.com>
 <alXwXRGqECTUZ3ou@google.com>
 <alXzcrnxWADIEL2H@google.com>
 <alX3nHLykNc_nng5@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alX3nHLykNc_nng5@google.com>

On Tue, Jul 14, 2026 at 09:47:24AM +0100, Vincent Donnefort wrote:
> On Tue, Jul 14, 2026 at 08:29:38AM +0000, Mostafa Saleh wrote:
> > On Tue, Jul 14, 2026 at 09:16:29AM +0100, Vincent Donnefort wrote:
> > > On Mon, Jul 13, 2026 at 06:19:24PM +0000, Mostafa Saleh wrote:
> > > > 
> > > > That would walk the table twice, first time with a massive map, then
> > > > to unmap the pages that was just mapped, issuing TLB invalidations
> > > > for all of those, also as the IOMMU page table code never frees tables
> > > > that means we would immediately exahust the IOMMU pool.
> > > 
> > > Well the massive map is pretty quick we would mostly just allocate the PGD? And
> > > then it would be just for the subsequent unmaps to split the blocks. So nothing
> > > to be freed really and no risk to exhaust the pool. But if you put the calls to
> > > the host_stage2_* functions that's pretty transparent.
> > 
> > Not for the IOMMU, everything is mapped with a leaf mapping, because
> 
> Ha Ok my bad, I didn't get that!
> 
> > the pgtable code does not support splitting blocks, this is something
> > I plan to add support for in a follow up series after this one is
> > merged along side other optimizations.
> > 
> > > 
> > > Just to make sure I am clear. Here's what it could look like:
> > > 
> > > in iommu.c:
> > > 
> > > int kvm_iommu_stage2_idmap_init(struct kvm_s2_mmu *host_mmu)
> > > {
> > > 	u64 addr = 0;
> > > 
> > > 	for (i = 0; i < hyp_memblock_nr; i++) { 
> > > 		kvm_iommu_stage2_idmap(addr, reg->start, IOMMU_MMIO);
> > > 
> > > 		addr = reg->start + reg->size;
> > > 		kvm_iommu_stage2_idmap(reg->start, addr, IOMMU_READ | IOMMU_WRITE);
> > > 	}
> > > 
> > > 	kvm_iommu_stage2_idmap(addr, kvm_phys_size(host_mmu), IOMMU_MMIO);
> > > }
> > > 
> > > in mem_protect.c:
> > > 
> > > int kvm_host_prepare_stage2(void *pgt_pool_base)
> > > {
> > > 	...
> > > 
> > > 	return kvm_iommu_stage2_idmap_init(mmu);
> > > 
> > > 	/* 
> > > 	 * From here, all the changes to the host stage-2 will be reported to
> > > 	 * the iommu driver
> > > 	 */
> > > }
> > > 
> > > On the pro side: no custom walker and we really couple the iommu idmap to the
> > > host stage-2 map.
> > > 
> > > On the con side: As you've pointed out, we'd need indeed the iommu to be ready
> > > early enough.
> > > 
> > > If you want to stick to the snapshot function, could we have the walker to
> > > first walk the hyp_memblock? the .arg could just pass if we are walking a MMIO
> > > region? That would avoid that find_mem_range_from() and I believe would
> > > massively simplify the snapshot walker.
> > > 
> > 
> > I see, let me try that.
> > 
> > 
> > Unrelated to this, but while looking into option#2 I see that
> > __pkvm_guest_share_host() does not call either of the
> > host_stage2_set_owner* so that requires another explicit
> > pkvm_iommu_host_stage2_idmap() call.
> 
> It does! it calls __host_set_page_state_range() which calls
> host_stage2_idmap_locked().

But host_stage2_idmap_locked() does not call any set_owner variant,
so __pkvm_guest_share_host() would require an explicit
pkvm_iommu_host_stage2_idmap() call.

Thanks,
Mostafa

> 
> FTR, I don't really like __host_set_page_state_range(). And we removed it
> recently from our Android tree. Because there's just a special case in
> __host_set_page_state_range() to cover guest_share_host. So we can easily
> replace all the callers with __host_update_page_state() and and call the
> idmap explicitely in __pkvm_guest_share_host().
> 
> > 
> > I still plan to use option#2 in v7.
> > 
> > Thanks,
> > Mostafa
> > 
