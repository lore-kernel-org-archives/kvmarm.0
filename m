Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FC119902
	for <kvmarm@lists.linux.dev>; Tue,  9 May 2023 20:52:42 +0000 (UTC)
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-43469a7946eso2064684137.1
        for <kvmarm@lists.linux.dev>; Tue, 09 May 2023 13:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683665562; x=1686257562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pGveV70EhrzKH5NDozv/FlcoyfGp++y/44scfhvFNg0=;
        b=0SqxAEK0XdnZAczBffvk1TxFVJPTdh1aF5zmNNIENV/JKvz9tKYLF5+NLg+ToFFd0j
         9c03pOSmvAKmljF3G00DKyhloj4IQ17Wz+JhVmuDha3YWaHiCnwCsynUaHNQWX7h054J
         bC0YsIK0Y7WFF+8fJwucs+09uJnV66ZS8f8ClHC99BAFxGsPhHszNPGt0ozVmxq7OODd
         TpIhv0S9m6AToIKqD9zqOcTFAqZmChclKzcZUi9GmZ9GVtUuFIQWW/Wj0qA6WjWGjhUZ
         xzIVn/qsxi+dH7GFtx32f7eI2l5cNTPnSwhUQTyLFRSWV7NtMys1LzW4dKjaJ07C5PtP
         Sprw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683665562; x=1686257562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pGveV70EhrzKH5NDozv/FlcoyfGp++y/44scfhvFNg0=;
        b=ZNAjzhtr7SaJcJq8WCzk8bmYjjRBmPOdCNEs1iX7Vuh4iAruaAE5ZaWYmEffs8h0H3
         evuw7GBlcKQ+vge2qVVk+QjwjVCVMjRuXygLnn4z5zdac1msZtnc+nS/RiPmG6V8Qsvk
         GLVwt69wR7A/M4i7fNsU/RNuBtcKFmt1FPa3iHuPyX4uMAzdpiKfoG+9eKGbNz6mt5vR
         wCXDC6FQj1uCDwMgdXp5BFm9ST2Fo1lBK+3/2Lqx+Xp+OPfRAiFseUPMhybN0g3B7NJq
         Qq+aHFM1wH48QivJ2ENs5D8zwOdi/z6FN79SHlHMiBGljkSL4rYGbJO+UnTQRNrpx1Qa
         GyuA==
X-Gm-Message-State: AC+VfDycECaA+fJPGXtD3N3hUlMydgGQ9At6/iVzmHcO9tx5HkNRjIS3
	mBoi4M5yrYP946lGexcy8VAFMa0HHIB7xUCp3SFoPQ==
X-Google-Smtp-Source: ACHHUZ4A9uKe5Oz5G8ou57kXdOkTSfd4mvGR419ZB3kR7LxUaQjr0JsRk5SlRXyBWxyaujTRDRo2s1AIGXCXwFrhE6w=
X-Received: by 2002:a05:6102:3656:b0:42f:f1c6:b017 with SMTP id
 s22-20020a056102365600b0042ff1c6b017mr5860042vsu.27.1683665561734; Tue, 09
 May 2023 13:52:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com>
 <CAF7b7mr-_U6vU1iOwukdmOoaT0G1ttyxD62cv=vebnQeXL3R0w@mail.gmail.com>
 <ZErahL/7DKimG+46@x1n> <CAF7b7mqaxk6w90+9+5UkEAE13vDTmBMmCO_ZdAEo6pD8_--fZA@mail.gmail.com>
 <ZFLPlRReglM/Vgfu@x1n> <ZFLRpEV09lrpJqua@x1n> <ZFLVS+UvpG5w747u@google.com>
 <ZFLyGDoXHQrN1CCD@x1n> <ZFQC5TZ9tVSvxFWt@x1n> <CAF7b7mrTGL8rLVCmsmX4dZinZHRFFB7R7kX0Wv9FZR-B-4xhhw@mail.gmail.com>
 <ZFhO9dlaFQRwaPFa@x1n>
In-Reply-To: <ZFhO9dlaFQRwaPFa@x1n>
From: Anish Moorthy <amoorthy@google.com>
Date: Tue, 9 May 2023 13:52:05 -0700
Message-ID: <CAF7b7mqPdfbzj6cOWPsg+Owysc-SOTF+6UUymd9f0Mctag=8DQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
To: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, Nadav Amit <nadav.amit@gmail.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org, 
	oliver.upton@linux.dev, James Houghton <jthoughton@google.com>, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, kvm <kvm@vger.kernel.org>, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 7, 2023 at 6:23=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> I explained why I think it could be useful to test this in my reply to
> Nadav, do you think it makes sense to you?

Ah, I actually missed your reply to Nadav: didn't realize you had sent
*two* emails.

> While OTOH if multi-uffd can scale well, then there's a chance of
> general solution as long as we can remove the single-queue
> contention over the whole guest mem.

I don't quite understand your statement here: if we pursue multi-uffd,
then it seems to me that by definition we've removed the single
queue(s) for all of guest memory, and thus the associated contention.
And we'd still have the issue of multiple vCPUs contending for a
single UFFD.

But I do share some of your curiosity about multi-uffd performance,
especially since some of my earlier numbers indicated that multi-uffd
doesn't scale linearly, even when each vCPU corresponds to a single
UFFD.

So, I grabbed some more profiles for 32 and 64 vcpus using the following co=
mmand
./demand_paging_test -b 512M -u MINOR -s shmem -v <n> -r 1 -c <1,...,n>

The 32-vcpu config achieves a per-vcpu paging rate of 8.8k. That rate
goes down to 3.9k (!) with 64 vCPUs. I don't immediately see the issue
from the traces, but safe to say it's definitely not scaling. Since I
applied your fixes from earlier, the prefaulting isn't being counted
against the demand paging rate either.

32-vcpu profile:
https://drive.google.com/file/d/19ZZDxZArhSsbW_5u5VcmLT48osHlO9TG/view?usp=
=3Ddrivesdk
64-vcpu profile:
https://drive.google.com/file/d/1dyLOLVHRNdkUoFFr7gxqtoSZGn1_GqmS/view?usp=
=3Ddrivesdk

Do let me know if you need svg files instead and I'll try and figure that o=
ut.
