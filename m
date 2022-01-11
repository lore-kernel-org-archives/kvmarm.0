Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41FF6C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 11 Jan 2022 13:59:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A57E24B1F7;
	Tue, 11 Jan 2022 08:59:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zMg3rZYz6owC; Tue, 11 Jan 2022 08:59:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A04F4B1FC;
	Tue, 11 Jan 2022 08:59:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AF144B1E7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 08:59:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TeewQABFfbiu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Jan 2022 08:59:01 -0500 (EST)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com
 [209.85.221.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3BEBD4B1A9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 08:59:01 -0500 (EST)
Received: by mail-wr1-f41.google.com with SMTP id d19so2619896wrb.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 05:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Y0S24GbNlH/zMOK0Dq8vzMLE3BUZEfsOBAPd3kCGXLI=;
 b=xJIUuFglseW+loQm20MX0XfMvDv5bNtf6k5I/FwW4t8tvtjIN9Ko5fHkO0aHRyxbqj
 V8eOPXN3uoDJv4Mr69nuTUZOekiSNDrksGA8izGa1Qmqhspbi8mc7jRR1ELddP4+sLty
 PygolyxT5VLR0E0ie+2KsEomPgM68WLk5+H2U054Qfg9Ro6N4oHMkwJmjaf1RNwlI5aL
 FfthQ+9l2w6nKq7Ha8/C5KclTC2Tfud/iK2vNpT/4E1GelkhHoahcbL6V3kFrv6MytyR
 tnc7nYZ2f3fba9+Y2ix6C8g3MuvvBrUcH9n3WmFHLP+YBsWhtWVpCuSyvXYdx2ZrdglE
 yC/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Y0S24GbNlH/zMOK0Dq8vzMLE3BUZEfsOBAPd3kCGXLI=;
 b=SLymrSKH24p47uiDlRyxklEPgMuzLOCyfI/1S55ROKbANt5RzACv7dmRY8ACQe33xJ
 akJU+KR2XocJeycJNANAsVbI5yw7V526OtFuxOie0MnrTGinmLhrHPTEbl7yvQbvFILw
 CS9eUEX1fWo3KRyn2pN0fdi5NyACmgnjY1y3gA3Bt1Kxfe5fO5hiPg+eP08b8+Wxeoxl
 7jyHXhIPxRoWtu3a/zzPLp5nQNptxOajhGZK6dKgEtU9QyPskZnojYPdwKJLgf8WzsZl
 Ubms2vizx4uWx1xqBq/y6t8IBJzNe2neyZ3dwkf123/TGN4RDDrW+7xtbe5o+TghQ6sh
 f1ww==
X-Gm-Message-State: AOAM531KVgELvW0dz9QergJF3QgmYkRhKdYjAdbIUMfR6vPzH3yY5ErG
 XcjngI0osLAQUkciehZ8oJlFPW98J/cA6kOt9X/4rw==
X-Google-Smtp-Source: ABdhPJxSa/pjNGlZajE5AGDkqsOOzhaiVdqBzYlyttImUrEV5HxX+Ns0FRy1giAxhN66dwG5IAen+GYN7Aw3khMJMMA=
X-Received: by 2002:a5d:52c4:: with SMTP id r4mr4051250wrv.521.1641909540226; 
 Tue, 11 Jan 2022 05:59:00 -0800 (PST)
MIME-Version: 1.0
References: <20220107150154.2490308-1-maz@kernel.org>
 <a3d32f18-dbbb-e462-82ce-722f424707f9@linaro.org>
 <c9a3552aa067ba691055841b5e3fb7b7@kernel.org>
In-Reply-To: <c9a3552aa067ba691055841b5e3fb7b7@kernel.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 11 Jan 2022 13:58:49 +0000
Message-ID: <CAFEAcA8L5pH41cQ6srk9-JbMKNjdhCD7YpWcw4P06t83Jp11vw@mail.gmail.com>
Subject: Re: [PATCH v3] hw/arm/virt: KVM: Enable PAuth when supported by the
 host
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Richard Henderson <richard.henderson@linaro.org>,
 qemu-devel@nongnu.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Sat, 8 Jan 2022 at 13:42, Marc Zyngier <maz@kernel.org> wrote:
>
> On 2022-01-07 20:23, Richard Henderson wrote:
> > On 1/7/22 7:01 AM, Marc Zyngier wrote:
> >> @@ -1380,17 +1380,10 @@ void arm_cpu_finalize_features(ARMCPU *cpu,
> >> Error **errp)
> >>               return;
> >>           }
> >>   -        /*
> >> -         * KVM does not support modifications to this feature.
> >> -         * We have not registered the cpu properties when KVM
> >> -         * is in use, so the user will not be able to set them.
> >> -         */
> >> -        if (!kvm_enabled()) {
> >> -            arm_cpu_pauth_finalize(cpu, &local_err);
> >> -            if (local_err != NULL) {
> >> +        arm_cpu_pauth_finalize(cpu, &local_err);
> >> +        if (local_err != NULL) {
> >>                   error_propagate(errp, local_err);
> >>                   return;
> >> -            }
> >>           }
> >
> > Indentation is still off -- error + return should be out-dented one
> > level.
> >
>
> Duh. Clearly, my brain can't spot these. Apologies for the extra noise.
>
> > Otherwise,
> > Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>
> Thanks. I'll repost a version shortly, unless someone shouts.

Don't worry about it -- I've applied this to target-arm.next and
fixed the indent there.

-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
