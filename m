From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v6 00/10] arm64: Add support for KVM with ACPI
Date: Tue, 3 May 2016 10:21:24 +0200
Message-ID: <20160503082124.GA17923@cbox>
References: <1460388780-914-1-git-send-email-julien.grall@arm.com>
 <57220C73.7010900@arm.com>
 <20160502125414.GR27057@io.lakedaemon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77C1749B8D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2016 04:18:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bbjJBr2o3qKE for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2016 04:18:25 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7EBBA49B81
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2016 04:18:25 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id g17so24557163wme.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 May 2016 01:21:00 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160502125414.GR27057@io.lakedaemon.net>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jason Cooper <jason@lakedaemon.net>
Cc: al.stone@linaro.org, kvm@vger.kernel.org, hanjun.guo@linaro.org, Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, gg@slimlogic.co.uk
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 02, 2016 at 12:54:14PM +0000, Jason Cooper wrote:
> On Thu, Apr 28, 2016 at 02:13:23PM +0100, Marc Zyngier wrote:
> > [+ Thomas, Jason]
> > 
> > Do you have any objection against this going through the KVM tree? The
> > dependencies are rather intricate, and Daniel gave us his green light
> > already for the clocksource part.
> > 
> > If you'd rather maintain the usual flow, please let us know and we'll
> > deal with it.
> 
> I've no objection.
> 
> Acked-by: Jason Cooper <jason@lakedaemon.net>
> 
Just to be clear, that's on all the irqchip patches, right?

Thanks!
-Christoffer
