From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/2] irq: add get_gsi callback
Date: Fri, 24 Apr 2015 11:29:25 +0200
Message-ID: <553A0CF5.9030304@redhat.com>
References: <1429778977-1632-1-git-send-email-eric.auger@linaro.org>
 <5538BBD3.9040404@redhat.com> <5538BE19.6030009@linaro.org>
 <5538C246.20304@redhat.com> <553A0657.6050100@linaro.org>
 <553A08D3.3020609@redhat.com> <553A0A4D.905@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87D034E652
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2015 05:21:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qdjptEo6ilHG for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Apr 2015 05:21:21 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 32D704E651
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2015 05:21:20 -0400 (EDT)
In-Reply-To: <553A0A4D.905@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com, qemu-devel@nongnu.org, alex.williamson@redhat.com, peter.maydell@linaro.org, agraf@suse.de
Cc: kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 24/04/2015 11:18, Eric Auger wrote:
>>> >> I implemented this alternative but my concern is the check method is
>>> >> called before the qemu_irq setting. So on this callback I cannot
>>> >> retrieve the qemu_irq VFIOINTp struct container object needed to setup
>>> >> irqfd hence does not work for me.
>> > 
>> > Isn't the qemu_irq passed as the third argument to the callback?  I
>> > thought this solution was fine because you weren't passing the "int n"
>> > from sysbus_connect_irq to your notifier.
> Yes it is. But I need to access the EventNotifiers for trigger &
> resample which were initialized before for eventfd trigger and stored in
> the container object. Will study if I can restructure the code ...

What did the notifier code look like with your patch?

Paolo
