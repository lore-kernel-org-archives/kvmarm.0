From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 1/7] arm64: KVM: Move GIC accessors to arch_gicv3.h
Date: Mon, 5 Sep 2016 13:28:59 +0200
Message-ID: <20160905112859.GG26366@cbox>
References: <1471344418-19568-1-git-send-email-vladimir.murzin@arm.com>
 <1471344418-19568-2-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A50FD49B40
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Sep 2016 07:18:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AQnaFzq-9Onp for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Sep 2016 07:18:10 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9EC9249B45
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Sep 2016 07:18:10 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id 1so133704442wmz.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 05 Sep 2016 04:26:32 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1471344418-19568-2-git-send-email-vladimir.murzin@arm.com>
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
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 16, 2016 at 11:46:52AM +0100, Vladimir Murzin wrote:
> Since we are going to share vgic-v3 save/restore code with ARM
> keep arch specific accessors separately.
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
