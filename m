Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347654F8AD
	for <kvmarm@lists.linux.dev>; Fri, 17 Nov 2023 21:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Nnw5q/ju"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-545557de8e6so4059a12.0
        for <kvmarm@lists.linux.dev>; Fri, 17 Nov 2023 13:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1700257381; x=1700862181; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ujYjA2fMuJosPo3loLcixIlShBqonBBw0jOYoqTUEbI=;
        b=Nnw5q/juaeu3DS2rqR7uL7/SciC0QSvebDmaCNLda3p0bD3u2SnkfYdbtbQQClQPyq
         5ylIeoPXGT4Ji7IcFSoUxEUQFd3TxcPxNGUPkS6/HVOKHMrfPLQB8bg3R6A+H32/JptZ
         5ogucOkLsoQhLexc/vmGf8eOOnQaMQnHtswCOxzpbWwAEZdQNV/PwzbNYBzOqe6xNOAM
         1Qz/ah/ynt7QXnLlJcBpcDjt6H/an9PwX6E1MVWU1ci03SJG9KAToDC4guxiRZRLUJaA
         BKb9z3AMTDzn+QQTJ6qUJ1RVJmKUcF49lqvgIkq3yh8trtxtrEaaUUoFdh6AT2cNWG8N
         dpxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700257381; x=1700862181;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ujYjA2fMuJosPo3loLcixIlShBqonBBw0jOYoqTUEbI=;
        b=TZI9pBHYOVSvYEq61fUeBNNfAxEYUXTuzrWoNBzBftbR+DXgzVG5W84ZS6JuwHK2Lo
         68ArOSGYuY/3E4hCq9Whdbzeq1o8j78MIsxFYyxVZY3HscDB2exivOb5eq5UuYjKWKh2
         4gyjGfNC9xzJ4IeYztYV/Ju6cobmbffb1CSJ0VprDndWFh+j8G2UK76PZ+LMH70udEcd
         tcwbfYGUrdpFh8ZYTWtfTzYzKGJL2QqyHU1UPlN7WCO+D+8CVSrUV02G+VbroCSoh08j
         8aHl4K5CxxZIW/6zuWsi4XhSR7JifJGLIuV9Jp0/IUkG++ZCIwMA3kt10ufpKVkmxXNX
         pmcA==
X-Gm-Message-State: AOJu0Ywc3EhTY/QKxrVLthKIpWJUlLmk/LbnOoMVhyH3zSqh9Tpucdct
	YUNPICZUy1GWm22hmiM5WwAWOPXvqqL4sWkVfzgF5w==
X-Google-Smtp-Source: AGHT+IFzo4owGzdKo8rsXvYDeRW/CQLhY7R8K7FADyBpLoJaOtqZgCWDwniibGxYqIp45hkQ1/AU39ZCwnDLjjBxymM=
X-Received: by 2002:a05:6402:1492:b0:547:9b49:f221 with SMTP id
 e18-20020a056402149200b005479b49f221mr225727edv.6.1700257381255; Fri, 17 Nov
 2023 13:43:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
 <20231011195740.3349631-3-oliver.upton@linux.dev> <CAM9d7cjxkAmEc=g0jWBPQ9d6GYmfdZSKjqi5v0UsoPvkQy-fSw@mail.gmail.com>
 <ZS/n5dqo6dZE40HE@kernel.org> <CAP-5=fWcrQqZz5vTEd_YHBcZ8rGF4Shj=QpZ9mTLDnXbwwLZmw@mail.gmail.com>
In-Reply-To: <CAP-5=fWcrQqZz5vTEd_YHBcZ8rGF4Shj=QpZ9mTLDnXbwwLZmw@mail.gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Fri, 17 Nov 2023 13:42:49 -0800
Message-ID: <CAP-5=fXxiOJMVqaH1JPU_K6+1GhaEgVeR7YyN+F0r7qTE8DGEw@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] perf build: Generate arm64's sysreg-defs.h and add
 to include path
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-perf-users@vger.kernel.org, Mark Brown <broonie@kernel.org>, 
	Jing Zhang <jingzhangos@google.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, James Morse <james.morse@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 6, 2023 at 10:10=E2=80=AFPM Ian Rogers <irogers@google.com> wro=
te:
>
> On Wed, Oct 18, 2023 at 7:12=E2=80=AFAM Arnaldo Carvalho de Melo
> <acme@kernel.org> wrote:
> >
> > Em Tue, Oct 17, 2023 at 03:23:40PM -0700, Namhyung Kim escreveu:
> > > Hello,
> > >
> > > On Wed, Oct 11, 2023 at 12:58=E2=80=AFPM Oliver Upton <oliver.upton@l=
inux.dev> wrote:
> > > >
> > > > Start generating sysreg-defs.h in anticipation of updating sysreg.h=
 to a
> > > > version that needs the generated output.
> > > >
> > > > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > >
> > > It seems we also need this on non-ARM archs to process ARM SPE data.
> > >
> > > Acked-by: Namhyung Kim <namhyung@kernel.org>
> >
> > When building with CORESIGHT=3D1, yes.
> >
> > I have it in my tests and:
> >
> > =E2=AC=A2[acme@toolbox perf-tools-next]$ ls -la /tmp/build/perf-tools-n=
ext/util/arm-spe.o
> > -rw-r--r--. 1 acme acme 135432 Oct 17 16:49 /tmp/build/perf-tools-next/=
util/arm-spe.o
> > =E2=AC=A2[acme@toolbox perf-tools-next]$ ldd /tmp/build/perf-tools-next=
/perf | grep csd
> >         libopencsd_c_api.so.1 =3D> /lib64/libopencsd_c_api.so.1 (0x0000=
7f36bfca5000)
> >         libopencsd.so.1 =3D> /lib64/libopencsd.so.1 (0x00007f36be2e0000=
)
> > =E2=AC=A2[acme@toolbox perf-tools-next]$ rpm -qf /lib64/libopencsd.so.1
> > opencsd-1.3.3-1.fc38.x86_64
> > =E2=AC=A2[acme@toolbox perf-tools-next]$ rpm -q --qf "%{summary}\n" ope=
ncsd
> > An open source CoreSight(tm) Trace Decode library
> > =E2=AC=A2[acme@toolbox perf-tools-next]$
> >
> > Well, double checked and arm-spe.o is built by default, only way to
> > disable it is using NO_AUXTRACE=3D1 in the make command line, but then
> > IIRC one needs linking with opencsd to decode all those traces, right?
> >
> > Anyway:
> >
> > Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> >
> > - Arnaldo
> >
> > > Thanks,
> > > Namhyung
> > >
> > >
> > > > ---
> > > >  tools/perf/Makefile.perf | 15 +++++++++++++--
> > > >  tools/perf/util/Build    |  2 +-
> > > >  2 files changed, 14 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> > > > index 37af6df7b978..14dedd11a1f5 100644
> > > > --- a/tools/perf/Makefile.perf
> > > > +++ b/tools/perf/Makefile.perf
> > > > @@ -443,6 +443,15 @@ drm_ioctl_tbl :=3D $(srctree)/tools/perf/trace=
/beauty/drm_ioctl.sh
> > > >  # Create output directory if not already present
> > > >  _dummy :=3D $(shell [ -d '$(beauty_ioctl_outdir)' ] || mkdir -p '$=
(beauty_ioctl_outdir)')
> > > >
> > > > +arm64_gen_sysreg_dir :=3D $(srctree)/tools/arch/arm64/tools
> > > > +
> > > > +arm64-sysreg-defs: FORCE
> > > > +       $(Q)$(MAKE) -C $(arm64_gen_sysreg_dir)
>
> Should this not build an install_headers target? The generated code is
> going into the source tree as is, ignoring O=3D options to make.

I think on top of this, tools/perf/MANIFEST needs to have:
arch/arm64/tools/gen-sysreg.awk
arch/arm64/tools/sysreg
This will add these files to the release tar balls, it already
contains things like scripts/bpf_doc.py.
tools/arch/arm64/tools/Makefile is picked up by tools/arch being in
the MANIFEST.

Thanks,
Ian
