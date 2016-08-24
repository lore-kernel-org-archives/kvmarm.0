From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH] arm64: KVM: Enable support for Cortex-A72
Date: Wed, 24 Aug 2016 11:54:50 +0100
Message-ID: <CAFEAcA_6=7ko_w=8MNC3nB2GTw2o=zZkCvZoLx5N0iO5Z65L_w@mail.gmail.com>
References: <1472023297-2756-1-git-send-email-zhaoshenglong@huawei.com>
 <ffda6889-5c31-1b56-942c-de65bbb1c16f@arm.com> <57BD679A.6060406@huawei.com>
 <c02d842a-2576-92f5-8b25-8802cd9876d4@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD6FE411BE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2016 06:47:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Cjs4wVFPRB0m for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Aug 2016 06:47:23 -0400 (EDT)
Received: from mail-ua0-f179.google.com (mail-ua0-f179.google.com
 [209.85.217.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AF26640C9D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2016 06:47:23 -0400 (EDT)
Received: by mail-ua0-f179.google.com with SMTP id n59so21247116uan.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2016 03:55:11 -0700 (PDT)
In-Reply-To: <c02d842a-2576-92f5-8b25-8802cd9876d4@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 24 August 2016 at 11:19, Suzuki K Poulose <Suzuki.Poulose@arm.com> wrote:
> On 24/08/16 10:23, Shannon Zhao wrote:
>> Yes, this works for qemu with "-cpu host". But if it specifies the cpu
>> type with "-cpu cortex-a72". It will fail without this patch.
>
>
> Thats because you specify the expected target from the kernel in Qemu.

That's because if the user said "I really really want a cortex-A72 in
the guest" then we need to tell the kernel "really must be an A72"
(and the kernel can then fake it up in some hypothetical future world
where we can simulate A72 on non-A72 h/w). If the user is happy
with "whatever the kernel's best effort is" that's what -cpu host does.
If there's no way to tell the kernel "must be an A72" we fail the command
because we can't do what the user asked for.

thanks
-- PMM
