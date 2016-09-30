From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH 0/3] Support userspace irqchip with arch timers
Date: Fri, 30 Sep 2016 17:38:11 +0200
Message-ID: <3e85d538-2539-f190-0d17-a2ecfe7b48ce@suse.de>
References: <20160927190806.22988-1-christoffer.dall@linaro.org>
 <de375a6e-095c-a17a-0db7-876a5619df42@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 991CF410D7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Sep 2016 11:28:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ow+mkQ3--gYg for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Sep 2016 11:28:42 -0400 (EDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9D4E240F77
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Sep 2016 11:28:42 -0400 (EDT)
In-Reply-To: <de375a6e-095c-a17a-0db7-876a5619df42@suse.de>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 30.09.16 16:54, Alexander Graf wrote:
> 
> 
> On 27.09.16 21:08, Christoffer Dall wrote:
>> Hi Alex,
>>
>> Marc and I have been looking at this during Linaro connect and have
>> slightly reworked your patch into this small series.
>>
>> It would be good if you could have a look at it and test it out.
>>
>> I've tested it with your QEMU, and it works for UP, but secondary CPUs
>> fail to come up, and it looks like the kernel never gets an IPI for
>> those CPUs from userspace.  Any chance you're willing to take a look at
>> that?
> 
> I still need to see whether I can come up with a prettier solution, but
> for now this works:
> 
> diff --git a/target-i386/kvm.c b/target-i386/kvm.c

Eh, no, not in i386 code :). But the problem seems to be a missing
mpstate sync.


Alex
