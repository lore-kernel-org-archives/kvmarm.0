From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 1/9] KVM: add kvm_request_pending
Date: Wed, 5 Apr 2017 20:30:03 +0200
Message-ID: <fb830008-1d6f-b5c4-615c-9f6776dc7dca@redhat.com>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-2-drjones@redhat.com> <20170404153014.GL11752@cbox>
 <20170404164120.xvlvyebvcqoci5cu@kamzik.brq.redhat.com>
 <20170405131049.GD6369@potion> <20170405173918.GA27123@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83F8340A7F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Apr 2017 14:27:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u5wotuw2xSZJ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Apr 2017 14:27:53 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E0E9740A74
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Apr 2017 14:27:53 -0400 (EDT)
In-Reply-To: <20170405173918.GA27123@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 05/04/2017 19:39, Christoffer Dall wrote:
>> Uses of vcpu->requests should already have barriers that take care of
>> the ordering.  I think the main reason for READ_ONCE() is to tell
>> programmers that requests are special, but predictable.
> 
> I don't know what to do with "special, but predictable", unfortunately.
> In fact, I don't even think I know what you mean.

I don't think it's special, but predictable.  It's atomic, but with
relaxed ordering.

Paolo
