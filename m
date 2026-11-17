Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794926581;
	b=uZWtcMvrO1LoQQgyyxC0Ib4RKDeZeVqAS1qHRlSwAAdb6sAwub26mmzI9OtMlGDec0x1
	 1V4Jb2shwIeESt/KP+RehHaUIG6+O87AYPhfU7ELc7wv7thK52Q/MmWxoN3yG3cH9/597
	 SCE6QqPnzybKkgXBDoCQJb/DN1/Kx7hdkafV8rUjbOaMhfetpthzEHmsoJx1W6+l4OLxB
	 +CpkzMatigu1rSE41866sD3kty3/iRnjKwpK+n1H8KZip7H3UNCRV1YG/q2zj4JNXPa31
	 YRvVX74Qlg1rhhUcr7qjB+hu4eNmlUoDjs04K0OnHqztO75bDWLAcJKu6ZGf9iQp+xw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794926581;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=yDy1XcgDWZwINenyHLTABAspaDvRGL9tl++CNqH98OQ=;
	b=zeMOww55jkrhCvIdLcZsI3QoFBvCbUgCrsOTHE5/q8G0+1zH07ka0EI2YnC9KjjBx0bi
	 OexWb1H9CkgCKxCWmJluBGisb1Vd55H55WEiRlUoEvR2Xg/7pGYCF1vczfbV4m3Xi19xQ
	 xh0altVNh37gzIYr/kKMEDwDEoGALdqIBwBMNX+wQx904b9F7b35eV6fBlrZyYg/hFWT+
	 /vdrJLpCWGQPvoqAOsZJVu3+XI/3Owro8i/yhMGl0R+9kjWwTpvOgMsZic3rR83PZGk0h
	 8YD1adb1XQKQ7QZUxOryRuE13fILiykcMQKdq0Oxz67pxic2v0eMUfi/zEX8qSqCK8g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=iLdmwY9b;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.44
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06AC606A32A
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 14:43:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B06AC606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=iLdmwY9b
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5c14bc5a743so9848e87.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 06:43:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794926579; cv=none;
        d=google.com; s=arc-20260327;
        b=MMTmZ9DTaMar0/zard8skeyc4c8D29syyrw29hbtZgrhgSGCsBJH3R9TzKAG1SdmRD
         bMIPWi+RgCXPT3O6/v+ey1to419zHjQmMuDGCM/TIiDM66FG11kWvrtjxQG0UUKcmuin
         C5xCOHHMUlWfJT1vEcAPtG/ct5bY7JQQZ2GyZrRfpMiHIawPkmGd2eaAufnygJksJIBp
         0MvNY0EJBTmqDD1nF4DNaaIdCkByLNoiAkYy8A2JJdUG+qfD9b0S3/8eRK5DYmO1GGo0
         xOo41b1JkHHFTutoIVkdM7xNfSGNo0ozYkgX+SvZM0GlUfBGL/ulWFLJD9HnjxvbIuKp
         epow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=yDy1XcgDWZwINenyHLTABAspaDvRGL9tl++CNqH98OQ=;
        fh=NQbjnv5r0FQ4pb7CNvKgD/sh9wq+Xu7EwrJIIuW5W2w=;
        b=nfXov0uavF5DDz03gPkmZAhJFd91Ua78yixbJpOrIOGBOCvEByS0R1uPi1WYnckjWe
         PhfBb535lNlenon7xmeMuHZrQ5HYzVy8Qc5jKZpeRA/pz9VQRrAkBBD8H4Br2nGiW1u/
         73rP9F1G6CYfXC0GBLxnldipormIBdff+WZ+s63HcorMfcjbDrVR0u1UpHKNgcoH2WcT
         giv0+KdNCSq1WIr7H3PRrhiXikXHylHYxbKhkkIaB/2z23mF9c+tgWDWnkykWnSs6SoH
         upTpxdMag2skBMva+nn+sAn3XWQbGL/XY/7MfmIvTZST6ZPWONArgEC3VSHUNDHaLpWJ
         QZQA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794926579; x=1795531379; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yDy1XcgDWZwINenyHLTABAspaDvRGL9tl++CNqH98OQ=;
        b=iLdmwY9bV1opg9GnODQ1WJzYbiC4+hWPSrEJE/IPLvkGk6syxPms9MSBHs+SrzLIY/
         z0lIHqQR/EoCBeANGM60GV+FA0RGEucCt6Tbqm2qKjsRN67hX97LwemUI3tzmAFTFypb
         4G2aBxAQ8r0NmY8/dh7dA1nlzh7j0FSgQvAIWiw10YCUNaajiNoRvjuPrI76Rt9W+34P
         anKkj9vq2o5sWfyS+8KinlOC+1tQXGSKs7p+HfMVSj2A2z5eGqmgpVfWqrLJRW7EdMQW
         8/y8oGlrekUcun1Yn5uFl8lwogkEQ8ChcfAXIdE+WXooKAO7pwxW53WrXgjQma4wHkeB
         aGMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794926579; x=1795531379;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=yDy1XcgDWZwINenyHLTABAspaDvRGL9tl++CNqH98OQ=;
        b=03QXZ9wDH5e0PwYgQlvK4rv0tqA1XDOAlB/M/suEN/oGvc3L2SSjHaw4B7/7fFmrbm
         8mE8nkO4KYTaqnOvShWBrfTkkn05g2yptbjbmL5ZgVJb7hoyDcR02Rr46FTZOzFKCCPn
         CQ6pXimq5bzs1TRQW6g+uJwrekHdzGd+UFnkcQLPqDZv/uAS+lSuQGwAjsQfMl/SfiBn
         XrX0xgZmGOgFt2L7555Yp/MLBviglHVjXDEieZVMr7jANy2Y89puP2zqScVv68y5xDA+
         y/OY3mJhOj2nacdVe/lE1eADuVNn3PNRTbmO7fNZM5mobI9tAoaWqeZXSrs/w/cyo+LU
         nODg==
X-Forwarded-Encrypted: i=1; AL+hErFwOyq/nIfCyZkluDtQ/dN1kO8THrjQmNslZjIP53b2IjoSdSb99vBeUTo7uqfpmVRmctlCF5Y=@lists.linux.dev
X-Gm-Message-State: APuU4Z/mI/GksZtFsVPGOcHGeS4yg0JKIH/GgNSiYxF1m3IqdnyGkEab
	hsCAFHXj3ueoHFJSNaQVUfOzJVmwAlMKNxB1nsmyCl7R+g0GfIkkdd1JpHlTLzTj1a/tYM91lVQ
	ak45J0sEOg13ea0hRAGNCKzjSnWkoB17Xa/b7jWjh
X-Gm-Gg: AYBFou3KSstZEtiGiZynxUqoz34YCgaxLghEGZJXHSnuVfE1whzsCtQlROLjhRQZJMf
	yXfpqkFytCLN3ntEsKOr8fdZVZ/iRtrxFXS/Zdk5KArvVS9zxwdYqJfpiXJO81gvwLi6A60abNW
	+n1FoBvfw0bA3ZWjZOOCzuQ/Rg2M4PZ5wfDokFlbpK9zyOTUBDKiHII/r59EBk9IUlGMXEL96XN
	NMz8kI7P4NfXc4rhhRjyE+2QfcR8tkZdb9rASAb30qmYcIPpY0+1GA0e9AzohlCYmym1jyETQv+
	k8tCIxmaV4tDW3IS3ZvKz1+1997V1jKWQP2RrvSwjLzJoPTVDJ3BIwt47zAjEV4RHoAyFZ6ig3B
	bZCCckfIIpytsr5YQzTu+XPPY/pAGrnpmcSQg2cBguUjU8kxQcXzv5Poz95ibpE1PLcd1tNpOI+
	LIdF8UPWsuJpSXoXisG15XIzEj
X-Received: by 2002:ac2:4e07:0:b0:5bf:f84f:1d74 with SMTP id
 2adb3069b0e04-5c1a2185fadmr144874e87.13.1794926578238; Tue, 17 Nov 2026
 06:42:58 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261116164358.142785-1-steven.price@arm.com> <20261116164358.142785-9-steven.price@arm.com>
In-Reply-To: <20261116164358.142785-9-steven.price@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Nov 2026 14:42:22 +0000
X-Gm-Features: AclHuK_cj3TGdQobS2sWbu8813m5UwP4GVfoFkRYcpiUN0Z7bFACWbcVhIVAqkY
Message-ID: <CA+EHjTzAo+5FhtxfX8mQ4t3k5BhatR15UKNSAQw+CRbxJ=wz7A@mail.gmail.com>
Subject: Re: [PATCH v3 08/11] KVM: arm64: CCA: Prevent memslot modifications
 after Realm creation
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Christoffer Dall <christoffer.dall@arm.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Kohei Enju <enju.kohei@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Nov 2026 16:43:54 +0000, Steven Price <steven.price@arm.com> wrote:
[...]
> Define kvm_arch_has_private_mem() so generic KVM recognizes Realm VMs
> as supporting private memory.
[...]
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
[...]
> @@ -1611,6 +1611,8 @@ struct kvm *kvm_arch_alloc_vm(void);
>
>  #define kvm_vm_hyp_is_distrusting(kvm)        ((kvm)->arch.vm_flavor >= __VM_DISTRUSTING_HYP)
>
> +#define kvm_arch_has_private_mem(kvm) kvm_vm_is_realm(kvm)

Could the message say that defining the macro makes
gmem_in_place_conversion true for every arm64 VM? One visible change
is that KVM_SET_MEMORY_ATTRIBUTES2 on a non-Realm VM's guest_memfd
returns -EINVAL instead of -ENOTTY.

[...]
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
[...]
> @@ -2887,10 +2903,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>                  return 0;
>
>          /*
> -         * Prevent userspace from creating a memory region outside of the IPA
> -         * space addressable by the KVM guest IPA space.
> +         * Realm shared IPAs alias the corresponding private IPAs, so memslots
> +         * must reside entirely in the canonical lower half of the IPA space.
>           */
> -        if ((new->base_gfn + new->npages) > (kvm_phys_size(&kvm->arch.mmu) >> PAGE_SHIFT))
> +        ipa_limit = kvm_phys_size(&kvm->arch.mmu) >> PAGE_SHIFT;
> +        if (kvm_vm_is_realm(kvm))
> +                ipa_limit >>= 1;
> +        if (new->base_gfn + new->npages > ipa_limit)
>                  return -EFAULT;

This check still applies to every VM, so I'd keep the old comment and
add the Realm sentence to it.

Cheers,
/fuad
