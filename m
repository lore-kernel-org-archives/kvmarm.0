From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH] kvm: pass the virtual SEI syndrome to guest OS
Date: Tue, 28 Mar 2017 12:33:59 +0100
Message-ID: <CAFEAcA9O_mUbO=RChLwpj=qr0ZDg6iEsYwzWLTbHMRV-9z-1vQ@mail.gmail.com>
References: <1489996534-8270-1-git-send-email-gengdongjiu@huawei.com>
 <7055772d-2a20-6e0c-2bf8-204bc9ef52a5@arm.com>
 <b912c293-4314-7c90-30a4-2f986feb1670@huawei.com>
 <22fb583f-a33e-15f8-a059-fb112b27dd4f@arm.com> <58CFF058.8020205@arm.com>
 <76795e20-2f20-1e54-cfa5-7444f28b18ee@huawei.com>
 <20170321113428.GC15920@cbox>
 <58D17AF0.2010802@arm.com> <20170321193933.GB31111@cbox>
 <58DA3F68.6090901@arm.com> <20170328112328.GA31156@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E03BD40C17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 07:32:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bwICceHSRjfn for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Mar 2017 07:32:21 -0400 (EDT)
Received: from mail-wr0-f177.google.com (mail-wr0-f177.google.com
 [209.85.128.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B9ED240A95
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 07:32:21 -0400 (EDT)
Received: by mail-wr0-f177.google.com with SMTP id u1so100419343wra.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 04:34:20 -0700 (PDT)
In-Reply-To: <20170328112328.GA31156@cbox>
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
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, wuquanming@huawei.com, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Achin Gupta <Achin.Gupta@arm.com>, Will Deacon <will.deacon@arm.com>, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, gengdongjiu <gengdongjiu@huawei.com>, Leif.Lindholm@linaro.com, Andre Przywara <andre.przywara@arm.com>, huangshaoyu@huawei.com, wangxiongfeng2@huawei.com, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 28 March 2017 at 12:23, Christoffer Dall <cdall@linaro.org> wrote:
> On Tue, Mar 28, 2017 at 11:48:08AM +0100, James Morse wrote:
>> On the host, part of UEFI is involved to generate the CPER records.
>> In a guest?, I don't know.
>> Qemu could generate the records, or drive some other component to do it.
>
> I think I am beginning to understand this a bit.  Since the guet UEFI
> instance is specifically built for the machine it runs on, QEMU's virt
> machine in this case, they could simply agree (by some contract) to
> place the records at some specific location in memory, and if the guest
> kernel asks its guest UEFI for that location, things should just work by
> having logic in QEMU to process error reports and populate guest memory.

Is "write direct to guest memory" the best ABI here or would
it be preferable to use the fw_cfg interface for the guest UEFI
to retrieve the data items on demand?

Is there a pre-existing "this is how it works on x86" implementation?

thanks
-- PMM
