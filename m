From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 4/5] arm64: mmu: map .text as read-only from the outset
Date: Tue, 14 Feb 2017 17:54:05 +0000
Message-ID: <20170214175405.GL23718@leverpostej>
References: <1486844586-26135-1-git-send-email-ard.biesheuvel@linaro.org>
 <1486844586-26135-5-git-send-email-ard.biesheuvel@linaro.org>
 <20170214155704.GE23718@leverpostej>
 <651D9CBB-3E64-41CE-BF85-D2FF0CB927B7@linaro.org>
 <20170214174029.GJ23718@leverpostej>
 <42A48E4E-EF3C-4F28-A660-AFEBB238B698@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 438144092C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Feb 2017 12:53:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UTuYyNqFNPLi for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Feb 2017 12:53:31 -0500 (EST)
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-eopbgr30077.outbound.protection.outlook.com [40.107.3.77])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A18D340905
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Feb 2017 12:53:30 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <42A48E4E-EF3C-4F28-A660-AFEBB238B698@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: keescook@chromium.org, marc.zyngier@arm.com, catalin.marinas@arm.com, kernel-hardening@lists.openwall.com, will.deacon@arm.com, andre.przywara@arm.com, nd@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, labbott@fedoraproject.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 14, 2017 at 05:49:19PM +0000, Ard Biesheuvel wrote:
> 
> > On 14 Feb 2017, at 17:40, Mark Rutland <mark.rutland@arm.com> wrote:
> > 
> >> On Tue, Feb 14, 2017 at 04:15:11PM +0000, Ard Biesheuvel wrote:

> >> Having trivial 'off' switches for security features makes me feel
> >> uneasy (although this is orthogonal to this patch)
> > 
> > From my PoV, external debuggers are the sole reason to allow rodata=off
> > for arm64, and we already allow rodata=off.
> > 
> > 
> 
> Indeed. If that is how it works currently, we shouldn't interfere with
> it. If we ever get anywhere with the lockdown patches, we should
> blacklist this parameter (or rather, not whitelist it, since
> blacklisting kernel params to enforce security is infeasible imo)

Agreed on all counts!

Mark.
