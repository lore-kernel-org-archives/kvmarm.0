Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D985716D4F3
	for <kvmarm@lists.linux.dev>; Thu, 11 Jul 2024 23:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720741987; cv=none; b=bKT3cdMdWD0bLtxiDGuPbU4aMmyUXoipZPwWL7gFKwQc9baqcKEI6YugtFCcnJO+fwxllVwpY/VV10ICUXYeqoZFgI2/AUoAmhM6zEsgXjjqmc2tQsUMvK+H9GU3PFIF8EBPhd5zpr0WCwS0PgLjM8Uq7ceCjVtHNFK76ATSAIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720741987; c=relaxed/simple;
	bh=eHwJddF+i82eOhfzBTfbWQn49KtPf7X+mrBUinBbdfU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l3NivrjAXyLC3AZpW0AX6ki588tbzzjBs1iY61KEiT4d/x/plsNDi++6GdTeYA2VHBaeTBEPdHJ2sPomoJQjkwAH4K5THGdY2E1kSjEcyyy+YxhwaZ0xgvZ+hOVDxw6uBdW45LoSM/xc03yfipiE7IYBA00tMrDs4E/U333iOfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T3ZidDsD; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T3ZidDsD"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a77ec5d3b0dso194178366b.0
        for <kvmarm@lists.linux.dev>; Thu, 11 Jul 2024 16:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720741984; x=1721346784; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J1ii8KLMLxRl5UF5VTiJZsw30BNj3HWI5MJg1fOCFrg=;
        b=T3ZidDsDWqJ69llep/01q4qnQQJPHwtZpcclVRUjec3uy0Z/9K7LRhRVVpIr9IVG+Y
         WkgD6U80gpSfYQp0L9TWnF91RthG8N42gYsPM1B1r68BZOxZfVXgu5WqCxYwSmWs2oR6
         XYNUuVvxavW5aYYUNuFDZaVWlh6CGMeNxdjCZ6XuSctzalxDOfXM2m4GmI7YchntRm7+
         rwAjFRyBh1cFCCWeAfF6qs0BGbHcA7jW58inXuibSWSBV94r0yVEG1Br7XBI/95reQKD
         u8rCd90I2Okf0N1VvmwpY2oTIC18xgqXw5wMXhrTZECluyJGm5m7xkgkE/Z+5iaZwRWX
         NY5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720741984; x=1721346784;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J1ii8KLMLxRl5UF5VTiJZsw30BNj3HWI5MJg1fOCFrg=;
        b=BtgRIXxg1SzttzMgeFLou3t4i/RLpJWcs6p+QaFvBd6H+rFPPLgpW11UUuNc1OsYuj
         DhyQLQN1IWdhJ+KYgKjb/biqUk4Ph2RUez6WNaSckgE8uA7XPbC7UztNDksBuUe0uNKa
         u7yM63/WbabWFebFlK3zdG5YMKcZtQU4yDDjwP5VX+e1aQRO/OuUFa/B45cLic8UIz3Y
         oNvixeOkVcvDBno5Vf49/BvAwijo5JpA2wPiRhnhw+49Zxbk7go+MAvB5sCVT2gLLZ3d
         QkUBgRObEVD7E7llexrD7E3vgoU/rctO+kQqS2RsIgmAGrh9Rvb80c7nEaE/r/D0nWqO
         ZvIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUisJALy+ZmQNAl0Mzdzg8Obhmh80jG255d53IPqx24Ovooog0qu9L+73qkW9LVTX3olW7VRwEMzEivLTlEbLN6IH7kZU7q
X-Gm-Message-State: AOJu0Yzh4PwHO04llO7TM/TPCXZN5bo4xePt1MV/tn8HZc8jOtm8mRko
	gwtVpnOr0PCn6dZbppNGTAXVIRWg6qtwYmwnCHtRtpfldQxAejDIj0b8lW+8mh5gXlyVqMwpcuV
	x3hyH9u1Y2DsB6NJ7BBKMHLrCI/Jtv4yJhnid
X-Google-Smtp-Source: AGHT+IGg/L+LIOLGS8JdBlkXQAM9OjIKvUIv0USQWI0ixWzGE8fSPNkcsknZoKiaKzNv9LECa/JaMTAQzxubG6QsFVs=
X-Received: by 2002:a17:906:cc9a:b0:a77:c7d7:5ece with SMTP id
 a640c23a62f3a-a780b701683mr557985866b.35.1720741984043; Thu, 11 Jul 2024
 16:53:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com> <20240710234222.2333120-15-jthoughton@google.com>
In-Reply-To: <20240710234222.2333120-15-jthoughton@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 11 Jul 2024 16:52:38 -0700
Message-ID: <CALzav=d=LaVCFTLxzJD8C_=6+fxjsoLxdKOnxKBgn_QdNDOoXw@mail.gmail.com>
Subject: Re: [RFC PATCH 14/18] KVM: Add asynchronous userfaults, KVM_READ_USERFAULT
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, Peter Xu <peterx@redhat.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 10, 2024 at 4:42=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> +       case KVM_READ_USERFAULT: {
> +               struct kvm_fault fault;
> +               gfn_t gfn;
> +
> +               r =3D kvm_vm_ioctl_read_userfault(kvm, &gfn);
> +               if (r)
> +                       goto out;
> +
> +               fault.address =3D gfn;
> +
> +               /* TODO: if this fails, this gfn is lost. */
> +               r =3D -EFAULT;
> +               if (copy_to_user(&fault, argp, sizeof(fault)))

You could do the copy under the spin_lock() with
copy_to_user_nofault() to avoid losing gfn.
