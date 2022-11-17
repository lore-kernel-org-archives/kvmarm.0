Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDDDAC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 17 Nov 2022 22:33:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5258A4B89F;
	Thu, 17 Nov 2022 17:33:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IvhhhTYOkcwC; Thu, 17 Nov 2022 17:33:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C2654B7FC;
	Thu, 17 Nov 2022 17:33:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E8874B754
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2022 17:32:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H9Fy8BstPBlR for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Nov 2022 17:32:58 -0500 (EST)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
 [209.85.210.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F1E174B69D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2022 17:32:57 -0500 (EST)
Received: by mail-pf1-f176.google.com with SMTP id d192so3195205pfd.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2022 14:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=JJnX0WEos5jTRigFggqcWTgwGYoctrWx0Q/bRYwgPOw=;
 b=orjwgIe8kl6hEsdghGmcAPLmmi79K3QzB0hGVLCFUsglgQGZ8IidYAjJg/GV/FkMG7
 YB2CDLhUOoJ2G1Mxu+LekKxKsCieo31v5V6eqREZVDobQElRzRHpP1yyPiS1SIh6qc9E
 syPdIm+LBmeWIDtVfWYaqyh5WhEykp+DyFu/8QImqc/L8aTMhenEivOBPO2YDaW9MNrU
 sCQdT2+9Tz4TB/z8MFExA73zCjSbEpbuT9w2ifakvP/HYNZ8q980hn3+6fb8LMQb4gu2
 sNl6/ZRrJiDtK48TYUhTcIM5kSgFa69VE7BFzSDb8a0j0LQOg6/pTb507wWlNkEK8f0b
 kCNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=JJnX0WEos5jTRigFggqcWTgwGYoctrWx0Q/bRYwgPOw=;
 b=5aSyeKR442k5oTrRDYe/MCEf+/WOw85zk0kIpKJ5QynseJjH16PVIN7ml/8eao4mYG
 Q9jafkgra/fVd+QK825U3ByKTeRU7BJ8xMYvL6zjMIWK6ZPgwqfsSIPtajJKh/h9IXiL
 LJ9tljo6MeK8ifDvxGJyJsDBhv5e7wydER47GYyPBqeoXH4jT3xDfYhe2o38/EWDXK1p
 O0PNoDaIAi4d4trXCkwg1vH04wfbxLk2es0khEPj/m9+eKqth1BNzYiWVOkJ9vob2yJj
 1FVOjpDPlmNx58HPPgRTKAz/siRIdnjOLQa3JqA7Md/n752pTFmSxnYZwWJIn/ZwUYey
 HDfA==
X-Gm-Message-State: ANoB5pkHH7bfcibVpW1XTIv36KX7ariAS37lhSjOndX+OBcSPBVaIxXs
 Gg6w1JLW8Z3R6b0GQjwWbgjkiA==
X-Google-Smtp-Source: AA0mqf62hgVFP75vxpYXME1e9myoKhlSOl3NkjrteC+H66jW50x5Upfk3tLqM3B4NZYvwuXH4gz+ag==
X-Received: by 2002:a63:ff62:0:b0:476:898c:ded8 with SMTP id
 s34-20020a63ff62000000b00476898cded8mr4068515pgk.251.1668724376940; 
 Thu, 17 Nov 2022 14:32:56 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 k186-20020a6324c3000000b0046fd180640asm1561643pgk.24.2022.11.17.14.32.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 17 Nov 2022 14:32:56 -0800 (PST)
Date: Thu, 17 Nov 2022 22:32:53 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 2/2] KVM: arm64: selftests: Disable single-step without
 relying on ucall()
Message-ID: <Y3a2lfLLys4BtET3@google.com>
References: <20221117002350.2178351-1-seanjc@google.com>
 <20221117002350.2178351-3-seanjc@google.com>
 <Y3WF8YlvFm8NGYHd@google.com> <Y3WMeovid9z1qOjD@google.com>
 <Y3ZQ+fCobB4DOc+S@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y3ZQ+fCobB4DOc+S@google.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Thu, Nov 17, 2022, Sean Christopherson wrote:
> On Thu, Nov 17, 2022, Sean Christopherson wrote:
> > On Thu, Nov 17, 2022, Oliver Upton wrote:
> > > On Thu, Nov 17, 2022 at 12:23:50AM +0000, Sean Christopherson wrote:
> > > > Automatically disable single-step when the guest reaches the end of the
> > > > verified section instead of using an explicit ucall() to ask userspace to
> > > > disable single-step.  An upcoming change to implement a pool-based scheme
> > > > for ucall() will add an atomic operation (bit test and set) in the guest
> > > > ucall code, and if the compiler generate "old school" atomics, e.g.
> > > 
> > > Off topic, but I didn't ask when we were discussing this issue. What is
> > > the atomic used for in the pool-based ucall implementation?
> > 
> > To avoid having to plumb an "id" into the guest, vCPUs grab a ucall entry from
> > the pool on a first-come first-serve basis, and then release the entry when the
> > ucall is complete.  The current implementation is a bitmap, e.g. every possible
> > entry has a bit in the map, and vCPUs do an atomic bit-test-and-set to claim an
> > entry.
> > 
> > Ugh.  And there's a bug.  Of course I notice it after sending the pull request.
> > Depsite being defined in atomic.h, and despite clear_bit() being atomic in the
> > kernel, tools' clear_bit() isn't actually atomic.  Grr.
> > 
> > Doesn't cause problems because there are so few multi-vCPU selftests, but that
> > needs to be fixed.  Best thing would be to fix clear_bit() itself.
> 
> Ha!  And I bet when clear_bit() is fixed, this test will start failing again
> because the ucall() to activate single-step needs to release the entry _after_
> exiting to the host, i.e. single-step will be enabled across the atomic region
> again.

LOL, yep.  Test gets stuck in __aarch64_ldclr8_sync().
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
