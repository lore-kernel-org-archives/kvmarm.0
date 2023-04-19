Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C392564
	for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 16:40:57 +0000 (UTC)
Received: by mail-wm1-f44.google.com with SMTP id o29-20020a05600c511d00b003f1739de43cso1747230wms.4
        for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 09:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681922455; x=1684514455;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x7ulxf76hUCZ0akg3GoWfjVZJU9xZOvLTfQ8cLCLnXs=;
        b=lLpEcte1WFIPxs1iYDAcqsvSne5uaJCO31xK1HIHPaNFz96e11Lq9WgLL3os9eTgzE
         GI+2Dz4szYFXhOWkojooOqXvu/8eGchwq1Gr4VUN7wC6AnGt2sMD0NbUCpMPz8vOymqX
         bX4zUie+ggg6sMHO3VCb1tZMZV6Hv66E7rYh2CIsAiIIxu32uBbLkH/ZZAABdQokaxbX
         zzSDAWAYMi3002Ua2FIkWE8zoY7c58nXtCDNW+UhDZM50J8av4F2swhStMjr44K0Ewdu
         6xSfKSBLzBow3J7OWjoEDPLhz/cmBPOnh9qGf5lBktHyhCxnRadV634p6FS/QfFDumH5
         0qvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681922455; x=1684514455;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x7ulxf76hUCZ0akg3GoWfjVZJU9xZOvLTfQ8cLCLnXs=;
        b=lTIUgiC2NvWFWbmQWq2aRn4Gvl1sK2FTvEUlqL+6kPlh10Isg0/7AtUU7/DacovQGZ
         eRjGyu/rM2KB0GVS8AXdljpJuVbI4tfXwKUZkTAwobNB0KpqnvdWCCpIO0LH4XYw9JIm
         UGAr7Yp4ynRWWKFfw53ler8rWqNZWn/qEMxMtl46VhKoxSrzgQTJpjFTlpSiWTNPi40m
         PQE3H7ALjPzcj0MociKeg1pfg2jHwW/pLOlaajw7QbszMGKjwlqznal6B0V0A+0cKZIs
         /4OlVtm+ZkBXW6f8AMamtJf3Lv51ITZ9gfA/CaRLx4stUEieWrrlxOmSU2q5PaAdPPYt
         bYWA==
X-Gm-Message-State: AAQBX9fvLleqHYgH8ZCDP3oJ9aPdMtAlnAFJ+OBVB2sjiy9SnBARlu0p
	aoFNqUX17vyGlGZnX7kdXY0xLRHWsJ44/nBMibfGBA==
X-Google-Smtp-Source: AKy350Y36y/mjjnrbKOpnXE3uN4J7+Aex1emSDVNVOsx9QcPt8EaxobZWA9Pka67YsWN6T+kDsEPZwmOOkXh2+I1FBg=
X-Received: by 2002:a7b:cbd3:0:b0:3f0:9a3f:c8b6 with SMTP id
 n19-20020a7bcbd3000000b003f09a3fc8b6mr17580825wmi.2.1681922455207; Wed, 19
 Apr 2023 09:40:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-23-amoorthy@google.com>
 <7db5a448-f3b2-2c43-1cf1-d7e75e8d06e1@gmail.com>
In-Reply-To: <7db5a448-f3b2-2c43-1cf1-d7e75e8d06e1@gmail.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 19 Apr 2023 09:40:18 -0700
Message-ID: <CAF7b7mpmodkW=vmsNxGRy_bdwFSqMPfnEnG-iKdF4VyawMCNpw@mail.gmail.com>
Subject: Re: [PATCH v3 22/22] KVM: selftests: Handle memory fault exits in demand_paging_test
To: Hoo Robert <robert.hoo.linux@gmail.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	seanjc@google.com, jthoughton@google.com, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 19, 2023 at 7:10=E2=80=AFAM Hoo Robert <robert.hoo.linux@gmail.=
com> wrote:
>
> There are quite a few strange line breaks/indentations across this
> patch set, editor's issue?:-)

A combination of editor issues and inconsistency on my part I think,
that's been a bit of a theme :/ Thanks for pointing out so many
places, I'll figure out what's going wrong (and also look at your
non-style related feedback as well :)
