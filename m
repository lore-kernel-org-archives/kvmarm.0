From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 0/2] irq: add get_gsi callback
Date: Fri, 24 Apr 2015 13:59:25 +0200
Message-ID: <553A301D.3070503@linaro.org>
References: <1429778977-1632-1-git-send-email-eric.auger@linaro.org>
 <5538BBD3.9040404@redhat.com> <5538BE19.6030009@linaro.org>
 <5538C246.20304@redhat.com> <553A0657.6050100@linaro.org>
 <553A08D3.3020609@redhat.com> <553A0A4D.905@linaro.org>
 <553A0CF5.9030304@redhat.com> <553A115E.1050705@linaro.org>
 <553A14D3.1030300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C95D4E571
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2015 07:53:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ax9EzF9RCHBh for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Apr 2015 07:53:47 -0400 (EDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
 [209.85.212.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2FAFF4E30C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2015 07:53:46 -0400 (EDT)
Received: by wiun10 with SMTP id n10so17544807wiu.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2015 05:02:02 -0700 (PDT)
In-Reply-To: <553A14D3.1030300@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, eric.auger@st.com, qemu-devel@nongnu.org, alex.williamson@redhat.com, peter.maydell@linaro.org, agraf@suse.de
Cc: kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/24/2015 12:02 PM, Paolo Bonzini wrote:
> 
> 
> On 24/04/2015 11:48, Eric Auger wrote:
>>>> What did the notifier code look like with your patch?
>> Currently both notifiers are stored in the VFIOINTp struct. They are
>> initialized in vfio_init_intp. VFIO platform device holds a list of
>> VFIOINTp struct.
>>
>> When the vfio_start_irqfd callback is called the qemuirq is not yet
>> initialized so I cannot retrieve the EventNotifiers by container_of.
> 
> Understood better now.  I would pass the "Object **child" variable of
> object_set_link_property to the callback then (in qom/object.c).
> 
> Then I would go for the other solution (the notifier, just adding the
> callback to SysbusDeviceClass).  But I still do not understand why you
> didn't have exactly the same problem :) unless you were walking the list
> to find the relevant VFIOINTp.
Hi Paolo,

Yes I was walking the list ;-)

So is my understanding coherent: revert to first patch but moving
notifier in class

Thanks

Eric
> 
> Paolo
> 
>> I can allocate and initialize them in the callback but I need a place to
>> store them to close the eventfd.
>>
>> Also at the moment I start irqfd I must take some actions to stop (user
>> side) eventfd trigger; this also urges me to get access to VFIOINTp
>> struct. Some extracted pieces below (under work).
