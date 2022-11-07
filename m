Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FBED531
	for <kvmarm@lists.linux.dev>; Mon,  7 Nov 2022 16:05:41 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id d13-20020a17090a3b0d00b00213519dfe4aso10735064pjc.2
        for <kvmarm@lists.linux.dev>; Mon, 07 Nov 2022 08:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CwCXHOiuiyfKv69+MEzKNVwp3Ov8oZ78eR0WR4d2A90=;
        b=NLcMdAU2vS38J28r0bBcsw9sZG6YcZkl/8nBVDjJmKmae84CrIcfXGeRXyu5K/r2XC
         UXrnEq0BsJneLcHe1CNJYHR75xYsoXID5BQbTEcuwORpbQ+QfxAjFkkD8vDJsL2oodUp
         DIuWBiHaNivTC8uyPcgEfz1vmoWtscFYydQi+R3bmF6HEgWJmUiWrYPuVIaUChxcqxTi
         di9evWogJbj1Hbyk9lUBgezlAa96Ur8/3SxAxP0+2IU0yS7UH7HSbHYQwC9QdQrQmZGN
         JyXtK6CAsYEae29AWcTHURqTPdtdj6RMhazriqop30Mk5iNQ232Ex5JAIGbk+jM6+DBc
         He+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CwCXHOiuiyfKv69+MEzKNVwp3Ov8oZ78eR0WR4d2A90=;
        b=Eo9a6fjZ6hti/hP+P/xOe+0j6e0aO++uFN0eWJkoxTrYnDZQHqhsNGntxbOSHi3jv4
         lPb5SMQjxl3v63jVicXB6kRdEzUXyiWD+uMuzWSo79MuRJsBpzQg2JyIdTHbDkXRZnZW
         8Z5AEeaJYij3nMMdMz3LVn0YdQ0PTPTisank7FB4Heootv4sPWb4mu7kHzId6sbOeFu/
         b5bKRFZpiiBjrADXI6Fp9QlwTmV6xgvX3y1rkafanVu9ymKVMbf4AkOrqgz4aqBRHou3
         hCT1JBwnNiNBEOJXvpyg+iKAD5Rco8CBYrQ629peX04VTYLVmdRLhW4ovPwi801aeSZY
         xcVw==
X-Gm-Message-State: ANoB5pluqBttBj6oQoCsH8tb2bBSTYuNEle3M0dxS4evB4mbAfK1N9nQ
	uvx0A5Ux/OL6fWQfKao2uvXIUA==
X-Google-Smtp-Source: AA0mqf7NmHUwnj4p1J7j0E54Y9RXMXBZQMv0Sw4ZZdbS0IXjebmkq5OLQBCE6zzlWdvLIEkqEMOzqA==
X-Received: by 2002:a17:903:4052:b0:188:6bad:3ff0 with SMTP id n18-20020a170903405200b001886bad3ff0mr16812130pla.6.1667837140430;
        Mon, 07 Nov 2022 08:05:40 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n5-20020a170902e54500b00186c54188b4sm5188752plf.240.2022.11.07.08.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 08:05:39 -0800 (PST)
Date: Mon, 7 Nov 2022 16:05:36 +0000
From: Sean Christopherson <seanjc@google.com>
To: Gavin Shan <gshan@redhat.com>
Cc: kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, shuah@kernel.org, catalin.marinas@arm.com,
	andrew.jones@linux.dev, ajones@ventanamicro.com, bgardon@google.com,
	dmatlack@google.com, will@kernel.org, suzuki.poulose@arm.com,
	alexandru.elisei@arm.com, pbonzini@redhat.com, maz@kernel.org,
	peterx@redhat.com, oliver.upton@linux.dev, zhenyzha@redhat.com,
	shan.gavin@gmail.com
Subject: Re: [PATCH v8 3/7] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2ks0NWEEfN8bWV1@google.com>
References: <20221104234049.25103-1-gshan@redhat.com>
 <20221104234049.25103-4-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104234049.25103-4-gshan@redhat.com>
Message-ID: <20221107160536.qLqB1nnZpQJGyzIqInJZSaT4guF6GNMn_zmxWD5tpss@z>

On Sat, Nov 05, 2022, Gavin Shan wrote:
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index fecbb7d75ad2..758679724447 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -21,6 +21,16 @@ u32 kvm_dirty_ring_get_rsvd_entries(void)
>  	return KVM_DIRTY_RING_RSVD_ENTRIES + kvm_cpu_dirty_log_size();
>  }
>  
> +bool kvm_use_dirty_bitmap(struct kvm *kvm)
> +{

	lockdep_assert_held(&kvm->slots_lock);

To guard against accessing kvm->dirty_ring_with_bitmap without holding slots_lock.

> +	return !kvm->dirty_ring_size || kvm->dirty_ring_with_bitmap;
> +}
> +
> @@ -4588,6 +4594,31 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>  			return -EINVAL;
>  
>  		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
> +	case KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP: {
> +		struct kvm_memslots *slots;
> +		int r = -EINVAL;
> +
> +		if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
> +		    !kvm->dirty_ring_size)
> +			return r;
> +
> +		mutex_lock(&kvm->slots_lock);
> +
> +		slots = kvm_memslots(kvm);

Sadly, this needs to iterate over all possible memslots thanks to x86's SMM
address space.  Might be worth adding a separate helper (that's local to kvm_main.c
to discourage use), e.g. 

static bool kvm_are_all_memslots_empty(struct kvm *kvm)
{
	int i;

	lockdep_assert_held(&kvm->slots_lock);

	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
		if (!kvm_memslots_empty(__kvm_memslots(kvm, i)))
			return false;
	}

	return true;
}

> +
> +		/*
> +		 * Avoid a race between memslot creation and enabling the ring +
> +		 * bitmap capability to guarantee that no memslots have been
> +		 * created without a bitmap.

Nit, it's not just enabling, the below also allows disabling the bitmap.  The
enabling case is definitely the most interesting, but the above wording makes it
sound like the enabling case is the only thing that being given protection.  That's
kinda true since KVM frees bitmaps without checking kvm_use_dirty_bitmap(), but
that's not a strict requirement.

And there's no race required, e.g. without this check userspace could simply create
a memslot and then toggle on the capability.  Acquiring slots_lock above is what
guards against races.

Might also be worth alluding to the alternative solution of allocating the bitmap
for all memslots here, e.g. something like

		/*
		 * For simplicity, allow toggling ring+bitmap if and only if
		 * there are no memslots, e.g. to ensure all memslots allocate a
		 * bitmap after the capability is enabled.
		 */

> +		 */
> +		if (kvm_memslots_empty(slots)) {
> +			kvm->dirty_ring_with_bitmap = cap->args[0];
> +			r = 0;
> +		}
> +
> +		mutex_unlock(&kvm->slots_lock);
> +		return r;
> +	}
>  	default:
>  		return kvm_vm_ioctl_enable_cap(kvm, cap);
>  	}
> -- 
