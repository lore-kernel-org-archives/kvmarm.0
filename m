Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76A6152DED
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708619326; cv=none; b=SUSbGbST6hpRCdy0T0v1ftTBllNKP7Gpeo9KmQBxiw+UKxSq2mm9aa7rG+q+oiLUi2N1GlJNyPfl7d03yooVjzl9/gDr2d9ixQ3T3Xq4LnrND39jPcu10hdXXOuKPtu4zuUSOJWYme0rfasmQmgRiMqqmTD4a3Bb+hAlgBDpqXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708619326; c=relaxed/simple;
	bh=01Kv48UhZTiRbFa5coyv3Ndk6Pl5j+14Pm9ZDBsB8HE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fXWth8EDwgXMFkHiQlwLu0ETxjoGI8TqEeKxOYMfipKuhm+5jPWpxKypee5/ygOoEiiEFnKChyQqUmdkZw/XXrziSf42aGpvmBJeDBR6OnRGa3+7hCiJocOQ9UWvFIPQVyJAjh94vrK43GheEy5UYuDx2gxlREH0aMmNwRJcCco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QZFnMdjK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QZFnMdjK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708619323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oeyV/h3qwyqimuCrS8DKKkTdRK0sr4x4KyXe1MihyaQ=;
	b=QZFnMdjKCC+UbgQKSJ6deyWdpDkjeD2BJStEtELgWgeHYBoCJtKsQu8ClBXuwTOqePRyw8
	tbhPbI1NkB59OlDtbNtVp2p7Xm49pd6GBDYGksVhGlVMSdCzASass8wy3zG3+Ij2u0JAho
	G5fGfM6GTAYgB/Z0AI4D0E0b072TXj4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-269-sBA0vaMbPMC21wTMCBNx2g-1; Thu, 22 Feb 2024 11:28:40 -0500
X-MC-Unique: sBA0vaMbPMC21wTMCBNx2g-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-33cf68241c8so2956991f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 08:28:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708619319; x=1709224119;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oeyV/h3qwyqimuCrS8DKKkTdRK0sr4x4KyXe1MihyaQ=;
        b=h1ChhRl2563rF2NhppqypImKLzVCjLrj57u/VrAej5/FjOpXjCjfDA1Lb7QJxIeEqb
         dBhNo14AbeR5VlqgSKMt00s92cMZLytQRbda1/z+J5W6uyXe0a+ZnugWqXx75Ce31dBt
         ewfftSQhAtDR4O5pfYWl0OMR8a9wlEjc3wMwOiBY7iID0eMkkj4d4GKx8CO4W9KFEZeX
         8PlNrP/OhQ3DsEEPiO2aNDXcqF5IH426+8VN7WEvctnHeSNuRyskklPTTtZei5hG5wKL
         oC2esZRdrwdBtFaYYT0SGT/CSCqtZlSYO94LSYu3dV0mpm7Tz0jtVvyGTg9P89BQqjsy
         2EkA==
X-Forwarded-Encrypted: i=1; AJvYcCWwq4eLPI6OH3ozYQDhqv3B33El2mM7t9RzNRBDnRTWUZEw/r2cgt/eBVGbb1gzMCquAQZ8HSRhqsZe/ZqvYv9jjDG7v31C
X-Gm-Message-State: AOJu0YzPcNPdkR5+I7xKhWvR+En6OqRjRop/cgOwy9pYLFTO3HVPcngP
	BiatmBvySzjKBXyknHsBfi1otPU34M8dkebQZPmhsjrzLqmnqN9Ar95rT9kNZEPSgRTXj/X+mum
	iGeGBx8cQ3jZeMoaGYjlbAICOz1znqSgrSuztoEj+1m8UTLL1Rcq6yQ==
X-Received: by 2002:a5d:56ce:0:b0:33d:6301:91c5 with SMTP id m14-20020a5d56ce000000b0033d630191c5mr6610070wrw.3.1708619319094;
        Thu, 22 Feb 2024 08:28:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEoECzQRCmLE3DdCH+SmXi/9n4Mi6wiygasCtSki1L4vJ5MLZJDv/tzfJHKI0au8JDOa7FWlg==
X-Received: by 2002:a5d:56ce:0:b0:33d:6301:91c5 with SMTP id m14-20020a5d56ce000000b0033d630191c5mr6610029wrw.3.1708619318638;
        Thu, 22 Feb 2024 08:28:38 -0800 (PST)
Received: from ?IPV6:2003:cb:c70f:8b00:ed48:6d18:2152:1cda? (p200300cbc70f8b00ed486d1821521cda.dip0.t-ipconnect.de. [2003:cb:c70f:8b00:ed48:6d18:2152:1cda])
        by smtp.gmail.com with ESMTPSA id n9-20020a056000170900b0033d5fab6781sm12335002wrc.96.2024.02.22.08.28.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Feb 2024 08:28:38 -0800 (PST)
Message-ID: <86461043-fa5b-405d-bd2e-dc1aba9977c5@redhat.com>
Date: Thu, 22 Feb 2024 17:28:35 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 03/26] KVM: Add restricted support for mapping
 guestmem by the host
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
 mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com
References: <20240222161047.402609-1-tabba@google.com>
 <20240222161047.402609-4-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240222161047.402609-4-tabba@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> +static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
> +{
> +	struct folio *folio;
> +
> +	folio = kvm_gmem_get_folio(file_inode(vmf->vma->vm_file), vmf->pgoff);
> +	if (!folio)
> +		return VM_FAULT_SIGBUS;
> +
> +	/*
> +	 * Check if the page is allowed to be faulted to the host, with the
> +	 * folio lock held to ensure that the check and incrementing the page
> +	 * count are protected by the same folio lock.
> +	 */
> +	if (!kvm_gmem_isfaultable(vmf)) {
> +		folio_unlock(folio);
> +		return VM_FAULT_SIGBUS;
> +	}
> +
> +	vmf->page = folio_file_page(folio, vmf->pgoff);

We won't currently get hugetlb (or even THP) here. It mimics what shmem 
would do.

finish_fault->set_pte_range() will call folio_add_file_rmap_ptes(), 
getting the rmap involved.

Do we have some tests in place that make sure that 
fallocate(FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE) will properly unmap 
the page again (IOW, that the rmap does indeed work?).

-- 
Cheers,

David / dhildenb

