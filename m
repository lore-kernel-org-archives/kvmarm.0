From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v5 4/9] irqchip/gic-v2: Parse and export virtual GIC
 information
Date: Wed, 6 Apr 2016 18:40:41 +0100
Message-ID: <57054A19.1090208@arm.com>
References: <1459769860-6629-1-git-send-email-julien.grall@arm.com>
 <1459769860-6629-5-git-send-email-julien.grall@arm.com>
 <20160406170432.GD8961@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A6A440B58
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2016 13:39:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DW7Qlutc6YZ1 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Apr 2016 13:39:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C41E40B40
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2016 13:39:24 -0400 (EDT)
In-Reply-To: <20160406170432.GD8961@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org, fu.wei@linaro.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, gg@slimlogic.co.uk
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 06/04/2016 18:04, Christoffer Dall wrote:
> On Mon, Apr 04, 2016 at 12:37:35PM +0100, Julien Grall wrote:
>> diff --git a/include/linux/irqchip/arm-gic-common.h b/include/linux/irqchip/arm-gic-common.h
>> new file mode 100644
>> index 0000000..ef34f6f
>> --- /dev/null
>> +++ b/include/linux/irqchip/arm-gic-common.h
>
> just out of curiosity, why is include/linux/irqchip/arm-gic.h not
> suitable?

Because arm-gic.h contains the definitions for GICv2 only. At least one 
of them is clashing with the GICv3 ones.

For instance, the function gic_send_sgi is defined statically the in 
GICv3 code, but exported for GICv2.

Regards,

-- 
Julien Grall
