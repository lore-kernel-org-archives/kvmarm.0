Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0131FDA
	for <kvmarm@lists.linux.dev>; Thu,  1 Feb 2024 00:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706747207; cv=none; b=JQKDrJpA8N3ie0LVQmTYpcD9GOlrRqMLxhjn4SnL0dHWmCc2LuT8J79d4ASH+x1bJbRMB7D4vZYoJkC1xMQ/0EdTcfhbLnEc5L6oDr93uAxFsqcLCp43/Z9s+bSgxNvHGECRwWnDkEnAp35sMOhL9fly1RZthzXQZRuaLpZBKOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706747207; c=relaxed/simple;
	bh=6tJHrUkrQP7NwvtLhO/da5PPrg5uJy9hVBGQTtTpIig=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NgWJyOEIOzncTlkE8jY8vs4cZlX9UTWlFSEaybNRZ0G5hh44CvxITfqu20/vYOUoPq55Tw9B+dKcpf+TXymfx6SRm/kVF10Hh8VnuQVk8qLUCsDFQPEszwUpHNFJQQnPOyjCZ8I47dEI4f9Do8gIUjfG0/9hijYs8qGy5XzpXBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E8uyYVI5; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E8uyYVI5"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-42a88ad0813so106651cf.0
        for <kvmarm@lists.linux.dev>; Wed, 31 Jan 2024 16:26:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706747205; x=1707352005; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MfVbRf3BHUSn3cK7ZTAjeFEicT/rpADsX5UluXSAJko=;
        b=E8uyYVI5TirrN1tKVS5YppmWAMx2WcX0hu2tF9+wLDTgMBYYT128o4yKpb4kT6kMHl
         uDN6BysFczQHklWanQ6lRGh3t5QqbawGpJy9cPXK9LuHM3f2tgwIb551V4L+QD99OAku
         jL+noalngosr0vSgHy40UIa4JBqe1scrv74UWJWs+mwpLab67rvHbvF2nIg7hUxEiRFE
         cu2BOsQq+DX6XG8u3iGKAsjUhmHkkeActsa37dqV6qaeLhzz9YA32A2Jj9wlZ03/MrUJ
         d/TKJug7I00MgS1oqxsfplfoZA/F/r0qhABoF1Md0Fvm4fFXmQMoXzywosd+G4kr6mYW
         YtgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706747205; x=1707352005;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MfVbRf3BHUSn3cK7ZTAjeFEicT/rpADsX5UluXSAJko=;
        b=fJlZJ1TzRyHkmT2ZGd6To/t7mc9X8vzDkSPrCIxdcsfSf/s/nBF0g3WHLEN2hCXGw+
         NIVOPuiCaNT3vdcfL2SDGliLakMH9D825PtL35N9xD3m2niHcjNIk4q0vWQBV6MC8BKb
         BWJf/mnbzBWXJepxzbh3xMrlvkLPRElfcwTQHN0/WYNBlSw/eqSLwoBFFMxUyAeUnMjf
         aplG60NkCXlgAaIpXMkJrR7YG6QPTUDccCzS950cqsXwBAF5jyEwt/YVXW5KWDjsyjck
         qUcSU9ZC/+7JOjnwtKdzPF+COTPDB3QMxvQoEM9Wg7V4aHAbzOXVm6iSrfRvd+oFyYmk
         xYkA==
X-Gm-Message-State: AOJu0YxuB0EO4B/WFoslqY0z8Ch+Vri4BR85DYJpD0zTWHKsuf30Aajv
	ywfz0MCuzRoB8KvR2YQZ3g3riKcyDu9uUW3F30a0TXKpXaUzVUVsYw15KAhWzOR5xmGj3b3trow
	T4bIu8aT72LGJRrTXRToef2zM6HMQrY+yMm4D
X-Google-Smtp-Source: AGHT+IFkozDy72/y2wNyA2yA/lTNSD0/eZVvz82Xg5xHONs8hs/Df4umXylnquFRHZr6PnmZkZkDhPz2CdJa2WRWaj8=
X-Received: by 2002:a05:622a:3ce:b0:42a:9c21:2655 with SMTP id
 k14-20020a05622a03ce00b0042a9c212655mr86925qtx.13.1706747204771; Wed, 31 Jan
 2024 16:26:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-7-amoorthy@google.com>
 <CADrL8HWYKSiDZ_ahGbMXjup=r75B4JqC3LvT8A-qPVenV+MOiw@mail.gmail.com> <CAF7b7mrA3rB33sUZe3HX33+fXpF=8VwD284LpCcEn9KT9OgwUQ@mail.gmail.com>
In-Reply-To: <CAF7b7mrA3rB33sUZe3HX33+fXpF=8VwD284LpCcEn9KT9OgwUQ@mail.gmail.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 31 Jan 2024 16:26:08 -0800
Message-ID: <CADrL8HXSzm_C9UwUb8-H_c6-TRgpkKLE+qeXfyN-X_rHGj2vuw@mail.gmail.com>
Subject: Re: [PATCH v6 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
To: Anish Moorthy <amoorthy@google.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 31, 2024 at 2:00=E2=80=AFPM Anish Moorthy <amoorthy@google.com>=
 wrote:
>
> On Tue, Jan 30, 2024 at 4:26=E2=80=AFPM James Houghton <jthoughton@google=
.com> wrote:
> > > @@ -3070,6 +3074,15 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kv=
m_memory_slot *slot, gfn_t gfn,
> > >                 writable =3D NULL;
> > >         }
> > >
> > > +       if (!atomic && can_exit_on_missing
> > > +           && kvm_is_slot_exit_on_missing(slot)) {
> > > +               atomic =3D true;
> > > +               if (async) {
> > > +                       *async =3D false;
> > > +                       async =3D NULL;
> > > +               }
> > > +       }
> > > +
> >
> > Perhaps we should have a comment for this? Maybe something like: "If
> > we want to exit-on-missing, we want to bail out if fast GUP fails, and
> > we do not want to go into slow GUP. Setting atomic=3Dtrue does exactly
> > this."
>
> I was going to push back on the use of "we" but I see that it's all
> over kvm_main.c :).
>
> I agree that a comment would be good, but isn't the "fast GUP only iff
> atomic=3Dtrue" statement a tautology? That's an actual question, my
> memory's fuzzy.
>
> What about
>
> > When the slot is exit-on-missing (and when we should respect that)
> > set atomic=3Dtrue to prevent GUP from faulting in the userspace
> > mappings.
>
> instead?

This is much better than what I wrote, thanks! We merely want GUP not
to fault the page in; we don't actually care about fast GUP vs. slow
GUP.

On that note, I think we need to drop the patch that causes
read-faults in RO memslots to go through fast GUP. KVM didn't do that
for a good reason[1].

That would break KVM_EXIT_ON_MISSING for RO memslots, so I think that
the right way to implement KVM_EXIT_ON_MISSING is to have
hva_to_pfn_slow pass FOLL_NOFAULT, at least for the RO memslot case.
We still get the win we're looking for: don't grab the userfaultfd
locks.

[1]: Commit 17839856fd5 ("gup: document and work around "COW can break
either way" issue")
