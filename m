Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDAE5C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  4 Apr 2022 01:51:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E730849EBD;
	Sun,  3 Apr 2022 21:51:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AgNkYDia7HS2; Sun,  3 Apr 2022 21:51:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7DE94B0EF;
	Sun,  3 Apr 2022 21:51:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EDE94A5A0
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Apr 2022 21:51:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZNa1iYnaEm4k for <kvmarm@lists.cs.columbia.edu>;
 Sun,  3 Apr 2022 21:51:33 -0400 (EDT)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
 [209.85.214.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 08AA249EBD
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Apr 2022 21:51:32 -0400 (EDT)
Received: by mail-pl1-f170.google.com with SMTP id y6so6974116plg.2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 03 Apr 2022 18:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=/HPdEv1u1dHBI9/8ZBUeRoQdCX9qorofNrQMRHwE/GM=;
 b=TH7dk7njieIgZMTiOMnEIMvq+kdoMWSqtMYSxG5nKkNG4lplBb6nOcZElTyYhgdDrp
 hR9rgg9oE2w1A7L4evuBKkZ258pqZoWl2wBuPX3QeTUN0fsmzRuh3Mi6Yxn1H37IQqg3
 X80ZJeF8GbE73f1zPSqOYhkLWEUPe0NE+5q76iLvJZ+4uFD40aOTQ8rkoBvoF0xBvVie
 CWx92BLBNo6CsWPLZOmC5jsJ/d8/XNmGI+oyuCS8ixp3agIFVepWHZjPhNcTQWmvgMX8
 GgSAV2Bj+pC7Xv0vAQQJIXIDDv67tLEX4dg644wEjpR/Eq+2cR+xwBxdTEZ3JJLdkvxM
 sqXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=/HPdEv1u1dHBI9/8ZBUeRoQdCX9qorofNrQMRHwE/GM=;
 b=5y10+NjZp8T60DAQs1m+SAqCr5tSTaaK/G0Bb4tU+AB3TpzWwoiSFLpNYJ8P/WVtBJ
 SfjLWwegvGSFKbRQHCCx16Apc3Ezt/t6BAt/oXFgm/Nc5/4InLHi6Kqy7wlkbV7AJccR
 zZVZ3BwB7gxSYsJbHfznDELcfAfbXjCf//w1c4wWmz972geGdl5NgD3y4pFwqTHxhbOD
 Wti8VpvBUVR/6Jtgk+t21dUspDKxDyrZI1jC8tEzBBBK3d8pHK2XITCr/nMZvSydgxQY
 lCbPGn3sPK9dVqfVtEVElR9MJ8hV+DzGiDMlKp9TVPBhV2iDNqqbVIKh1s1+QawkZgEk
 Lgxg==
X-Gm-Message-State: AOAM531TAAaPPSq+NnpA7HMNW3SqGU7lXYth73v+GCNIr3rmZMkOhjY6
 fCJWApPs+HWyHw512k3lnT9AKEwl7wk865ZyWKzutQ==
X-Google-Smtp-Source: ABdhPJxyxERsq7XOg9dz4MNtcUQNW88b6cSv75PSoe0iFwSBsyc+IpLz523KkiK7LrRy69grM1vP5GttYQgnmHlw9TY=
X-Received: by 2002:a17:902:c215:b0:153:8d90:a108 with SMTP id
 21-20020a170902c21500b001538d90a108mr21434704pll.172.1649037091972; Sun, 03
 Apr 2022 18:51:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220401010832.3425787-1-oupton@google.com>
 <20220401010832.3425787-2-oupton@google.com>
In-Reply-To: <20220401010832.3425787-2-oupton@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Sun, 3 Apr 2022 18:51:16 -0700
Message-ID: <CAAeT=Fy=aUNHq7zWYxYOLWvR-nOZr5Gdvu1yNiOisgtJ3SF1pw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] KVM: arm64: Wire up CP15 feature registers to
 their AArch64 equivalents
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
> KVM currently does not trap ID register accesses from an AArch32 EL1.
> This is painful for a couple of reasons. Certain unimplemented features
> are visible to AArch32 EL1, as we limit PMU to version 3 and the debug
> architecture to v8.0. Additionally, we attempt to paper over
> heterogeneous systems by using register values that are safe
> system-wide. All this hard work is completely sidestepped because KVM
> does not set TID3 for AArch32 guests.
>
> Fix up handling of CP15 feature registers by simply rerouting to their
> AArch64 aliases. Punt setting HCR_EL2.TID3 to a later change, as we need
> to fix up the oddball CP10 feature registers still.
>
> Signed-off-by: Oliver Upton <oupton@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
