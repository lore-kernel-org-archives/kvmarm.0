From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v13 2/4] arm: Add PMU test
Date: Thu, 1 Dec 2016 12:02:52 +0000
Message-ID: <CAFEAcA--kXnrDw3m1VCwOpJoHb-VBkJDakD2gZ+B6j_itQyJjA@mail.gmail.com>
References: <1480569402-8848-1-git-send-email-wei@redhat.com>
 <1480569402-8848-3-git-send-email-wei@redhat.com>
 <20161201090303.6vdo7iqlj2lfqqvv@kamzik.brq.redhat.com>
 <369668b9-d158-45dd-562d-cf25cdaaa749@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F50440798
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2016 07:02:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8zGl-ufGqUAh for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Dec 2016 07:02:22 -0500 (EST)
Received: from mail-vk0-f54.google.com (mail-vk0-f54.google.com
 [209.85.213.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7429F40670
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2016 07:02:22 -0500 (EST)
Received: by mail-vk0-f54.google.com with SMTP id 137so127149282vkl.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Dec 2016 04:03:13 -0800 (PST)
In-Reply-To: <369668b9-d158-45dd-562d-cf25cdaaa749@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Aaron Lindsay <alindsay@codeaurora.org>, kvm-devel <kvm@vger.kernel.org>, croberts@codeaurora.org, QEMU Developers <qemu-devel@nongnu.org>, Alistair Francis <alistair.francis@xilinx.com>, Shannon Zhao <shannon.zhao@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 1 December 2016 at 11:28, Andre Przywara <andre.przywara@arm.com> wrote:
> I don't think so. At least here as a _variable_ type uint32_t is
> probably the right one, as the ARMv8 ARM explicitly says that PMCR is a
> 32-bit register, for both bitnesses.

For 64-bit ARM this is strictly speaking just shorthand for "64-bit
register with the top 32-bit being RES0". It is in theory possible that
a future architecture extension might define uses for those RES0
bits.

thanks
-- PMM
