From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v2 3/6] vfio: platform: reset: calxedaxgmac: add reset
 function registration
Date: Thu, 22 Oct 2015 13:54:42 +0200
Message-ID: <5628CE82.7090105@linaro.org>
References: <1445506922-6005-1-git-send-email-eric.auger@linaro.org>
 <1445506922-6005-4-git-send-email-eric.auger@linaro.org>
 <4810974.apRDTjc3oB@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C712412AF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2015 07:52:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Pmbls1CeZC3f for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Oct 2015 07:52:08 -0400 (EDT)
Received: from mail-wi0-f173.google.com (mail-wi0-f173.google.com
 [209.85.212.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7919040FAB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2015 07:52:08 -0400 (EDT)
Received: by wicfv8 with SMTP id fv8so116379607wic.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2015 04:54:45 -0700 (PDT)
In-Reply-To: <4810974.apRDTjc3oB@wuerfel>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Arnd Bergmann <arnd@arndb.de>
Cc: kvm@vger.kernel.org, patches@linaro.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, eric.auger@st.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 10/22/2015 12:13 PM, Arnd Bergmann wrote:
> On Thursday 22 October 2015 11:41:59 Eric Auger wrote:
>> This patch adds the reset function registration/unregistration.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
> Looks good, except one thing:
>> @@ -70,6 +69,8 @@ int vfio_platform_calxedaxgmac_reset(struct vfio_platform_device *vdev)
>>  			return -ENOMEM;
>>  	}
>>  
>> +	pr_info("VFIO reset of %s\n", vdev->name);
>> +
>>  	/* disable IRQ */
>>  	writel(0, reg.ioaddr + XGMAC_DMA_INTR_ENA);
>>  
> 
> This probably slipped in from debugging, please remove it.
Well actually this is not an oversight but some unappropriate tracing
attempt I am afraid. I wanted to add a trace useful for the end-user to
make sure the VFIO reset function was called. Do you forbid that or do
recommend to use another tracing mechanism/level? In the past I tried
dynamic tracing but with module loading mechanism I found it not that handy.

Eric
> 
> 	Arnd
> 
