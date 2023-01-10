Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6850C15A7
	for <kvmarm@lists.linux.dev>; Tue, 10 Jan 2023 01:18:16 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id v23so10657297pju.3
        for <kvmarm@lists.linux.dev>; Mon, 09 Jan 2023 17:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4WzHP9HtqOS+7EgkyaB7qsHOqXPusLU6aq8lH0si9po=;
        b=SNtfT/pKNP1WO2Z96CPYNglF9ygm6E27LHZYd9dKJr97+T3yZB8afeQxrZR680yggK
         Te7Dpk3vypCFvNdHNkynXANL9iYTtOPUwiEjRR8K+FwQeG4UdRd66/cvqVjMEjOhHqgs
         ok0yeZwvTmLDYP4eEwJ28j8onl0ZaDcvEyt4nH2txkNZnJagDBfnsHj4ZTlwc7mHWmSQ
         deGveKDB8X0kk2Jmtw7pEEYnYS3TWDNM9lhxsCNYnw8nkg7Y9r/cOOoyNA5H9ja9jiqk
         Hq2oDeAbCdQm6M0yglCTebO4WZ7F3zrnJDSASN5KdPtwZ7jA3e2VkmWmujyCFFwXgqFJ
         FY8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4WzHP9HtqOS+7EgkyaB7qsHOqXPusLU6aq8lH0si9po=;
        b=ZjH2lp0h38qBGbKA00oPsA7DTKGFwSs7cxfH6tHUI90iN8QoiOgBZPtAHCTIdUIOXI
         c2zkTx5yiEDeBljFkdMC2B1YzkvTJXF5zdh2UDJ+DNVUsLexCU7UCleIrvtf7wwuxxVX
         F6/B3Yt+SL21tf3rUDh35cTtOyj+dIvl5GTbQwtNaK7NzSDM3DjSTeWj1oLzYzTimHB9
         +Yn+iaYjHwT2T90XhQ4MHkDew8SIr7H96KA+qJr+dU1hCsLv6DZF5aDmehnSGr7GEs+1
         7a8XalcdNIA7Y5DpxOkuSCeTv4oRpQ+HPBDxgQ3GRIrhyBCc4D3XFhl4EBc7hkfG7nC+
         P3fg==
X-Gm-Message-State: AFqh2koeXEREhEVs2swpSS+HrEE9qYjjQr06rGIst6cOKr7PXtwqPTzT
	CosQREUK8iBLhS7VCtkGkr5ZUUq0MOJrGOLwTsKlow==
X-Google-Smtp-Source: AMrXdXuCNEnCglyKwTg+tL1hvWXJW7ijbzqRmcLjK5pyJ46Isl93+rRt7aWNsVQJVrX6LohrQSCdJ0wBph8xbuZglFc=
X-Received: by 2002:a17:902:bb8b:b0:192:71f0:719e with SMTP id
 m11-20020a170902bb8b00b0019271f0719emr5700133pls.30.1673313495725; Mon, 09
 Jan 2023 17:18:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221230035928.3423990-1-reijiw@google.com> <20221230035928.3423990-3-reijiw@google.com>
 <Y7sVx8sv2BYiMihZ@thinky-boi>
In-Reply-To: <Y7sVx8sv2BYiMihZ@thinky-boi>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 9 Jan 2023 17:17:59 -0800
Message-ID: <CAAeT=Fxnkn++j6MObaAhHwb4nTf-g9XGOgzr0NYpA5K6hicFkg@mail.gmail.com>
Subject: Re: [PATCH 2/7] KVM: arm64: PMU: Use reset_pmu_reg() for
 PMUSERENR_EL0 and PMCCFILTR_EL0
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ricardo Koller <ricarkol@google.com>, Jing Zhang <jingzhangos@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Sun, Jan 8, 2023 at 11:13 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> On Thu, Dec 29, 2022 at 07:59:23PM -0800, Reiji Watanabe wrote:
> > The default reset function for PMU registers (reset_pmu_reg())
> > now simply clears a specified register. Use that function for
> > PMUSERENR_EL0 and PMCCFILTR_EL0, since those registers should
> > simply be cleared on vCPU reset.
>
> AFAICT, the fields in both these registers have UNKNOWN reset values. Of
> course, 0 is an entirely valid reset value but the architectural
> behavior should be mentioned in the commit message.

Uh, yeah, the commit message was misleading.
The fields in both these registers have UNKNOWN reset values.
The ones for 32bit registers (PMUSERENR and PMCCFILTR) have zero reset
values though.

I will update the commit message to mention those explicitly.

Thank you,
Reiji
