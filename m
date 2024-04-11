Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D407E6FD0
	for <kvmarm@lists.linux.dev>; Thu, 11 Apr 2024 00:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712795751; cv=none; b=LcHo6SjFLEilazQjEO/6Y5tj69Jaa/LTIZtv3CFGobzh+Rkxgi6hFAWOSj+mvGUQukYuK2zx0u2TB+8pl2s1l8gep+ejcn1NkJBk2whfqwdW/C4SSYORhRWlyRLFoKoGfxLl086fshsDRl0DYuQGSU4pMMsiEsdPXoEk7QQTeu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712795751; c=relaxed/simple;
	bh=vDzBN7h5H7qRuMhHLOSWOdTcB6GR+YXycDXe8bfzdG4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZN2yv5LyaTlzLHsjT1q0zRljyd5lsAzZd9aYI1iPGKQ64vcR4lPso981IupaJkNA9o7a4L8uCGrj63MV/fBnpVF8eKapl+xEtAr2IZ7FpaqTzsBUQtjzaXtpw0ngY+io8fLtEacFwH8s7wf8myriJMVxE4edbiviNJIaXZw7iHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hiBDufNL; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hiBDufNL"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4348110e888so93351cf.1
        for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 17:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712795749; x=1713400549; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hll648Cvihh5+gbtq6L/4af+GOyNrj81dtl5gh6CLtU=;
        b=hiBDufNLXxvzcdcnKB1jT7i7i5De55TyHr9gh7WV44fsVistlXaX5YTD2tGBiRHaTQ
         x1aM8OOopVXrmcUcmkLOMWXwL6tmFC3oiA3iO/gB7aAfnJBZ9+8DjreOweTWilpkdCFz
         lAieaal3myOnY9NAGXIWS6vG9GtRIpl2FttoouaJDEoz2rm3pZSfwcJ35Ip90M+oA9rm
         V6ypEi4GYsW7d0AWe1thSjm1iR78V8LnQkrLOsaTl/ER/Tg5g0cXBcgPx3atdFsUWwgw
         C89H5AkbMCbfvLQuaC8iEPwmwKiKiMrgwR/E5RR16StPvH/Fkk8faSjvQJA60qsVyynZ
         1j4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712795749; x=1713400549;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hll648Cvihh5+gbtq6L/4af+GOyNrj81dtl5gh6CLtU=;
        b=GJVrYvqELWeRsbA9je8xTPv6NlGCfRZ6rJFXe/liYojwPMcUU/5s+h8nMlTRAs/Gmc
         ZKf6SDB1g8iLw3y3RLI1syEUsYUSXqcBDxFqK6hFtC4QD/YrlU2zsX+eF8HJbe5R7ub9
         AZAiSrC+qcy+tTW6KR2HY93gBb8DLLyIkUKz6trEMuDsB6DnwUriZTgsZb8W+jQ4JRiw
         QSKvrZ1JfAIbGzzHLaiOVJ1ZtB2SfKjKR9/a+9ohYVknMqbgl4ANB34tulFhKBzKTL0d
         KBOJzohqniBCycQzIZhRq4n3Jo8bgwonjXo+f1Z90KW8qcPLLOrJ8pYLl4bwtr4WDjT4
         IsHg==
X-Forwarded-Encrypted: i=1; AJvYcCX/xLHF1/p1BcHYpFIBUaUTUf6yXdbZGr8WLSJJD1PZIBpEvRNOmhic6rLaUEC7pnwdUihy4C0AjEexau1swcchRl4trICd
X-Gm-Message-State: AOJu0Yx5rNteXcS7IOWQRgMbaNHLaAkQhylcHqsN4AJTmllM/LbffzL/
	iLzo5Qp7t1UyS621E0mdjpG7B+BYStMtqN/VtnLCDNV1vGC5xEkV/Xxnnlws6m/T64n1n3+zrRM
	wyFU6q+4nOl+Xi63Cp6tDYM+WBA/McEPzsrwx
X-Google-Smtp-Source: AGHT+IFGLj1tAhjk5RpppfKTaL73oV3xSrwK17M0Lat/eXuLIVwkuvO1YH97f0uDQLYoqbM8Or5GftZ8IdKEWzGYOsE=
X-Received: by 2002:a05:622a:4d4a:b0:434:dcc1:cddb with SMTP id
 fe10-20020a05622a4d4a00b00434dcc1cddbmr88725qtb.26.1712795748610; Wed, 10 Apr
 2024 17:35:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240401232946.1837665-1-jthoughton@google.com>
 <20240401232946.1837665-2-jthoughton@google.com> <cce476f7-2f52-428a-8ae4-fc5dec714666@redhat.com>
 <CADrL8HVPEjdAs3PoTa3sPCvQpimZJG6pP9wbiLjnF5cROxfapA@mail.gmail.com> <226a222d-4273-4304-ab73-39b2f8f060b5@redhat.com>
In-Reply-To: <226a222d-4273-4304-ab73-39b2f8f060b5@redhat.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 10 Apr 2024 17:35:11 -0700
Message-ID: <CADrL8HWbF=7mEn=1s=uwUuZ_-vnCxHwK3hOdctiuCGLtephskg@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] mm: Add a bitmap into mmu_notifier_{clear,test}_young
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Yu Zhao <yuzhao@google.com>, David Matlack <dmatlack@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Gavin Shan <gshan@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Rientjes <rientjes@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 9, 2024 at 12:35=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 09.04.24 20:31, James Houghton wrote:
> > Ah, I didn't see this in my inbox, sorry David!
>
> No worries :)
>
> >
> > On Thu, Apr 4, 2024 at 11:52=E2=80=AFAM David Hildenbrand <david@redhat=
.com> wrote:
> >>
> >> On 02.04.24 01:29, James Houghton wrote:
> >>> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifie=
r.h
> >>> index f349e08a9dfe..daaa9db625d3 100644
> >>> --- a/include/linux/mmu_notifier.h
> >>> +++ b/include/linux/mmu_notifier.h
> >>> @@ -61,6 +61,10 @@ enum mmu_notifier_event {
> >>>
> >>>    #define MMU_NOTIFIER_RANGE_BLOCKABLE (1 << 0)
> >>>
> >>> +#define MMU_NOTIFIER_YOUNG                   (1 << 0)
> >>> +#define MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE (1 << 1)
> >>
> >> Especially this one really deserves some documentation :)
> >
> > Yes, will do. Something like
> >
> >      MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE indicates that the passed-in
> > bitmap either (1) does not accurately represent the age of the pages
> > (in the case of test_young), or (2) was not able to be used to
> > completely clear the age/access bit (in the case of clear_young).
>
> Make sense. I do wonder what the expected reaction from the caller is :)

In this series the caller doesn't actually care (matching what Yu had
in his v2[1]). test_spte_young() probably ought to return false if it
finds MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE (and I'll do this in v4 if
no one objects), but it doesn't have to. The bitmap will never say
that a page is young when it was actually not, only the other way
around.

>
> >
> >>
> >>> +#define MMU_NOTIFIER_YOUNG_FAST                      (1 << 2)
> >>
> >> And that one as well.
> >
> > Something like
> >
> >     Indicates that (1) passing a bitmap ({test,clear}_young_bitmap)
> > would have been supported for this address range.
> >
> > The name MMU_NOTIFIER_YOUNG_FAST really comes from the fact that KVM
> > is able to harvest the access bit "fast" (so for x86, locklessly, and
> > for arm64, with the KVM MMU read lock), "fast" enough that using a
> > bitmap to do look-around is probably a good idea.
>
> Is that really the right way to communicate that ("would have been
> supported") -- wouldn't we want to sense support differently?

What I have now seems fine to me. It would be a little nicer to have a
way to query for bitmap support and make sure that the answer will not
be stale by the time we call the bitmap notifiers, but the complexity
to make that work seems unnecessary for dealing with such an uncommon
scenario.

Maybe the right thing to do is just to have KVM always return the same
answer. So instead of checking if the shadow root is allocated, we
could check something else (I'm not sure what exactly yet though...).

[1]: https://lore.kernel.org/kvmarm/20230526234435.662652-11-yuzhao@google.=
com/
