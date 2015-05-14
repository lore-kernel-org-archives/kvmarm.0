From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 5/5] arm64: KVM: Switch vgic save/restore to
 alternative_insn
Date: Thu, 14 May 2015 13:53:55 +0200
Message-ID: <20150514115355.GT32765@cbox>
References: <1427461765-14462-1-git-send-email-marc.zyngier@arm.com>
 <1427461765-14462-6-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBB0D5148D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 07:44:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z78j3w665Q7k for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 May 2015 07:44:36 -0400 (EDT)
Received: from mail-la0-f44.google.com (mail-la0-f44.google.com
 [209.85.215.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 93FF35148C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 07:44:36 -0400 (EDT)
Received: by lagv1 with SMTP id v1so63695205lag.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 04:53:43 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1427461765-14462-6-git-send-email-marc.zyngier@arm.com>
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
Cc: "Jon Medhurst (Tixy)" <tixy@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dave Martin <dave.martin@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 27, 2015 at 01:09:25PM +0000, Marc Zyngier wrote:
> So far, we configured the world-switch by having a small array
> of pointers to the save and restore functions, depending on the
> GIC used on the platform.
> 
> Loading these values each time is a bit silly (they never change),
> and it makes sense to rely on the instruction patching instead.
> 
> This leads to a nice cleanup of the code.
> 
> Acked-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

I gave this a quick spin on Juno as well and works as expected:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
