From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFT - PATCH v2 0/2] KVM/arm64: add fp/simd lazy switch support
Date: Mon, 5 Oct 2015 17:45:40 +0200
Message-ID: <20151005154540.GJ9011@cbox>
References: <1442964843-11953-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 95DF1412D6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Oct 2015 11:43:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UkyuAnX+z7T9 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Oct 2015 11:43:39 -0400 (EDT)
Received: from mail-la0-f54.google.com (mail-la0-f54.google.com
 [209.85.215.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6A43F412AF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Oct 2015 11:43:39 -0400 (EDT)
Received: by laddr2 with SMTP id dr2so10481518lad.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 05 Oct 2015 08:45:29 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1442964843-11953-1-git-send-email-m.smarduch@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Sep 22, 2015 at 04:34:01PM -0700, Mario Smarduch wrote:
> This is a 2nd itteration for arm64, v1 patches were posted by mistake from an 
> older branch which included several bugs. Hopefully didn't waste too much of 
> anyones time.
> 
> This patch series is a followup to the armv7 fp/simd lazy switch
> implementation, uses similar approach and depends on the series - see
> https://lists.cs.columbia.edu/pipermail/kvmarm/2015-September/016516.html
> 
> It's based on earlier arm64 fp/simd optimization work - see
> https://lists.cs.columbia.edu/pipermail/kvmarm/2015-July/015748.html
> 
> And subsequent fixes by Marc and Christoffer at KVM Forum hackathon to handle
> 32-bit guest on 64 bit host (and may require more here) - see
> https://lists.cs.columbia.edu/pipermail/kvmarm/2015-August/016128.html
> 
> This series has be tested with arm64 on arm64 with several FP applications 
> running on host and guest, with substantial decrease on number of 
> fp/simd context switches. From about 30% down to 2% with one guest running.
> 
> At this time I don't have arm32/arm64 working and hoping Christoffer and/or
> Marc (or anyone) can test 32-bit guest/64-bit host.
> 
Did you already have some test infrastructure/applications that I can
reuse for this purpose or do I have to write userspace software?

-Christoffer
