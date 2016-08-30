From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH v3 3/5] arm/arm64: vgic-new: Introduce find_reg_by_id()
Date: Tue, 30 Aug 2016 14:41:56 +0200
Message-ID: <20160830124156.GI10162@cbox>
References: <1472037609-4164-1-git-send-email-vijay.kilari@gmail.com>
 <1472037609-4164-4-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 774DD40F90
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2016 08:31:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UycKil987qRW for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Aug 2016 08:31:34 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5960240B58
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2016 08:31:33 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id i5so33662500wmg.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2016 05:39:38 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1472037609-4164-4-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: vijay.kilari@gmail.com
Cc: marc.zyngier@arm.com, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 24, 2016 at 04:50:07PM +0530, vijay.kilari@gmail.com wrote:
> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> 
> In order to implement vGICv3 CPU interface access, we will need to perform
> table lookup of system registers. We would need both index_to_params() and
> find_reg() exported for that purpose, but instead we export a single
> function which combines them both.
> 
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
