Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F774191F9B
	for <kvmarm@lists.linux.dev>; Thu,  5 Dec 2024 23:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733441505; cv=none; b=qApcSaux3BkMrUe+YrOpSuDZt3FOBEo0u7ErogzyHAQqisRFzTj6yqhG4ysL8bMXWQcv4S3QSklbZ20lKWK+y+F4Yzh7IZAZJnVeMUapE7/NdziWQHH4ibUqbQ7dBD+CY1PwoGAnBkJi7cPuhKns3OCoxxQI/BRTJlzBi4gIgQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733441505; c=relaxed/simple;
	bh=/ihX0lCXBJfFCvsOFHIJu6cysZ6Vq0x4cO5iS9Q7qBY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mIs9Bv9a4DiQ2xSYq4gacFZlgKfq83XKHfAhn/x9kumg5k4axVvMt/T9gB2mLoIdqpIb8XKydaCnfuwePM5kHpH+e6YdTXbkfizS+vuxPZg3LwEgLui2RH85y++E81Uj8wLMAvvxYPn0x54B7yh6q5+RImh+1WgL38lmH1L+8rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VOIhuJfC; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VOIhuJfC"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-6efe5c1dea4so1004127b3.3
        for <kvmarm@lists.linux.dev>; Thu, 05 Dec 2024 15:31:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733441501; x=1734046301; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T0IMN5OU4hbVrS5t00San57aLCq8tVf/YYU7UNV9XtU=;
        b=VOIhuJfC3RBceGD0bR6Lf/xDuQmNA84+d6dBu/GqcqEXFS6e4n7axumxNHJ8y9oB3/
         tpenvxh0NvePpziuOItw0GxM+PVItK7xmDCDfjQTZ2vMlvT+2U3sPxIOkqR/XH3Qmmby
         svUS8IiuEFXa+IWgOgIbd5PV8kaT6VcPKVpRzwJxJJvMgu0ceq//dR/r377F72VB7SrK
         8iFsDJCaV/LTEYJRmxSdeCzJIvcnmiShtsbYlyF1HijY1khQn4cyrd0RhHbP/njOaS2Q
         CUEBNIgeKmV1wJohDBwhhRw8iRG51uxFJ4z11PzwO4G6iDHXiTYofS6Wqlu8wZmjImZI
         2YfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733441501; x=1734046301;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T0IMN5OU4hbVrS5t00San57aLCq8tVf/YYU7UNV9XtU=;
        b=whfowoRk65TsObLh21xrSx2Dq4ixOGYlxjePfBn0qz7HODB7+2iNaiMYo+9RMsabc+
         ayz62HVKee+EKWw6N7ywwxEQATFhS7Bvul8tBxL0t3oNTsq1DsyBlueexcJMnbrmCwkP
         SGZumRCvLu7dLO/rmlJBuTbzwTwP666Jhm5V6CBH7/0vFt2X6F8KOCp8tx+XMWLYW8U/
         FH0QomG6FW1EpkxbOuYhtSbHXH50y9AhpMg0NjbPKJrV+DTGjpSQsWXNdW3MewTJcZLO
         QYusSjjcSo7jurolgGY9167ORMfu3N856ZnLWJ+hERtA0W2KS6dx8pRDr82AJnNRECXG
         KRig==
X-Forwarded-Encrypted: i=1; AJvYcCXjQlt+MK8dQqBOrBmtmT4DzyUBLWR/ZKgBDnR0B1o/U6TCd+A6mVSWUFUhawOR7m5um/8X08A=@lists.linux.dev
X-Gm-Message-State: AOJu0YyG8961/cp8sImNMVZV/WXHuH396pdIeQWBG4rXttzn36mhE2DO
	hwjvPKztgt7qQepDy9/mB2VWEvyY817ETyLZkurF0lO62pWqyFP7vqEaff9MqJVIWIHRmxraiOe
	18zDC+LSn93nzGTZNxdFSzJHVZERO/lmU68py
X-Gm-Gg: ASbGnculolWFrjWc8Mzfhp4Qd/tPVmJbfRpP3ZQUKSWKdEaW/J3c5TJwEtzucDg7Gd5
	W3pouiyOfFtKfKqHMW/s0VUH/4sTb7KHfebi/j2etKAGb+97XwMJ+n3aFFotq
X-Google-Smtp-Source: AGHT+IGmoqWrGrMqKXzXbSlaDtMUJEUS1r8dSNypZARIHLTYBVYvB4FriHIdmOjPWn9wrKQu/NTZU5U476BPS24s0cI=
X-Received: by 2002:a05:690c:6083:b0:6ee:6c7d:4888 with SMTP id
 00721157ae682-6efe3c6049bmr11833187b3.22.1733441501392; Thu, 05 Dec 2024
 15:31:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
 <20241204191349.1730936-7-jthoughton@google.com> <Z1Dgr_TnaFQT04Pi@linux.dev>
In-Reply-To: <Z1Dgr_TnaFQT04Pi@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Thu, 5 Dec 2024 15:31:05 -0800
Message-ID: <CADrL8HWC7HhYmEBWa+5KeWmyD+iT1zPBJUAUtNyrhH7ZpLXJNQ@mail.gmail.com>
Subject: Re: [PATCH v1 06/13] KVM: arm64: Add support for KVM_MEM_USERFAULT
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, Wei W <wei.w.wang@intel.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024 at 3:07=E2=80=AFPM Oliver Upton <oliver.upton@linux.dev=
> wrote:
>
> Hi James,

Hi Oliver!

>
> On Wed, Dec 04, 2024 at 07:13:41PM +0000, James Houghton wrote:
> > Adhering to the requirements of KVM Userfault:
> >
> > 1. When it is toggled (either on or off), zap the second stage with
> >    kvm_arch_flush_shadow_memslot(). This is to (1) respect
> >    userfault-ness and (2) to reconstruct block mappings.
> > 2. While KVM_MEM_USERFAULT is enabled, restrict new second-stage mappin=
gs
> >    to be PAGE_SIZE, just like when dirty logging is enabled.
> >
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> >   I'm not 100% sure if kvm_arch_flush_shadow_memslot() is correct in
> >   this case (like if the host does not have S2FWB).
>
> Invalidating the stage-2 entries is of course necessary for correctness
> on the !USERFAULT -> USERFAULT transition, and the MMU will do the right
> thing regardless of whether hardware implements FEAT_S2FWB.
>
> What I think you may be getting at is the *performance* implications are
> quite worrying without FEAT_S2FWB due to the storm of CMOs, and I'd
> definitely agree with that.

Thanks for clarifying that for me.

> > @@ -2062,6 +2069,20 @@ void kvm_arch_commit_memory_region(struct kvm *k=
vm,
> >                                  enum kvm_mr_change change)
> >  {
> >       bool log_dirty_pages =3D new && new->flags & KVM_MEM_LOG_DIRTY_PA=
GES;
> > +     u32 changed_flags =3D (new ? new->flags : 0) ^ (old ? old->flags =
: 0);
> > +
> > +     /*
> > +      * If KVM_MEM_USERFAULT changed, drop all the stage-2 mappings so=
 that
> > +      * we can (1) respect userfault-ness or (2) create block mappings=
.
> > +      */
> > +     if ((changed_flags & KVM_MEM_USERFAULT) && change =3D=3D KVM_MR_F=
LAGS_ONLY)
> > +             kvm_arch_flush_shadow_memslot(kvm, old);
>
> I'd strongly prefer that we make (2) a userspace problem and don't
> eagerly invalidate stage-2 mappings on the USERFAULT -> !USERFAULT
> change.
>
> Having implied user-visible behaviors on ioctls is never good, and for
> systems without FEAT_S2FWB you might be better off avoiding the unmap in
> the first place.
>
> So, if userspace decides there's a benefit to invalidating the stage-2
> MMU, it can just delete + recreate the memslot.

Ok I think that's reasonable. So for USERFAULT -> !USERFAULT, I'll
just follow the precedent set by dirty logging. For x86 today, we
collapse the mappings, and for arm64 we do not.

Is arm64 ever going to support collapsing back to huge mappings after
dirty logging is disabled?
