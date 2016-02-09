From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 17/28] ARM: KVM: Add populating of fault data structure
Date: Tue, 9 Feb 2016 19:44:59 +0100
Message-ID: <20160209184459.GU5171@cbox>
References: <1454583645-10144-1-git-send-email-marc.zyngier@arm.com>
 <1454583645-10144-18-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 51301496AC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2016 13:38:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TaBfBo6dfL1e for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Feb 2016 13:38:33 -0500 (EST)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7324D49A18
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2016 13:38:33 -0500 (EST)
Received: by mail-wm0-f43.google.com with SMTP id g62so35881199wme.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Feb 2016 10:44:22 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1454583645-10144-18-git-send-email-marc.zyngier@arm.com>
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

On Thu, Feb 04, 2016 at 11:00:34AM +0000, Marc Zyngier wrote:
> On guest exit, we must take care of populating our fault data
> structure so that the host code can handle it. This includes
> resolving the IPA for permission faults, which can result in
> restarting the guest.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
