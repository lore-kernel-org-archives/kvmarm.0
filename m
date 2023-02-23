Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC8623A5
	for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 09:19:01 +0000 (UTC)
Received: by mail-vs1-f45.google.com with SMTP id v27so6143905vsa.7
        for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 01:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677143940;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jJG07+p6MKBGS+KUMirk1JxFZsTo6RYQStGyBrR/Eec=;
        b=VTUwGjwxIdIk+8DQo1F08zqK342XkE0IyISiKy445xlO4gn5BcvtIN8ObhUibjnPdh
         +8QCDzAGRnNMibyH/sRteQ9ut7OJkOEsJ8kPkEGYc9OBnih7SfNQpowLXMcwoFUvs1K0
         6ELBLUgwh0HmEnFhlM7FrYYPj3mzKwUNEEOe1h31zEj9FFkZtgtvcDAl/ADLU4zCLTaC
         CZOb1xxY9uT50WPXBxvhwk3EuLggirXkkdcMLU8rlZo6fi998cB25h17CFWSnwQ6kgUi
         scHNy8oFEGRxc67FjqT0UL/HkF89zud1sd74gtEScsUHorUBPQzjefZ88i8TDYmSUg2T
         qgLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677143940;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jJG07+p6MKBGS+KUMirk1JxFZsTo6RYQStGyBrR/Eec=;
        b=e7putYZYXEWB490LOn+0ikUJrk/TnLbCT/k5rALisUJPKRPPQu6R7n6iHhrbwN9Vqk
         2kgfduI2AaC69PN5Mdw2/QpA7QtqzgAIwvB/N+OwRktw06HQcJdfk4vjjyVv5WzAcUqp
         UHBHzMFaX4yexrWJBJzSUIvmBzyqS3qfdsGEUqhVi4RnxmfSMbzg8OY9ILJJv7e0BItx
         FM1gQF+o/dhMoaoVqwOspjMZbMfZHYMqlTBX5nrtCrlVVrN7EjTxLmZcRQYeZrlo+q2l
         cmEkpPSZ91cfQjEF5yWmhrLKs4AVAKuEQsBeAc5T+FVxWr0skeZ4a3lPR8Hap/2OMpMr
         9O7A==
X-Gm-Message-State: AO0yUKV3PdexlRTwhQXnZ4fsr+Ag29HjlquxeROEz8S0oUSZSQKKQeOc
	5RJ9AnrUV84A3zKzP5p54tdUM5xcSdVYg2sfgTOePQ==
X-Google-Smtp-Source: AK7set+fL9K7BQue1MVWJ997o1Uw4HQUESRxfTJt3q61lF9gsBJ2K4+iBi+Hrae4wfMfj+Ek0HWi8Lg5PF2Mvbw7Sx4=
X-Received: by 2002:a1f:aa41:0:b0:412:948:73ff with SMTP id
 t62-20020a1faa41000000b00412094873ffmr251161vke.13.1677143940266; Thu, 23 Feb
 2023 01:19:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-4-yuzhao@google.com>
 <CAOUHufYSx-edDVCZSauOzwOJG6Av0++0TFT4ko8qWq7vLi_mjw@mail.gmail.com>
 <86lekwy8d7.wl-maz@kernel.org> <CAOUHufbbs2gG+DPvSOw_N_Kx7FWdZvpdJUvLzko-BDQ8vfd6Xg@mail.gmail.com>
 <86a614ycs3.wl-maz@kernel.org>
In-Reply-To: <86a614ycs3.wl-maz@kernel.org>
From: Yu Zhao <yuzhao@google.com>
Date: Thu, 23 Feb 2023 02:18:24 -0700
Message-ID: <CAOUHufYLmu7oowXZ5YmVJqgx5dHWdz-1eaqPiVzUq3RAY4e_6A@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 3/5] kvm/arm64: add kvm_arch_test_clear_young()
To: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Michael Larabel <michael@michaellarabel.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org, 
	linux-mm@google.com, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 23, 2023 at 2:03=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Thu, 23 Feb 2023 03:58:47 +0000,
> Yu Zhao <yuzhao@google.com> wrote:
> >
> > On Fri, Feb 17, 2023 at 2:00=E2=80=AFAM Marc Zyngier <maz@kernel.org> w=
rote:
> > >
> > > On Fri, 17 Feb 2023 04:21:28 +0000,
> > > Yu Zhao <yuzhao@google.com> wrote:
> > > >
> > > > On Thu, Feb 16, 2023 at 9:12 PM Yu Zhao <yuzhao@google.com> wrote:
> > > > >
> > > > > This patch adds kvm_arch_test_clear_young() for the vast majority=
 of
> > > > > VMs that are not pKVM and run on hardware that sets the accessed =
bit
> > > > > in KVM page tables.
> > >
> > > I'm really interested in how you can back this statement. 90% of the
> > > HW I have access to is not FEAT_HWAFDB capable, either because it
> > > predates the feature or because the feature is too buggy to be useful=
.
> >
> > This is my expericen too -- most devices are pre v8.2.
>
> And yet you have no issue writing the above. Puzzling.

That's best to my knowledge. Mind enlightening me?

> > > Do you have numbers?
> >
> > Let's do a quick market survey by segment. The following only applies
> > to ARM CPUs:
> >
> > 1. Phones: none of the major Android phone vendors sell phones running
> > VMs; no other major Linux phone vendors.
>
> Maybe you should have a reality check and look at what your own
> employer is shipping.

Which model? I'll look it up and see how/how I missed it.

> > 2. Laptops: only a very limited number of Chromebooks run VMs, namely
> > ACRVM. No other major Linux laptop vendors.
>
> Again, your employer disagree.

What do you mean? Sorry, I'm a little surprised here... I do know *a
lot* about Chromebooks.

> > 3. Desktops: no major Linux desktop vendors.
>
> My desktop disagree (I send this from my arm64 desktop VM ).

A model number please?

> > 4. Embedded/IoT/Router: no major Linux vendors run VMs (Android Auto
> > can be a VM guest on QNX host).
>
> This email is brought to you via a router VM on an arm64 box.

More details?

> > 5. Cloud: this is where the vast majority VMs come from. Among the
> > vendors available to the general public, Ampere is the biggest player.
> > Here [1] is a list of its customers. The A-bit works well even on its
> > EVT products (Neoverse cores).
>
> Just the phone stuff dwarfs the number of cloud hosts.

Please point me to something that I can work on so that I wouldn't
sound so ignorant next time.
