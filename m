From: Christoffer Dall <cdall@linaro.org>
Subject: Re: How to trap a real interrupt to EL2 ?
Date: Tue, 4 Jul 2017 13:12:12 +0200
Message-ID: <20170704111212.GQ4066@cbox>
References: <CAPB=Z-o0-fGEvaxmwUVnSUTUAVWa0GgWupaaFcjJNecpeX3mrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A27E040D58
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jul 2017 07:11:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N8-pF2ZPoMX8 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jul 2017 07:11:55 -0400 (EDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 836E640A80
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jul 2017 07:11:55 -0400 (EDT)
Received: by mail-wm0-f52.google.com with SMTP id 62so193136927wmw.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Jul 2017 04:12:16 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAPB=Z-o0-fGEvaxmwUVnSUTUAVWa0GgWupaaFcjJNecpeX3mrQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Raz <raziebe@gmail.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 03, 2017 at 09:56:06PM +0000, Raz wrote:
> Hey
> 
> I am trying to trap any real IRQ  into EL2.
> I created a thin hypervisor with mmu enabled and set hcr_el2 as follows:
> hcr_el2= HCR_IMO  | HCR_VM | HCR_RW.
> 
> 
> Now it seems that once I set hcr_el2 to the above value and then exit from
> EL2 I immediately jump back to EL2.

You could read the ESR_EL2 and figure out what caused the exception...

-Christoffer
