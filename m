From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [Qemu-devel] [PATCH] virt: Lift the maximum RAM limit from 30GB
 to 255GB
Date: Fri, 26 Feb 2016 10:22:17 +0000
Message-ID: <CAFEAcA940YM=cbKTtEqO0yym9=WpXvVjPZMFCY0S4CWOVB1E0A@mail.gmail.com>
References: <1456402182-11651-1-git-send-email-peter.maydell@linaro.org>
 <CAFEAcA9d6u=2GLo5UEXGPzb=9bZNnk-CgEOt=235giCdPTW_pw@mail.gmail.com>
 <20160226080631.GB9352@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2865D48529
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 05:15:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wn2Njp7e7gEo for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Feb 2016 05:15:46 -0500 (EST)
Received: from mail-vk0-f53.google.com (mail-vk0-f53.google.com
 [209.85.213.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 216AD4130B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 05:15:45 -0500 (EST)
Received: by mail-vk0-f53.google.com with SMTP id e185so73171792vkb.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 02:22:36 -0800 (PST)
In-Reply-To: <20160226080631.GB9352@cbox>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, qemu-arm <qemu-arm@nongnu.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, QEMU Developers <qemu-devel@nongnu.org>, Patch Tracking <patches@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 26 February 2016 at 08:06, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> On Thu, Feb 25, 2016 at 04:51:51PM +0000, Peter Maydell wrote:
>> [Typoed the kvmarm list address; sorry... -- PMM]
>>
>> On 25 February 2016 at 12:09, Peter Maydell <peter.maydell@linaro.org> wrote:
>> > The virt board restricts guests to only 30GB of RAM. This is a
>> > hangover from the vexpress-a15 board, and there's inherent reason
>
> did you mean "there's *no* inherent reason" ?

Yes :-)

>> > for it. 30GB is smaller than you might reasonably want to provision
>> > a VM for on a beefy server machine. Raise the limit to 255GB.

>> > CC'ing kvm-arm as a heads-up that my proposal here is to make
>> > the kernel devs do the heavy lifting for supporting >255GB.
>> > Discussion welcome on whether I have the tradeoffs here right.
>
> I think so, this looks good to me.

> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

Thanks.
-- PMM
