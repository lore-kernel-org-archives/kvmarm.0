From: Jintack Lim <jintack.lim@linaro.org>
Subject: Re: How to trap a real interrupt to EL2 ?
Date: Mon, 3 Jul 2017 21:25:37 -0400
Message-ID: <CAHyh4xgwxbmXoZuBDOzseQQPDYwuGitSCbZx=jHWNoqPcNa4eg@mail.gmail.com>
References: <CAPB=Z-o0-fGEvaxmwUVnSUTUAVWa0GgWupaaFcjJNecpeX3mrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC58040CE0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jul 2017 21:25:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6A-ojQIWuPmB for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Jul 2017 21:25:20 -0400 (EDT)
Received: from mail-qk0-f172.google.com (mail-qk0-f172.google.com
 [209.85.220.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9C55540A80
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jul 2017 21:25:20 -0400 (EDT)
Received: by mail-qk0-f172.google.com with SMTP id p21so158147209qke.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 03 Jul 2017 18:25:40 -0700 (PDT)
Received: from mail-qt0-f170.google.com (mail-qt0-f170.google.com.
 [209.85.216.170])
 by smtp.gmail.com with ESMTPSA id w46sm14733688qtw.28.2017.07.03.18.25.38
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Mon, 03 Jul 2017 18:25:38 -0700 (PDT)
Received: by mail-qt0-f170.google.com with SMTP id 32so155223468qtv.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 03 Jul 2017 18:25:38 -0700 (PDT)
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

Hi Raz,

On Mon, Jul 3, 2017 at 5:56 PM, Raz <raziebe@gmail.com> wrote:
> Hey
>
> I am trying to trap any real IRQ  into EL2.
> I created a thin hypervisor with mmu enabled and set hcr_el2 as follows:
> hcr_el2= HCR_IMO  | HCR_VM | HCR_RW.
>
>
> Now it seems that once I set hcr_el2 to the above value and then exit from
> EL2 I immediately jump back to EL2.

Did you change irq states once you received irqs in EL2?
If not, my guess is that you have pending irqs when you return from
EL2 to lower exception levels.

Thanks,
Jintack

>
> Any idea why ?
>
>
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>
