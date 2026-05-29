Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405583A7D73
	for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 08:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780041974; cv=pass; b=LSnyj94ISID14TJbkirKsXpV8BsKU80/PR2+ZEttMAQo2u9lzdT5sVUHkQtGlKCUuT9prJ/V3TxRZ4m0Ou3L6qm2cAYlvk72UDKmk1xqp7FeJLcPe5UAbr+Lb4BIqcTf7H162vCkcO2HcQ5HLRVmvandcoZ98Rf5mdTCX4PhQiw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780041974; c=relaxed/simple;
	bh=Mejxta14fuvnz6WpFOU1DfxJEDSiC2l8Uq8GAcLC63c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WCPI967qG517m+/c7zAKI4UYqmxgD8/rKCFfUqEA9pFugO/yoIz48gRVP8nnG3K5Ubv6st7Ks24qd0fiuj5au4bmKLaXc6SOhwwzRIkLZQRhxlJDfxf/hRTS8UAYeLprW0nOmrYLli94IjNfMYSEhsy0X2gyP2IW1ohKbDhLJdU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fjT8DWzx; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fjT8DWzx"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-516d78ba1adso1431cf.1
        for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 01:06:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780041972; cv=none;
        d=google.com; s=arc-20240605;
        b=Ef3Ic94P61xGlCYrJMVMaJHEvBlPWHVTmWXTtkdNaeRzv5cpTDxEZX7Yl8MBOtJaTn
         AlqLsjrO0ZX6ZVbWpXGAgsTDeJOijitdOlBJ6eVU1q/rmDZs/Ypdz/vO+MWnwMsn+Pk9
         RxUc9r9CGn8gV3S8s5rlB5B79tIzOM/V2fkaN++6ykcnvFbAU81SITnoQ8SzJI5LzKpk
         uFSok+SgEiDkppvSEbASgsGv/4HlBJQHWOwIlL+mg7rqg3ZbSrB0JnEEBQKLd6rluIbQ
         IFqd+g+r/qxTn3vS8FSojZ1o63yLdDXb+v66iraqR90tm3Wok0P3CAUj6T3DUVATlPKo
         PusA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=f05sF6HcNfeY9NaPK45KVgik8aSR3ZDOtTZVDoaoPk4=;
        fh=wE+DKT5WEAB0jHCiPtsvyIUr6l4dIFTSU3UW5nCdDlk=;
        b=cOvyHSugNLdhkmp402F8Kj1LQdfRpd3soaEnCujTTY4EQSe9gMpzM6uSRjcmZuFJUs
         B/w/yW3KT7oQQryfEALtY/PmH8uWQyPrTt7GJUwqOktaIhcLo3z0NIQdFfswKgdtPGsQ
         8w96CowePHvzuxfhcRPkxnA0aI9SWteaieRF/Z/5jADaPtzyBsAvW/yH9qLrPz4f+byl
         NsGO/ZI4lRGhv8Ye7BrmrGNaJnTlM1xNvhtnN5xKkV153/AXk/OO6H3ZGDAzQic7SYs6
         ga4pTWkQow4AVRM9CadcLRHNz5UjDNYjtro+XnZoxfj9ZXSMEruCrmMXyoLPDTBYOk5Y
         5WDw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780041972; x=1780646772; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=f05sF6HcNfeY9NaPK45KVgik8aSR3ZDOtTZVDoaoPk4=;
        b=fjT8DWzxyfkiRoJBKRJ0bNqH5WcIbu9/qeti7jnrH9wx7SOVUgotgVPk2oniOvJy+q
         jqQ29WVF2DHbllb+VbZdDICM6q8lSHXY3gn4VW/nDNrUo32zg012ZM8QCm4OymbQyINj
         dKA7+dXvKrrtR5CCiyYnewh+aV91a0fUsoWj3V+XPFHGjK3JIgzVDQ+RnAWWmqtSNr9X
         1kjPOtBU3IhuLHeSWHz2rhwUEHI/dygGHIJ+k7pTSHIwIM34ez0DPXwePpsvO8ESR66M
         yl4QcYyD0DoncIN6gmw4uWQ3my/Bv+joSoP8oQJ7gHHO8eP1Ps0D2JpOvL/rDSsPgGMU
         p9Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780041972; x=1780646772;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f05sF6HcNfeY9NaPK45KVgik8aSR3ZDOtTZVDoaoPk4=;
        b=HIXymb2PbDARllYLjL208sRMychjyMFwpv3EyVNgh3abTOCsPQtlKq8+v+ghmjnOCA
         z5lyXNptM1/C2A8uoGH3s8liWUSYGElk93uQ0+3dYM3IiutLaSGUmAMpoldDzG6IbEVC
         Tz9U4OZUyGGLk3fIybPk/BuV1OoY+Ed8x0Y2WVa6YzdikrBeYKWPb9aQsd8AMJY6d7Os
         0KlNclS0SJNEIgIqsH3o2aBSnbfg1JM+ODLAzfnbaTPVnCcujNtaxFZQQH1wtqjhWPHQ
         IfVpB7P4IC8i4kIbxmZ79AHuVt2ZP29tX1PKsVhNsJ/3XxdDjjzkkwvHCZKehKMW854N
         +xYA==
X-Forwarded-Encrypted: i=1; AFNElJ8HNTXOwgYFW7xV+Y0BQNi/M2uJyp6zAcY7V8WdjWVLqLuqglMtDLkU5/WpeTz7BKvn34EN5fk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzDqCGAu3da+MwOv51rPakyqMUlOC34l1nMS+iZ/dGptYdM+bxo
	vzLYCh7FXnW/SQKFoZb3wxNsO1IVBmwiEiyuKNW1cBw7EDWOPdZRnNvtTrMqg8CG4C5tBNuHRIr
	Skali0OtHj3hztUQwmr5VwCNzMbDj7nSGG/rG52nT
X-Gm-Gg: Acq92OG0nBN6PQkCZQtS2A8lf1Qmj+iDVxg2TMtMzkwfu+/mdmuuhT/qwfvnO2Dr8n9
	a+geM3FK8mgKuLqGhwZnRSbV0COwL/8fzU32FHaJxpYNh/0M/7pvTglH7N9x1tDDC67he9e5L0K
	3F3lgtrJBMo6RT/y9VIrfDrHdEINvvfBtcs+lkUNBJxuGeMf8KNQTGYjKuBoNFkNAJ7ASEuqGDC
	0J0vY1rx/B5TLc5Sl1hpv98LzWtwq5UwzfHctVS4F2tf5B0y+4gwD2pG2yl61IHyxs7E2AhiLGO
	jy3s7MtthCFAv9lH2FE=
X-Received: by 2002:ac8:58d1:0:b0:50f:af60:3496 with SMTP id
 d75a77b69052e-5172f749fe4mr4695851cf.1.1780041971660; Fri, 29 May 2026
 01:06:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260529074341.2271950-1-tabba@google.com> <ahlIJQU-1b0mayPP@google.com>
In-Reply-To: <ahlIJQU-1b0mayPP@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 29 May 2026 09:05:35 +0100
X-Gm-Features: AVHnY4IsnAKmofdq6nk2K3297Z-C7ow2zDSgBYFAHw1ynri3vQ-SBvvvAsaLYy4
Message-ID: <CA+EHjTxktk4-B6qcAOf4O26++M5s6CKkkP539s4dRBRWxZN83Q@mail.gmail.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Fix host/hyp tracking on share/unshare
 hypercall failure
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 29 May 2026 at 09:02, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> On Fri, May 29, 2026 at 08:43:39AM +0100, tabba@google.com wrote:
> > Hi folks,
> >
> > Yet another bug I found while testing Sashiko locally with fixes to
> > review-prompts.
> >
> > share_pfn_hyp() and unshare_pfn_hyp() in arch/arm64/kvm/mmu.c
> > maintain a host-side RB-tree mirroring the set of pages shared with
> > EL2. Both invoke a hypercall that can fail (page-state mismatch,
> > EL2 refcount still held), but neither cleans up on failure:
> >
> > - share_pfn_hyp() inserts the tracking node before the hypercall
> >   and leaves it in the tree on failure, leaking the allocation and
> >   presenting a phantom share to a later unshare.
> >
> > - unshare_pfn_hyp() erases the tracking node before the hypercall;
> >   on failure the host loses its record while EL2 still owns the
> >   share, breaking later operations on the same pfn.
> >
> > Severity is low (no isolation impact) and the failure paths are rare
> > in practice, but the desync is real. Both patches are independent and
> > apply cleanly to current mainline. In other words, this can wait for
> > 7.2.
>
>
> I believe I fixed that here lore.kernel.org/all/acyKhZL2di_QQ9xm@google.com but
> as Quentin pointed-out, there's absolutely no reason for the hypercall to fail.
> So I haven't sent a v2.

At the very least we need to add a comment, otherwise, people like me
and LLMs like Sashiko would stumble upon it.

That said, this fix adds no real overhead, makes the code clearer, and
guards us against a future where that call might fail.
Self-documenting in essense.

WDYT?

/fuad

>
> >
> > Cheers,
> > /fuad
> >
> > Fuad Tabba (2):
> >   KVM: arm64: Free hyp-share tracking node when share hypercall fails
> >   KVM: arm64: Avoid host/hyp share desync on unshare hypercall failure
> >
> >  arch/arm64/kvm/mmu.c | 14 +++++++++++---
> >  1 file changed, 11 insertions(+), 3 deletions(-)
> >
> > --
> > 2.54.0.929.g9b7fa37559-goog
> >
