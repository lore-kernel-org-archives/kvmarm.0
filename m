From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 22/23] arm64: VHE: Add support for running Linux in
 EL2 mode
Date: Thu, 4 Feb 2016 20:25:25 +0100
Message-ID: <20160204192525.GI13974@cbox>
References: <1454522416-6874-1-git-send-email-marc.zyngier@arm.com>
 <1454522416-6874-23-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFD38412C2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2016 14:19:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tOQ4ad3wtDSj for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2016 14:19:25 -0500 (EST)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C5B54411AA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2016 14:19:25 -0500 (EST)
Received: by mail-wm0-f45.google.com with SMTP id g62so19425054wme.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Feb 2016 11:24:55 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1454522416-6874-23-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 03, 2016 at 06:00:15PM +0000, Marc Zyngier wrote:
> With ARMv8.1 VHE, the architecture is able to (almost) transparently
> run the kernel at EL2, despite being written for EL1.
> 
> This patch takes care of the "almost" part, mostly preventing the kernel
> from dropping from EL2 to EL1, and setting up the HYP configuration.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
