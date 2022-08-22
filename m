Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 311FBC32774
	for <kvmarm@archiver.kernel.org>; Mon, 22 Aug 2022 17:18:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DF4F4C8D4;
	Mon, 22 Aug 2022 13:18:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lALCdP1tm-pJ; Mon, 22 Aug 2022 13:18:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 314BB4C8D1;
	Mon, 22 Aug 2022 13:18:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 691E44C8CD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Aug 2022 13:18:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vQJ1hrWnXT1p for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Aug 2022 13:18:17 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E02C4C8CA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Aug 2022 13:18:17 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1661188696;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=fDT0NzG0FkOZTyIfEMiwc/td94ymUGlK2/HiuIYhkVw=;
 b=VCRD7T2Vikex064ekKgNnYPzP/DAPAtkiZSxAyuufUTDmOA6cud1sDCKaJrtoxiUiD6hvK
 UhWidu46vjYjS0YeHcrsgJjDCQBaxLqulbRzLo7ztbElbFsZdIJBSeL1vXNe6Psyzb2BhP
 h7S4mRR3Plg9MD1zLxvsbEel1nOjPOE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-610-LSbWQeJyO5iO-KtXUUFwyA-1; Mon, 22 Aug 2022 13:18:15 -0400
X-MC-Unique: LSbWQeJyO5iO-KtXUUFwyA-1
Received: by mail-wm1-f69.google.com with SMTP id
 n7-20020a1c2707000000b003a638356355so4462895wmn.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Aug 2022 10:18:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc;
 bh=fDT0NzG0FkOZTyIfEMiwc/td94ymUGlK2/HiuIYhkVw=;
 b=hf4UrmD10jyLDnX6Dc5pCkY0yzSdtbgR+D6mAsT1xe7/zDJCkzBPmA9qm0B0Aq5ywd
 fgNh14OQrsdtq83s3eTiv7z0mw6/sGYkl1h3Fpy+w7N9T2G4a4PWs5Ag/eEIaHAjAp1G
 k4F46CXeGrjX5TQ8AOnHBIx5DoY8Xybs9XEJxwKrVNp7C1YdNdSies040ehGrXfQgbTl
 E5AnHsT6kYxvPAGIwaCTmhdnRjr5z98JZTBWNBGyp+1mqmyOpw0Z/aWJbVCn7LY966rY
 NV1Rvi27uPnUmUNU5ynpyJHllC19TUjt9eOp9JePQLdEDQUtRLlT9HL6WtadTQraJb8s
 OXbQ==
X-Gm-Message-State: ACgBeo2GlIWC8jOIxcz6NH0E+rGcnxBhhu17hz8ompEzzaY81bmMV91W
 W5PGJdTJXOVJ2eh9U69cp40wKwehjHQv13NtNPIPn6E5FcpNG9DcizQRDgOWwMPagRCMOZFFNXv
 zcOjqYYAKAvTExdbPYocs9iMV
X-Received: by 2002:a05:600c:42ca:b0:3a6:3b06:92bd with SMTP id
 j10-20020a05600c42ca00b003a63b0692bdmr9729428wme.11.1661188694054; 
 Mon, 22 Aug 2022 10:18:14 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6+IYglItshBwaPPpRAzS01T43FN9+dUi4FLjFhCug7p7YEh483os0Z+YBPlQqSBN5wAQivlA==
X-Received: by 2002:a05:600c:42ca:b0:3a6:3b06:92bd with SMTP id
 j10-20020a05600c42ca00b003a63b0692bdmr9729415wme.11.1661188693822; 
 Mon, 22 Aug 2022 10:18:13 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 x2-20020adfffc2000000b0021e5bec14basm11950426wrs.5.2022.08.22.10.18.12
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 22 Aug 2022 10:18:13 -0700 (PDT)
Message-ID: <aac8f6c9-c817-cde3-03ef-5c203899d269@redhat.com>
Date: Mon, 22 Aug 2022 19:18:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] mailmap: Update Oliver's email address
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
References: <20220819190158.234290-1-oliver.upton@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220819190158.234290-1-oliver.upton@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 8/19/22 21:01, Oliver Upton wrote:
> While I'm still at Google, I've since switched to a linux.dev account
> for working upstream.
> 
> Add an alias to the new address.
> 
> Signed-off-by: Oliver Upton<oliver.upton@linux.dev>

Queued, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
