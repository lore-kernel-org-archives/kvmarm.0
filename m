Return-Path: <SRS0=YqI3=NO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B9ADC4338F
	for <kvmarm@archiver.kernel.org>; Mon, 23 Aug 2021 20:56:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B102461391
	for <kvmarm@archiver.kernel.org>; Mon, 23 Aug 2021 20:56:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B102461391
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E38E4B1C1;
	Mon, 23 Aug 2021 16:56:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ph2wFxsX97ny; Mon, 23 Aug 2021 16:56:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F2B94B1CB;
	Mon, 23 Aug 2021 16:56:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13F984B15E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 16:56:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9R7m7FBoOiTF for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Aug 2021 16:56:42 -0400 (EDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com
 [209.85.167.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AC54C4B14E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 16:56:42 -0400 (EDT)
Received: by mail-lf1-f52.google.com with SMTP id y34so40584728lfa.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 13:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=MfPwGm7EjtmSmvRvog46PefSQxr+x+Md7zVpSE6q5iY=;
 b=F2VT7MfdNQfF2aC+mrjNV+Daso+Yq3Z14ZV+Z6h8uaopYNj0tHQL/DCg520+YFSpkz
 HMHC2ObB8T9d6VnhiY6VgvFdgh5rlX4vqTZi96FDXT1DF/Vwkw+F3Jjn+pn8OWQPMWkB
 mYCV0IwCPhknXBSAj7wi+114bTreZL51D42va1MYcCoXCWvrXScI0UQLqnLnFLvUkHA0
 bBSxLSelk4cilUeMgdUnelmsbIaqk5mZOBrMeTaM+8unId+sJlOGteHTlUeZRNAMFn5z
 bRzAC4Jjv0D2b83ZDGDLlPorCzx8OR+UxWNK66lljAtyFbDduaVa4Bu6ME55eIQ7e3X5
 EAlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=MfPwGm7EjtmSmvRvog46PefSQxr+x+Md7zVpSE6q5iY=;
 b=WoX+PfnbZlSSWjz7VyHfNFCoiRROhiKZkSL5Ud72PMX7r6c27c6nTeBTLXCXR6xXms
 ay7GHm6EO0k6PqCBiapzrZLWEUFbWaSARbBL5BcdrvA7Kh4Dvdm+TJnze7ulU0m6hpmb
 S4OJnVaJV03WgvQAJk6ikZ05Aj0wDaNn9sZmgGAdN279nkjkoUPGNSxWlfXqJsyj2fPE
 1D5uhac6sSotD9ahKtcWSS1TNjpYpwoLTbKPNBp9nKGHpGbalQO8vMJPvEw4iQpUSsgZ
 rDWVDAIkOtpthTh/zofIT38qFK0etDjP4W2R0ckNJCE0W6yhr2n+z2xot48zG81Y5lRl
 0KiQ==
X-Gm-Message-State: AOAM530f3da3fGR9AlCqiOkeWuwMiwpHl4pNZ3ydbtSj5949di3DnM4J
 ku3anhnKWb55kKXINZg4h3Y1PFwUHnlTy/x+DO4qcg==
X-Google-Smtp-Source: ABdhPJw8SHvShGUZj5r3Nx+hzSSyezPNL0Amodo1oDiTqLZh0M2RrBLha351nIEgZs2TuC0YuCzhvO/JGjr8cgLzSXg=
X-Received: by 2002:a05:6512:3ba4:: with SMTP id
 g36mr26490576lfv.80.1629752200949; 
 Mon, 23 Aug 2021 13:56:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210816001130.3059564-1-oupton@google.com>
 <20210816001130.3059564-7-oupton@google.com>
In-Reply-To: <20210816001130.3059564-7-oupton@google.com>
From: Oliver Upton <oupton@google.com>
Date: Mon, 23 Aug 2021 13:56:30 -0700
Message-ID: <CAOQ_Qsj_MfRNRRSK1UswsfBw4c9ugSW6tKXNua=3O78sHEonvA@mail.gmail.com>
Subject: Re: [PATCH v7 6/6] KVM: x86: Expose TSC offset controls to userspace
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

Paolo,

On Sun, Aug 15, 2021 at 5:11 PM Oliver Upton <oupton@google.com> wrote:
>
> To date, VMM-directed TSC synchronization and migration has been a bit
> messy. KVM has some baked-in heuristics around TSC writes to infer if
> the VMM is attempting to synchronize. This is problematic, as it depends
> on host userspace writing to the guest's TSC within 1 second of the last
> write.
>
> A much cleaner approach to configuring the guest's views of the TSC is to
> simply migrate the TSC offset for every vCPU. Offsets are idempotent,
> and thus not subject to change depending on when the VMM actually
> reads/writes values from/to KVM. The VMM can then read the TSC once with
> KVM_GET_CLOCK to capture a (realtime, host_tsc) pair at the instant when
> the guest is paused.
>
> Cc: David Matlack <dmatlack@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>

Could you please squash the following into this patch? We need to
advertise KVM_CAP_VCPU_ATTRIBUTES to userspace. Otherwise, happy to
resend.

Thanks,
Oliver

 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b946430faaae..b5be1ca07704 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4070,6 +4070,7 @@ int kvm_vm_ioctl_check_extension(struct kvm
*kvm, long ext)
        case KVM_CAP_VM_COPY_ENC_CONTEXT_FROM:
        case KVM_CAP_SREGS2:
        case KVM_CAP_EXIT_ON_EMULATION_FAILURE:
+       case KVM_CAP_VCPU_ATTRIBUTES:
                r = 1;
                break;
        case KVM_CAP_EXIT_HYPERCALL:
-- 
2.33.0.rc2.250.ged5fa647cd-goog
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
