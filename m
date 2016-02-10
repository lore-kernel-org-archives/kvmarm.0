From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 5/8] ARM: KVM: Switch the CP reg search to be a binary
 search
Date: Wed, 10 Feb 2016 13:44:47 +0100
Message-ID: <20160210124447.GK5171@cbox>
References: <1454931622-14902-1-git-send-email-marc.zyngier@arm.com>
 <1454931622-14902-6-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D20849AD4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Feb 2016 07:38:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yFK8YC810xno for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Feb 2016 07:38:17 -0500 (EST)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B812249B0C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Feb 2016 07:38:17 -0500 (EST)
Received: by mail-wm0-f50.google.com with SMTP id g62so25077602wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Feb 2016 04:44:09 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1454931622-14902-6-git-send-email-marc.zyngier@arm.com>
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

On Mon, Feb 08, 2016 at 11:40:19AM +0000, Marc Zyngier wrote:
> Doing a linear search is a bit silly when we can do a binary search.
> Not that we trap that so many things that it has become a burden yet,
> but it makes sense to align it with the arm64 code.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
