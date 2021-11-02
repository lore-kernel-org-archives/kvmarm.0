Return-Path: <SRS0=ULe9=PV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A4E8C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  2 Nov 2021 09:51:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CB25B60C41
	for <kvmarm@archiver.kernel.org>; Tue,  2 Nov 2021 09:51:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CB25B60C41
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5799C4B12E;
	Tue,  2 Nov 2021 05:51:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Tp02fT9UHrqV; Tue,  2 Nov 2021 05:51:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F9564B150;
	Tue,  2 Nov 2021 05:51:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CD624B11C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Nov 2021 05:51:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x0vATYDc-Nzb for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Nov 2021 05:51:35 -0400 (EDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com
 [209.85.208.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0E8ED4B104
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Nov 2021 05:51:34 -0400 (EDT)
Received: by mail-lj1-f177.google.com with SMTP id 1so28021643ljv.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 02:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ltDk5JK6z+dHqY8fdueOIJnXFQ9epuN/VTXpT5MWcbo=;
 b=dB1O/eAqNcHN1R5TtXUb4Ium887EbOkxo37AnK/8BMd9z/JGifaE1xNVkrSWa5LMMh
 07YxdoVTS/OIMoHQHPutCkgiq9L1DjLVN+3aiQGnfasgaMJZT2JkrdBiej0auqMzj4Zq
 SeM4ASzdOt0EEDJw+/4W7DextFsZHaW0Y9fWezHvThGjnSv7/G41wW+7dEqC1oG/ACET
 9Xzc6fMqSJpq/raOpG4T5jn7IdAUg68R+0iuy8UNcVa7NUOJWFTXwhVdThdLVwusOjhS
 D85uaZLFHrfRqn23fuXjUwJw7svEl6TUbgIJCuE0CD5xCubi44JJLNS7JXRWSf49glWD
 xPUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ltDk5JK6z+dHqY8fdueOIJnXFQ9epuN/VTXpT5MWcbo=;
 b=ewtlc0fwipT4tkpCD5CfSTjdBkjJTNSRF4ufL3Pet8l62zGUzz8nRbm7GWRTeeVJlK
 jt9/FPReErmN/jygw0/Y2P2+/xkISSVMwWLIgUKMK6EB5/1RoPXRRik3j0XccP0yY6vy
 V6NtPnh1VWXk/07JDTw4T4bhOACiiDq2QrTcqjG1SIFrkVDDWHqUNlp0HCppLIKpT8b0
 AFtIIR1BHJ7/3gwNUDRLJvh0nzjcF7SimHxudUrgEewi1wk6UooplVamQf+mLz6P3/Pp
 J/X36IY+DE3fpeqgN9hUJrzEWfT/xYfsM4fd+WOdT7WTitGxPh81XPyKwxOd2QA3mJzs
 o/vw==
X-Gm-Message-State: AOAM532zbDfRIqsozzFS6tTZdRvm/Bdvwq7VaxYWXToRV+N3bX8GSYvg
 KQY9fE78jKuTmIGZna7K8biO6U0CAV9S2UPQ0n3JzH6MKZy1Qw==
X-Google-Smtp-Source: ABdhPJzlG6VNtE7PqaH0TRioe9leU6UmH/EsyksQvloUt4hUzw+AxRflWPdOgJuKeeHnODlRb4wS9kPqVoBnzRwawEU=
X-Received: by 2002:a05:651c:556:: with SMTP id
 q22mr24142315ljp.374.1635846692565; 
 Tue, 02 Nov 2021 02:51:32 -0700 (PDT)
MIME-Version: 1.0
References: <20211102094651.2071532-1-oupton@google.com>
 <20211102094651.2071532-3-oupton@google.com>
In-Reply-To: <20211102094651.2071532-3-oupton@google.com>
From: Oliver Upton <oupton@google.com>
Date: Tue, 2 Nov 2021 02:51:21 -0700
Message-ID: <CAOQ_QsgqLVVwzOhC5QeRm4qvWA-OXPB+bA=JJk4ffAavO5KMqQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] KVM: arm64: Stash OSLSR_EL1 in the cpu context
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-arm-kernel@lists.infradead.org
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

On Tue, Nov 2, 2021 at 2:47 AM Oliver Upton <oupton@google.com> wrote:
>
> An upcoming change to KVM will context switch the OS Lock status between
> guest/host. Add OSLSR_EL1 to the cpu context and handle guest reads
> using the stored value.
>
> Wire up a custom handler for writes from userspace and prevent any of
> the invariant bits from changing.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/kvm/sys_regs.c         | 31 ++++++++++++++++++++++++-------
>  2 files changed, 25 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f8be56d5342b..c98f65c4a1f7 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -172,6 +172,7 @@ enum vcpu_sysreg {
>         MDSCR_EL1,      /* Monitor Debug System Control Register */
>         MDCCINT_EL1,    /* Monitor Debug Comms Channel Interrupt Enable Reg */
>         DISR_EL1,       /* Deferred Interrupt Status Register */
> +       OSLSR_EL1,      /* OS Lock Status Register */

Sorry Marc, forgot to move this up per your suggestion on the last
series. Only caught it once the patch went out the door.

--
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
