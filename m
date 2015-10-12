From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 00/16] KVM: arm64: GICv3 ITS emulation
Date: Mon, 12 Oct 2015 15:12:17 +0100
Message-ID: <561BBFC1.4070200@arm.com>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
 <20151010153744.GH29128@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6B33411E2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Oct 2015 10:09:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rqtvI5agX+bU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Oct 2015 10:09:12 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3B2941022
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Oct 2015 10:09:12 -0400 (EDT)
In-Reply-To: <20151010153744.GH29128@cbox>
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
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hej,

On 10/10/15 16:37, Christoffer Dall wrote:
> Hi Andre,
> 
> 
> On Wed, Oct 07, 2015 at 03:55:10PM +0100, Andre Przywara wrote:
>> Hi,
>>
>> another respin and rebase of the ITS emulation series.
>> Major changes compared to v2 (beside some minor things like added
>> comments and function renames) are the rebasing and adaption to 4.3-rc
>> and Christoffer's timer rework series. Also the locking has been
>> reworked to cope with the dependencies of the its and the dist lock
>> in connection with the PROPBASER/PENDBASER and the command handling.
>> For a more detailed changelog see below or look at the respective
>> commit messages.
>>
>> This should address most of the comments I got on the list.
>> Many thanks to the diligent reviewers!
>> I didn't bother to fine-tune patch 01/16 too much, as I guess there
>> will be more discussion around this based on Pavel's latest post.
>>
>> These patches go on top of Christoffer's timer rework series [1],
>> which itself is on top of 4.3-rc2.
>> You can find all of this code in the its-emul/v3 branch of my
>> repository [2].
> 
> Thanks for rebasing the series!
> 
> Just a heads up that I may not be able to review this series for the
> next 1-2 weeks, so I'm afraid it's not going to make it in for v4.4,
> sorry.
> 
> Please let me know if this breaks expectations from everyone.

No worries, I wasn't expecting this for 4.4 anyway.
I'd rather see the prerequisites like your timer series going upstream
first, I will then rebase it on top of 4.4-rc1 (with fixes from newer
review comments incorporated).
Maybe we can take Pavel's cleanup (replacing my 1/16 and 2/16) for 4.4
already? (I will reply on those soon)
Also what is the status of Eric's IRQ routing support? Should this go in
first now?

Cheers,
Andre.

> Othersie, I will try review it with due dilligence so it makes it in for
> v4.5.
> 
> Best,
> -Christoffer
