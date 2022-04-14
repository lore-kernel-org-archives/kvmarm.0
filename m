Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5714C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 14 Apr 2022 05:00:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 447D24B175;
	Thu, 14 Apr 2022 01:00:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DqGCLtIW4S0z; Thu, 14 Apr 2022 01:00:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40D024B105;
	Thu, 14 Apr 2022 01:00:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1CC34B105
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2022 01:00:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xuJTycOQWfnh for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Apr 2022 01:00:49 -0400 (EDT)
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com
 [209.85.216.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C5D8D4B0BE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2022 01:00:49 -0400 (EDT)
Received: by mail-pj1-f51.google.com with SMTP id md4so4071887pjb.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2022 22:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=G+uxBXn2CsAxnZsOAkfx1jrlhANZjdH2Cp3uCpCwX/Q=;
 b=ds/hJKiggiortsqecqFtGUrCyrcqkBHtAGput5CsQRJ0dw9pMAoowE2pq/91qZOd8t
 Ek0I1JpwDJhw4o5eWzICQ24kFHMxvifi12A85LhkF7QmHE1zmLsqqPEFM0mqiqWBMxtl
 SwpHErS9M143cM/R4Xalrjki7yZuxe+l4zWufOhfyRF1o7gQfDfcMnTFfP1vV1TlkuVF
 gPk1i3CLo0/u2dLpAj9uOQTOzU1n60JtRyN07f2l/gPQMFt49IYZ4lh6i0cNclX6dsS6
 rQUhxKNTGUnoGw4QqH75EmhmufQIpxUzKLh0hvYv6Z7keAVn4b/pY7PW3/ibY1ijNxaB
 V5AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=G+uxBXn2CsAxnZsOAkfx1jrlhANZjdH2Cp3uCpCwX/Q=;
 b=SVusmBKqOPYyzi9KKohIlk4h+vsqhvjIkfjLo7Y3kI3mjvJXhPRzeQ2l5ON7XJTHWV
 8mQ55dsfetBi+OgcZtvQEFF2j57CDSv9fKdEl9g9zgrqNNSHVAjnd98j1uc/xaD2/3rn
 cicl70bKhL/UM5EIuj+GvTgTrSQboihKf4H9KA2oCR673SSvRjcm+676vKljpFLTi5dk
 MWCVlpTEMhCxN1U3Fl+3rqW23S+LDesQqtIpWt6OeK9xynpBdvdo75x8S8af1HQ/IkMM
 kHdNDwYEBQ/X1TIrwCLv/x+B4v08I6OrlUmm7sdbCDnGHXC5MMNmwEAqgKaf1fqbO/kk
 tqZQ==
X-Gm-Message-State: AOAM533FrHJe2ApZeiQxlw3nbV4XgtnnVWJnx+YLS4hYxYmL6Ex7NWvP
 yi9PVdJu2aw3VTw3gcEEo5AAJchbQXf2a0TsoOdnSWG/+v6zIA==
X-Google-Smtp-Source: ABdhPJyLSdBGfP7VGWSb+ZOmT/YRV2i9sQeReQWr6TjWWrEU5MkTR0ZUVdVc7rqaYxu5HKB3hHhTfxeHACQ/lHPq128=
X-Received: by 2002:a17:902:c215:b0:153:8d90:a108 with SMTP id
 21-20020a170902c21500b001538d90a108mr45929939pll.172.1649912448731; Wed, 13
 Apr 2022 22:00:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com>
 <20220409184549.1681189-2-oupton@google.com>
In-Reply-To: <20220409184549.1681189-2-oupton@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 13 Apr 2022 22:00:32 -0700
Message-ID: <CAAeT=FwWB2d-Kea-BQxC--AXZXPSNJh2BoS0_ZMjaKs45rJmeg@mail.gmail.com>
Subject: Re: [PATCH v5 01/13] KVM: arm64: Don't depend on fallthrough to hide
 SYSTEM_RESET2
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
> Depending on a fallthrough to the default case for hiding SYSTEM_RESET2
> requires that any new case statements clean up the failure path for this
> PSCI call.
>
> Unhitch SYSTEM_RESET2 from the default case by setting val to
> PSCI_RET_NOT_SUPPORTED outside of the switch statement. Apply the
> cleanup to both the PSCI_1_1_FN_SYSTEM_RESET2 and
> PSCI_1_0_FN_PSCI_FEATURES handlers.
>
> No functional change intended.
>
> Signed-off-by: Oliver Upton <oupton@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
