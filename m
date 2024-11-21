Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7231BE84B
	for <kvmarm@lists.linux.dev>; Thu, 21 Nov 2024 09:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732182148; cv=none; b=IqmksAnnqd329TZEReFqB3sh7THWZyBAk7XLvKqQ3KkaKLrWWqs/DYR0rVuuhw+LFa+to6szDDgDQtXgc39x0Q+hNtBpgLyrQByTPYHr+czfJUqJX2sWBaMyWb2UskDU1IyEjBT8KrF6TkTJAEASdd6g1Lty+oW7OLgqiyqfOoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732182148; c=relaxed/simple;
	bh=rzBEZf/k85AJWre+PG3JbyGG1C6M67qkOpZieb88lAg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WhKdCWIIILaC3Le/PQIWyh7ssztVgmyt+ixKw9MmUntEZ//xVs9cq2a1q5dEt6pM0MWaw3fISJr5DCG7eXdmvFOoA+kyUTXnAyDa1sTweLtYy5dRs48gnOtbJb7yRRMUhggf0b6J5tY/5NxnH5XfxSU6MQYSjnAUoGaK8JA/q+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o6o8cS/T; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o6o8cS/T"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-460a8d1a9b7so163241cf.1
        for <kvmarm@lists.linux.dev>; Thu, 21 Nov 2024 01:42:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732182145; x=1732786945; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rP8Da8s2wnevMi29j7d8+2oFJbj2lRWCCDSZ4S6BMjE=;
        b=o6o8cS/To0k7xaOdOmbwpRrn3S4LvomFN8eskaNQWmxaZqBtpkhjrulC/M9vZTEKkn
         iIO4BNbFpn5rHY7mnK25oKipaLUDb2AYbypJJblSgq7Spj7fIXpOHExa51+caeVZY7C5
         r3IvC6yPsYsIwgLL9resMz1t0wzDvzQqNGfoapzIhKoMbkKlmMXhLPHLqtqVzdETPT3q
         95fPn7f2dSH63F+2ACNoh5iFKTYdr/LSKN/nFbn4lP+y9Le8ikUrGtKgD8P49MnlDESb
         ga6ukClVku8AuU/+JypG2rbwIhSh0zMA6tuIAgxed1lBX6KR6Q7fiz+ooe6kzPO62dKd
         tFIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732182145; x=1732786945;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rP8Da8s2wnevMi29j7d8+2oFJbj2lRWCCDSZ4S6BMjE=;
        b=XPstboo9SyL7m3Ib6XKRhVlkjVcacAUC68jQCZs1300KcrrI+0SXbLytJVnJl8fwwz
         +M/rFIhZOYweWOiczbfWXvJzrP2VFqb1sTdiNfaKqspokyzi8O40AIjGsJVFcL5ZjDR3
         KbuRPE4/jKqxXhVnB1VMTR62t8ZCkEuEPyHW0cA9GASZ+W6LZoMIVcL30YHwgRjQd9TV
         wrxk+JKi6fJHhd1+5bOWNxS0LzocxjjQ+TDu6v7XBxMvFM89Juw0IyThQ93cdtFS6VMP
         XBdug6qpLHthziz3falctJB8J8gNTSh6O2mEsDVNWD1R0dBmP3FShixT+I5QTw6SZMJS
         F9/Q==
X-Gm-Message-State: AOJu0YyzsLS4uoeNI+r5BfYWzErOfYVpIIPJcfZ6fi8dQ1JskaH3I95r
	9bNRR9+kGsVmlTnRNrzD1Ot0FP/RU16k8lOi0fMMtxYj3OGtztYade6Qm6otidZUvLm887cCd9I
	G/5vl3jLuiUDGZN9qlzF37kAEhFF8pfLnH5ol
X-Gm-Gg: ASbGncsqYberK09EtU5/PAb1yumxOliipH7WHPQ/WMHs/BL1oEIHB//eeN9/SdO2dDO
	pI8+y9nOp0kXfGCKLbkk/F5NuuGOznmDtEWufxg41lH49SodjgvyTDa5Nzy68
X-Google-Smtp-Source: AGHT+IFz6PCHpbrIIj+vbX5fqVx29xCyDAikIqlQtMrrnG5d6xsAZ47MPsinRyCZ06YWTiincJIRrcrRSIzCHKH7CHI=
X-Received: by 2002:ac8:5989:0:b0:461:6e0a:6a27 with SMTP id
 d75a77b69052e-465300d14cfmr2591491cf.20.1732182144485; Thu, 21 Nov 2024
 01:42:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241120105254.2842020-1-tabba@google.com> <20241120105254.2842020-11-tabba@google.com>
 <Zz7wBU3BHW-XNnbr@google.com>
In-Reply-To: <Zz7wBU3BHW-XNnbr@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 Nov 2024 09:41:46 +0000
Message-ID: <CA+EHjTyGzjOnVnyqfS6LO5=_EhQY3CS18HyrnSmnfNF483yz6w@mail.gmail.com>
Subject: Re: [PATCH v1 10/12] KVM: arm64: Calculate cptr_el2 traps on
 activating traps
To: Quentin Perret <qperret@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Quentin,

On Thu, 21 Nov 2024 at 08:32, Quentin Perret <qperret@google.com> wrote:
>
> Hi Fuad,
>
> On Wednesday 20 Nov 2024 at 10:52:52 (+0000), Fuad Tabba wrote:
> > -static void pvm_init_traps_cptr(struct kvm_vcpu *vcpu)
> > -{
> > -     struct kvm *kvm = vcpu->kvm;
> > -     u64 val = vcpu->arch.cptr_el2;
> > -
> > -     if (!has_hvhe()) {
> > -             val |= CPTR_NVHE_EL2_RES1;
> > -             val &= ~(CPTR_NVHE_EL2_RES0);
> > -     }
>
> To be on the safe side, should keep the RES1 stuff for nVHE?

Sure. My thinking in removing this is that, once consolidated, it
would be easy to spot whether we could be clearing the wrong bit. But
I could reintroduce this when I respin.

Thanks!
/fuad

> Thanks,
> Quentin
