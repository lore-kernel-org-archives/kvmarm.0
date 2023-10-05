Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E1E38BB5
	for <kvmarm@lists.linux.dev>; Thu,  5 Oct 2023 18:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AIr6JwKG"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-57b5f0d658dso743029eaf.0
        for <kvmarm@lists.linux.dev>; Thu, 05 Oct 2023 11:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696531594; x=1697136394; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2VPf19ilHtAD+Owv0i7z4J+SpXRejSHrhSqcq1CMBKM=;
        b=AIr6JwKGYu0yEoKZObHNYo4yMiv9BDBWV5jcjhD7n6q0Ar5qS0g4wW9QJYuPa5/bWu
         jlAoKjm6N4ECbDDl8zUDwlM0LMETiwA8U468dBYgiWGBtLOhCkbij6fZ9/7YdWrD76da
         3UsB0+9PRe6ABadFROPLt+pZQymqCEkm4RALHsd8XGNEIehzloQX6mH1smOdnae+8M8z
         DcXyOsiJKuvpImiuEColad92Z2KYwniDTpObknxYdP2Cs4qHxLNfXdgroVY9yArS/RP+
         Vh7BvVgh0RQjWKW82MOQDo9OPlCq1n7mIHmg6b7omV6GiETK/x/OpXd45+HzvvLa3nmO
         Xgew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696531594; x=1697136394;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2VPf19ilHtAD+Owv0i7z4J+SpXRejSHrhSqcq1CMBKM=;
        b=Namw3KMk4MyrqB/ytLkXMwptAsR0B1A1x9SKuvm/8Iw3+FR+5KE4jAqKdYECrrws/z
         tt00+rzoYD+/07qdNkFGMkC7BDzAmGXs6t7xVTkSaywcHlEFQXfs5Db4SMc5QdvL0BLV
         qBLFkTXIGNwzFwCowNMUafMZVGBkRFT9ffisngXQ+a3Ad6J9hIILB1HmUggtyqp1CFFg
         InFTDVvbYWbOsKjgyTHV8//+10OzqOp8XfXlac82Ymc8tgVlrFEX5pYB+se3BR5xSt87
         qZrTnyvVzEHFezB7cpILUJaWM1XqMqx7X17O4nY6oqWMMA3bCKst4zGWfV9YuAn0X0mt
         deaQ==
X-Gm-Message-State: AOJu0Yw8jfuLgyAW8G/FBbOzZ6TjeeKwOUECpGq0lKQCkf4N82bI+Wy6
	rKRyr4BxsIjxPF+40Rcgqnr1YnshBHeu6hFTzHjKeg==
X-Google-Smtp-Source: AGHT+IGM/D0+4k30Jd6fhOvSgxFV+GVUeOTZeMDMYlEkNd1cdIy5uNOQnPXfsklEcDTJinrDOAa9oeR9V69J66jhHL4=
X-Received: by 2002:a4a:d2c4:0:b0:57b:f285:ae41 with SMTP id
 j4-20020a4ad2c4000000b0057bf285ae41mr6125209oos.9.1696531593929; Thu, 05 Oct
 2023 11:46:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-5-amoorthy@google.com>
 <ZR4N8cwzTMDanPUY@google.com>
In-Reply-To: <ZR4N8cwzTMDanPUY@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 5 Oct 2023 11:45:57 -0700
Message-ID: <CAF7b7moE19p+kDXuwaxHCY6=NXB95fNJ7ectNRxdUMMBpgT0Fg@mail.gmail.com>
Subject: Re: [PATCH v5 04/17] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
To: Sean Christopherson <seanjc@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 4, 2023 at 6:14=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> And peeking at future patches, pass in the RWX flags as bools, that way t=
his
> helper can deal with the bools=3D>flags conversion.  Oh, and fill the fla=
gs with
> bitwise ORs, that way future conflicts with private memory will be trivia=
l to
> resolve.
>
> E.g.
>
> static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
>                                                  gpa_t gpa, gpa_t size,
>                                                  bool is_write, bool is_e=
xec)
> {
>         vcpu->run->exit_reason =3D KVM_EXIT_MEMORY_FAULT;
>         vcpu->run->memory_fault.gpa =3D gpa;
>         vcpu->run->memory_fault.size =3D size;
>
>         vcpu->run->memory_fault.flags =3D 0;
>         if (is_write)
>                 vcpu->run->memory_fault.flags |=3D KVM_MEMORY_FAULT_FLAG_=
WRITE;
>         else if (is_exec)
>                 vcpu->run->memory_fault.flags |=3D KVM_MEMORY_FAULT_FLAG_=
EXEC;
>         else
>                 vcpu->run->memory_fault.flags |=3D KVM_MEMORY_FAULT_FLAG_=
READ;
> }

Is a BUG/VM_BUG_ON() warranted in the (is_write && is_exec) case do
you think? I see that user_mem_abort already VM_BUG_ON()s for this
case, but if there's one in the x86 page fault path I don't
immediately see it. Also this helper could be called from other paths,
so maybe there's some value in it.

> I'll send you a clean-ish patch to use as a starting point sometime next =
week.

You mean something containing the next spin of the guest memfd stuff?
Or parts of David's series as well?
