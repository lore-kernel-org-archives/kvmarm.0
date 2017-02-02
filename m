From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC v3 06/10] KVM: arm/arm64: Update the physical timer
 interrupt level
Date: Thu, 2 Feb 2017 11:15:28 +0100
Message-ID: <20170202101528.GE27852@cbox>
References: <1485970990-13775-1-git-send-email-jintack@cs.columbia.edu>
 <1485970990-13775-7-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F27440966
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Feb 2017 05:15:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZzFJeYPjshFG for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Feb 2017 05:15:10 -0500 (EST)
Received: from mail-lf0-f45.google.com (mail-lf0-f45.google.com
 [209.85.215.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E3534092C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Feb 2017 05:15:10 -0500 (EST)
Received: by mail-lf0-f45.google.com with SMTP id x1so5916331lff.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Feb 2017 02:15:33 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1485970990-13775-7-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jintack Lim <jintack@cs.columbia.edu>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, andre.przywara@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 01, 2017 at 12:43:06PM -0500, Jintack Lim wrote:
> Now that we maintain the EL1 physical timer register states of VMs,
> update the physical timer interrupt level along with the virtual one.
> 
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
