Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3583033E3
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 18:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291416; cv=pass; b=sD+P4d7iT/20RrpCUUUgfEv5oPTH7ikVhCzBI85logQNCbD5uVdi4X/ljCciOAD0BhLOqVdin6AFhflBXdQv2DfizVUsfhS6ippr28YHpsP5H5muKVIyvSyeiVfp8MpA4cRV9hUKyx6cSjoeFGm8C5xrakRnrpdw2JLjPtv8yNI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291416; c=relaxed/simple;
	bh=8iR09lTQ4Edfh1UQkmolcFNIjMuLzSLKVF5JEj/9nwQ=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XkYUhvRKChiCZzaAvBqKA3Ka05geBJgnCZGGvmIbxer6y3qOxbmjfOEuyC108Ha8NlprujmYBPjtt0G6NvGWXBA05ysF/GTuK/yDXr2xphVOAPco3C3UFJASza14Nm2ZPnHuPSwb9T59/r2+muVjDpzXG2Z67q4dhY66k9jVSzw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eRSB9G+H; arc=pass smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eRSB9G+H"
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-56cc6fe8815so1895978e0c.1
        for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 11:43:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774291413; cv=none;
        d=google.com; s=arc-20240605;
        b=iN7JpzGS8/+WXluJukPB+mdd81uDzDQ9IyWhp0SZ3O4+vu7CU9LoABrCp7MHQsxrB0
         P52ltWR2ZEfqhJfh+XrgCxDGZEFX08phN4jkhQBCWoc0OoVyuU/er/ZTns1LVb2jpev2
         dGIboOc8cs+WANITRwX3E7031+CHk+e76/ynlAlv+cLuSBHXE9U8N8ltL+12ZMjDNYRa
         zqDv0zSf4T6c3onAIOaGx9F4XU8Lfjr/C2gb4CWObv4VpmeAN9j7m53t16ts9diD5kNY
         6XT9JAQgC7dZ48ErIhJ+mlUK1bMLmsFkedt3U1JStawpFFOnfbL5SDMtwxOHV4d9ZIGa
         RdRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=jJ1uKbr2A9AcnUKDcibCUYQIsuprIaoAVD4N5Jh2tIQ=;
        fh=3nHLjI3DYsOrAsuXGQdjiPvGAzd4ZdbFfgIZuc9MaAs=;
        b=TZ9KawanryF09fF36FkF2NqZ46Ob2NzWwhXd8E7fDyp1eV97qIzCBi333EFcIQpIqT
         FsvI6kEtSlW8ZwIbM4AqCsaM9DUqiaCZBoZbynNsxRjwB9P0Z/R+3cuPixIm3OUYlZ0s
         lPkc/UTZEOQ9okWk4zmFGHEGQrPWEM0gLrtUhq/x0eR6PSPBSVA+xPkwd0nQVK695AzO
         2Wfs1vey3tz5jlB7P78phASLvQE5W2IlmKieWNmolMivOEXJ9wSyaeOkH6vz7h6A7/N2
         yarC/EjjsiNjwp8eEoOv+V2gyPPoXn+vMIF3WD/ROiCAF9e0ag4dIemqvdNIxD3wxhFx
         mMVg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774291413; x=1774896213; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=jJ1uKbr2A9AcnUKDcibCUYQIsuprIaoAVD4N5Jh2tIQ=;
        b=eRSB9G+HqmT/icxNG57TC/y+Vshq1N2Saqu8vCqnixOC4XBYrWDwdncpkjopa0cWVJ
         MfW9DeIdezgKncXj9t47GZnvB7yoycBCuF+gkzH0oA6JFvnqYMg0/4xZHVl9ze3A9Go1
         PYvLH62CwkUjUUq90nPSDvl8zYwuMamNbY6LBBk8Y+JrczaH1/RVCaZIZ5mZxHwsr3V9
         MY8mSBYizhJ6v9+SGomveD0qbNwxiR182wEPIQLfsQMtmFz74OXTQIAs7W/GN+JUygnE
         HCjBz0RIbnXYmrQj4liLpsccHJousGvlgLlKGDD8rMLlRzCp6AA9yMyt/XLkwqCIoCId
         Qn6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774291413; x=1774896213;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jJ1uKbr2A9AcnUKDcibCUYQIsuprIaoAVD4N5Jh2tIQ=;
        b=dorO1NOyZ4+zGapo5XG8NRmKY3lF+VoiiqF/Lulap8qRJ+8165wdkHoamajmJqlkz9
         GK6id/7t41S5gWPn4NUU6Abi/bALjltfgsHYXmY+0yT0U+1dddAA85FFkjl76dLxVoxu
         2PspnfodLNrsAGhUCYgQrCrKeFMWnP0RM5Yqy7lUNksNnQMitnErW6mhSPnMzL4lvABA
         UM2lR41K+Gomsdpu4IYwx5MVF5nlZsodhwFz06AvkLyHaaH3INtu8kTUAt6xcg1YC3zM
         FMD4kGp/JJRdbnrEa4Oc3bWYVVfrTSQkTtOSlo6ivYTBzq1uBJK4zQIax7CsW2UidnwN
         Vh4w==
X-Forwarded-Encrypted: i=1; AJvYcCU0f1edttA8YgwoYYvuZtZ2VXf3s4q2CQB5a6jawma+0tS4O42M1UhIuap1OCdqlrqrGafn03A=@lists.linux.dev
X-Gm-Message-State: AOJu0YzuO5zJCtuUhzQ9GDPQ++6AYAZao9CQpFtBlvvn51ic01Hkpltm
	oK1avN63AjNp6w2dxDX7EPhEDtLZuH2c/kDbe8z+gZ7kpi3yuju7iv61rdizyKlrcbzpKbkXADT
	HyZssVtNMupFBDwfo0usQdPLbB+QJhhPClqC0VzGQ
X-Gm-Gg: ATEYQzxwtGEXe/ty0s5ZI0Ax2aEWnQ7+K0AhVmHDEAyXL23TzYqfLYFPmFQR/BXROfd
	l4+Wf62SL8UMI6ESkTgn/RlISNqXjZpcjuoueic1hqMGeDsevf845EE9GN3tUAi56rbqzigZ2tu
	36OwnCNt79B5TcCMIQ8+IozY2tKVr2oSYcGhcccE/+m3iY+486c0Vr5Yxg7nlB4n1F6zPhZU99D
	wC0Iu677eAj1N3nv/tE6NilmH1S5oaBBwvO/rYxkpE6v0Ss58VRBUi9OaanQm4REz4wzFuXOwbO
	VoFcQWCNOAvZz9Mxvkynh+obgr0hU3z9NiJpsLGHmpYo1ZOYzkmn7h+SkD9flvhdBky5Og==
X-Received: by 2002:a05:6122:3c54:b0:566:2711:d8ab with SMTP id
 71dfb90a1353d-56cde344094mr6273796e0c.6.1774291412097; Mon, 23 Mar 2026
 11:43:32 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Mar 2026 11:43:31 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Mar 2026 11:43:31 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260317141031.514-3-kalyazin@amazon.com>
References: <20260317141031.514-1-kalyazin@amazon.com> <20260317141031.514-3-kalyazin@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Mon, 23 Mar 2026 11:43:31 -0700
X-Gm-Features: AQROBzAKG1Xpk4hVDWY3sqqSXNvIKws3qrAExzeSImrnNlU_ii0wYSbiIV_SQDw
Message-ID: <CAEvNRgEFBexkZCjOMFHJRQFHOpiUezD2jbfDVFrGhYXODdpMjg@mail.gmail.com>
Subject: Re: [PATCH v11 02/16] set_memory: add folio_{zap,restore}_direct_map helpers
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "kernel@xen0n.name" <kernel@xen0n.name>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "tglx@kernel.org" <tglx@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "vbabka@kernel.org" <vbabka@kernel.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, 
	"jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>, "riel@surriel.com" <riel@surriel.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com" <jgross@suse.com>, 
	"yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"coxu@redhat.com" <coxu@redhat.com>, "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, 
	"yosry@kernel.org" <yosry@kernel.org>, "ajones@ventanamicro.com" <ajones@ventanamicro.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "tabba@google.com" <tabba@google.com>, 
	"prsampat@amd.com" <prsampat@amd.com>, "wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>, 
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, 
	"alex@ghiti.fr" <alex@ghiti.fr>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>, 
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"pjw@kernel.org" <pjw@kernel.org>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"thuth@redhat.com" <thuth@redhat.com>, "wyihan@google.com" <wyihan@google.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "urezki@gmail.com" <urezki@gmail.com>, 
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, 
	"gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>, 
	"jiayuan.chen@shopee.com" <jiayuan.chen@shopee.com>, "lenb@kernel.org" <lenb@kernel.org>, 
	"osalvador@suse.de" <osalvador@suse.de>, "pavel@kernel.org" <pavel@kernel.org>, 
	"rafael@kernel.org" <rafael@kernel.org>, "vannapurve@google.com" <vannapurve@google.com>, 
	"jackmanb@google.com" <jackmanb@google.com>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, 
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>, "Thomson, Jack" <jackabt@amazon.co.uk>, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>
Content-Type: text/plain; charset="UTF-8"

"Kalyazin, Nikita" <kalyazin@amazon.co.uk> writes:

> From: Nikita Kalyazin <kalyazin@amazon.com>
>
> Let's provide folio_{zap,restore}_direct_map helpers as preparation for
> supporting removal of the direct map for guest_memfd folios.
> In folio_zap_direct_map(), flush TLB to make sure the data is not
> accessible.
>
> The new helpers need to be accessible to KVM on architectures that
> support guest_memfd (x86 and arm64).
>
> Direct map removal gives guest_memfd the same protection that
> memfd_secret does, such as hardening against Spectre-like attacks
> through in-kernel gadgets.
>
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---
>  include/linux/set_memory.h | 13 ++++++++++++
>  mm/memory.c                | 42 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 55 insertions(+)
>
> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> index 1a2563f525fc..24caea2931f9 100644
> --- a/include/linux/set_memory.h
> +++ b/include/linux/set_memory.h
> @@ -41,6 +41,15 @@ static inline int set_direct_map_valid_noflush(const void *addr,
>  	return 0;
>  }
>
> +static inline int folio_zap_direct_map(struct folio *folio)
> +{
> +	return 0;
> +}
> +
> +static inline void folio_restore_direct_map(struct folio *folio)
> +{
> +}
> +
>  static inline bool kernel_page_present(struct page *page)
>  {
>  	return true;
> @@ -57,6 +66,10 @@ static inline bool can_set_direct_map(void)
>  }
>  #define can_set_direct_map can_set_direct_map
>  #endif
> +
> +int folio_zap_direct_map(struct folio *folio);
> +void folio_restore_direct_map(struct folio *folio);
> +
>  #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
>
>  #ifdef CONFIG_X86_64
> diff --git a/mm/memory.c b/mm/memory.c
> index 07778814b4a8..cab6bb237fc0 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -78,6 +78,7 @@
>  #include <linux/sched/sysctl.h>
>  #include <linux/pgalloc.h>
>  #include <linux/uaccess.h>
> +#include <linux/set_memory.h>
>
>  #include <trace/events/kmem.h>
>
> @@ -7478,3 +7479,44 @@ void vma_pgtable_walk_end(struct vm_area_struct *vma)
>  	if (is_vm_hugetlb_page(vma))
>  		hugetlb_vma_unlock_read(vma);
>  }
> +
> +#ifdef CONFIG_ARCH_HAS_SET_DIRECT_MAP
> +/**
> + * folio_zap_direct_map - remove a folio from the kernel direct map
> + * @folio: folio to remove from the direct map
> + *
> + * Removes the folio from the kernel direct map and flushes the TLB.  This may
> + * require splitting huge pages in the direct map, which can fail due to memory
> + * allocation.
> + *
> + * Return: 0 on success, or a negative error code on failure.
> + */
> +int folio_zap_direct_map(struct folio *folio)
> +{
> +	const void *addr = folio_address(folio);
> +	int ret;
> +
> +	ret = set_direct_map_valid_noflush(addr, folio_nr_pages(folio), false);
> +	flush_tlb_kernel_range((unsigned long)addr,
> +			       (unsigned long)addr + folio_size(folio));
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_FOR_MODULES(folio_zap_direct_map, "kvm");
> +
> +/**
> + * folio_restore_direct_map - restore the kernel direct map entry for a folio
> + * @folio: folio whose direct map entry is to be restored
> + *
> + * This may only be called after a prior successful folio_zap_direct_map() on
> + * the same folio.  Because the zap will have already split any huge pages in
> + * the direct map, restoration here only updates protection bits and cannot
> + * fail.
> + */
> +void folio_restore_direct_map(struct folio *folio)
> +{
> +	WARN_ON_ONCE(set_direct_map_valid_noflush(folio_address(folio),
> +						  folio_nr_pages(folio), true));
> +}
> +EXPORT_SYMBOL_FOR_MODULES(folio_restore_direct_map, "kvm");
> +#endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
> --
> 2.50.1

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

I also took a look at Sashiko's [1] comments and I think that the
highmem folio issues should be the responsibility of the caller to
check.

[1] https://sashiko.dev/#/patchset/20260317141031.514-1-kalyazin%40amazon.com
