Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2C7C950
	for <kvmarm@lists.linux.dev>; Wed,  5 Apr 2023 22:07:59 +0000 (UTC)
Received: by mail-pg1-f175.google.com with SMTP id h31so22669377pgl.6
        for <kvmarm@lists.linux.dev>; Wed, 05 Apr 2023 15:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680732479;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6G4NsFlCDV5fs2a2Hk+HPn6BW+TSo8l8fhvL/n7IKto=;
        b=Co/XH8kheGMcW5639kFQflWIBdRbseeE5Rgi33B4NHAwkIuhJ8cRjGblOk3jTnpe3M
         r8NDGd4BbIPvGUCTtlIr1C3Zi3M3kVBDoSPBmqFnbVUgJEH+rMm0xic9kbB5F1PS469K
         v1mqbc0XbrOyTEZFxU0ygPvmf+3dHmAY6CsJ9O7wnH7swCU/AVkriErypZpzAdgN2JX5
         g7RiLqySQwykhvK9Yp436hJ6RVIMG7NxCvKb3YHlnhCMdin4lAC9yBtRjNUKm8bUitaS
         sSu9j6TkAiYHkxQxzNBHO0Xb9op6XALV5XasEjMG0VTfxTM7nkVUzYMSqHE97uOdWJz9
         t2rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680732479;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6G4NsFlCDV5fs2a2Hk+HPn6BW+TSo8l8fhvL/n7IKto=;
        b=5xXs43U2wY/y3VAeTz8/c4QgOp2vUk224lSZv5YnF6DRYLedO4mN9xXqEtdy6l/1XP
         fuY4i445g3CrLz1nHxvU74JSoSoubejE5fB0CdRrIrQdJcobQansjXlG6zEJF1KMSnWo
         FnYz3ie4QChx7G0OdxHHlkEfxUrEV2QIcx6f7XN0JcXF5D9QsgPDTO9GZiw1XFxowsRC
         v+sMT9srsPqYcfy0OHhBVihowMGXyHmquEzABuz2KWcLG9s9lO5uKeqIDgBqosPSyY4j
         MmgxoWG3mNCBy3nH/BFIAyw44+RP7InDgxtnwxcHFs9TO2oloqeCQL8dU0DB+8yJk9cb
         85EA==
X-Gm-Message-State: AAQBX9dAFKMojumg6kOdf5b8rT0C5U0TjXC+bXHqFhYy9+U9aDSNvdK3
	RMfASZASU9n64pyjGFdwzaowsRKWZw8G1PkcUSP2mQ==
X-Google-Smtp-Source: AKy350YWe0LQY4a1WtMtO9UBAtN8fCXxF/yrfEr5xXDYzw+Sj0JKwU0Q2JALgP82rgc6URVJ5DF6xJk/YwaCPJm10os=
X-Received: by 2002:a05:6a00:999:b0:625:cda5:c28c with SMTP id
 u25-20020a056a00099900b00625cda5c28cmr4345578pfg.6.1680732478867; Wed, 05 Apr
 2023 15:07:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230331014356.1033759-1-davidai@google.com> <20230331014356.1033759-6-davidai@google.com>
 <CAL_JsqJErVOZZ==i1HpMABfuVEDC+drboLTntMDB0sUC9ZdQ_Q@mail.gmail.com>
In-Reply-To: <CAL_JsqJErVOZZ==i1HpMABfuVEDC+drboLTntMDB0sUC9ZdQ_Q@mail.gmail.com>
From: Saravana Kannan <saravanak@google.com>
Date: Wed, 5 Apr 2023 15:07:22 -0700
Message-ID: <CAGETcx_YhXqgyuWwH7BrMV4-z2LVEq5-X-FtPvmi-9tCrjVXVw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 5/6] dt-bindings: cpufreq: add bindings for virtual
 kvm cpufreq
To: Rob Herring <robh+dt@kernel.org>
Cc: David Dai <davidai@google.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>, kernel-team@android.com, 
	linux-pm@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 31, 2023 at 5:47=E2=80=AFAM Rob Herring <robh+dt@kernel.org> wr=
ote:
>
> On Thu, Mar 30, 2023 at 8:45=E2=80=AFPM David Dai <davidai@google.com> wr=
ote:
> >
> > Add devicetree bindings for a virtual kvm cpufreq driver.
> >
> > Co-developed-by: Saravana Kannan <saravanak@google.com>
> > Signed-off-by: Saravana Kannan <saravanak@google.com>
> > Signed-off-by: David Dai <davidai@google.com>
> > ---
> >  .../bindings/cpufreq/cpufreq-virtual-kvm.yaml | 39 +++++++++++++++++++
> >  1 file changed, 39 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/cpufreq/cpufreq-v=
irtual-kvm.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-virtual-=
kvm.yaml b/Documentation/devicetree/bindings/cpufreq/cpufreq-virtual-kvm.ya=
ml
> > new file mode 100644
> > index 000000000000..31e64558a7f1
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/cpufreq/cpufreq-virtual-kvm.yam=
l
> > @@ -0,0 +1,39 @@
> > +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/cpufreq/cpufreq-virtual-kvm.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Virtual KVM CPUFreq
> > +
> > +maintainers:
> > +  - David Dai <davidai@google.com>
> > +
> > +description: |
> > +
> > +  KVM CPUFreq is a virtualized driver in guest kernels that sends util=
ization
> > +  of its vCPUs as a hint to the host. The host uses hint to schedule v=
CPU
> > +  threads and select CPU frequency. It enables accurate Per-Entity Loa=
d
> > +  Tracking for tasks running in the guest by querying host CPU frequen=
cy
> > +  unless a virtualized FIE exists(Like AMUs).
> > +
> > +properties:
> > +  compatible:
> > +    const: virtual,kvm-cpufreq
> > +
> > +required:
> > +  - compatible
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    {
> > +      #address-cells =3D <2>;
> > +      #size-cells =3D <2>;
> > +
> > +      cpufreq {
> > +            compatible =3D "virtual,kvm-cpufreq";
> > +      };
>
> The same thing was tried on non-virtual h/w too. This is not a device
> so it doesn't go in DT. It is just an abuse of DT as a kernel driver
> instantiation mechanism.

Because it has no registers it's reading and writing, right? Yeah,
just went with this for now to make it easy for people to cherry pick
and test it. Maybe we shouldn't have added documentation and made this
look too official.

In the end, I'm expecting this will be a real MMIO device. Until we
move from RFC to PATCH, feel free to ignore this patch.

-Saravana
