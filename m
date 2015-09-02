From: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH 02/14] arm64: Handle section maps for swapper/idmap
Date: Wed, 02 Sep 2015 10:42:58 +0100
Message-ID: <55E6C4A2.7080307@arm.com>
References: <1439465645-22584-1-git-send-email-suzuki.poulose@arm.com>	<1439465645-22584-3-git-send-email-suzuki.poulose@arm.com>
 <CAKv+Gu-0ut3o3iy322tbyqLAmR_gfzoE5272O3U3qSd5Zoh0Hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67A91419C7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2015 05:42:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DC-p5uZR0-oW for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2015 05:42:41 -0400 (EDT)
Received: from eu-smtp-delivery-143.mimecast.com
 (eu-smtp-delivery-143.mimecast.com [207.82.80.143])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D61F419A9
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2015 05:42:40 -0400 (EDT)
In-Reply-To: <CAKv+Gu-0ut3o3iy322tbyqLAmR_gfzoE5272O3U3qSd5Zoh0Hw@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: KVM devel mailing list <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 02/09/15 10:38, Ard Biesheuvel wrote:
> On 13 August 2015 at 13:33, Suzuki K. Poulose <suzuki.poulose@arm.com> wrote:
>> From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
>>
>> We use section maps with 4K page size to create the
>> swapper/idmaps. So far we have used !64K or 4K checks
>> to handle the case where we use the section maps. This
>> patch adds a symbol to make it clear those cases.
>>
>
> That sentence does not make sense.

I agree. How about :

"This patch adds a new symbol, 'ARM64_SWAPPER_USES_SECTION_MAPS', to
handle cases where we use section maps, instead of using the page size
symbols."

Suzuki
