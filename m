Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A6FCC4332F
	for <kvmarm@archiver.kernel.org>; Wed, 23 Nov 2022 06:08:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E961649F41;
	Wed, 23 Nov 2022 01:08:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M5bhjs5pDY8r; Wed, 23 Nov 2022 01:08:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCAC84B3F3;
	Wed, 23 Nov 2022 01:08:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E89F4B3D0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2022 01:08:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q6dX445CWaLb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Nov 2022 01:08:09 -0500 (EST)
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com
 [209.85.214.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7BC7249F41
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2022 01:08:09 -0500 (EST)
Received: by mail-pl1-f174.google.com with SMTP id jn7so13890062plb.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Nov 2022 22:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=h5tlKNi35V94k0QmV2ysH94Zb5ALfgaBlCa6CRxYIVw=;
 b=eEdddm6ebarYt7g7uJhWOnpgtypJcRMCmOrwuMaNVAA0C5aBaCucbUGx0fVJIOPlSW
 hNU/iCZT3w1eHA9yNvRVrKP4s/WGB5nWkZ5SNaTLoDMrZdetIXV7DUlzXgQ0ZI6O6D+6
 turNtaZkl1rWGQ25PWMZCrZdZetW0KQ5nSknO98LM/koczRsx+sr997Z6Y/nWEVSjfkg
 qVEcHzGhPUx8KY4y+poF1Ed4OUzls/fCfaCQ+ku5rLVm7nWR2Fvu/iFVPShBI//SIcTM
 EYWYxB+VjSWM0PzjWaZYoES2vXUzhfLJe96SE6tNaWrzXSI35zv+R9NxKDwCNWfzNNlH
 YRoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=h5tlKNi35V94k0QmV2ysH94Zb5ALfgaBlCa6CRxYIVw=;
 b=Z/boUenT0OUEgFsG7EIaCrQijkttcoC76QosFQpHBFFw0cG6h7ZhEtkW5ulCX6CC/n
 gCmfz54NzNjQ0Hc9Jwz3I1r+4NGBGMpqROndiU1eLv9u9o4Lbv/3KNeCvMw0DyBZaOCT
 P6GfN07zHYA7S8J4tgMtnP0N+QEJDB+z7yG2hefWn31GAbbI3ZHVc+Dq4CpAS3knLErw
 WJMThJYT/6tVYsTvD4aSRnJFr3E5WILI6ZNW+TnpZJthZ7DIZz5lIlU6myiwEWkedMmx
 AitSXUzWb3dMm+TJp8irrgeQ7LwvyJFbk4qogGsSYrr7cF0o8DEe2/GhWi7v0jxATvr1
 W0zw==
X-Gm-Message-State: ANoB5pkmrCvzCmytNNMCiQs8taLB7anB71fiJ+4FOOBAPLrSySpIFOMT
 RirgtDrHJpq+iuU73Ye+vSXYB4zGbw1KV83YkmCGRA==
X-Google-Smtp-Source: AA0mqf5lImrYjSG2qG8wHkOxPafuxpqJyZLTwqEDiwfRe0ptbYcQ09on7ZiYFobULDz+0AHmQt42G9VURGZZHsd0DAk=
X-Received: by 2002:a17:90a:e2c5:b0:214:1648:687d with SMTP id
 fr5-20020a17090ae2c500b002141648687dmr35554546pjb.78.1669183688483; Tue, 22
 Nov 2022 22:08:08 -0800 (PST)
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org>
 <20221113163832.3154370-15-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-15-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 22 Nov 2022 22:07:52 -0800
Message-ID: <CAAeT=FwKuB2mAhWaeDSVQnHyDnQrLnNAuZ+Z3=KoFZe5imiwXQ@mail.gmail.com>
Subject: Re: [PATCH v4 14/16] KVM: arm64: PMU: Allow PMUv3p5 to be exposed to
 the guest
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
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

On Sun, Nov 13, 2022 at 8:46 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Now that the infrastructure is in place, bump the PMU support up
> to PMUv3p5.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
