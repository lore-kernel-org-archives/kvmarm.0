Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2BE63BA
	for <kvmarm@lists.linux.dev>; Thu,  6 Jul 2023 22:52:25 +0000 (UTC)
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-4714e9f07c0so353676e0c.2
        for <kvmarm@lists.linux.dev>; Thu, 06 Jul 2023 15:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688683944; x=1691275944;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xFM5vvARO4VuyjeAA2Dj/k0wZ3/yn5NXGhIXXP9dftY=;
        b=MHUkGf3/fge9q66ZxvPEmK65FMOZ8VR+wmtd2Zvk7hh1wGZloXnuwcl7kCrtmwEY5C
         ftQjgPiBYe8JoRAuH5ij6mP7Pkpv/fheILEj0kFC+IZMC5336Qchxhualm/zy47y3q+A
         /RITyAs8mYErrLRrLwZCm6KX4NXEcrO8Zw7RHVQkUCy7rTjEb5iFxhYxUvLjNWLkB14f
         GdIyZkbOz454L+ieerH5u9M/p6KpWrAH+v57zCIfWHKgSb8Yf8VqLvs3DEiAMQERqKIo
         mJ1v1VRWBnns1nPLlhKlfjQrzHAv16kF+drGTnrW592pYutm/H322OTLmCrqaqBuGA2c
         jflw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688683944; x=1691275944;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xFM5vvARO4VuyjeAA2Dj/k0wZ3/yn5NXGhIXXP9dftY=;
        b=a3raQafMe3kU8SAUvKbt2xVS6YT5KG2crYJj+r0mV7vYN61ngwiajkD72qPGpL4qt2
         Hko5vn8npm8RZFaq9ZjWD2O52ZMb76GFEOOaHVJ87fXxP1Q9DKtLNHG7BLdDjjld01g3
         xiW85bqDYSZ6b4Z2pLzXpGID2JMQvXZz0O0VLnLt7Yk71VgjEUcgEf1gHbxZqW9gzVDE
         OMddlsZxVWYEDcBrZey2ep64aJ4IOoe4KZuDWumFABKC2H/lP2y0ttytsRRpLfrb6xV+
         vDhtAHj449bO7MDI/YSR2tthOpawFWeKViKSng0E/7gE5kfKvqvdGIfOi+hqp0mf5Qfu
         vaaA==
X-Gm-Message-State: ABy/qLZbuS+R2S1Ic6WFm+flRZiYrywPKMHkn+D/B46Xy+CS7S57l6Hv
	iiWwm2aSNxeSPPCsc+vsPs8Eq47Xps9CEtkqK8GBUQ==
X-Google-Smtp-Source: APBJJlE6OuavnbaXWp2fxmaTb2w2owpzmowMWj1JftHly7x35c+8VnAE/uji/O8u8se8gY7tDrZf+b6qSx4yEgHqrS0=
X-Received: by 2002:a1f:458f:0:b0:47e:3dc0:ed1 with SMTP id
 s137-20020a1f458f000000b0047e3dc00ed1mr1658229vka.6.1688683943985; Thu, 06
 Jul 2023 15:52:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-6-amoorthy@google.com>
 <ZIoQoIe+UF6qix5v@google.com>
In-Reply-To: <ZIoQoIe+UF6qix5v@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 6 Jul 2023 15:51:48 -0700
Message-ID: <CAF7b7mrxNdMJZT=BQC5VP2EK7SdihW_BfaSywbtJpFz0bgiUbw@mail.gmail.com>
Subject: Re: [PATCH v4 05/16] KVM: Annotate -EFAULTs from kvm_vcpu_write_guest_page()
To: Sean Christopherson <seanjc@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 14, 2023 at 12:10=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> For future reference, the 80 char limit is a soft limit, and with a lot o=
f
> subjectivity, can be breached.  In this case, this...

Oh neat, I thought it looked pretty ugly too: done.

> Newline after variable declarations.  Double demerits for breaking what w=
as
> originally correct :-)

:(

>
> As mentioned in a previous mail, put this in the (one) caller.  If more c=
allers
> come along, which is highly unlikely, we can revisit that decision.  Righ=
t now,
> it just adds noise, both here and in the helper.
>
> ...
>
> With my various suggestions, something like
>
>         struct kvm_memory_slot *slot =3D kvm_vcpu_gfn_to_memslot(vcpu, gf=
n);
>         int r;
>
>         r =3D __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset, =
len);
>         if (r)
>                 kvm_handle_guest_uaccess_fault(...);
>         return r;
>

So, the reason I had the logic within the helper was that it also
returns -EFAULT on gfn_to_hva_memslot() failures.

> static int __kvm_write_guest_page(struct kvm *kvm,
>     struct kvm_memory_slot *memslot, gfn_t gfn,
>     const void *data, int offset, int len)
> {
>     int r;
>     unsigned long addr;
>
>     addr =3D gfn_to_hva_memslot(memslot, gfn);
>     if (kvm_is_error_hva(addr))
>         return -EFAULT;
> ...

Is it ok to catch these with an annotated efault? Strictly speaking
they don't seem to arise from a failed user access (perhaps my
definition is wrong: I'm looking at uaccess.h) so I'm not sure that
annotating them is valid.
