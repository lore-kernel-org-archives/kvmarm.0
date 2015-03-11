From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 1/3] arm64: KVM: Fix stage-2 PGD allocation to have
 per-page refcounting
Date: Wed, 11 Mar 2015 13:56:34 +0000
Message-ID: <55004992.5030908@arm.com>
References: <1426014421-5579-1-git-send-email-marc.zyngier@arm.com>	<1426014421-5579-2-git-send-email-marc.zyngier@arm.com>	<20150311121635.GA12888@cbox>	<55003F5F.6050706@arm.com>
 <CAMJs5B_rXikZiLdWgwxdXYHcsyzo_Hm1T1Rm9Gkw12HPUvJ84A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7860A48711
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2015 09:50:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ehRObaE5Y-yZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Mar 2015 09:50:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C97148710
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2015 09:50:18 -0400 (EDT)
In-Reply-To: <CAMJs5B_rXikZiLdWgwxdXYHcsyzo_Hm1T1Rm9Gkw12HPUvJ84A@mail.gmail.com>
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
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 11/03/15 13:20, Christoffer Dall wrote:
> On Wed, Mar 11, 2015 at 2:13 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:

>> Looks good to me. I'll fold that into the patch, amend the commit
>> message and resend.
>>
> 
> I've done that here:
> https://git.linaro.org/people/christoffer.dall/linux-kvm-arm.git/shortlog/refs/heads/pgd-fixes-alt
> 
> (except for the commit message, which I can also adjust).

Looks great, thanks.

> I gave this a quick spin on Juno and TC2 (but couldn't test 64K pages
> because I don't have a platform for that handy this very second)...

I can do that if you want.

	M.
-- 
Jazz is not dead. It just smells funny...
