Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C63A6C54EE9
	for <kvmarm@archiver.kernel.org>; Tue, 27 Sep 2022 16:01:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 35C5F4B647;
	Tue, 27 Sep 2022 12:01:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DEM2WmSCkZrm; Tue, 27 Sep 2022 12:01:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDACB4B633;
	Tue, 27 Sep 2022 12:01:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38EB040C23
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 12:01:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dVpevNr7hrKR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2022 12:01:01 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 325C94B647
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 12:01:01 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1664294460;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=OBR4xNQEpKsKlU6oEB+jHo2f2aRGU/mGD6dagUtmSrA=;
 b=DCcmvCGBefDrvyBPrjZErFy1Bpq8uKjTwskdC9a23bJho80Qg1SlDPCX8nUDG/mhMJVv9e
 LajF/6vG40VjEtZCLwlXxEpyD4+uqGuxBnZRtgFG1KzYs84GxsCv03okOrdFUqDm43IyVT
 n9FSNdGCyoqs//64b/aPc+dL/76Q+JY=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-490-8hsmTE4aMCSKlTJxlxT7IQ-1; Tue, 27 Sep 2022 12:00:59 -0400
X-MC-Unique: 8hsmTE4aMCSKlTJxlxT7IQ-1
Received: by mail-qv1-f71.google.com with SMTP id
 nn9-20020a056214358900b004ac7136c9a3so6076007qvb.16
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 09:00:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=OBR4xNQEpKsKlU6oEB+jHo2f2aRGU/mGD6dagUtmSrA=;
 b=wsub0rY8gw69I/uCUwP3JRIff3Oo4rAA8EVW5soO6+HOgYRjLiWBEyudJe25eGFp2j
 W1MEO9alTcW3IqjCpLtupp83w9xuS0Gjk5MCzPIVu+g4x9sDUM2VO42mdvVrzLu0bFwL
 mw+50NObwD6W26VCpKx2Cw47KjzbXJgSohqbE4v2Ka06e0Ori5kgBMxQsivECICjdJ9j
 VymOAvLxbkd/eFVVrQrlCIyyXC42zvWexjTpKf6IfmEFjMTTrkFzhOoQblUFE9pLfP9T
 Q4bRoiKtqGMJKgD4i6XMV6rwPkXvay41gVfPQQ8H7evzEosiaHPJnRrcNIo0KuzsNP8L
 MafA==
X-Gm-Message-State: ACrzQf2n9YJJVVLzJ2t0UCEuSFXAFldB/p8k8Sfxi5lxROjgWWoNVJtA
 cNa4SfZn61hNSwnehHMtINe/bP69HPw/jNl7zcDRIvTa2r4ucG7cNdEeH6JWUayBMPiVh1R+tZ2
 DyQVcM2a7BGPx+kts1JfCOtYi
X-Received: by 2002:a37:691:0:b0:6cf:532a:6f4c with SMTP id
 139-20020a370691000000b006cf532a6f4cmr18552034qkg.89.1664294459073; 
 Tue, 27 Sep 2022 09:00:59 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4vaVTukQ9Ej/20po7f9wxzUqLefkMYhEbvAtlgYl1WVQCZHpehWvF+WtqAEIp2CmBVHJb3hg==
X-Received: by 2002:a37:691:0:b0:6cf:532a:6f4c with SMTP id
 139-20020a370691000000b006cf532a6f4cmr18552006qkg.89.1664294458793; 
 Tue, 27 Sep 2022 09:00:58 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca.
 [70.31.27.79]) by smtp.gmail.com with ESMTPSA id
 f1-20020a05620a280100b006b95b0a714esm1295626qkp.17.2022.09.27.09.00.57
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 27 Sep 2022 09:00:58 -0700 (PDT)
Date: Tue, 27 Sep 2022 12:00:55 -0400
From: Peter Xu <peterx@redhat.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v4 2/6] KVM: x86: Move declaration of
 kvm_cpu_dirty_log_size() to kvm_dirty_ring.h
Message-ID: <YzMeN6ZFjyoT+Rz2@x1n>
References: <20220927005439.21130-1-gshan@redhat.com>
 <20220927005439.21130-3-gshan@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20220927005439.21130-3-gshan@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: maz@kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com,
 andrew.jones@linux.dev, will@kernel.org, shan.gavin@gmail.com,
 bgardon@google.com, dmatlack@google.com, pbonzini@redhat.com,
 zhenyzha@redhat.com, shuah@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Tue, Sep 27, 2022 at 08:54:35AM +0800, Gavin Shan wrote:
> Not all architectures like ARM64 need to override the function. Move
> its declaration to kvm_dirty_ring.h to avoid the following compiling
> warning on ARM64 when the feature is enabled.
> 
>   arch/arm64/kvm/../../../virt/kvm/dirty_ring.c:14:12:        \
>   warning: no previous prototype for 'kvm_cpu_dirty_log_size' \
>   [-Wmissing-prototypes]                                      \
>   int __weak kvm_cpu_dirty_log_size(void)
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Gavin Shan <gshan@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
