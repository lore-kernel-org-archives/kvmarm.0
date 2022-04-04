Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 425C1C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  4 Apr 2022 04:45:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F24349F4A;
	Mon,  4 Apr 2022 00:45:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id E4mgtFamlxHZ; Mon,  4 Apr 2022 00:45:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 746674A104;
	Mon,  4 Apr 2022 00:45:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07C0849F4A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 00:45:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kjqeJhIMABpL for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2022 00:45:32 -0400 (EDT)
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com
 [209.85.216.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EFEA349F2A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 00:45:31 -0400 (EDT)
Received: by mail-pj1-f48.google.com with SMTP id
 ku13-20020a17090b218d00b001ca8fcd3adeso1975493pjb.2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 03 Apr 2022 21:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=EEBN46zG2gvj2WY3lcxbVjrOksL0c/6WsjgZKCCzd/I=;
 b=kO4FdgYOebV/t2yzqBUOJ9hdCnVOAE3BWF9Xy8r7hy5NcvqQG9Q59fB2bGDz3+c94d
 tzqJw1ebi1BVASe6U2F6kGGXnf8lsXzK3vuEkvTHitRwLEPwoilxOyk3Vk07cBPVgcbF
 ue4XLYc4quOAF2XEnzJm7J0Gv/svvXxIfc2fSdexbpx2QcdTBwR5rcljcYhLapjF/0Pf
 t44yEaWd3T89rgPU9PQCuCtS7eGl7rqKj5LfFqG4ovsi3qcjmGPiktdZU9tq6DqSzj7i
 7hcDvWP9+15F67X9PrYumh8bQaJy1B2Kx7moJbcJNCEk4aR6eaJnViNcNQmPbLuepjRS
 8iYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=EEBN46zG2gvj2WY3lcxbVjrOksL0c/6WsjgZKCCzd/I=;
 b=SA+st294zWeCKmlimhVhXEWIxiRmuBJLr5NXWYgVgPYomK+PRAiZcdbluMPOQIZdi/
 by1fU/c4OBnpPixJ9zsKWlmQ6WEW9Y/IQ4WrmMSb+XHh4iy2sY9KNJcuHak6pX4+BiSy
 zWRHYfCTDlT8ZIoQdtDQq3/zcb2H3Cn9YZn8sGq/DBsh9l7nRU2Zz5fCmDIfmaMWEiXr
 f4kX7KWRAR9wv9l0kR30f2wbOFI0pwFlM5MIa8KBS5YDqOMpFiNz8ARgNzZHA+tt5/Qv
 uur0WnS4x0i/ASFS8M9yFllr7DzNMEwMgA6F+rIr51TyBvwGKqrJiaOdB+DCO2n6o7vX
 PXdQ==
X-Gm-Message-State: AOAM531cjRo3m0h+/Jvim+OuKhUF/cqKr9DG1O8EIpAQQVb895RnAgEk
 6H7N2FCmRSYcurgejPoxbc+Na6DPUtRBC32OZge9bg==
X-Google-Smtp-Source: ABdhPJzDVFMCClRUsK6gQWVxwlJiuN5q5hN2bBgrZWH+gsR5sokMSlYJUr9RMO+e4xu5pPL/2GX8kvOJQQ01h2wlkk8=
X-Received: by 2002:a17:90b:2350:b0:1ca:23b5:69a6 with SMTP id
 ms16-20020a17090b235000b001ca23b569a6mr20934316pjb.9.1649047530910; Sun, 03
 Apr 2022 21:45:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220401010832.3425787-1-oupton@google.com>
 <20220401010832.3425787-4-oupton@google.com>
In-Reply-To: <20220401010832.3425787-4-oupton@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Sun, 3 Apr 2022 21:45:15 -0700
Message-ID: <CAAeT=Fz4cB_SoZCMkOp9cEuMbY+M+ieQ6PTBcvCOQRwGkGv9pA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Start trapping ID registers for 32 bit
 guests
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu,
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

On Thu, Mar 31, 2022 at 6:08 PM Oliver Upton <oupton@google.com> wrote:
>
> To date KVM has not trapped ID register accesses from AArch32, meaning
> that guests get an unconstrained view of what hardware supports. This
> can be a serious problem because we try to base the guest's feature
> registers on values that are safe system-wide. Furthermore, KVM does not
> implement the latest ISA in the PMU and Debug architecture, so we
> constrain these fields to supported values.
>
> Since KVM now correctly handles CP15 and CP10 register traps, we no
> longer need to clear HCR_EL2.TID3 for 32 bit guests and will instead
> emulate reads with their safe values.
>
> Signed-off-by: Oliver Upton <oupton@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>

BTW, due to this, on a system that supports PMUv3, ID_DFR0_E1 value will
become 0 for the aarch32 guest without PMUv3. This is the correct behavior,
but it affects migration.  I'm not sure how much we should care about
migration of the aarch32 guest though (and it will be resolved once ID
registers become configurable anyway).

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
