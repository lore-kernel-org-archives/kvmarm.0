Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A04E46BA
	for <kvmarm@lists.linux.dev>; Thu,  9 Nov 2023 08:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FpvZcgh6"
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-7b625ed7208so224695241.1
        for <kvmarm@lists.linux.dev>; Thu, 09 Nov 2023 00:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699520132; x=1700124932; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LW/Fx883nWIRZKyM7HAb/UStNZnvbG60FpXDwf7xK7Y=;
        b=FpvZcgh6vYlJhu3iN281wf9zUhSOfwuGV7Ii5dGwZSzacNxa5Klk+kSn6egRFPUfn2
         UkqFGXV+Ftg02wlMDUfgqGEV9PO3yhCSEz3QohnFgWFMYENmJbeTcECxN8xg18EnYWhs
         cX2HgYH7pffauo/4/ipVc+a4FjFWZH2tNl58KMjo5GAJmPxUoyKS9dQksMowQxGEXz8C
         ZCLAOhhekoxH7K2j0Ag1womdTDTrL7JIqgY48b1rPuhCTDmYdcdj3AwKF+muEJZ2C6iS
         /bTX4FYB7g8xjfgC4eLrgrl+Syoek5F29WXFdRRKYtX3xiKZGYlq6y3XFgwbElkAkH2W
         Lgkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699520132; x=1700124932;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LW/Fx883nWIRZKyM7HAb/UStNZnvbG60FpXDwf7xK7Y=;
        b=CJskpsfbkGrCwV7JmKskDWHGHXwwl1HE1WHzXQ4yY+RQllOWUJlhGoK6lmWtvLdaR9
         KXPDO/IB8UFOElkMQgFqi39JiPGCSFfQbk+8M6627dJ5GNaNeAMIi91QVddShmI7Jx5E
         83uXMPg6qOF7qJH67voYHvN/3WKluXnYiS9Zpi5hXaiT82e2fh6TOX7XcQEryCsfloq2
         X5g9dkalu2r0WHFyDSAcwE3ocamtsvI02Z+1vks34e6yx8g9jcIoIhXJUhsnH1xdqSj5
         j/7/ZfiGFd7PLO0m1j7KM0PbU1isNemti7TpqZw+bGTGnryDYnjSKAN++fyh0a2kxIFG
         jGsQ==
X-Gm-Message-State: AOJu0Yy2xKHgI0whMu0ZC6dVXSvI7T/oAnz3k/kJsmBV85TSUMhh+UUp
	B0Y6iUulhtr3gS03S2yHlVRi+Bk4FU7v+0yH/r+rWA==
X-Google-Smtp-Source: AGHT+IFw1OMfZ7dogx5GHZ5PY3FJDFYi1Xj9fX4uGT6v90sIMw1YGf7XiATC8vKEmYII9um0nqZKnx8f2F+kXqvVgVE=
X-Received: by 2002:a67:c282:0:b0:45f:65e9:f070 with SMTP id
 k2-20020a67c282000000b0045f65e9f070mr3952209vsj.12.1699520132149; Thu, 09 Nov
 2023 00:55:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231105163040.14904-1-pbonzini@redhat.com> <20231105163040.14904-35-pbonzini@redhat.com>
 <CAF7b7mpmuYLTY6OQfRRoOryfO-2e1ZumQ6SCQDHHPD5XFyhFTQ@mail.gmail.com>
In-Reply-To: <CAF7b7mpmuYLTY6OQfRRoOryfO-2e1ZumQ6SCQDHHPD5XFyhFTQ@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 9 Nov 2023 08:54:55 +0000
Message-ID: <CA+EHjTxxBUHX9Rg=vZ-UTWHUPKf0ujTsOsynueG7JAMt=GZQ0A@mail.gmail.com>
Subject: Re: [PATCH 34/34] KVM: selftests: Add a memory region subtest to
 validate invalid flags
To: Anish Moorthy <amoorthy@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Sean Christopherson <seanjc@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, David Matlack <dmatlack@google.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	=?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Anish,

On Thu, Nov 9, 2023 at 1:08=E2=80=AFAM Anish Moorthy <amoorthy@google.com> =
wrote:
>
> Applying [1] and [2] reveals that this also breaks non-x86 builds- the
> MEM_REGION_GPA/SLOT definitions are guarded behind an #ifdef
> __x86_64__, while the usages introduced here aren't.
>
> Should
>
> On Sun, Nov 5, 2023 at 8:35=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.com=
> wrote:
> >
> > +       test_invalid_memory_region_flags();
>
> be #ifdef'd, perhaps? I'm not quite sure what the intent is.
>
> Side note: I wasn't able to get [2] to apply by copy-pasting the diff
> and trying "git apply", and that was after checking out the relevant
> commit. Eventually I just did it manually. If anyone can successfully
> apply it, please let me know what you did so I can see what I was
> doing wrong :)

For me I applied the whole series as follows:

Checkout kvm-x86-next-2023.11.01 (45b890f7689e) from
https://github.com/kvm-x86/linux.git . Then use b4:
b4 am -o -  20231105163040.14904-1-pbonzini@redhat.com  | git am -3

Cheers,
/fuad

>
> [1] https://lore.kernel.org/kvm/20231108233723.3380042-1-amoorthy@google.=
com/
> [2] https://lore.kernel.org/kvm/affca7a8-116e-4b0f-9edf-6cdc05ba65ca@redh=
at.com/
