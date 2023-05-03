Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A488EDF67
	for <kvmarm@lists.linux.dev>; Wed,  3 May 2023 20:09:54 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-b9a7e3fc659so12407522276.1
        for <kvmarm@lists.linux.dev>; Wed, 03 May 2023 13:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683144593; x=1685736593;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eGmt2vyUuGkmpCbVhWZSJ5eSK3GpTIz9V8J//ylvB7M=;
        b=5Itlb076hfzk2tpwbXXhouV0ED49WTj7zlg9jjFf90Mqn52Lu4ZzwDBPk5qe0GaXC0
         Bjq0g43uvHE5X4nITMUBJfu2blbJFOdVRrKVwpZH0GjPbv01lkhKcx9O3soajxi8ljQk
         ZHPtrOdWyby7dMYefELp+UVWKQoFyR0EN6nOYCNDdD3HjwqQRq8T7IKyfEFI8MXaqRJM
         siOWMuuKq6+3+o7pA4J5PFzS/t18oQgt9qa16PHvY2egCAk0N6ZG/kXGy9CoyBmchIdN
         UK5hj2l7Gw963FR+8dLavY+pjNpDheO8pqkKWq5gMcpGRcBaoRR1uSWG1cQ+fv76fT3U
         zPNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683144593; x=1685736593;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eGmt2vyUuGkmpCbVhWZSJ5eSK3GpTIz9V8J//ylvB7M=;
        b=hU2jV2ZQnkBq/IUkJNpuCWFuyKph0WO8pIy4EojvmujUt1/WV7Hq6+ItYDc+eyPg8r
         V70grOf7FtqvPxSdyJnjXp/Ac2nF9tcv9g4wusUpDQtEE7GbdQVw2m+2+mJHc+CYh7Z9
         W5h8w5chkn4dCR8BRNAMJAvHWx7oy4RO5u5RDiCOBzJW49arosy9UIS+4oYWlFwjtBHb
         klaAx1pwf3TRR6pFj6QqhCGfL+ZDEwKvFhL/zFyt4qR3dA4ZFrsWhGxp2tTSFnqUfkb+
         jr5zQYNadYY5MesW3JiHCuTAVQmmG5q2YfGNKFgzLLMHo75GtExycwAEhJEKDn3nG+Mi
         c3jw==
X-Gm-Message-State: AC+VfDwuhdJEmnU+j8/WB2tx3S1fN6QIyLRYeE9quW4BmEesuhR7BmNi
	jFVsqxhxsexmtmx/Khvcf+EIAbVoVfs=
X-Google-Smtp-Source: ACHHUZ5pv/blUiyPyfMIgcxE0mYSuWOMa0JCpIXDO8pCT1AJhklO6MfaMJHycwYdut6UuO0uVg1UVSmDp0w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:947:0:b0:b9d:8612:a8bd with SMTP id
 u7-20020a250947000000b00b9d8612a8bdmr6880905ybm.4.1683144593691; Wed, 03 May
 2023 13:09:53 -0700 (PDT)
Date: Wed, 3 May 2023 13:09:51 -0700
In-Reply-To: <CAF7b7mqaxk6w90+9+5UkEAE13vDTmBMmCO_ZdAEo6pD8_--fZA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <CAJHvVchBqQ8iVHgF9cVZDusMKQM2AjtNx2z=i9ZHP2BosN4tBg@mail.gmail.com>
 <ZEBXi5tZZNxA+jRs@x1n> <CAF7b7mo68VLNp=QynfT7QKgdq=d1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>
 <ZEGuogfbtxPNUq7t@x1n> <46DD705B-3A3F-438E-A5B1-929C1E43D11F@gmail.com>
 <CAF7b7mo78e2YPHU5YrhzuORdpGXCVRxXr6kSyMa+L+guW8jKGw@mail.gmail.com>
 <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com> <CAF7b7mr-_U6vU1iOwukdmOoaT0G1ttyxD62cv=vebnQeXL3R0w@mail.gmail.com>
 <ZErahL/7DKimG+46@x1n> <CAF7b7mqaxk6w90+9+5UkEAE13vDTmBMmCO_ZdAEo6pD8_--fZA@mail.gmail.com>
Message-ID: <ZFK/j8EjGc1v8T5g@google.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: Peter Xu <peterx@redhat.com>, Nadav Amit <nadav.amit@gmail.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org, 
	oliver.upton@linux.dev, James Houghton <jthoughton@google.com>, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, kvm <kvm@vger.kernel.org>, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 03, 2023, Anish Moorthy wrote:
> On Thu, Apr 27, 2023 at 1:26=E2=80=AFPM Peter Xu <peterx@redhat.com> wrot=
e:
> >
> > Thanks (for doing this test, and also to Nadav for all his inputs), and
> > sorry for a late response.
>=20
> No need to apologize: anyways, I've got you comfortably beat on being
> late at this point :)

LOL, hold my beer and let me you you the true meaning of "late response". :=
-)
