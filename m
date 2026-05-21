Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0474C4014AA
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 13:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779368893; cv=pass; b=t4CBFq7djq3Uqvcxurx6COkeCdoyHgQ3wPbePcZtt+9M0D4EFGMDJCXIAQ3hMWOVyOu0bbYwEqW2nZ5bVr5Idi5vMWvRoQM2ufSHEaBmrQIGpLeDgs9cjQKvXbwxrj1RMcbqop9IG34Kq19t0nOXfI4KHCOTeJc2K1uDUDhi0+4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779368893; c=relaxed/simple;
	bh=WbUuWW43d3lbl0IDVPwVVeJJQED8p1k3PaKRHx/+LX4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TrULZO429bX3V2NTrKzFMMHkyR3IE7mcdxLUFCPAw7HMKN0PKc+ThvqjrsslweqhkmGEhMfpVyVAxsikemqKkTbFhYfrgsVLrRi7bxEOZlkNyXqRhoBgAsVHhkyKHAjgnNGQhkv4jlH7CgwLEs3AjBd5PdRAhUqRKCSGoMbz5RI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XnUQziCe; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XnUQziCe"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-50d6b393d60so15341cf.0
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 06:08:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779368891; cv=none;
        d=google.com; s=arc-20240605;
        b=Q2wPeC/nCqfF7Qzs6ULUDveGjpmiBQnOJeTd6pFb6H5koGxrV9d3PBTot0YVFOjZcZ
         JbnIc2KV+Fy7o5sghVXe7yM+xhrg814+7shgifmBojrGQ1PHRtMUYLs/YPdKoxEEnOaJ
         V3DvWmBprYZv9dmOphD8EFNOuMJdmVm1QbWXsXcrNvnSWky8AEmoWrMFrC0lcxfXfzwy
         nCw93NeTjPqVAyWZyFfui3A2zgdKNldQGvt+pi2N2hifqaz93QZynt2ziNyUBsAD+5ZH
         4FsJ9lWmG6vFbS9a/x1BLYg2QzuE/+nIcUMJygYkq2lvQPAg1RHtpuQdC9LMVU+ZEfYz
         wGig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=5cR07XDjlS+wXZUNvs0UUZjGctg9E4/1xeGtGHmHDoY=;
        fh=qf2/RxbHiViQhz56245m2R0UTb8kKAhpMpdZYpr350A=;
        b=dP3kLexKs+ot9N/qEbLosQ5CVheHTZuE2wQM2Xv4Rj1I2q61OUID19S5UkZGD7g+4L
         ki9wcQQ6vO+EnWiTzQe8vI1c3S6+HC2INehzcg5WzUY570lBW9gvVKyN98pcCOENMHnz
         FNBN7K1l5YSwpJYeDej+gSX1mAtVyJQuYgPVNfUQQE7oPnAIfUic1kwQKUo0HdMmuyYB
         ViTPuzOLYPjd/XHbKbiIx+fjHkAWvgOIG+0D2obcYBuJ5ttZoy+i62rtU6jI8yqgaF/d
         DqQu0mnPocMP5I/z4x+hb+GBjKWfHcJ+pWcSwFwZBzTt8aWMxhZI3EsKWMxz3zYAdoeJ
         KUdw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779368891; x=1779973691; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5cR07XDjlS+wXZUNvs0UUZjGctg9E4/1xeGtGHmHDoY=;
        b=XnUQziCeKRXouxYpS/pww0GBgpEPneV6/7rpkPvQ2jBIZNaZJgxF+ebUmm1su+9Peg
         voqrIMhOrfuAgwnRLVfi1ltJNPDb+zBQue1aIIW3ySfyQD6sEt7xeljBqEzQ3TZ7kHuZ
         gTs2X6w8G93PVcqFbErO090dVohpGqzmRBj2lDOv4skrTDnOFI/DH/FWCmFKyj041Nmv
         PNopXDY0yUyLC/dq4gD7uRxWL6lkirmy4vrm+6IEQNd1PQ+KNKe8EqFlBFqOLa/0CzZa
         tgOPD3eGspa0ZLOE67n2qxQq81VheHbohwnPVschw27tBoSaDGI1pWusYgPnI7Nq/bzp
         BSaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779368891; x=1779973691;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5cR07XDjlS+wXZUNvs0UUZjGctg9E4/1xeGtGHmHDoY=;
        b=KmfiY20osKMpla7pb3gHHaE+wsSLgbt21fuUYsZ6bHRDUZF2oroif3ZqATXe8Rv4E5
         ow/WSDSxAOOa+400d5utXCFkPPPj06EvQaKLsz0WozFzD9XsIqqABQrqOYMIpbtiArI0
         8Xsidk25dmRqc7ebbqXQa11UpuATm/5dkjChlzJPPqMCHf5o+9uHGrSKycuN5ZmoF8ma
         f8UL9qptBam7kbzp3haf1/pAV9/GmjyTwDJeuBMWrAehdiZ5duXJ0z+HBHs09UtrYas+
         nYoBy+ZMvIWCC03kCoTJ5/whhhLfqyVVhBCFabehMbYI0cAjGKUuhml4RfUJ7GYLuJK6
         ReDQ==
X-Forwarded-Encrypted: i=1; AFNElJ8OnUK11hAO14VqxDbmPI9+tagc/j3OXHxie/doSOi6AzK0KATrntWEnk05BiNDowJBqwoZgww=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx4jHe1lwoytb7ysPGULWfj6reJD58kprCl8CjyUroZJikJHNRc
	SZdB4ImHdzOgylQJ3nhzmlfbRz1aySO7fBAhGFDFQ+znxj5J5e42oBTfbUfLk4e3qhI1td4OR7M
	HxdjrQiH8W4Y9BuEiQN2X4h8pD80kMKJa2MzbzOq8
X-Gm-Gg: Acq92OGyePB/VIYLjvBqu6EShc2fr8oLPdbNYYpKBfQOoo/0BT66jqLRKK/JTduCgiT
	XQpvK0j0bxQrE8bX+QkY0jNaa0Gf2kJFzmtucSHP3QbVEFqHK8yxEL1N0A83/z9mctYUQUxieW/
	imb68H7U7LH5pLw1K27/lJd2TgOb8Fy2zXGrWVeGIaLYvrsn2U/nuT8CMJBT2QROHZftlB5IQ76
	7k4AszOirbidPpIsMTsX7MM7JTQG6q7+ljcdyq/x0OTKHH0QQEvNSrWwSG2e3F65X3C5FoEUwCZ
	3ZQW83Kr8rGCTWIZH1E=
X-Received: by 2002:a05:622a:5147:b0:509:15b6:f6a0 with SMTP id
 d75a77b69052e-516c533a032mr9304301cf.6.1779368890494; Thu, 21 May 2026
 06:08:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260521102149.804874-1-vdonnefort@google.com>
In-Reply-To: <20260521102149.804874-1-vdonnefort@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 May 2026 14:07:33 +0100
X-Gm-Features: AVHnY4JIjf2uZYHmJ4dR6Y-DYOh1okfQ1cljWLx4X95PZ0crH8aSvwnk1-SFv8E
Message-ID: <CA+EHjTxWp_NB3p+z-iVriSKq1iAd_CwpBVUprO30G36X2ZJfdg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Fix __pkvm_init_vm error path
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 21 May 2026 at 11:22, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> Sashiko reported a potential refcount leak in the unlikely case where
> insert_vm_table_entry fails.
>
> While at it, I have added a fail-safe to __pkvm_hyp_donate_host to ensure this
> function doesn't allow leaking refcounted pages.
>
> Changes since v2:
>
>   * Proactively init hyp_page order field in hyp_pool_init
>
> v1 (https://lore.kernel.org/all/20260521081250.655226-1-vdonnefort@google.com/)
>
> *** BLURB HERE ***

nit: missing BLURB :)

/fuad



/fuad

>
> Vincent Donnefort (3):
>   KVM: arm64: Reset page order in pKVM hyp_pool_init
>   KVM: arm64: Fix __pkvm_init_vm error path
>   KVM: arm64: Add fail-safe for refcounted pages in
>     __pkvm_hyp_donate_host
>
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 34 ++++++++++++++-----
>  arch/arm64/kvm/hyp/nvhe/page_alloc.c          |  6 +++-
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                |  4 ++-
>  4 files changed, 34 insertions(+), 11 deletions(-)
>
>
> base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
> --
> 2.54.0.746.g67dd491aae-goog
>
