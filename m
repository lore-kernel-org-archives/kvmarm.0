From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 20/21] KVM: arm64: Take any host SError before
 entering the guest
Date: Mon, 6 Nov 2017 13:45:25 +0100
Message-ID: <20171106124525.GE14144@cbox>
References: <20171019145807.23251-1-james.morse@arm.com>
 <20171019145807.23251-21-james.morse@arm.com>
 <20171031062315.GY2166@lvm> <59F861EE.4010505@arm.com>
 <20171101045550.GB11166@lvm> <59FB0D0C.1010208@arm.com>
 <20171103124904.GC14144@cbox> <59FC95CC.3090706@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6CDF49D1B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Nov 2017 07:43:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ep+xpsLZMIvy for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Nov 2017 07:43:29 -0500 (EST)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EF8BB49D19
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Nov 2017 07:43:28 -0500 (EST)
Received: by mail-wm0-f45.google.com with SMTP id r196so13546252wmf.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Nov 2017 04:45:21 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <59FC95CC.3090706@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, linux-arm-kernel@lists.infradead.org, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Nov 03, 2017 at 04:14:04PM +0000, James Morse wrote:
> Hi Christoffer,
> 
> On 03/11/17 12:49, Christoffer Dall wrote:
> > Does a non-secure esb() cause the error to be delivered to firmware on
> > the secure side if anything is pending?
> 
> Yes, the ESB-instruction causes 'synchronisable' errors to become pending as an
> SError. They then follow the normal SError rules.
> 
> 
> > I'm not sure I fully understand the interaction between issuing an
> > esb() in non-secure and firmware handling a RAS error; I thought there
> > would be none, and that this was only for kernel-first ?
> 
> To implement firmware-first, EL3 has to set SCR_EL3.EA to route external-aborts
> and physical SError to EL3. So an ESB-instruction, even in a guest, may cause an
> SError to be taken to EL3 for firmware-first handling.
> 
> This is why RAS is causing so much noise for KVM, any notification could also
> interrupt a guest, so firmware has to emulate an exception taken to EL2
> correctly and KVM will have to plumb the notification across to the host APEI code.
> 
> 

I see, but since the end result is that either we panic or firmware
reboots the machine, we don't care and can leave this patch out for now.
Makes sense.

Thanks for the explanation!
-Christoffer
