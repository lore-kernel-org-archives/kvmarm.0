Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8822848A3
	for <kvmarm@lists.linux.dev>; Thu,  9 Oct 2025 21:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760045226; cv=none; b=tJWj7UIgN5sTiQ4sZgoZ/nL9R6J5q+Bw87nomCYUVdL3OdCUDHTOFZKQklLtpQYnqpt5+/AQ58aoDR2tvQ5pjjbMBUM4iEoiNtR68VqJbuMGzqvb1osbaMjzMhf2dtbaaV2xSOH4t5/ZLKPUtdhv1cBAJj/lBjTRCladBZey2oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760045226; c=relaxed/simple;
	bh=QUyhg2tPz5e6+QEJVc5tbnozxAJnMMfwwidrggXUHNo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d8YKHXBLI5wazsqaDGCJY/VWm0zgO6ZE/PEd1s1gNAC6liAt0zedGgDa4xWfrKBM4NjakpYW5QjcTpAIKRyxHJBTJJoOdkzKIwNYGNtWNvVyp7a7OqiG7lWznd1esWJIc3yCFanxyMeW+KMfW0s5aYzjbbWXKIIkz+D45UD9i14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZuU04+qy; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZuU04+qy"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-78102ba5966so2093523b3a.2
        for <kvmarm@lists.linux.dev>; Thu, 09 Oct 2025 14:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760045224; x=1760650024; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VyG7Vshnn1y3ko5tY/OsDeeGP+hnaQE19ZgqRlKar30=;
        b=ZuU04+qykn2ppLrrm32aHQTpw8JEUecswO1T9KWAyOC5GMAjLhrfDlYosl9TuJdWYb
         VCQCjiEaDJ2AurH1ijRfownZbISI7EXBCf5sHxjMBQiqzKWI1qBXf7PO5VCIBgWmEyhd
         0sEV8GGhz8Fdw+1+0gN2oo1+88x/Yd+KcTiit6j2IQRO4Ufa/Kco6f8k+E4YgWjaoS8T
         MMt6vcs2vXhEav3K4SLIVVA3dSkstnUHJ/3XbuAtmTffsgHY/tIy1Mj9YqzgbMESzIHs
         2qQGLoXXiBz4PMn5JgZJimKDi8YwA2AZDwkSgOIXcnkSOwSqXYsx7lfIaKsGCAlZLFXD
         82pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760045224; x=1760650024;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VyG7Vshnn1y3ko5tY/OsDeeGP+hnaQE19ZgqRlKar30=;
        b=PEhJ38twIQWMx4AoyNzKdszGK5W5aEnA6s2QjbomVIB5HQ7BcmAlZ8DvBVjhcH1L00
         v2t+EvHt/71SXpnC5JsGy2k+t3t7nqx8imXejuZCx0Hy5+hDZTH7jmkHeXpQzwfz6DR5
         oVWmXHi4nlOo2fmLvUM594REGo1gxxHwdQUwdNyQK2fGr12xNzDy/dXPvTwOG6d1lN8v
         xAMt5cbxdxHUZ6DWjheYjH1qJDaqSMBlACT5Wdz+i57onFFg+qmbMlb8hciFvaciQPvJ
         RkimRdzVb+ZKw0tzpr5nLJUUyka1Mb3QZtYiNVQfW8tnsGDL2/Xi1a7z5+qY+HVUYnhe
         s9FQ==
X-Forwarded-Encrypted: i=1; AJvYcCW6U5cyfFiZnl8pTa/U+RrNfmHlYAxt5Y37Gj0/7/jVi+73+nq9ycQNVqQG20kwJx8Ody/sU8g=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxt4YM5DuckbLvRZG7/a2ZgvqWjDuqc4G74LVu3Dtof63NsRYUB
	e4CCUgcSsXK7RPAXGqSD9cQUGQt5sdYSykQxe8vvV2AiV5PEQkvT0j9s+WmdyfK4A+seGHSJbsZ
	j3w5753EP9+a2JOIxTCvx+Fi/LQ==
X-Google-Smtp-Source: AGHT+IEXSCT7Ge93/eS1ZLL+wIsHzqCvUWVK2zdip6A/DIomUySbaHDcPWrDH/GuqrKumWfw/V6m+o1hEtdfCxTDkQ==
X-Received: from pjbms8.prod.google.com ([2002:a17:90b:2348:b0:33b:51fe:1a80])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:33a6:b0:32a:6d26:fb5a with SMTP id adf61e73a8af0-32da80b8305mr11558495637.4.1760045224327;
 Thu, 09 Oct 2025 14:27:04 -0700 (PDT)
Date: Thu, 09 Oct 2025 14:27:02 -0700
In-Reply-To: <20251007221420.344669-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com> <20251007221420.344669-3-seanjc@google.com>
Message-ID: <diqzwm53hil5.fsf@google.com>
Subject: Re: [PATCH v12 02/12] KVM: guest_memfd: Add macro to iterate over
 gmem_files for a mapping/inode
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Add a kvm_gmem_for_each_file() to make it more obvious that KVM is
> iterating over guest_memfd _files_, not guest_memfd instances, as could
> be assumed given the name "gmem_list".
>

Can we also add to .clang-format:

diff --git i/.clang-format w/.clang-format
index 48405c54ef271..e4df86f2d3cf7 100644
--- i/.clang-format
+++ w/.clang-format
@@ -541,6 +541,7 @@ ForEachMacros:
   - 'kvm_for_each_memslot'
   - 'kvm_for_each_memslot_in_gfn_range'
   - 'kvm_for_each_vcpu'
+  - 'kvm_gmem_for_each_file'
   - 'libbpf_nla_for_each_attr'
   - 'list_for_each'
   - 'list_for_each_codec'

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Ackerley Tng <ackerleytng@google.com>

> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/guest_memfd.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 3c57fb42f12c..9b9e239b3073 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -22,6 +22,9 @@ struct gmem_file {
>  	struct list_head entry;
>  };
>  
> +#define kvm_gmem_for_each_file(f, mapping) \
> +	list_for_each_entry(f, &(mapping)->i_private_list, entry)
> +
>  /**
>   * folio_file_pfn - like folio_file_page, but return a pfn.
>   * @folio: The folio which contains this index.
> @@ -159,13 +162,12 @@ static void __kvm_gmem_invalidate_begin(struct gmem_file *f, pgoff_t start,
>  static void kvm_gmem_invalidate_begin(struct inode *inode, pgoff_t start,
>  				      pgoff_t end)
>  {
> -	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
>  	enum kvm_gfn_range_filter attr_filter;
>  	struct gmem_file *f;
>  
>  	attr_filter = kvm_gmem_get_invalidate_filter(inode);
>  
> -	list_for_each_entry(f, gmem_list, entry)
> +	kvm_gmem_for_each_file(f, inode->i_mapping)
>  		__kvm_gmem_invalidate_begin(f, start, end, attr_filter);
>  }
>  
> @@ -184,10 +186,9 @@ static void __kvm_gmem_invalidate_end(struct gmem_file *f, pgoff_t start,
>  static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
>  				    pgoff_t end)
>  {
> -	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
>  	struct gmem_file *f;
>  
> -	list_for_each_entry(f, gmem_list, entry)
> +	kvm_gmem_for_each_file(f, inode->i_mapping)
>  		__kvm_gmem_invalidate_end(f, start, end);
>  }
>  
> -- 
> 2.51.0.710.ga91ca5db03-goog
