Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAD155C02
	for <kvmarm@lists.linux.dev>; Mon, 11 Dec 2023 22:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-5906e03a7a4so2701605eaf.1
        for <kvmarm@lists.linux.dev>; Mon, 11 Dec 2023 14:48:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702334880; x=1702939680;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k4H6aTdYE8tqOr/rhjfIkIGsF0cSzu4dWTqXBe8lHAQ=;
        b=pNXPSYFKtV+HDhQJxdsV5fFz5UPgLujWV9ArfnPfqve5eTn7O1z8XYEB5K9X4Y+CoH
         Z7Sz+Nw3BhuVZbA56VDoD0Tj5PTkMkzHO/0C2I8OeDWBj+qFGsTFmmFIBvp8jE5sVo10
         1fyKEKD11X+VAMvjHLjUJgvlDAvTYhGXQCTkya0pJmZYSPSekKsrOxz0oFVE0URoABa5
         4lZkRbDr0PccPiKhXGQiVkX+zheKuH8CV2nAiPkPqk3P4v8dDruHofe2FA/+HJTlnyom
         3on7H2Me8mvmCSuPgDaeqpQt2QpjAHUnmHAiG+GcD5yexdALzDS1wZLYj+DoFMUbzYSu
         eVFQ==
X-Gm-Message-State: AOJu0Yzde2zUs/4QC6e3mXIv+AWiztF4r8rJ4yOzYx8mpFmZjXsFM5BR
	zEXBBNygDaL6953W3EemxkbZgPx1W8kxI27YRt8=
X-Google-Smtp-Source: AGHT+IF31Mg+zAriK3Z8TrEy05W4kntJoJ4yBtpYQzWGNS2VD5tmT/nhYRq+mn0O9RBa0jUyCvS3Hi31NDsPEFoKSeU=
X-Received: by 2002:a05:6359:4114:b0:170:bfb9:fb41 with SMTP id
 kh20-20020a056359411400b00170bfb9fb41mr2885853rwc.28.1702334879711; Mon, 11
 Dec 2023 14:47:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231121192956.919380-1-oliver.upton@linux.dev>
 <20231121192956.919380-3-oliver.upton@linux.dev> <c701bf6b-0ff0-44a0-9d1d-84e8515d077c@sirena.org.uk>
 <ZWui3KxloT5tcIsJ@thinky-boi> <80ff02a5-8355-437d-b844-3de9fe182518@sirena.org.uk>
 <bec12895-38d0-46d3-8031-53c55f88f3a7@sirena.org.uk>
In-Reply-To: <bec12895-38d0-46d3-8031-53c55f88f3a7@sirena.org.uk>
From: Namhyung Kim <namhyung@kernel.org>
Date: Mon, 11 Dec 2023 14:47:48 -0800
Message-ID: <CAM9d7cirVU1sGPKT9SfmjPpFKJ2PiZ-Md52bWB=Ormbkiwvgkw@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf build: Ensure sysreg-defs Makefile respects
 output dir
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Mark Brown <broonie@kernel.org>, linux-perf-users@vger.kernel.org, 
	kvmarm@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	Marc Zyngier <maz@kernel.org>, torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Oliver,

On Mon, Dec 11, 2023 at 5:19=E2=80=AFAM Mark Brown <broonie@kernel.org> wro=
te:
>
> On Wed, Dec 06, 2023 at 01:45:56PM +0000, Mark Brown wrote:
> > On Sat, Dec 02, 2023 at 01:34:20PM -0800, Oliver Upton wrote:
> > > Thanks for the bug report. Apologies for the latency on my end, I've =
had
> > > a mountain of non-upstream stuff to wade through.
> > > On Wed, Nov 29, 2023 at 04:27:01PM +0000, Mark Brown wrote:
>
> > > > This breaks some build configurations:
>
> > > > make[5]: Entering directory '/home/broonie/git/bisect/tools/arch/ar=
m64/tools'
> > > > /home/broonie/git/bisect/tools/scripts/Makefile.include:4: *** O=3D=
../../../../tools does not exist.  Stop.
>
> > > Looks like its because $(PWD) is tools/testing/selftests/ when buildi=
ng
> > > from the top level makefile. I'll get a fix out in the next couple da=
ys
> > > after I find my Make dunce cap :)
>
> > This issue is now in Linus' tree.
>
> Any news on this, the problem remains in -rc5?

Have you found some time to work on it?

Thanks,
Namhyung
