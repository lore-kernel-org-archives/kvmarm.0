From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v4 15/21] KVM: arm64: Set an impdef ESR for Virtual-SError
 using VSESR_EL2.
Date: Tue, 24 Oct 2017 17:53:56 +0800
Message-ID: <9fbee52d-5090-9409-d07a-335acc059878@huawei.com>
References: <20171019145807.23251-1-james.morse@arm.com>
 <20171019145807.23251-16-james.morse@arm.com>
 <CAMj-D2AMy1_SPrLGti9U=oz1JvBDHvRAMsBtw51B3JK0omLyXg@mail.gmail.com>
 <59EE0A2F.8050703@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFB0749D36
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Oct 2017 05:54:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IKmLAqm2qLSk for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Oct 2017 05:54:37 -0400 (EDT)
Received: from huawei.com (unknown [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 067C940D25
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Oct 2017 05:54:37 -0400 (EDT)
In-Reply-To: <59EE0A2F.8050703@arm.com>
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
To: James Morse <james.morse@arm.com>, gengdongjiu <gengdj.1984@gmail.com>
Cc: Jonathan.Zhang@cavium.com, Julien Thierry <julien.thierry@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Xiongfeng Wang <wangxiongfeng2@huawei.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

On 2017/10/23 23:26, James Morse wrote:
> If you're suggesting Qemu should set a default 'unknown' ESR for use when KVM
> doesn't know what to do, and SError is pretty much its only option:
> 
> Why would Qemu set anything other than impdef:all-zeros?
> 
> The only use would be to fake this back into a RAS error. Qemu isn't involved
> here so this can't be used to emulate NOTIFY_SEI without the kernel support. We
> don't have support for emulating the RAS ERR registers either, so this can't be
> used to emulate kernel first.
> 
> 
> If you're suggesting Qemu should specify a set of ESR values for the different
> cases where KVM doesn't know what do: this would be an early shortcut that burns
> us in the future, these things are going to be changed. This is too specific to
> KVMs internals:
> 
> When we add NOTIFY_SEI support, we will call out of this KVM code and APEI
> should 'claim' any SError that arrived with CPER records.
> 
> I expect this code to change dramatically if/when we add kernel first support.
> 
> 
> The KVM patches on the end of this series are just the minimum needed to enable
> IESB and keep the status quo for all other behaviour. And this is just so we can
> tackle the other bits of support that depends on the cpufeature without
> reposting all the same code.

Thanks very much for your explanation, understand it now.
