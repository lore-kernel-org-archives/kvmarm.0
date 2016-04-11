From: Hanjun Guo <hanjun.guo@linaro.org>
Subject: Re: [PATCH v5 3/9] irqchip/gic-v2: Gather ACPI specific data in a
 single structure
Date: Mon, 11 Apr 2016 10:47:51 +0800
Message-ID: <570B1057.2080902@linaro.org>
References: <1459769860-6629-1-git-send-email-julien.grall@arm.com>
 <1459769860-6629-4-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42BF34053F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Apr 2016 22:46:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v5ynAlDAd-JN for <kvmarm@lists.cs.columbia.edu>;
 Sun, 10 Apr 2016 22:46:26 -0400 (EDT)
Received: from mail-pa0-f50.google.com (mail-pa0-f50.google.com
 [209.85.220.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E9C6640402
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Apr 2016 22:46:25 -0400 (EDT)
Received: by mail-pa0-f50.google.com with SMTP id td3so112277060pab.2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Apr 2016 19:47:59 -0700 (PDT)
In-Reply-To: <1459769860-6629-4-git-send-email-julien.grall@arm.com>
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

Hi Julien,

On 2016/4/4 19:37, Julien Grall wrote:
> The ACPI code requires to use global variables in order to collect
> information from the tables.
>
> For now, a single global variable is used, but more will be added in a
> subsequent patch. To make clear they are ACPI specific, gather all the
> information in a single structure.
>
> Signed-off-by: Julien Grall <julien.grall@arm.com>
> Acked-by: Christofer Dall <christoffer.dall@linaro.org>

Acked-by: Hanjun Guo <hanjun.guo@linaro.org>

Please cc me if you have further versions, I would
like to review the ARM64 ACPI related code.

Thanks
Hanjun
