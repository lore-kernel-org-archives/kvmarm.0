Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0515E322B87
	for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 18:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785435367; cv=pass; b=NrNzt90sCxfvr8vSV49JGvFkIdXroBx+0XgYoJMC6+wYfxq0B78qT1kLHr4aoPlMjj1Des6ehg4QGTTU0O1rX+xxq90gc+171atzS4eswn+Fb7Fxz1duwAAx2svWZ6ws0erUJQ3VK7DtSSHFtc3YWWfvp06uKuojAQnuQLWrT+o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785435367; c=relaxed/simple;
	bh=ACnSUSFGOHB+6aR5J0+hOwYkWmGuBgWWNFIJt2FZc6E=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PUhyU4fik8TqAiDpaj4aWXwifidB2zVmM9Ju77EmkxSz/xatBT5AQjCEPrg2GOes7CD3x1iIvBXQLYCqmyyTrnTdWyzPY1eCWzoLwwBuR9B2OwDxPOrJQasiu6dxL8uqwMtbsqpQsSGSAQ+T3DLA82vWn5/LPo7NYPrE6GMBMJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bRYiY6ei; arc=pass smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bRYiY6ei"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-ca12086c06eso89831a12.0
        for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 11:16:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785435365; cv=none;
        d=google.com; s=arc-20260327;
        b=PEyuL4jsf6XxlsRjg0iyMv9hFDtAgvBVR2AqW7iFsHgUeAgl7/nTtjdT07spb4EeVW
         d4B6BY/TsYymwbnLsOCLAQ7nANmW+PHJR0r3pUFUpBr4pzmWpGtg56n30MXOFl7PXkUe
         iSTgD/H+RoKOS6+nvoz/ZaGaaS/jRgUm0BKrtfvm6V7XvWhRAGX+txm+rtuQ60Ytu4RM
         yRt0m8TSjE/6Njf3hpm2v3MHSPQtuVIx4/nto5B5TtI9paGtrVSbmlny0wI8fMVEfwrz
         1cXBpqR4dahM7hiGVGeTB/oAG9vWRboUskEtkv9roy6aWKaAPpPjZ/05TrE88i+oehsJ
         qwTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=jeT5JD84OLDwdMghWHFJO3a32W5zB/0PvPjAX4B/43g=;
        fh=YVcc2vGA6cu3Y2Xp32UBq2uq5Gfn3N++3jQpI8f/yb0=;
        b=Oosrml0ZRR6IcSGEWNd/Jy3QnkEQYJc1EFbywhqtI54KNsh/Y84g3RER2Mjwt9xbM8
         yQ+ycJO2RAca7zIrIrk8/uZuDQjSOtnCVtbA+hqNEMhBM0yCr/NFzwmaRUPLNY1id/4V
         VJf9n+62/aspxauoia6quNvgMwyDC27Kse0nkUmrSMZzxzbQRkUyOhZi/uw6QA2am4bk
         GKgjWU5JMhCQ8AAbYGyPJ/BlJk9wo55BzD91A+nISH43W3cb1NHwBUyyQ4APKcvvQaqD
         t/QFJ016SPJ1JXRENKIJJNv8x3rVSh8E0gwQxky4TJalQMXQmW+IEFMZsBqt+vfTXGJq
         6C0A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785435365; x=1786040165; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jeT5JD84OLDwdMghWHFJO3a32W5zB/0PvPjAX4B/43g=;
        b=bRYiY6eiB0O+OqIngME8thg9Sj3FZ9RebdO+thXLtxbD4BO7yZcQ2b18RLqfsOi2lD
         ewsw3IbyEZfNIeNIJAZNGfEzDH02i8gSMG7gTnRvu+lrmkWbgpdteEUO42+VU7ocwRSn
         TiPAxdOXTY+L/LiFm/12DbOnC0J6zQG/Yl8SopiyULpzCn1jyKWyUrCd7afk0NDC7OQB
         yndoiv0F3C8j70uXQTsPYDU55t8R0MALeHGrD99ghbljiGC9jIOoYXhAvoNcRFdeFujF
         7jtEbn2xc+hpOSnV/Jh2ZplPjKzdDu3Ux3YLFIC8kGxaBJg4DpMZlMxvzWx27PlWREPV
         /+BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785435365; x=1786040165;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jeT5JD84OLDwdMghWHFJO3a32W5zB/0PvPjAX4B/43g=;
        b=j137d2UCDGmu2rCgA0yvyscrQ0mAQLRIQ+/9r16wdgUUnnOndgkI2UrVE7l4DsSmTX
         CvoF0NTd3+cWH4qWBqVrsZxnZZe4to4E7HVXKTyTIf97SEpq17k+4j51MLv977DQyegU
         gUKJpiO7YWKHnboT5u37hZr3y3ZDtfkY1IDLISDU5+92rroKRUujxtMfMM9n9CVZm6s3
         R7Vnc1HWMLllaQcDzizw1UARbvdRsz2o+goOmS1Zf5wwUoq6V5it3mpEkHrwf/z5YtW6
         Pro7vqO5+Rv4m0YyfEvaXrl4t2Ma49x/caC+hUV8bybSy/tHMKEaS2aPgc4DVXIniGZK
         LVRw==
X-Forwarded-Encrypted: i=1; AHgh+Rok1lr7g0WBE1QvPG+R/itSFKgeYdRsQELkYDooyrMmAwcjjPnIICD1rOvlIlSQwG5VB3K7ZAE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0gknSn3jlP/AiU8xxL9BlRHDq+iYyefHPpy6yddJnPPEKObxh
	8ql+QYnsCS4ZNxpdMQSPNocOSNJOzMHgvcDs0T6cUsvdbi5hRTl7Z0TKHdKeqxAR0zvfLkh4vjg
	o0gMKwuGDqDUAVvQdqaVt+7q5UNBdyY79dQXcNZhI
X-Gm-Gg: AR+sD10bQgpD+uzd+hpEkLGeA3B100sn+yhFWS4qcmyXOBUuRtJ4JLk/sOGK2t7PtPN
	kWBFwVfw5pFaMJVj5APr8Q68oiI41YvJ+ENnGXP5VQGEJxVY1sz/j0Fr1gWVILS3sk/aq1tOAX3
	oYnfR+O/6SLdOzpcw5vj7LVg/pntDxC3BNvIY5N1safbV5ioRxainxsP3SXPzeyTcIvFL9zcqRr
	LE44laDOb9fRVZOjbe/tIYh/bxXqtdXhEjwciOmeMExotczEvl96urIKYf/6Lkqo1SfcIhaDpLP
	GmvgAR+AISUWAmXP8uNFRM7WehPJffkAlEswbmXPkJq07GyOzBDbEvQl8sd3uUqxADKonF2m9D/
	TY9NNvFa1KOc2MYEbUXU817UZfZwBsfuJWA==
X-Received: by 2002:a05:6a21:699:b0:3c3:a948:e2dc with SMTP id
 adf61e73a8af0-3c900759828mr3817647637.27.1785435364789; Thu, 30 Jul 2026
 11:16:04 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 11:16:03 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 11:16:03 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260728121138.1103610-9-tarunsahu@google.com>
References: <20260728121138.1103610-1-tarunsahu@google.com> <20260728121138.1103610-9-tarunsahu@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 30 Jul 2026 11:16:03 -0700
X-Gm-Features: AUfX_mwuYQlBmJdhbZSf7MRgmwyNG_KfxbR45Duou2tcQqjIodL3cnnQ31aoSzA
Message-ID: <CAEvNRgGJ0s5Vu8xRvfPmA39p2Bmkr-U7JFFkshM9Dyk9j+t-YA@mail.gmail.com>
Subject: Re: [PATCH v4 08/11] KVM: guest_memfd: Add support for preservation
 via LUO
To: Tarun Sahu <tarunsahu@google.com>, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"

Tarun Sahu <tarunsahu@google.com> writes:

>
> [...snip...]
>
> +static bool kvm_gmem_luo_can_preserve(struct liveupdate_file_handler *handler, struct file *file)
> +{
> +	struct inode *inode = file_inode(file);
> +	struct gmem_file *gmem_file;
> +	struct kvm *kvm;
> +
> +	if (inode->i_sb->s_magic != GUEST_MEMFD_MAGIC)
> +		return false;
> +
> +	gmem_file = file->private_data;
> +	if (!gmem_file)
> +		return false;
> +
> +	/*
> +	 * Only Fully-shared guest_memfd preservation is supported
> +	 */
> +	if (!(GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED))
> +		return false;
> +

The above check can probably be removed. I think the core thing about
this series is "we can preserve any memory that doesn't have any
encryption state that goes along with it", and so the check for
kvm_arch_has_private_mem() below would be sufficient to gate that.

> +	/*
> +	 * It makes sure that no memory can be converted to private
> +	 * even if it was initially fully shared (in-place conversions are
> +	 * prevented).
> +	 */
> +	kvm = gmem_file->kvm;
> +	if (kvm_arch_has_private_mem(kvm))
> +		return false;
> +

For now, has_private_mem == has some encryption state that we can't
preserve yet.

This also gates off KVM_X86_SW_PROTECTED_VM, but I guess that is
intended, since when work is done for preserving encryption state, we
can then test using KVM_X86_SW_PROTECTED_VM, and only then, remove this
check?

> +	if (mapping_large_folio_support(inode->i_mapping))
> +		return false;
> +
> +	return true;
> +}
> +
>
> [...snip...]
>
