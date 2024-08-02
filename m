Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF6C1ABEDD
	for <kvmarm@lists.linux.dev>; Fri,  2 Aug 2024 20:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722631893; cv=none; b=b1jbXk5o8O08FZwlyQ1dxrpOkaXlYQC6vkFJGk4XJQX79ZWD53BRCHbtKWQA4N6uMR5FF0EMLryV7onYpVPVpm1HoXZWYTVEm2fBqrMkbboPqtPukvX7u1Nd/R9EWf/TGyEAXTVW+2PdEQGC48+Da7omPFKQkgN3n5oHKKGeIXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722631893; c=relaxed/simple;
	bh=FueBNgDDCfYI2k+0y4y+ZR1Vsa5mvu9gB1exHHHan94=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m5ZBIVpKmaTP3MKE3BfXi2ULkJl3xRVjMyGg9nZGSwzrzhxtxRGMphkOUa/kjF/v8i4WVqIZsz0e35c4BoNwCLySLBNo+h07V1NMsR+NQFdi09GbAoG0IqBluXt0GcyVJGrzFv7fa9I2PKONxZtUs3jvKZw6AMES93jyI4wcgHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=trr31+XK; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="trr31+XK"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70ec1039600so7438646b3a.0
        for <kvmarm@lists.linux.dev>; Fri, 02 Aug 2024 13:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722631892; x=1723236692; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tXkYm8GWgU7Uugm4gxQOf+EOoFr0lG6UD/VJhjiOPnM=;
        b=trr31+XKy11/MzLdirIK//yfQfW9700ayrgHEcdomZFMv3nmtSH2gsEUl6/F1EGl8/
         CV1UF0MkpCq1w7hlAgF5TF7lQWxk8g/Q5jAowHCDS1aHpjt7HC+FwtJa72e+yvqng3hJ
         IG5Q1Yeuddfcj/2pLKtPdTpcs1283HJ9vSiQt07CUtzEM3/uBbHUj+A8aSb5eABKS3W5
         PGqWa7F80DfpX3GALMO+fhXS+0ONSfZPBG1mNiDnavO/AP+hFDus24JF5Y5zuTOwB7Vv
         6bvDMIzCovBmY7VuYmmLMFLiWf1J9wBNBNLXuJa7GtTygj2ZdhkkcFgAlVWYuC5VDpTs
         Lgsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722631892; x=1723236692;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tXkYm8GWgU7Uugm4gxQOf+EOoFr0lG6UD/VJhjiOPnM=;
        b=no2nN5hccnKvVf6srgFw8qpwUWqodeW4mXRdJrOxjGmBxFhX5uH9bZufDTN0lNVfLa
         stLrnFYiXIU4mP3N0E2tEH6/8kt5GMol9NdlaeKICQ60DSi5NZ6Re1Y3uxurNeX5rtfv
         YlEfBRFZN/P7nJGYiVtqEvRXGaBWNtwzCxaEUVwRy8i5aII/ZN0GhOP32XnEQ3wtZoDI
         JEnjlO1BGmfEUnSvoHlqKktKDF4a3kAZMNL7erE9xh3hVvIj1pzARTHH8uY8GSwNR/mn
         aQeImRQ7MInt4yccdH9QKIDNOoR8RmzbQN0fcqFZXSWLJ997gs6U161/u0H+u3asPTt7
         HuCg==
X-Forwarded-Encrypted: i=1; AJvYcCXnZ8ZyywrxuVj99DfWS07Cyh6RvviHoPeS3Dh2rWVDtU/Phty0Ep0FHDcbSJQTuidDlvMQouoBuKCva3hPmJcbMu8EAcgl
X-Gm-Message-State: AOJu0YxmRonIx9mkx/753JOiptap9JSnSKm7KmUilg/S+EQzozEhzt3V
	42jFXoWJoE4T3rayBNkj0GXbvqBoMTPWYjkewYfIznGBVe3vLuC7otJrg9tF1TWsWMOjvFgYP1o
	8dA==
X-Google-Smtp-Source: AGHT+IE1tZi1nsiH0SIgqwEaG7Vb1R0ZlJXHcVhuB6HgEl7rj1NR5a6/czPeOlKS3H+iSO3nwk8SFUENvrM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6f01:b0:70d:fba:c51c with SMTP id
 d2e1a72fcca58-7106d071bd2mr16631b3a.3.1722631891698; Fri, 02 Aug 2024
 13:51:31 -0700 (PDT)
Date: Fri, 2 Aug 2024 13:51:30 -0700
In-Reply-To: <CABayD+dHLXwQK3YdwVi6raf+CF3XOaAiAG+tfDYPiZFzqeVXpQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240802200136.329973-1-seanjc@google.com> <20240802200136.329973-3-seanjc@google.com>
 <CABayD+dHLXwQK3YdwVi6raf+CF3XOaAiAG+tfDYPiZFzqeVXpQ@mail.gmail.com>
Message-ID: <Zq1G0n-b8_C6DFp7@google.com>
Subject: Re: [PATCH 2/2] KVM: Protect vCPU's "last run PID" with rwlock, not RCU
From: Sean Christopherson <seanjc@google.com>
To: Steve Rutherford <srutherford@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 02, 2024, Steve Rutherford wrote:
> On Fri, Aug 2, 2024 at 1:01=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> > @@ -4178,9 +4181,9 @@ static int vcpu_get_pid(void *data, u64 *val)
> >  {
> >         struct kvm_vcpu *vcpu =3D data;
> >
> > -       rcu_read_lock();
> > -       *val =3D pid_nr(rcu_dereference(vcpu->pid));
> > -       rcu_read_unlock();
> > +       read_lock(&vcpu->pid_lock);
> > +       *val =3D pid_nr(vcpu->pid);
> > +       read_unlock(&vcpu->pid_lock);
> >         return 0;
> >  }
> >
> > @@ -4466,7 +4469,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
> >                 r =3D -EINVAL;
> >                 if (arg)
> >                         goto out;
> > -               oldpid =3D rcu_access_pointer(vcpu->pid);
> > +               oldpid =3D vcpu->pid;
>=20
> Overall this patch looks correct, but this spot took me a moment, and
> I want to confirm. This skips the reader lock since writing only
> happens just below, under the vcpu lock, and we've already taken that
> lock?

Yep, exactly.
