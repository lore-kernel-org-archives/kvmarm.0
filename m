Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD80191
	for <kvmarm@lists.linux.dev>; Thu, 17 Nov 2022 03:07:39 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id l22-20020a17090a3f1600b00212fbbcfb78so4179807pjc.3
        for <kvmarm@lists.linux.dev>; Wed, 16 Nov 2022 19:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=OR5ThsLh9nRwRbxBNsfh7vFMMNU89ac1b7syi86HvzoiQHJ/9vP23BOswe+bkeCqJz
         xuFSNcuNsSPoYCMJ+oXgDl6iANVpeurvj+niDqO+QXj7WIWCSt/MV1rgcgLjjH6uSkBF
         PwFmSAHwCrTxRSYZhD8OCEtZVbpHHBa30/BPpnwpJFTpnfgIzruKivU8JTz77jqSO2mA
         i3ZHNDk22RGLIE2o2hs128ZsDeuyaMonAxpNzCUpjoq0n5INBi6AMxdNOH+Q1BOEVzUs
         ZfSDymxDVNuz2J7y96w/jRuXPkKIe7vLHPV5etAHKyE167+Jp2YIu8pvu35d7GPvByxs
         t+zw==
X-Gm-Message-State: ANoB5plOETabnsS9fgdxg84o8/40OQNCmZQHFUB37TMBtk49FDNpunET
	Ilx93qUzp2Qcuyu5t9WqbUjW8hEPwL3G82w91VOoWg==
X-Google-Smtp-Source: AA0mqf5jM3My1EFwIt/TwMaZZNxkmVEVeIgETQ8NwxHMtyqxBMr0+Vx0ky5+Ys2cY70a/jv7ld+2MVmtsd4eI1eTa5I=
X-Received: by 2002:a17:90a:ab84:b0:213:343:9873 with SMTP id
 n4-20020a17090aab8400b0021303439873mr6754073pjq.102.1668654458703; Wed, 16
 Nov 2022 19:07:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221117002350.2178351-1-seanjc@google.com> <20221117002350.2178351-2-seanjc@google.com>
In-Reply-To: <20221117002350.2178351-2-seanjc@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 16 Nov 2022 19:07:22 -0800
Message-ID: <CAAeT=Fx1u=H=5xvmaPxnv4osNwAqNT5c_K1XTfwT0HiPucn+gg@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: selftests: Disable single-step with
 correct KVM define
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221117030722.95BXjXej-zTGSlkZfEIFKwArlQ735VTY6O3p63T5GeU@z>

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
