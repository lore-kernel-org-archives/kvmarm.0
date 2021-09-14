Return-Path: <SRS0=7Ft5=OE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A01C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 14 Sep 2021 16:52:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7D2126115C
	for <kvmarm@archiver.kernel.org>; Tue, 14 Sep 2021 16:52:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7D2126115C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E28F84B125;
	Tue, 14 Sep 2021 12:52:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CAE4xqQaAUZL; Tue, 14 Sep 2021 12:52:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5E0A4B127;
	Tue, 14 Sep 2021 12:52:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B9924B127
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Sep 2021 12:52:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r7IIQCMTj3ne for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Sep 2021 12:52:03 -0400 (EDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com
 [209.85.219.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 24B9F4B121
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Sep 2021 12:52:03 -0400 (EDT)
Received: by mail-yb1-f181.google.com with SMTP id s11so29611257yba.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Sep 2021 09:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=InOpix2phRGLMorlyZqQ+GGTXRocd0DMzXMfTrOXIA8=;
 b=nrOaF0RH6u956TyUyQH1NkkOgIGnw+zvNCqN8QZ36kWB6qePAQWi8cn0yFbga60Vsu
 sRW+HWafhWk6f++eXZLpGzpEgPlh8G16aEC4HJhIW9/bmFt2i2mPuDRgpeTXONJ5TNNM
 Tp2bqLDrUE6phdkOMo322ofUMoJzCug9X0E7PUrBuejl5bMGPgJXZ0QYo7QRPWlwPqm2
 1ytrqMHpyiu6LPDfx8WqE6DamhFtgWcHijiAN1erSs62NG6Ru8eIoBFtitSm+IMqO/XJ
 j/ruyaeHzBEQzMGY72FSdzuTDPm+jfe0D+k522tSC8bj2xcXpPynGhWztD9b5l9SrpxM
 REtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=InOpix2phRGLMorlyZqQ+GGTXRocd0DMzXMfTrOXIA8=;
 b=uYCDBT2QpCstrRw6JxKX2FWLjeM/S3rEGScBaqFG5yR77yXkgT7dcgTMjuyYBNIotJ
 MYXij2jE3w1BSGQeGPZ9KXr127kcWtTri3jLudr0FwUkVaJ4FCQjvv+KayJytFhzoEJG
 hBag7K5GVOmbUc52DLAN2hwN9wkvPmAClRdI6bQnWP2vJTpcipoLfGM4dv88kot9n99Q
 i8Y9hHDfbSpSNF7G5qi7W2wfo+lLzazc3/BR0pzKD8ldDBwnIk4IBCBgLYAlx6IHj2zV
 TyLoTWGTzpMMv8XkBA0aBFAOU4keLlgqUQWk2Zya10XYSzx0DKPTBHrfTXZmrRrsmies
 V7cA==
X-Gm-Message-State: AOAM531xWqxx02ba6kg7kZM8yMRv9NKT5I7uArs0khh7ynH1V/oiCmZb
 QgYDP4IUVrBCsUOxIfPIYZV8uT7t4KiMc81+IlIv+g==
X-Google-Smtp-Source: ABdhPJyHV28ZJhx5INkGz4FS57frMA9C4W90KU6v9rPb7f8DnJDT7BHYoLFwTtirGvLKJE69HQJQgZDW4qFMUfPs300=
X-Received: by 2002:a25:2d4c:: with SMTP id s12mr163395ybe.350.1631638322326; 
 Tue, 14 Sep 2021 09:52:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210913230955.156323-1-rananta@google.com>
 <20210913230955.156323-10-rananta@google.com>
 <20210914070340.u6fp5zo7pjpxdlga@gator.home>
In-Reply-To: <20210914070340.u6fp5zo7pjpxdlga@gator.home>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 14 Sep 2021 09:51:51 -0700
Message-ID: <CAJHc60w_p5d0=0_BthStcutUywNJaJjamMdJrhD6HbFt_BVFHw@mail.gmail.com>
Subject: Re: [PATCH v6 09/14] KVM: arm64: selftests: Add guest support to get
 the vcpuid
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Sep 14, 2021 at 12:03 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Mon, Sep 13, 2021 at 11:09:50PM +0000, Raghavendra Rao Ananta wrote:
> > At times, such as when in the interrupt handler, the guest wants
> > to get the vcpuid that it's running on to pull the per-cpu private
> > data. As a result, introduce guest_get_vcpuid() that returns the
> > vcpuid of the calling vcpu. The interface is architecture
> > independent, but defined only for arm64 as of now.
> >
> > Suggested-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > Reviewed-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  tools/testing/selftests/kvm/include/kvm_util.h      | 2 ++
> >  tools/testing/selftests/kvm/lib/aarch64/processor.c | 6 ++++++
> >  2 files changed, 8 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> > index 010b59b13917..5770751a5735 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > @@ -400,4 +400,6 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
> >  int vm_get_stats_fd(struct kvm_vm *vm);
> >  int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
> >
> > +int guest_get_vcpuid(void);
> > +
> >  #endif /* SELFTEST_KVM_UTIL_H */
> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > index db64ee206064..f1255f44dad0 100644
> > --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > @@ -277,6 +277,7 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
>
> x86's vcpu_setup strangely uses 'int' for vcpuid even though everywhere
> else we use uint32_t. Unfortunately that strangeness got inherited by
> aarch64 (my fault). We should change it to uint32_t here (as a separate
> patch) and...
>
I can send one out as a part of this series.

Regards,
Raghavendra
> >       set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TCR_EL1), tcr_el1);
> >       set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_MAIR_EL1), DEFAULT_MAIR_EL1);
> >       set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TTBR0_EL1), vm->pgd);
> > +     set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TPIDR_EL1), vcpuid);
> >  }
> >
> >  void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
> > @@ -426,3 +427,8 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
> >       assert(vector < VECTOR_NUM);
> >       handlers->exception_handlers[vector][0] = handler;
> >  }
> > +
> > +int guest_get_vcpuid(void)
> > +{
> > +     return read_sysreg(tpidr_el1);
> > +}
>
> ...return uint32_t here.
>
> Thanks,
> drew
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
