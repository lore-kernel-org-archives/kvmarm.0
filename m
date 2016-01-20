From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH V12 3/7] dma: add Qualcomm Technologies HIDMA management
 driver
Date: Wed, 20 Jan 2016 17:18:29 -0500
Message-ID: <56A007B5.9070502@codeaurora.org>
References: <1452523550-8920-1-git-send-email-okaya@codeaurora.org>
 <1452523550-8920-4-git-send-email-okaya@codeaurora.org>
 <20160115145629.GI3262@leverpostej> <56990CD4.6020405@arm.com>
 <20160115153656.GM3262@leverpostej> <569917C7.9000804@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DE384972F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jan 2016 17:14:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xgjwz+5jP0HI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jan 2016 17:14:00 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 23DBA49708
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jan 2016 17:13:59 -0500 (EST)
In-Reply-To: <569917C7.9000804@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, arnd@arndb.de, Marc Zyngier <marc.zyngier@arm.com>, jcm@redhat.com, timur@codeaurora.org, linux-kernel@vger.kernel.org, vinod.koul@intel.com, agross@codeaurora.org, dmaengine@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-msm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Mark,

On 1/15/2016 11:01 AM, Sinan Kaya wrote:
>> I'm concerned with how this is safe, and with the userspace interface.
>> > e.g. if the user wants to up the QoS for a VM, how to they find the
>> > right channel in sysfs  to alter?
> The HW supports changing the QoS values on the flight. In order to locate the
> object, I'm exporting a 
> 
> I tried to address your concern on v10 last series. Here is brief summary.
> 
> Each channel device has a sysfs entry named chid.
> What:		/sys/devices/platform/hidma-*/chid
> +		/sys/devices/platform/QCOM8061:*/chid
> 
> 
> Each management object has one priority and weight file per channel.
> +What:		/sys/devices/platform/hidma-mgmt*/chanops/chan*/priority
> +		/sys/devices/platform/QCOM8060:*/chanops/chan*/priority
> 
> Suppose you want to change the priority of a channel you assigned to guess,
> the userspace application goes and reads the chid value of the channel.
> 
> Then goes to chanops/chan<chid>/ directory and can change priority and weight 
> parameters here.
> 
> Here is how the directory looks like. QCOM8060:00 is a management object.
> QCOM8061:0x are the channel objects.
> 
> /sys/devices/platform/QCOM8060:00# ls
> QCOM8061:00
> QCOM8061:01
> QCOM8061:02
> QCOM8061:03
> QCOM8061:04
> QCOM8061:05
> chanops
> <other common attributes>
> 
> 
> 
> 


Did this answer your question? 

I'm capturing all the questions and answers as FAQ into the cover letter as I keep
repeating myself for every single reviewer.

Besides from the "lack of documentation", is there any code related change you'd like to
discuss in the series.


-- 
Sinan Kaya
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
