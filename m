Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 457D7C00140
	for <kvmarm@archiver.kernel.org>; Fri, 12 Aug 2022 17:57:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0B1F4EF59;
	Fri, 12 Aug 2022 13:57:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YxLqTbcJwWnw; Fri, 12 Aug 2022 13:57:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A18D4EF54;
	Fri, 12 Aug 2022 13:57:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 632CD4EF58
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Aug 2022 13:57:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GKxUp43U2xl4 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Aug 2022 13:57:16 -0400 (EDT)
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com
 [209.85.210.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 826714EF52
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Aug 2022 13:57:16 -0400 (EDT)
Received: by mail-pf1-f178.google.com with SMTP id f30so1565439pfq.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Aug 2022 10:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc;
 bh=On7C2WVHpUSP29uDe0Zk7xxqfw94zgRBvMfSSWUNRhE=;
 b=T7d1TkRsePjPxfnWhD1hH8gtjeKcF1Ui/wCiLf7RviRGolw2Km2Y+mQXkWGuyV2Ysa
 H6cXOMgIammjqjfKqJgseTSjYpunELu99QkzL6+jdHjRpsMj3LDXqGet5nBZK0RHZkN8
 T4aiUW+Q2gG89SyvKu+Y9PDPdRwonxwoa+oWRgYQwDgUhwU9KlBRl9pUwnWaqxFo47Pw
 TBKljNA8DeNhP+p0eTHy6fSsMEsX/g21SUyG1rc+ym7PwX54GSq84BQJp4VFzwTm4QpL
 OrZAc+rbqWaBvsugzqB0PuiJGXcH73pAc35YUNpxDSkmNDuGwbYD+v4NnaUdExj9lGCS
 eACw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
 bh=On7C2WVHpUSP29uDe0Zk7xxqfw94zgRBvMfSSWUNRhE=;
 b=hi+kWx2edkln8+Y1C2a0+gcG6QeAzi3XbfNGK2JVK4sOZ2vt8HsxpjiP9UWdYArXgd
 O64oL9ByEyeQidiF1fXVxZrDEoLEpaiXz/kfjDspEh/waWg92zUGFmetYcky9g4/FpU/
 M+SjT6i771y+/fG1dP8evjT5UD6KG9ZZ1gcUxehsQjT2+Ex6zFin/pz7l8eDZACeYqOl
 rXpLyC5Vz0GYHJnZaiiYo5BSYjgY/VuQcf6hN1zQgwemecRojl2N18PDhllrUI6GVvvC
 ELjVymGWkRSdche8c2lF1rlc3p+QAIwslz88EtIUxA6RcCeb+W2t81hD5PNJuXhtzJua
 Y3sg==
X-Gm-Message-State: ACgBeo13f6sY1XfAvegnz7H6TSHvNi+qyP9A8vTC89nx2hBkatOzZ0Br
 V5LyC4E3RsPyWMXnx319jmYjPw==
X-Google-Smtp-Source: AA6agR7WF+te4SjtfCu2H/j3kNeq5igrD9TNACHGGoMYEgeEc2wnCVx2meSrLvTN+UvM4hGRXAx43Q==
X-Received: by 2002:a63:5320:0:b0:41c:89ca:f931 with SMTP id
 h32-20020a635320000000b0041c89caf931mr3918667pgb.525.1660327035251; 
 Fri, 12 Aug 2022 10:57:15 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 v7-20020a632f07000000b0041cd5ddde6fsm1591636pgv.76.2022.08.12.10.57.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 12 Aug 2022 10:57:14 -0700 (PDT)
Date: Fri, 12 Aug 2022 10:57:10 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Andrew Jones <andrew.jones@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v4 0/4] arm: pmu: Fixes for bare metal
Message-ID: <YvaUdjguLwvXabIF@google.com>
References: <20220811185210.234711-1-ricarkol@google.com>
 <20220812063300.ygeyivgzzkyzg3uo@kamzik>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220812063300.ygeyivgzzkyzg3uo@kamzik>
Cc: kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Fri, Aug 12, 2022 at 08:33:00AM +0200, Andrew Jones wrote:
> On Thu, Aug 11, 2022 at 11:52:06AM -0700, Ricardo Koller wrote:
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
> > Addressed all comments from the previous version:
> > https://lore.kernel.org/kvmarm/YvPsBKGbHHQP+0oS@google.com/T/#mb077998e2eb9fb3e15930b3412fd7ba2fb4103ca
> > - add pmu_reset() for 32-bit arm [Andrew]
> > - collect r-b from Alexandru
> 
> You forgot to pick up Oliver's r-b's and his Link suggestion.

Ahh, yes, sorry Oliver.

> I can do that again, though.

Thanks Andrew

> 
> Thanks,
> drew
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
