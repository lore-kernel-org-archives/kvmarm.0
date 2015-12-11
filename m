From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 11/22] arm64: KVM: Add patchable function selector
Date: Fri, 11 Dec 2015 22:21:16 +0100
Message-ID: <20151211212116.GI27689@cbox>
References: <1449485618-9443-1-git-send-email-marc.zyngier@arm.com>
 <1449485618-9443-12-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 944D240B58
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Dec 2015 16:18:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7CdRtEiLSCjZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Dec 2015 16:18:26 -0500 (EST)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A8B07407A0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Dec 2015 16:18:26 -0500 (EST)
Received: by wmec201 with SMTP id c201so87350917wme.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Dec 2015 13:20:29 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1449485618-9443-12-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 07, 2015 at 10:53:27AM +0000, Marc Zyngier wrote:
> KVM so far relies on code patching, and is likely to use it more
> in the future. The main issue is that our alternative system works
> at the instruction level, while we'd like to have alternatives at
> the function level.
> 
> In order to cope with this, add the "hyp_alternate_select" macro that
> outputs a brief sequence of code that in turn can be patched, allowing
> an alternative function to be selected.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
