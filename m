Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88045C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jul 2022 17:18:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E42E94D6F9;
	Mon, 18 Jul 2022 13:18:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dyEpOxq85U04; Mon, 18 Jul 2022 13:18:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C462D4D3DB;
	Mon, 18 Jul 2022 13:18:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26CAA4D3A0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 13:18:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xEebd1-0mVY7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2022 13:18:44 -0400 (EDT)
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com
 [209.85.216.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 03EB74D39B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 13:18:43 -0400 (EDT)
Received: by mail-pj1-f45.google.com with SMTP id p9so12356302pjd.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 10:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=O+93vwyZCBtIfSzt+zHZDwMtD0oUi0EihMlo7pm6fvc=;
 b=r6OoQJ3en6er/iZYe0wnDU0KNgKRWt+E0a8EaCaViv/9dnMVeDBoImj2fdN8lMKU0Z
 +ODctnO2E+tj3jyYyXR0Q/kctG9PaBcw+yg94KJZ9DIBtc3cUQs15pb87aPaZvRTWGA9
 fc365G0ro09jgrY2VdDJ7/l3PKyOg4VCdMTOE13LoX5TMUuhcGU2rw3T6aJCJP+IVhan
 vv/Z200yFtPdGSUlmAxckM/3xVG+GM+vCc/UDUuyjUda8UbchATNR3sfDPEez7/4y9Uu
 n134Hfah/MxdViGOOkSrtVvXRH0sNRa6VhrhDhkyKmnP5XZzVDfUqL/57mNSCNtz7KD1
 l5KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=O+93vwyZCBtIfSzt+zHZDwMtD0oUi0EihMlo7pm6fvc=;
 b=H86oezPiwmcazNdqF5tsgtKwVDmzXl4DbAS8jM2raveG+t+0gRmhUsqSxkBkCZ2/Zo
 dpjDKY5NRqUPbardQQUcdxrvfNpO0qfCc7Qym6AZeYLA7JE+MUqMNnEX0EjByTKYtKeG
 X3ekzGWKRgSDRzXfUkpSNRKkehXQoot6+6cTxpTd4wYLH9Xs7kb3j+0cyS6AkEtrKKXe
 dr0k9PiWJ3sewrtPvyaKl4dVZptzZP2rY/KeqJKkXkRteguAMz/kIrQoW6pSe8WbjWu6
 GMuc3ldSDG9+kuR+xxk4+xrdHI8kgRi/GwEf/Afbvdti4JhW+taXnrXX07qF75+WGEtp
 +zdw==
X-Gm-Message-State: AJIora/kKi62NmWyuOwedfNhyvZ59fWJTE7nf+cToNod261gJGrhKSgg
 yOdlxe+CtH6LeBvlQ2g+qT2jAg==
X-Google-Smtp-Source: AGRyM1tvU8nSRHjMbzxG++8pKT3KPkxakjucMRyr+1ZsowRIduO2aS8kjdBQ7saWuuzuAyWaltgE1A==
X-Received: by 2002:a17:90b:3b4b:b0:1ef:f5b0:ce60 with SMTP id
 ot11-20020a17090b3b4b00b001eff5b0ce60mr40865600pjb.71.1658164722909; 
 Mon, 18 Jul 2022 10:18:42 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150]) by smtp.gmail.com with ESMTPSA id
 w24-20020aa79558000000b0052af2e8bba3sm9556204pfq.37.2022.07.18.10.18.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 Jul 2022 10:18:42 -0700 (PDT)
Date: Mon, 18 Jul 2022 10:18:37 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH 0/3] arm: pmu: Fixes for bare metal
Message-ID: <YtWV7fDh9ihufLhM@google.com>
References: <20220718154910.3923412-1-ricarkol@google.com>
 <YtWNYGuP/Nu1HwDU@monolith.localdoman>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YtWNYGuP/Nu1HwDU@monolith.localdoman>
Cc: kvm@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 andrew.jones@linux.dev, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Jul 18, 2022 at 05:42:08PM +0100, Alexandru Elisei wrote:
> Hi,
> 
> I believe you're missing the updated email for the arm maintainer. Added it.
> 
> Thanks,
> Alex
> 
> On Mon, Jul 18, 2022 at 08:49:07AM -0700, Ricardo Koller wrote:
> > There are some tests that fail when running on bare metal (including a
> > passthrough prototype).  There are three issues with the tests.  The
> > first one is that there are some missing isb()'s between enabling event
> > counting and the actual counting. This wasn't an issue on KVM as
> > trapping on registers served as context synchronization events. The
> > second issue is that some tests assume that registers reset to 0.  And
> > finally, the third issue is that overflowing the low counter of a
> > chained event sets the overflow flag in PMVOS and some tests fail by
> > checking for it not being set.
> > 
> > I believe the third fix also requires a KVM change, but would like to
> > double check with others first.  The only reference I could find in the
> > ARM ARM is the AArch64.IncrementEventCounter() pseudocode (DDI 0487H.a,
> > J1.1.1 "aarch64/debug") that unconditionally sets the PMOVS bit on
> > overflow.
> > 
> > Ricardo Koller (3):
> >   arm: pmu: Add missing isb()'s after sys register writing
> >   arm: pmu: Reset the pmu registers before starting some tests
> >   arm: pmu: Remove checks for !overflow in chained counters tests
> > 
> >  arm/pmu.c | 34 +++++++++++++++++++++++-----------
> >  1 file changed, 23 insertions(+), 11 deletions(-)
> > 
> > -- 
> > 2.37.0.170.g444d1eabd0-goog
> > 

Right, I forgot about the new email. Thanks for the forwarding!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
