Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75E22EC16
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 19:10:26 +0000 (UTC)
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-666841398cdso231982b3a.3
        for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 12:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686769826; x=1689361826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dxQJOhg0ds4nvP7Z166Sd90CLLinvyoKIj6nvECzLfw=;
        b=z0vg4Kmo6oKZVBeTkzK1ixF6OPifd5jGjG/sKFwzjh/BgZ6qNYI+QIOtc/ENviFNzB
         dGvHzY5MnoRMUkgN2LUZbQiTQQICsq4svC6d8n/1Nag0h5s96J8gpLL40Rb8Yn7VXXti
         Fhh5zxBoA64ykKdfzPKy2fZUpfa5584W4OM49pZt4ZDuxGf5RJLT3TfhDhr/fiS3VeSv
         D4O/ZvmrKVONKv4exTu3ReQW2JI91Z+asaqMZlptjwd7dx2XaX39x/+n/Iv39MD7yOtD
         v9kZfNDtdcc43gcDMThKgpipEq0PpuaFq5FMh57V5cpJvdOaDGh0isyod6zpffXDmk/v
         jY2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686769826; x=1689361826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dxQJOhg0ds4nvP7Z166Sd90CLLinvyoKIj6nvECzLfw=;
        b=ACjZ+jCdS6aHpsquufoNmPctlyxv+2TJqnPR/TY21XJuYiSJ7SHFOnlBreZ8nF7Vue
         XQl4Im4XZgst4tEGuRHUK5VwL4Rmr/jh63jognFwUJPaLza7FqqkI0p1JJdvFlfO2ri5
         UzLIhIVANv426zmhR676b4w9EM5L0lcNK2RgN3cUy0S7VTcRFiacJmjh81ptHxYHjvvL
         wOefpZlUryxivLVs0C7PevYhTGcOC43rM8EWnzSe63/bzjZidiYUd6kY4MEmf6GOIutU
         NVWgBW4b8SbIL+9D+cmsWmAtS6UZi4ETBrzigyL16VpB998KK/jOl7/4K4lId5Sv2hTT
         rscA==
X-Gm-Message-State: AC+VfDwMwd44UVqyFsDUXKEYGJ9rEBMR0v9RDoeEOx4eInyBCcxg3gTN
	v0r934DmHWNMbs3V3uflu+J2kbROIaI=
X-Google-Smtp-Source: ACHHUZ7C3cReboQ0Er1o7SpOku2nwnKw5DU0VxT9Y3qsSKHzED7PcdYspTE6bmt9GRrX8epAxXEm1tbsSjA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d82:b0:665:b46a:b26f with SMTP id
 fb2-20020a056a002d8200b00665b46ab26fmr759072pfb.0.1686769826143; Wed, 14 Jun
 2023 12:10:26 -0700 (PDT)
Date: Wed, 14 Jun 2023 12:10:24 -0700
In-Reply-To: <20230602161921.208564-6-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-6-amoorthy@google.com>
Message-ID: <ZIoQoIe+UF6qix5v@google.com>
Subject: Re: [PATCH v4 05/16] KVM: Annotate -EFAULTs from kvm_vcpu_write_guest_page()
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 02, 2023, Anish Moorthy wrote:
> Implement KVM_CAP_MEMORY_FAULT_INFO for uaccess failures in
> kvm_vcpu_write_guest_page()
> 
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  virt/kvm/kvm_main.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d9c0fa7c907f..ea27a8178f1a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3090,8 +3090,10 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
>  
>  /*
>   * Copy 'len' bytes from 'data' into guest memory at '(gfn * PAGE_SIZE) + offset'
> + * If 'vcpu' is non-null, then may fill its run struct for a
> + * KVM_EXIT_MEMORY_FAULT on uaccess failure.
>   */
> -static int __kvm_write_guest_page(struct kvm *kvm,
> +static int __kvm_write_guest_page(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  				  struct kvm_memory_slot *memslot, gfn_t gfn,
>  			          const void *data, int offset, int len)
>  {
> @@ -3102,8 +3104,13 @@ static int __kvm_write_guest_page(struct kvm *kvm,
>  	if (kvm_is_error_hva(addr))
>  		return -EFAULT;
>  	r = __copy_to_user((void __user *)addr + offset, data, len);
> -	if (r)
> +	if (r) {
> +		if (vcpu)

As mentioned in a previous mail, put this in the (one) caller.  If more callers
come along, which is highly unlikely, we can revisit that decision.  Right now,
it just adds noise, both here and in the helper.

> +			kvm_populate_efault_info(vcpu, gfn * PAGE_SIZE + offset,
> +						 len,
> +						 KVM_MEMORY_FAULT_FLAG_WRITE);

For future reference, the 80 char limit is a soft limit, and with a lot of
subjectivity, can be breached.  In this case, this

			kvm_populate_efault_info(vcpu, gfn * PAGE_SIZE + offset,
						 len, KVM_MEMORY_FAULT_FLAG_WRITE);

is subjectively more readable than

			kvm_populate_efault_info(vcpu, gfn * PAGE_SIZE + offset,
						 len,
						 KVM_MEMORY_FAULT_FLAG_WRITE);
>  		return -EFAULT;
> +	}
>  	mark_page_dirty_in_slot(kvm, memslot, gfn);
>  	return 0;
>  }
> @@ -3113,7 +3120,7 @@ int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn,
>  {
>  	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
>  
> -	return __kvm_write_guest_page(kvm, slot, gfn, data, offset, len);
> +	return __kvm_write_guest_page(kvm, NULL, slot, gfn, data, offset, len);
>  }
>  EXPORT_SYMBOL_GPL(kvm_write_guest_page);
>  
> @@ -3121,8 +3128,8 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
>  			      const void *data, int offset, int len)
>  {
>  	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> -

Newline after variable declarations.  Double demerits for breaking what was
originally correct :-)

> -	return __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
> +	return __kvm_write_guest_page(vcpu->kvm, vcpu, slot, gfn, data,
> +				      offset, len);

With my various suggestions, something like

	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
	int r;

	r = __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
	if (r)
		kvm_handle_guest_uaccess_fault(...);
	return r;

Side topic, "uaccess", and thus any "userfault" variants, is probably a bad name
for the API, because that will fall apart when guest private memory comes along.  
