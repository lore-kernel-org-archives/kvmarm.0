From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 03/11] KVM: arm: enable to use the ARM_DSCR_MDBGEN
 macro from KVM assembly code
Date: Tue, 30 Jun 2015 15:20:13 +0200
Message-ID: <20150630132013.GT11332@cbox>
References: <1434969694-7432-1-git-send-email-zhichao.huang@linaro.org>
 <1434969694-7432-4-git-send-email-zhichao.huang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9336256AD8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Jun 2015 09:09:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HKrZ50XhGDDZ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Jun 2015 09:09:01 -0400 (EDT)
Received: from mail-la0-f49.google.com (mail-la0-f49.google.com
 [209.85.215.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AE59D56AD5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Jun 2015 09:09:01 -0400 (EDT)
Received: by lagh6 with SMTP id h6so13087148lag.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Jun 2015 06:20:13 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1434969694-7432-4-git-send-email-zhichao.huang@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Zhichao Huang <zhichao.huang@linaro.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, huangzhichao@huawei.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jun 22, 2015 at 06:41:26PM +0800, Zhichao Huang wrote:
> Add #ifndef __ASSEMBLY__ in hw_breakpoint.h, in order to use
> the ARM_DSCR_MDBGEN macro from KVM assembly code.
> 
> Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
> Reviewed-by: Alex Bennee <alex.bennee@linaro.org>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
