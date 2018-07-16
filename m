From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v8 4/4] KVM: arm: Add 32bit get/set events support
Date: Mon, 16 Jul 2018 11:00:10 +0800
Message-ID: <bb946622-4835-133a-d70d-d3a4e360319d@huawei.com>
References: <20180713154751.18131-1-james.morse@arm.com>
 <20180713154751.18131-5-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E9B64A12B
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Jul 2018 22:48:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SKkWN3hlsS-e for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 Jul 2018 22:48:01 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 13FA64A129
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Jul 2018 22:48:01 -0400 (EDT)
In-Reply-To: <20180713154751.18131-5-james.morse@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, linuxarm@huawei.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2018/7/13 23:47, James Morse wrote:
> arm64's new use of KVMs get_events/set_events API calls isn't just
> for RAS, it allows an SError that has been made pending by KVM as
> part of its device emulation to be migrated.
> 
> Wire this up for 32bit too.
> 
> We only need to read/write the HCR_VA bit, and check that no esr has
> been provided, as we don't yet support VDFSR.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> CC: Dongjiu Geng <gengdongjiu@huawei.com>

Thanks!
Reviewed-by: Dongjiu Geng <gengdongjiu@huawei.com>

> ---
> Changes since v7:
>  * Removed temporary #ifdefs
>  * Added 'and 32bit' to the the documentation.
> ---
>  Documentation/virtual/kvm/api.txt |  8 ++++----
>  arch/arm/include/asm/kvm_host.h   |  5 +++++
