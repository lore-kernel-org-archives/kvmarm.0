Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BBD2069C
	for <kvmarm@lists.linux.dev>; Thu, 11 May 2023 17:18:24 +0000 (UTC)
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-43624fdd9c9so754015137.1
        for <kvmarm@lists.linux.dev>; Thu, 11 May 2023 10:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683825503; x=1686417503;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9g3QPSW366xmIBoE8HQa8vjGvWDy8pwzthEW0pwdt28=;
        b=MipUL06ocXBu9FwukZ7DW2NA1NNmGyNqva3aZjTBC2oESbDvCcvVfylCT66cV7ezIB
         uPV9b5xDBpZIoxSEiZ0Wdsg3gBTvXTrF+mGI03zCPmSJWYoozdYYGiA11wdrwZSlycz4
         /i/2ycYyXxlhTDLPgPT8d7HeXqziet8Pk/HTK6fG+IrW3wE/ZFxtD5lLLvucOMfvHN4P
         OnvYzhpFk0LeFtwrEh8aCwnzHSGk7OqTxlIg8cAjqZnLLCUjGfsRlf/Ter8CLOi5Az2k
         JT4ihBgb0+2dcyW6LpjlZD2V7TlpzkZS+EuXMmwvlb9s+Y8SPJ+9CDw4OJCpsgKnu4wU
         eYqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683825503; x=1686417503;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9g3QPSW366xmIBoE8HQa8vjGvWDy8pwzthEW0pwdt28=;
        b=gRuRagZTjIVwHqeEcO8Z4AjHq67VyenKAkLhwgu3t/Dlsp+D1PZpf5afCXQk913sdV
         Dkv0G4jyalulReiDFqfdzcmbUp0mvhj+dIumIOpO7VAWtTn7nvRDSoxeG5UJhR0Aox6k
         Y+Y0sQ/R8sCCJAv4zMKWJoC3ByAPMTmKWrGwhRrMdtIHC78uKynzYQxwrnXcf04z3jSQ
         MiLtXnhK7POTzlIM/cFH66mdRmdj9db7F9GA+5XiE14j9a20u6bIOM/7L8uCL90HqT2r
         nCHJKYiBdA7WUp7B9/YVTTi0UKZruchHV/8DpfW7zpqiFQ3V/yy6qhZManb7a9nlWhKi
         qleg==
X-Gm-Message-State: AC+VfDyNSGxqfQ6OtZRzLQXJuVNpuAy9s5a+E1G0CoJYPvZlb1Wgqtt7
	ykib/X9Y6rXiOqo8sxFRQld7WvpSHV9BcWgWjZfODQ==
X-Google-Smtp-Source: ACHHUZ43+BQhWUSZulu6UjBHzIWdkmWmLNZmOzHgMSGV0VvNDJlrAeTewbS6qaqSQipZKGmlTn2mDi8c09VzxKLRTOE=
X-Received: by 2002:a67:f047:0:b0:42c:761a:90ed with SMTP id
 q7-20020a67f047000000b0042c761a90edmr8867617vsm.6.1683825503429; Thu, 11 May
 2023 10:18:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZErahL/7DKimG+46@x1n> <CAF7b7mqaxk6w90+9+5UkEAE13vDTmBMmCO_ZdAEo6pD8_--fZA@mail.gmail.com>
 <ZFLPlRReglM/Vgfu@x1n> <ZFLRpEV09lrpJqua@x1n> <ZFLVS+UvpG5w747u@google.com>
 <ZFLyGDoXHQrN1CCD@x1n> <ZFQC5TZ9tVSvxFWt@x1n> <CAF7b7mrTGL8rLVCmsmX4dZinZHRFFB7R7kX0Wv9FZR-B-4xhhw@mail.gmail.com>
 <ZFhO9dlaFQRwaPFa@x1n> <CAF7b7mqPdfbzj6cOWPsg+Owysc-SOTF+6UUymd9f0Mctag=8DQ@mail.gmail.com>
 <ZFwRuCuYYMtuUFFA@x1n>
In-Reply-To: <ZFwRuCuYYMtuUFFA@x1n>
From: David Matlack <dmatlack@google.com>
Date: Thu, 11 May 2023 10:17:56 -0700
Message-ID: <CALzav=e29rRw4TTRGpTkazgJpU1zPML3zQGoyeHj9Zbkq+yAdQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
To: Peter Xu <peterx@redhat.com>
Cc: Anish Moorthy <amoorthy@google.com>, Sean Christopherson <seanjc@google.com>, 
	Nadav Amit <nadav.amit@gmail.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org, oliver.upton@linux.dev, 
	James Houghton <jthoughton@google.com>, bgardon@google.com, ricarkol@google.com, 
	kvm <kvm@vger.kernel.org>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 10, 2023 at 2:50=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
> On Tue, May 09, 2023 at 01:52:05PM -0700, Anish Moorthy wrote:
> > On Sun, May 7, 2023 at 6:23=E2=80=AFPM Peter Xu <peterx@redhat.com> wro=
te:
>
> What I wanted to do is to understand whether there's still chance to
> provide a generic solution.  I don't know why you have had a bunch of pmu
> stack showing in the graph, perhaps you forgot to disable some of the per=
f
> events when doing the test?  Let me know if you figure out why it happene=
d
> like that (so far I didn't see), but I feel guilty to keep overloading yo=
u
> with such questions.
>
> The major problem I had with this series is it's definitely not a clean
> approach.  Say, even if you'll all rely on userapp you'll still need to
> rely on userfaultfd for kernel traps on corner cases or it just won't wor=
k.
> IIUC that's also the concern from Nadav.

This is a long thread, so apologies if the following has already been discu=
ssed.

Would per-tid userfaultfd support be a generic solution? i.e. Allow
userspace to create a userfaultfd that is tied to a specific task. Any
userfaults encountered by that task use that fd, rather than the
process-wide fd. I'm making the assumption here that each of these fds
would have independent signaling mechanisms/queues and so this would
solve the scaling problem.

A VMM could use this to create 1 userfaultfd per vCPU and 1 thread per
vCPU for handling userfault requests. This seems like it'd have
roughly the same scalability characteristics as the KVM -EFAULT
approach.
