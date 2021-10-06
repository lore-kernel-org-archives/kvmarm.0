Return-Path: <SRS0=qtHs=O2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F338CC433EF
	for <kvmarm@archiver.kernel.org>; Wed,  6 Oct 2021 10:07:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6E70C61152
	for <kvmarm@archiver.kernel.org>; Wed,  6 Oct 2021 10:07:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6E70C61152
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B2FC04B2B4;
	Wed,  6 Oct 2021 06:07:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7qAmoJUOm3Hi; Wed,  6 Oct 2021 06:07:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B99FF4B2B5;
	Wed,  6 Oct 2021 06:07:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D1C54B2B2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Oct 2021 06:07:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KmajL1QaBdJG for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Oct 2021 06:07:51 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 906F34B2AE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Oct 2021 06:07:51 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633514871;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=yj+1mrM82BCTz7uj5sLU3T9p8kSl41YyFNyCTwKFhxk=;
 b=VSp1A35uImG32Itgm5IjpIFPsnGn3HYnDpc2+fP8H/JZ2YEh+99DkEgEHKeLD+hN2IlJCm
 kBfT3wVhNpOWAvNpfTZNPgPC0kxbZ4U+XIhVmsADUP0yu5S8UcAj/grY28u6NUmOuaMgqz
 rqgnO0P+yGmMOpHOJ1o6gGD3ZdpoYzw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-kCWmm8amNr-RhHs__9IKoQ-1; Wed, 06 Oct 2021 06:07:50 -0400
X-MC-Unique: kCWmm8amNr-RhHs__9IKoQ-1
Received: by mail-ed1-f72.google.com with SMTP id
 w6-20020a50d786000000b003dabc563406so2117885edi.17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Oct 2021 03:07:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=yj+1mrM82BCTz7uj5sLU3T9p8kSl41YyFNyCTwKFhxk=;
 b=6ZlMKyM3rAu+EWqp9XuBWQpsnxQmE0B2yy0qcQWlVAxhh4Uy7DmWFsrbrkDqPRonhA
 oimbUw6XUXKuaAChA0EtSXF2pe2visQnz7UPCIAAAPhhzUffVkePiwzeFwtnOG3XjwMd
 y+1PX2sNGIyU7xh8O23I61oJAgIddy32S8f1bpbKo09pfTbrpM6GcvGwE9jsIf0TZ397
 ZUXet+cHR3ZwPj97fYXB7H4IhQQJXskLTZ5nN2MZpWu9lAnV3Yeh54vhrUggzjsgoZ8F
 jL4RfgbjlGWjh+YKbndBtbUOQ1QBdtfL4xl6RoZEK3GxNsDZHDl5HLvI21wVQrILVpzr
 si+A==
X-Gm-Message-State: AOAM533YuCNN76eGebeiGzSqXHFzDZdB7XewEigsiNF+K1WI+587FlRA
 raufjsqxShku6hB6Ogye12scetpjU8hoK/EpCbg5o9PzSyAHZV7grishD+Ji294IVVd2ck51R7j
 RMmU3e00b2uZHtBsGFprs24IR
X-Received: by 2002:a50:d511:: with SMTP id u17mr31603363edi.105.1633514869400; 
 Wed, 06 Oct 2021 03:07:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVmH7htpm8XyEWwBpvpkOQHw+beXuhBecIj3zIjideTBPR95+pQCNRZBlwYFeSmOAe5zzIbg==
X-Received: by 2002:a50:d511:: with SMTP id u17mr31603347edi.105.1633514869251; 
 Wed, 06 Oct 2021 03:07:49 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id e7sm8111509edv.39.2021.10.06.03.07.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 06 Oct 2021 03:07:49 -0700 (PDT)
Date: Wed, 6 Oct 2021 12:07:47 +0200
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v4 09/11] KVM: arm64: selftests: Add tests for GIC
 redist/cpuif partially above IPA range
Message-ID: <20211006100747.vlyrxk6s2j73blpl@gator.home>
References: <20211005011921.437353-1-ricarkol@google.com>
 <20211005011921.437353-10-ricarkol@google.com>
MIME-Version: 1.0
In-Reply-To: <20211005011921.437353-10-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: shuah@kernel.org, kvm@vger.kernel.org, maz@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
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

On Mon, Oct 04, 2021 at 06:19:19PM -0700, Ricardo Koller wrote:
> Add tests for checking that KVM returns the right error when trying to
> set GICv2 CPU interfaces or GICv3 Redistributors partially above the
> addressable IPA range. Also tighten the IPA range by replacing
> KVM_CAP_ARM_VM_IPA_SIZE with the IPA range currently configured for the
> guest (i.e., the default).

This tightening can even be considered a fix for the original tests,
since it looks like the objective of them was to check the boundary.

> 
> The check for the GICv3 redistributor created using the REDIST legacy
> API is not sufficient as this new test only checks the check done using
> vcpus already created when setting the base. The next commit will add
> the missing test which verifies that the KVM check is done at first vcpu
> run.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 38 +++++++++++++------
>  1 file changed, 26 insertions(+), 12 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
