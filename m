Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB045ECAAA2
	for <kvmarm@archiver.kernel.org>; Fri, 26 Aug 2022 00:59:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C7E44E3AF;
	Thu, 25 Aug 2022 20:59:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Bcxmq75uBe9s; Thu, 25 Aug 2022 20:59:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 441814E3B0;
	Thu, 25 Aug 2022 20:59:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14CAD4E3AC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 20:59:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id moqZ2HGeqaM4 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Aug 2022 20:59:49 -0400 (EDT)
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com
 [209.85.222.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3275D4E3AB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 20:59:49 -0400 (EDT)
Received: by mail-ua1-f49.google.com with SMTP id i11so44375ual.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 17:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc;
 bh=Nli7Lqv/iLJ91SrMgnfSlaqiEwBg1Xz1DfrVtIbRpJA=;
 b=baHVdsjMKFiRtUU6rg+ySj++qyTShUppqNX7xVpJE7BneDnKTdGiI4zae0Ht5KSeS1
 o6SvB7uMMyvng2nz81GAXOReUausBF/p9+ei4z9h31mJ1ODnZIbQtrJVifYwlZkA82AL
 qiAN/HLbA1JkUVpyA3xDJndnVK6qRNV/X7A3O5Ou6zH26MFzIFPa8L93LbIelxS4OUz6
 B/ZHk4b9f+0dk4DbQwA/J3pWvfGAqd39PdzbpFfJ/dzwkvr1OwYyNkEqj7Wh2yTHRTs4
 Id1SkCcVeUTGEJXeaoEW8WeUJTuncisDh6mpyv9VCmxwOU4ktF8ZS9Sum2qPJG85FFaf
 x08A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=Nli7Lqv/iLJ91SrMgnfSlaqiEwBg1Xz1DfrVtIbRpJA=;
 b=ElrIM2KM7BJ1XF+vtZSoj0sSMtzdmNh3cLY2LZHnYG6mAopCycIeSnuYBNroe39zzN
 u/SAlzNMxkaO5HH4FVoQhFN/I4UgGhGeQTUGx6n/SgeNgmxGN8WKoclCer09EKb3n/YP
 pMIbWPrN5VXSnijsQptYmDqbmBcgqhGQdRoFGFEzaGewiY7i7MoQXHwuqSUNq8FaovIV
 ++Eln6h48OyZfJCQky2zTifYBAbkrj7vc/sAYgkFzUgalEK0DLH1CB/gRRVH1kHNO25a
 9TShGeIt9RjhWLah61zbnAn28SqlQ6LmHwfCnzwiYHms0jHPxmF/8vpUUyhbie7+wftO
 KYsw==
X-Gm-Message-State: ACgBeo1ouCKjrZqpwp9PWn/JOc4Vk9f3kRSd1VQ+GlkFsIq0hL8kfpY1
 Q36K2UmbqbFgUDgTavbENLzPFNvFCoIBJxjGvTuECg==
X-Google-Smtp-Source: AA6agR7HwiDBsuw7STNcKz4WrRkm87dl2weKr4NcFWuZmrhojV0KLt2JoG7FnfoctJ7jGDiYHKvwr6nkthzrj3Ip22I=
X-Received: by 2002:ab0:13ed:0:b0:39a:2447:e4ae with SMTP id
 n42-20020ab013ed000000b0039a2447e4aemr2392200uae.37.1661475588658; Thu, 25
 Aug 2022 17:59:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com>
 <20220825050846.3418868-6-reijiw@google.com>
 <YwexdqgGpN43qYyy@google.com>
In-Reply-To: <YwexdqgGpN43qYyy@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 25 Aug 2022 17:59:33 -0700
Message-ID: <CAAeT=FzjsQ7UaRhvLRt_++PDzA5G294ze5DRON6MZx51DzCjZg@mail.gmail.com>
Subject: Re: [PATCH 5/9] KVM: arm64: selftests: Have debug_version() use
 cpuid_get_ufield() helper
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Andrew Jones <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Thu, Aug 25, 2022 at 10:29 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> On Wed, Aug 24, 2022 at 10:08:42PM -0700, Reiji Watanabe wrote:
> > Change debug_version() to use cpuid_get_ufield() to extract DebugVer
> > field from the AA64DFR0_EL1 register value.
>
> Either squash this into the patch that adds the field accessors or
> reorder it to immediately follow said patch.
>
> aarch64_get_supported_page_sizes() is also due for a cleanup, as it
> accesses the TGRANx fields of ID_AA64MMFR0_EL1.

Sure, I will fix them.

Thank you,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
