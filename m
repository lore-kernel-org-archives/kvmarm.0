From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64: KVM: Fix user access for debug registers
Date: Wed, 16 Sep 2015 15:41:41 +0200
Message-ID: <20150916134141.GA15903@cbox>
References: <1442400070-23316-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2817C413DD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2015 09:38:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J3qv8gPEY4Eu for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Sep 2015 09:38:58 -0400 (EDT)
Received: from mail-la0-f51.google.com (mail-la0-f51.google.com
 [209.85.215.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 375B2411E2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2015 09:38:57 -0400 (EDT)
Received: by lahg1 with SMTP id g1so100181237lah.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2015 06:39:56 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1442400070-23316-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Sep 16, 2015 at 11:41:10AM +0100, Marc Zyngier wrote:
> When setting the debug register from userspace, make sure that
> copy_from_user() is called with its parameters in the expected
> order. It otherwise doesn't do what you think.
> =

> Reported-by: Peter Maydell <peter.maydell@linaro.org>
> Cc: Alex Benn=E9e <alex.bennee@linaro.org>
> Fixes: 84e690bfbed1 ("KVM: arm64: introduce vcpu->arch.debug_ptr")
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

yikes!

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
