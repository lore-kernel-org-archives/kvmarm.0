Return-Path: <SRS0=Qgx2=LI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01476C49361
	for <kvmarm@archiver.kernel.org>; Mon, 14 Jun 2021 09:51:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7DFDF61380
	for <kvmarm@archiver.kernel.org>; Mon, 14 Jun 2021 09:51:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7DFDF61380
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB71C40808;
	Mon, 14 Jun 2021 05:51:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M3RrLCFTu8bC; Mon, 14 Jun 2021 05:51:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D7014083E;
	Mon, 14 Jun 2021 05:51:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5315840821
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 05:51:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PqV3TUbm9UMQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Jun 2021 05:51:26 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5378E40808
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 05:51:26 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623664286;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=yVGqXIcKrLCK11mCl5CKOO3c7mK+et1d86zdU/of4sY=;
 b=Jb5JdD8X/xF0x/6xn+VQj7HDjgkfSpyZXv+u8LxkZZRpkqK8QiJbszXNbbqmytvJUswjQs
 Wnh3v1wG7WdNrqW3OaEz5NFOC+Kgg9a4MAO1oogYDNpFmeHbbOrpK2aN02aRyD1pBINXUw
 dM7asWdPEOMhXzzu0G0sEYa0G83cYJ4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-mMvvA3GEMDmmfSaqyxVCOA-1; Mon, 14 Jun 2021 05:51:24 -0400
X-MC-Unique: mMvvA3GEMDmmfSaqyxVCOA-1
Received: by mail-ed1-f69.google.com with SMTP id
 a16-20020aa7cf100000b0290391819a774aso18022486edy.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 02:51:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=yVGqXIcKrLCK11mCl5CKOO3c7mK+et1d86zdU/of4sY=;
 b=SeiRuvhaqBZLx7TEeFNJpfznqOhwjfl1zLcJoJiBjVYFRrhX2KlOyrbnbeV9lGFjkF
 g9Y78Fxz2Wv3CPc4KZobtsJi9o9A8nmoweD6z4PVi+jcgOJpU8Wt4CHOHM9hcObEyb3i
 AKLNxa4nwZLTrznXSizEDSeOK8L7GIOxvT1siIxgn2qZXkCzjv5LvrhT5DZRQsWcxJkh
 XqFbDFUO1fBtXhiNnerQdJmUIGk95l3qbTbDrJMrzPLlxe8i4NK8oIN/vSjSWV4BzxG1
 tbkhrol8lWrzSmwzHGLvq6Ujet2RgTu5VOZBBMigpQTBn+l3RKtiVuwIqV9lL83j2tKn
 1zrA==
X-Gm-Message-State: AOAM533kYAvrvY4zjXLuInhlmWYH5x92d2RMCx8rq2a5a39bp7uwjj01
 9nm3dXvUTeoH4IBYOm7BGCt2YdhxVnNZGAOBdtID6UXfyjsb2TSGaJVP4VqMcoD1fqLf+DkSV6W
 rFnG9DHzdmhv3OXs0csJz1Egp
X-Received: by 2002:a17:906:606:: with SMTP id
 s6mr14277118ejb.206.1623664283795; 
 Mon, 14 Jun 2021 02:51:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUGdB6YCrtVUeX6wpPs0U6HuF+wRnjGRZ9weZzhvjGvM0kMMRuORQ5jQGRt+viUDl0Dzm5nQ==
X-Received: by 2002:a17:906:606:: with SMTP id
 s6mr14277110ejb.206.1623664283633; 
 Mon, 14 Jun 2021 02:51:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id y15sm8131933edd.55.2021.06.14.02.51.22
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 14 Jun 2021 02:51:22 -0700 (PDT)
Subject: Re: [PATCH 2/4] KVM: stats: Use binary stats descriptors for debugfs
 interface
To: Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>, LinuxMIPS
 <linux-mips@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
 LinuxS390 <linux-s390@vger.kernel.org>, Fuad Tabba <tabba@google.com>
References: <20210614025351.365284-1-jingzhangos@google.com>
 <20210614025351.365284-3-jingzhangos@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1b57502b-116a-9be5-fa2f-1e8f5b5fce2d@redhat.com>
Date: Mon, 14 Jun 2021 11:51:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210614025351.365284-3-jingzhangos@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
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

On 14/06/21 04:53, Jing Zhang wrote:
> +	STATS_DESC_ICOUNTER_RONLY(VM, lpages),
> +	STATS_DESC_ICOUNTER_RONLY(VM, nx_lpage_splits),
>  	STATS_DESC_ICOUNTER(VM, max_mmu_page_hash_collisions)

I think we're now adding too many macros.

max_mmu_page_hash_collisions is the only remaining instant counter that 
is not read-only.  In fact, in the statsfs prototype we made all instant 
counters read-only.

You could add a third type in addition to instant and cumulative, let's 
call it "peak".  This essentially corresponds to the "max" aggregation 
function in the statsfs prototype.  Then instant counters would be read 
only, while cumulative and peak would be read-write.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
