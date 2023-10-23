Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618A033E7
	for <kvmarm@lists.linux.dev>; Mon, 23 Oct 2023 17:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LLtDW0oS"
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3575da42138so7005ab.1
        for <kvmarm@lists.linux.dev>; Mon, 23 Oct 2023 10:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698083911; x=1698688711; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TfJGqGdTH39RlV73n8ZRtDromBqG4R/oxQlCFc0Ndko=;
        b=LLtDW0oSipi2fTCLVcxJo2ChTNYTFZPwbdcGKCzCUwKgdzYkKe9yIKfeTsJ0s3dnWG
         5Llpk2CQLi3CNJwFk3i6Wv0lFsTESnQjC63SMZyf4+6yEvNQT0AUZkGBrxvArxDbCQu/
         MmH90yR3o0Qv1c+L3OS+UlYqeBS3u5SDrmmJgHsUFy+uCgvE0T9LDGYGBqkbB6GKq0sW
         Id7WFV9HPFn8fS0b7LGsoY459FiZ9dceNWgHr/u3OzB5MYIXLzGinjUhMXOgp9FI5DoA
         DR2ntif6OoVdWMyBf3TAT7tL7moZ/CpAQoxMkFz+++sUsDotp4WBcCiJ5C63FZjFbokY
         yvsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698083911; x=1698688711;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TfJGqGdTH39RlV73n8ZRtDromBqG4R/oxQlCFc0Ndko=;
        b=vOFgWAKcrLFPWVwPpQyqNBzQoyt86B3TRYnHsL5XEVxp0Oc+eYWCJLYwxw2UgUu/Sz
         kzkHL5Ts4tQjRSA7w1YrIhQVBfWnaSOlAjTTdpJ+14uKWNiihLLXusg28CG9NoS4Ux9b
         L9GtgK4Db5Xpsn/HjT+7NneQvqlxaHcqlht7h1XjciSJR1b1r9+UC3wJ2Gzdi9mAMoLk
         9BgbpiD4vO2FRX1ipj8Lz1XyNqb2vVOzmpEWL87PErux1DAnQytXwI59ZxRfkVmgELGU
         /Cwa1S48224llsCXfylE1bunJcMF/q4SZxQGQz1ZDqNXzwLlblI9TKhA34hUw9XNtGxE
         0kmQ==
X-Gm-Message-State: AOJu0YwrtUKmiQXD5QYA+Jb/uFGyhmpcUkyZHJRee44RXSI9bOaIChVZ
	5Bz+EhDYM6SiHuP4Y9sGYwLG7hCIcVeF8CCZJSPUZQ==
X-Google-Smtp-Source: AGHT+IHFu+B+EkRtR9TtZ2HnO5hJ/bbYmjecKN2fzau01UI7bGBTJ8SmNfFiuS/aPe3ywIzuv4AuB6FgCqAsG1FO86A=
X-Received: by 2002:a92:d08f:0:b0:357:cb68:b1cd with SMTP id
 h15-20020a92d08f000000b00357cb68b1cdmr29333ilh.22.1698083911264; Mon, 23 Oct
 2023 10:58:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231020214053.2144305-1-rananta@google.com> <86v8ax4hae.wl-maz@kernel.org>
In-Reply-To: <86v8ax4hae.wl-maz@kernel.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 23 Oct 2023 10:58:19 -0700
Message-ID: <CAJHc60yGk2Gfh-GRtOE94NS0K968iGTfn_3SSMYXxbgKaA_+Pg@mail.gmail.com>
Subject: Re: [PATCH v8 00/13] KVM: arm64: PMU: Allow userspace to limit the
 number of PMCs on vCPU
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 23, 2023 at 6:09=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Fri, 20 Oct 2023 22:40:40 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > Hello,
> >
> > The goal of this series is to allow userspace to limit the number
> > of PMU event counters on the vCPU.  We need this to support migration
> > across systems that implement different numbers of counters.
>
> [...]
>
> I've gone through the initial patches, and stopped before the tests
> (which I usually can't be bothered to review anyway).
>
> The comments I have a relatively minor and could be applied as fixes
> on top if Oliver can be convinced to do so. Note that patch #4 has an
> attribution issue.
>
> > base-commit: 0a3a1665cbc59ee8d6326aa6c0b4a8d1cd67dda3
>
> maz@valley-girl:~/hot-poop/arm-platforms$ git describe 0a3a1665cbc59ee8d6=
326aa6c0b4a8d1cd67dda3
> fatal: 0a3a1665cbc59ee8d6326aa6c0b4a8d1cd67dda3 is neither a commit nor b=
lob
>
> Can you please make an effort to base your postings on a known, stable
> commit? A tagged -rc would be best. but certainly not a random commit.
>
I usually do base on a known -rc. But this series needed a couple of
series from kvmarm/next (mentioned in the original patch), and hence I
rebased on top of them. How do you suggest I handle this in the
future? Rebase to a known -rc on mainline, apply the required series,
and then my series on top?

Thank you.
Raghavendra
