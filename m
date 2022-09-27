Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D0BCC54EE9
	for <kvmarm@archiver.kernel.org>; Tue, 27 Sep 2022 17:38:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A70974B6B6;
	Tue, 27 Sep 2022 13:38:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YA-Z24FYHpcU; Tue, 27 Sep 2022 13:38:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E7654B63E;
	Tue, 27 Sep 2022 13:38:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4695F4B0CB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 13:38:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZO0dKLB4UKPd for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2022 13:38:35 -0400 (EDT)
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com
 [209.85.166.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 31DE4408A7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 13:38:35 -0400 (EDT)
Received: by mail-io1-f43.google.com with SMTP id z191so8298414iof.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 10:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date;
 bh=zwWYKbkkIMXnui5gCfkJ00LzKXpPlaBP/wjajc/qT2s=;
 b=syVso9JR6664/0/8mv5Q0ETYytR/HniKXmKiH3T1jW5szdgBIeR6jrNwGL0FX2LiCm
 F4PGCPVRtW9j/nghuwf+gEtj2HzOLg+ajhiadpCHFepcUySHBDw2v1zsD7VzKKvJxyo4
 CL0j58elRqrDEmDWTSJecNQ6lX5TKYckWqFOa9PxrRmeg0dSBR+rT2vYjCYMUkI4txut
 M0c/TqRHQG+mjav8eL5QgGwTx/qw47Uz3bLYSGQHC8RyeTK0oJq1VjBWksj3kJx9zPFL
 IIt160iugt34uDrqxE1tX48P9LKN3c+EWbH/SIMBl1Vc4zDimqX1nWXB3R5IU8y84mDc
 Gymg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=zwWYKbkkIMXnui5gCfkJ00LzKXpPlaBP/wjajc/qT2s=;
 b=ygLcMLHFnOeu7g2sEaXVGyWXYZ9ty39omzA+gFsBX1+EXzi4RxyNfxsbI2Z9M6zzcC
 zYAxy0O7SNTH8aKLF9Z0JXhakSZOU2JzubXS35p1y3HuC/pA7aJu1vDbRko/EATRTU5X
 86J9s/A8zKWugfuTPwmP/oqY7eDsgHL0W/GocNgqKh09kk7PXkQmRehuD1G2pxsiFUY7
 sjrIVQOrcfGuYnmoIk/WoiWdv5GLpr2F+aMO3tYgqGT1mRbzZmwKKjA8ITudzKRNHbS7
 XzV91lLFX4oX6BlA9lEpH5el7tA19mpz0cyC/rZAz24Djb6bORHAEaMbe/FDNOFFttLk
 RrxA==
X-Gm-Message-State: ACrzQf2ibbU76qjh6q0JogdQqtZ6CCDwgC+UqY9OJqiBAsRRVlL6dw+v
 urAWfs+eMJKNOoewWsLAu1OkaN01oLxDM0Gyg0xCyA==
X-Google-Smtp-Source: AMsMyM5MfXlfh9YEbgA+gtNnYv11bP83Vk62ySUseMBdKK5z9jeJJNAuT70mC5cTy94LiccSQm6HTh24Cbmndz+QGlU=
X-Received: by 2002:a05:6638:4184:b0:35a:3eb4:f932 with SMTP id
 az4-20020a056638418400b0035a3eb4f932mr15108246jab.216.1664300314532; Tue, 27
 Sep 2022 10:38:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220927002715.2142353-1-mizhang@google.com>
 <CAAeT=FwqWkbhFLHvr12A2rYdzZuDJWBti=jKQRargvAb6bKtaA@mail.gmail.com>
In-Reply-To: <CAAeT=FwqWkbhFLHvr12A2rYdzZuDJWBti=jKQRargvAb6bKtaA@mail.gmail.com>
From: Mingwei Zhang <mizhang@google.com>
Date: Tue, 27 Sep 2022 10:38:22 -0700
Message-ID: <CAL715WJsp7zJ-p++TzjxAv5b0cWRKFH-2Tqws1SV34EO16Xp-g@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Cleanup the __get_fault_info() to take out
 the code that validates HPFAR
To: Reiji Watanabe <reijiw@google.com>
Cc: Marc Zyngier <maz@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>,
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

> > +static inline bool __hpfar_is_valid(u64 esr)
>
> Unlike what the name implies, this function returns true for some
> cases that HPFAR is not valid (i.e. SEA).  I think the function
> returns true when KVM doesn't need HPFAR, or when HPFAR is valid.
> IMHO the name might be a bit misleading, although I don't have
> a good name for this.  It would be nice to state that in the
> comment at least.
>
> Thank you,
> Reiji
>

Yeah, I agree with you Reiji that the name does not reflect the
meaning of the function. So I was thinking about other names like
__translate_hpfar_to_far_needed().
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
