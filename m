From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2] arm: KVM: Fix idmap overlap detection when the kernel
 is idmap'ed
Date: Thu, 25 Aug 2016 20:34:44 +0200
Message-ID: <20160825183444.GA13095@lvm>
References: <1471852877-17197-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1226411E3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2016 14:26:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R9hLf9MHNSKJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Aug 2016 14:26:55 -0400 (EDT)
Received: from mail-qk0-f176.google.com (mail-qk0-f176.google.com
 [209.85.220.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2795140C9A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2016 14:26:54 -0400 (EDT)
Received: by mail-qk0-f176.google.com with SMTP id v123so54448722qkh.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2016 11:34:46 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1471852877-17197-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Aug 22, 2016 at 09:01:17AM +0100, Marc Zyngier wrote:
> We're trying hard to detect when the HYP idmap overlaps with the
> HYP va, as it makes the teardown of a cpu dangerous. But there is
> one case where an overlap is completely safe, which is when the
> whole of the kernel is idmap'ed, which is likely to happen on 32bit
> when RAM is at 0x8000000 and we're using a 2G/2G VA split.
> 
> In that case, we can proceed safely.
> 
> Reported-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Thanks, applied.

-Christoffer
