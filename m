From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v3 4/4] target-arm: Add the GICv2m to the virt board
Date: Tue, 26 May 2015 15:07:59 +0200
Message-ID: <5564702F.2030308@linaro.org>
References: <1432464666-4825-1-git-send-email-christoffer.dall@linaro.org>
 <1432464666-4825-5-git-send-email-christoffer.dall@linaro.org>
 <55646D0F.9040801@linaro.org>
 <CAFEAcA-NVfKXNOUo=3Li298wys-KFw1Vn9mVHbh+bc0aJ2efEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7502A520E2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2015 08:58:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GJqX0K969ir0 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 May 2015 08:58:29 -0400 (EDT)
Received: from mail-wg0-f48.google.com (mail-wg0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C3010520E1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2015 08:58:29 -0400 (EDT)
Received: by wghq2 with SMTP id q2so96663546wgh.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2015 06:08:08 -0700 (PDT)
In-Reply-To: <CAFEAcA-NVfKXNOUo=3Li298wys-KFw1Vn9mVHbh+bc0aJ2efEQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 05/26/2015 02:55 PM, Peter Maydell wrote:
> On 26 May 2015 at 13:54, Eric Auger <eric.auger@linaro.org> wrote:
>> Reviewed-by: Eric Auger <eric.auger@linaro.org>
>>
>> The only question I have is related to mid-term virt strategy about
>> GICv3 integration. Are we going to reuse that memory map for the machine
>> instantiating the GICv3? If yes, shouldn't we put the GICv2M somewhere
>> else to leave space for GICv3 redistributors, assuming we reuse the
>> shared distributor region. I understood the memory map is difficult to
>> change once applied once.
> 
> I wouldn't expect that you'd have a GICv2M at all in a
> system with a GICv3 in it, would you?

no indeed. but we currently use a single static a15memmap memory map in
virt. This one is currently planned to be reused for machines
instantiating GICv3 so we start seeing things like
VIRT_GIC_CPU =  VIRT_GIC_REDIST. I fear this is going to become messy.

What is your guidance, should we introduce new memory maps for GICv3
enabled machine or should we move to a single dynamic memory map?

Best Regards

Eric

> 
> -- PMM
> 
