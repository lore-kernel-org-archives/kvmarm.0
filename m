Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083552F23
	for <kvmarm@lists.linux.dev>; Wed, 10 May 2023 23:45:15 +0000 (UTC)
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-305f0491e62so7553131f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 10 May 2023 16:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683762314; x=1686354314;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g/f8372EfFL0dLuJKV88dmyrC50A+7+4fh9twA0BZdY=;
        b=m50IVE0QT4eqBj4Or1oen4xbNKS5CMUm8lq5U/3QnCNem8hdW+QYI69PdE8BXfygwY
         Cjkv9s5R+qJwKrCjXBH8R/n9NQ7BgQtk7xloOeLczsO4MytH/UMNsW2xu8L7mFu4hQZc
         /1nVpf6ZH1Z71Fa7KIXImPhZ0DM4l9QypzWSLXaAsyqZ9Xr2ox0vvREZsVpIoMZLjyO0
         AbPbgFy8D4/EFQJdZIN1s76ZENXKdlo32sjW+Gl4YRhppamJuQNYOGv7sRzm2k5bQyJa
         wmxK6NH1j4cRHDJqlY0J1XoRBFdt2rZRE4XecJJaVwockrnceezaYQm5KorLW22XdS78
         xNUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683762314; x=1686354314;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g/f8372EfFL0dLuJKV88dmyrC50A+7+4fh9twA0BZdY=;
        b=JSMiQauN07Yfp/tr6cCPym9sJoiZu34ya/uG9nRxEE1g2cRYKNn2xvQz0HmZ07l0/t
         cmCHf/k05sTkP6ie9zkYG0CGXISt+hbW6UYQVJYDxAcMnS/WTCt/ZpYWKW6T2EmKHzXh
         64gRVkRM4D10LqQAkONKcZRQC0twwN0OL9THKeRZUyWw+94hjAD50sexNVErp4I4JI7v
         N+ppOTt/ToUQlgRZYfPEwAjHkyx+RNW7R5853ypNlu956evNYWkxvlN7jeZnXLQ+NZ82
         U9SyJlRC9XK3J+SUVR4o0et2L3+itYss+7yI9lfRYpoHI5vEnziyKcROwsCuMFjOlE32
         ewXQ==
X-Gm-Message-State: AC+VfDyGaBdW/PQG4N4Tpkq2jhVuzaR40ManqfFD+yS+2fwQt2Jqo2xX
	qpQtqjEElsPCHDAjpnQV6hQbpyRx3eskAYuRbJrD+A==
X-Google-Smtp-Source: ACHHUZ47nGjmuV7bPmEwBVtyVi/FCzcge0GMT/DBO5cr5fCZW+NSursjE7RbTpdEU+gNfH1L81j3WQHrb0/C+84VnjY=
X-Received: by 2002:a5d:6606:0:b0:2ef:b123:46d9 with SMTP id
 n6-20020a5d6606000000b002efb12346d9mr13906473wru.3.1683762314195; Wed, 10 May
 2023 16:45:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <ZFrG4KSacT/K9+k5@google.com>
 <ZFwcRCSSlpCBspxy@google.com>
In-Reply-To: <ZFwcRCSSlpCBspxy@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 10 May 2023 16:44:37 -0700
Message-ID: <CAF7b7mrLW665hfZCT==1A0C2bw1SHUYTF+yaAMDNuZAd8ydu1w@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
To: Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>, pbonzini@redhat.com, maz@kernel.org, 
	oliver.upton@linux.dev, jthoughton@google.com, bgardon@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 10, 2023 at 3:35=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Yeah, when I speed read the series, several of the conversions stood out =
as being
> "wrong".  My (potentially unstated) idea was that KVM would only signal
> KVM_EXIT_MEMORY_FAULT when the -EFAULT could be traced back to a user acc=
ess,
> i.e. when the fault _might_ be resolvable by userspace.

Well, you definitely tried to get the idea across somehow- even in my
cover letter here, I state

> As a first step, KVM_CAP_MEMORY_FAULT_INFO is introduced. This
> capability is meant to deliver useful information to userspace (i.e. the
> problematic range of guest physical memory) when a vCPU fails a guest
> memory access.

So the fact that I'm doing something more here is unintentional and
stems from unfamiliarity with all of the ways in which KVM does (or
does not) perform user accesses.

Sean, besides direct_map which other patches did you notice as needing
to be dropped/marked as unrecoverable errors?
