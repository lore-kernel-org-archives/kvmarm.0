From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 13/28] ARM: KVM: Add banked registers save/restore
Date: Tue, 9 Feb 2016 19:42:57 +0100
Message-ID: <20160209184257.GQ5171@cbox>
References: <1454583645-10144-1-git-send-email-marc.zyngier@arm.com>
 <1454583645-10144-14-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98082499FE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2016 13:36:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vd4ihY3KVeoz for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Feb 2016 13:36:31 -0500 (EST)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AE2C3499E8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2016 13:36:31 -0500 (EST)
Received: by mail-wm0-f46.google.com with SMTP id 128so208475971wmz.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Feb 2016 10:42:20 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1454583645-10144-14-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 04, 2016 at 11:00:30AM +0000, Marc Zyngier wrote:
> Banked registers are one of the many perks of the 32bit architecture,
> and the world switch needs to cope with it.
> 
> This requires some "special" accessors, as these are not accessed
> using a standard coprocessor instruction.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
