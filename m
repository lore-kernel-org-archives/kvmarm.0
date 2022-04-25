Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56736C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 25 Apr 2022 17:26:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D03EB4B266;
	Mon, 25 Apr 2022 13:26:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xNc89xIB6yHr; Mon, 25 Apr 2022 13:26:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CBEDA4B24D;
	Mon, 25 Apr 2022 13:26:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88EC14B242
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 13:26:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id so3N6tMmppwb for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Apr 2022 13:26:41 -0400 (EDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com
 [209.85.167.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 712DB4B229
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 13:26:41 -0400 (EDT)
Received: by mail-lf1-f50.google.com with SMTP id x17so27439433lfa.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 10:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ha/LOnKGhTGVaztiB1JL1yTrZhDFJAw4NzQBXSs32Ng=;
 b=ACxvZKfaGvgVZaysmoOgq+T93j3yCM4R01sMQMFvsNCcg2mSZRVtHmalMKsO15xE2C
 kNPcuM//xAXKxdPasBwQ0p3tUJhi98neEiJfFnKLW/U8J32zyh95szJpqh+tZWXHfumb
 DBUosvntVNDoifE1mIcDRE6/BjJ6y5b1v+C+HCaHScoRdVxgafrL9S8X/CelblJ6GYBZ
 +IIPH7XjHcLmHqJUis4wR8pB4H5g1uZnIC8e1x6+bB+LTDWNqkrvHJZKngsWFtFDEtO+
 Nyn260vtbZF9nLDeNde1lqsQ1xDwypX5e0PpE5v5DbBWx+g9Pa+Yioul3sa92SXdoqVw
 yVrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ha/LOnKGhTGVaztiB1JL1yTrZhDFJAw4NzQBXSs32Ng=;
 b=CvT2zibqfjnfJPt3aJqixvV+l9tflSYTeL//eZ1pNQxIwvw2m5GyabjH96RPe1SecQ
 P8ZQ6Cvv9gShPh0sLkYmtwGUMHRrPJE5ZUk/CHjnvfTzrgv8uWjw9rL6aNFoj2rTPlCC
 TJDEJeVUfrwsVLc18MyGXYEvZ8OdUomu8cC3F7MPFpQsj2VrmyEb4+a7PxufzHeKwUjK
 RBcNXolQ2UigJgkAAEFX3lc+zvprMBK1niXkPQ5RLtEwkNreDO+imGpVgQWOPbdTMZw9
 2m4G1x+9UfjjZjjS0wzt2zzopuAzTXAMPl/hfTPYtxK5z1dxgr0qJAnoif58zHUsNvuQ
 v2oA==
X-Gm-Message-State: AOAM53326s1QW+tfXfr6nYbKq0rFovLWlFr9u6dYQZK+KDQatHwEC9yo
 brh7P+jCa/fdrlABuAq0vtUpq7yF/csIoZVCUxpFRg==
X-Google-Smtp-Source: ABdhPJzM68lr0W5NEFudBKNRx7c+jwYJA0+DOpxrKiFAHQo8gznQckMNvnnqklGGRaUrAoL3MDJQ9O53GhnJXFjOark=
X-Received: by 2002:ac2:4ac9:0:b0:471:f6da:640d with SMTP id
 m9-20020ac24ac9000000b00471f6da640dmr9106672lfp.286.1650907599836; Mon, 25
 Apr 2022 10:26:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220425145530.723858-1-alexandru.elisei@arm.com>
 <875ymx9jbu.wl-maz@kernel.org>
In-Reply-To: <875ymx9jbu.wl-maz@kernel.org>
From: Oliver Upton <oupton@google.com>
Date: Mon, 25 Apr 2022 10:26:28 -0700
Message-ID: <CAOQ_Qsj+jVT49Lb9GgkYE8OEE2K_0qEJ1YstHvH3crpCNQehtQ@mail.gmail.com>
Subject: Re: [PATCH] KVM/arm64: Don't emulate a PMU for 32-bit guests if
 feature not set
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Howdy,

On Mon, Apr 25, 2022 at 10:14 AM Marc Zyngier <maz@kernel.org> wrote:
> Although I'm not opposed to this as an immediate workaround to avoid
> the ugly crash, I think sanitising the AArch32 regs is the way to go.
> Oliver had a stab at this a few weeks back[1], but this seem to have
> stalled.

Planning on sending out a new spin this week, I had been juggling a
few too many things since mailing that one out :) I was honestly
surprised nothing had blown up yet!

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
