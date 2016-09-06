From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC v2 PATCH 5/7] arm64/kvm: hyp: tlb: use __tlbi() helper
Date: Tue, 6 Sep 2016 08:39:20 +0200
Message-ID: <20160906063920.GD30513@cbox>
References: <1473093097-30932-1-git-send-email-punit.agrawal@arm.com>
 <1473093097-30932-6-git-send-email-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B550840F77
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 02:28:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yVs0dL41HHhj for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 02:28:28 -0400 (EDT)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A0DF49B44
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 02:28:28 -0400 (EDT)
Received: by mail-wm0-f51.google.com with SMTP id w207so31219305wmw.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 05 Sep 2016 23:36:52 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1473093097-30932-6-git-send-email-punit.agrawal@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Sep 05, 2016 at 05:31:35PM +0100, Punit Agrawal wrote:
> From: Mark Rutland <mark.rutland@arm.com>
> 
> Now that we have a __tlbi() helper, make use of this in the arm64 KVM hyp
> code to get rid of asm() boilerplate. At the same time, we simplify
> __tlb_flush_vm_context by using __flush_icache_all(), as this has the
> appropriate instruction cache maintenance and barrier.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> [ rename tlbi -> __tlbi, convert additional sites, update commit log ]
> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
