From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2] target-arm: kvm: Differentiate registers based on
 write-back levels
Date: Wed, 22 Jul 2015 15:03:12 +0100
Message-ID: <CAFEAcA8RNjyXBXXbTDSyNuh0E0gDDm8YOgRhci+RaAnuOeHDQg@mail.gmail.com>
References: <1437046488-10773-1-git-send-email-christoffer.dall@linaro.org>
 <CAFEAcA_cyXztq2E007cOjmm7usq_KNJ4AsUXRCkNwyETibcfqg@mail.gmail.com>
 <20150717153901.GD14024@cbox> <55AF92EB.9050909@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EABB358FE8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2015 09:51:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gsq8XcRKHeA6 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jul 2015 09:51:21 -0400 (EDT)
Received: from mail-vn0-f51.google.com (mail-vn0-f51.google.com
 [209.85.216.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ADF0E58FE3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2015 09:51:21 -0400 (EDT)
Received: by vnav141 with SMTP id v141so48500988vna.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2015 07:03:31 -0700 (PDT)
In-Reply-To: <55AF92EB.9050909@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Claudio Fontana <claudio.fontana@huawei.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Jan Kiszka <jan.kiszka@web.de>, QEMU Developers <qemu-devel@nongnu.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 22 July 2015 at 13:56, Claudio Fontana <claudio.fontana@huawei.com> wrote:
>
> I can if you want check if this patch actually fixes the problem without the KVM workaround.
> Is this the version I am supposed to test, or should I wait for the next respin?

Fixed version went into master earlier this week, so test that...

thanks
-- PMM
