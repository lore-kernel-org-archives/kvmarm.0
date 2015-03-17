From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2] target-arm: Store SPSR_EL1 state in banked_spsr[1]
 (SPSR_svc)
Date: Tue, 17 Mar 2015 19:44:47 +0000
Message-ID: <CAFEAcA9CMAG3sU5dH7mo4YVuqC5EeoTD3PTS2BypNcG7wAKxnA@mail.gmail.com>
References: <1426620735-2454-1-git-send-email-peter.maydell@linaro.org>
 <20150317193816.GB23225@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9850848FB3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Mar 2015 15:38:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qiuYVPKacyMO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Mar 2015 15:38:31 -0400 (EDT)
Received: from mail-ig0-f173.google.com (mail-ig0-f173.google.com
 [209.85.213.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9089948FB2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Mar 2015 15:38:31 -0400 (EDT)
Received: by igcau2 with SMTP id au2so44265122igc.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Mar 2015 12:45:08 -0700 (PDT)
In-Reply-To: <20150317193816.GB23225@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Greg Bellows <greg.bellows@linaro.org>, QEMU Developers <qemu-devel@nongnu.org>, Patch Tracking <patches@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 17 March 2015 at 19:38, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> On Tue, Mar 17, 2015 at 07:32:15PM +0000, Peter Maydell wrote:
>> The AArch64 SPSR_EL1 register is architecturally mandated to
>> be mapped to the AArch32 SPSR_svc register. This means its
>> state should live in QEMU's env->banked_spsr[1] field.
>> Correct the various places in the code that incorrectly
>> put it in banked_spsr[0].
>>
>> Signed-off-by: Peter Maydell <peter.maydell@linaro.org>
>
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

Thanks. It also occurs to me that we could avoid some of these
magic 1/6/7 numbers by defining some constants BANK_USR,
BANK_SVC, BANK_ABT, etc for the return values from bank_number
(ie the indexes into env->banked_* arrays),
and then using them where we need to refer to particular
banked_* entries elsewhere. Then for instance this array
in aarch64_banked_spsr_index() looks like

         [1] = BANK_SVC, /* EL1.  */
         [2] = BANK_HYP, /* EL2.  */
         [3] = BANK_MON, /* EL3.  */

and the mapping between the AArch32 and AArch64 SPSRs is
suddenly much more obvious and easy to check.

-- PMM
