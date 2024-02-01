Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CD185622
	for <kvmarm@lists.linux.dev>; Thu,  1 Feb 2024 19:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817244; cv=none; b=HTm0+UeQbzgrPpZ4Um6/eTyt483HI4+M8RXo/ubZ8NpBCxs6FVH5BgD2zuZ5G1Tmhig17SHi0U/OSyD9BCxiWXstjRjl/cptflYmxXiwTs4b4Qd7PLwO7iZZBZ95LgHX1PSi3uOvJs4kA5to36J2ZP5NaxqHr1qsN5scWebtrDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817244; c=relaxed/simple;
	bh=ZQsn9Trvvh+RY6jMorE8AU+v9azhRM7SEsdC5Uycm3U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b9zi29pjRHLKc816BcY5VwHanNmJAhu/rk7lAFDOtLxB+GKD33Qw60RXmDHHIAIOslk95AgA9mQE8fITs/HUoPLxu55UQHc/BA54D6+WYJBJmxG1tNNCEzRGQs8v8V/Qx21yOyvB3xHISgECwRZ/dViaQ2d9XdiOtpuq2jZLMOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NW+J+t5F; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NW+J+t5F"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-2143a96d185so694169fac.3
        for <kvmarm@lists.linux.dev>; Thu, 01 Feb 2024 11:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706817242; x=1707422042; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f/LoHtdt3viOsVB5O0XlvICEJk4SiOVHEdN+gLYbxK0=;
        b=NW+J+t5FKzYJOaOSzX9QPT39Jw9OVrqR4bx68NZnYpiC7j4aNPpVWXOxFcXZUjoXtH
         3FzR2RzJtJukOrQvxbj7XeD/cmT0LswvL3umwili+k9n8WaEOKotfC1YXJ2T+YYtz6pW
         wPLV1d37Ipxh260k6pydQVi1dfED+1jAnO2lZUPo3ksFKTCLI7/YZpPsokeA1MPH7fvj
         pw3u5rZlcFb2+0AUXX8U1CyqGPFkpIXmbdP/skdiBYmy3EXsnwKmAwgsb6M6u9zQaGWo
         f7iSll/HS6jsRDSbbweIgSUfwUyTJbRDxG1VuX+Vzy3+CnrV7V+HPRS6XoXSJmmHKvwr
         683A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706817242; x=1707422042;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f/LoHtdt3viOsVB5O0XlvICEJk4SiOVHEdN+gLYbxK0=;
        b=QFTKL2HVEstIbKgT+DOlz4Y7QHYLvb/8foAyWNvBqby1iXf14hX11Q6FHTC9kbSGwl
         WnbVh2l2TvQE+eEV3SgFICrCwvm7XXUePyOPgeA/MC8s5Z0kyYa2jhGapVqWWb85HXAI
         Bsa3dvSZooA4JsGJmFF5RPy0DwbNMSPXFDP/4O8szklBR1Qh38Iy9CnURkd5MO8B3rz9
         XYr6/teR4psCH4KcYvq/br7CWmPLscrppUTZ8/ACWFKzGPGWrJcKjTSrVKGd9t6eNCvx
         25RIamY2DNUGSuUmjsIIjvJgXV9oPqo7ZNpNhBSkwo3UGuIR2UerPpLzlqjeQRGaWam6
         ugCg==
X-Gm-Message-State: AOJu0Yw2m25NhS3lb0OiIsXWkRbAPAaPeAq6ASu4VLSdf3Hq2GsHBbAo
	eVNukki9xdulIigf1Ws6GfGxURI1UkWBrIJm/RC3JlQ1KBHMWMPH+RsnGafQNPcubxnrg6WESIU
	/smPOrp6mGfWGtPPq3RV9UkOWnmrjsT1dTr15
X-Google-Smtp-Source: AGHT+IEjLEnPw55qSHpu7Ywg6jXC8lZw+1LTzNpNEH76MmLRU7HKs4S3CoVbX+W4IQEQhkg2wMd+9rYo3E9WLfVvJcA=
X-Received: by 2002:a05:6871:5c43:b0:219:faf:b1b4 with SMTP id
 os3-20020a0568715c4300b002190fafb1b4mr19743oac.41.1706817242298; Thu, 01 Feb
 2024 11:54:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-7-amoorthy@google.com>
 <CADrL8HWYKSiDZ_ahGbMXjup=r75B4JqC3LvT8A-qPVenV+MOiw@mail.gmail.com>
 <CAF7b7mrA3rB33sUZe3HX33+fXpF=8VwD284LpCcEn9KT9OgwUQ@mail.gmail.com> <ZbvCU5wPAnePJZtI@google.com>
In-Reply-To: <ZbvCU5wPAnePJZtI@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 1 Feb 2024 11:53:25 -0800
Message-ID: <CAF7b7morHn_-WQBPFexpS_Eb-bXSyu_7CCf-EpBWbAvxReWZXg@mail.gmail.com>
Subject: Re: [PATCH v6 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
To: Sean Christopherson <seanjc@google.com>
Cc: James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 1, 2024 at 8:09=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Wed, Jan 31, 2024, Anish Moorthy wrote:
> > On Tue, Jan 30, 2024 at 4:26=E2=80=AFPM James Houghton <jthoughton@goog=
le.com> wrote:
> > >
> > > Feel free to add:
> > >
> > > Reviewed-by: James Houghton <jthoughton@google.com>
> >
> > > If we include KVM_MEM_GUEST_MEMFD here, we should point the reader to
> > > KVM_SET_USER_MEMORY_REGION2 and explain that using
> > > KVM_SET_USER_MEMORY_REGION with this flag will always fail.
> >
> > Done and done (I've split the guest memfd doc update off into its own
> > commit too).
> >
> > > > @@ -3070,6 +3074,15 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct =
kvm_memory_slot *slot, gfn_t gfn,
> > > >                 writable =3D NULL;
> > > >         }
> > > >
> > > > +       if (!atomic && can_exit_on_missing
> > > > +           && kvm_is_slot_exit_on_missing(slot)) {
>
> Operators go on the preceding line:

Thanks. On a side note, is this actually documented anywhere? I
searched coding-style.rst but couldn't find it.

> > > Perhaps we should have a comment for this? Maybe something like: "If
> > > we want to exit-on-missing, we want to bail out if fast GUP fails, an=
d
> > > we do not want to go into slow GUP. Setting atomic=3Dtrue does exactl=
y
> > > this."
> >
> > I was going to push back on the use of "we" but I see that it's all
> > over kvm_main.c :).
>
> Ignore the ancient art, push back.  The KVM code base is 15 years old at =
this
> point.  A _lot_ of has changed in 15 years.  The fact that KVM has existi=
ng code
> that's in violation of current standards doesn't justify ignoring the sta=
ndards
> when adding new code.

Well, actually the idea to push back here was more mechanical- I'm a
fan of "we" in comments myself. Somehow I got the idea that it's
discouraged, but that might just be leakage from comments on my past
commit messages.

Again I don't see anything in coding-style.rst, but I wonder if I'm
missing something.
