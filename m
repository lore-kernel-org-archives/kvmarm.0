From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2] ARM: KVM: Cleanup exception injection
Date: Fri, 18 Dec 2015 10:58:47 +0100
Message-ID: <20151218095847.GC32720@cbox>
References: <1450349383-19975-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7A214852E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Dec 2015 04:56:17 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PPD3fAuc8wYY for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Dec 2015 04:56:16 -0500 (EST)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A62B8412A6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Dec 2015 04:56:16 -0500 (EST)
Received: by mail-wm0-f46.google.com with SMTP id l126so56891111wml.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Dec 2015 01:58:44 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1450349383-19975-1-git-send-email-marc.zyngier@arm.com>
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
Cc: David Binderman <dcb314@hotmail.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Dec 17, 2015 at 10:49:43AM +0000, Marc Zyngier wrote:
> David Binderman reported that the exception injection code had a
> couple of unused variables lingering around.
> 
> Upon examination, it looked like this code could do with an
> anticipated spring cleaning, which amounts to deduplicating
> the CPSR/SPSR update, and making it look a bit more like
> the architecture spec.
> 
> The spurious variables are removed in the process.
> 
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
