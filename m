From: Kees Cook <keescook@chromium.org>
Subject: Re: [RFC 17/17] arm64: compile the kernel with ptrauth
 -msign-return-address
Date: Mon, 15 Oct 2018 15:38:53 -0700
Message-ID: <CAGXu5jL5v_Db9RnLYEJtFcGHYf3j023Kxd5eWvtpBjYYQorYMQ@mail.gmail.com>
References: <20181005084754.20950-1-kristina.martsenko@arm.com>
 <20181005084754.20950-18-kristina.martsenko@arm.com>
 <d0e36e1f-fa1a-f4ab-5a83-11e095801fef@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36DA949F94
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Oct 2018 18:38:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6G89diRsuVhE for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Oct 2018 18:38:58 -0400 (EDT)
Received: from mail-yb1-f195.google.com (mail-yb1-f195.google.com
 [209.85.219.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 60F6640493
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Oct 2018 18:38:57 -0400 (EDT)
Received: by mail-yb1-f195.google.com with SMTP id h1-v6so8148977ybm.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Oct 2018 15:38:57 -0700 (PDT)
Received: from mail-yw1-f50.google.com (mail-yw1-f50.google.com.
 [209.85.161.50])
 by smtp.gmail.com with ESMTPSA id i63-v6sm3060750ywa.74.2018.10.15.15.38.54
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Mon, 15 Oct 2018 15:38:54 -0700 (PDT)
Received: by mail-yw1-f50.google.com with SMTP id m129-v6so8179245ywc.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Oct 2018 15:38:54 -0700 (PDT)
In-Reply-To: <d0e36e1f-fa1a-f4ab-5a83-11e095801fef@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: linux-arch <linux-arch@vger.kernel.org>, Jacob Bramley <jacob.bramley@arm.com>, Arnd Bergmann <arnd@arndb.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Adam Wallis <awallis@codeaurora.org>, Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>, Kristina Martsenko <kristina.martsenko@arm.com>, Dave P Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Amit Kachhap <Amit.Kachhap@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 11, 2018 at 7:23 AM, Vladimir Murzin
<vladimir.murzin@arm.com> wrote:
> Hi Kristina,
>
> On 05/10/18 09:47, Kristina Martsenko wrote:
>> diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
>> index 106039d25e2f..dbcd43ea99d8 100644
>> --- a/arch/arm64/Makefile
>> +++ b/arch/arm64/Makefile
>> @@ -56,6 +56,10 @@ KBUILD_AFLAGS      += $(lseinstr) $(brokengasinst)
>>  KBUILD_CFLAGS        += $(call cc-option,-mabi=lp64)
>>  KBUILD_AFLAGS        += $(call cc-option,-mabi=lp64)
>>
>> +ifeq ($(CONFIG_ARM64_PTR_AUTH),y)
>> +KBUILD_CFLAGS        += -msign-return-address=all
>> +endif
>
> Should not it be done via cc-option so old toolchains keep working [1]?
>
> [1]
> $ aarch64-linux-gnu-gcc --version
> aarch64-linux-gnu-gcc (Linaro GCC 2014.11) 4.9.3 20141031 (prerelease)
> Copyright (C) 2014 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
>
> $ aarch64-linux-gnu-gcc -msign-return-address=all
> aarch64-linux-gnu-gcc: error: unrecognized command line option '-msign-return-address=all'
> ...

I would like to see CONFIG_ARM64_PTR_AUTH testing for compiler support
via Kconfig (as stack-protector does). This would allow developers to
only see the option if it was available (i.e. no "downgrade" happens
if the compiler is missing support). Using cc-option runs the risk of
building a kernel with CONFIG_ARM64_PTR_AUTH set, but _not_ actually
using ptr auth.

-Kees

-- 
Kees Cook
Pixel Security
