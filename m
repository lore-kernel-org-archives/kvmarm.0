Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC76200CA
	for <kvmarm@lists.linux.dev>; Wed, 22 Nov 2023 20:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aPJ5gIcc"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-50aa698b384so861e87.0
        for <kvmarm@lists.linux.dev>; Wed, 22 Nov 2023 12:36:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1700685388; x=1701290188; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kR4sLw90jB12SVs/JReLRRIAKLV6ovCULQumS/HywIo=;
        b=aPJ5gIccCVhDWF1vDq4orBiuqh5wcmqy03C02jGbfysqCZQcmb8u+Y4cXst4yrj0ic
         bMPz2XxY7zkDxsB5drfSO5+b9zMfIGOrba8Ur19e8YWidC1R1HTf0Nt+lqhVqZIm8Gll
         L5+z312A0cPYnXaYEOY66bm+vC+EA0rkfXHdWiwAZIU5/OCelGDJXS+DxmittzEWA+5/
         kRQ3Tm8vDz0OxyPxcKfpmOWR9RkIR6pX23tfgMzfIryiOjP7YWbWUW/XD5CTeXdaskVy
         5JwmCCiPPDG03ikreZSnE46WSHeNP4SK6j0bYCd00iqvCG7WsGs+dMdUxaOcRDyaEtra
         8xoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700685388; x=1701290188;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kR4sLw90jB12SVs/JReLRRIAKLV6ovCULQumS/HywIo=;
        b=W8r5rFUHq7kyKpPxRcmytrRzLYmo1bN/dUAx459ivJ7uomjTumxYF/Fj8BB5f7pbEx
         QlNpB5VCAsIZ01CCxTAhBPUPhiKfWjX846c2/OSEQOhSjov6NY9Kcb9SovnjGUD6cues
         ZBktHgnEh7+S8Cjc5wxAutyIF+dbwKGdCAYRa73TtLwLk2atgHbav9FNFOXj/CWHDyWb
         4tSmVvkQc85otctzrTKoXgS7R+YOy2qKv/lhtQUKxfgtYa9Gg3z3XRWCjmRRYAVA/CI9
         7EL3rkwtllbsD0NP2gQdYGbBjNlLnZ62xWNVhV0PZrXzKyZhKImlNX21vXLIpKuGt3yi
         +EPw==
X-Gm-Message-State: AOJu0Yzi/u/pZRXO0HMHr2+lZDmhaMeCsnao7qS18Wsp+ZVXHGjpS0yn
	HRvDfzpP7mrw8KoeaYrmxyIBuJTx1CWpJWMzy9zo7A==
X-Google-Smtp-Source: AGHT+IH32WEfT+14LMY74Y2LUjqrzFffVQ9DiIpbxOANbwCDQlxmcKw7nqP4W+anXj5b6r+AmwoFKvQ+hO6ZTs6Gqq8=
X-Received: by 2002:a19:ad43:0:b0:504:7b50:ec9a with SMTP id
 s3-20020a19ad43000000b005047b50ec9amr99424lfd.1.1700685387341; Wed, 22 Nov
 2023 12:36:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231121192956.919380-1-oliver.upton@linux.dev>
In-Reply-To: <20231121192956.919380-1-oliver.upton@linux.dev>
From: Ian Rogers <irogers@google.com>
Date: Wed, 22 Nov 2023 12:36:12 -0800
Message-ID: <CAP-5=fU3MdtsayuvLja-_-Sc11+SivPXENMhztwPA6bMugdLSA@mail.gmail.com>
Subject: Re: [PATCH 0/2] perf build: Fixes for arm64 sysreg-defs build rules
To: Oliver Upton <oliver.upton@linux.dev>
Cc: linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 21, 2023 at 11:30=E2=80=AFAM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> Small series to address the issues Ian raised in [*]. Tested with
> perf-targz-src-pkg and building arm64 KVM selftests.
>
> [*] https://lore.kernel.org/linux-perf-users/CAP-5=3DfXxiOJMVqaH1JPU_K6+1=
GhaEgVeR7YyN+F0r7qTE8DGEw@mail.gmail.com/
>
> Oliver Upton (2):
>   tools perf: Add arm64 sysreg files to MANIFEST
>   perf build: Ensure sysreg-defs Makefile respects output dir

Sorry for missing these, scripts/get_maintainer.pl will recommend
linux-kernel@vger.kernel.org so this didn't show in my review pile due
to my email filters.

Tested-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

>  tools/arch/arm64/tools/Makefile      |  2 +-
>  tools/perf/MANIFEST                  |  2 ++
>  tools/perf/Makefile.perf             | 24 +++++++++++++++---------
>  tools/perf/util/Build                |  2 +-
>  tools/testing/selftests/kvm/Makefile |  5 +++--
>  5 files changed, 22 insertions(+), 13 deletions(-)
>
>
> base-commit: b85ea95d086471afb4ad062012a4d73cd328fa86
> --
> 2.43.0.rc1.413.gea7ed67945-goog
>
