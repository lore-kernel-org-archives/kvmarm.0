From: Hanjun Guo <hanjun.guo@linaro.org>
Subject: Re: [PATCH v6 04/10] irqchip/gic-v2: Parse and export virtual GIC
 information
Date: Wed, 13 Apr 2016 17:50:42 +0800
Message-ID: <570E1672.5060900@linaro.org>
References: <1460388780-914-1-git-send-email-julien.grall@arm.com>
 <1460388780-914-5-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E323449B3C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2016 05:49:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I5JOJ9pmv+NW for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Apr 2016 05:49:09 -0400 (EDT)
Received: from mail-pf0-f172.google.com (mail-pf0-f172.google.com
 [209.85.192.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C9FBA49B37
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2016 05:49:09 -0400 (EDT)
Received: by mail-pf0-f172.google.com with SMTP id c20so31328085pfc.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2016 02:50:50 -0700 (PDT)
In-Reply-To: <1460388780-914-5-git-send-email-julien.grall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, fu.wei@linaro.org, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, linux-arm-kernel@lists.infradead.org, gg@slimlogic.co.uk
List-Id: kvmarm@lists.cs.columbia.edu

On 2016/4/11 23:32, Julien Grall wrote:
> For now, the firmware tables are parsed 2 times: once in the GIC
> drivers, the other timer when initializing the vGIC. It means code
> duplication and make more tedious to add the support for another
> firmware table (like ACPI).
>
> Introduce a new structure and set of helpers to get/set the virtual GIC
> information. Also fill up the structure for GICv2.
>
> Signed-off-by: Julien Grall <julien.grall@arm.com>

For ACPI code,

Acked-by: Hanjun Guo <hanjun.guo@linaro.org>

Thanks
Hanjun
