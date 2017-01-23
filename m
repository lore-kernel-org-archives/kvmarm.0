From: Vijay Kilari <vijay.kilari@gmail.com>
Subject: Re: [PATCH v10 0/8] arm/arm64: vgic: Implement API for vGICv3 live
 migration
Date: Mon, 23 Jan 2017 15:54:51 +0530
Message-ID: <CALicx6sCdPdS97Lcsfr0BGyW21FXBVfMyWPRDtNXAcFLXp29Yw@mail.gmail.com>
References: <1480576187-5012-1-git-send-email-vijay.kilari@gmail.com>
 <20170120195915.GK13531@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF18140986
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jan 2017 05:24:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AovTn5jN3slf for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Jan 2017 05:24:47 -0500 (EST)
Received: from mail-oi0-f41.google.com (mail-oi0-f41.google.com
 [209.85.218.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE06E40838
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jan 2017 05:24:47 -0500 (EST)
Received: by mail-oi0-f41.google.com with SMTP id j15so77396001oih.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jan 2017 02:24:52 -0800 (PST)
In-Reply-To: <20170120195915.GK13531@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Jan 21, 2017 at 1:29 AM, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> Hi Vijaya,
>
> On Thu, Dec 01, 2016 at 12:39:39PM +0530, vijay.kilari@gmail.com wrote:
>> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
>>
>> This patchset adds API for saving and restoring
>> of VGICv3 registers to support live migration with new vgic feature.
>> This API definition is as per version of VGICv3 specification
>> Documentation/virtual/kvm/devices/arm-vgic-v3.txt
>>
>> The patch 3 & 4 are picked from the Pavel's previous implementation.
>> http://www.spinics.net/lists/kvm/msg122040.html
>>
>> NOTE: Only compilation tested for AArch32. No hardware to test.
>>
>
> I'm mostly happy with this series at this point, and everything beyond
> the ABI discussion can be fixed later if we should spot anything.
>
> Assuming we can agree on the API for the level_info shortly, can you
> address the other comments in the series and reabse on v4.10-rc4 (or rc5
> if that's out when you get there) and send out a new version that we can
> queue?

OK.

Regards
Vijay
