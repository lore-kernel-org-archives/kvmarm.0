Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C9C5689
	for <kvmarm@lists.linux.dev>; Fri, 21 Apr 2023 17:40:04 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1a686260adcso27090725ad.0
        for <kvmarm@lists.linux.dev>; Fri, 21 Apr 2023 10:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682098804; x=1684690804;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dhmzadUG3fZs7husXeA0WbkxQGo5+WSirow/ZLJYIA8=;
        b=pJm4mnRWylHJ0Gat/ee7mWuQRrm9PVz1aPFna537nzZRRXGR4K5lTDHOl8n5i2uu48
         EUMk6MzxI+9wqOFuxraK0ZbUpvCC4tIGAsXhspbFezqRX8BE1BxwJy8OKhTaDOjig6ob
         Px/LF85jpt9vPJa9dFPxJ+yv7OdYPoEljuimK0lpmB0E+KgSvniPG4vuKuefphuSeJcZ
         QluANtigCw2t0Hv/9nffvdU0U1OIAQSzStrVHs0TvaHhsrMAaXJtyA1lkV0TkygyEeGT
         7DoXIwF2Nyu9/i4GFaAA3xw7svYLkVVtdjP39DUN/74Ax/5uxGgKNcnH1gusSFvtPnIO
         Fd3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682098804; x=1684690804;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dhmzadUG3fZs7husXeA0WbkxQGo5+WSirow/ZLJYIA8=;
        b=kd1srMujzXuMSWISOgCWNlTmfSHnJfwQlgIwssQ50bKvGxsSec14IML1lKsOQTj4/B
         oeP4htqFVAIUkOeld/zugy6QIPLAMJna+xBQERBipueEEOug3V6BUdjaxPbhBYMTUniC
         oq7DSL9MX5X7XqNR2ZqS7CcoEjVl/c3uf2bMbhnDwVnrGZhC8o8Ugoxd1tAEtfVZUr39
         vZ4H1b/aZysdeoSecvtWtIHCZnWnAaNYBBG9+tbolqLoHEvDQ8TL7F0EOAP0GTTbpVcp
         cuoxFeytnEuVtQ0DNIuviDFCaGQBTa17wgBmcKPw69CTXvqdangTQQFukY6IyYqNK+/E
         QnmA==
X-Gm-Message-State: AAQBX9exirstu6dEP6MDbIyyWE6kx/uMz9GowBX21yeHCy/vfcSsJ8Vu
	sZxXSZ2hVrazt9lw3GKTM1c=
X-Google-Smtp-Source: AKy350YGTGp3cJL7b4EnpySmGHmH/RmGOJNpVyZKI5FM1zZ1uha5N7JLEpkc6v8GyUuGJfA+4+aGYA==
X-Received: by 2002:a17:903:1ce:b0:1a2:a8d0:838e with SMTP id e14-20020a17090301ce00b001a2a8d0838emr5564267plh.61.1682098803815;
        Fri, 21 Apr 2023 10:40:03 -0700 (PDT)
Received: from smtpclient.apple ([66.170.99.95])
        by smtp.gmail.com with ESMTPSA id ju18-20020a170903429200b001a526805b86sm2987436plb.191.2023.04.21.10.40.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Apr 2023 10:40:03 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <ZEGuogfbtxPNUq7t@x1n>
Date: Fri, 21 Apr 2023 10:39:51 -0700
Cc: Anish Moorthy <amoorthy@google.com>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 maz@kernel.org,
 oliver.upton@linux.dev,
 Sean Christopherson <seanjc@google.com>,
 James Houghton <jthoughton@google.com>,
 bgardon@google.com,
 dmatlack@google.com,
 ricarkol@google.com,
 kvm <kvm@vger.kernel.org>,
 kvmarm@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <46DD705B-3A3F-438E-A5B1-929C1E43D11F@gmail.com>
References: <20230412213510.1220557-1-amoorthy@google.com>
 <ZEBHTw3+DcAnPc37@x1n>
 <CAJHvVchBqQ8iVHgF9cVZDusMKQM2AjtNx2z=i9ZHP2BosN4tBg@mail.gmail.com>
 <ZEBXi5tZZNxA+jRs@x1n>
 <CAF7b7mo68VLNp=QynfT7QKgdq=d1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>
 <ZEGuogfbtxPNUq7t@x1n>
To: Peter Xu <peterx@redhat.com>
X-Mailer: Apple Mail (2.3731.500.231)


> On Apr 20, 2023, at 2:29 PM, Peter Xu <peterx@redhat.com> wrote:
>=20
> Hi, Anish,
>=20
> [Copied Nadav Amit for the last few paragraphs on userfaultfd, because
> Nadav worked on a few userfaultfd performance problems; so maybe he'll
> also have some ideas around]

Sorry for not following this thread and previous ones.

I skimmed through and I hope my answers would be helpful and relevant=E2=80=
=A6

Anyhow, I also encountered to some extent the cost of locking (not the
contention). In my case, I only did a small change to reduce the =
overhead of
acquiring the locks by =E2=80=9Ccombining" the locks of =
faulting_pending_wqh and
fault_wqh, which are (almost?) always acquired together. I only acquired
fault_pending_wqh and then introduced =E2=80=9Cfake_spin_lock()=E2=80=9D =
which only got
lockdep to understand the fault_wqh is already protected.

But as I said, this solution was only intended to reduce the cost of =
locking,
and it does not solve the contention.

If I understand the problem correctly, it sounds as if the proper =
solution
should be some kind of a range-locks. If it is too heavy or the =
interface can
be changed/extended to wake a single address (instead of a range),
simpler hashed-locks can be used.=
