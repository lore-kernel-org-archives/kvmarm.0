From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PULL 0/3] KVM/ARM updates for v4.9-rc4
Date: Fri, 11 Nov 2016 10:23:20 +0000
Message-ID: <8ba4f486-e9f8-ae85-6647-29b1ffb31c97@arm.com>
References: <20161104183638.28137-1-marc.zyngier@arm.com>
 <09984771-dfe4-1811-7d2e-29eaf34d99a9@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CA54404BA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Nov 2016 05:23:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 07-A3qtOrb6Z for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Nov 2016 05:22:59 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 62A9A403F8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Nov 2016 05:22:58 -0500 (EST)
In-Reply-To: <09984771-dfe4-1811-7d2e-29eaf34d99a9@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 11/11/16 10:14, Paolo Bonzini wrote:
> 
> 
> On 04/11/2016 19:36, Marc Zyngier wrote:
>>   git://git.kernel.org:/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-v4.9-rc4
> 
> What is the extra colon after "org"? :)

That's obviously me screwing up when hacking the .git/config to have
different fetch and push URLs. The odd thing is that git (2.10.1)
doesn't even complain and happily pulls the branch... Did you get an
error? Anyway, I'll fix that in my local config.

> Pulled now, and I will send it in time for rc5.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
