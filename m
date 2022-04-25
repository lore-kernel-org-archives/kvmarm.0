Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2327C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 25 Apr 2022 15:13:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24FF14B23A;
	Mon, 25 Apr 2022 11:13:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CKbfFxHU5h96; Mon, 25 Apr 2022 11:13:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17A854B229;
	Mon, 25 Apr 2022 11:13:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14F9F4B0D6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 11:13:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mJyGFIxWivQq for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Apr 2022 11:13:05 -0400 (EDT)
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com
 [209.85.216.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 206B24A19A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 11:13:05 -0400 (EDT)
Received: by mail-pj1-f41.google.com with SMTP id
 m14-20020a17090a34ce00b001d5fe250e23so2864544pjf.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 08:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=9K6RsS9yPXS4qwCnQU4PvhBaosajT6TXjveseEixd9Y=;
 b=Td8+8OcwoY3gMAuGy+Nr7PDBXjeTKxoXi6wOU0bvpucj+ZegyFRrb3nNV04TsgD8WB
 RSOLS2NTdczLjZ1AveRgpgmHKul+uTROWO9g2KaNG4ZQ/Tsef4I5BA9eGSstyX/lebc1
 Xjp4PIm9vk6XpnMvJs0fbh4nF26ppyY+R+HNauGnycg+BDyfkicDyzGEi9n04tJS/Go+
 ifSZhxhhIwUFqugC2nYiradOOf3VKGY6aKUxugzPUNvX47TUhTcufsa61KoMLhYPnPOk
 sGM6dlEaPevIBdzIJShxBddisnmzp79s5CDR38STSlzZyUV59TW3Q8W7gwBd6MsLYRY2
 /1Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=9K6RsS9yPXS4qwCnQU4PvhBaosajT6TXjveseEixd9Y=;
 b=6AF8kTBirSb6WaDPRTZuuO738b3FRgA6iL6aZmB281X4Tf1/b+8YNT9tIcLTyXrEo0
 U4tEDv2XeQEZkJgiycwvwNCh6XS6xgPVSnR0UF5ATqUkRipzbBO9HNwHSdi2mgmkUeFO
 L3eCowGhhl4gVS1EYou6naOydwJib1JQIBfWiSrrZxIG7c0NBawpI4mBPFkFjmHis1lB
 x+l8v3Li0iKPuaJZ/iHiZNs7UmOyKCn9Sn08axWlZJUdmBHm9Q0XNl4BoFJHFFJZffad
 o3+c7E2tQVLZBKr8o2RBs/s5vvhZz79M8duMfZ9QHvIOOdlz9Z0il1ppcvCuu4BlRFDN
 TGPA==
X-Gm-Message-State: AOAM5329za/qxoAxiqst6CQNhIQMMa2ocrSD+PNXuWTj2OLqvmrXTS5N
 /tn7Io3U1POROfOSXhqN1QHaFA==
X-Google-Smtp-Source: ABdhPJwUOlDnUHF5k3woHlV9TQvV9nTL1L7mwNMrpk9JJnQLty3+DM3IyKzJ5rF+Kktvx1yg6+/bZQ==
X-Received: by 2002:a17:90b:390b:b0:1d6:b448:b26f with SMTP id
 ob11-20020a17090b390b00b001d6b448b26fmr21328663pjb.61.1650899583966; 
 Mon, 25 Apr 2022 08:13:03 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 p64-20020a622943000000b004fdd5c07d0bsm11630040pfp.63.2022.04.25.08.13.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 25 Apr 2022 08:13:03 -0700 (PDT)
Date: Mon, 25 Apr 2022 15:13:00 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [RFC PATCH 06/17] KVM: arm64: Implement break-before-make
 sequence for parallel walks
Message-ID: <Yma6fEoRstvmu6sd@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-7-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220415215901.1737897-7-oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Ben Gardon <bgardon@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

On Fri, Apr 15, 2022, Oliver Upton wrote:
> The ARM architecture requires that software use the 'break-before-make'
> sequence whenever memory is being remapped.

What does "remapped" mean here?  Changing the pfn?  Promoting/demoting to/from a
huge page?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
