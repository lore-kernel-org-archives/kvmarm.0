From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm/arm64: KVM: Enforce Break-Before-Make on Stage-2
 page tables
Date: Fri, 29 Apr 2016 13:31:31 +0200
Message-ID: <20160429113131.GA24942@cbox>
References: <1461856591-5751-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8B0749B9A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2016 07:28:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sKkYMTXbVQWG for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Apr 2016 07:28:49 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E106F49B98
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2016 07:28:48 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id a17so31363223wme.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2016 04:31:13 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1461856591-5751-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 28, 2016 at 04:16:31PM +0100, Marc Zyngier wrote:
> The ARM architecture mandates that when changing a page table entry
> from a valid entry to another valid entry, an invalid entry is first
> written, TLB invalidated, and only then the new entry being written.
> 
> The current code doesn't respect this, directly writing the new
> entry and only then invalidating TLBs. Let's fix it up.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Thanks for fixing this, I've applied it to next.

-Christoffer
