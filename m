Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F9D29E0F4
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 15:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753111025; cv=none; b=ov5WcBk3KgqKXf7jrGCwXtPBOHTNMl8pwJjVzsPEkxyb1XT0ey3HCm4vOMLkz1SkStkbtmteXSVNKcfKNxY5c2e7jpBXh6pNAToG7GJaDIWIFISzJLaIE5j3meu73N06CFEpe/I+oAARzJYd2FR/IQL0ue4AcaEUcfIAdshrHOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753111025; c=relaxed/simple;
	bh=DdMAoLnDt3BZqGC3/MH1e4CmgEmvQhr8zC+TrEQ8g/A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F9K1+Vk2I2RdQtn9lntF+s4N4ik6ZdaLHjVso5reY2fCOe2W1gY1IQo03DeWw3NvTnhpyvXRhEuQOdj/skTKwjtcygI0liZemrUprfyXg/anRaxWerbe5M8clWgA0yVoflk9v0wl4/1WVBSOSl3AjJm5kpjRkehFQStAFRe4FBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UUGsUy1L; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UUGsUy1L"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2354ba59eb6so63300265ad.1
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 08:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753111023; x=1753715823; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eZhvDkWg2vIcqb5h1LaFmsKpUFQK58z+6ZtJpc5qCi4=;
        b=UUGsUy1LChvMQkeUp0qLydvE85/r1MtMGflxTUytBUQqCA5/UoCc/mQngX1XDcQzk5
         IFeFKEIaCFUz236LzSNogXegdCvt1Z6ulhA1jkzS1BadfiGFJkSEh8Z+BfVxau2cb/VG
         k7Z2d7Ozz1zMBYKNfwtaO1R9YzJXMonpQ7+6PjTxSj6xtboBFYRm57UK7UvF9l5czBah
         rTj3vwJZ+pDs2sRN3DTOdoUry4zFCeDyFXtEBXpJjbX6HwuBUrPzfn/hF0zBtJJ1XoKI
         HK5YqxnuzOze8AqumEVECOHHMRZOpb6NYoyiUpxpbSfQWw7XAU0UVUe523Yf9Bqhx1aH
         lJAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753111023; x=1753715823;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eZhvDkWg2vIcqb5h1LaFmsKpUFQK58z+6ZtJpc5qCi4=;
        b=oNtO85ZE3cvLxSBhYOZi82TNXJwese1WZDQEuOk3gqlQ+5NsfUw0eCzjQ7HLSNXrfI
         9OLaIqfP/mL8utKc8iWZg8wzTL7QmLecf1lnGhoSmtgHBCkoSKGvSSrkOrprMI+Zy0++
         XcClV2jo0MguNtBo1tGPX7OdUAKlxCjoogPc/XzRJ+v7j+rkqixWKroyGSWwJtsbND1n
         8sWfkSZgiVFKFVl4GUqgF0jJyVZB7wMUQNgcTjvM6crOQUSPuorx++8suLbeWynNxYNQ
         8rzzmXz418GuoQZ7ib51F5tthpTWdFhE1iCousUZ8GGE/D4ITjHDqJqe3u4BMMb1EInn
         TKQQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2CuWlGfc0l4npGyyM0om6Z2P7kbQR+DT9PkdTFERqip6eeQ1ntV3dw/4Qz7yMoxE2UHaL1zA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwsjjzBoi23fSWl3hek68XxSmeAno9FQRljJyGzRrjvBVlOjZ4H
	B4umF3nivwG/Z7l939c/1YFWtfngJEkRj+BJTk/Qxghgwi1+5piH439IZArawgcIy7rgff6iQTt
	jGaXxMQ==
X-Google-Smtp-Source: AGHT+IEOUhgoKLdh5nmcOUZ5zQQMJ+il7P7YZIA288keFVcRXhlFL8IRxQfYB3qVxDFSK42KaGDwW30OvDY=
X-Received: from pjbqo12.prod.google.com ([2002:a17:90b:3dcc:b0:31c:2fe4:33ba])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d50f:b0:234:eb6:a35d
 with SMTP id d9443c01a7336-23e2572af2dmr282186375ad.27.1753111023196; Mon, 21
 Jul 2025 08:17:03 -0700 (PDT)
Date: Mon, 21 Jul 2025 08:17:01 -0700
In-Reply-To: <20250717162731.446579-2-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-2-tabba@google.com>
Message-ID: <aH5Z7edFZSPzmJ5w@google.com>
Subject: Re: [PATCH v15 01/21] KVM: Rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 17, 2025, Fuad Tabba wrote:
> Rename the Kconfig option CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM. 

Please name this CONFIG_KVM_GUEST_MEMFD.  I'm a-ok using gmem as the namespace
for functions/macros/variables, but there's zero reason to shorten things like
Kconfigs.

> @@ -719,10 +719,10 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>  #endif
>  
>  /*
> - * Arch code must define kvm_arch_has_private_mem if support for private memory
> - * is enabled.
> + * Arch code must define kvm_arch_has_private_mem if support for guest_memfd is
> + * enabled.

This is undesirable, and the comment is flat out wrong.  As evidenced by the lack
of a #define in arm64, arch does NOT need to #define kvm_arch_has_private_mem if
CONFIG_KVM_GUEST_MEMFD=y.  It "works" because the sole caller to kvm_arch_has_private_mem()
is guarded by CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES=y, and that's never selected
by arm64.

I.e. this needs to key off of CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES=y, not off of
CONFIG_KVM_GUEST_MEMFD=y.  And I would just drop the comment altogether at that
point, because it's all quite self-explanatory:

#ifndef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
{
	return false;
}
#endif


>   */
> -#if !defined(kvm_arch_has_private_mem) && !IS_ENABLED(CONFIG_KVM_PRIVATE_MEM)
> +#if !defined(kvm_arch_has_private_mem) && !IS_ENABLED(CONFIG_KVM_GMEM)
>  static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
>  {
>  	return false;
> @@ -2527,7 +2527,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
>  
>  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  {
> -	return IS_ENABLED(CONFIG_KVM_PRIVATE_MEM) &&
> +	return IS_ENABLED(CONFIG_KVM_GMEM) &&

And this is equally wrong.  The existing code checked CONFIG_KVM_PRIVATE_MEM,
because memory obviously can't be private if private memory is unsupported.

But that logic chain doesn't work as well for guest_memfd.  In a way, this is a
weird semantic change, e.g. it changes from "select guest_memfd if private memory
is supported" to "allow private memory if guest_memfd is select".   The former
existed because compiling in support for guest_memfd when it coulnd't possibly
be used was wasteful, but even then it was somewhat superfluous.

The latter is an arbitrary requirement that probably shouldn't exist, and if we
did want to make it a hard requirement, should be expressed in the Kconfig
dependency, not here.

TL;DR: drop the IS_ENABLED(CONFIG_KVM_GMEM) check.
