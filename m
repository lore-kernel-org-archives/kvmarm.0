Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085D37487
	for <kvmarm@lists.linux.dev>; Mon,  3 Apr 2023 19:45:18 +0000 (UTC)
Received: by mail-ot1-f42.google.com with SMTP id k14-20020a9d700e000000b0069faa923e7eso16231270otj.10
        for <kvmarm@lists.linux.dev>; Mon, 03 Apr 2023 12:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680551118;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fXSd0dlF+2R3I9OQwTpEhIHnKpahJpStsjSP41bbUjc=;
        b=XQ4duCSgeYl7dN2WP/jz7f/ZPzS4X6hE5Mw13camiK43W7fCFcrfFTrP6SIZ3R3rqF
         hDRZLZzIJoHthkfpFYid5n2GZc0KGGXjEM1/DS1w3d5/TXDW90x7qxwhiDxT0DRsjlYD
         0mC2Ektshgb5wCFkeVBCGT4P/uT10CJZBAiIjQKrEUkUfQb/m6aCXCboQnNqmP89rTZt
         jEh+Rl89s31ObidvF1GOLP/4WhKo4US7M0NQgTXeFCcp3nUVEK2IIzHf3u1DMkwrwyeb
         6EjHA2PfMjKmjx+TGYd8p4JlmrzIPc5CJahpF0h+CM+o/vs2p8B6fjhc/noqmZqZSpXV
         oaNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680551118;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fXSd0dlF+2R3I9OQwTpEhIHnKpahJpStsjSP41bbUjc=;
        b=HYt4JSMyDYxJ8vFNwK+cSRu3OEnG6UxDnxaxgZRq9XHHbkwnRVZen2MXvYb0FRPhs7
         WCpaOK8hzq0NFTDjXoiiHXE/vY8VQ0X7uDx+fmtg06EgDZ5YJbtLUOb4/B4/72kT7jf3
         znk46F+uLVKB77FmajC6xZfzp/bSKktpOir0aVMhHCffl5p+1WK0/sJACYrJJTe0eAW8
         FX+FW0/TLd7Gk/0bFMjcNyX5UNABHSb1OXLLrGamuzLMHXRTpkKl61IvLBsDkA6yqvXr
         EZTAMnVmwydcXVuMY2RIwrD6AGycuaeA6p8LUFFF5m0lbRxkcMloT7H3Exkfo5vhyp7B
         SqVw==
X-Gm-Message-State: AAQBX9dzDtDXVkrt420Vofr4vBQ79lt2F9A9VH7VHM1wHUsc2b6Btvxg
	5JIaEva9Kgi3l+BepC+kgWMe3MkpSD5nrSXIAlRA+VMkCo7JK/xVZCY=
X-Google-Smtp-Source: AKy350ZxJ+YsCNZ4p9Ct24YsF2zVuM3+teNZbDHaHjt3h+8I63ARqubdQEG8mXItDUiJaSFmLFZthJNG8ctsSHDnP5o=
X-Received: by 2002:a9d:60d1:0:b0:694:3b4e:d8d7 with SMTP id
 b17-20020a9d60d1000000b006943b4ed8d7mr7732358otk.0.1680551117954; Mon, 03 Apr
 2023 12:45:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230402183735.3011540-1-jingzhangos@google.com>
 <20230402183735.3011540-6-jingzhangos@google.com> <86y1n9up5f.wl-maz@kernel.org>
In-Reply-To: <86y1n9up5f.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Mon, 3 Apr 2023 12:45:06 -0700
Message-ID: <CAAdAUthLZpu80rbmQYeGR_Mt5bRUdGhHqbJuRrUwX4MQ6n0O7w@mail.gmail.com>
Subject: Re: [PATCH v5 5/6] KVM: arm64: Introduce ID register specific descriptor
To: Marc Zyngier <maz@kernel.org>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Oliver Upton <oupton@google.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Mon, Apr 3, 2023 at 5:27=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> On Sun, 02 Apr 2023 19:37:34 +0100,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > Introduce an ID feature register specific descriptor to include ID
> > register specific fields and callbacks besides its corresponding
> > general system register descriptor.
> >
> > No functional change intended.
> >
> > Co-developed-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/kvm/id_regs.c  | 233 ++++++++++++++++++++++++++++----------
> >  arch/arm64/kvm/sys_regs.c |   2 +-
> >  arch/arm64/kvm/sys_regs.h |   1 +
> >  3 files changed, 178 insertions(+), 58 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> > index e92eacb0ad32..af86001e2686 100644
> > --- a/arch/arm64/kvm/id_regs.c
> > +++ b/arch/arm64/kvm/id_regs.c
> > @@ -18,6 +18,27 @@
> >
> >  #include "sys_regs.h"
> >
> > +struct id_reg_desc {
> > +     const struct sys_reg_desc       reg_desc;
> > +     /*
> > +      * ftr_bits points to the feature bits array defined in cpufeatur=
e.c for
> > +      * writable CPU ID feature register.
> > +      */
> > +     const struct arm64_ftr_bits *ftr_bits;
>
> Why do we need to keep this around? we already have all the required
> infrastructure to lookup a full arm64_ftr_reg. So why the added stuff?
You're right. Will use the lookup function.
>
> > +     /*
> > +      * Only bits with 1 are writable from userspace.
> > +      * This mask might not be necessary in the future whenever all ID
> > +      * registers are enabled as writable from userspace.
> > +      */
> > +     const u64 writable_mask;
> > +     /*
> > +      * This function returns the KVM sanitised register value.
> > +      * The value would be the same as the host kernel sanitised value=
 if
> > +      * there is no KVM sanitisation for this id register.
> > +      */
> > +     u64 (*read_kvm_sanitised_reg)(const struct id_reg_desc *idr);
>
> Why can't this function return both the required value and a mask?
> Why can't it live in the sys_reg_desc structure?
>
> Frankly, I don't see a good reason to have this wrapper structure
> which makes things pointlessly complicated and prevent code sharing
> with the rest of the infrastructure.
Sure, will reuse the existing fields in sys_reg_desc structure as you
demonstrated.
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
Thanks,
Jing
