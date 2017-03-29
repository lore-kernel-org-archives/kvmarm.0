From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: host stalls when qemu-system-aarch64 with kvm and pflash
Date: Wed, 29 Mar 2017 19:34:11 +0100
Message-ID: <CAFEAcA-9nVNUMiSDDNsoMHTdJggJpL=3-7bK+jVoT7MSC3J_CA@mail.gmail.com>
References: <CAC8NTUUWuH4k7SZSus_hz6a6V+OLGYUFcSOUwVbji2YDAZbVdQ@mail.gmail.com>
 <20170328201623.GD20211@cbox>
 <CAC8NTUVPoH=ZiJ51EoOLPKhsyGKo5iszkhHzb5K8Heax3n2KuA@mail.gmail.com>
 <CAC8NTUWHysUbj_MuL5DG4oxAe4W=qDQ65o4bQ5TN2W+YqX8aRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BED7540284
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Mar 2017 14:32:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Jlx6NwqdE4Y0 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Mar 2017 14:32:31 -0400 (EDT)
Received: from mail-wr0-f174.google.com (mail-wr0-f174.google.com
 [209.85.128.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF7CF40019
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Mar 2017 14:32:31 -0400 (EDT)
Received: by mail-wr0-f174.google.com with SMTP id k6so21453505wre.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Mar 2017 11:34:32 -0700 (PDT)
In-Reply-To: <CAC8NTUWHysUbj_MuL5DG4oxAe4W=qDQ65o4bQ5TN2W+YqX8aRA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Radha Mohan <mohun106@gmail.com>
Cc: Christoffer Dall <cdall@linaro.org>, QEMU Developers <qemu-devel@nongnu.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 29 March 2017 at 19:17, Radha Mohan <mohun106@gmail.com> wrote:
>> I will also try with qemu 2.8 and see.
>
> Same issue with 2.8.0 and 2.7.1 qemu version.

Thanks for checking -- good to know it's not a regression
on the QEMU side. (If you can soft-lockup the host it's
clearly a host kernel bug, but it might have been that
we changed something recently to provoke it.)

thanks
-- PMM
