Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1531119F
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 20:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713558924; cv=none; b=aZA/g7dJgMq6qjkI1FbEyeEyUSjRVC6x4nI5Wn7L0rlGtSBPetW2v/w5+7CMWfeY8i+F2o4PySC0MH7nQFoV2X0v3SSPNsNW6uTAxN+MECQd4J18g/qNq3UgNko3y3eOuBCLuY1VV7X+GNgPKZhwkxJRv2vhpRTG0fl048oM7ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713558924; c=relaxed/simple;
	bh=KdvhzhTEJ+Lqb5rjSKDpCDq3IFnp7mDeGqpm5OBZCxk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DLMWUn6AXwBrQAiC9kZmwvvVNAK+N01rsO5NryvAToGYy4Cb+DqTAbAvJPBw7wT/Br3W5hcr7SrnXgSXBi7GRURH230wmBd94YCh16zIEFYKM8dY7qEfmDluPptMeLfypmLFGjymd0hti61Wzl8fcd2Qb86bw3ubybyaiAzFJUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a+mRF8b+; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a+mRF8b+"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-436ed871225so20971cf.1
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 13:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713558922; x=1714163722; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Y0px2zCMzPrnpLTJJ0/3e4JM7/QQstbfzC053pVTkI=;
        b=a+mRF8b+WmmwePPsS2MtXQVaB3hkrkgT5NWwwd3kPMZtxuonWktx3OnvMOLSYM2dUa
         h2L+HTPUigkO80AzWDjplSDhomNAnJuGWHXCGxxvGAWNSyhwHOsupIZXGAH5+wLpOeoe
         tPIccaYXXYR/AEvEvyxrr7/6oB95nPu/p6LbeOW8t/O1tobbsF/A7RQBSY6z/CYofSJn
         Rx7W76xWCT5jzLmzgM8K+mLOP61gccTuQnaf2qHjTu7QVSYdDzZMlsdFhWf5RgApe0na
         D9cv2nkWmTIXiuR9+3fzZM6AdSNEWjS4PqKwqaCiyzJpRRf8AmV7BgfdqFbXLZ2QGhKs
         qGjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713558922; x=1714163722;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4Y0px2zCMzPrnpLTJJ0/3e4JM7/QQstbfzC053pVTkI=;
        b=SDaiqYdZXCcbSHZFH784igQHjdoLPsVfkxDZuAzHCPLi9BozimrY+aSStYUAur8CIo
         MNUpBBUkimCEFvB6hR8mcOECuykHhoaY0ePxmDmLY1MygCrhyQP+7BndPVq6m9Fvj0cF
         UmiqkjRXnxOzFqoygwtVH082phyjvn6EOO883yk73SxGa8sI7wosnyMzDbQeTa+lgeTf
         F3lJSSZjpGMXcYF9bi5ODcxbJVFYLoHsqBDvf8xuCvWg+CeBPDoCqnHmxE5SEHDjI0sl
         /ni+lxKKMZhHMuIFKX1FlZsKrfXSXPtNqsXIPBPEpaAqba8FCehPA3LzcHjH6uqZUdXw
         luLg==
X-Forwarded-Encrypted: i=1; AJvYcCWnrbD8P+s2DJxOZJrO1Kj6k//RgUhaj3AjrE/DfjuJPGfqCD2R32qfQm38ZOAanKRbNStII+2cHmgCtpQH9wT9mEqSDGVQ
X-Gm-Message-State: AOJu0YwYKXvMu9TFIUqnWNdbejVVwVwEzyLOBKzbXW0yzzJ+fovPLC9k
	70Z3rcbVtDAEkNIfJWS8aFpqY5cpgw8mr/S+kSP7wOJSvURdK5CcGLa1CXdKB0Vjs3kNDDgHvgG
	X/qGH5LpHgvHSDrqWs+gtl7s5/oRX6fmwxnxe
X-Google-Smtp-Source: AGHT+IHkJfmmAPvCAeL3PHiy9LxcBKxU4sSXwU9Wa6fLPfcfMdaU+/fg9082O+N/4bGE4vTBhG7w/N+0y3iUY9ReW7w=
X-Received: by 2002:ac8:74cf:0:b0:437:b867:5782 with SMTP id
 j15-20020ac874cf000000b00437b8675782mr6844qtr.19.1713558921674; Fri, 19 Apr
 2024 13:35:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240401232946.1837665-1-jthoughton@google.com>
 <20240401232946.1837665-2-jthoughton@google.com> <ZhmBTUIhypg-Kxbx@google.com>
In-Reply-To: <ZhmBTUIhypg-Kxbx@google.com>
From: James Houghton <jthoughton@google.com>
Date: Fri, 19 Apr 2024 13:34:44 -0700
Message-ID: <CADrL8HXLH=LL5QQq1i48U1CEbyUK2zqqHu4iRqVFBjDtwaqmDw@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] mm: Add a bitmap into mmu_notifier_{clear,test}_young
To: David Matlack <dmatlack@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Yu Zhao <yuzhao@google.com>, Marc Zyngier <maz@kernel.org>, 
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

On Fri, Apr 12, 2024 at 11:45=E2=80=AFAM David Matlack <dmatlack@google.com=
> wrote:
>
> On 2024-04-01 11:29 PM, James Houghton wrote:
> > The bitmap is provided for secondary MMUs to use if they support it. Fo=
r
> > test_young(), after it returns, the bitmap represents the pages that
> > were young in the interval [start, end). For clear_young, it represents
> > the pages that we wish the secondary MMU to clear the accessed/young bi=
t
> > for.
> >
> > If a bitmap is not provided, the mmu_notifier_{test,clear}_young() API
> > should be unchanged except that if young PTEs are found and the
> > architecture supports passing in a bitmap, instead of returning 1,
> > MMU_NOTIFIER_YOUNG_FAST is returned.
> >
> > This allows MGLRU's look-around logic to work faster, resulting in a 4%
> > improvement in real workloads[1]. Also introduce MMU_NOTIFIER_YOUNG_FAS=
T
> > to indicate to main mm that doing look-around is likely to be
> > beneficial.
> >
> > If the secondary MMU doesn't support the bitmap, it must return
> > an int that contains MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE.
> >
> > [1]: https://lore.kernel.org/all/20230609005935.42390-1-yuzhao@google.c=
om/
> >
> > Suggested-by: Yu Zhao <yuzhao@google.com>
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> >  include/linux/mmu_notifier.h | 93 +++++++++++++++++++++++++++++++++---
> >  include/trace/events/kvm.h   | 13 +++--
> >  mm/mmu_notifier.c            | 20 +++++---
> >  virt/kvm/kvm_main.c          | 19 ++++++--
> >  4 files changed, 123 insertions(+), 22 deletions(-)
> >
> > diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.=
h
> > index f349e08a9dfe..daaa9db625d3 100644
> > --- a/include/linux/mmu_notifier.h
> > +++ b/include/linux/mmu_notifier.h
> > @@ -61,6 +61,10 @@ enum mmu_notifier_event {
> >
> >  #define MMU_NOTIFIER_RANGE_BLOCKABLE (1 << 0)
> >
> > +#define MMU_NOTIFIER_YOUNG                   (1 << 0)
> > +#define MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE (1 << 1)
>
> MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE appears to be unused by all callers
> of test/clear_young(). I would vote to remove it.

Works for me.

>
> > +#define MMU_NOTIFIER_YOUNG_FAST                      (1 << 2)
>
> Instead of MMU_NOTIFIER_YOUNG_FAST, how about
> MMU_NOTIFIER_YOUNG_LOOK_AROUND? i.e. The secondary MMU is returning
> saying it recommends doing a look-around and passing in a bitmap?
>
> That would avoid the whole "what does FAST really mean" confusion.

I think MMU_NOTIFIER_YOUNG_LOOK_AROUND is fine.

>
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index fb49c2a60200..ca4b1ef9dfc2 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -917,10 +917,15 @@ static int kvm_mmu_notifier_clear_flush_young(str=
uct mmu_notifier *mn,
> >  static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
> >                                       struct mm_struct *mm,
> >                                       unsigned long start,
> > -                                     unsigned long end)
> > +                                     unsigned long end,
> > +                                     unsigned long *bitmap)
> >  {
> >       trace_kvm_age_hva(start, end);
> >
> > +     /* We don't support bitmaps. Don't test or clear anything. */
> > +     if (bitmap)
> > +             return MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE;
>
> Wouldn't it be a bug to get a bitmap here? The main MM is only suppost
> to pass in a bitmap if the secondary MMU returns
> MMU_NOTIFIER_YOUNG_FAST, which KVM does not do at this point.
>
> Put another way, this check seems unneccessary.
>
> > +
> >       /*
> >        * Even though we do not flush TLB, this will still adversely
> >        * affect performance on pre-Haswell Intel EPT, where there is
> > @@ -939,11 +944,17 @@ static int kvm_mmu_notifier_clear_young(struct mm=
u_notifier *mn,
> >
> >  static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
> >                                      struct mm_struct *mm,
> > -                                    unsigned long address)
> > +                                    unsigned long start,
> > +                                    unsigned long end,
> > +                                    unsigned long *bitmap)
> >  {
> > -     trace_kvm_test_age_hva(address);
> > +     trace_kvm_test_age_hva(start, end);
> > +
> > +     /* We don't support bitmaps. Don't test or clear anything. */
> > +     if (bitmap)
> > +             return MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE;
>
> Same thing here.

I will remove them, they are indeed unnecessary, as it is just dead code.
