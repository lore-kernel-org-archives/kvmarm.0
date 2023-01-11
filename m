Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B41515A7
	for <kvmarm@lists.linux.dev>; Wed, 11 Jan 2023 00:56:00 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id b17so7560721pld.7
        for <kvmarm@lists.linux.dev>; Tue, 10 Jan 2023 16:56:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LHHWINXpgWQ8X1RAhvss5tXTw045jI9Q+hmOj82PhHI=;
        b=d/h1K4XBhTxSg/yHUwV3qQNrApxphNvm5Vp1r0ZcR9pHOL+fcE/39lQe08nRfIRxiL
         Aoy0tXLXOFI8chfV1dYnPzmP59cL6yK6xes1mqiwgKc/zfg/3FvPSZ3JRktgoRkhJZcP
         BwYIKVPCBgr92oVndlNVEoOx65hYEboe2akrICqwOEro1PTyZX+vVxkrZtv8uRex9kAK
         TDG9nL4T8nWs+9E7DdCVNVrkbrrBq2jEtkt3hGrYU289eCUCdoqSlJdR2G1eJ1QarvSx
         pX2YIsrm1wvOzqTJxiAzh/LnVpR5TVfxnJHZXDwj46leHPhj4Z29I6+kBlp1TYSlvqky
         mqOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LHHWINXpgWQ8X1RAhvss5tXTw045jI9Q+hmOj82PhHI=;
        b=Q6D4BMeFsf2+78sYqnBtxXI8eq4OGg5fAKWRy9P4o1toRSvjcGoS7MJLxtUXNIOqz1
         Vvm5fn/MGSs2RSmN/yA2xRjTBEQ7GmzZaPwt1vOnJ1Xzbj1Tfn0Ws6ux75GlyxnP+Wg3
         +z3z4Bu9v+EDohedFfwoiOT+o7rkgQ9rYhTyAgw2MLXrXO/QURs1yZ0FUayL9TA2olnf
         veuYDzqnH74CsC+8PDi3GhehDreQHl4nYsXrMkVvY9dgCXwpv9kYD0zlknxEJZdb7YLe
         csRuMTL/N/bBGXMvs4/ejb8M+kcn/Gy6YgUCG85IXYdY/ms1PvdPdvMTgVoZ4U26UxQ7
         e8DA==
X-Gm-Message-State: AFqh2kpRbFUhJd2tBlUqbsPlhIJtSW9OPpvQf/m6akKL4z1irA7rArkh
	lTMmuUphwjGZHbkNEPbZ9nR2TpiepTiHlKf8/GB3fQ==
X-Google-Smtp-Source: AMrXdXsYHS/aIJUbc2lrM9W3MRvphUJ+CDg/fAUxo0yMmZfAo9p7h4JAVlo2dZNdQzVfYPqUU13hauz2CKYXF9nuFWw=
X-Received: by 2002:a17:90a:2a82:b0:227:1d0b:5379 with SMTP id
 j2-20020a17090a2a8200b002271d0b5379mr842064pjd.103.1673398559752; Tue, 10 Jan
 2023 16:55:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221230035928.3423990-1-reijiw@google.com> <Y7zG3B3DmFZLU200@google.com>
In-Reply-To: <Y7zG3B3DmFZLU200@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 10 Jan 2023 16:55:43 -0800
Message-ID: <CAAeT=FzJozO+qW3VbiF2ojfDqcf_WTMohh45uxfiUBVfF5bHaQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] KVM: arm64: PMU: Allow userspace to limit the number
 of PMCs on vCPU
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ricardo Koller <ricarkol@google.com>, Jing Zhang <jingzhangos@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Mon, Jan 9, 2023 at 6:01 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Hi Reiji,
>
> On Thu, Dec 29, 2022 at 07:59:21PM -0800, Reiji Watanabe wrote:
> > The goal of this series is to allow userspace to limit the number
> > of PMU event counters on the vCPU.
> >
> > The number of PMU event counters is indicated in PMCR_EL0.N.
> > For a vCPU with PMUv3 configured, its value will be the same as
> > the host value by default. Userspace can set PMCR_EL0.N for the
> > vCPU to a lower value than the host value, using KVM_SET_ONE_REG.
> > However, it is practically unsupported, as KVM resets PMCR_EL0.N
> > to the host value on vCPU reset and some KVM code uses the host
> > value to identify (un)implemented event counters on the vCPU.
> >
> > This series will ensure that the PMCR_EL0.N value is preserved
> > on vCPU reset and that KVM doesn't use the host value
> > to identify (un)implemented event counters on the vCPU.
> > This allows userspace to limit the number of the PMU event
> > counters on the vCPU.
>
> I just wanted to bring up the conversation we had today on the list as
> it is a pretty relevant issue.
>
> KVM currently allows any value to be written to PMCR_EL0.N, meaning that
> userspace could advertize more PMCs than are supported by the system.
>
> IDK if Marc feels otherwise, but it doesn't seem like we should worry
> about ABI change here (i.e. userspace can no longer write junk to the
> register) as KVM has advertized the correct value to userspace. The only
> case that breaks would be a userspace that intentionally sets PMCR_EL0.N
> to something larger than the host. As accesses to unadvertized PMC
> indices is CONSTRAINED UNPRED behavior, I'm having a hard time coming up
> with a use case.

Yes, I agree with that. I will be looking at adding the validation
of the register field for the v2.

Thank you,
Reiji
