Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E335E37756B
	for <kvmarm@lists.linux.dev>; Tue, 21 Apr 2026 16:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776789072; cv=none; b=EuU7wriXof/tuSZHwXQeS1rUoSDKFrpLcM3q7lKTj9PjtQPsh0s3GTTl7yNuLUD3g5J27ALO9KNKODZ3NZ5MtlOufnD+LAv5JtadyP/+shJANs1BqLBLafTzu9EZm9q1BImOPYOQ1ixH8gXzORR/vfOCx3OJ+aSwVkbpi/muUsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776789072; c=relaxed/simple;
	bh=sdGOibwiTUlGb9HHFRJY6kF15dopnn55unT/vgkUwM0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uxQ3thdUdaTYmkRT/q7VmnMb4WahT4WYnRhLPiSqqwbH6jEV5s+LLlne4WpYOO4reN1Ihbifba0kMC0D3oLCe04MXd4H29T6s2XO1504epr4yYk6iWb4S2Xqy0HW0B1IJTJtTHLSQvlnWmAbCnR0Pghtgv3YSuuSAZbmPiStYeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uQUxWmQ8; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uQUxWmQ8"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82f07078ff0so3033117b3a.1
        for <kvmarm@lists.linux.dev>; Tue, 21 Apr 2026 09:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776789069; x=1777393869; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rjgkwxA0RLtfuWNBMEJF4TxxPjAXkNJh9XTaeAVjQ5Q=;
        b=uQUxWmQ8elrGMfXrcfmUzQbDNTycCkD1a7Ag4k2BTjlqLgKMmC6Ow6CEi1gwxeb9op
         0xN4K/WRY+KF7zd5QtJiyOPLZvFR9royKPWXigIEeYRz0OinFJIGtLHonZXqPXT89LKB
         6sBHp9C95GrY1/vPvghJBDY5PZ+Uh/n+L3hu7wIc/bj99dA174yo8HPM9i4yVs0oq5dV
         LnBBIklDiqF9Zek/8xActD5w3Axhg7Upsh68QqNjQ9fIMk9CrKeTFfLAro7naDYj67QW
         JRl0OQNoYhciI5F6Ygqhw8wlq3pMRb0SwlXH2OwWytHgjvclYJqa8L/ua7tF5QGwN7EV
         QDsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776789069; x=1777393869;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rjgkwxA0RLtfuWNBMEJF4TxxPjAXkNJh9XTaeAVjQ5Q=;
        b=r6BpqNjzE1Y7aMxscGewJmBGdOhRSKi0jFYohCT8IbnwRHrRcC8JlO5Ie6pQz06sDj
         Ouf93KCWQiiIHlQPKSan2wppfm69J7QNy22nbLA2WnitVWzGxFhkjd9uWGn+ohG5DVRb
         nYxReBnsXbi6Gm421NDzevJk6Wolj2efSt4ZFjf0Ekn0diMrdobmeCbXW/pZCyPbNBnk
         Yo/aCCds8CyWxuU7clgUSR8vhjjvvQca8p1wdIZI+ErerQQC0UJS6oAsy3avkB/vXFpJ
         79JrUNallWqoWIef+CeODrc6Ct8a9+CkiOdGhdSvUMF8KvX74FkiAxuDClMHCTz8SY6u
         zGcQ==
X-Forwarded-Encrypted: i=1; AFNElJ9vG64Qq55cXr4wZY938tm6kv3LWlZDvKeT1RnFTmXmVQFX0wuo3uMhQZiwHMa2xrDTPYwQujw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwfJxUAts/IA1UKICdHBndS3jLyqMmYQ7rxYS/xz923uIcMkktu
	dzRxDyRo8thdsAjBHh4xjpOxGfgbMaknGed4GZKf8cktmz4onF1DEpyuo3X+kdt0RIPLo9ewjND
	P3qs7lA==
X-Received: from pfbhk7.prod.google.com ([2002:a05:6a00:8787:b0:82f:f2d:5b4d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2d8d:b0:82c:1cd0:2f5e
 with SMTP id d2e1a72fcca58-82f8c96eb30mr20038023b3a.44.1776789068848; Tue, 21
 Apr 2026 09:31:08 -0700 (PDT)
Date: Tue, 21 Apr 2026 09:31:07 -0700
In-Reply-To: <20260410151746.61150-11-kalyazin@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260410151746.61150-1-kalyazin@amazon.com> <20260410151746.61150-11-kalyazin@amazon.com>
Message-ID: <aeemS2wm38Cm4qAf@google.com>
Subject: Re: [PATCH v12 10/16] KVM: guest_memfd: Add flag to remove from
 direct map
From: Sean Christopherson <seanjc@google.com>
To: Nikita Kalyazin <kalyazin@amazon.co.uk>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
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
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
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
	"coxu@redhat.com" <coxu@redhat.com>, "ackerleytng@google.com" <ackerleytng@google.com>, 
	"yosry@kernel.org" <yosry@kernel.org>, "ajones@ventanamicro.com" <ajones@ventanamicro.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "tabba@google.com" <tabba@google.com>, 
	"prsampat@amd.com" <prsampat@amd.com>, "wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>, 
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, 
	"alex@ghiti.fr" <alex@ghiti.fr>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"gor@linux.ibm.com" <gor@linux.ibm.com>, "hca@linux.ibm.com" <hca@linux.ibm.com>, 
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "pjw@kernel.org" <pjw@kernel.org>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"thuth@redhat.com" <thuth@redhat.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "urezki@gmail.com" <urezki@gmail.com>, 
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, 
	"gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>, 
	"jiayuan.chen@shopee.com" <jiayuan.chen@shopee.com>, "lenb@kernel.org" <lenb@kernel.org>, 
	"pavel@kernel.org" <pavel@kernel.org>, "rafael@kernel.org" <rafael@kernel.org>, 
	"yangyicong@hisilicon.com" <yangyicong@hisilicon.com>, "vannapurve@google.com" <vannapurve@google.com>, 
	"jackmanb@google.com" <jackmanb@google.com>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	Jack Thomson <jackabt@amazon.co.uk>, Takahiro Itazuri <itazur@amazon.co.uk>, 
	Derek Manwaring <derekmn@amazon.com>, Nikita Kalyazin <nikita.kalyazin@linux.dev>
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 10, 2026, Nikita Kalyazin wrote:
> From: Patrick Roy <patrick.roy@linux.dev>
> 
> Add GUEST_MEMFD_FLAG_NO_DIRECT_MAP flag for KVM_CREATE_GUEST_MEMFD()
> ioctl. When set, guest_memfd folios will be removed from the direct map
> after preparation, with direct map entries only restored when the folios
> are freed.
> 
> To ensure these folios do not end up in places where the kernel cannot
> deal with them, set AS_NO_DIRECT_MAP on the guest_memfd's struct
> address_space if GUEST_MEMFD_FLAG_NO_DIRECT_MAP is requested.
> 
> Note that this flag causes removal of direct map entries for all
> guest_memfd folios independent of whether they are "shared" or "private"
> (although current guest_memfd only supports either all folios in the
> "shared" state, or all folios in the "private" state if
> GUEST_MEMFD_FLAG_MMAP is not set). The usecase for removing direct map
> entries of also the shared parts of guest_memfd are a special type of
> non-CoCo VM where, host userspace is trusted to have access to all of
> guest memory, but where Spectre-style transient execution attacks
> through the host kernel's direct map should still be mitigated.  In this
> setup, KVM retains access to guest memory via userspace mappings of
> guest_memfd, which are reflected back into KVM's memslots via
> userspace_addr. This is needed for things like MMIO emulation on x86_64
> to work.
> 
> Direct map entries are zapped right before guest or userspace mappings
> of gmem folios are set up, e.g. in kvm_gmem_fault_user_mapping() or
> kvm_gmem_get_pfn() [called from the KVM MMU code].

...

> +#define KVM_GMEM_FOLIO_NO_DIRECT_MAP BIT(0)
> +
> +static bool kvm_gmem_folio_no_direct_map(struct folio *folio)
> +{
> +	return ((u64)folio->private) & KVM_GMEM_FOLIO_NO_DIRECT_MAP;
> +}
> +
> +static int kvm_gmem_folio_zap_direct_map(struct folio *folio)
> +{
> +	int r = 0;
> +
> +	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
> +
> +	if (WARN_ON_ONCE(!(GMEM_I(folio_inode(folio))->flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP)))
> +		return -EINVAL;
> +
> +	if (kvm_gmem_folio_no_direct_map(folio))
> +		goto out;
> +
> +	r = folio_zap_direct_map(folio);
> +	if (!r)
> +		folio->private = (void *)((u64)folio->private | KVM_GMEM_FOLIO_NO_DIRECT_MAP);
> +
> +out:
> +	return r;
> +}
> +
> +static void kvm_gmem_folio_restore_direct_map(struct folio *folio)
> +{
> +	folio_restore_direct_map(folio);
> +	folio->private = (void *)((u64)folio->private & ~KVM_GMEM_FOLIO_NO_DIRECT_MAP);
> +}

Making guest_memfd responsible for zapping and restoring the direct map on a per-
folio basis feels wrong given the addition of AS_NO_DIRECT_MAP.  I especially don't
like that the "rules" for when an AS_NO_DIRECT_MAP folio has a direct map will vary
based on the owner, and even within an owner (e.g. guest_memfd) will be ad hoc.

E.g. as per the series to add guest_memfd write() support[*]:

  When direct map removal is implemented [2]
   - write() will not be allowed to access pages that have already
     been removed from direct map
   - on completion, write() will remove the populated pages from
     direct map

That's pretty gross ABI, because with KVM_GMEM_FOLIO_NO_DIRECT_MAP, userspace can
write() exactly once.  To re-write memory, I assume userspace would need to do a
PUNCH_HOLE or truncate.

What's preventing us from handling this automagically in e.g. filemap_add_folio()
and filemap_remove_folio()?  Then the usage rules are pretty straightforward: the
kernel must *always* assume the direct map is invalid for folios from
AS_NO_DIRECT_MAP mappings.

Then if KVM needs to utilize a kernel mapping, e.g. in kvm_gmem_populate(), KVM
could use dedicated variants of kmap_local_xxx() to deal with a local mapping for
a folio/page without a direct map.  Or, KVM could simply disallow the specific
sequence that would require KVM to do the memcpy (I'm pretty sure we can do that
with in-place shared=>private conversion support).

I realize that could throw a big wrench into write() performance, but IMO, before
merging either series, we need a complete story for exactly how this will all fit
together, in a maintainable fashion and with sane ABI.

[*] https://lore.kernel.org/all/20251114151828.98165-1-kalyazin@amazon.com
