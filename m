Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D1E8C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 11 May 2022 14:12:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AAD6949EB2;
	Wed, 11 May 2022 10:12:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@brainfault-org.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id thynjmFejHSR; Wed, 11 May 2022 10:12:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51B7149F18;
	Wed, 11 May 2022 10:12:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D51B349EDF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2022 10:12:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 74hovBm229Wz for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 May 2022 10:12:40 -0400 (EDT)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com
 [209.85.128.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 700FC49EB2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2022 10:12:40 -0400 (EDT)
Received: by mail-wm1-f49.google.com with SMTP id
 m2-20020a1ca302000000b003943bc63f98so1310839wme.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2022 07:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=brainfault-org.20210112.gappssmtp.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=RSGHn1F0BncOfTcKYhrKyIk0Nc9jRJLzLB3ecNcIZy4=;
 b=jW12ZwQnnCztcNwkigLKzLeyKxuLaypSdNh5RLphYPfrxCmn7JNKcAFQyhsDExQ715
 wJwjtZki4XfUaxqAYliizclV7JqcbjMJZH3O294nmneM4g9jdOzsk+Y7dwWTdMhJNmFr
 luTgFG70VKGd5rBsQuYZFTUjRfEcJ0/y7nPhAyW1ERcls1P51FqhBYBEYo8vF1V2mXNd
 8SRsu7Z8MrurgPTYpBt1TQjav+1DEREjLXAbJ0D6pm6Q+pDArYfJ2vpNCWaWnM02wpn/
 0SNSQoIcK+vj+GrpRIllI9L4jtsan3nrlQwi8mHwvPTLx1sPHdv/4t0fc5sKaLD/XZ2s
 9LPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=RSGHn1F0BncOfTcKYhrKyIk0Nc9jRJLzLB3ecNcIZy4=;
 b=5DVs6YB6LqxDpZyxMidawDuc2oeKDU8/+6R6m6PbEFbTtqPTBpXk7lwyfjAR6IDVhZ
 ODJTiMJ/1WNQRE6UCF9Ln1iYC3UUkhKVel4AvEjwwkRmRrGrEmOf/etHLVj3y4mJWlQB
 in2AgdQkR20DDCNFvFoCVQkbrcr2SywgYbp/ndtB4NLc8nIHC98/Jlp5js8L7PPOy31K
 s3UOQef3KoilWNb/ZiefCpX8+r7P4mvJmk3Saua7d9XoCiaKnVw9XH9c0rg/kkzRHLXw
 +apJv7gwt8NBS1sZVMAKH1V+F+QfTvnRWPYJU95dpJBRnIMTwDVENyP1yGuEdIWebT4G
 yIQw==
X-Gm-Message-State: AOAM5323Xa8qKdsnARiYKdr8n8rTUNrHADk1BTDvazL0caUKLBFCQJIo
 tI+0yNcm0tV0UJ4sTLUmFL6DuzuFujqZBEnrPDjFeA==
X-Google-Smtp-Source: ABdhPJx0EgilpXqO9xhDBZma49ZiZYBQW1CYQalIbu7JvciYQUGx6pSOeqXv1MQtlngcxiEp7hb87+4QPXM1UtmgtzY=
X-Received: by 2002:a05:600c:1d08:b0:394:54ee:c994 with SMTP id
 l8-20020a05600c1d0800b0039454eec994mr5072481wms.137.1652278359083; Wed, 11
 May 2022 07:12:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220511120621.36956-1-guozhengkui@vivo.com>
In-Reply-To: <20220511120621.36956-1-guozhengkui@vivo.com>
From: Anup Patel <anup@brainfault.org>
Date: Wed, 11 May 2022 19:42:27 +0530
Message-ID: <CAAhSdy3Ynx-8DgDEE6huye2nA_21CV6cN=keopaCJOK2b00k5g@mail.gmail.com>
Subject: Re: [PATCH] selftests: kvm: replace ternary operator with min()
To: Guo Zhengkui <guozhengkui@vivo.com>
Cc: zhengkui_guo@outlook.com, Albert Ou <aou@eecs.berkeley.edu>,
 Janosch Frank <frankja@linux.ibm.com>,
 "open list:KERNEL VIRTUAL MACHINE \(KVM\)" <kvm@vger.kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 David Hildenbrand <david@redhat.com>, open list <linux-kernel@vger.kernel.org>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>,
 "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Paolo Bonzini <pbonzini@redhat.com>,
 "open list:RISC-V ARCHITECTURE" <linux-riscv@lists.infradead.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Shuah Khan <shuah@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <linux-arm-kernel@lists.infradead.org>
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

On Wed, May 11, 2022 at 5:38 PM Guo Zhengkui <guozhengkui@vivo.com> wrote:
>
> Fix the following coccicheck warnings:
>
> tools/testing/selftests/kvm/lib/s390x/ucall.c:25:15-17: WARNING
> opportunity for min()
> tools/testing/selftests/kvm/lib/x86_64/ucall.c:27:15-17: WARNING
> opportunity for min()
> tools/testing/selftests/kvm/lib/riscv/ucall.c:56:15-17: WARNING
> opportunity for min()
> tools/testing/selftests/kvm/lib/aarch64/ucall.c:82:15-17: WARNING
> opportunity for min()
> tools/testing/selftests/kvm/lib/aarch64/ucall.c:55:20-21: WARNING
> opportunity for min()
>
> min() is defined in tools/include/linux/kernel.h.
>
> Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Thanks,
Anup

> ---
>  tools/testing/selftests/kvm/lib/aarch64/ucall.c | 4 ++--
>  tools/testing/selftests/kvm/lib/riscv/ucall.c   | 2 +-
>  tools/testing/selftests/kvm/lib/s390x/ucall.c   | 2 +-
>  tools/testing/selftests/kvm/lib/x86_64/ucall.c  | 2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> index e0b0164e9af8..00be3ef195ca 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> @@ -52,7 +52,7 @@ void ucall_init(struct kvm_vm *vm, void *arg)
>          * lower and won't match physical addresses.
>          */
>         bits = vm->va_bits - 1;
> -       bits = vm->pa_bits < bits ? vm->pa_bits : bits;
> +       bits = min(vm->pa_bits, bits);
>         end = 1ul << bits;
>         start = end * 5 / 8;
>         step = end / 16;
> @@ -79,7 +79,7 @@ void ucall(uint64_t cmd, int nargs, ...)
>         va_list va;
>         int i;
>
> -       nargs = nargs <= UCALL_MAX_ARGS ? nargs : UCALL_MAX_ARGS;
> +       nargs = min(nargs, UCALL_MAX_ARGS);
>
>         va_start(va, nargs);
>         for (i = 0; i < nargs; ++i)
> diff --git a/tools/testing/selftests/kvm/lib/riscv/ucall.c b/tools/testing/selftests/kvm/lib/riscv/ucall.c
> index 9e42d8248fa6..34f16fe70ce8 100644
> --- a/tools/testing/selftests/kvm/lib/riscv/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/riscv/ucall.c
> @@ -53,7 +53,7 @@ void ucall(uint64_t cmd, int nargs, ...)
>         va_list va;
>         int i;
>
> -       nargs = nargs <= UCALL_MAX_ARGS ? nargs : UCALL_MAX_ARGS;
> +       nargs = min(nargs, UCALL_MAX_ARGS);
>
>         va_start(va, nargs);
>         for (i = 0; i < nargs; ++i)
> diff --git a/tools/testing/selftests/kvm/lib/s390x/ucall.c b/tools/testing/selftests/kvm/lib/s390x/ucall.c
> index 9d3b0f15249a..665267c1135d 100644
> --- a/tools/testing/selftests/kvm/lib/s390x/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/s390x/ucall.c
> @@ -22,7 +22,7 @@ void ucall(uint64_t cmd, int nargs, ...)
>         va_list va;
>         int i;
>
> -       nargs = nargs <= UCALL_MAX_ARGS ? nargs : UCALL_MAX_ARGS;
> +       nargs = min(nargs, UCALL_MAX_ARGS);
>
>         va_start(va, nargs);
>         for (i = 0; i < nargs; ++i)
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> index a3489973e290..2ea31a0ebe30 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> @@ -24,7 +24,7 @@ void ucall(uint64_t cmd, int nargs, ...)
>         va_list va;
>         int i;
>
> -       nargs = nargs <= UCALL_MAX_ARGS ? nargs : UCALL_MAX_ARGS;
> +       nargs = min(nargs, UCALL_MAX_ARGS);
>
>         va_start(va, nargs);
>         for (i = 0; i < nargs; ++i)
> --
> 2.20.1
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
