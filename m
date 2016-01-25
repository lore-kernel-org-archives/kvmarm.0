From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v9 19/21] KVM: ARM64: Add a new feature bit for PMUv3
Date: Mon, 25 Jan 2016 16:47:29 +0000
Message-ID: <CAFEAcA_fyEp3tihjbCyQBzU6vex4273Sp78J4Kg1UXkkyX+1Pg@mail.gmail.com>
References: <1452839275-19368-1-git-send-email-zhaoshenglong@huawei.com>
 <1452839275-19368-20-git-send-email-zhaoshenglong@huawei.com>
 <20160115110816.GE3915@hawk.localdomain> <569DE171.1070602@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 752C340C9D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2016 11:42:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oCC7qJM1NPO2 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Jan 2016 11:42:57 -0500 (EST)
Received: from mail-vk0-f45.google.com (mail-vk0-f45.google.com
 [209.85.213.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8836340B58
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2016 11:42:57 -0500 (EST)
Received: by mail-vk0-f45.google.com with SMTP id e185so76769797vkb.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2016 08:47:49 -0800 (PST)
In-Reply-To: <569DE171.1070602@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, Will Deacon <will.deacon@arm.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 19 January 2016 at 07:10, Shannon Zhao <zhaoshenglong@huawei.com> wrote:
> Yes, for checking the CAP true/false is enough. Maybe I think the number
> of host counters could be useful for QEMU to know the number and for
> supporting cross-type vcpu, but I'm not sure. If someone else has no
> other suggestion, I will change it to what you suggest.

Do we care about the number of host counters? We might want to
know how many counters the guest sees, but we can do that by
using KVM_GET_ONE_REG to look at the guest PMCR_EL0, right?

thanks
-- PMM
