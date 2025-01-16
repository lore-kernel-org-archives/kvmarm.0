Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D294222CF02
	for <kvmarm@lists.linux.dev>; Thu, 16 Jan 2025 22:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737067910; cv=none; b=n7ZVcvhjL6foh8kn2ZLlofaxEgcCprnvJWBC1LepMRpsQEn6yl+OAq1BeslRFrcjSd9doG6R28aNe8s8+yyG22r2BLksxzdWbtUgCeGzESqZ/7OhSY9THHmxPAOzr2zmaVq8Vf1p4olMbSy1aHMgee95lMw0VLfplQe4UrdLmco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737067910; c=relaxed/simple;
	bh=8vzofeRWcsorue9hM39qV72+nCmIg6eJE6V/BKMgF4A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ivmIHe90L+R4y+SCuz+3Yzy2Rdbfl/48mnDO9U40Yf3pzNfablj8/gY0MwN0uVoY+VqoyGO/5RuzlfbC/8yckucIEzehkx1XzUDb9SS57m4pSrRoyRFvLvcqQdAIIoQxP8L40Un37ZOHZXkIfcVFZznKKCF1FNTR1lZehZIlJoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qf1MWNIZ; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qf1MWNIZ"
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e39779a268bso2518145276.1
        for <kvmarm@lists.linux.dev>; Thu, 16 Jan 2025 14:51:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737067908; x=1737672708; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mo8wWiVSieP36PQBtcad/p/Y6sOL31Xn/K7FaizLB00=;
        b=Qf1MWNIZLpmjp7H5NgEQ4KqXQarLsSUR7nxyWGbAG8XsKW+eWKb3igwbDbltUJI+So
         WrF8FVvqw6mdkzUsD4XDhBNIidE/CHJux1MGJbGrMNu5G+fFrIK6o/nqf1ZRXArtq9zT
         XVCI4QHMsx4Y1VW4GA7xx6TW3efu18d5cNG7ZfLk1ECabSvePMul4lA7U9pA0Jlv5jpf
         lRoBNBnRqymI4vWm9k06RJE5uLjmy6rit2Yff+Mx68ibdOGo+2YWEMYzJ0E8IdZhXnVm
         EewW0agLD/ZdzYlHbuIOe6/JI6EvEhFvA0yDkNfutMK6e7HcTmTLBReBMirhgJUKEPPz
         UHbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737067908; x=1737672708;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mo8wWiVSieP36PQBtcad/p/Y6sOL31Xn/K7FaizLB00=;
        b=ikUUWSLb0HQ5XNAQdE8Fr1+1zdWt/wdP6wPzUvNKsIA7usXcmC/yTjzMQQwepnlELJ
         88oiCG9bz/7pM9m32ps6Z2hxtDiJGJLY8fvHXMaupX+/gfRtpIf7rdL5uWXeIcYgKoV8
         mTn/AzDD267hkgAzRrypM2dB6RZChA+HYHl8hNJRf78c4yMe8AlR2IoXIi0iQzqmSD5Y
         BLR/7CE0cdCcfU0TlsbGDHUF2bcYaxauYqlCrGJ529xBKGo2lubHNJ6FrgajDly4OOvs
         Fy7Pf4nC0s7aIiNbGhKTSf56bi5ERW6fz4xejFjVcNP8lraj8kQu0AKMfKFV0GikjkVw
         11Uw==
X-Forwarded-Encrypted: i=1; AJvYcCV+iXBYVv5HJu11UeskTnTplbVJIDbkJBc4iV2e8Jhy+noTKFvL4dLhd/WzBsc9yeBdlkX5wkw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzlLjMqfwcvNp3crjD3ueQFevHv/9O152gYfh9jNb4RglMoT4BQ
	JMO+Amuo7Q2RIR9dGwh57rKgLxnazbaBvQrkbWu7jqc9V4hsYp9LT54e/8anI5uHO1RPVgiR/Kh
	ceWZ9Z43sq7hAIT4UiW3FmzYa8+wm2iGcl6lr
X-Gm-Gg: ASbGncvV+G4L5cei+FdX3oDH+SAwwXiqirAi918y1T4bcr1dR92memWvAo4Z+ZIeRU9
	wvbBwB7c6hFt0oA6QIPF+tYumBfwcjELOi1b4Jg0UdEXn4pbRs8zQmGZnWoy2efVbrAWn
X-Google-Smtp-Source: AGHT+IHDVU+IJsNlLjF83+Ds9RyEMFn3PvbsQABSjjSiGmmyVwS/zqJzA12leRcKXime5YwyEjpU/j8pOjxtozPQTYw=
X-Received: by 2002:a05:6902:1447:b0:e54:9a7a:bce1 with SMTP id
 3f1490d57ef6-e57b0c833demr376797276.20.1737067907684; Thu, 16 Jan 2025
 14:51:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
 <Z2simHWeYbww90OZ@x1n> <CADrL8HUkP2ti1yWwp=1LwTX2Koit5Pk6LFcOyTpN2b+B3MfKuw@mail.gmail.com>
 <Z4lp5QzdOX0oYGOk@x1n> <Z4lsxgFSdiqpNtdG@x1n>
In-Reply-To: <Z4lsxgFSdiqpNtdG@x1n>
From: James Houghton <jthoughton@google.com>
Date: Thu, 16 Jan 2025 14:51:11 -0800
X-Gm-Features: AbW1kvYOIA-rxNht25vJwL_NVGMkqbp_NoziG0prE60wf6DVUh2TfK28c0IaFFg
Message-ID: <CADrL8HWRavCoZ_NtXJvcLOvjOiGDCor6ucWeEqkecA3VDY-adg@mail.gmail.com>
Subject: Re: [PATCH v1 00/13] KVM: Introduce KVM Userfault
To: Peter Xu <peterx@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Yan Zhao <yan.y.zhao@intel.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, 
	David Matlack <dmatlack@google.com>, Wei W <wei.w.wang@intel.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 16, 2025 at 12:32=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote=
:
>
> On Thu, Jan 16, 2025 at 03:19:49PM -0500, Peter Xu wrote:
> > James,
> >
> > Sorry for a late reply.
> >
> > I still do have one or two pure questions, but nothing directly relevan=
t to
> > your series.
> >
> > On Thu, Jan 02, 2025 at 12:53:11PM -0500, James Houghton wrote:
> > > So I'm not pushing for KVM Userfault to replace userfaultfd; it's not
> > > worth the extra/duplicated complexity. And at LPC, Paolo and Sean
> > > indicated that this direction was indeed wrong. I have another way to
> > > make this work in mind. :)
> >
> > Do you still want to share it, more or less? :)

I think I'm referring to how to make 4K demand fetches for 1G-backed
guest memory work, and I kind of said what I was thinking a little
further down:

On Thu, Jan 2, 2025 at 9:53=E2=80=AFAM James Houghton <jthoughton@google.co=
m> wrote:
>
> FWIW, I think userspace mapping of gmem + userfaultfd support for
> userspace-mapped gmem + 1G page support for gmem =3D good 1G post-copy
> for QEMU (i.e., use gmem instead of hugetlbfs after gmem supports 1G
> pages).
>
> Remember the feedback I got from LSFMM a while ago? "don't use
> hugetlbfs." gmem seems like the natural replacement.

I guess this might not work if QEMU *needs* to use HugeTLB for
whatever reason, but Google's hypervisor just needs 1G pages; it
doesn't matter where they come from really.

> > > For the gmem case, userfaultfd cannot be used, so KVM Userfault isn't
> > > replacing it. And as of right now anyway, KVM Userfault *does* provid=
e
> > > a complete post-copy system for gmem.
> > >
> > > When gmem pages can be mapped into userspace, for post-copy to remain
> > > functional, userspace-mapped gmem will need userfaultfd integration.
> > > Keep in mind that even after this integration happens, userfaultfd
> > > alone will *not* be a complete post-copy solution, as vCPU faults
> > > won't be resolved via the userspace page tables.
> >
> > Do you know in context of CoCo, whether a private page can be accessed =
at
> > all outside of KVM?
> >
> > I think I'm pretty sure now a private page can never be mapped to
> > userspace.  However, can another module like vhost-kernel access it dur=
ing
> > postcopy?  My impression of that is still a yes, but then how about
> > vhost-user?
> >
> > Here, the "vhost-kernel" part represents a question on whether private
> > pages can be accessed at all outside KVM.  While "vhost-user" part
> > represents a question on whether, if the previous vhost-kernel question
> > answers as "yes it can", such access attempt can happen in another
> > process/task (hence, not only does it lack KVM context, but also not
> > sharing the same task context).
>
> Right after I sent it, I just recalled whenever a device needs to access
> the page, it needs to be converted to shared pages first..

Yep! This is my understanding anyway. Devices will need to GUP or use
the userspace page tables to access guest memory; both of which will
go to userfaultfd. And userspace hasn't told KVM to make some pages
shared, then these GUPs/faults will fail.

Maybe Trusted I/O changes some things here... let me reply to Sean. :)

> So I suppose the questions were not valid at all!  It is not about the
> context but that the pages will be shared always whenever a device in
> whatever form will access it..
>
> Fundamentally I'm thinking about whether userfaultfd must support (fd,
> offset) tuple.  Now I suppose it's not, because vCPUs accessing
> private/shared will all exit to userspace, while all non-vCPU / devices c=
an
> access shared pages only.
>
> In that case, looks like userfaultfd can support CoCo on device emulation=
s
> by sticking with virtual-address traps like before, at least from that
> specific POV.

Yeah, I don't think the userfaultfd API needs to change to support
gmem, because it's going to be using the VMAs / user mappings of gmem.
