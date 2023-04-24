Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A323214
	for <kvmarm@lists.linux.dev>; Mon, 24 Apr 2023 17:55:28 +0000 (UTC)
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-76355514e03so430265739f.0
        for <kvmarm@lists.linux.dev>; Mon, 24 Apr 2023 10:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682358927; x=1684950927;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qK0g7OjjecNV9tTu3zO64lSO1YjuimVznnZZbsBmbRA=;
        b=m2GQZIOpmOMM7ESyTmKbtoevb5UEW7eDeXUpNfNok9EqUc75StZqoqM2rHHuDY8L+i
         rhNAW52UC807nIj0M4O8M2Xsrm8eiR75V4SYcRNTjm/HQcKpj80+OBQqmlHozhOarAgM
         s//kPObbRGybaw0gRSL1ot566d/ip/8ae+5HW1DEEZ4odrUPHZ/UzyqSaolbtcy55slb
         geRWognQa3HCKtKJ6Y4jw/un0Z7hV3nB54awmhbcJndbud49MfPaxUCgYxY51g4u4A35
         Gq4YDOHn3BsvlSGrmSF9nHapcbkQHH/7eFvdxxbCcoISiWSeEiahxtTdNzDsKwRE4Lfz
         AXcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682358927; x=1684950927;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qK0g7OjjecNV9tTu3zO64lSO1YjuimVznnZZbsBmbRA=;
        b=AqmCpkGtZlY6Xb8duD30ekWyBXDQ1gvSU8nUvX0lG1Iw2RyBOMQolWqzyNd0LGbsxu
         6T1EBjSGUegDUT82nDM0k80AvS7jPB0Q78g0ZEk4x1Y66ds/dvCaMC1VW60HM/DQanFq
         VTAK7YsYq/5KwJ/1CWWdN9pRv+QYgO3eh9+eX7mJaoAPpyYACu2X7zka6uZB4hc5CB/K
         njdFgHJN1uh+O0erV0hBZGEB4qM6RUuYKi7p4sTEpcI/yKdfoP3aE8Q2e+XO++hn9S6e
         c8rWFcQDAWs5clu+lroKzAjgC9H3+cq5aimkpCyvPgN0JmhSxhjJ+8Vq+7jrxgW0Ejte
         Lj0A==
X-Gm-Message-State: AAQBX9chtK/bVr2i1IT4hHWHA8EJeRiQ++3x/Vnb6k8SHz/WNFuwUryS
	VEjlTICzBy4UnEVUjr0MUWLKHOVodfUeSTkTZi36hA==
X-Google-Smtp-Source: AKy350Ye7jrvbmBowRwPJtvtJhUL3SLCQKNIIPngIs6AtoBBdiCVXC0qfiNo/W6uFPuCcup6AZKJyi/VNVKXKhbl/A8=
X-Received: by 2002:a6b:490b:0:b0:760:3b22:9d0 with SMTP id
 u11-20020a6b490b000000b007603b2209d0mr5636708iob.19.1682358927190; Mon, 24
 Apr 2023 10:55:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <ZEBHTw3+DcAnPc37@x1n>
 <CAJHvVchBqQ8iVHgF9cVZDusMKQM2AjtNx2z=i9ZHP2BosN4tBg@mail.gmail.com>
 <ZEBXi5tZZNxA+jRs@x1n> <CAF7b7mo68VLNp=QynfT7QKgdq=d1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>
 <ZEGuogfbtxPNUq7t@x1n> <46DD705B-3A3F-438E-A5B1-929C1E43D11F@gmail.com>
In-Reply-To: <46DD705B-3A3F-438E-A5B1-929C1E43D11F@gmail.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Mon, 24 Apr 2023 10:54:51 -0700
Message-ID: <CAF7b7mo78e2YPHU5YrhzuORdpGXCVRxXr6kSyMa+L+guW8jKGw@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
To: Nadav Amit <nadav.amit@gmail.com>
Cc: Peter Xu <peterx@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org, oliver.upton@linux.dev, 
	Sean Christopherson <seanjc@google.com>, James Houghton <jthoughton@google.com>, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, kvm <kvm@vger.kernel.org>, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 21, 2023 at 10:40=E2=80=AFAM Nadav Amit <nadav.amit@gmail.com> =
wrote:
>
> If I understand the problem correctly, it sounds as if the proper solutio=
n
> should be some kind of a range-locks. If it is too heavy or the interface=
 can
> be changed/extended to wake a single address (instead of a range),
> simpler hashed-locks can be used.

Some sort of range-based locking system does seem relevant, although I
don't see how that would necessarily speed up the delivery of faults
to UFFD readers: I'll have to think about it more.

On the KVM side though, I think there's value in merging
KVM_CAP_ABSENT_MAPPING_FAULT and allowing performance improvements to
UFFD itself proceed separately. It's likely that returning faults
directly via the vCPU threads will be faster than even an improved
UFFD, since the former approach basically removes one level of
indirection. That seems important, given the criticality of the
EPT-violation path during postcopy. Furthermore, if future performance
improvements to UFFD involve changes/restrictions to its API, then
KVM_CAP_ABSENT_MAPPING_FAULT could well be useful anyways.

Sean did mention that he wanted KVM_CAP_MEMORY_FAULT_INFO in general,
so I'm guessing (some version of) that will (eventually :) be merged
in any case.
