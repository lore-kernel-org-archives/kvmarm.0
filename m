From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64: KVM: Remove duplicating init code for setting VMID
Date: Thu, 22 Sep 2016 13:23:25 +0200
Message-ID: <20160922112325.GC9101@cbox>
References: <1474532281-37917-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B9BA49B36
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2016 07:14:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i9KFJYJbJCIh for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2016 07:14:10 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AE51D49B35
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2016 07:14:10 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id l132so321750459wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2016 04:23:19 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1474532281-37917-1-git-send-email-vladimir.murzin@arm.com>
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

On Thu, Sep 22, 2016 at 09:18:01AM +0100, Vladimir Murzin wrote:
> By now both VHE and non-VHE initialisation sequences query supported
> VMID size. Lets keep only single instance of this code under
> init_common_resources().
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>

Applied, thanks!
-Christoffer
