From: Steven Price <steven.price@arm.com>
Subject: Re: Re: [RFC] arm/cpu: fix soft lockup panic after resuming from stop
Date: Wed, 13 Mar 2019 10:22:44 +0000
Message-ID: <f54d219f-1a2c-c263-66e7-903da4162d66@arm.com>
References: <1552370960-2061-1-git-send-email-guoheyi@huawei.com>
 <CAFEAcA-29Q-sTg2wLre0GJJCr2gfu89rg0vuTOf7cW5drE4d7Q@mail.gmail.com>
 <136f773f-9b08-a39b-3ecb-2c00ff290b49@arm.com>
 <f528c40f-7b31-3bd2-ca93-1c579961581d@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 901034A36C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Mar 2019 06:22:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AEyoRIVpWGMz for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Mar 2019 06:22:48 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CE5A4A2BE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Mar 2019 06:22:48 -0400 (EDT)
In-Reply-To: <f528c40f-7b31-3bd2-ca93-1c579961581d@huawei.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Heyi Guo <guoheyi@huawei.com>, Marc Zyngier <marc.zyngier@arm.com>, Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-arm <qemu-arm@nongnu.org>, QEMU Developers <qemu-devel@nongnu.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 13/03/2019 01:57, Heyi Guo wrote:
> Dear all,
> 
> Really appreciate your comments and information. For "Live Physical
> Time", is there any document to tell the whole story? And may I know the
> timeline to make it happen?

The documentation is available here:
https://developer.arm.com/docs/den0057/a

I also posted an RFC for Linux support last year:
http://lists.infradead.org/pipermail/linux-arm-kernel/2018-December/620338.html

In terms of timeline I don't have anything definite. We need to get the
spec nailed down before much progress can be made on the code. And at
the moment Live Physical Time (LPT) isn't that useful on it's own
because there are a number of other issues with migrating an arm64 guest
from one host to another which has different hardware (e.g. handling
different CPU errata).

Steve
