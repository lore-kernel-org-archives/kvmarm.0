Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76868370AE2
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 09:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787217628; cv=pass; b=RlXG8yyy0xi3wMj9q+SWWpqMiOqoDBkFcMR4HVuDr4st/Nz/vC2gN67Pwbzb2A1+IepCFw5cLjzJiMDGjYVTTwn/GySykk6r/4zKA8EhTtGHmD5/u6ctL4Z0hwV6+6uZ9jTccY52NkdLo31njlpNY407rJ/b28tQnHTFk1bm6Ig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787217628; c=relaxed/simple;
	bh=mCKwif1IQ/lLee7i1tlpkED0sCq1sTR3RlYMoWGxaM4=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HHPj5Ix+V4R29mstEIHWzu5zf6xX2LdWBTd22O2CbBqKU2DkJwX+wSkCjw8ZkbKZxPuxxX7YijmJtasbj8RH97RxHUuIXoGgnE6px3SPqxHW2QKMx2ysbY4llKbXVOs8K0UfF1msl1AhL+JsRIF5Y3Zx4NPBtAJf/XstSea7wyo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m6KPAOm2; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m6KPAOm2"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-52d590ce5cdso14150441cf.1
        for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 02:20:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787217626; cv=none;
        d=google.com; s=arc-20260327;
        b=QJrGNt6Jeu+mGQChiIKzC5zJs9rXv6XB0BVs6wae/hArCJqSWwnytcfXzdJCrZpHNd
         Wf3VD9vlKFXGf9GyYYsjbNAk8l+MUR4g/IwqdGpsTG2jGhWob7oL8kKYdbYHZFKUAjxW
         pu0NvY0ML7kyJ9Sacd2GhfW3PzYVSCG3Qkjhcy46Nf0nfyi/0HxBDIoWV4Bao+EFwH06
         n86kafDf1rOouQxITq9yAbTwX3W1xDkju9sRrJm6lhSYB3ezoWKU6mQ5zfL3MdmYOsSd
         1KAy90mLUma2U5UAY/J5d3zS/Aye11PRO1MOgmpCxRt/V7+FCBLxPDKp1GqnBia6gQOw
         l38A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:dkim-signature;
        bh=btEJqH3glvcBsRJbKg2L7KXKgyRtz4hJgj5UscNKC5A=;
        fh=1DG3hP6pbHd3i7R0EDgvO1q/ghFoOpxT+1kSShT9MRc=;
        b=NtVzhHcQh+Pm4XMOnBYpc2wofreGw/g9ukQuf/hhTjIrDB5VOm5j6Sogy0bwIfkojn
         rTIClJJFTYpU4etsopy02pk/TRBuVuCguFg49SfaYogb3dnXVhQ5mKyU1t+CYWUmngW8
         PV2h0AOR4+c6pqM9RcsNR98IPoCLGqVzcDAQO8NKLugJnik4Qpg8aKsbC5C7iQRkz/8j
         qOx0jC+uJltDJhHUtl4IDQqrEpoO7Ukz33fEe0HN9/tGURLKGeii/ppXnFUaP0pTUNC+
         pGMBstogPsVa2gkIYGfQty3s/7pLS8yKCWqNhoXCzMAv4y1rws9IOQ5NtV5myXSWz9Hu
         9Ryw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787217626; x=1787822426; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:references:in-reply-to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=btEJqH3glvcBsRJbKg2L7KXKgyRtz4hJgj5UscNKC5A=;
        b=m6KPAOm2wDsMzaOHHZdCz+w4KSdLDibDGtTmbjYgUdf9XHy1fBTzPueWwNT6bvBPhX
         w+osymFiTGbxycgdNkaSJm3Z6sIpV8s8MvQ325oFFqG6LtBR+9rv2PboJaWBA/aWLf/f
         OwX3R1HFx90UpcrQ1/DzOpVwEKF27+I/2g4vPTpj5vUEPbES+TZ3LAXUkjP1veObMbyF
         j3igTVOX4euX/T36qU9dNG6z8mCWkDJHJ4xDNI+WRxtm3fw1NaJuDzXqRYrB2bTLVkUZ
         Lb/6gZJ3NBC33j329nugTlZ4S1BI6SXJnHBC5eX1P5mxVme9BF8MSFGXAiiaWqkv29Bj
         ehyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787217626; x=1787822426;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:references:in-reply-to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=btEJqH3glvcBsRJbKg2L7KXKgyRtz4hJgj5UscNKC5A=;
        b=Y9Z9X0NGMk5gf7YIxo26ExsV/rGA7iyCpTBt8+I50mIBznuuyqzS3jCuOuUYvz3uHa
         ZlOroJhkTpNLlMV+e9BBko7Iy6ht/BAFwNXKj+MQIDhmTgsPCEIzXKaXiQFgkBk++k5M
         +4lk3FCa8hr6wHOCAnbhh9qgwu7Krjd0LaPGPMffi+okwo1U9eSHHGApBiufnGG8LlSd
         tgP7DUf2pFr/fFCItBJYLOL7QXR9drZfP/WV26X3oVw+IKyky6JQTYg8eGnIcUQ+R2V1
         GZvMgXyWHZtrYzU2rRDeXg+Y+ofrlbcqs2Ohn1gi/RbyRNCVToyBGXQIjgKlLmA5qtcs
         e2hg==
X-Forwarded-Encrypted: i=1; AHgh+RqSRwM+tHaMNxsvcEK8FPaBXY5mj1eAGGe2inCyy+N6En0AT8ZuHMKy48hgIe4m7y82T3XVJHA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwUwu9Yz0wD1axdznE1kGkibTxqc9M9NJZ3cWKcto9jeu1krkeN
	NQ6PL8ffoN3RqOQo67zsKj0uQP+jbY49+kW32WnxHN01MYU8qdp0OrcuxWngoGpVvluesW6kb2J
	ezwmuZCp5cnP/YIppr+fewGSKJl0xi7u1SoGOwdfX
X-Gm-Gg: AR+sD10gAvajHO+D8B+IAxSI2lNgSgktWiYW7IsDOtjqMZCifGwbibYPl8UmDVli3Nk
	3rGSZWmJtTZSmXppRN4LJIg8N5AD+x8mo+z5k5+S/3rvTIe3NdmdMNblaokFleHixXCpZ/J5exf
	/GrZiYbIa+zflfceOKpuym+xgsDybiV3zrJ0noyOgtrTVI2d/OYX9qs5we+nvMbnCNAlW6ylsXD
	u3jbN6S+p11TrMuXdTdu8WODePH6WwNzBZ4LKGOTWgAXm4cLubAz0TCqy8a+Kxm5QeAhCsBN8YN
	knJjK16leKPKMddFl3fx8TE+GQhKaB6klINRTBio6Guw6jxXlnJbQSP4aYdvzc0dLXZLyWdoe0T
	f
X-Received: by 2002:a05:622a:5148:b0:516:d955:ea6 with SMTP id
 d75a77b69052e-52dd58d3483mr104538721cf.14.1787217625625; Thu, 20 Aug 2026
 02:20:25 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 20 Aug 2026 02:20:25 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 20 Aug 2026 02:20:24 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260818092717.3F4871F000E9@smtp.kernel.org>
References: <20260818-gmem-no-return-page-v2-0-5298f42d49bb@google.com>
 <20260818-gmem-no-return-page-v2-3-5298f42d49bb@google.com> <20260818092717.3F4871F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 20 Aug 2026 02:20:24 -0700
X-Gm-Features: AcwNN1VYoQ5shf82DtyHbf0xd5d-e2E9t-61o0yco6Y-2RGI9BPKRpGen-uy2Zw
Message-ID: <CAEvNRgHEVxO+1Mkoc3-c2+qSrKWnD+BDe04NBvuwGU6BL0amzA@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] KVM: SEV: Drop page refcount early in VMSA reload
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [Critical] A preexisting vulnerability in `sev_gmem_make_shared` allows=
 a malicious SEV-SNP guest to cause a host kernel panic by transitioning a =
`guest_memfd` page to VMSA state. When the page is subsequently freed, KVM =
fails to reclaim it and returns the still-firmware-owned page to the host p=
age allocator.
> --
>
> --- Patch [3]: [PATCH v2 3/4] KVM: SEV: Drop page refcount early in VMSA =
reload ---
> commit 597ff1c52e82911967f2122ff1d77aa79a4a2d9b
> Author: Ackerley Tng <ackerleytng@google.com>
>
> KVM: SEV: Drop page refcount early in VMSA reload
>
> This commit modifies the guest VMSA reload path for SEV-SNP vCPUs to drop
> the page reference immediately after retrieving the PFN from guest_memfd.
> This avoids holding the reference across MMU lock acquisition and prepare=
s
> for future changes. The page's presence remains governed by KVM's MMU
> invalidation protocol.
>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index b34b11d7f8fad..d3d620bc04dce 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -4062,6 +4062,7 @@ static void __sev_snp_reload_vmsa(struct kvm_vcpu =
*vcpu, gpa_t gpa)
>>  	 */
>>  	if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, &page, NULL))
>>  		return;
>> +	kvm_release_page_clean(page);
>>
>>  	read_lock(&kvm->mmu_lock);
>>  	/*
>> @@ -4076,8 +4077,6 @@ static void __sev_snp_reload_vmsa(struct kvm_vcpu =
*vcpu, gpa_t gpa)
>>  	else
>>  		svm->vmcb->control.vmsa_pa =3D pfn_to_hpa(pfn);
>>  	read_unlock(&kvm->mmu_lock);
>> -
>> -	kvm_release_page_clean(page);
>>  }
>
> [Severity: Critical]
> This is a pre-existing issue, but can this allow a malicious guest to
> cause a host kernel panic?
>
> Looking at sev_gmem_make_shared() in arch/x86/kvm/svm/sev.c:
>
> arch/x86/kvm/svm/sev.c:sev_gmem_make_shared() {
>     ...
> 		rc =3D rmp_make_shared(pfn, use_2m_update ? PG_LEVEL_2M : PG_LEVEL_4K);
> 		if (WARN_ONCE(rc, "SEV: Failed to update RMP entry for PFN 0x%llx error=
 %d\n",
> 			      pfn, rc))
> 			goto next_pfn;
>     ...
> }
>
> If an untrusted SEV-SNP guest modifies a guest_memfd page state to VMSA
> using RMPADJUST, and the page is subsequently freed, rmp_make_shared()
> will architecturally fail on the VMSA page.
>

I need some help with this one.

For the initial VMSA page, IIUC snp_safe_alloc_page() gets a
non-guest_memfd page. This won't ever go through sev_gmem_make_shared(),
so we're good. snp_leak_pages() doesn't actually leak pages, it just
tracks leaked pages, but __free_page() is skipped so the page is really
leaked.

> Because the error is bypassed without calling snp_leak_pages(), the
> firmware-owned page is returned to the host page allocator.
>

For guest-provided VMSA pages, those can be guest_memfd pages. The
refcount taken is the one guest_memfd holds. Without considering
conversions, just considering truncation, sev_gmem_make_shared() is
called from kvm_gmem_free_folio(). Sashiko is saying that
rmp_make_shared() will fail, and the folio is freed.

Sounds like this would be a problem if the folio is used elsewhere...?

> Could this lead to an RMP violation and a host kernel panic when the host
> later attempts to access the freed page?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818-gmem-no-=
return-page-v2-0-5298f42d49bb@google.com?part=3D3
