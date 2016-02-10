From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 4/8] ARM: KVM: Rename struct coproc_reg::is_64 to is_64bit
Date: Wed, 10 Feb 2016 13:44:52 +0100
Message-ID: <20160210124452.GL5171@cbox>
References: <1454931622-14902-1-git-send-email-marc.zyngier@arm.com>
 <1454931622-14902-5-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3A3C49AF2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Feb 2016 07:38:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fm9Qq64yPP0C for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Feb 2016 07:38:22 -0500 (EST)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0E99C49AE3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Feb 2016 07:38:22 -0500 (EST)
Received: by mail-wm0-f54.google.com with SMTP id 128so25178893wmz.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Feb 2016 04:44:13 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1454931622-14902-5-git-send-email-marc.zyngier@arm.com>
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

On Mon, Feb 08, 2016 at 11:40:18AM +0000, Marc Zyngier wrote:
> As we're going to play some tricks on the struct coproc_reg,
> make sure its 64bit indicator field matches that of coproc_params.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
