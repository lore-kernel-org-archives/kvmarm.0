From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 09/15] arm64: Add page size to the kernel image header
Date: Mon, 5 Oct 2015 14:22:20 +0100
Message-ID: <CAKv+Gu9KAJMeVK257qPoWOvtvioj2qi9_Dqb--Gqo07fzhzKDA@mail.gmail.com>
References: <1442331684-28818-1-git-send-email-suzuki.poulose@arm.com>
 <1442331684-28818-10-git-send-email-suzuki.poulose@arm.com>
 <20151002154900.GN6963@e104818-lin.cambridge.arm.com>
 <561274C8.20500@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D659D41390
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Oct 2015 09:20:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lzBVUc6cfHFj for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Oct 2015 09:20:29 -0400 (EDT)
Received: from mail-io0-f169.google.com (mail-io0-f169.google.com
 [209.85.223.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2754D412DD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Oct 2015 09:20:28 -0400 (EDT)
Received: by ioiz6 with SMTP id z6so184461982ioi.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 05 Oct 2015 06:22:20 -0700 (PDT)
In-Reply-To: <561274C8.20500@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 5 October 2015 at 14:02, Suzuki K. Poulose <Suzuki.Poulose@arm.com> wrote:
> On 02/10/15 16:49, Catalin Marinas wrote:
>>
>> On Tue, Sep 15, 2015 at 04:41:18PM +0100, Suzuki K. Poulose wrote:
>>>
>>> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>>
>>> This patch adds the page size to the arm64 kernel image header
>>> so that one can infer the PAGESIZE used by the kernel. This will
>>> be helpful to diagnose failures to boot the kernel with page size
>>> not supported by the CPU.
>>>
>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>
>>
>> This patch needs you signed-off-by as well since you are posting it. And
>> IIRC I acked it as well, I'll check.
>>
>
> Yes, you did mention that you were OK with the patch. But I thought there
> was
> no  'Acked-by' tag added. Hence didn't pick that up.
>

In my version of this patch (which I sent separately before noticing
that Suzuki had already folded it into his series), I took the comment
from Catalin to the email in which I suggested this change as an
implicit Acked-by.

-- 
Ard.
