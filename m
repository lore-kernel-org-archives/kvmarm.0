From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v11 5/6] target-arm: kvm64: handle SIGBUS signal for
 synchronous External Abort
Date: Fri, 8 Sep 2017 17:21:52 +0100
Message-ID: <CAFEAcA8HPhHeeXEDtxnewJ7mAJ-gYzR96pC06qA+Xx95LHu2DA@mail.gmail.com>
References: <0184EA26B2509940AA629AE1405DD7F2015F5F11@DGGEMA503-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6154349C45
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Sep 2017 12:19:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QxnsVk7eWfcy for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Sep 2017 12:19:44 -0400 (EDT)
Received: from mail-wr0-f174.google.com (mail-wr0-f174.google.com
 [209.85.128.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1321F49C38
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Sep 2017 12:19:43 -0400 (EDT)
Received: by mail-wr0-f174.google.com with SMTP id o42so5552501wrb.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Sep 2017 09:22:13 -0700 (PDT)
In-Reply-To: <0184EA26B2509940AA629AE1405DD7F2015F5F11@DGGEMA503-MBX.china.huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, QEMU Developers <qemu-devel@nongnu.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "zjzhang@codeaurora.org" <zjzhang@codeaurora.org>, Ingo Molnar <mingo@kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Huangshaoyu <huangshaoyu@huawei.com>, huangdaode <huangdaode@hisilicon.com>, "bp@suse.de" <bp@suse.de>, Wuquanming <wuquanming@huawei.com>, Marc Zyngier <marc.zyngier@arm.com>, "edk2-devel@lists.01.org" <edk2-devel@lists.01.org>, John Garry <john.garry@huawei.com>, Linuxarm <linuxarm@huawei.com>, qemu-arm <qemu-arm@nongnu.org>, Igor Mammedov <imammedo@redhat.com>, "Zhengqiang (turing)" <zhengqiang10@huawei.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, devel@acpica.org
List-Id: kvmarm@lists.cs.columbia.edu

On 8 September 2017 at 17:17, gengdongjiu <gengdongjiu@huawei.com> wrote:
>>
>> This code has all just been copied-and-pasted from target/i386/kvm.c.
>> Please instead abstract it out properly into a cpu-independent source file.
>
>
> Yes, it copied from x86.
> Do you mean abstracting this code to a common folder so that i386 and arm platform share it?

I mean it should go into a common source file (perhaps
accel/kvm/kvm-all.c).


>> What is this ??? You should never need to look up things in the cpreg arrays by fieldoffset.
>
>
> I used it to set the esr_el1's and far_el1's value, for example:
>
>   /* set ESR_EL1 */
>   ret = kvm_arm_cpreg_value(cpu, offsetof(CPUARMState, cp15.esr_el[1]));
>
>   /* set FAR_EL1 */
>   ret = kvm_arm_cpreg_value(cpu, offsetof(CPUARMState, cp15.far_el[1]));

Yes, I saw that, but I have no idea why you think that's
the right way to set register values. No other code in
QEMU does this.

> So use the added API kvm_arm_cpreg_value() to set their value.
> If not used it, do you better method to set their value?

I suggest:

>> The code for handling debug exits (software step, watchpoint,
>> etc) is probably a good place to look for how to deal with register state.

>> Any new globally-visible function prototype in a header should
>> have a doc-comment formatted documentation comment, please.
>
>
> Ok, thanks for this reminder. Do you mean I need to add comments
> for this globally-visible function, such as below:
>
> /*
>  * xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
>  */
> void kvm_hwpoison_page_add(ram_addr_t ram_addr);

It should be in the doc-comment format, which begins
"/**" and has some stylization of how you list parameters
and so on. Lots of examples in the existing headers.

thanks
-- PMM
