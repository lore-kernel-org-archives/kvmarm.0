From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v4 20/21] KVM: arm64: Take any host SError before entering
 the guest
Date: Fri, 03 Nov 2017 16:14:04 +0000
Message-ID: <59FC95CC.3090706@arm.com>
References: <20171019145807.23251-1-james.morse@arm.com>
 <20171019145807.23251-21-james.morse@arm.com> <20171031062315.GY2166@lvm>
 <59F861EE.4010505@arm.com> <20171101045550.GB11166@lvm>
 <59FB0D0C.1010208@arm.com> <20171103124904.GC14144@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9148349D5D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Nov 2017 12:14:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 09hmQGpzMgsW for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Nov 2017 12:14:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7482F49D4B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Nov 2017 12:14:07 -0400 (EDT)
In-Reply-To: <20171103124904.GC14144@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, linux-arm-kernel@lists.infradead.org, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 03/11/17 12:49, Christoffer Dall wrote:
> Does a non-secure esb() cause the error to be delivered to firmware on
> the secure side if anything is pending?

Yes, the ESB-instruction causes 'synchronisable' errors to become pending as an
SError. They then follow the normal SError rules.


> I'm not sure I fully understand the interaction between issuing an
> esb() in non-secure and firmware handling a RAS error; I thought there
> would be none, and that this was only for kernel-first ?

To implement firmware-first, EL3 has to set SCR_EL3.EA to route external-aborts
and physical SError to EL3. So an ESB-instruction, even in a guest, may cause an
SError to be taken to EL3 for firmware-first handling.

This is why RAS is causing so much noise for KVM, any notification could also
interrupt a guest, so firmware has to emulate an exception taken to EL2
correctly and KVM will have to plumb the notification across to the host APEI code.


Thanks,

James
