Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95E0AC38A02
	for <kvmarm@archiver.kernel.org>; Fri, 28 Oct 2022 09:57:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00E4240E00;
	Fri, 28 Oct 2022 05:57:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jBSIBBqmFJBT; Fri, 28 Oct 2022 05:57:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E374640D02;
	Fri, 28 Oct 2022 05:57:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7873940298
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 05:57:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QZkDO1EM73He for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Oct 2022 05:57:09 -0400 (EDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com
 [209.85.208.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6278B4024F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 05:57:09 -0400 (EDT)
Received: by mail-ed1-f46.google.com with SMTP id f7so1443060edc.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 02:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=mvHL5Drr+3t1aS/5ADf3q7iM5WIuHk2AYt4Ze0ZBgjk=;
 b=XzOlmJP/jS7VT1xg6wG+42FDDXw981TfzCCruFtGWZepNQEEDI1xBoIQxendEL6nVw
 gV++vJ7t7L7EWZHnXPGmx0WFIw3SkrgmFHy7yiCJmdCaMetbBp4gmGb8H0OpwnEhz4uA
 NXR0EIjkLtokHm+btvWViZasIH8uRkLuXGJU84pBFCN9ZAMKWmzhw1vgpkv0EaZCYXGC
 lRB/IpHGfMApklvbsCU3KW8TkXSHNoNTekYSvt6CgCgcciE56e87YjFKyn9JXOirreG8
 e5BSpaR4vnFx+66Pxz1mIral+3sROyLK+wRy96aO3CnMOlMYCH/XbevP2WLneL9Q/7Yd
 BWDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=mvHL5Drr+3t1aS/5ADf3q7iM5WIuHk2AYt4Ze0ZBgjk=;
 b=TTnwHzdRB/WcjtHYVnBmnwkdJ+QfFJg9qUmty1s81UucxSowrPrIJ3o4QC0MPIDJ9u
 9jbAMfZwyKWA8NGWN04MMaeFji4aEjz91ITWa85X3gP/IREWmOfRgQCPBoaM/TSe7bB+
 zQ+WHgrCzF5wdmX8FO3kHIE9KIS2OX0ZCaszmKJFHNokor7+vPh6KRKU0TwoG6bdK8fj
 dD+/HWlzozmACGc655QGpnQkmqkfdxZQBm4vvAIJ61hCB3QpIf9ExbEs/vIvLoIVkors
 NhA7A29ncofHfhW3DE1xEchEYEO8r4f8oq3X/2PjBTIJu8iN6MKhtgtfVbPndPosh+v/
 wVlA==
X-Gm-Message-State: ACrzQf3knLHwLK1DXQor+m5LObqH3Tze+o3IwfU/Crnz/FzEHouQgWWu
 S3F0DMLSZJykPiCsVdH2dWM0Vg==
X-Google-Smtp-Source: AMsMyM5zJVsp3vp9yM+1qZ9xU/7wt91EQOkPXZmY19wmU4+a4o6tvJjAEaJRmC8JNHIxmOjkkdPfsw==
X-Received: by 2002:a50:ff09:0:b0:456:fd61:83b3 with SMTP id
 a9-20020a50ff09000000b00456fd6183b3mr48978165edu.166.1666951028189; 
 Fri, 28 Oct 2022 02:57:08 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com.
 [34.90.227.64]) by smtp.gmail.com with ESMTPSA id
 x1-20020a05640226c100b00443d657d8a4sm2435255edd.61.2022.10.28.02.57.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 28 Oct 2022 02:57:07 -0700 (PDT)
Date: Fri, 28 Oct 2022 09:57:04 +0000
From: Quentin Perret <qperret@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 2/2] KVM: arm64: Redefine pKVM memory transitions in
 terms of source/target
Message-ID: <Y1uncNq2oyc5wALG@google.com>
References: <20221028083448.1998389-1-oliver.upton@linux.dev>
 <20221028083448.1998389-3-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221028083448.1998389-3-oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hey Oliver,

On Friday 28 Oct 2022 at 08:34:48 (+0000), Oliver Upton wrote:
> Perhaps it is just me, but the 'initiator' and 'completer' terms are
> slightly confusing descriptors for the addresses involved in a memory
> transition. Apply a rename to instead describe memory transitions in
> terms of a source and target address.

Just to provide some rationale for the initiator/completer terminology,
the very first implementation we did of this used 'sender/recipient (or
something along those lines I think), and we ended up confusing
ourselves massively. The main issue is that memory doesn't necessarily
'flow' in the same direction as the transition. It's all fine for a
donation or a share, but reclaim and unshare become funny. 'The
recipient of an unshare' can be easily misunderstood, I think.

So yeah, we ended up with initiator/completer, which may not be the
prettiest terminology, but it was useful to disambiguate things at
least.

Thanks for the review!
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
