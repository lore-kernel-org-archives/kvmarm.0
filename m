From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 17/21] arm64: KVM: Map the kernel RO section into HYP
Date: Wed, 2 Dec 2015 12:49:31 +0100
Message-ID: <20151202114931.GC18376@cbox>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com>
 <1448650215-15218-18-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5FF949786
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2015 06:47:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EdGytfv0rKuY for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2015 06:47:30 -0500 (EST)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B811D49721
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2015 06:47:30 -0500 (EST)
Received: by wmww144 with SMTP id w144so53236350wmw.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Dec 2015 03:48:58 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1448650215-15218-18-git-send-email-marc.zyngier@arm.com>
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

On Fri, Nov 27, 2015 at 06:50:11PM +0000, Marc Zyngier wrote:
> In order to run C code in HYP, we must make sure that the kernel's
> RO section in mapped into HYP (otherwise things break badly).
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
