Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBECAC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 06:59:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F7C54BD82;
	Fri, 15 Jul 2022 02:59:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Rx0nTpE-AU7Q; Fri, 15 Jul 2022 02:59:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 35DE24BD76;
	Fri, 15 Jul 2022 02:59:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D1E64BD6E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:59:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u9-fCl0dp+0l for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 02:59:45 -0400 (EDT)
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com
 [209.85.217.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2AA514B824
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:59:45 -0400 (EDT)
Received: by mail-vs1-f54.google.com with SMTP id j1so3501819vsr.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 23:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=9v+qQ9/0tophHLrpQx//eLF1ttOOmYgqB9pEWD7iCw8=;
 b=F/CzcXUe47hIrpdFe66HlTftbGIk3QG1VLgQR0e/kqDeRjJZqyht9j/9IvttzcDOKc
 8SdPSN0Kd4DBRuyWwKxmq9PquMUBkjATg9mBiLQRchfOlNI/WkOOsA7wZ1Ba4LYS5eCS
 6Cd4holvVZXLFRIkLG83JbXSbd46nvhDcpcsDhFj3WNfErI/6BCkbytd9pje7gmudF3D
 aPE9yGHNWT+YZzJcKN+sscbCJOZoGDvO7S2QxUpF6lE5TwfmcSBT0vxBTv+8Imz5sK/d
 PlslhVNu0DtIVJVfx898W5RRIH66GjzNG0ftjH5zJ5sL5CkdfoY0TQGBe0aVGmuGVaGz
 wH0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=9v+qQ9/0tophHLrpQx//eLF1ttOOmYgqB9pEWD7iCw8=;
 b=XHpKQ8byFpOD4Y9Jc4TgEPtD26P2zSG+UhJXm9uQ4Rw0LLF49i+z77V+ldwvwZlCAU
 JubFDXrX002MDSY0HX+ftk0p8LQ7yzrcD7Im+oLfx31K/0Gf0PzetDgS7H/hP6UyCulT
 uMTdkCq+KpzfiiL640RVvb7LvjFA7oXqnC8sQp3kFn93eSYGSEgAniMWDOCB2X/oGc+d
 Tx3g+HVVWtr2hlupxdvQSBsFFjEyt1qzshcYi7IGOZM8D/Jjf9Cu66Ng8ijvcHpQdE41
 dPsCYiK/RUpIivgq6ihJ5Qcc3P6jfDxi/kI9rGVC130Istvwi4Ok0mGNWE7yF9OY7cEs
 raxA==
X-Gm-Message-State: AJIora/+EVc1ne0lFFiHXduR1YVoSTVvl0NulC09NWF8CLSeR2PykbYn
 CN1eCTYJwBP8Xz5h8+oyqa9/rZ9wRd7NmzXQltY9dQ==
X-Google-Smtp-Source: AGRyM1sr0ShmlCy9/t1KZMf7KxdwU27MRr25tDvj76kxV+HvQRAvDwCn4B8rEbmPyJX67PTEmVUXT/b7MtCYpd4he1o=
X-Received: by 2002:a67:5c41:0:b0:356:20ab:2f29 with SMTP id
 q62-20020a675c41000000b0035620ab2f29mr5284432vsb.63.1657868384547; Thu, 14
 Jul 2022 23:59:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220714152024.1673368-1-maz@kernel.org>
 <20220714152024.1673368-5-maz@kernel.org>
In-Reply-To: <20220714152024.1673368-5-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 14 Jul 2022 23:59:28 -0700
Message-ID: <CAAeT=Fxqc7PN6K+T8P7LwZQSWMFivpyosPDaRnJtGQMJcHi8wg@mail.gmail.com>
Subject: Re: [PATCH v2 04/20] KVM: arm64: Rely on index_to_param() for size
 checks on userspace access
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kernel-team@android.com, Schspa Shi <schspa@gmail.com>,
 Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.cs.columbia.edu,
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

On Thu, Jul 14, 2022 at 8:20 AM Marc Zyngier <maz@kernel.org> wrote:
>
> index_to_param() already checks that we use 64bit accesses for all
> registers accessed from userspace.
>
> However, we have extra checks in other places, which is pretty
> confusing. Get rid on these checks.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
