Return-Path: <SRS0=odEw=I6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15712C433ED
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 09:28:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 85567610CB
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 09:28:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 85567610CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A0D34B61F;
	Thu,  1 Apr 2021 05:28:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bJl4Md+Kff9Y; Thu,  1 Apr 2021 05:28:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7C2A4B62E;
	Thu,  1 Apr 2021 05:28:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13BFE4B4B3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 16:52:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id clG1366gr0If for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Mar 2021 16:52:17 -0400 (EDT)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
 [209.85.216.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D2D114B48D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 16:52:17 -0400 (EDT)
Received: by mail-pj1-f52.google.com with SMTP id
 nh23-20020a17090b3657b02900c0d5e235a8so1935175pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 13:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=yoJglSBv69WpXRq5eWsDMsVvLVSgKRL+uxkOtmCkPv4=;
 b=ADUqKKQ3BT9AZj97LO1eTtS3t9SA7Iz5Y9gKCHGjYiSKaRi0OjZsNbCEZHlTHVsUK2
 RNZXwtrgWGKiRwRERUqUQHhNjNE4avYwBTOHTNeXUrFuBOZpSNcUgsrOMnNOFrF4Qmmx
 O6VxlothBKh2mwj18o5erYydCBdLp41Jx1ACR3P2G4E6KTzIjQwXv0iNU/NOfDyTFFnS
 200CcWoWmbjT9IdQc2M/KYaGZJ9MQ4swwqQjH/lVhVw8kM/Yif9KbXdwfMKqqTFBCtHd
 qG+c+KtKeKb557k9yYsai7I+C2YdTVQm/TDzi18tNlIaNowK9yiwFIR0cMG4QxaUuNJ2
 ySUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=yoJglSBv69WpXRq5eWsDMsVvLVSgKRL+uxkOtmCkPv4=;
 b=As8nUZtwCIWgDJk0resshmpGKPWVniWDPpHoeha2xtrwhI7dFvLRLLrIFFBKliaxIY
 ninBKolUASt4nOUucTdzqBtdP7LhQiVa/8URUaYdzCQDzpWT4QcA4tLkrttqLKpJx707
 OmnUC/+OEjxsFlBIYIA4Xo/2u9x+56T4TTW33T3ez2qaToJumJzjblLeyVwCXv3lRBk8
 rANVJw8WxehfMnhgXvpgahrjEeEWv/cem7MTT02hTLaTKgQwclAjO4Z/gjC04k0Z2Ko4
 FfEF9Fi9f95RlrXLifYUw7YwskIWVFoDPTe+IPsbtgWXUYdQzXD/aK259/WWV1OE3Opc
 zVsg==
X-Gm-Message-State: AOAM532PDSNm3+5r0QhkhO39+Vlxo4nwOromO+9lvz+ENd+Kg81L39q3
 XalkTtljS7+g75ggkF5t4efirw==
X-Google-Smtp-Source: ABdhPJyf4HLSrowxJceov6XASpdTMiPhuzoLXLjATJzpx1nt33JVlntT/l7g0VYbcVhhGtzPXPv8aQ==
X-Received: by 2002:a17:902:d4cd:b029:e5:dd6d:f9b3 with SMTP id
 o13-20020a170902d4cdb02900e5dd6df9b3mr4527204plg.43.1617223936594; 
 Wed, 31 Mar 2021 13:52:16 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com.
 [35.247.111.240])
 by smtp.gmail.com with ESMTPSA id s28sm3246776pfd.155.2021.03.31.13.52.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 31 Mar 2021 13:52:16 -0700 (PDT)
Date: Wed, 31 Mar 2021 20:52:12 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 16/18] KVM: Don't take mmu_lock for range invalidation
 unless necessary
Message-ID: <YGTg/AWdieMM/mS7@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-17-seanjc@google.com>
 <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
X-Mailman-Approved-At: Thu, 01 Apr 2021 05:28:17 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 linux-arm-kernel@lists.infradead.org, Ben Gardon <bgardon@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

On Wed, Mar 31, 2021, Paolo Bonzini wrote:
> On 26/03/21 03:19, Sean Christopherson wrote:
> Also, related to the first part of the series, perhaps you could structure
> the series in a slightly different way:
> 
> 1) introduce the HVA walking API in common code, complete with on_lock and
> patch 15, so that you can use on_lock to increase mmu_notifier_seq
> 
> 2) then migrate all architectures including x86 to the new API
> 
> IOW, first half of patch 10 and all of patch 15; then the second half of
> patch 10; then patches 11-14.

100% agree with introducing on_lock separately from the conditional locking.

Not so sure about introducing conditional locking and then converting non-x86
archs.  I'd prefer to keep the conditional locking after arch conversion.
If something does go awry, it would be nice to be able to preciesly bisect to
the conditional locking.  Ditto if it needs to be reverted because it breaks an
arch.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
