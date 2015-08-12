From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: KVM Live migration with GICv3
Date: Wed, 12 Aug 2015 17:33:01 +0100
Message-ID: <CAFEAcA9X62T6J1StW2h+zPDiiKqqSjmYM1oRtsu0p6-FwaSrYg@mail.gmail.com>
References: <CALicx6soU-pqs3XgkEHxtBVy9yR-7irSU4ZJvC3D6V2UmKHQqA@mail.gmail.com>
 <009101d0d400$c92925f0$5b7b71d0$@samsung.com>
 <CALicx6s4BOuHsP40r2zuqgiLh+Rx=e=UQvwV5_R7LJB9-dpkig@mail.gmail.com>
 <019101d0d449$c6721210$53563630$@samsung.com> <55CB7195.2070505@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BA305A87A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2015 12:20:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FbyJAL88mV+e for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Aug 2015 12:20:14 -0400 (EDT)
Received: from mail-vk0-f51.google.com (mail-vk0-f51.google.com
 [209.85.213.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1286E5A46B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2015 12:20:13 -0400 (EDT)
Received: by vkhl6 with SMTP id l6so7975087vkh.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2015 09:33:20 -0700 (PDT)
In-Reply-To: <55CB7195.2070505@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 12 August 2015 at 17:17, Marc Zyngier <marc.zyngier@arm.com> wrote:
> If you plan to do anything for GICv3, you should only deal with with the
> system register version of the CPU interface.

Also, please make sure that you think about (and in terms of)
the underlying state inside the GIC, which is closely
related to but not necessarily identical to "contents of
all the registers". Migration cares about saving and restoring
state.

-- PMM
