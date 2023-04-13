Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6747E
	for <kvmarm@lists.linux.dev>; Thu, 13 Apr 2023 00:07:55 +0000 (UTC)
Received: by mail-pg1-f178.google.com with SMTP id 191so2791107pga.12
        for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 17:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681344474; x=1683936474;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kKAsIKGLMCjdiMjyYgpIrloOvGnvw3VKlriI5GXRN4I=;
        b=2ItN+tuUpWJoDHZW7JEKXnfoI8Ujg4dDAlkY/WfQSIZQmMt22ieaeyCJ/MX4GAoB5J
         TVXdtxMQ/qpSt3c5QAg30x7AD8THGhS5T2khj9Ja/5HEScjOfn9w3cWGkkVX4JKtLaAl
         EKkFjRiS9tGTBpbYqVXPUvzA8uI0t/dyDimUnQFCSgVfxF8yE/xSjXuse4k0xujgQZ5P
         czZQlXliQxSKDKUuu/mZc0kh2DFv6LQB5Ef2zFr3f7JdrjSo94quWeZdT0ITuRqpsOHR
         Lq2bQrIrveuvzRucH92FVUbafqoxOiJlUK8Gj+YJTo66w2mlj8HzLvlZiuo4cjm/D4KU
         RkNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681344474; x=1683936474;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kKAsIKGLMCjdiMjyYgpIrloOvGnvw3VKlriI5GXRN4I=;
        b=Kmg3jC0VE9xy+k2BTpM+C0+9z113f1A8wIP4TY3hAfUGwusZwflSRNTqdhutU1v++y
         GRbpUV29kbfn5pdoDf8aySPhZFDuOLLIXibCPQqcFbCLvM2zG93APaoIxHRhg+9Lral9
         VzpcddwcteweIELjNFaldadlJNb9e/JYj11qTt7I2cYXUeZviCSRtx/73gvHvLoJxw10
         17GKM+FX7Ywa1fKCnb6ewRKC0k4HRhmmA/pdkp3c/Zf/KbhDR44V0puTtI5y81bKJNpX
         O1J/MKSbpCxWXwn8/iYDGmzmd9voas1dv9p8Z2q6q/gRngu93rqodKx7eO1BmzfMRIsJ
         wDlA==
X-Gm-Message-State: AAQBX9ePOjP2aYo+6ei5pDI9rCKSUNfu8d18U+eIL+8r2jRQRpd7cYYy
	XFn275t/439S3udk9aq8d0be7g3xJBKxxu6Pan84pw==
X-Google-Smtp-Source: AKy350ZslI/1nnGseGhaPt1ANKI3NMzvWy4XpoBuKrS83PsSkHoKwJ4zv6tFEy5paivPw1yzgwz46V4bM56jOb1AiNs=
X-Received: by 2002:a63:5158:0:b0:513:955d:ee9f with SMTP id
 r24-20020a635158000000b00513955dee9fmr4393677pgl.4.1681344474384; Wed, 12 Apr
 2023 17:07:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230408034759.2369068-1-reijiw@google.com> <20230408034759.2369068-3-reijiw@google.com>
 <ZDUpfnXi/GwFwFV9@FVFF77S0Q05N> <20230412051410.emaip77vyak624pu@google.com>
 <ZDZ3xbSePtOD3CSX@FVFF77S0Q05N> <86v8i1l7ru.wl-maz@kernel.org>
In-Reply-To: <86v8i1l7ru.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 12 Apr 2023 17:07:38 -0700
Message-ID: <CAAeT=FwUZ-TTn+4tt9pcesB59b7_=_zxkeRftMh5aQDUqnMz8g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: arm64: PMU: Don't overwrite PMUSERENR with
 vcpu loaded
To: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Rob Herring <robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Apr 12, 2023 at 11:22:29AM +0100, Marc Zyngier wrote:
> On Wed, 12 Apr 2023 10:20:05 +0100,
> Mark Rutland <mark.rutland@arm.com> wrote:
> >
> > On Tue, Apr 11, 2023 at 10:14:10PM -0700, Reiji Watanabe wrote:
> > > Uh, right, interrupts are not masked during those windows...
> > >
> > > What I am currently considering on this would be disabling
> > > IRQs while manipulating the register, and introducing a new flag
> > > to indicate whether the PMUSERENR for the guest EL0 is loaded,
> > > and having kvm_set_pmuserenr() check the new flag.
> > >
> > > The code would be something like below (local_irq_save/local_irq_restore
> > > needs to be excluded for NVHE though).
>
> It shouldn't need to be excluded. It should be fairly harmless, unless
> I'm missing something really obvious?

The reason why I think local_irq_{save,restore} should be excluded
are because they use trace_hardirqs_{on,off} (Since IRQs are
masked here for NVHE, practically, they shouldn't be called with
the current KVM implementation though).

I'm looking at using "ifndef __KVM_NVHE_HYPERVISOR__" or other
ways to organize the code for this.
Since {__activate,__deactivate}_traps_common() are pretty lightweight
functions, I'm also considering disabling IRQs in their call sites
(i.e. activate_traps_vhe_load/deactivate_traps_vhe_put), instead of in
__{de}activate_traps_common() (Thanks for this suggestion, Oliver).


> > I'm happy with that; it doesn't change the arm_pmu side of the interface and it
> > looks good from a functional perspective.
> >
> > I'll have to leave it to Marc and Oliver to say whether they're happy with the
> > KVM side.
>
> This looks OK to me. My only ask would be to have a small comment in
> the __{de}activate_traps_common() functions to say what this protects
> against, because I'll page it out within minutes.

Thank you for the feedback!
Yes, I will add a comment for those.

Thank you,
Reiji
