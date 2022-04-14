Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C790C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 14 Apr 2022 05:41:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9426E4B15C;
	Thu, 14 Apr 2022 01:40:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ld7M7g1NC3tj; Thu, 14 Apr 2022 01:40:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FDD84B1B5;
	Thu, 14 Apr 2022 01:40:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDEC14B1AD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2022 01:40:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kJNw9-yf81Wx for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Apr 2022 01:40:55 -0400 (EDT)
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com
 [209.85.215.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AD2544B116
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2022 01:40:55 -0400 (EDT)
Received: by mail-pg1-f171.google.com with SMTP id r66so3877261pgr.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2022 22:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=r1hgtWRPVfebHCx6gQcTV3Yk+K2c4QLvXa3Krc4aE+I=;
 b=HBRAGQ+fdedq6sCWFdaUuiingyGqdqgL2NwOwh7l6M3C4+3PWTpWz9sRnQppY5X5es
 7zL11ImuBV9qw9CUu632h83AkbIugEf+Wh3BhJWXUIQvpLCrlUNg0ZRnRs/K0OIJJgIE
 U7waqA3D08+CyyXeODngDKP4KQqjF/RNNrraanYRpj42qi/53Gaz0k7e0FJd4LrbtxmL
 tH+zH7HWByi+PXc/ygxFCIGJ9NwqJ3hehDAjWHQsbAYUeXbzluepBluecyJ+Ur4mw+kk
 8AaTMogFL0FezD8IzqvmmU1nqmOhdEFT89J1yloUBBam5vF+xPbaa7Wa0piTFiQcyQt0
 1oRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=r1hgtWRPVfebHCx6gQcTV3Yk+K2c4QLvXa3Krc4aE+I=;
 b=0oz4nqCKtkcGRoM/mo2fckheBSQ1No/x8MjiTQS5SqkCDXC3on5SaEkd6Smv7x7XBK
 emGeU4FSSK626rT+1NJkg0BuauL8MKNqAANXLg4AgM14niHkVCevYFSYVT0KlGfNhOPm
 RRBkKoXozBll8lj4XpZFC83epscWc3AUKbvkKGFkWMk7ocfOZsHteJ6QPnooNYYGL/ht
 SNBw3XYsCWAcZ1/vitsE9O/6WLZnbH0lQwrzDjkLTnKmNNWOO8DJNbnsNs8ao6/LJ/Q4
 0cazsgprv2EhlGOdBGsuS4hPrjreX195Z6UL7gLsEGvS7YJEq/cQP3QWhGY216CRNbRz
 awVA==
X-Gm-Message-State: AOAM5327ZPc6r6T7GnFCerfK0EteQUn0g5597dMvI6mEauK2Gevm/lRM
 sUNqZVGHdLiJsy2z8HmX0bmC4R/v6aQL/+leldcZ0w==
X-Google-Smtp-Source: ABdhPJyisD+MrxCX0bQsCM+Yp8XfbbWBxwD7Q6y71Dzxvhi/l3pOb2vn2KwYoKHVe94g7haoXdRZFL7A2KgCb6+pK4o=
X-Received: by 2002:a05:6a00:9a2:b0:505:974f:9fd6 with SMTP id
 u34-20020a056a0009a200b00505974f9fd6mr2299540pfg.12.1649914854653; Wed, 13
 Apr 2022 22:40:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com>
 <20220409184549.1681189-6-oupton@google.com>
In-Reply-To: <20220409184549.1681189-6-oupton@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 13 Apr 2022 22:40:38 -0700
Message-ID: <CAAeT=FxBMy9jopi5O-L54Rk9AajvwdCSBdNdMozZ_a_OcBB5aA@mail.gmail.com>
Subject: Re: [PATCH v5 05/13] KVM: Create helper for setting a system event
 exit
To: Oliver Upton <oupton@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
 Peter Shier <pshier@google.com>, kvm-riscv@lists.infradead.org,
 Atish Patra <atishp@atishpatra.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

On Sat, Apr 9, 2022 at 11:46 AM Oliver Upton <oupton@google.com> wrote:
>
> Create a helper that appropriately configures kvm_run for a system event
> exit.
>
> No functional change intended.
>
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Oliver Upton <oupton@google.com>
> Acked-by: Anup Patel <anup@brainfault.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
