Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C7D199EF
	for <kvmarm@lists.linux.dev>; Thu, 20 Jul 2023 08:42:44 +0000 (UTC)
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-635e107642fso2537006d6.1
        for <kvmarm@lists.linux.dev>; Thu, 20 Jul 2023 01:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689842563; x=1690447363;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pWx7QFz1K/WRJqEHJXfuBLFpInCo7G0KjVdDqgKixaM=;
        b=zO1yD2j8x09N4ZZ/FY0/P9m3J/t2KaHQ1GY/k8fFhwdwVR330YyhetNA7PWHh9oIYN
         CxYjzLB8OaPH/1bBoQz3CegfinSg8YLItjX/qKvO9K6HhD+I9T1MNnV+EdOfKE0mmndf
         IC8JkkBJrP51hCfhg+qu0Y2Rtb6F+VtfUdfCmSrILxZkRoZk2qiXI1TONZeqJhZ6+w85
         iYTGLDrkempUSfqxAkRZufJkCQluTQq/Up/8r0PsTwzBzZassz41k0rdeEEqFlKJFAma
         RGozFAW4g/EVx5dOMcTu+EM9FHdgeQUqTweMbirloKQ8iDNEAg2qTL83DgmODJ7rmhWv
         yVVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689842563; x=1690447363;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pWx7QFz1K/WRJqEHJXfuBLFpInCo7G0KjVdDqgKixaM=;
        b=Ct4zWH0xtKBfkjU7rLhz0P8SvGYbz7XPGu/ovBs2MdGE+3qtdv3YoqZq/eZgn/9xy2
         +db9+oZTPkIevJaolPm5ZCFgxRntljqisIbCKNwiMLlGbAg/h5DKteTjP2KFYvB5C68V
         d5sZsHE6RAX+rtSqf1JJgEmQDaDVfzb7uk1AMH4cmCBeF6xn8zMHQzNbIgiK6kgDKWAZ
         b8YTMFtcZ6ISk0as/q8gU2dhUxlvg5QQeKfRztdygfPte+kJqXv4F0iyunOs+tGopOSr
         ZuQ6g8lptWiHB4QG8GxXDXjOQKMw4ztggNsxNjNJoA2c1sbP1CwO2pDgM4G8zEPWI63H
         6cYQ==
X-Gm-Message-State: ABy/qLarK0eEOzCOsZZ1zM/JGAOFYKVx64nQWqfngK4fqtFTssVpTDvQ
	EVeEoP/dnhBd+8oO3ajfqVWuB21vi6pC/wqnPpq7zw==
X-Google-Smtp-Source: APBJJlE97Hy61kBiG4YCBfH7SBPT4Bob8UxajGKcpLbyB3mY/PWmqOpCQPybG4RbpZENVuO/3Mog2SNASQE6km5dk2I=
X-Received: by 2002:a0c:e4cd:0:b0:635:899:946f with SMTP id
 g13-20020a0ce4cd000000b006350899946fmr5318530qvm.17.1689842563410; Thu, 20
 Jul 2023 01:42:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230719150639.1968034-1-tabba@google.com> <86v8egszb2.wl-maz@kernel.org>
In-Reply-To: <86v8egszb2.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 20 Jul 2023 09:42:07 +0100
Message-ID: <CA+EHjTx5vFX6zNP-2+mKT-auvtOsCtospj7xM83kOu_wv1R5bA@mail.gmail.com>
Subject: Re: [PATCH v1 0/5] Fix setting SVE and SME traps in (h)VHE
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Wed, Jul 19, 2023 at 4:20=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Hey Fuad,
>
> Many thanks for looking into this, much appreciated. A passing comment
> below.
>
> On Wed, 19 Jul 2023 16:06:34 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > The (re)setting and disabling of SVE/SME trap handling (mostly)
> > done for the hVHE work [*] misses a couple of cases.
> >
> > This patch series ensures that these traps are disabled on setup
> > and reset. Moreover, it makes the code consistent in using
> > CPACR_EL1 or CPTR_EL2, depending on the mode.
>
> To provide context, this last point isn't really a correctness issue.
> It only ensures that:
>
> - we don't need to issue a synchronisation when alternating one or the
>   other accessor,
>
> - when running hVHE under NV, we don't trap unnecessarily on accessing
>   CPTR_EL2, while CPACR_EL1 can be used directly without any trap.

Thanks for that. I'll include this in the cover letter when I respin
to give more context.

Cheers,
/fuad
>
> I'll have a look at the actual patches shortly.
>
> Thanks again,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
