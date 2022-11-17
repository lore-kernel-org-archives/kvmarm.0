Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F9E3C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 17 Nov 2022 06:55:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CE2E4B845;
	Thu, 17 Nov 2022 01:55:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tp4OQiL9Krab; Thu, 17 Nov 2022 01:55:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 364B04B826;
	Thu, 17 Nov 2022 01:55:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8CFB4B7FC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2022 01:55:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i-rD1PgxI+Nv for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Nov 2022 01:55:14 -0500 (EST)
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com
 [209.85.216.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC6C64B7BE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2022 01:55:14 -0500 (EST)
Received: by mail-pj1-f42.google.com with SMTP id t17so162980pjo.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 22:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=ufxDvLSDDXikRLOuIVMfp9fSGQBpXIXeB0N0kqgYhWg=;
 b=lphVdcKLOqU6XMwwXsfp8UJjZ4YvVzwfNjrrS86/KM1DX9fQBnL9coNdVkwnhcnLkG
 I5uOhio65rpvnLXU+BRJHDcfpgVCrFguCCt2lVJM1g6Wb8NAtiLNMkSk3nEmNv1rPTy2
 MU+rAcLgLmhgtAZZfgHxJr1KR2TrUcfcED5pQXGemidQyCw+xq5x6eeBVi+WaTCpGObx
 77wtjfJGwJyVA4j1IeVYatXkLQDzd8PcsSn5YQgKKufdMpjZAkXWU0BsQ9MfckX8xK13
 LaObeh6PpoONhM/H4C8YXVGlaiA0ZeRy4WFH7ecWAQJpJNExtwg+0gBNT9SJAp+JJh13
 Ewkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=ufxDvLSDDXikRLOuIVMfp9fSGQBpXIXeB0N0kqgYhWg=;
 b=hk1IjZmU/jxV0HMQyOjsmvTkBcjTd+ByzGYIrUcuogspRcg4TTRg47VKs5GsySuiPD
 2P0Hdl/x6BAZcCrQ4M7wlzws7ZmcfCvwmXgQyq1dmhfPL1dlca6hn10uEAWGNWGXdF6y
 HRSHbIbfvJ4mDpHIMFAfzWvwl5CC5SVLOolnv3n+9LioBclWod6NruhBZbYwmHyFj/D5
 XI4RjV1wSdJ37UR5Vz7VTK5XcAAtWXriyvXvtukQletsvGku0OtuZwnxfvzKypONVsyc
 we+e3KXQ//c1oyh4DovT0ogiTCMCdB8jaKeGFpBrkd7/vhpCb1SWiTy9hjbKgeQgGie5
 gxMw==
X-Gm-Message-State: ANoB5pl6Qdi6vNMWm+IVqLf/gxKud+ynwxHPVLdf5JWXBYPx+7faKsJK
 eMYTG4/RNRoKFDYWC6WEe5ZF5G1+T6a46/B7HyRbxA==
X-Google-Smtp-Source: AA0mqf7tSFrAZEMwmVmmUbqLCEc3pBNl7lqKOL+eWOL+gkt0uZHRyU+pxKg569MjVOU21bkykdSb6tDYkG3Bmcz6qvc=
X-Received: by 2002:a17:90a:bd11:b0:206:64cd:4797 with SMTP id
 y17-20020a17090abd1100b0020664cd4797mr1454425pjr.103.1668668113644; Wed, 16
 Nov 2022 22:55:13 -0800 (PST)
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org>
 <20221113163832.3154370-7-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-7-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 16 Nov 2022 22:54:57 -0800
Message-ID: <CAAeT=FzPpotx-g1e_cqZx79DOgxuJEgKo4zudC_0b_Qd3Cz5FQ@mail.gmail.com>
Subject: Re: [PATCH v4 06/16] KVM: arm64: PMU: Only narrow counters that are
 not 64bit wide
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

On Sun, Nov 13, 2022 at 8:38 AM Marc Zyngier <maz@kernel.org> wrote:
>
> The current PMU emulation sometimes narrows counters to 32bit
> if the counter isn't the cycle counter. As this is going to
> change with PMUv3p5 where the counters are all 64bit, fix
> the couple of cases where this happens unconditionally.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
