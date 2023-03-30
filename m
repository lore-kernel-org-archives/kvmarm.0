Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F40D304
	for <kvmarm@lists.linux.dev>; Thu, 30 Mar 2023 23:37:28 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso21520426pjb.2
        for <kvmarm@lists.linux.dev>; Thu, 30 Mar 2023 16:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680219448;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2eDo3aJDVwLeCDAqSFj4/6qZNCE8g3cOEBacnGbW7bI=;
        b=pGoqpRn+ct/S38sH8FxamWuu4EFHgodhZnA86Ne+b+EusZcEX3oP1I0Y0fydMifcNb
         /O797XnqSOtMyMTliBYfarywfU/anDymn6QrgRqSr4WtrKf6cEIcFtcAZQXUH41RDQEG
         JwjyQPaU0PgpuQgaxVKrVHQIEgcjkluooP8mIW9mODu/ZMdfl4NKk+z5vbEwtXUkvCE0
         hwjXeaiDDiZrrl/1mCCBn26yjFkmOb5N6NnSFHV4FiFEyegxLObz6e26W/pSEC2uL4AG
         5i4kS+T0FAL2ACo1WPPL/ulfLMKUAhbSb5ut5TVJVOkcPJsaBiks+/K7FG0lpHqaGlhX
         UwrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680219448;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2eDo3aJDVwLeCDAqSFj4/6qZNCE8g3cOEBacnGbW7bI=;
        b=6jqTlTAwmiAHRhpFPo0PBDnbviPCGZN8vMVlhjele4biMqBKI8CBgwB2KxboIuB9OT
         1b83bnwednXBRiwsoIqmY80A8Y4IUJVMlkigN1VSsiUDrw3QMFXSkVFHGr9X0oINf0ug
         7+97qwTb3rL+co4byi7DcVMKbxgVLCgMJT49zd4a6A1ndlGll85RWbD3j4lfVSAVaoEK
         QyrtUgWwv9tYN/CzgkOK3WF94oObatczrIPq+tURqstF6FlxnLHC8K0sSpCNrnuAf6jH
         E4NO0lUyxa6SVAkM5C9AVgAXTS+IutUnnogSBkMqDLJwmwC7XCyoIyJ3ZkvZ5RY25k5i
         ufJA==
X-Gm-Message-State: AAQBX9dxMq8tmxonIuMKzuuyfBSOp7EAwd6vgVdilAmQGyy2ivLrNUuz
	AkoG/2azlpTypWAP3zah6dpRzFPK2yS1p0P2QCTT6w==
X-Google-Smtp-Source: AKy350aRhbVD0HVeNG0Zc+8z0dVv4kK0sd6xAZDKd+CWn9FN2aXR2UVptE7G4oHVXkeVHOCPhRuCkhQxTInkuAFeNeE=
X-Received: by 2002:a17:902:b196:b0:19f:36ab:c34 with SMTP id
 s22-20020a170902b19600b0019f36ab0c34mr8867229plr.10.1680219448157; Thu, 30
 Mar 2023 16:37:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230330224348.1006691-1-davidai@google.com> <ZCYZRIbPh+f3v26v@linux.dev>
In-Reply-To: <ZCYZRIbPh+f3v26v@linux.dev>
From: Saravana Kannan <saravanak@google.com>
Date: Thu, 30 Mar 2023 16:36:52 -0700
Message-ID: <CAGETcx_P27-=wkAkCETTR2Q0edA01M5jArS_t-zZFn61YM9Muw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] Improve VM DVFS and task placement behavior
To: Oliver Upton <oliver.upton@linux.dev>
Cc: David Dai <davidai@google.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Rob Herring <robh+dt@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, 
	Sudeep Holla <sudeep.holla@arm.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>, kernel-team@android.com, 
	linux-pm@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 30, 2023 at 4:20=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Thu, Mar 30, 2023 at 03:43:35PM -0700, David Dai wrote:
>
> [...]
>
> > David Dai (6):
> >   sched/fair: Add util_guest for tasks
> >   kvm: arm64: Add support for get_cur_cpufreq service
> >   kvm: arm64: Add support for util_hint service
> >   kvm: arm64: Add support for get_freqtbl service
> >   dt-bindings: cpufreq: add bindings for virtual kvm cpufreq
> >   cpufreq: add kvm-cpufreq driver
>
> I only received patches 2-4 in my inbox (same goes for the mailing lists
> AFAICT). Mind sending the rest? :)

Oliver,

Sorry about that. Actually even I'm not cc'ed in the cover letter :)

Is it okay if we fix this when we send the next version? Mainly to
avoid some people responding to this vs other responding to a new
series (where the patches are the same).

We used a script for --to-cmd and --cc-cmd but looks like it needs
some more fixes.

Here is the full series to anyone who's wondering where the rest of
the patches are:
https://lore.kernel.org/lkml/20230330224348.1006691-1-davidai@google.com/T/=
#t

Thanks,
Saravana
