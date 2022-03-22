Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0352CC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 06:52:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79CEF49F02;
	Tue, 22 Mar 2022 02:52:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ao6aSC-evUch; Tue, 22 Mar 2022 02:52:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64E1749E2A;
	Tue, 22 Mar 2022 02:52:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF06240CDE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 02:52:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QPBsgvh96FTY for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 02:52:40 -0400 (EDT)
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com
 [209.85.166.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9905140B03
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 02:52:40 -0400 (EDT)
Received: by mail-io1-f49.google.com with SMTP id q11so19200866iod.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 23:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=XFoP8ryMln3uN20GWCunzZwIqKTPKsaz5P8BGJuL+LE=;
 b=oK4Dnxbemz6jkM6BAl43GshFrSPECt5yiqS/W2TtD4osI0sQrDEDzdu+6TcXW1/5Ll
 h3Tks8ZVoxxHfujsFYRjCKYCjluDVWpZmUwOtC557I+8HNXz1FKZTdkrXU9k8m4Y6EHC
 xMdkEFYXkA8ZwFKlrkDmLKO9va4NELZu7Al5Fo07+1qrMPvJv6ERt7bp+5uR5DaVdNbX
 oxARZvZFsp76D4motp6GpUTndgKGrzgOp0i4w/a6ddWxKixsjE41+zIJnnyc4rdjEHAm
 RBngOIPFZYg+80aKchv52lL38R02oOQlIflgaIbjIEMCRhXRgMc082/0P83J1A+nvs/Y
 FE3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=XFoP8ryMln3uN20GWCunzZwIqKTPKsaz5P8BGJuL+LE=;
 b=cbgX0iOPbPapL6pxlehHTSr8nnQd4JrAwC6mbcPK02nUfU73hC+Ni8HDxK9aFXNBGU
 iYFRmpNydl9AwQ1qMVrXe7HISX9sGDp+mg1xO3aOYIWoh42ORjLBRqkZcg6RxQHE4EHu
 UVZhAMm1nHgFNL9tlzZEY/KLJ6STZH8MLTk2Fv3hwnGYUeJlsjFmXdH3ux5OY15UHgL+
 MKTxuLrd6Nv0mGThoQgiiOfRXafVjsEfPNh5FOnAqeW8jxEjQqdLsFn8zrFRbqVDax4Z
 yaPRWxhturs+5tYAx9zUgDK5cReNjRtvS3iEutotUC0rq4ehx94WIOQiuXGoTuGlxXVs
 fOdQ==
X-Gm-Message-State: AOAM531csQmY5zU0Zl5xqijeiwDcF9r0TT2+YXRemOoADoPiuHMonHJo
 KEcF230xySBxx7G2Ng2j0kcO9Q==
X-Google-Smtp-Source: ABdhPJwSrV9ylByYHP6URYLJyyVsaDxyoDFv8jOKk1FGM5qehDvweIPCo9u6CGJK2Skc2EfPxwq7Eg==
X-Received: by 2002:a05:6602:1541:b0:649:94e:3cf7 with SMTP id
 h1-20020a056602154100b00649094e3cf7mr11820601iow.10.1647931959803; 
 Mon, 21 Mar 2022 23:52:39 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 b12-20020a6be70c000000b00648f61d9652sm9150605ioh.52.2022.03.21.23.52.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 21 Mar 2022 23:52:39 -0700 (PDT)
Date: Tue, 22 Mar 2022 06:52:35 +0000
From: Oliver Upton <oupton@google.com>
To: Anup Patel <anup@brainfault.org>
Subject: Re: [PATCH v4 07/15] KVM: Create helper for setting a system event
 exit
Message-ID: <YjlyM6/WFMB4JnHF@google.com>
References: <20220311174001.605719-1-oupton@google.com>
 <20220311174001.605719-8-oupton@google.com>
 <CAAhSdy3mH5JQ9N9JzbUpBw3ZdqKtLretsUKL3WAdMhpEXVmJRg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAhSdy3mH5JQ9N9JzbUpBw3ZdqKtLretsUKL3WAdMhpEXVmJRg@mail.gmail.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, KVM General <kvm@vger.kernel.org>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Peter Shier <pshier@google.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Atish Patra <atishp@atishpatra.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Jim Mattson <jmattson@google.com>
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

On Sat, Mar 19, 2022 at 12:58:28PM +0530, Anup Patel wrote:
> On Fri, Mar 11, 2022 at 11:11 PM Oliver Upton <oupton@google.com> wrote:
> >
> > Create a helper that appropriately configures kvm_run for a system event
> > exit.
> >
> > No functional change intended.
> >
> > Suggested-by: Marc Zyngier <maz@kernel.org>
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > Acked-by: Anup Patel <anup@brainfault.org>
> > ---
> >  arch/arm64/kvm/psci.c         | 5 +----
> >  arch/riscv/kvm/vcpu_sbi_v01.c | 4 +---
> >  arch/x86/kvm/x86.c            | 6 ++----
> >  include/linux/kvm_host.h      | 2 ++
> >  virt/kvm/kvm_main.c           | 8 ++++++++
> >  5 files changed, 14 insertions(+), 11 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> > index efd4428fda1c..78266716165e 100644
> > --- a/arch/arm64/kvm/psci.c
> > +++ b/arch/arm64/kvm/psci.c
> > @@ -173,10 +173,7 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type, u64 flags)
> >                 tmp->arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
> >         kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
> >
> > -       memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
> > -       vcpu->run->system_event.type = type;
> > -       vcpu->run->system_event.flags = flags;
> > -       vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> > +       kvm_vcpu_set_system_event_exit(vcpu, type, flags);
> >  }
> >
> >  static void kvm_psci_system_off(struct kvm_vcpu *vcpu)
> > diff --git a/arch/riscv/kvm/vcpu_sbi_v01.c b/arch/riscv/kvm/vcpu_sbi_v01.c
> > index 07e2de14433a..c5581008dd88 100644
> > --- a/arch/riscv/kvm/vcpu_sbi_v01.c
> > +++ b/arch/riscv/kvm/vcpu_sbi_v01.c
> > @@ -24,9 +24,7 @@ static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu,
> >                 tmp->arch.power_off = true;
> >         kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
> >
> > -       memset(&run->system_event, 0, sizeof(run->system_event));
> > -       run->system_event.type = type;
> > -       run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> > +       kvm_vcpu_set_system_event_exit(vcpu, type, 0);
> 
> This patch needs to be rebased on the latest kvm/next because we have
> done some refactoring to support SBI v0.3 SRST extension.

Sure thing, I've already picked up some fixes anyhow so not a problem.
Thank you for letting me know directly about the conflict though :)

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
