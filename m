Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21DE7464
	for <kvmarm@lists.linux.dev>; Sun, 25 Jun 2023 19:45:04 +0000 (UTC)
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-341dd309b6fso13630885ab.1
        for <kvmarm@lists.linux.dev>; Sun, 25 Jun 2023 12:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687722304; x=1690314304;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UD778V9DnbQQOIeZ16R9VPoinqYi52FwCCQW+55Zlfg=;
        b=nH/1GU6tAoZJ5TOiQyuLU9ktyEVt+6AGm7NmokBvorjStJrPO56/iNX19gld4nzsn6
         ZW62uYzB78gfffCvqXhO1huDp0UXF0Xq9ddibruZ1XGiQLG5oXVq5udjcdqh9OZOb/RG
         ZOWtOAMtf8cpWsoAoPPaRBUazUynWWEhReq4R9mNkVnJEKisAMchvHdsZ6nOdMM1rKgX
         cax65oJNsw1wDuZw0F/So6bbli7d4TseT9SPnjWr13bl9Mys8QTiuAEaiSn7uEaKst7x
         OA1mJAmQ9K6Rh1dkWd4zd03vphGJgrqe7WEGkUHUOjGomTIqpiXJO+r4Fm4JIF9VOnxV
         L0nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687722304; x=1690314304;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UD778V9DnbQQOIeZ16R9VPoinqYi52FwCCQW+55Zlfg=;
        b=B3B9M7xVk18fi4o7IK4rMFwZQsJPgI7QMub+i1/97F7FgbtV2ukQ+WellJadmJxhlO
         UyUYF4oQtLLGO0OF9PICExFXrEBZ3+g3YTt+BAGBAa+tAeQBfcWcD1u6WnVVsdF9H6Fd
         bDJzkTyPBlgPPW3duqLcAyhcnoEZ8rrg46j81X1I4vc5fGgmpt9LTgY+ouWh9ezGTorw
         uNP8AN6TbQU2CzxtCg5wyQCkXdfaXFLcPOary3yogeDTGF/oqayp9j+UvfAfi0faEh2i
         Vaw0VQBC4FrFGqwb+RjvnZv50K5Ni2jpePSO/Bk3fDNwslvVIZtfiK6nRDzCjOcfnQA0
         PNMQ==
X-Gm-Message-State: AC+VfDySROWnP31EauS//NkDAA2Fu/20ASAsQ6DN2AEiHwl+Lh/nJsVZ
	zwWaceZwuHPlBr5okbU9LfJ7fCIhoGY=
X-Google-Smtp-Source: ACHHUZ7OVVWILzkNimUL7YZMLzzTvPEiDpBLJaMNeR74K2LfQUZbPkANTfFyrSM4IL9OYnt8ITIYDA==
X-Received: by 2002:a92:d910:0:b0:343:92a1:9cf4 with SMTP id s16-20020a92d910000000b0034392a19cf4mr20250462iln.19.1687722303599;
        Sun, 25 Jun 2023 12:45:03 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id v26-20020aa7809a000000b0062cf75a9e6bsm2540730pff.131.2023.06.25.12.45.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Jun 2023 12:45:03 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [kvm-unit-tests PATCH 1/2] arm64: set sctlr_el1.SPAN
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20230617013138.1823-2-namit@vmware.com>
Date: Sun, 25 Jun 2023 12:44:51 -0700
Cc: kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <14C64FF1-A7D1-48F5-AD9C-09E8492FB5AC@gmail.com>
References: <20230617013138.1823-1-namit@vmware.com>
 <20230617013138.1823-2-namit@vmware.com>
To: Andrew Jones <andrew.jones@linux.dev>
X-Mailer: Apple Mail (2.3731.600.7)



> On Jun 16, 2023, at 6:31 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
> From: Nadav Amit <namit@vmware.com>
>=20
> Do not assume PAN is not supported or that sctlr_el1.SPAN is already =
set.
>=20
> Without setting sctlr_el1.SPAN, tests crash when they access the =
memory
> after an exception.

Andrew,

You=E2=80=99ve been kind enough to review the other patch-set and =
perhaps this
one fell through the cracks. Can you please have a look at this one
specifically and on:

https://lore.kernel.org/all/20230615003832.161134-1-namit@vmware.com/

These issues cause problem on other environments.

Thanks,
Nadav

