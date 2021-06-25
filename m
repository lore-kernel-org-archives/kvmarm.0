Return-Path: <SRS0=mXZs=LT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BEE5C2B9F4
	for <kvmarm@archiver.kernel.org>; Fri, 25 Jun 2021 15:22:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5683F61941
	for <kvmarm@archiver.kernel.org>; Fri, 25 Jun 2021 15:22:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5683F61941
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDA644B17A;
	Fri, 25 Jun 2021 11:22:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xEu3j3r6EQaz; Fri, 25 Jun 2021 11:22:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A371B4B15C;
	Fri, 25 Jun 2021 11:22:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9077A4B133
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jun 2021 11:22:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id de1mWcYk1dKS for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Jun 2021 11:22:42 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D39E4B119
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jun 2021 11:22:42 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1624634562;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=c60/pv7sL8eCu7tXeJN0+FKp9/E4tHFjAmIjYk7Ari4=;
 b=DBPr2AGhLcP2BXteJb4AmEsJZ7/UmGb1h14cZgL9a319HnVwZPKnpxSlcbc3/upAwBVlaJ
 CyShjY8lDpH+mHJICy72mQ5qW0RVlVtCmenLFNy9zq5G1iS0FA//DtdRaGIW/dkF8F+VbX
 TbcPVeKo2v2LWhSnHdZfbs2LiuHKGP4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-O4WCQSXvPpKUJ2Qt_jlyWQ-1; Fri, 25 Jun 2021 11:22:40 -0400
X-MC-Unique: O4WCQSXvPpKUJ2Qt_jlyWQ-1
Received: by mail-wm1-f69.google.com with SMTP id
 j38-20020a05600c1c26b02901dbf7d18ff8so4314998wms.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jun 2021 08:22:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:cc:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=c60/pv7sL8eCu7tXeJN0+FKp9/E4tHFjAmIjYk7Ari4=;
 b=cTvAIgHJGcKBe0fWIeZYVuJ1KfByBTRFLsCphMmzagVO1FgY3/ODHuftDlROFGxCBu
 QzrX/1j2z+U4bkz9Qu+lvnIEZqz73UOrI5AYzfFzDQQZx4k/jR0UhPw+MxUufmzqPDuL
 WMeKxAV+R7SaG+Aw4sYa+kbmSCE9ULs3D1gdQkzF1Jg6TJFIh7W/b3elsgC6RF2KOVa3
 wnsyZsZqV6cgKFE6u2qg6LOXVIUUGOswMYkodGhwU8fo15xkDP22eRtM7ydNLuGtoi9L
 cn1YXrVHtbAodMYH4eQ1brHrXlZRh1GH55ZTqHG86kzvTFJ4uQJhA/DnU8RSYVWl8Uwp
 2DtA==
X-Gm-Message-State: AOAM530jJ5G3Z6nL5QdmCwR2I0to993UgdJHi025b7yKJcbMFOylMKrk
 BL2auENNpjITuu3F0ORgTfIPyR5P2LAm2w2mAh3Hz8C8nZgr9n7jDfB7OSauHDz+7xRHN1hQKk0
 ys2UuVIRzil11ENKcuvsQIY23
X-Received: by 2002:a5d:45cc:: with SMTP id b12mr11400169wrs.43.1624634559738; 
 Fri, 25 Jun 2021 08:22:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyDGD9t/H/HRws3awcg3HRn/cf6d23iY7tTVM5TXBjLc44hX2J/pwawWcJJd8s4t+aHlLMlDA==
X-Received: by 2002:a5d:45cc:: with SMTP id b12mr11400130wrs.43.1624634559537; 
 Fri, 25 Jun 2021 08:22:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id y7sm11207948wma.22.2021.06.25.08.22.38
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 25 Jun 2021 08:22:38 -0700 (PDT)
To: Marc Zyngier <maz@kernel.org>
References: <20210625134357.12804-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] KVM/arm64 updates for 5.14
Message-ID: <a302cb0c-dc44-8acf-93b9-0048c757f82e@redhat.com>
Date: Fri, 25 Jun 2021 17:22:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210625134357.12804-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvmarm@lists.cs.columbia.edu, kernel-team@android.com, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Steven Price <steven.price@arm.com>, linux-arm-kernel@lists.infradead.org,
 Jinank Jain <jinankj@amazon.de>
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

On 25/06/21 15:43, Marc Zyngier wrote:
> - Add MTE support in guests, complete with tag save/restore interface
> - Reduce the impact of CMOs by moving them in the page-table code
> - Allow device block mappings at stage-2
> - Reduce the footprint of the vmemmap in protected mode
> - Support the vGIC on dumb systems such as the Apple M1
> - Add selftest infrastructure to support multiple configuration
>    and apply that to PMU/non-PMU setups
> - Add selftests for the debug architecture
> - The usual crop of PMU fixes

Oh well since all the arches are here let's just send a single pull request.

> Note that we carry a branch (arm64/for-next/caches) shared with the
> arm64 tree in order to avoid ugly conflicts. You will still get a few
> minor ones with the PPC tree, but the resolution is obvious.

Great, thanks.

> Oh, and each merge commit has a full description of what they contain.
> Hopefully we won't get yelled at this time.

Heh, I probably should have yelled at you last time too. :)  But this 
time it's all looking really good to me too!

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
