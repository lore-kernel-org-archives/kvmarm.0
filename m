From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH kvm-unit-tests 2/3] arm64: timer: Fix test on APM X-Gene
Date: Mon, 24 Jul 2017 19:13:44 +0200
Message-ID: <b7900fdf-bcc0-00af-bf5d-940eca09e4ae@redhat.com>
References: <20170713192009.10069-1-cdall@linaro.org>
 <20170713192009.10069-3-cdall@linaro.org>
 <a58bfe11-19a0-aa92-5166-2c33e4cb8981@arm.com> <20170714154512.GC1535@lvm>
 <20170718100503.crn2dgqlalrirzqw@kamzik.brq.redhat.com>
 <20170718103512.GB14069@cbox>
 <20170718121527.ptemrr6mbhfwwbwe@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38E4740FAF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jul 2017 13:12:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U16rCBH9t+xx for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Jul 2017 13:12:50 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4DBDD40017
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jul 2017 13:12:50 -0400 (EDT)
In-Reply-To: <20170718121527.ptemrr6mbhfwwbwe@kamzik.brq.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, Christoffer Dall <cdall@linaro.org>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 18/07/2017 14:15, Andrew Jones wrote:
>>
>> If we want to add a "the platform provides a timer with 56 valid bits in
>> the counter and compare register", then I think it should be a separate
>> test, and the the user can see that "basic stuff works", "architecture
>> compliance not so much" and shrug accordingly.
> Two separate tests sounds good to me. Although, if the value of 'now' is
> large enough that now + 10s will set bit 31, then a mustang run (at least
> mine) will fail - and most likely cause a lot of confusion, since it
> normally does not. We should probably attempt to address that known issue
> in some way as well.

Is the value relative to vm startup or host startup?

Paolo
