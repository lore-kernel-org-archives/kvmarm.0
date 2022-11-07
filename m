Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F15DC433FE
	for <kvmarm@archiver.kernel.org>; Mon,  7 Nov 2022 16:05:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C5BE4B8BC;
	Mon,  7 Nov 2022 11:05:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H4C9G+zsaDvJ; Mon,  7 Nov 2022 11:05:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25FE54B88F;
	Mon,  7 Nov 2022 11:05:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 338494B86B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 11:05:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0x-VoHSsxeZe for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 11:05:41 -0500 (EST)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
 [209.85.216.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B75254B850
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 11:05:41 -0500 (EST)
Received: by mail-pj1-f46.google.com with SMTP id
 q1-20020a17090a750100b002139ec1e999so10737534pjk.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Nov 2022 08:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
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
 b=SuqcqOGOUA6g+ggcA5vaPgso2LW3L8nG0VO01uWIxnn5EzimZkowJxkryE1TYqOs7K
 5I2B84NgiLzwkv6PPKLj3EWLKvuRCG1VJYmB2mLQwGoa9qYBJtogN6dxgmIwUFVAhB3d
 r9llwyPIrsRLek6cBlZyCPzGZA+6Krvh6YuuuzK5qk86JtEbGI9bqGNZPY9OWzDno728
 z7bKThdAFBvzobMp+af9avDgZll2jGlswPQe2y2sOLggsbpRbU/cwGnFOiuvFI/4Zx7Y
 z38fq/jYIfkn6h5iWR1X+elMDEGr1qn2UrPBexFrEvSQd8OQ7eEupeYz+625eQtZ7oUM
 qFvA==
X-Gm-Message-State: ANoB5pny181s3881yUjxI2okXX5NhcOqELV4vMgBQK8CLjwUvSY85yqD
 bLxZFfaRct8b2Olh9YcPEOjA+A==
X-Google-Smtp-Source: AA0mqf7NmHUwnj4p1J7j0E54Y9RXMXBZQMv0Sw4ZZdbS0IXjebmkq5OLQBCE6zzlWdvLIEkqEMOzqA==
X-Received: by 2002:a17:903:4052:b0:188:6bad:3ff0 with SMTP id
 n18-20020a170903405200b001886bad3ff0mr16812130pla.6.1667837140430; 
 Mon, 07 Nov 2022 08:05:40 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 n5-20020a170902e54500b00186c54188b4sm5188752plf.240.2022.11.07.08.05.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Nov 2022 08:05:39 -0800 (PST)
Date: Mon, 7 Nov 2022 16:05:36 +0000
From: Sean Christopherson <seanjc@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v8 3/7] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2ks0NWEEfN8bWV1@google.com>
References: <20221104234049.25103-1-gshan@redhat.com>
 <20221104234049.25103-4-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221104234049.25103-4-gshan@redhat.com>
Cc: maz@kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com,
 andrew.jones@linux.dev, dmatlack@google.com, will@kernel.org,
 shan.gavin@gmail.com, bgardon@google.com, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, zhenyzha@redhat.com, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
