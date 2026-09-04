Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563011BC2A
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 00:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788482197; cv=none; b=Qfc6NcgJ3opbco8/MiisRSlCW336DrxXi52qfGSVcDwVgckvp9fxWE5NePmeN0cfsuUl1LPjbBKWKfa+TfzHJyhZHWxFSay+iFqpL1HThAptOqX6ETBVbih8Z8PaYvvohIRvd4E4Hgue0W5OyOPSUYYODflVFwTzJUXvb/wz0hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788482197; c=relaxed/simple;
	bh=x5LDPsdvbXimywbzcLmSFkCU3DoJpJnex4rJgmAGAVE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OftRIBCPLqFOPzzn1IUNACRkJ7mONKY/c0x3OAlSFCa1PeM+JRZeLobHRUu4sMqaQ8agozoGqOmIq3fVujZUKrvxZ9R6aOQVwOMiyFO72cMJ+8vv2RBOytI1d/ALo1V9tY/D+oz3GIPDN/9kygaTrvbqYXAweW+lZBrHzU/S8Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZHD3+8HY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZHD3+8HY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788482195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f6GMexSWWuoc9Cddr8yMae7nQERhafauV/Q+TnV8uPo=;
	b=ZHD3+8HYAOqVcONtAwigZHibYQ7EZQJrHoVpmAUCOvS3RuyRAZ82FD0J2zgFlQBIWMCvXo
	4603P2X2mOO5eNjQDkM8WTQak4yD0DJ1xNQ4RvJUMP9WJyP1t5DzJEzwxrZS2vnwhsxVBW
	uMTu+ke9y4oOBnkLzabzkrvp6S3Nhtk=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-BWkoiCaANP6_EIuiIBdAlQ-1; Thu, 03 Sep 2026 20:36:33 -0400
X-MC-Unique: BWkoiCaANP6_EIuiIBdAlQ-1
X-Mimecast-MFC-AGG-ID: BWkoiCaANP6_EIuiIBdAlQ_1788482193
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-398dcfabbf8so1008396a91.0
        for <kvmarm@lists.linux.dev>; Thu, 03 Sep 2026 17:36:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788482192; x=1789086992;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f6GMexSWWuoc9Cddr8yMae7nQERhafauV/Q+TnV8uPo=;
        b=DgDfxUiA0sKAsQ/JgROQN4ZmrW87m5kpFOmY2+NsmiDuxz8pHeKtQ27skOOwbZbcxG
         Vtj2SWh4R5yikaV7wZ4cvMuDZ4s7M670X0wNmUUqT/mSZJKYBMXoj83V8hiNaxX/keCs
         YiUJ9B+We73SAioDQfSu3TcN8ylpnGJC2tXTGD1YJqY9Ep0eYTS9vffqQtRbggvPtLDv
         ddhDXF9NscMYEiTACa5TwLanB3+Mzukn/eEkkTUZFzm5VkUA/n92lZSp3WO90FSdEYvk
         uBt/sfHQXTXaecs+WBCEl5tANCQoVURk2JfIMZ0wSHQ9tJGN8bStnMTPgju+gOBk5B3v
         uy/g==
X-Forwarded-Encrypted: i=1; AKwUvBxqKrVzoCE1FDLyn7crc1aCpRobG1Rd9nl3I6JhmZ67TDn+UwNLnyi5u1aSqxo7xUjtJwcgma4=@lists.linux.dev
X-Gm-Message-State: AFuF++la+Z+a5ktm9nxi1eP2G39KFXzJIux8FiO4kaxaPMxlLcdN5HW/
	qXyUcXsBrQIq5W57DVDleWr/E260yP2lyVF8VvoHhgKCzPWhPAuPRP1oOz7xRW9MFuYks6tpuLv
	xrASNpDF0BSjO2++HGbNj5v8wApnBFm7Q48/AnC9ymNen7uRdI0ANoBHkxyYmS9Mw/w==
X-Gm-Gg: AYBFou1GKvScAjBjt/yTDUfL5HWtG/HAm/+XLrqmBz9Q845SYF6vaVm8VBMipEUNgL2
	ZSdtTwReVQHkq1sen7Drc1RXmY2xYeKruDhMEs4xLKFEy4hBF2Dwmt8aU/359sIxlWcgaqk+hIv
	Xznxhea28/czafKL76nBTziAyw12nhsy4gjC+oaHizZ1QC217ri3kNMB5bhzVjs43p8Jj3ThkSs
	i51+gdsisOT68DdPcusYhg4xmodwOXBQqYomCn+iMGB6wJcNa5wB2e/cmvjdoCs1r0YGgfc0eQh
	Gy+Vp1wI7sJOx0hc68x7f2962CHISyVMX4nDoMHMnMktxY2tHRj94J/aKICZ6XDMk7OGgRnrS5l
	xj+/e18TGQJYl5bOVHuXMokEd/Qna/ORA3IPKXTCnzQ==
X-Received: by 2002:a17:90a:c106:b0:398:e1f4:bda1 with SMTP id 98e67ed59e1d1-39b2624cf3fmr3925672a91.21.1788482192419;
        Thu, 03 Sep 2026 17:36:32 -0700 (PDT)
X-Received: by 2002:a17:90a:c106:b0:398:e1f4:bda1 with SMTP id 98e67ed59e1d1-39b2624cf3fmr3925599a91.21.1788482191942;
        Thu, 03 Sep 2026 17:36:31 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339b8f44d7sm2233190eec.22.2026.09.03.17.36.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2026 17:36:30 -0700 (PDT)
Message-ID: <a7fb4f62-bc2c-49f9-848f-9f64235f95a1@redhat.com>
Date: Fri, 4 Sep 2026 10:36:19 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/5] KVM: guest_memfd: Stop returning struct page from
 PFN lookup
To: Ackerley Tng <ackerleytng@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>,
 Michael Roth <michael.roth@amd.com>, Brijesh Singh <brijesh.singh@amd.com>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, David Hildenbrand <david@kernel.org>,
 Yan Zhao <yan.y.zhao@intel.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 Vishal Annapurve <vannapurve@google.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20260826-gmem-no-return-page-v4-0-3bb9c1ddb4e3@google.com>
 <20260826-gmem-no-return-page-v4-5-3bb9c1ddb4e3@google.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260826-gmem-no-return-page-v4-5-3bb9c1ddb4e3@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1KKRGMAfr1x8utMdGR386kvvNYAz-djAJRZ9Z27FZi4_1788482193
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/26/26 7:01 PM, Ackerley Tng wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> KVM currently expects guest_memfd PFN lookups to return a refcounted struct
> page, which callers hold across fault handling.
> 
> Drop the page's refcount before returning from kvm_gmem_get_pfn() to
> prepare for the in-place conversions series.
> 
> CoCo shared-to-private conversion handling must inspect folio refcounts to
> ensure exclusive ownership by guest_memfd. A concurrent guest page fault
> taking a temporary reference on the folio causes conversions to fail due to
> an elevated refcount.
> 
> While this refcount is also taken on host userspace page faults, that
> refcount is taken on behalf of the host userspace page tables. This
> refcount will be dropped when conversions unmaps the page. Either way, once
> there's an mmap() or userspace mapping, the pages are open to way more
> refcounts, transient or not. This patch focuses on just dropping refcounts
> before handing KVM a page.
> 
> guest_memfd already notifies KVM of page invalidations, so callers within
> KVM only need to respect the MMU invalidation protocol to safely rely on
> guest_memfd for page presence.
> 
> Since the page refcounts are dropped, don't return the struct page pointer.
> 
> Not returning the struct page from the guest_memfd PFN lookup moves KVM
> closer toward supporting memory backends that are not backed by struct
> page.
> 
> Here are some notes on the cleanup in the callers of kvm_gmem_get_pfn():
> 
> kvm_release_faultin_page() in ARM's gmem_abort() originally also serves to
> set the page dirty and accessed under some conditions. The dirty and
> accessed flags don't matter for guest_memfd anyway, so it is safe to just
> drop the call to kvm_release_faultin_page().
> 
> For ARM's kvm_translate_vncr(), the local page pointer must be initialized
> to NULL so that the shared cleanup path that releases faulted-in pages
> safely no-ops for guest_memfd.
> 
> For x86, no additional changes are required in the MMU fault path because
> the page fault tracking structure is zero-initialized at the start of page
> fault handling, ensuring the refcounted page pointer is already NULL.
> 
> Reported-by: Yan Zhao <yan.y.zhao@intel.com>
> Closes: https://lore.kernel.org/all/anZ4W9o5pTWIEgMY@yzhao56-desk.sh.intel.com/
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Reviewed-by: Michael Roth <michael.roth@amd.com>
> Tested-by: Michael Roth <michael.roth@amd.com>
> Tested-by: Yan Zhao <yan.y.zhao@intel.com>
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>   arch/arm64/kvm/mmu.c     | 4 +---
>   arch/arm64/kvm/nested.c  | 4 ++--
>   arch/x86/kvm/mmu/mmu.c   | 2 +-
>   arch/x86/kvm/svm/sev.c   | 8 ++------
>   include/linux/kvm_host.h | 6 ++----
>   virt/kvm/guest_memfd.c   | 9 ++-------
>   6 files changed, 10 insertions(+), 23 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


