Return-Path: <SRS0=b97j=N4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF95C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  6 Sep 2021 06:50:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ED213604AC
	for <kvmarm@archiver.kernel.org>; Mon,  6 Sep 2021 06:50:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org ED213604AC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A80BD4B260;
	Mon,  6 Sep 2021 02:50:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QsfhsAiVpZu1; Mon,  6 Sep 2021 02:50:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A36944B2C2;
	Mon,  6 Sep 2021 02:50:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8A374B284
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Sep 2021 02:50:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6wK1i8fiAKII for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Sep 2021 02:50:24 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D4BA4B1D5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Sep 2021 02:50:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1630911023;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=aypnITcWlLv4lCfRDaFN+Jti+hI0KIdPR67H8ACIpZ4=;
 b=XlwrSIasv+ZJOR56zabRaiCzbjQPUvDuAPuAytVzjngwz1zqG2+HFb8KeEF2aSs084jc/2
 Jv0yLKPBoBcS1rD8SxBqZ5motEXp9xtF30QibsnyTvx7FFPL2ntlNT3l4vmviYzRC7XkHq
 E91ex/qy61R4TDvbrOii/d2t350g4hQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-f59oPPoNOLmCSXcg93JcKg-1; Mon, 06 Sep 2021 02:50:22 -0400
X-MC-Unique: f59oPPoNOLmCSXcg93JcKg-1
Received: by mail-ej1-f72.google.com with SMTP id
 x6-20020a170906710600b005c980192a39so1883565ejj.9
 for <kvmarm@lists.cs.columbia.edu>; Sun, 05 Sep 2021 23:50:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=aypnITcWlLv4lCfRDaFN+Jti+hI0KIdPR67H8ACIpZ4=;
 b=IMwVwVaJfCoxqI4OEVZ9aazR+45bByaXBV/jjJVWv8JTOLUDw0R/ZliPN250xpftoZ
 pwWXfTObtpn6Blvl2JS/PvdjFsPm8QU5oKP7hNlwz4IGTW/1H3BzT+UDl8rtPbWkeea0
 G2ABQ7GemnKTmhg+9GXfmlzH84T4vtxV9eyRuM5lttElIBK/sKS+Bld8jgvIlMiR48B1
 xcLz2Vf7262l0QrWnHCzRad/JFWI/STAuud33vfdCMkE96kg2yFYtHP9i35UXk1WTcJe
 0Up4XN6q8Qi36Dq7XR8lNKt1LLjfkphtEXppcvXbEddaSbCwjg+lbrgWUim3FGJ0sAKf
 7hCw==
X-Gm-Message-State: AOAM532ebSVku3GaAm72Wp2r5QjBXKhHP3TaumRr9ECOMNd84XKYNUi1
 P5FrbjJA8Aavbxuot+0dyZI/xFgjcWDUXwOc16+0Ezr4Yand2scInTBpjlddrwKHjCU1nSbPSMD
 qPEDeqj7fu2o3hPYOT4M9vITL
X-Received: by 2002:a17:907:7601:: with SMTP id
 jx1mr11963669ejc.69.1630911021492; 
 Sun, 05 Sep 2021 23:50:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzFIYjYkzsq7JAWCJ17zM3GVn179l8k5sV9FWmnoDh3D865k+M2BuOeZrF4Haf7EvH4sDARIg==
X-Received: by 2002:a17:907:7601:: with SMTP id
 jx1mr11963663ejc.69.1630911021357; 
 Sun, 05 Sep 2021 23:50:21 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id b15sm3305728ejq.83.2021.09.05.23.50.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 05 Sep 2021 23:50:21 -0700 (PDT)
Date: Mon, 6 Sep 2021 08:50:19 +0200
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH 1/2] KVM: selftests: make memslot_perf_test arch
 independent
Message-ID: <20210906065019.mdlqorvyqizdrksd@gator.home>
References: <20210903231154.25091-1-ricarkol@google.com>
 <20210903231154.25091-2-ricarkol@google.com>
MIME-Version: 1.0
In-Reply-To: <20210903231154.25091-2-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, maz@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, maciej.szmigiero@oracle.com,
 kvmarm@lists.cs.columbia.edu
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

On Fri, Sep 03, 2021 at 04:11:53PM -0700, Ricardo Koller wrote:
> memslot_perf_test uses ucalls for synchronization between guest and
> host. Ucalls API is architecture independent: tests do not need know
> what kind of exit they generate on a specific arch.  More specifically,
> there is no need to check whether an exit is KVM_EXIT_IO in x86 for the
> host to know that the exit is ucall related, as get_ucall() already
> makes that check.
> 
> Change memslot_perf_test to not require specifying what exit does a
> ucall generate. Also add a missing ucall_init.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/memslot_perf_test.c | 56 +++++++++++--------
>  1 file changed, 34 insertions(+), 22 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
