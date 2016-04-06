From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v5 5/9] irqchip/gic-v3: Gather all ACPI specific data in
 a single structure
Date: Wed, 6 Apr 2016 19:26:20 +0200
Message-ID: <20160406172620.GI8961@cbox>
References: <1459769860-6629-1-git-send-email-julien.grall@arm.com>
 <1459769860-6629-6-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BC5740B58
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2016 13:24:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YmiS9O+eevhS for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Apr 2016 13:24:48 -0400 (EDT)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C57F5409A2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2016 13:24:48 -0400 (EDT)
Received: by mail-wm0-f51.google.com with SMTP id 191so65863580wmq.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Apr 2016 10:26:10 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1459769860-6629-6-git-send-email-julien.grall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Grall <julien.grall@arm.com>
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org, fu.wei@linaro.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, gg@slimlogic.co.uk
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 04, 2016 at 12:37:36PM +0100, Julien Grall wrote:
> The ACPI code requires to use global variales in order to collect

s/variales/variables/

> information from the tables.
> 
> To make clear those variables are ACPI specific, gather all of them in a
> single structure.
> 
> Furthermore, even if some of the variables are not marked with
> __initdata, they are all only used during the initialization. Therefore,
> the new variable, which hold the structure, can be marked with
> __initdata.
> 
> Signed-off-by: Julien Grall <julien.grall@arm.com>
> 
> ---
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> 
>     Changes in v4:
>         - Rework commit message
> 
>     Changes in v3:
>         - Patch added
> ---

Otherwise:
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
