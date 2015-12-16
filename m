From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 2/3] kvm: arm: make kvm_arm.h friendly to assembly code
Date: Wed, 16 Dec 2015 21:30:24 +0100
Message-ID: <20151216203024.GD24889@cbox>
References: <1447673298-25503-1-git-send-email-vladimir.murzin@arm.com>
 <1447673298-25503-3-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3315249723
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2015 15:28:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1WBbhDaoTn3z for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Dec 2015 15:28:00 -0500 (EST)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 641394972F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2015 15:28:00 -0500 (EST)
Received: by mail-wm0-f45.google.com with SMTP id l126so57044768wml.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2015 12:30:22 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1447673298-25503-3-git-send-email-vladimir.murzin@arm.com>
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

On Mon, Nov 16, 2015 at 11:28:17AM +0000, Vladimir Murzin wrote:
> kvm_arm.h is included from both C code and assembly code; however some
> definitions in this header supplied with U/UL/ULL suffixes which might
> confuse assembly once they got evaluated.
> We have _AC macro for such cases, so just wrap problem places with it.
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
