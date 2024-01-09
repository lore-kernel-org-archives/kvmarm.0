Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27FF3A8C6
	for <kvmarm@lists.linux.dev>; Tue,  9 Jan 2024 16:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x39xsYMK"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2cca5d81826so41703941fa.2
        for <kvmarm@lists.linux.dev>; Tue, 09 Jan 2024 08:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704817419; x=1705422219; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wsg7zMm5Fdy1jA8s3lcgjoxedub8Q57T3G6fYjwRVq8=;
        b=x39xsYMKAKM6M6ctNygCs1xsIHtso0sAHAIq05nokNjmRXLWBgfsv3+nFgk6o53AyT
         RNMlWF/dUmyYBHtbE9ZYz+pYMgH2T0mlR5JSE8IQHbKlJM3UQsg9fcTDQpJ5hFVTCFiN
         UiwCYtDjnT7rzZdlCY+0lANP0EpP+9vc6IeU18ewyct2zi9m3eRr6JFj0jP7pCdGp21Y
         EHjZzjo3dy6OVWWVxu5ydJ78mMrlgb0DVWf264ZGi1u3YwRq5Hk6y2vmW6dk3coO2oZp
         PxJQgRpYUymUCxMeJ9fuQ9bFLKVkJSOsmMHsqlExbbG/wln7g7R1kk2JH3oeILmx+9zI
         qm5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704817419; x=1705422219;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wsg7zMm5Fdy1jA8s3lcgjoxedub8Q57T3G6fYjwRVq8=;
        b=RYcIbjZ8vAJFrHLtuDoAgCKduttudeT+y9DBe9hKaNtCA3SLTnudm2Fe8gLtTgvb8O
         MHtrXYBqdDDAv4LZKgnH/aXF23pt0O0c0Kd+G2oLq5JR7wXgW6/M4hugo1TjEb3x/Qyv
         5860JWrXXZSWL/g35IRDa1RJlf+eU5jEUYR/NtpsNaf601zEN9UVwmo7VbyYLpFF9/iU
         gC92gjbRqPPqCjDJRYimCX3Upn4UgC1gNDanucOli9S9rIjcK99d8VqgrUSg1wH5Nn6m
         8nBmGvFYm9m2maxLXZOpGqtFh3rZM0f2bol83Fmz2cSDAOgbzLslLykaCcE/GU6VVSi7
         SCCQ==
X-Gm-Message-State: AOJu0YxcP91+ycPLdsH72mTUxRQb+qTmrdy7lHofpCjSHwQQbFjEK1NE
	wkQJjCmwBz0so+YxzzY19SlUE0RZlIusmqwxqwmurreeRwRi
X-Google-Smtp-Source: AGHT+IENINkHdScslGoH1+e94F8Ik5C9aYB8w1MwoOyMisInkBOG5KStveZ4xiPiBsZa81JjQmBLru7M1qN9QTUClhM=
X-Received: by 2002:a2e:b712:0:b0:2cc:788a:3d4d with SMTP id
 j18-20020a2eb712000000b002cc788a3d4dmr2530358ljo.51.1704817418515; Tue, 09
 Jan 2024 08:23:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
 <20231011195740.3349631-6-oliver.upton@linux.dev> <e0facec9-8c50-10cb-fd02-1214f9a49571@redhat.com>
 <ab1337bc-d4a2-0afc-3e26-0d50dff4ea73@huawei.com> <ZZx5y_iy9kXg47SW@linux.dev>
 <CAAdAUtie4GFKAPhk4wDWnEmSOzWF+X-6eHwS79169JRv_=hKdg@mail.gmail.com> <c90a3fb4-62b7-5642-433a-b0cfb41d6992@linux.dev>
In-Reply-To: <c90a3fb4-62b7-5642-433a-b0cfb41d6992@linux.dev>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 9 Jan 2024 08:23:26 -0800
Message-ID: <CAAdAUthgbQ5i8gatF0daa6RPRUtQ79cU3renpBrjkHwroziA9w@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] KVM: arm64: selftests: Test for setting ID
 register from usersapce
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
	Eric Auger <eauger@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
	Mark Brown <broonie@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	James Morse <james.morse@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks Zenghui.

On Tue, Jan 9, 2024 at 7:37=E2=80=AFAM Zenghui Yu <zenghui.yu@linux.dev> wr=
ote:
>
> On 2024/1/9 09:31, Jing Zhang wrote:
> > Hi Zenghui,
> >
> > I don't have a Cortex A72 to fully verify the fix. Could you help
> > verify the following change?
>
> It works for me (after fixing a compilation error locally ;-) ), thanks!
>
> Zenghui

Jing
