Return-Path: <SRS0=ZO96=C5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0709BC43463
	for <kvmarm@archiver.kernel.org>; Sun, 20 Sep 2020 13:14:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4069420EDD
	for <kvmarm@archiver.kernel.org>; Sun, 20 Sep 2020 13:14:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O0+TWtET"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4069420EDD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7112D4B2DE;
	Sun, 20 Sep 2020 09:14:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I5vo2DvUQmEP; Sun, 20 Sep 2020 09:14:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 730884B426;
	Sun, 20 Sep 2020 09:14:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DEBD24B2E5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 20 Sep 2020 09:14:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9Hj7wFAo8grN for <kvmarm@lists.cs.columbia.edu>;
 Sun, 20 Sep 2020 09:14:38 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6F704B2DE
 for <kvmarm@lists.cs.columbia.edu>; Sun, 20 Sep 2020 09:14:38 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1600607678;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=gSKW12cZqUl1E+chwojz8nTsFE2FCtnzJEASLd/xV30=;
 b=O0+TWtETR13X8spicV0NW7cvoUvRWkzW4qc8QQIsaGIY9IJlEVMwP5F/cSYrOcoQv10fOy
 AvlpbTZO2X3PbuBcFsbMM4ybIJzMGWeQgAOREOk1s4mBtd8voSrZRBifWd+NsdewEESqER
 bWLGWnEsfX9pacHeYaLBxSYGy8PYk88=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-S_D0cttKPiigKNLNNEIXeg-1; Sun, 20 Sep 2020 09:14:34 -0400
X-MC-Unique: S_D0cttKPiigKNLNNEIXeg-1
Received: by mail-wr1-f69.google.com with SMTP id 33so4569536wrk.12
 for <kvmarm@lists.cs.columbia.edu>; Sun, 20 Sep 2020 06:14:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=gSKW12cZqUl1E+chwojz8nTsFE2FCtnzJEASLd/xV30=;
 b=awHkKXTyDEhypabSPxwugC8PQtdAu8DXxN4ncitwBY5lKTUCqNFRHpym2BJHotCUDI
 biDoVdy0YqC5fJQLP0KHuprelMv0Ao33fxuBzwatRWH8uddi9bw0zlTpkFGdah7rUyCi
 vJekcuZvNFdlg6ZHnk1n3dxj3zc4he8ngJrMinPo61VeG0yi/c99QAFEdL8N9FdceqZs
 C4WMsMSCWb0A3Afbik6gxFhu2J2mJWkkVtQnRLcIp8QEXQMw9xlybJdUDrYDARjDB7VG
 CbF/Fzkqct7vliZRWHk4OR8P9+gizER5a/sANIspQsNKu54aYUpjRia83BcSQ+eTReaG
 3PiA==
X-Gm-Message-State: AOAM530pR3aza2hdOxrxXm6BiATLBHs0zgjKXNUkezx7kKKovcm2muNm
 8+TsSNZ2sMOCnI+4mIXAvtnYKWvr60SLehdYwrWM70f8ulpbbyfyfiFcXFEMmslfoY/dveTuTVI
 IVGgIh3Qd8CQV/Y1WfDIo6kvZ
X-Received: by 2002:a1c:40a:: with SMTP id 10mr26039002wme.61.1600607671971;
 Sun, 20 Sep 2020 06:14:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzy9mQ/XuFR3pCMbTHL8kPkRRUxwdVKzYostTWzZC+d7lZERoWWg3MPLZ+kxWK7UN4+gBtzdQ==
X-Received: by 2002:a1c:40a:: with SMTP id 10mr26038968wme.61.1600607671619;
 Sun, 20 Sep 2020 06:14:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:458b:b280:cf0:4acf?
 ([2001:b07:6468:f312:458b:b280:cf0:4acf])
 by smtp.gmail.com with ESMTPSA id n14sm13982479wmi.33.2020.09.20.06.14.30
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 20 Sep 2020 06:14:31 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.9, take #2
To: Marc Zyngier <maz@kernel.org>
References: <20200918171651.1340445-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3705aa31-fd73-288b-98f1-b6bc02c94709@redhat.com>
Date: Sun, 20 Sep 2020 15:14:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200918171651.1340445-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>, kernel-team@android.com,
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

On 18/09/20 19:16, Marc Zyngier wrote:
> Hi Paolo,
> 
> Here's the latest set of fixes for 5.9. The first patch is pretty
> nasty, as a guest hitting this bug will have its vcpu stuck on a
> fault, without any hope of it being resolved. Embarrassing, and
> definitely a stable candidate. The second patch is only a cleanup
> after the first one.
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit 7b75cd5128421c673153efb1236705696a1a9812:
> 
>   KVM: arm64: Update page shift if stage 2 block mapping not supported (2020-09-04 10:53:48 +0100)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.9-2

Pulled, thanks.

Paolo

> 
> for you to fetch changes up to 620cf45f7a516bf5fe9e5dce675a652e935c8bde:
> 
>   KVM: arm64: Remove S1PTW check from kvm_vcpu_dabt_iswrite() (2020-09-18 18:01:48 +0100)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for 5.9, take #2
> 
> - Fix handling of S1 Page Table Walk permission fault at S2
>   on instruction fetch
> - Cleanup kvm_vcpu_dabt_iswrite()
> 
> ----------------------------------------------------------------
> Marc Zyngier (2):
>       KVM: arm64: Assume write fault on S1PTW permission fault on instruction fetch
>       KVM: arm64: Remove S1PTW check from kvm_vcpu_dabt_iswrite()
> 
>  arch/arm64/include/asm/kvm_emulate.h    | 14 +++++++++++---
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
>  arch/arm64/kvm/mmu.c                    |  4 ++--
>  3 files changed, 14 insertions(+), 6 deletions(-)
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
