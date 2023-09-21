Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD88C9CA57
	for <kvmarm@lists.linux.dev>; Thu, 21 Sep 2023 22:25:23 +0000 (UTC)
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7740d57e9f3so57880485a.3
        for <kvmarm@lists.linux.dev>; Thu, 21 Sep 2023 15:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695335122; x=1695939922; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=w2WooG+QkTpfUqojwok2CEiVMWZpsqmSjm3ZHCN+V1E=;
        b=kML8YbdfpLzbKUfu68rP+F0CaHS0uea8T+tS3t5uOC1JKeM3afYUxNBOyRA61kkXpf
         T3/YVUr6E86TJ7UJJzvR5Yfb+xq8Jq5OjaG6TSFxdkOZ3dxZzCAEoh8ZoGCzE9TP/D7g
         2iqAdY0Xqq9FkppxPQ9z1UY8w0z01/pgIJtuG0mp+ybhIM3c6ophRGjCaos7klKe+kQq
         RBs4UnvTj7gzjvGyFQSd1OE6Ylb6wWnDmD2cwM67tQIiFqiguNsStS9DyiIDNzf14qGZ
         /dFqOOdEE58QUqaY7oDQG4UJoEYKtqhEHwHDVnHGcHy89vwa5x1Po/QUw72OEG9jQCeL
         dfZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695335122; x=1695939922;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w2WooG+QkTpfUqojwok2CEiVMWZpsqmSjm3ZHCN+V1E=;
        b=M+4JMR/Kk5ef7RXnJ8TnqqRGSvIW6NqEAsml12VJDtsNUj5RK2y2L7xJJ1HgXpvCZL
         skBVZAJgKjQvHdWtheM1zO3Wv6SjERnf7tWSVhgbyh9GPguDPrphmaSRl3gduN2j4K1O
         AvymF+VJoqbNlmZHm7pUAdvfLdnPsjC9MmqOfKBnpWU6ymLbtvWAs3YMYnQPTaBlPAMH
         wcN4ezlV4AuwlyJwTjsSuTF1LGqqJ29L5DrQcCLTht8fkf1GtgTdivmGgLXBo+ZbSc9x
         YNh38NKcNc0mLcfAsfc5iO7Cfhq08bBpIvRSMeGNVRdKsNLHI3lCa696RMnt8D1suMEb
         9ikA==
X-Gm-Message-State: AOJu0YwS+2CF6mFFLtod9IGsLQdQe6+o3Ey2llD/IMkOwalVhrOpTsIl
	D5yNPID2D3yCuMm7b8nBFvs=
X-Google-Smtp-Source: AGHT+IFF0Fxu8IrAYMqbYE9O+JZeHJhGWgzy2cxwLDKKEWylEYlzdyNJ+FOguWr32UjLJJaA5m+Wew==
X-Received: by 2002:a0c:e106:0:b0:651:6968:ae40 with SMTP id w6-20020a0ce106000000b006516968ae40mr6418148qvk.20.1695335122511;
        Thu, 21 Sep 2023 15:25:22 -0700 (PDT)
Received: from freeip.amazon.com ([205.251.233.111])
        by smtp.googlemail.com with ESMTPSA id v7-20020a0ce1c7000000b00655d55117f5sm924928qvl.81.2023.09.21.15.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 15:25:21 -0700 (PDT)
Message-ID: <2031eecaa417d4f6021717dcbbba133d784add72.camel@gmail.com>
Subject: Re: [PATCH stable 6.1.y 2/2] KVM: arm64: Prevent unconditional
 donation of unmapped regions from the host
From: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org, james.morse@arm.com, alexandru.elisei@arm.com, 
	suzuki.poulose@arm.com, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>, Quentin Perret
	 <qperret@google.com>
Date: Thu, 21 Sep 2023 15:25:19 -0700
In-Reply-To: <877cok3skn.wl-maz@kernel.org>
References: <20230920192729.694309-1-surajjs@amazon.com>
	 <20230920192729.694309-2-surajjs@amazon.com> <877cok3skn.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2023-09-21 at 08:15 +0100, Marc Zyngier wrote:
> On Wed, 20 Sep 2023 20:27:29 +0100,
> Suraj Jitindar Singh <surajjs@amazon.com> wrote:
> >=20
> > From: Will Deacon <will@kernel.org>
> >=20
> > commit 09cce60bddd6461a93a5bf434265a47827d1bc6f upstream.
> >=20
> > Since host stage-2 mappings are created lazily, we cannot rely
> > solely on
> > the pte in order to recover the target physical address when
> > checking a
> > host-initiated memory transition as this permits donation of
> > unmapped
> > regions corresponding to MMIO or "no-map" memory.
> >=20
> > Instead of inspecting the pte, move the addr_is_allowed_memory()
> > check
> > into the host callback function where it is passed the physical
> > address
> > directly from the walker.
> >=20
> > Cc: Quentin Perret <qperret@google.com>
> > Fixes: e82edcc75c4e ("KVM: arm64: Implement do_share() helper for
> > sharing memory")
> > Signed-off-by: Will Deacon <will@kernel.org>
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Link:
> > https://lore.kernel.org/r/20230518095844.1178-1-will@kernel.org
> > [ bp: s/ctx->addr/addr in __check_page_state_visitor due to missing
> > commit
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "KVM: arm64: Combine visitor arguments i=
nto a context
> > structure"
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 in stable.
> > ]
>=20
> Same question.

Noting what changes were made to the patch from the upstream mainline
version when it was applied to the stable tree.

>=20
> > Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
>=20
> Again, I find this backport pretty pointless. What is the rationale
> for it?

The 2 patches were backported to address CVE-2023-21264.
This one addresses the CVE.

Thanks

>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0M.
>=20

