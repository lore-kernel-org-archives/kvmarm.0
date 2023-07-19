Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80002256A
	for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 05:45:42 +0000 (UTC)
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-676f16e0bc4so4350874b3a.0
        for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 22:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689745542; x=1690350342;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GpYVe+K4N2AVq5RLqdAWngfkcEzNRoNK/cVqRuEcyWE=;
        b=YAtGqRidGi08yabf9tSMuEEbFGiG25LVYNeqXcGeCn2r8SoQJUv6TnuTq/DZsLegHp
         YtPN0IRgQSK5zW6KgpyN8uT6raZEh0zDVdvtivi9EgiVTvkJJzG5h+7QNhM/OMHLcPXU
         EJZ0v2sqJF1WWKScLQul6nZDjnd0Wm3hSHXzhTdhtjjZYsGkbRfanQ5ga6Vipd0nXWI0
         h8+AA0XEEFnpLPr7Jn0/0KjsRHJcWA6JpyGqbMaRs8xHRhLVCUaCvWq4AThcgNPRmoS+
         lAVARz2yO8Dc+XjeFYWPocbIEezRhXkJVpPnJ4uDBOdEh+D517nViMndLSEQbWJUjXu6
         8K/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689745542; x=1690350342;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GpYVe+K4N2AVq5RLqdAWngfkcEzNRoNK/cVqRuEcyWE=;
        b=S8LyZytXOE3AhXMao12cfHyWluSi53gf68Em65kyvMDmsZQgcq5Pax1jfbIq6OZV7h
         F8YNfS1LoBstBF+pu3bhhVAYgVgdgt5A4Dur1ZZAC/R67liN+81V/TRL5NzEWp/ZcPfQ
         znPhBbNA+O0HofLlJqUsLXKkn4MPVWZ1NcRIHKyiMFXMoODeFltO1n9Feebbd6wK951l
         8q76/AACWTQubkJFusYAGVpw99/Tdz4E00WNz4/6A0lcb7OFTEXRAS38wH7PyFzRAwyB
         wpxywH/U8xI9D6h2nhpo45Zoxiwzu7rv3+bvS8thdl1vcKto59u6QYigloXu5Bb53lFW
         a06g==
X-Gm-Message-State: ABy/qLYrj076O9cRy7MxGet2fe6TM+G6thyZl4M61H4wttQzP9HBlg+F
	l8oBQcevZG2O2qGZ8xG21Lo=
X-Google-Smtp-Source: APBJJlFf/gV0F0U0nwTUNOA7IELfp3gSfQNZDOYYLyy2U6tghsZJdRLsiuWNVX2ugkmiIHOJVLU2Xg==
X-Received: by 2002:a05:6a20:394a:b0:130:9af7:bfa with SMTP id r10-20020a056a20394a00b001309af70bfamr16123327pzg.60.1689745541562;
        Tue, 18 Jul 2023 22:45:41 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id x3-20020a170902ea8300b001b895336435sm2905403plb.21.2023.07.18.22.45.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jul 2023 22:45:41 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [kvm-unit-tests PATCH v1 2/2] arm64: Define name for the bits
 used in SCTLR_EL1_RES1
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20230719031926.752931-3-shahuang@redhat.com>
Date: Tue, 18 Jul 2023 22:45:29 -0700
Cc: Andrew Jones <andrew.jones@linux.dev>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>,
 kvmarm@lists.linux.dev,
 kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <FDD82614-A542-46AA-A85B-6A437F802B6F@gmail.com>
References: <20230719031926.752931-1-shahuang@redhat.com>
 <20230719031926.752931-3-shahuang@redhat.com>
To: Shaoqin Huang <shahuang@redhat.com>
X-Mailer: Apple Mail (2.3731.600.7)



> On Jul 18, 2023, at 8:19 PM, Shaoqin Huang <shahuang@redhat.com> =
wrote:
>=20
> Currently some fields in SCTLR_EL1 don't define a name and directly =
used
> in the SCTLR_EL1_RES1, that's not good now since these fields have =
been
> functional and have a name.
>=20
> According to the ARM DDI 0487J.a, define the name related to these
> fields.
>=20
> Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>

Thanks for doing that!

While I debugged my SCTLR issue on EFI, I did try to grep =E2=80=9CSPAN", =
and this
patch would=E2=80=99ve certainly helped.


