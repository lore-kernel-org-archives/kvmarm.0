From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2] target-arm: Store SPSR_EL1 state in banked_spsr[1]
 (SPSR_svc)
Date: Tue, 17 Mar 2015 20:38:16 +0100
Message-ID: <20150317193816.GB23225@cbox>
References: <1426620735-2454-1-git-send-email-peter.maydell@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BD0648FAE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Mar 2015 15:31:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6VPaJQVx9hVD for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Mar 2015 15:31:12 -0400 (EDT)
Received: from mail-la0-f41.google.com (mail-la0-f41.google.com
 [209.85.215.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 382F648FAB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Mar 2015 15:31:11 -0400 (EDT)
Received: by ladw1 with SMTP id w1so17967396lad.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Mar 2015 12:37:48 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1426620735-2454-1-git-send-email-peter.maydell@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, Greg Bellows <greg.bellows@linaro.org>, qemu-devel@nongnu.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 17, 2015 at 07:32:15PM +0000, Peter Maydell wrote:
> The AArch64 SPSR_EL1 register is architecturally mandated to
> be mapped to the AArch32 SPSR_svc register. This means its
> state should live in QEMU's env->banked_spsr[1] field.
> Correct the various places in the code that incorrectly
> put it in banked_spsr[0].
> 
> Signed-off-by: Peter Maydell <peter.maydell@linaro.org>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>


Alex, will you respin the SPSR patch based on this one then?  You can
change the authorship on the SPSR patch to yourself if you prefer.

Thanks,
-Christoffer
