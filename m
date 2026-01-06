Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFC0350A0D
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 19:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767728972; cv=pass; b=Cvdq0JQY3Yw7v4oyQ/dA0wJISCG+HDAafLjmmWB49BYPWsiIFe+6MXlY0ssc3gm2PYgvkXd6EJ0z4wpuKJKOMXTFwSZ9NPjf3MQv4fV0nHuuEhbg5wGMSEb5UlWrLz4t9c0VvrIm30nAG8Zs66mSsVa3PoDJemMkjPKMJQ9nHJc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767728972; c=relaxed/simple;
	bh=p6oeRyLM2d9R8ycZvPrjdHpPqvJio4+nRSZFHhJA4O4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pAeKlDbhqPO2tpywkNtUUsMiCR5Tpl2qXO8Q3vyU2HRaLyoNO1r9S8jgfBX8w11VaViMxhymrgRXz5WlhwXdVeBwRUaPFMyGZBY+TZ8Pr6OZQf+xHljLNmQi6WkpPHZgCaWgN7rgZbjPgM5vo8ZR4yk5UHwbjTibwigay8FJebA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GMw8bEI8; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GMw8bEI8"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4f34f257a1bso62101cf.0
        for <kvmarm@lists.linux.dev>; Tue, 06 Jan 2026 11:49:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767728970; cv=none;
        d=google.com; s=arc-20240605;
        b=ieFQ6rCXoVKpycR48TTnOKrxCNHYtpxgWQo24X4/TEiist1faotfgpsIVP77+o5ir6
         lH0HH6kzCQrSrFEUiuDM4ySEo4c0bCNOwKO+vjHpX6+ra+rq8VNghz3QkgJgcn+AReYT
         jfoDWcZtj/QFvsozYHI/lpatTpkpoMcvt6JC3hgxhsb/yeUZsHfvZyQJVXbjvJbkReLT
         qC0lN/lNtAik5mvgGUwtKTb+8+nJMQoiBb+yI4XOrFlnzhTdBaz6D5fGUqn129T5fP6S
         xOuBnDKivlwB6ErCYEJw86L6gtn5Krjz+d9TkdlbsFHvPsLjNSpzVBcKmO6g1byQ/3R3
         fWiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=k9+aHBxxyMm5uEUryvCGnluoRKqqLv7iqR1X9acm+vo=;
        fh=TwtGZU/aGT05t/BR4SWkU0rue295yR7Mf+geIeV8PmM=;
        b=PrtU2Q9jPbJG/KRQrCV+wtFAoy49qATf0JI46a8ItCE49omrDfc9dsj83FnbllvxU5
         JtkaVbUowjF476QHa3XeRVaFtHqA/jeYC4L62Da+dKuiSg6BGkulsfv48uIFnDSS4Rx/
         aCO1SFTT+jt2RttopeSC+YQ6thVhv8hNJhkmc9qgAoBqRsFM2WKvyR6Sam9ICPsAGyk7
         bOk8kb7THJ22b0xD104khVgRq0czi7BYUi1BZber+5s8rIqrdwu0a03kaEX/2T3rRSx3
         OOHoItd2c4VqCYJdDXssDY3AacvcJV2ea/d/jQJk1pgIrjJFZdQjQrt3E62pw0F01RyX
         Dhbw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767728970; x=1768333770; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=k9+aHBxxyMm5uEUryvCGnluoRKqqLv7iqR1X9acm+vo=;
        b=GMw8bEI8IdsHt8DdotJLX6J+Prif9kN1qd3ZHKn/XS1y9n+4EjyRLJx3nSmXWG0mcl
         3P8ig1r2dSNrbcBPI9ScsRk89kM6gJ2qcmrja4aILwiug/L8E5n2+p3cS9LHv6HCtjDS
         eeGtjo0DsBqO1JYh81kovPTktJ2Y/qth9T9cQWK68o/rik49eZ0nyS1OyyVzxJ68RtD/
         58AEkbASXYz7EjZ2DtfMm48R37eap8JnbUqV8w/tg7t4u0dGxm4HwqPMGwDqn1TQb6Hx
         2ZyDt3u4v7FpNbr8IwvtCMkeSVXInsEy6jyOcpWb0k1Noc0nk9b4nRBfvsWewyuG/m4z
         YWTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767728970; x=1768333770;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k9+aHBxxyMm5uEUryvCGnluoRKqqLv7iqR1X9acm+vo=;
        b=JN7Fw/6xGSJUiJ7z/19KgrhpGenyuaS3BKXhekbwag8n4ohyBuCHkBGU0Qb8VRCgsU
         LrhA6nhQUYNpOquERwaFvonnnbrv5oobD+fTx+/mvtE1/34jjKN8nj6UK61Z17aSNr64
         WXDnOEaAyYH9Cn+Vqb2keVaoMIPu51Ovh042E+R8726Y51j0yoP2BU9R8yG9kbeyTc8h
         zqlNn56hK5sliZXUCpsGSTzKB1l5A287Qf7NXCK0UpIzMdWXzWVvOPeLYH0Pxo3KmUX4
         2eGIZ7JIUP/KJPnSud85Lx28GN5n/QGSVfMOElXPVSlpPq3uqy547xzzBVr8s4on903G
         3EhQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvJoxULNi6NdM28X2jyIOjE8rCOnXVlyo8Y4sZiu7MWgWW9+E8iNOF1CnWbJZKixdJV1ufKMA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwyCfmuYz5VUA1vE7bIT2Kv0BrJ/qHza5bDhEFvK2/HtYXLxtVE
	R/66OByhDwY1doSqy84seqchbbtAAzjbegc6L8YvVSSve4BhYURE33SKstim+jPdTgmDd9dNr4k
	tuG95/R11ZwrlvAJioilFJJw3TPudFOCv2LGiS9hS
X-Gm-Gg: AY/fxX49Z37qFITeP7jjuNmfS2f28/B55OV7U24Fv27WcWMpVaCw1qlcV0VO+sT64AC
	G5eFKTExSplLU0wlB8VFkBmCca3c4umW29Jm6OFiPGaMiubnnV41MdCFKxEYpd8SpTew3rSfa8C
	x8yqpJQyKC/oQFzaNs+3OtAcfMLum0EHdWJAjDQPJuenwiPb1cM3dnigut2iYyqJia95o1fSMoM
	qpDJLY7ixqRQV9gKG7RIRERHogk09X3s2Wv+Kl+3P8YtxUFvXYgNED5ue+U6ehGAh+r2yd4
X-Received: by 2002:ac8:58d3:0:b0:4ff:a98b:c33e with SMTP id
 d75a77b69052e-4ffb3c9bfd7mr1612321cf.6.1767728969218; Tue, 06 Jan 2026
 11:49:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260106092425.1529428-1-tabba@google.com> <20260106092425.1529428-5-tabba@google.com>
 <aV1mqQtALFIUBHVM@google.com>
In-Reply-To: <aV1mqQtALFIUBHVM@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 6 Jan 2026 19:48:52 +0000
X-Gm-Features: AQt7F2oD6imhUH1-IKtVcA97OhzMLb8nSqzV2q_rb-md0NTxT87GehM6m6PIMYQ
Message-ID: <CA+EHjTw3YBG9HNateXEAYsSUJ625eWGu2OHt-2=Y0=-qzbObWw@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] KVM: selftests: Move page_align() to shared header
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, 
	itaru.kitayama@fujitsu.com, andrew.jones@linux.dev
Content-Type: text/plain; charset="UTF-8"

On Tue, 6 Jan 2026 at 19:46, Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jan 06, 2026, Fuad Tabba wrote:
> > To avoid code duplication, move page_align() to the shared `kvm_util.h`
> > header file.
> >
> > No functional change intended.
> >
> > Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  tools/testing/selftests/kvm/include/kvm_util.h    | 5 +++++
> >  tools/testing/selftests/kvm/lib/arm64/processor.c | 5 -----
> >  tools/testing/selftests/kvm/lib/riscv/processor.c | 5 -----
> >  3 files changed, 5 insertions(+), 10 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> > index 81f4355ff28a..dabbe4c3b93f 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > @@ -1258,6 +1258,11 @@ static inline int __vm_disable_nx_huge_pages(struct kvm_vm *vm)
> >       return __vm_enable_cap(vm, KVM_CAP_VM_DISABLE_NX_HUGE_PAGES, 0);
> >  }
> >
> > +static inline uint64_t page_align(struct kvm_vm *vm, uint64_t v)
>
> Maybe vm_page_align()?  So that it's a bit more obvious when reading call sites
> that the alignment is done with respect to the guest's "base" page size, not the
> host's page size.

Yes, that's clearer. I'll fix this.

Thanks,
/fuad

> > +{
> > +     return (v + vm->page_size - 1) & ~(vm->page_size - 1);
> > +}
> > +
> >  /*
> >   * Arch hook that is invoked via a constructor, i.e. before exeucting main(),
> >   * to allow for arch-specific setup that is common to all tests, e.g. computing
> > diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
> > index 607a4e462984..143632917766 100644
> > --- a/tools/testing/selftests/kvm/lib/arm64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
> > @@ -21,11 +21,6 @@
> >
> >  static vm_vaddr_t exception_handlers;
> >
> > -static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
> > -{
> > -     return (v + vm->page_size - 1) & ~(vm->page_size - 1);
> > -}
> > -
> >  static uint64_t pgd_index(struct kvm_vm *vm, vm_vaddr_t gva)
> >  {
> >       unsigned int shift = (vm->pgtable_levels - 1) * (vm->page_shift - 3) + vm->page_shift;
> > diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
> > index d5e8747b5e69..f8ff4bf938d9 100644
> > --- a/tools/testing/selftests/kvm/lib/riscv/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
> > @@ -26,11 +26,6 @@ bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext)
> >       return !ret && !!value;
> >  }
> >
> > -static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
> > -{
> > -     return (v + vm->page_size - 1) & ~(vm->page_size - 1);
> > -}
> > -
> >  static uint64_t pte_addr(struct kvm_vm *vm, uint64_t entry)
> >  {
> >       return ((entry & PGTBL_PTE_ADDR_MASK) >> PGTBL_PTE_ADDR_SHIFT) <<
> > --
> > 2.52.0.351.gbe84eed79e-goog
> >
