From: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH 09/15] arm64: Add page size to the kernel image header
Date: Mon, 05 Oct 2015 14:02:00 +0100
Message-ID: <561274C8.20500@arm.com>
References: <1442331684-28818-1-git-send-email-suzuki.poulose@arm.com>
 <1442331684-28818-10-git-send-email-suzuki.poulose@arm.com>
 <20151002154900.GN6963@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54F914141D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Oct 2015 09:00:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IhO4hoxjRVjd for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Oct 2015 09:00:17 -0400 (EDT)
Received: from eu-smtp-delivery-143.mimecast.com
 (eu-smtp-delivery-143.mimecast.com [207.82.80.143])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 850FF41457
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Oct 2015 09:00:11 -0400 (EDT)
In-Reply-To: <20151002154900.GN6963@e104818-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 02/10/15 16:49, Catalin Marinas wrote:
> On Tue, Sep 15, 2015 at 04:41:18PM +0100, Suzuki K. Poulose wrote:
>> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>
>> This patch adds the page size to the arm64 kernel image header
>> so that one can infer the PAGESIZE used by the kernel. This will
>> be helpful to diagnose failures to boot the kernel with page size
>> not supported by the CPU.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> This patch needs you signed-off-by as well since you are posting it. And
> IIRC I acked it as well, I'll check.
>

Yes, you did mention that you were OK with the patch. But I thought there was
no  'Acked-by' tag added. Hence didn't pick that up.


> If you are fine with adding your signed-of-by, I can add it to the patch
> when applying (unless I see other issues with the series).
>

Yes, please go ahead, if I don't have to send another version depending on
the review of KVM bits. If I not, I will add the S-o-b and your Acked-by.


Thanks
Suzuki
