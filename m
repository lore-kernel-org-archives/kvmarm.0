From: Vijay Kilari <vijay.kilari@gmail.com>
Subject: Re: [PATCH v4 0/5] arm/arm64: vgic-new: Implement API for vGICv3 live
 migration
Date: Mon, 12 Sep 2016 22:14:51 +0530
Message-ID: <CALicx6sqSf1yS61-tOHCX58oQC7UT+H-R2K6ztH+p=9KZCX+3w@mail.gmail.com>
References: <1473510138-4719-1-git-send-email-vijay.kilari@gmail.com>
 <57D6AA83.6060208@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E8E1410B5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2016 12:36:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V4+ZDdyrHVEb for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Sep 2016 12:36:11 -0400 (EDT)
Received: from mail-oi0-f65.google.com (mail-oi0-f65.google.com
 [209.85.218.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 52C3F40F9B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2016 12:36:10 -0400 (EDT)
Received: by mail-oi0-f65.google.com with SMTP id y2so18845866oie.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2016 09:44:52 -0700 (PDT)
In-Reply-To: <57D6AA83.6060208@arm.com>
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
Cc: Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Sep 12, 2016 at 6:45 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 10/09/16 13:22, vijay.kilari@gmail.com wrote:
>> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
>>
>> This patchset adds API for saving and restoring
>> of VGICv3 registers to support live migration with new vgic feature.
>> This API definition is as per version of VGICv3 specification
>> http://lists.infradead.org/pipermail/linux-arm-kernel/2016-July/445611.html
>>
>> Compatible live migration QEMU patches will be sent later.
>
> Could you please point to the QEMU patches as well? I need to be able to
> test the this infrastructure.

I just sent you corresponding QEMU patches.

Thanks
Vijay
>
> Thanks,
>
>         M.
> --
> Jazz is not dead. It just smells funny...
