From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PULL 0/8] KVM/ARM Changes for v4.14
Date: Tue, 5 Sep 2017 17:07:01 +0200
Message-ID: <CAMJs5B_jCsWupkGZOeRz-H4jApfDojV4V_52Q9ccjE1OyCT1qA@mail.gmail.com>
References: <20170905145207.18447-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E0DC49C1C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Sep 2017 11:04:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DLPbFy8US7xj for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Sep 2017 11:04:39 -0400 (EDT)
Received: from mail-pg0-f51.google.com (mail-pg0-f51.google.com [74.125.83.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E2CBC40A86
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Sep 2017 11:04:38 -0400 (EDT)
Received: by mail-pg0-f51.google.com with SMTP id 188so6699204pgb.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Sep 2017 08:07:03 -0700 (PDT)
In-Reply-To: <20170905145207.18447-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Sep 5, 2017 at 4:51 PM, Christoffer Dall <cdall@linaro.org> wrote:
> Hi Paolo and Radim,
>
> Here are the changes for KVM/ARM for v4.14.
>
> The changes are mostly bug fixes which are cc'ed stable.
>
> We also have some minor cleanups and improvements, including added
> support for migrating the active priority of interrupts when running a
> GICv2 guest on a GICv3 host.
>
> Sorry about arriving with these rather late.
>
> The following changes since commit 5771a8c08880cdca3bfb4a3fc6d309d6bba20877:
>
>   Linux v4.13-rc1 (2017-07-15 15:22:10 -0700)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-v4.14
>
> for you to fetch changes up to f3470ce68ee2917ea17d27521b379af117b48c02:
>
>   KVM: arm/arm64: Support uaccess of GICC_APRn (2017-09-05 16:46:30 +0200)
>
>

Whoops, it would appear that Marc already sent you the first two.
Please ignore this request, I'll send another.

Thanks,
-Christoffer
