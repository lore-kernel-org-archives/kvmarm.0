From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64: kvm: avoid %p in __kvm_hyp_panic
Date: Tue, 24 Nov 2015 18:18:32 +0100
Message-ID: <20151124171832.GB18855@cbox>
References: <1447682151-5827-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EAC941145
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 12:17:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4tRQsJAusfMn for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2015 12:17:12 -0500 (EST)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3EA414113E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 12:17:11 -0500 (EST)
Received: by wmec201 with SMTP id c201so36429680wme.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 09:18:10 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1447682151-5827-1-git-send-email-mark.rutland@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 16, 2015 at 01:55:51PM +0000, Mark Rutland wrote:
> Currently __kvm_hyp_panic uses %p for values which are not pointers,
> such as the ESR value. This can confusingly lead to "(null)" being
> printed for the value.
> 
> Use %x instead, and only use %p for host pointers.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>

Thanks, applied.

-Christoffer
