From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 02/22] arm64: KVM: Add a HYP-specific header file
Date: Fri, 11 Dec 2015 22:19:28 +0100
Message-ID: <20151211211928.GG27689@cbox>
References: <1449485618-9443-1-git-send-email-marc.zyngier@arm.com>
 <1449485618-9443-3-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A2C3407A0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Dec 2015 16:16:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IfN77Ui1Oz7m for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Dec 2015 16:16:39 -0500 (EST)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6EB4D40402
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Dec 2015 16:16:38 -0500 (EST)
Received: by mail-wm0-f41.google.com with SMTP id c17so26271279wmd.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Dec 2015 13:18:42 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1449485618-9443-3-git-send-email-marc.zyngier@arm.com>
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

On Mon, Dec 07, 2015 at 10:53:18AM +0000, Marc Zyngier wrote:
> In order to expose the various EL2 services that are private to
> the hypervisor, add a new hyp.h file.
> 
> So far, it only contains mundane things such as section annotation
> and VA manipulation.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
