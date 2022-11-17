Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D787C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 17 Nov 2022 03:07:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 726AB4B81F;
	Wed, 16 Nov 2022 22:07:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R+-fT2NIpfUh; Wed, 16 Nov 2022 22:07:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B5464B7B6;
	Wed, 16 Nov 2022 22:07:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00B784B7B6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 22:07:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bq5u+IC7Pj5s for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Nov 2022 22:07:39 -0500 (EST)
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com
 [209.85.216.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CF9B84B7A7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 22:07:39 -0500 (EST)
Received: by mail-pj1-f51.google.com with SMTP id gw22so465817pjb.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 19:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=pa5UqVHoKtSmMcTtq44P+OTbkS+eAwwWT8kOI+vqzfQ=;
 b=fGfwLJbYQdy/G/BDCUmvzEKCl86N3TtDPIxkdzCUUG5SxWXmkaqsjH4zxZjm+9EqQ3
 0DnbmWLdhVLD47jVGlDwt1Qi6cjG3CIXIHP5oC5CQ2zRR7QTACY9/Sb//2HfGoIVou2o
 lDypdJakoSkMG3OzQNBziXbuuQAqSMTXNI8tHZFEW3YYnLF489LAS1awa1C6y1UBWVUL
 2dEn1B0NeuQluzDRXry+DZBdotiZsXrloQg00i634wfHsCm6zZ+VSRzNBsejwHT7/IFV
 fuEAkUYy07DwH+JrjYGkN8EM7flnITG0xEK3F4svo31W7SWMBhULnsAp5qwRqfjTF03S
 Xx/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=pa5UqVHoKtSmMcTtq44P+OTbkS+eAwwWT8kOI+vqzfQ=;
 b=1Ru7o//o9y6afnq440wCvAgx+rXAEVUujaBarg8KVWvBlUWSxj+rYd4v5JaToYepBP
 /T4wzVFWxy9rwT+Q+6InltWqyPk1hAETEMUtrxyO5g40wsT2E/la36JGMz/g3T46WFIx
 XORAUiYe99UkVFvAkqrPkIQPWwP7Q2aZCE3SM4xwPRV30YkJ64qeSyGaAuRoVi6uuEo1
 m6NCqlK9vxIBWz1LfP00O3EkGGRe8GXXcm5tlvIi0rsFw59W2BY94Iq+v2E9f++MDMMM
 9EeGD/xG4KNkm+uIyXzpjnLplUJGgHUhrhx5lds1n8JKZM7Tw834QZsFZzcDBJTrrEAG
 dNLQ==
X-Gm-Message-State: ANoB5pnrbrzyEsUMQiVtOL8/qgJyEtas8AdXJoGjfahLZBSnXyWLavI6
 +Hq+RX1dcfo5UfBjQ3lOmJTYGBTQ7QghFwQ34PBgwg==
X-Google-Smtp-Source: AA0mqf5jM3My1EFwIt/TwMaZZNxkmVEVeIgETQ8NwxHMtyqxBMr0+Vx0ky5+Ys2cY70a/jv7ld+2MVmtsd4eI1eTa5I=
X-Received: by 2002:a17:90a:ab84:b0:213:343:9873 with SMTP id
 n4-20020a17090aab8400b0021303439873mr6754073pjq.102.1668654458703; Wed, 16
 Nov 2022 19:07:38 -0800 (PST)
MIME-Version: 1.0
References: <20221117002350.2178351-1-seanjc@google.com>
 <20221117002350.2178351-2-seanjc@google.com>
In-Reply-To: <20221117002350.2178351-2-seanjc@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 16 Nov 2022 19:07:22 -0800
Message-ID: <CAAeT=Fx1u=H=5xvmaPxnv4osNwAqNT5c_K1XTfwT0HiPucn+gg@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: selftests: Disable single-step with
 correct KVM define
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
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

On Wed, Nov 16, 2022 at 4:24 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Disable single-step by setting debug.control to KVM_GUESTDBG_ENABLE,
> not to SINGLE_STEP_DISABLE.  The latter is an arbitrary test enum that
> just happens to have the same value as KVM_GUESTDBG_ENABLE, and so
> effectively disables single-step debug.
>
> No functional change intended.
>
> Cc: Reiji Watanabe <reijiw@google.com>
> Fixes: b18e4d4aebdd ("KVM: arm64: selftests: Add a test case for KVM_GUESTDBG_SINGLESTEP")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/aarch64/debug-exceptions.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> index 947bd201435c..91f55b45dfc7 100644
> --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> @@ -369,7 +369,7 @@ void test_single_step_from_userspace(int test_cnt)
>                                                 KVM_GUESTDBG_SINGLESTEP;
>                                 ss_enable = true;
>                         } else {
> -                               debug.control = SINGLE_STEP_DISABLE;
> +                               debug.control = KVM_GUESTDBG_ENABLE;

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Maybe I originally wanted to set it to 0:)
There is no issue with KVM_GUESTDBG_ENABLE at all,
as KVM_GUESTDBG_SINGLESTEP is cleared with that.

Thank you for fixing this!

Thanks,
Reiji


>                                 ss_enable = false;
>                         }
>
> --
> 2.38.1.431.g37b22c650d-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
