From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 11/13] KVM: arm64: implement ITS command queue command
 handlers
Date: Fri, 3 Jul 2015 16:57:04 +0100
Message-ID: <5596B0D0.3080505@arm.com>
References: <1432893209-27313-1-git-send-email-andre.przywara@arm.com>
 <1432893209-27313-12-git-send-email-andre.przywara@arm.com>
 <20150628194148.GM28244@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BFD7579A5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 11:45:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w6m+tya09Qwx for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jul 2015 11:45:47 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 420FF5799E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 11:45:46 -0400 (EDT)
In-Reply-To: <20150628194148.GM28244@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

....

>> +
>> +static struct its_collection *vits_new_collection(struct kvm *kvm, u32 coll_id)
>> +{
>> +	struct its_collection *collection;
>> +
>> +	collection = kmalloc(sizeof(struct its_collection), GFP_KERNEL);
> 
> If I manage to understand the structure here, you're calling all these
> handler functions with a spinlock held so any operation that may sleep
> could cause your system to deadlock.
> 
> I'll stop looking for these and recommend you go over the whole series
> for these.

Do you reckon it would be sufficient to just avoid the kmallocs inside
the lock? For this case above we could go with some storage space
preallocated outside of the lock (I hope).

> 
> Perhaps the right thing to do is to synchronize access to your data
> structure (why you hold the spinlock right?) with RCU if you can...

Well, the point is that there is not one ITS data structure, but it's a
mesh of lists connected to each other. I'd like to avoid going down with
RCU there, so I'd like to keep it all under one lock.
I wonder if this could be mutex_lock_interruptible, though. From the top
of your head, is there anything that would prevent that? I reckon ITS
access contention is rather rare (though possible), so a sleeping VCPU
wouldn't harm us so much in practice, would it?

Cheers,
Andre.
