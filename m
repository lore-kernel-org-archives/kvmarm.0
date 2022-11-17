Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5053417E0
	for <kvmarm@lists.linux.dev>; Thu, 17 Nov 2022 06:55:14 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id l2so750586pld.13
        for <kvmarm@lists.linux.dev>; Wed, 16 Nov 2022 22:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=ptKTmUufh9HK8z0sAwf51LoKiqEl7xpFdJchDYFQhZQc9TTiRFlX86VoFLQTI+T/16
         1pX0C5F68+Uj7kNZeHufs88Do/PykLuB623yGdg6R1GDK2oaDZCjRTzqvybLuNGpobuG
         ynwvdHze5Iah1c9zJdFPwUjc5o2B0refGQiuHxr/sPx9v9D6yjMWfun9Ui3J/OyLBNyj
         iH+HfhutW0o9CeQKBrRHVYkhcRvClUCdtHPwbwmgBMvXQSQJS5v99x8LEWTTLvS7A9+2
         h0xLiXN6/18NCYInoFsLm9AxSpD2qSmawL1Z5GraX6vrThC6Vxg2VH77+0T8T8xu2BBA
         Pn8w==
X-Gm-Message-State: ANoB5pm2XIDvCBpQjco/4RINgm7SpnDCc7aBAW6GCbe8QoEIIjM34P5p
	IORWui3LUKF4pG2GtEqeHriZPKqselhfl46JCkRY+w==
X-Google-Smtp-Source: AA0mqf7tSFrAZEMwmVmmUbqLCEc3pBNl7lqKOL+eWOL+gkt0uZHRyU+pxKg569MjVOU21bkykdSb6tDYkG3Bmcz6qvc=
X-Received: by 2002:a17:90a:bd11:b0:206:64cd:4797 with SMTP id
 y17-20020a17090abd1100b0020664cd4797mr1454425pjr.103.1668668113644; Wed, 16
 Nov 2022 22:55:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org> <20221113163832.3154370-7-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-7-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 16 Nov 2022 22:54:57 -0800
Message-ID: <CAAeT=FzPpotx-g1e_cqZx79DOgxuJEgKo4zudC_0b_Qd3Cz5FQ@mail.gmail.com>
Subject: Re: [PATCH v4 06/16] KVM: arm64: PMU: Only narrow counters that are
 not 64bit wide
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221117065457.BnsM1mfDQzL6-0W6ICnu5Zs4TIhN7DKxdAZz7tHa0kg@z>

On Sun, Nov 13, 2022 at 8:38 AM Marc Zyngier <maz@kernel.org> wrote:
>
> The current PMU emulation sometimes narrows counters to 32bit
> if the counter isn't the cycle counter. As this is going to
> change with PMUv3p5 where the counters are all 64bit, fix
> the couple of cases where this happens unconditionally.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
