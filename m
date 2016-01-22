From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH V12 3/7] dma: add Qualcomm Technologies HIDMA management
 driver
Date: Fri, 22 Jan 2016 13:38:59 -0500
Message-ID: <56A27743.40008@codeaurora.org>
References: <1452523550-8920-1-git-send-email-okaya@codeaurora.org>
 <1452523550-8920-4-git-send-email-okaya@codeaurora.org>
 <20160115145629.GI3262@leverpostej> <56990C40.4050407@codeaurora.org>
 <20160115152257.GK3262@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E0E5411BE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jan 2016 13:34:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id REkaK9my-XtP for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jan 2016 13:34:25 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E60F8410EB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jan 2016 13:34:24 -0500 (EST)
In-Reply-To: <20160115152257.GK3262@leverpostej>
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
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, arnd@arndb.de, vinod.koul@intel.com, jcm@redhat.com, timur@codeaurora.org, linux-kernel@vger.kernel.org, marc.zyngier@arm.com, agross@codeaurora.org, dmaengine@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-msm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 1/15/2016 10:22 AM, Mark Rutland wrote:
> Typically VFIO-platform also comes with a corresponding reset driver.
> You don't need one?

Digging this further, I do need a HIDMA reset driver. The reset driver is useful if HIDMA 
operation is aborted in the middle and guest machine is shutdown. 

I'm preparing a reset driver and I'll post it soon. 

In the meantime, I have observed a lack of ACPI HID support in the platform reset interface
vfio_platform_lookup_reset and vfio_platform_probe_common specifically.

The interface is querying objects with "compatible" string. Of course on a true ACPI system
with proper named HIDs except PRP001, "compatible" attribute does not exist. I'm also preparing a
patch for this too.

Since VFIO patches go through another branch and the reset driver also needs to go through vfio along 
with the ACPI object querying support, would you like this to be addressed independently with a different series 
or have it reviewed altogether here then figure out the merge path later?

-- 
Sinan Kaya
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
