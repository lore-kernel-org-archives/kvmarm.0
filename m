Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E1AC433EF
	for <kvmarm@archiver.kernel.org>; Mon,  4 Apr 2022 06:10:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0B754B120;
	Mon,  4 Apr 2022 02:10:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UJ9tOd1T4vbW; Mon,  4 Apr 2022 02:10:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A8C504B0EF;
	Mon,  4 Apr 2022 02:10:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0D164B0EC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 02:10:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4mCHaX4ekNsf for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2022 02:10:02 -0400 (EDT)
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com
 [209.85.166.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 92C334B159
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 02:10:02 -0400 (EDT)
Received: by mail-io1-f51.google.com with SMTP id b16so10066376ioz.3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 03 Apr 2022 23:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=8NsrVtImWjpdc3DRwbLRWqAdracGEBMqr1JyxBipXZ0=;
 b=Kb9k+FhvpMEe/hS5w3NPbD1fP2PoutHoLKAoQWUV2sI61rCyJeyBNNU937Vtq9BrS1
 6KHSnHCu16vUR8mIwUDjqWNlWcT1UdLWSlmhkfLQRIwzuAfiBe5dD5/UCxMgwkW3bN8r
 /vxlAQiWEV1OamMjGDsG/Atj7EgzYBPgw4KqnuhqgUgCPuWP2+72TvhOkmhyE5mNlhl2
 Vr8k6k7MjLjwwpwVKn6Q13CKkTBG1O0nVoIcgNAgkIs0BenHbXyyisrPYPMaWdiU8Pg5
 0ft33vVxiqsKmIErrwnsWTVyKnjsNEhmLdslddBrRopemZKqzZloOHTGAWHS+NpmZjZw
 6OuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=8NsrVtImWjpdc3DRwbLRWqAdracGEBMqr1JyxBipXZ0=;
 b=X4fB1eEaDIVs7nb+Fgiz4iQqe2slUAtuflTavy9p4ncmiykS7AXKdgLdf/b9RvIykO
 zSWEIlGi50/hfskFIASaz0JpLOwdcONESJNJNuFowNjeCPs3zhq0cHBM2z42VPbCdxZ2
 Er6xDNBJA8aRcUaFnTwDHn5DB5KQvOzriIwbEwtARUhDn1Hvdhg1Q4Cd0sL+QelKWjYx
 oY5rGgKyjaa6qz7ui52WCGfoeIcLAZjOv4GFS/s4QEPVY3c3b18LWKEnJJlf2PFvudr6
 NvYdVz7s3ZvMBbacL4n9xvsA04rF4KXT8se0g2UgfJF/Aejd9+LO87QTuFjU8Qh0TDgB
 RE9g==
X-Gm-Message-State: AOAM5318mySPILAAD6g+f1ZJbC3NEU3qrjCj5Uqn1yU7tLc88/p9j39Y
 3o3QEc51pfR/RDml9DhhRv+0Mw==
X-Google-Smtp-Source: ABdhPJw+t1GS5uz9Bam4IoZJ75AdBpJNgGE1/0FoEc58mJE8ZXDInNTIx5EbtWNTO9p1HU3dYUv4AQ==
X-Received: by 2002:a05:6638:2653:b0:323:d901:9272 with SMTP id
 n19-20020a056638265300b00323d9019272mr3560184jat.208.1649052601665; 
 Sun, 03 Apr 2022 23:10:01 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 u15-20020a056e021a4f00b002c665afb993sm5297152ilv.11.2022.04.03.23.10.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 03 Apr 2022 23:10:01 -0700 (PDT)
Date: Mon, 4 Apr 2022 06:09:57 +0000
From: Oliver Upton <oupton@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v6 00/18] Support SDEI Virtualization
Message-ID: <YkqLtYquZQAKjbAk@google.com>
References: <20220403153911.12332-1-gshan@redhat.com>
 <a3bf5b44-0ab8-fd85-5557-6c496fd68bc1@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a3bf5b44-0ab8-fd85-5557-6c496fd68bc1@redhat.com>
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

Hi Gavin,

On Sun, Apr 03, 2022 at 11:47:07PM +0800, Gavin Shan wrote:
> I'm explicitly copying Oliver, James, Mark and Shannon to avoid resending this series.
> It seems they have been skipped even I explicitly copied them by 'git send-email --cc=<email-addr>'.

Dunno about others, but FWIW your first crack at sending this series out
arrived in my inbox just fine :)

Thanks for cc'ing me, I'll find some time this week to take a look.

--
Best,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
