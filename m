Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294E61836D0
	for <kvmarm@lists.linux.dev>; Wed,  3 Jul 2024 20:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720037548; cv=none; b=gLQ6eCIULARJULkjiPtx7M4pTrc30ooR24fJh9v2h92v81mRV8U92vvrcUqsKCJvpZpICv5H+NnrUJTF1+DHW/M8vjbEvec+CZ27Z8Z7W/+lbeyE0bpo1A4I2690F2JjMM7zKDbtR1K8m7dwC8IB72u1Lc4erfAcuqzz+zW215s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720037548; c=relaxed/simple;
	bh=80W5GndL0widXld75GsZwiV0NLDCplZ+tQVpoOnihP8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o84Ce523o1WLcdfpK6gzm+91HUFC0c3nvZksrF4DUeFjZqzZnsPNDkPCZkoEqL58Ync4EH+VrgrUb+R+utLhG1FJBT1v11qzjf+AcSG20ywj3faLPkPKUjBFuAaEoKdgrtK37mpWBRQpJZLkJyUbqKguwQFjh04AHHW6t7uMQlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XoCPUbt7; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XoCPUbt7"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-42578fe58a6so32990665e9.3
        for <kvmarm@lists.linux.dev>; Wed, 03 Jul 2024 13:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720037543; x=1720642343; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zE63Ktwe2xp7wEqSVWtbUemIUpIWXGCvMeuKhVG4zNw=;
        b=XoCPUbt7RI08aTOsQKQc4IJp1pCVT3lWnT/SwDhus6FHIQFKBCluobbfxy1D5iUgyM
         irwAqFTlv+6TdqDddAh2iq9vdBsB31u4+u4YCoMtNu555ud42o0DQYuzO8IQRStGbxi+
         //vIwK2FYoDujZGi2I4QejUpd0G7Flm0ou0iFP72YqJx6rO+CfhP6SjBkoyFupDeA7i8
         jd/cjZ2bNtgDRuZ0hxkPbk0lW0oDuEkrAm4wXBhYfWOrN2KhUEoZhy6aP/5NijtyGOQ/
         +BKblYUkrnEOoXxaLfollagJ4gunyu8uKbRFSoBgyvm/zC5yiI4wngIPgGqEDW29OV/9
         NZFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720037543; x=1720642343;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zE63Ktwe2xp7wEqSVWtbUemIUpIWXGCvMeuKhVG4zNw=;
        b=SIXkoKaD3ARyKJA+BL83RKlRyMg1JMmUFQVuHWZBs0MsT+mM5unT6H6tLjE3sTbSfC
         0TZ4+wbHzHxe/LfXmYwnXAoHlNymJ5DpmFO3FmRq2wbPaTlxuAPY949V8/JTzNE7+BE6
         +7TjlJvtYqfnw50f9WS2I7GDSvwwKB8EtqpVCrqQqE1YN0O911s96r6z7QryNymum+8g
         KjiwnyP3BxpY6MKqt/w0e3Hfe0v5V1m9DdyahgRAk0XoVO5cXYSYxUgiH6vr2+uT+C7t
         HSwYwr8G/0YGLQa63J3ivTyVIdNqBTLCPl/AzfqZNeSQFOxR2jDI1ECxS5Jl+qXLAA5M
         OJHw==
X-Forwarded-Encrypted: i=1; AJvYcCUao97BfXBEMghkhgtdRnCEx4pvFjatRqxLNIGUlmVBC8Lui8aQWS3iKDmZPIAymnxMGsAqMM73tlue2bJyyxA8L5HWrVHE
X-Gm-Message-State: AOJu0Yy6xQL3LnTwID3o0PLCR67AuqbYGSB+8goNhq1Z+qHq9Kz+MNj+
	YHPRmDp7U4x908O/LQ3RU426/Ao5Pt5smcVkzCHLkqr2k+GncqQ6xKvWHX5P6c23dX0ZW5x5+U5
	MSANu7LrIkxcbKLjWooWAoWPcL+7+JdvTxRPO
X-Google-Smtp-Source: AGHT+IEbTBGkDEkTRWn1RGJZwfOMrQRPTBUh/CecN+lIDwo4RV9LNTAOu7EMjJk2Li2rPQJa1KTDgqJ8gKdJ6DL5+/8=
X-Received: by 2002:a05:600c:3547:b0:424:8f40:a2eb with SMTP id
 5b1f17b1804b1-4257a034de5mr93861665e9.9.1720037543469; Wed, 03 Jul 2024
 13:12:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com> <20240215235405.368539-7-amoorthy@google.com>
 <ZeuMEdQTFADDSFkX@google.com> <ZeuxaHlZzI4qnnFq@google.com>
 <Ze6Md/RF8Lbg38Rf@thinky-boi> <CALzav=cMrt8jhCKZSJL+76L=PUZLBH7D=Uo-5Cd1vBOoEja0Nw@mail.gmail.com>
 <923126dd-5f23-4f99-8327-9e8738540efb@amazon.com>
In-Reply-To: <923126dd-5f23-4f99-8327-9e8738540efb@amazon.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 3 Jul 2024 13:11:55 -0700
Message-ID: <CALzav=ePCJiYABpWG70ddPj2Yt57UAxynd64ZWzSVDHUVA3X3w@mail.gmail.com>
Subject: Re: [PATCH v7 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
To: kalyazin@amazon.com
Cc: Sean Christopherson <seanjc@google.com>, Anish Moorthy <amoorthy@google.com>, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com, 
	Oliver Upton <oliver.upton@linux.dev>, roypat@amazon.co.uk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 3, 2024 at 10:35=E2=80=AFAM Nikita Kalyazin <kalyazin@amazon.co=
m> wrote:
>
> Hi David,
>
> On 11/03/2024 16:20, David Matlack wrote:
> > On Sun, Mar 10, 2024 at 9:46=E2=80=AFPM Oliver Upton <oliver.upton@linu=
x.dev> wrote:
> >>>>
> >>>>    2. What is your best guess as to when KVM userfault patches will =
be available,
> >>>>       even if only in RFC form?
> >>>
> >>> We're aiming for the end of April for RFC with KVM/ARM support.
> >>
> >> Just to make sure everyone is read in on what this entails -- is this
> >> the implementation that only worries about vCPUs touching non-present
> >> memory, leaving the question of other UAPIs that consume guest memory
> >> (e.g. GIC/ITS table save/restore) up for further discussion?
> >
> > Yes. The initial version will only support returning to userspace on
> > invalid vCPU accesses with KVM_EXIT_MEMORY_FAULT. Non-vCPU accesses to
> > invalid pages (e.g. GIC/ITS table save/restore) will trigger an error
> > return from __gfn_to_hva_many() (which will cause the corresponding
> > ioctl to fail). It will be userspace's responsibility to clear the
> > invalid attribute before invoking those ioctls.
> >
> > For x86 we may need an blocking kernel-to-userspace notification
> > mechanism for code paths in the emulator, but we'd like to investigate
> > and discuss if there are any other cleaner alternatives before going
> > too far down that route.
>
> I wasn't able to locate any follow-ups on the LKML about this topic.
> May I know if you are still working on or planning to work on this?

Yes, James Houghton at Google has been working on this. We decided to
build a more complete RFC (with x86 and ARM) support, so that
reviewers can get an idea of the full scope of the feature, so it has
taken a bit longer than originally planned. But the RFC is code
complete now. I think James is planning to send the patches next week.
