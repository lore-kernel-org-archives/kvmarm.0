Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0A2BC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 17 Nov 2022 15:19:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34FC84B83B;
	Thu, 17 Nov 2022 10:19:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GR-wpXY6PEhB; Thu, 17 Nov 2022 10:19:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1123A4B7F0;
	Thu, 17 Nov 2022 10:19:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 909794B739
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2022 10:19:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jzN7Q3Tu4WyI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Nov 2022 10:19:27 -0500 (EST)
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com
 [209.85.214.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B1E944B6DD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2022 10:19:27 -0500 (EST)
Received: by mail-pl1-f174.google.com with SMTP id d20so1888815plr.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2022 07:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=54/qpLgKvMYRxZZN8WRThBEEYZ9T1CEvYfUVPrQm8ww=;
 b=iMSmmJd/PxvPh5Sz4Mhlv1D7h60/wqpXa0IlfaaP18ffK5JF15qrDhUVUrU0mPM8j5
 +yh01SuAl11IdhGv9HRnwbEbasiIbUwNJEroOSBoHC0PSRXsMxFlfF8m0vO27W0kb1Pm
 KpWAdkZ8OeO3IpRpd7GTMe3WaNU7LXQu8BNCDaNhWSHry1EDfm4x45qAKDcZTJ20US1O
 HaNzNoB5jQwXfuuGssFqSarSg2xv7H8v2ew9s7NTFe7wL3tI+gGTER+rUYg94g+fS9ez
 W2tfqJxdHRLZU8/vA1csfuG18K2GHHfSzgBem4hC01N5DJZYllLM7dekVdhJHFeniQQy
 KmQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=54/qpLgKvMYRxZZN8WRThBEEYZ9T1CEvYfUVPrQm8ww=;
 b=XXRcjLYaGOqSebPqPB7MZhbJXChacMTuJ7oR5D6Z8hoB56gDsZAP23JNC6C9nin7Yn
 cOmX2cO4Kv5f1TEH531eta4tAm6hbLFdqRoL+dKY/TRUdZOknFn9U1MTbsj/sTmfd6mV
 k8CE4M+/+SzrWDd3pXtRKrylbNp0rtgh72enEbFfHNeB6SHWlxJcTY4XwPjYsvFNRVY/
 DWicSLehIfdu2zDhZD0Mkh+aLNHcfEl+Lp38tpoonrjjOyo5GiVUUS0+D7pbK7DwxpwP
 7aQRzk1A5IufQXWBbQx8iEGMlSsUHpV9MbpZpPlOEYVH7H2UYr0ml/kaYWSCNkf1v676
 p5uQ==
X-Gm-Message-State: ANoB5pltJ/m+MR1NeClsHIffeRUrjSOJ1jPjDcHp5Tyim8PmQSo2Mvnm
 dpnvnrfJzZpuX+B1Wxcip/brdQ==
X-Google-Smtp-Source: AA0mqf4wrBLIgo7T2s4WuThT5jIfJYx8a5rV1w04DyLTsZXzfk7fRoTfBUBdt+cr0oVtZWuIShH4JQ==
X-Received: by 2002:a17:902:cf05:b0:186:de22:7968 with SMTP id
 i5-20020a170902cf0500b00186de227968mr3286934plg.3.1668698366550; 
 Thu, 17 Nov 2022 07:19:26 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 b4-20020a62cf04000000b005668b26ade0sm1242098pfg.136.2022.11.17.07.19.25
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 17 Nov 2022 07:19:25 -0800 (PST)
Date: Thu, 17 Nov 2022 15:19:21 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 2/2] KVM: arm64: selftests: Disable single-step without
 relying on ucall()
Message-ID: <Y3ZQ+fCobB4DOc+S@google.com>
References: <20221117002350.2178351-1-seanjc@google.com>
 <20221117002350.2178351-3-seanjc@google.com>
 <Y3WF8YlvFm8NGYHd@google.com> <Y3WMeovid9z1qOjD@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y3WMeovid9z1qOjD@google.com>
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
> On Thu, Nov 17, 2022, Oliver Upton wrote:
> > On Thu, Nov 17, 2022 at 12:23:50AM +0000, Sean Christopherson wrote:
> > > Automatically disable single-step when the guest reaches the end of the
> > > verified section instead of using an explicit ucall() to ask userspace to
> > > disable single-step.  An upcoming change to implement a pool-based scheme
> > > for ucall() will add an atomic operation (bit test and set) in the guest
> > > ucall code, and if the compiler generate "old school" atomics, e.g.
> > 
> > Off topic, but I didn't ask when we were discussing this issue. What is
> > the atomic used for in the pool-based ucall implementation?
> 
> To avoid having to plumb an "id" into the guest, vCPUs grab a ucall entry from
> the pool on a first-come first-serve basis, and then release the entry when the
> ucall is complete.  The current implementation is a bitmap, e.g. every possible
> entry has a bit in the map, and vCPUs do an atomic bit-test-and-set to claim an
> entry.
> 
> Ugh.  And there's a bug.  Of course I notice it after sending the pull request.
> Depsite being defined in atomic.h, and despite clear_bit() being atomic in the
> kernel, tools' clear_bit() isn't actually atomic.  Grr.
> 
> Doesn't cause problems because there are so few multi-vCPU selftests, but that
> needs to be fixed.  Best thing would be to fix clear_bit() itself.

Ha!  And I bet when clear_bit() is fixed, this test will start failing again
because the ucall() to activate single-step needs to release the entry _after_
exiting to the host, i.e. single-step will be enabled across the atomic region
again.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
