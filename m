Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F475EA9
	for <kvmarm@lists.linux.dev>; Thu,  5 Oct 2023 01:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VoajaehK"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2775a7f3803so373867a91.1
        for <kvmarm@lists.linux.dev>; Wed, 04 Oct 2023 18:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696468722; x=1697073522; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wbr8G8c5SpkphgF6J+oopW5jS/piuS6angX7igUOPT0=;
        b=VoajaehK34ItpNwc8k2bntT2IRE/gszem34ZWTlskM2tj/vkN7PdFVDOwZhB0dLnhA
         PCS9GI4RnjUGDMvOykQOHZX6A9orNX8wZC7QcRVYn3s6a9khotUXwlEIu/Z9dhjRzb5O
         BozmsctKJJyincXbNQj5JN3ThdmoXnfWL22Su4Vk9lVHwVxRr6e68hRjq5gt3RtUgCY6
         pdeQlNUlPnw51l+5llBftWPJ1fxF/12/K3n6Qp04BNuTRugjkQ8ZoRH/k6gOnaiWHJJK
         js1xQhdu+86Goo4+5zkxwJtU4KlpMkH8QgGSH3Kvdf/U+RpoimXDKvzG0p3G1GcHxIhB
         BqZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696468722; x=1697073522;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wbr8G8c5SpkphgF6J+oopW5jS/piuS6angX7igUOPT0=;
        b=S1HwIGL2mVau8Yp9bUL2UXZNEdNKgvinLdVvXilWqzho0+qXK2VhVapzpANlYHICMt
         oJ0giWIRmr4wuiaoLjh60MYXBMkVUCKxZlg8EITuRtThfBjSAlG1VbWxLUBUvfgMbs42
         RcZxA/zz8J+J/Awsbxv5FgiVOxdtPZ8iN2DP2+AcPyqvilcSMTa10pcTk7F7CyDEBgQz
         +Ux0IcPO4bv3atWmrOXDc+4+YgDOuw4NdeOVyBahjrZEhuZ08W1vUxWqzYOpEabLS9Fn
         54+SOEXGCGxfMWgC3DD8h1f2GmdD/91699PCbWCM0s/9fzSWetPaD1cmSNAV7LNlURRj
         rYTw==
X-Gm-Message-State: AOJu0YzyUeE/w8mfE4oiNelJQbRilntLzyE3CrR12TT0osNaCM8bbgh+
	WBUAeTAkKmPS/9J/uAVP/Eipbacg2M0=
X-Google-Smtp-Source: AGHT+IF0zzx7UMQ4wDXUv+JbgsF4dcYKUkEQIdr20Hqdjjh8byx0S/1IKqQI4ivKKJtuCJfX/AuHMQGHBMk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d396:b0:273:dfcd:bdbf with SMTP id
 q22-20020a17090ad39600b00273dfcdbdbfmr63059pju.8.1696468721871; Wed, 04 Oct
 2023 18:18:41 -0700 (PDT)
Date: Wed, 4 Oct 2023 18:18:40 -0700
In-Reply-To: <20230908222905.1321305-3-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-3-amoorthy@google.com>
Message-ID: <ZR4O8MMbQLEjbvn0@google.com>
Subject: Re: [PATCH v5 02/17] KVM: Add docstrings to __kvm_read/write_guest_page()
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 08, 2023, Anish Moorthy wrote:
> The (gfn, data, offset, len) order of parameters is a little strange,
> since "offset" actually applies to "gfn" rather than to "data". Add
> docstrings to make things perfectly clear.
> 
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  virt/kvm/kvm_main.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 84e90ed3a134..12837416ce8a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3014,6 +3014,9 @@ static int next_segment(unsigned long len, int offset)
>  		return len;
>  }
>  
> +/*
> + * Copy 'len' bytes from guest memory at '(gfn * PAGE_SIZE) + offset' to 'data'

A preceding @ is usually how kernel comments refer to paramaters, e.g. an
alternative would be:

  /* Copy @len bytes from guest memory at '(@gfn * PAGE_SIZE) + @offset' to @data */

Though I think I find your version to be more readable.

> + */

No need for a multi-line comment.

>  static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
>  				 void *data, int offset, int len)
>  {
> @@ -3115,6 +3118,9 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
>  
> +/*
> + * Copy 'len' bytes from 'data' into guest memory at '(gfn * PAGE_SIZE) + offset'
> + */
>  static int __kvm_write_guest_page(struct kvm *kvm,
>  				  struct kvm_memory_slot *memslot, gfn_t gfn,
>  			          const void *data, int offset, int len)
> -- 
> 2.42.0.283.g2d96d420d3-goog
> 
