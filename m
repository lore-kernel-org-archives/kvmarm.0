From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH kvm-unit-tests] arm/arm64: gicv3: support two
 redistributor regions
Date: Tue, 4 Sep 2018 01:49:11 +0100
Message-ID: <CAFEAcA-eb=k1SVS2k4GenTEUsKuLYdx1DJ1SzTk-bHYaJcY-zg@mail.gmail.com>
References: <20180903164507.24544-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E38A49F86
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 20:49:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GzrUISy2Lnqf for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Sep 2018 20:49:32 -0400 (EDT)
Received: from mail-oi0-f66.google.com (mail-oi0-f66.google.com
 [209.85.218.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 536CB49E3E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 20:49:32 -0400 (EDT)
Received: by mail-oi0-f66.google.com with SMTP id t68-v6so3547205oie.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 03 Sep 2018 17:49:32 -0700 (PDT)
In-Reply-To: <20180903164507.24544-1-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 3 September 2018 at 17:45, Andrew Jones <drjones@redhat.com> wrote:
> We need to support two redistributor regions in order to support
> more than 123 vcpus. Also bump NR_CPUS to 512, since that's what
> KVM currently supports.

Wouldn't it be neater to support the arbitrary number
of redistributor regions that the h/w spec allows and
the dt can describe, rather than just the specific case
of 2 regions that QEMU happens to use ?

thanks
-- PMM
