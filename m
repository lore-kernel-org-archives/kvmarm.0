Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F208D13AFD
	for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 17:01:45 +0000 (UTC)
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-48735dd1b98so2341813e0c.2
        for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 10:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692118904; x=1692723704;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6TxN9usqvIHEtKCyYGbomb7dCqmFUaFMC3Ca29a12X0=;
        b=pLbZIgivHluXPyq7S/WZczD4m5btDbQ0T/1Dxwog88giro2xyib6yb4/LNN8M4fVcD
         dNAqv4n7hejPMI/Irx9oHjOBbGS8Ccg0oQDo04QHQXPXs+I6i46RSBd+t/3ZIQbb6C0a
         avf6umohXpnZZVpwIR0TJ34NcnKmKJQg0SS3r4o2FHOQ9Ff/oWMUAg7ElGPQwcm8F1qz
         LV57X8kGBAZ57f4RBSzYR5kZOquxFxhen8i/cYMu4K1ILXiLT2/Ahr5+4QM7CgaotPZH
         6jYpzOD1W9AsLhsbu5t+Nf3UcJKinN0qe40oQNb9gI1UBpDB0AnL+2t6Ze1Ot5ATWa46
         qpuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692118904; x=1692723704;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6TxN9usqvIHEtKCyYGbomb7dCqmFUaFMC3Ca29a12X0=;
        b=RNxOgp3oybc4nDGuYk0XWOiNFbTFN9WjpLs/hdCeqavMl5ZXY/gVeNxpuM4lYGAvl9
         s2WZeBjuSNaC6MNnUwP7bUYYIZF8Q4ZSbA5ByAFjQjWKb4WBsFeJS5vRN2sKKbqn9MHb
         gR/I2nxdT0X4K73ACOTHvVO/U7rbuxGTJ1bIIdB/NvoE1KUsLFOibPJqupwdUDwDc3bt
         xTbru8lYwZW1UvIX3rAIJLnpz3m/K+XoIsjxpc/cQAzSXEx0rozN4y+4iviQI/HQa2HL
         /hBWhoUWzcH8z1U9LNIaqtXqRmgV1UY1CyHPrMPmtgp/NU6xDmvVQ6UIKO/BiFNJ6iys
         K1UA==
X-Gm-Message-State: AOJu0YwOHI8STExFyzgputNrzJdkfcw1SbuC+VGi0+N1pinyB8rjHUFQ
	Os7MIKlZ3sdE7s64U0ypfoms0cyEERhWZd7AE8KhHQ==
X-Google-Smtp-Source: AGHT+IGRkdcBbGkSl8f2JCtIPqajxHtZbYH+KVrXQXIFCZSf1dvCnHeO10WOmBQdfgHeDs7nMq0+gqSa/sO15MN9aXM=
X-Received: by 2002:a1f:bf81:0:b0:48a:5f32:dd53 with SMTP id
 p123-20020a1fbf81000000b0048a5f32dd53mr188496vkf.3.1692118904585; Tue, 15 Aug
 2023 10:01:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-4-amoorthy@google.com>
 <ZIn6VQSebTRN1jtX@google.com> <CAF7b7mqfkLYtWBJ=u0MK7hhARHrahQXHza9VnaughyNz5_tNug@mail.gmail.com>
 <ZNpsCngiSjISMG5j@google.com> <CAF7b7mo0gGGhv9dSFV70md1fNqMvPCfZ05VawPOB=xFkaax8AA@mail.gmail.com>
 <ZNrKNs8IjkUWOatn@google.com>
In-Reply-To: <ZNrKNs8IjkUWOatn@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Tue, 15 Aug 2023 10:01:07 -0700
Message-ID: <CAF7b7mp=bDBpaN+NHoSmL-+JUdShGfippRKdxr9LW0nNUhtpWA@mail.gmail.com>
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
To: Sean Christopherson <seanjc@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 11, 2023 at 3:12=E2=80=AFPM Anish Moorthy <amoorthy@google.com>=
 wrote:
>
> On Wed, Jun 14, 2023 at 10:35=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > +inline void kvm_populate_efault_info(struct kvm_vcpu *vcpu,
> >
> > Tagging a globally visible, non-static function as "inline" is odd, to =
say the
> > least.
>
> I think my eyes glaze over whenever I read the words "translation
> unit" (my brain certainly does) so I'll have to take your word for it.
> IIRC last time I tried to mark this function "static" the compiler
> yelled at me, so removing the "inline" it is.
>
>...
>
On Mon, Aug 14, 2023 at 5:43=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Can you point me at your branch?  That should be easy to resolve, but it'=
s all
> but impossible to figure out what's going wrong without being able to see=
 the
> full code.

Sure: https://github.com/anlsh/linux/tree/suffd-kvm-staticinline.
Don't worry about this unless you're bored though: I only called out
my change because I wanted to make sure the final signature was fine.
If you say it should be static inline then I can take a more concerted
stab at learning/figuring out what's going on here.

> > Btw, do you actually know the size of the union in the run struct? I
> > started checking it but stopped when I realized that it includes
> > arch-dependent structs.
>
> 256 bytes, though how much of that is actually free for the "speculative"=
 idea...
>
>                 /* Fix the size of the union. */
>                 char padding[256];
>
> Well fudge.  PPC's KVM_EXIT_OSI actually uses all 256 bytes.  And KVM_EXI=
T_SYSTEM_EVENT
> is closer to the limit than I'd like
>
> On the other hand, despite burning 2048 bytes for kvm_sync_regs, all of k=
vm_run
> is only 2352 bytes, i.e. we have plenty of room in the 4KiB page.  So we =
could
> throw the "speculative" exits in a completely different union.  But that =
would
> be cumbersome for userspace.

Haha, well it's a good thing we checked. What about an extra union
would be cumbersome for userspace though? From an API perspective it
doesn't seem like splitting the current struct or adding an extra one
would be all too different- is it something about needing to recompile
things due to the struct size change?
