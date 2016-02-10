From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 3/8] ARM: KVM: Enforce sorting of all CP tables
Date: Wed, 10 Feb 2016 13:44:42 +0100
Message-ID: <20160210124442.GJ5171@cbox>
References: <1454931622-14902-1-git-send-email-marc.zyngier@arm.com>
 <1454931622-14902-4-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7491049AE6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Feb 2016 07:38:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PHDIG9Jvj+Bj for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Feb 2016 07:38:12 -0500 (EST)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E29349AE3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Feb 2016 07:38:12 -0500 (EST)
Received: by mail-wm0-f54.google.com with SMTP id 128so25173253wmz.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Feb 2016 04:44:03 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1454931622-14902-4-git-send-email-marc.zyngier@arm.com>
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

On Mon, Feb 08, 2016 at 11:40:17AM +0000, Marc Zyngier wrote:
> Since we're obviously terrible at sorting the CP tables, make sure
> we're going to do it properly (or fail to boot). arm64 has had the
> same mechanism for a while, and nobody ever broke it...
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
