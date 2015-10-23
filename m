From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v3 3/7] vfio: platform: introduce
 module_vfio_reset_handler macro
Date: Fri, 23 Oct 2015 16:10:59 +0200
Message-ID: <562A3FF3.5040004@linaro.org>
References: <1445603835-14506-1-git-send-email-eric.auger@linaro.org>
 <1445603835-14506-4-git-send-email-eric.auger@linaro.org>
 <3721718.lcvGuESNdi@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 007A4410EB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 10:08:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7Zq1YBecSDtR for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Oct 2015 10:08:24 -0400 (EDT)
Received: from mail-wi0-f170.google.com (mail-wi0-f170.google.com
 [209.85.212.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DEBCF41049
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 10:08:23 -0400 (EDT)
Received: by wicll6 with SMTP id ll6so33179530wic.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 07:11:03 -0700 (PDT)
In-Reply-To: <3721718.lcvGuESNdi@wuerfel>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, patches@linaro.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, eric.auger@st.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Arnd,
On 10/23/2015 03:09 PM, Arnd Bergmann wrote:
> On Friday 23 October 2015 14:37:11 Eric Auger wrote:
>> +static int __init reset ## _module_init(void)                  \
>> +{                                                              \
>> +       vfio_platform_register_reset(compat, reset);            \
>> +       return 0;                                               \
>> +};                                                             \
>>
> 
> I would make this 'return vfio_platform_register_reset(...)', so loading
> the driver fails if the handler cannot get registered. Alternatively,
> change the return type of vfio_platform_register_reset to 'void'
> so it can never fail.
I will turn __vfio_platform_register_reset to 'void' then since it has
no reason to fail now.

Thanks

Eric

> 
> 	Arnd
> 
