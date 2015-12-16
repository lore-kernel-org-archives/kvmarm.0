From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 1/3] kvm: arm: arm64: remove unreferenced S2_PGD_ORDER
Date: Wed, 16 Dec 2015 21:30:19 +0100
Message-ID: <20151216203019.GC24889@cbox>
References: <1447673298-25503-1-git-send-email-vladimir.murzin@arm.com>
 <1447673298-25503-2-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17B3241267
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2015 15:27:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zHPVzSOnuF-3 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Dec 2015 15:27:56 -0500 (EST)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3238641280
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2015 15:27:56 -0500 (EST)
Received: by mail-wm0-f41.google.com with SMTP id l126so55251093wml.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2015 12:30:18 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1447673298-25503-2-git-send-email-vladimir.murzin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 16, 2015 at 11:28:16AM +0000, Vladimir Murzin wrote:
> Since commit a987370 "arm64: KVM: Fix stage-2 PGD allocation to have
> per-page refcounting" there is no reference to S2_PGD_ORDER, so kill it
> for the good.
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
