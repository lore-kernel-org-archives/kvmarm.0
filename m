Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF664125A1
	for <kvmarm@lists.linux.dev>; Mon, 18 Dec 2023 09:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="txVZIW3r"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-67f4a160dbbso2272976d6.0
        for <kvmarm@lists.linux.dev>; Mon, 18 Dec 2023 01:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702891033; x=1703495833; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0jJSYWooez4J2+P5GagANS2rc1qO6OZPVl70gjiCG4Y=;
        b=txVZIW3rxtb+Jo/V6WpNCDmts9BPMmmY7SSkJ0oJTTH3m+5odf67RNf19f4GvlUpog
         hRG0UJy+rOLssMhIS03jS3DdvsCOvsHrQKoIhWV1IAMSk16fV5CBbrcd+9BSVATC49qg
         0eyBQum2xjvkAsyAw8+T+4VyKApREOoUKa8LHuq3Ltows3ZpnpmGUIaR279qRTyhgMpb
         UUpKqhkpxTJhROAw7h9ucKNqcY3hP1t1xoHU0dJx8ih2fdAXGnnyy2bHJTgUG/LGkS8X
         MvCD2kFYBqXZNNY67GYUEP32e3SQ035jlVcGk+D1POk1i/CSjplDprPT5COnxcgHJKNn
         tdcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702891033; x=1703495833;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0jJSYWooez4J2+P5GagANS2rc1qO6OZPVl70gjiCG4Y=;
        b=PaPMkmMnZ4Kza7wSFH9Fbk66Ko2G2BbD5HYbHZGxKp584c9LVN58KyYTSsr+LRVdTb
         PenfuzdB1lZy1eugGQDx+Vc6FISDy6CksTNJh8jKWMG6mM5c9A40tmV53Zy3GediM5k4
         RnKIFz5vF+XWRntRmDV8lI6jxceZDhpczc4h9LYD9U8b19Ih16Tq0P20C04gtQqIZp1S
         0M7PQswOsXDSnTqFxqjMKy+yKGw9ApXsJ9B1MRmc8WkU6jtWNAn3y2jQKR9V+5nr3uom
         j91imZN1ucGi9nqMcETV2hJ/93DiruRiUI63nhhuG2qzS6OVJD5MhxKomJQw+qRJxOdJ
         OfoQ==
X-Gm-Message-State: AOJu0YykHHB73zv1cpTORroLi9gGUa3yl0BCP4CM9DZMJrhJ7cOk7Bol
	xA/YNeI8owDlwo9VAQ6gVMAyjO8khHTqi4aVpUGRpg==
X-Google-Smtp-Source: AGHT+IERIJJFPCIOEuvkzdpCRpTtxQjJv3YrlNmDwlhxBU6nHtTpADvmfEhz5SJfvsJgughpEXKCv/7O1XOp/BprY6A=
X-Received: by 2002:ad4:4708:0:b0:67a:95dd:f66f with SMTP id
 qb8-20020ad44708000000b0067a95ddf66fmr16845327qvb.55.1702891033594; Mon, 18
 Dec 2023 01:17:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231214100158.2305400-1-tabba@google.com> <20231214100158.2305400-14-tabba@google.com>
 <86y1drangj.wl-maz@kernel.org>
In-Reply-To: <86y1drangj.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 18 Dec 2023 09:16:36 +0000
Message-ID: <CA+EHjTyxKA5hhCWg4nsT_D=Lu-MKzB4+M4QzvBQFO7DPrghNGg@mail.gmail.com>
Subject: Re: [PATCH v3 13/17] KVM: arm64: Define FGT nMASK bits relative to
 other fields
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, oliver.upton@linux.dev, broonie@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, joey.gouly@arm.com, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 18, 2023 at 9:07=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Thu, 14 Dec 2023 10:01:53 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Now that RES0 and MASK have full coverage, no speed to manually
> > encode nMASK. Calculate it relative to the other fields.
>
> s/speed/need/ ?

I might have been in a hurry when I wrote this ;)
/fuad

>         M.
>
> --
> Without deviation from the norm, progress is not possible.
