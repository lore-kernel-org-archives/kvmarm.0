Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF257127B64
	for <kvmarm@lists.linux.dev>; Wed,  7 Feb 2024 21:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707340905; cv=none; b=KmRTPlMd/a3AwR9G65RVJ9zG9g/pP3BRp7D9wvP11bdE0244y8zRuaoqw6AB0igw6jkgfuVBGP0LSnK/nzTwaDPknfrbbEgIHqXCMlgGC4GjgYH+wLVyxznEjJpyPCZCV8UiIF8NQetFnxmzCu8ticYQ9A+GJs0BWJ3ZfhkDzN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707340905; c=relaxed/simple;
	bh=UQlLBfZgZXSkYlQ8HJZCC0qwcFlgHKC0bjB8npWrlD0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SnZ8gBAjYQH6Um2wIk6jd/cvBecrf6HIPPb5DvRarF/wvOGcIc5f0rBn0NpJNWsyjm1/Puf2UDWL5m59evnNoAm4ix50hksV38IFK0NVLInVn8hQQNhB9Cj6uyrgjEj74+VIYxBGfMUOZKMFPglMI5BB5bw2MyTe6YWvd7qKrhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H64NnNHo; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H64NnNHo"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-59a31c14100so475525eaf.0
        for <kvmarm@lists.linux.dev>; Wed, 07 Feb 2024 13:21:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707340903; x=1707945703; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9+9siunvM5UdG2ZEMEzLFuGyA9mTYuPGVcSBrejH4V0=;
        b=H64NnNHoCNx8H6pPMCMNSixwRvs6BXo0SlDt4oAUTvyg5/FcmFH4ccTqicd3CrUpQg
         MzivSYaB4rLiVS1R1M1RYh6kt4lrHh/SQrzjdFkY7CKNh7lhl8+W5dBSVxXt5iAzvKkJ
         p5oHw2NcAh8Ml7NeVkuKBCYgNrSByuGHz1j+nsCnRB+q2u9rZ7rxwb4TlEzR8DHOh4yQ
         4+DWPf3hFoLyFttUovW/+Q7K/uOEVGdYPtaoH+kc6AYliGm4ibTewfSgCRpIi02B3m43
         haWMXTjS8jAps/deH4hVwK4L3e5kIffd5xLk8Tnz2K5faQWDYTfm5cUiTzZO3OkwhQYh
         KaxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707340903; x=1707945703;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9+9siunvM5UdG2ZEMEzLFuGyA9mTYuPGVcSBrejH4V0=;
        b=szL3dnUUHDMrdZ3/iqOZ29ueX3LO412a/Kp9P5u5R3S1lQ+RoKPMy1ZtF4coPWEktm
         crJG1i8eTbG4vcsB7y8Ue6+CQDIM8SzYt9jSEG0VcTEK98DCJXd1/nBEBjQFQdehSN/G
         69vZ4GtgPEO5gQ5Si3bxn60XxLKscLFp8sFnPByrz8ZIkBxwCKi91/nPNa/eb5Nmar2n
         r2dDHgIiulAHNTV7XJKRb/IFd1nQadZWNYCqzKOGdSmBdImdiy6G3MtKS6qWSMRNFNJG
         mls4uJ4uVHPwpsddZX5yKFntkxgzo9LRhxCDvibKbjiGOGcs98uDLdYnqrLszpEd1itN
         8EvA==
X-Forwarded-Encrypted: i=1; AJvYcCW7b+mGchAGZKJOhPsq8r/i+n+/eD7quFIKTOT5B1ymoyHFujhfF6hs8g0wDlctVIrQvTdZ9Dr5rsCHmkH5YAwPE/41OiVP
X-Gm-Message-State: AOJu0Ywjp0pD2vaS/BYSbX7wAwJIrd/YMQmlF/92Q22lJjhGazxMuG5E
	joQT7of06b9oBNKE/Yy8Wp565Kayz8ui/ht9pLYfxBEsgB8lIGlJ5I4R9JCB7MW4ko2jPd/DZ3Q
	UAWrKoSBwZ2Fv3ln97YnevjtMISTm+1jopw8P
X-Google-Smtp-Source: AGHT+IHElp9ZPny7h8jfiC7GNRGG1UZioZ9JVc8UP8z30enIBWjKc+VXuS1u69leeZYfXtJ8/RrfQvLACexjKmcwDPM=
X-Received: by 2002:a4a:3402:0:b0:59a:893a:22fa with SMTP id
 b2-20020a4a3402000000b0059a893a22famr7853333ooa.6.1707340902937; Wed, 07 Feb
 2024 13:21:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-9-amoorthy@google.com>
 <CAF7b7mqDN97OM7kgS--KsDygokUHd=wiZjYPVz3yk7UB0jF_6w@mail.gmail.com>
 <ZcOkRoQn7Q-GcQ_s@google.com> <ZcOysZC2TI7hZBPA@linux.dev>
In-Reply-To: <ZcOysZC2TI7hZBPA@linux.dev>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 7 Feb 2024 13:21:05 -0800
Message-ID: <CAF7b7mqOCP2NiMsvzfpYaEaKWm4AzrRAHSGgQT9BWhRD1mcBcg@mail.gmail.com>
Subject: Re: [PATCH v6 08/14] KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO
To: Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	maz@kernel.org, robert.hoo.linux@gmail.com, jthoughton@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 7, 2024 at 8:41=E2=80=AFAM Oliver Upton <oliver.upton@linux.dev=
> wrote:
>
> On Wed, Feb 07, 2024 at 07:39:50AM -0800, Sean Christopherson wrote:
>
> Having said that...
>
> > be part of this patch.  Because otherwise, advertising KVM_CAP_MEMORY_F=
AULT_INFO
> > is a lie.  Userspace can't catch KVM in the lie, but that doesn't make =
it right.
> >
> > That should in turn make it easier to write a useful changelog.
>
> The feedback still stands. The capability needs to be squashed into the
> patch that actually introduces the functionality.
>
> --
> Thanks,
> Oliver

Hold on, I think there may be confusion here.
KVM_CAP_MEMORY_FAULT_INFO is the mechanism for reporting annotated
EFAULTs. These are generic in that other things (such as the guest
memfd stuff) may also report information to userspace using annotated
EFAULTs.

KVM_CAP_EXIT_ON_MISSING is the thing that says "do an annotated EFAULT
when a stage-2 violation would require faulting in host mapping" On
both x86 and arm64, the relevant functionality is added and the cap is
advertised in a single patch.

I think it makes sense to enable/advertise the two caps separately (as
I've done here). The former, after all, just says that userspace "may
get annotated EFAULTs for whatever reason" (as opposed to the latter
cap, which says that userspace *will* get annotated EFAULTs when the
stage-2 handler is failed). So even if arm64 userspaces never get
annotated EFAULTs as of this patch, I don't think we're "lying" to
them.

Consider a related problem: suppose that code is added in core KVM
which also generates annotated EFAULTs, and that later the arm64
"Enable KVM_CAP_EXIT_ON_MISSING"  patch [1] ends up needing to be
reverted for some reason. If the two patches were merged, that revert
would silence *all* annotated EFAULTs for arm64, which seems
incorrect.

James and I had this discussion in [2] (I propose an updated
description there too).

[1] https://lore.kernel.org/kvm/20231109210325.3806151-10-amoorthy@google.c=
om/
[2] https://lore.kernel.org/kvm/CAF7b7mrALBBWCg+ctU867BjQhtLQNuX=3DYo8u9TZE=
uDTEtCV6qw@mail.gmail.com/
