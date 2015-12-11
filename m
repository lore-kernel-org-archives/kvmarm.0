From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 06/22] arm64: KVM: Implement timer save/restore
Date: Fri, 11 Dec 2015 22:20:03 +0100
Message-ID: <20151211212003.GH27689@cbox>
References: <1449485618-9443-1-git-send-email-marc.zyngier@arm.com>
 <1449485618-9443-7-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38B7B407A0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Dec 2015 16:17:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DuZm91oPW8A9 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Dec 2015 16:17:15 -0500 (EST)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 52FE040402
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Dec 2015 16:17:15 -0500 (EST)
Received: by wmnn186 with SMTP id n186so48727951wmn.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Dec 2015 13:19:18 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1449485618-9443-7-git-send-email-marc.zyngier@arm.com>
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

On Mon, Dec 07, 2015 at 10:53:22AM +0000, Marc Zyngier wrote:
> Implement the timer save restore as a direct translation of
> the assembly code version.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
