Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C933246FA
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 21:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768513653; cv=none; b=dgQNgH67O5LpEf4r+hXxnk4WQbnLAS4VqMkv7elWS6hW/Axgsw7M9CJajLRpk8YxkJzyp0aUyRhqtBrrcGhcAzuiCI0wnT99+ZKZ5fzVgvi07AP/k8Fy9S8+gdOmDXRt57riWH7QanbZDsHF+ncaUQtAGhTv6o217A8JeqR5o1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768513653; c=relaxed/simple;
	bh=v118hUkz4tlXR7MqYZI3xl/4gAf6dCbuf95gCRXXIrU=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BoF4d1y8S6lltXQhZidpDp/5LMrj269lSfBGVr0NbQzkQIzfY1pj/rZvAu1dKJGXhYIZ4yQCIuhgB8Ngxrn0hrdnbM6xx2SPYQllButNDJgetBKiDrg95hUi7OAel4hnI8bmZM3HsMyJrqTRvEbGxC+Z+xavOeoa8/GALW4r39A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MTsQ1c3/; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MTsQ1c3/"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5636274b338so1154841e0c.1
        for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 13:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768513650; x=1769118450; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=YBmCHfpLlL8iGEYc8icjykZfZHQFfzihdrkSCqexEsw=;
        b=MTsQ1c3/5Dp0C8q0fyK5KJmM+CT3z6Tjbw+vMVEVrLtq291erJ+WWYagLlo5XQn+GN
         CKQKwXky2XACkxS00O5HAH5yvAUhrTjKZ6kAHTxqpsa9YurufKvfgSE8gqV6yPG3Rhwh
         ajx/E8aQfDHmQY7RhU3razZFzHo6QBjHMhNvrVSYrelrSreaQwFAi4iv1eyhzHYD5GK/
         xFs6gfGOnGLPO57i965HVPwiIsKQpli4ATTw+SC4Z4mStAS1Vf3j1Sqx/U4fdBH86Ahy
         QFzQmlvfFfTvIFXeVe08f/KPryVcszyRZJNokSoSw0PlZ4afgGmRypnzXGZiRg8ZgMG/
         aARw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768513650; x=1769118450;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YBmCHfpLlL8iGEYc8icjykZfZHQFfzihdrkSCqexEsw=;
        b=fx6DEEeYcdZUjGGRUx43jNLhyT2JNBN9Hy72hymutrZJG/X8QWG1ycYH/kFlwHSRpv
         ksQnuI7h8A2C0adfbVeQhH4/B3vkQlQwEPLYJrg2VCZqF/stgOCTvX4ibG6HECzNZnc6
         DZi8TkPpUxY+79QyIbsnRig4MDCwV1W99od9jX2E1HxoY0zsCpeH0jcVqay+Ck6rMU0c
         pcLfQ2IFah5iBfc5ebou9ANvxgJMXQl9kXtowuV6/f6H5oJt8RMau2WSTpvyR9S8vOMf
         +JPkiPgtXrjH/GeM2M4wJzoRnl2qtv/jan9fP714pznqB6DAQa0dXJb1IPlEuorojTPS
         NKbA==
X-Forwarded-Encrypted: i=1; AJvYcCXPuFYm3ZCmodGUPJz9U6jCpL3tmM/9gp1o3awWYUUM+CBsKDDA70V44vvuFR8llyAD7PScQVk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxAfokqttq8QS/kep0TNoeX/3PxWp7ZuWfPl7TwZKHCpsmt2W8h
	QFFJm9FVCzWmnj1NKVExgRnZa9rztIF2srxpIYqe6OaMKB2yip999GQReAU7oubfSwECggFoZSJ
	CDKLa2acKmY/UPqprnM9dFpWTUFnNzgpTFq0YBST2
X-Gm-Gg: AY/fxX76zRzaJGXNp/inZ+8sDcSorRJ7anCK0atsngPO0t/A8g4KXD41eYlABH5hfwV
	2ctZvUbV3XK1z6D8DTknav24OpEBD87DzLt0CNbdOA2UVlwLDeRynbzVhzXFy+RX9KhX0L5OE+U
	ApfReZvRq14KWu8TkREP9D8robBU80n3RJfaWjeBDZiCLc195oGxz/3QMzCev2M2tMgBfhTPLQs
	EtHDgngpbHd/Sw76NhGQrg2u41cX+zirlHoPsos76QdrfkwVecKuGX3NkscGYEPVeCtYT0prxzA
	nlX/noSru1FPjfOuocz2zMjgwQ==
X-Received: by 2002:a05:6122:500a:b0:563:466c:2 with SMTP id
 71dfb90a1353d-563aa9aae66mr1528951e0c.5.1768513649399; Thu, 15 Jan 2026
 13:47:29 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 15 Jan 2026 13:47:28 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 15 Jan 2026 13:47:28 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260114134510.1835-5-kalyazin@amazon.com>
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-5-kalyazin@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 15 Jan 2026 13:47:28 -0800
X-Gm-Features: AZwV_QiX95-0WFEZIhu3a0jzKlg7ft8DnUjTu2uxi7sdZ3xYcaUb3m6pe5q87wE
Message-ID: <CAEvNRgFihTZg_-R8yEytDLVxbiF34nFgTEsghMp6tzBvazVqoA@mail.gmail.com>
Subject: Re: [PATCH v9 04/13] KVM: guest_memfd: Add stub for kvm_arch_gmem_invalidate
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
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
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
	"shuah@kernel.org" <shuah@kernel.org>, "riel@surriel.com" <riel@surriel.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com" <jgross@suse.com>, 
	"yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"coxu@redhat.com" <coxu@redhat.com>, "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "prsampat@amd.com" <prsampat@amd.com>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>, 
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, 
	"alex@ghiti.fr" <alex@ghiti.fr>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>, 
	"hca@linux.ibm.com" <hca@linux.ibm.com>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"pjw@kernel.org" <pjw@kernel.org>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"thuth@redhat.com" <thuth@redhat.com>, "wyihan@google.com" <wyihan@google.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, 
	"vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com" <jackmanb@google.com>, 
	"aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	"Thomson, Jack" <jackabt@amazon.co.uk>, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	"Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco" <xmarcalx@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"

"Kalyazin, Nikita" <kalyazin@amazon.co.uk> writes:

> From: Patrick Roy <patrick.roy@linux.dev>
>
> Add a no-op stub for kvm_arch_gmem_invalidate if
> CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE=n. This allows defining
> kvm_gmem_free_folio without ifdef-ery, which allows more cleanly using
> guest_memfd's free_folio callback for non-arch-invalidation related
> code.
>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Patrick Roy <patrick.roy@linux.dev>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---
>  include/linux/kvm_host.h | 2 ++
>  virt/kvm/guest_memfd.c   | 4 ----
>  2 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d93f75b05ae2..27796a09d29b 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2589,6 +2589,8 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages
>
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
>  void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
> +#else
> +static inline void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) { }
>  #endif
>
>  #ifdef CONFIG_KVM_GENERIC_PRE_FAULT_MEMORY
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index fdaea3422c30..92e7f8c1f303 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -527,7 +527,6 @@ static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *fol
>  	return MF_DELAYED;
>  }
>
> -#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
>  static void kvm_gmem_free_folio(struct folio *folio)
>  {
>  	struct page *page = folio_page(folio, 0);
> @@ -536,15 +535,12 @@ static void kvm_gmem_free_folio(struct folio *folio)
>
>  	kvm_arch_gmem_invalidate(pfn, pfn + (1ul << order));
>  }
> -#endif
>
>  static const struct address_space_operations kvm_gmem_aops = {
>  	.dirty_folio = noop_dirty_folio,
>  	.migrate_folio	= kvm_gmem_migrate_folio,
>  	.error_remove_folio = kvm_gmem_error_folio,
> -#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
>  	.free_folio = kvm_gmem_free_folio,
> -#endif
>  };
>
>  static int kvm_gmem_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> --
> 2.50.1

Like this change, thanks!

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
