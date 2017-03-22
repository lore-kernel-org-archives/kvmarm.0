From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] kvm: pass the virtual SEI syndrome to guest OS
Date: Wed, 22 Mar 2017 11:15:15 +0000
Message-ID: <f56cf420-affc-35f0-2355-801a924b8a35@arm.com>
References: <1489996534-8270-1-git-send-email-gengdongjiu@huawei.com>
 <7055772d-2a20-6e0c-2bf8-204bc9ef52a5@arm.com>
 <b912c293-4314-7c90-30a4-2f986feb1670@huawei.com>
 <22fb583f-a33e-15f8-a059-fb112b27dd4f@arm.com> <58CFF058.8020205@arm.com>
 <76795e20-2f20-1e54-cfa5-7444f28b18ee@huawei.com>
 <20170321113428.GC15920@cbox> <58D17AF0.2010802@arm.com>
 <20170321193933.GB31111@cbox>
 <CAFEAcA_NBvRQpuXJ2iZs_8n3b6920Z6E5ueuiAeF-4JCcqPRxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0597540C28
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Mar 2017 07:13:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r4V2jj0PqZH6 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Mar 2017 07:13:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DC5240BE3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Mar 2017 07:13:30 -0400 (EDT)
In-Reply-To: <CAFEAcA_NBvRQpuXJ2iZs_8n3b6920Z6E5ueuiAeF-4JCcqPRxQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <cdall@linaro.org>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, wuquanming@huawei.com, kvm-devel <kvm@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, gengdongjiu <gengdongjiu@huawei.com>, Andre Przywara <andre.przywara@arm.com>, huangshaoyu@huawei.com, wangxiongfeng2@huawei.com, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 21/03/17 22:10, Peter Maydell wrote:
> On 21 March 2017 at 19:39, Christoffer Dall <cdall@linaro.org> wrote:
>> My confusion here comes from not thinking about QEMU or KVM as firmware,
>> but as the machine, so it would be sort of like the functionality is
>> baked into hardware rather than firmware.
> 
> There is precedent for that kind of thing -- we implement PSCI
> in KVM/QEMU for the guest, though in real hardware it would be
> provided by firmware at EL3.

[probably vastly off topic]

In retrospect, I now believe this was a rather big mistake to implement
PSCI in KVM.

Eventually, we want to be able to handle the full spectrum of the SMCCC
and forward things to an actual TEE if available. There is no real
reason why PSCI shouldn't be handled in userspace the same way (and we
already offload reset and halt to QEMU).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
