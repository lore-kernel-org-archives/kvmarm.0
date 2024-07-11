Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46DC158A35
	for <kvmarm@lists.linux.dev>; Thu, 11 Jul 2024 23:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720741286; cv=none; b=tV7wMNtcSy+jO/DGJ5RWAnYJ8glJA7/c5x6siIDyHHH0hyyCEdEAo7ggnkfk6g8dr6MakPtenbwQxMEofIOBEqIu20VlQ1lBDXO+OJCg1lxun+TBe33rGlcc/p6csuZeeBtxY1o87a9058kKlas1VTRHq1RcKjjZcLvFNl8lwvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720741286; c=relaxed/simple;
	bh=ZdwiAaNOEcsQ1iawVne670iRqDXG2wC8RCl2vG0f8s4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eqK2HzdtjgESvHoqeG9ucX86D4sF6r2MUAsb0phNdc2iKG2vviu+6z3zS9cYbQA6axtI+CQHpCuf4oyiLd9o9eupo+pcAfm3b9hIW/I5s6jBUl8Ys+AP+ey4ThIxs4LlDmIPBfs74EDbZcjw+ybOb86+elrmzOilrj3tDsqrsxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ekCm05/m; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ekCm05/m"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a7527afa23cso185687466b.2
        for <kvmarm@lists.linux.dev>; Thu, 11 Jul 2024 16:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720741283; x=1721346083; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pfuHNi5R9KMj0UxFnDquGekhSFTlViomrJL3yZ6eHpI=;
        b=ekCm05/mok/1ZCSPyOAnCGVj3M4t94aGxcROSV/UAvF+EA4EeZNEA+UDwTrP1lTL28
         PpjR3lZs/FJKO/5YZtRfbhGdNwxNWjqxvc/7TI8FqVCN6rx2TSn9tkmlrUTyNq3eAjlQ
         EehjpHW6CXvCUGVDYDMqZIOahcqNk4i82sh2kCztvf2nnf3YQh2+3A1UrBQtgFmGgGUF
         el673G/sONGxjDULT9woE8S0XRSwlyzx+m5OgvWkTbqAvvHhjb3DGWYfvqlIH36m7QQQ
         Vjh3z23p5T+P/MDT4kizFN71ZDqjG4mXFZI5H8slqaJNmqDjSe4DklA8wy0SA35WkaEr
         kvUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720741283; x=1721346083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pfuHNi5R9KMj0UxFnDquGekhSFTlViomrJL3yZ6eHpI=;
        b=ZUE+s0rs/m3QeXCwZMlgggoNSGsGZRCIYAtu9lJicAz5GlM6R/W1bbHxS/P2MJX7kN
         fS9b3CV/xJh//FlDrNpp8DNYd8FmSaEVRFrq6mRHxzL8Qo/PzV1e/9mKcQUqKVNsB6rO
         VvWzL5P5aztY0TJrHkEXYB3NHbiYSxs6V3mfIb+vXphpfCUDU6jH6apifhx0eOY/Un45
         RzYdfuW9Vk6/5c8WaUIvJ+kvIpWVShmp05NRnyVByQjFCnhY4SAlp09bBm3Ot+BDbJQc
         mORdFtaNl4SiSHQkjDxy+sA9ys5CvHwVKOJ2npenXBtwrKYkMNF1bfXn39cUGMvnluB/
         DABg==
X-Forwarded-Encrypted: i=1; AJvYcCU0c1k11umGv8fjmMR9VHKgp2YEzXCbgXn+5aHlfo41JW1da4KbQnmolA2BJfezTQ4HxJFl6BF1MkwYGE0HEYvMKAHd7dHh
X-Gm-Message-State: AOJu0Yx3FVGOVdGHNstZwSzM1LYvEkh8sLLGe6ZuiENcbaj4ZGY3Adti
	E3MkCwUm3M0SaWRSChFg1Sl7xpOM593+ZhxbDU523Fk0Ht8gfUnyBJ8BSlIVBLlvfQBu72A4epJ
	HJapAzWJdDXIsq/SFExUTltzHStD5GXqG44Tbs8uGVaYNQfHqWg==
X-Google-Smtp-Source: AGHT+IFND8OJ4Hc6Luty4DujmFBUJFFOnOhkbf4bXVfGHjmUWdjIMHEqzQfgESAoCPprxuNTe9hiEGwJ28pFonfz9vc=
X-Received: by 2002:a17:907:d93:b0:a75:20f7:2c71 with SMTP id
 a640c23a62f3a-a780b6ff667mr1002583166b.38.1720741282837; Thu, 11 Jul 2024
 16:41:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com> <20240710234222.2333120-5-jthoughton@google.com>
In-Reply-To: <20240710234222.2333120-5-jthoughton@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 11 Jul 2024 16:40:54 -0700
Message-ID: <CALzav=dfpy=BSZD4hOVMFSrfxgc5OhDjZHek7CzMDYRqTBALwg@mail.gmail.com>
Subject: Re: [RFC PATCH 04/18] KVM: Fail __gfn_to_hva_many for userfault gfns.
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, Peter Xu <peterx@redhat.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 10, 2024 at 4:42=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> Add gfn_has_userfault() that (1) checks that KVM Userfault is enabled,
> and (2) that our particular gfn is a userfault gfn.
>
> Check gfn_has_userfault() as part of __gfn_to_hva_many to prevent
> gfn->hva translations for userfault gfns.
>
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
>  include/linux/kvm_host.h | 12 ++++++++++++
>  virt/kvm/kvm_main.c      |  3 +++
>  2 files changed, 15 insertions(+)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index c1eb59a3141b..4cca896fb44a 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -140,6 +140,7 @@ static inline bool is_noslot_pfn(kvm_pfn_t pfn)
>
>  #define KVM_HVA_ERR_BAD                (PAGE_OFFSET)
>  #define KVM_HVA_ERR_RO_BAD     (PAGE_OFFSET + PAGE_SIZE)
> +#define KVM_HVA_ERR_USERFAULT  (PAGE_OFFSET + 2 * PAGE_SIZE)
>
>  static inline bool kvm_is_error_hva(unsigned long addr)
>  {
> @@ -2493,4 +2494,15 @@ static inline bool kvm_userfault_enabled(struct kv=
m *kvm)
>  #endif
>  }
>
> +static inline bool gfn_has_userfault(struct kvm *kvm, gfn_t gfn)
> +{
> +#ifdef CONFIG_KVM_USERFAULT
> +       return kvm_userfault_enabled(kvm) &&
> +               (kvm_get_memory_attributes(kvm, gfn) &
> +                KVM_MEMORY_ATTRIBUTE_USERFAULT);
> +#else
> +       return false;
> +#endif
> +}
> +
>  #endif
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ffa452a13672..758deb90a050 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2686,6 +2686,9 @@ static unsigned long __gfn_to_hva_many(const struct=
 kvm_memory_slot *slot, gfn_t
>         if (memslot_is_readonly(slot) && write)
>                 return KVM_HVA_ERR_RO_BAD;
>
> +       if (gfn_has_userfault(slot->kvm, gfn))
> +               return KVM_HVA_ERR_USERFAULT;

You missed the "many" part :)

Speaking of, to do this you'll need to convert all callers that pass
in nr_pages to actually set the number of pages they need. Today KVM
just checks from gfn to the end of the slot and returns the total
number of pages via nr_pages. i.e. We could end up checking (and async
fetching) the entire slot!

> +
>         if (nr_pages)
>                 *nr_pages =3D slot->npages - (gfn - slot->base_gfn);
>
> --
> 2.45.2.993.g49e7a77208-goog
>
