Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4BFAC433F5
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jan 2022 06:07:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 307F349FE6;
	Fri,  7 Jan 2022 01:07:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e4JDePualA2Y; Fri,  7 Jan 2022 01:07:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1130249F4B;
	Fri,  7 Jan 2022 01:07:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AAC8249F4B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jan 2022 01:07:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JL2-80vcmH-1 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Jan 2022 01:07:10 -0500 (EST)
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com
 [209.85.216.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 96D4D49EE4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jan 2022 01:07:10 -0500 (EST)
Received: by mail-pj1-f43.google.com with SMTP id
 y16-20020a17090a6c9000b001b13ffaa625so10980409pjj.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Jan 2022 22:07:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=2q58XOryfIlXBk+Ga94YK5KAiqVRv5tmtrlFtSkfC0E=;
 b=ochKJUmv9jcYYqjl8Ri0yXzDhwacQ2/M9JFDOvS2FBy8XLGNBzhfSvKLa9ii/FgSHR
 lKXPiHPPHOi42VPVoABzyceIiJ8F+Kbs3IS0k75hH2A5mdF2XigOH5lmdKWrpcwtxdbr
 ezxvlB8NX6lqdXgr7vLxp+V4EZIGdh1LCkEFmJztS6KTyCd2fXWSEdqhhi3oBwVmS13w
 /pYkJOH9knWKKZPd/LGxDD94eatNe6H5EBW+iGlQr71hEgAmZVB6ZiK24VPUj2ooMIaj
 42ZKBZFHvnOHD474TolWmS+OmhGNji04Be9HsERGLppfG0rRjME6jGJDuXtYXGuWgZIu
 K72Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=2q58XOryfIlXBk+Ga94YK5KAiqVRv5tmtrlFtSkfC0E=;
 b=oWXkADpva0rcZUDN92pONKUKYaXNfSO6iCf7MdzK74Kw0k9mhAxrZOOeaq4WUkxq9e
 G2ewnEAJxGNIXZHUXIob0QJj5KjFdHY7vqiLQX6JyHrdern62pIFb5NSuisheWwEXDUb
 L6K9Gtfivkirk2UmULL8usnvnMVX+ogriyr41eDgJZTBYanAzj3REXlccdlldsDhUt+B
 J6j4CbzZkQRsuF3Z033O3hjrYRca6rmFDsWAFNAoJnMYeSY5UPdkhSfyUDTS4r5F+ZPb
 8zGS2QKtfRbf4lvnKH9BoKyUKUxGGPD8Tfd6mjDEKQuPhx793sFuMDh2KWB1asZHUdiA
 pfmA==
X-Gm-Message-State: AOAM531SjuVYL7x6A0VvwrnR/eMySPgcCw5w4UbL48fN0wp89JYRpuJ9
 u2t4Z3Je0Y6KiFT9b73hNzoKhGfno+r5lReBhYkCOg==
X-Google-Smtp-Source: ABdhPJzi8RhMHj39b+4Rn0KshD189vXaFIX2vj8EwamLndmdEQUpG8o9KUsh8L5L/q0EpOVykikO8FcKUk+BveZguG8=
X-Received: by 2002:a17:902:c652:b0:148:f1a5:b7bf with SMTP id
 s18-20020a170902c65200b00148f1a5b7bfmr62134703pls.122.1641535629407; Thu, 06
 Jan 2022 22:07:09 -0800 (PST)
MIME-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com>
 <20220104194918.373612-2-rananta@google.com>
In-Reply-To: <20220104194918.373612-2-rananta@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 6 Jan 2022 22:06:53 -0800
Message-ID: <CAAeT=Fxyct=WLUvfbpROKwB9huyt+QdJnKTaj8c5NKk+UY51WQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Raghu,

On Tue, Jan 4, 2022 at 11:49 AM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> Capture the start of the KVM VM, which is basically the
> start of any vCPU run. This state of the VM is helpful
> in the upcoming patches to prevent user-space from
> configuring certain VM features after the VM has started
> running.
>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  include/linux/kvm_host.h | 3 +++
>  virt/kvm/kvm_main.c      | 9 +++++++++
>  2 files changed, 12 insertions(+)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index c310648cc8f1..d0bd8f7a026c 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -623,6 +623,7 @@ struct kvm {
>         struct notifier_block pm_notifier;
>  #endif
>         char stats_id[KVM_STATS_NAME_SIZE];
> +       bool vm_started;

Since KVM_RUN on any vCPUs doesn't necessarily mean that the VM
started yet, the name might be a bit misleading IMHO.  I would
think 'has_run_once' or 'ran_once' might be more clear (?).


>  };
>
>  #define kvm_err(fmt, ...) \
> @@ -1666,6 +1667,8 @@ static inline bool kvm_check_request(int req, struct kvm_vcpu *vcpu)
>         }
>  }
>
> +#define kvm_vm_has_started(kvm) (kvm->vm_started)
> +
>  extern bool kvm_rebooting;
>
>  extern unsigned int halt_poll_ns;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 72c4e6b39389..962b91ac2064 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3686,6 +3686,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
>         int r;
>         struct kvm_fpu *fpu = NULL;
>         struct kvm_sregs *kvm_sregs = NULL;
> +       struct kvm *kvm = vcpu->kvm;
>
>         if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_dead)
>                 return -EIO;
> @@ -3723,6 +3724,14 @@ static long kvm_vcpu_ioctl(struct file *filp,
>                         if (oldpid)
>                                 synchronize_rcu();
>                         put_pid(oldpid);
> +
> +                       /*
> +                        * Since we land here even on the first vCPU run,
> +                        * we can mark that the VM has started running.
> +                        */

It might be nicer to add a comment why the code below gets kvm->lock.

Anyway, the patch generally looks good to me, and thank you
for making this change (it works for my purpose as well).

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thanks,
Reiji


> +                       mutex_lock(&kvm->lock);
> +                       kvm->vm_started = true;
> +                       mutex_unlock(&kvm->lock);
>                 }
>                 r = kvm_arch_vcpu_ioctl_run(vcpu);
>                 trace_kvm_userspace_exit(vcpu->run->exit_reason, r);
> --
> 2.34.1.448.ga2b2bfdf31-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
