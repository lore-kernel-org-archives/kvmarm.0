Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795565382;
	b=rjwsn/fx1Jz1WGjPD7LlWpS1s4/7GeUKrk5aiAhuphIovxR5JtM3LpWnYoESs0QskmwU
	 4fC7U/OiunR45P9JJzCwzscgKAV7urxaGogXT/GBNNV17jpVNMHjxf0qFEI0WqbJqAtTM
	 4+iPgiR0jxn+KAJUW6/QfdLn+xv6f6MCCBeqwI8crSxHCbD0l5z8IZJCJwRElwxo6ZbmU
	 TKzzDqOcS3yJ/z8efgoRdXW+BsqeZJqeUGEi7ezfmY7Jti+5ZCvtLbIYqnHC3wsiVM0ws
	 i60AO5k3RYgjdASuEzXgrBzjooH25gM7avb674UisVy7E08Dms+7GoW6NM2G+e6xgdQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795565382;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:In-Reply-To:References:MIME-Version:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=rntaW4qP7qUm/rpCDs8AkAc3u/q2bwtFH1Dwu9ED+9M=;
	b=zTckzvPMwDwKQtyeaZGrceP/ZePOq5TQ8Zp03X0JNIypYmXojpnmbMpdnRRkY4WojuKR
	 PgI/KdHINEVpO9t1CcwRzLenkHRmaqDYGGKkO+CDjPY8EwNO8WlAoGO0jbWeOlBsKXDfT
	 kNR7WwepORHLGQpORG+o38nBtU14rjqgzXTRncZizFTC4kz0Gu6et6SmHgFXGYPkXZHNF
	 WR40ar8Cc+6RKoWAU+fsWs+mIz/R/M1wewu9XhpOtpGK0qb8jBgml0HOyJ44BiRrHvqHt
	 BXaWfhy0Elc+cYAaiucM+rFAY7uZazBEao9PMEZdhkOMx9EVqIC7Pm9sEwy+/6Afy1A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=bKP5JN+t;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.47
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7659F606A323
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 00:09:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7659F606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=bKP5JN+t
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-9213e130a16so29384326d6.1
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 16:09:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795565380; cv=none;
        d=google.com; s=arc-20260327;
        b=f9N77U1K3ZQcBiNFKEcVeU3bmX7J+hzENTFhBlfTE8wgqfcmcxbsxe/8uLqdU2+Mpy
         vqWd4b1khCH6xB4vkq5vtY8uezv1E2JRAuB2h2Itr59ARxuAmHkWmYXjEiOzYZ342BJJ
         duSyWe6y9OvsBcoWXjn+URXbtJrQELzSrEM637kTKCO94SN4Ce2yKkRWV9VYTQ3yBr6x
         dWZSyQu3ZOuWlEu/87KQ/RVJobaU1zGA4tIbT30w34orHJ+Eiz7cZe/w4emqRehqyxud
         pb3glkw5JsIycIq1KoXKlvqxFBwDzpZMOMZZVjvZyx9494uqDLgIaQLUwTckolfJNgEq
         lOyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=rntaW4qP7qUm/rpCDs8AkAc3u/q2bwtFH1Dwu9ED+9M=;
        fh=DQMU+4MbdnXphPd50Cvn6k6Ma++X8mbqbA98js7Safk=;
        b=CkVVWzdhamBfnrdea5QOKO4WQ6tKOQ0S74GBbpzPQwEefYeZC63pTZ5YxsW4A5tnUp
         M1frVHZTh94DeEuu28dcxU3xvfl8sv9YyWtA4gb32toZ2SAz0o8fYq8oxQ11Rkk61yo7
         3qpWBAuWVPGyzd5cbYB23eExLTdQK38Oy5Zr84wITMUJ+UqN+cdL9za1fpiwH8kjrDHd
         YDTmg1H25ib7xClft6P5MnzevFL5JKwvlGYJJ0aVf2FEBFUtN8aUN8aIV+zzUftE9P2c
         e5mFahJPRU/Kz+14wlI7y31YSsVEPwTVvLClepp10y/4sbmBEBxqG9KyhvrPvSM4aFZa
         OQaw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795565380; x=1796170180; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rntaW4qP7qUm/rpCDs8AkAc3u/q2bwtFH1Dwu9ED+9M=;
        b=bKP5JN+txnagUjrT+KyPlIY5daEWkCg82DFYQvk1pGDMCDG6uu2EjitGLRdfT3VPkW
         I9THDLfNLN8SotjLCYwRnqEgLJTY4e73uXFOyuo0wfEkkEbAlk/wCYJhLvdQrJptaSPd
         8TFanXGVkLg8jWdRBQ2xmIvpnRxMzZT9bsYGUuygTtoSGDHyGujGH3609YDgu+IQLDeu
         R+Vo0l3y1npCwGXht6pwopJOjYkKKaQbmXU2BoyW6ikjkZj3SnI4vP3k9XKm+SoSZvHn
         J0ioTmsPPDVooTqbo/NH8AqUTD/1qiFwx/N//Tse8kokQ4TpE2CxIbfQhmG6oilD2Azm
         Inyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795565380; x=1796170180;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rntaW4qP7qUm/rpCDs8AkAc3u/q2bwtFH1Dwu9ED+9M=;
        b=qMyxD9vm9jE1M2jjdc7KGLgpzJRy9MiyFzjFbYCKFSNrKhwvE/pl9kK3hB5Ueie7aI
         B4DuViM1tbS8i4u7Gxr7CShsXvnc/cIsN1ZhKZMbMCUs/3VOROKhHho57DsK6w32zgld
         1BWTz+k0X+szgkEPgT9bZdH0UF2XMVDCyKKahj01FbML6vBaqoEa5IWbgSQ+PKE99C5q
         2czP1zcaKFcm2c905SNq394XBZXo2xXsMnN2PDKGSrSwXUdwEmBEqoSJeMdeQq0d3k6s
         RksCk8nqUvRtik5P7bBG4JyqV1Mz8zOYPGKGG1MCFFNXGO3tDKEkQhEi+vddC5DAfKW9
         R+oA==
X-Forwarded-Encrypted: i=1; AL+hErFApJoFvRoZ9XpG2lgNpdI3MkbcoZhKZuIny2S1RjcZ25MUkgcKfVr0kYcEuQYljyvKjypMC4o=@lists.linux.dev
X-Gm-Message-State: APuU4Z/Wfzcw7+5Z4thPMNlocs0TPlbcmeYn7C1lwpN5WEiGd5VQUPcA
	rluRi/Hmx1li4bih3D2FQBQhe3iKgkH+F61YQDe3OKMBveOK+WzOJlT2noBGczvmX3wbs1HJl/s
	R4kWyJr8R9tCMRLR6cm8tYnMl0WtjkG2DrxlIrhma
X-Gm-Gg: AZFdTZfe9BDMhILsv/1V9shYaOfTBkYTM4ne3JQdX/iHRM4nVnOLh6VQC7cbFTPwlCg
	OK+9DG91uvbymjGL8x87eyvbwEJPFZv8I2VqOr55uy/Fomw6TM1dDp5XP8wQ0BAuFUWCpNwrxeZ
	Ks/9qcvqVIf4OCwsftjp08irC63qAE4jWskntfxlV+YeZWpJcdfBfmKFssuOy4kP0y8tsrkG1tS
	O9TI+GARUNbTsGKowhbuya6/V7LAkKD/CdPjLbL9KKVWIuzewufMTsxhF8zxwhQIZ9dceKdeHqv
	t1DcpwHx38u0r4Y62+xbm7x9xEs6Red6mut1iDF07b6rUafNm0KP/4gh8KHECyXmnZfJ/E1JUks
	W/BU8HE/PZ9xYsFeGCduPCGJUPmPhfpSTO//wc0vdFk3WW7VcSpBhFavt2HfROwC1icRUymsxzm
	Z6aHLj/mvf/U59ARYv5gEqTEk=
X-Received: by 2002:a05:6214:3c9d:b0:91c:9316:f4e8 with SMTP id
 6a1803df08f44-92134baab8amr275174306d6.54.1795565379417; Tue, 24 Nov 2026
 16:09:39 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 24 Nov 2026 16:09:38 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20261123104233.95710-10-steven.price@arm.com>
References: <20261123104233.95710-1-steven.price@arm.com> <20261123104233.95710-10-steven.price@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Date: Tue, 24 Nov 2026 16:09:38 -0800
X-Gm-Features: Aa3M54oNKjHnmwhcyDiHaoxz_zNMiDJBoB2YChnt0u_TPYjP0NAb6dZlL994CUs
Message-ID: <CAEvNRgFQ5BXqU3KfPFT8bfZTW=RyvBw25z3GZtr3JA=Wv3Yqfw@mail.gmail.com>
Subject: Re: [PATCH v4 09/11] KVM: arm64: CCA: Prevent memslot modifications
 after Realm creation
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Kohei Enju <enju.kohei@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

Steven Price <steven.price@arm.com> writes:

> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>
> Once the Realm is created, prevent changes to guest_memfd backed
> memslots, which can provide private memory. Validate these changes
> before KVM invalidates the old memslot, so a rejected deletion leaves
> its stage-2 mappings intact. Realm stage-2 faults will also validate
> the private memory backing in a later commit.
>
> Require Realm memslots to lie in the lower half of the IPA space, as the
> upper, shared half aliases the lower, protected half.
>
> Define kvm_arch_has_private_mem() so generic KVM recognizes Realm VMs
> as supporting private memory. Defining the macro also makes
> gmem_in_place_conversion true for every arm64 VM, so guest_memfd
> memslots are marked gmem-only even for non-Realm VMs. A well-formed
> KVM_SET_MEMORY_ATTRIBUTES2 request on a non-Realm guest_memfd now
> reaches the VM check and returns -EINVAL instead of -ENOTTY.
>
> Additionally, similar to pKVM, do not support dirty logging or
> read-only memslots.
>

Imo this could be split into a few patches

1. Add the constraints wrt realm memslots and being in the lower half of
   the IPA space
2. Defining arm's support for private mem
3. Imposing rules on memslot changes
4. Maybe some others, maybe I'm misunderstanding the patch

> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
>
> ---
> Changes since v3:
> - Explain the arm64-wide in-place conversion effect and keep the
>   general IPA limit comment.
>
> Changes since v1:
> - Preserve private mappings if KVM invalidates a Realm guest_memfd
>   slot before the prepare hook rejects its deletion.
> ---
>  arch/arm64/include/asm/kvm_host.h |  2 ++
>  arch/arm64/kvm/mmu.c              | 37 ++++++++++++++++++++++++-------
>  2 files changed, 31 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 3ddeddfacd06..55673d08e3eb 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1607,6 +1607,8 @@ struct kvm *kvm_arch_alloc_vm(void);
>
>  #define kvm_vm_is_realm(kvm)		((kvm)->arch.vm_flavor == VM_REALM)
>
> +#define kvm_arch_has_private_mem(kvm) kvm_vm_is_realm(kvm)
> +
>  #define kvm_has_mte(kvm)					\
>  	(system_supports_mte() &&				\
>  	 test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &(kvm)->arch.flags))
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 800333a345cd..9af5fe6d87f0 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2861,17 +2861,32 @@ int kvm_arch_validate_memory_region(struct kvm *kvm,
>  {
>  	lockdep_assert_held(&kvm->slots_lock);
>
> -	if (kvm_vm_is_protected(kvm)) {
> +	if (kvm_vm_is_protected(kvm) && new &&
> +	    (new->flags & (KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)))
> +		return -EPERM;

gmem is already generically mutually exclusive with
KVM_MEM_LOG_DIRTY_PAGES and KVM_MEM_READONLY, so before this change,
pKVM is saying no to KVM_MEM_LOG_DIRTY_PAGES and KVM_MEM_READONLY for
all memslots, gmem or not, so this check makes sense.

> +
> +	switch (kvm->arch.vm_flavor) {
> +	case VM_PROTECTED_PKVM:
>  		/* Cannot modify memslots once a pVM has run. */
>  		if (pkvm_hyp_vm_is_created(kvm) &&
> -		    (change == KVM_MR_DELETE || change == KVM_MR_MOVE)) {
> +		    (change == KVM_MR_DELETE || change == KVM_MR_MOVE))
>  			return -EPERM;
> -		}
> +		break;

Not sure why pKVM doesn't allow deleting a memslot after the vm is
created, but this is no change from before this patch, the removal of {}
here is mixed in with the other changes in this patch.

> +	case VM_REALM:
> +		/*
> +		 * Once the Realm is created, we cannot modify any slots that
> +		 * could be providing private memory. i.e., guest_memfd backed
> +		 * slots.
> +		 * TODO: Handle trusted device private memory slots
> +		 */
> +		if (!kvm_realm_is_created(kvm))
> +			break;
>
> -		if (new &&
> -		    new->flags & (KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)) {
> +		if (kvm_slot_has_gmem(old) || kvm_slot_has_gmem(new))
>  			return -EPERM;
> -		}
> +		break;

Imo this should be written the same way as the pKVM branch for clarity,
like

if (kvm_realm_is_created() &&
    (kvm_slot_has_gmem(old) || kvm_slot_has_gmem(new)))
        return -EPERM;

but that aside,

1. Why block creating memslots after realm is created?

Does ARM CCA have no way to add pages after a VM starts? This isn't
blocked for TDX and SNP so I think this constraint seems unnecessary.

2. Why block deleting memslots after realm is created?

This also seems like an artificial constraint, and it constrains the way
the userspace VMM operates when stopping a VM, like the memslots can't
be removed ever, the VM just has to be closed? (something like that)

> +	default:
> +		break;
>  	}
>
>  	return 0;
> @@ -2883,6 +2898,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  				   enum kvm_mr_change change)
>  {
>  	hva_t hva, reg_end;
> +	gfn_t ipa_limit;
>  	int ret = 0;
>
>  	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
> @@ -2891,9 +2907,14 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>
>  	/*
>  	 * Prevent userspace from creating a memory region outside of the IPA
> -	 * space addressable by the KVM guest IPA space.
> +	 * space addressable by the KVM guest IPA space. Realm shared IPAs alias
> +	 * the corresponding private IPAs, so Realm memslots must reside entirely
> +	 * in the lower half of that space.
>  	 */
> -	if ((new->base_gfn + new->npages) > (kvm_phys_size(&kvm->arch.mmu) >> PAGE_SHIFT))
> +	ipa_limit = kvm_phys_size(&kvm->arch.mmu) >> PAGE_SHIFT;
> +	if (kvm_vm_is_realm(kvm))
> +		ipa_limit >>= 1;
> +	if (new->base_gfn + new->npages > ipa_limit)
>  		return -EFAULT;
>
>  	/*
> --
> 2.43.0
