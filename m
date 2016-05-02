From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v6 00/10] arm64: Add support for KVM with ACPI
Date: Mon, 2 May 2016 12:54:14 +0000
Message-ID: <20160502125414.GR27057@io.lakedaemon.net>
References: <1460388780-914-1-git-send-email-julien.grall@arm.com>
 <57220C73.7010900@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C24449B9F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2016 08:51:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JzQ9qHF-yAi3 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 May 2016 08:51:47 -0400 (EDT)
Received: from erouter8.ore.mailhop.org (erouter8.ore.mailhop.org
 [54.187.218.212])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 465E249B9D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2016 08:51:46 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <57220C73.7010900@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, al.stone@linaro.org, kvm@vger.kernel.org, hanjun.guo@linaro.org, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, gg@slimlogic.co.uk
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 28, 2016 at 02:13:23PM +0100, Marc Zyngier wrote:
> [+ Thomas, Jason]
> 
> Do you have any objection against this going through the KVM tree? The
> dependencies are rather intricate, and Daniel gave us his green light
> already for the clocksource part.
> 
> If you'd rather maintain the usual flow, please let us know and we'll
> deal with it.

I've no objection.

Acked-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.
