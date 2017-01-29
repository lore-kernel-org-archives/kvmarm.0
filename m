From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [Qemu-devel] [PATCH RFC 3/6] arm: kvm64: Check if kvm supports
 cross type vCPU
Date: Sun, 29 Jan 2017 20:42:14 +0000
Message-ID: <CAFEAcA-nB7uQAGcZWUYeiAis2tY33U6yeiig+kwd2-KRD=KSuw@mail.gmail.com>
References: <1484558821-15512-1-git-send-email-zhaoshenglong@huawei.com>
 <1484558821-15512-4-git-send-email-zhaoshenglong@huawei.com>
 <20170129115306.iuhvofl3y65x7sjw@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E33DC40625
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Jan 2017 15:42:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QNPboLiuX1t5 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 29 Jan 2017 15:42:18 -0500 (EST)
Received: from mail-vk0-f46.google.com (mail-vk0-f46.google.com
 [209.85.213.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 902C140296
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Jan 2017 15:42:18 -0500 (EST)
Received: by mail-vk0-f46.google.com with SMTP id r136so205358616vke.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Jan 2017 12:42:35 -0800 (PST)
In-Reply-To: <20170129115306.iuhvofl3y65x7sjw@hawk.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: QEMU Developers <qemu-devel@nongnu.org>, qemu-arm <qemu-arm@nongnu.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 29 January 2017 at 11:53, Andrew Jones <drjones@redhat.com> wrote:
> On Mon, Jan 16, 2017 at 05:26:58PM +0800, Shannon Zhao wrote:
>> From: Shannon Zhao <shannon.zhao@linaro.org>
>> +    memset(id_regitsers, 0, ARM_CPU_ID_MAX * sizeof(struct kvm_one_reg));
>> +
>> +    id_regitsers[0].id = ARM64_SYS_REG(ARM_CPU_ID_MIDR);
>> +    id_regitsers[0].addr = (uintptr_t)&cpu->midr;
>> +
>> +    id_regitsers[1].id = ARM64_SYS_REG(ARM_CPU_ID_REVIDR);
>> +    id_regitsers[1].addr = (uintptr_t)&cpu->revidr;
>> +
>
> We can condense this nicely with list initialization
>
>  struct kvm_one_reg id_regitsers[] = {
>    { ARM64_SYS_REG(ARM_CPU_ID_MIDR), (uintptr_t)&cpu->midr },
>    { ARM64_SYS_REG(ARM_CPU_ID_REVIDR), (uintptr_t)&cpu->revidr },
>    ...
>    { 0, 0 }

"registers", please :-)

thanks
-- PMM
