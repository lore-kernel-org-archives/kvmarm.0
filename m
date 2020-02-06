Return-Path: <SRS0=Is6r=32=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 603F0C35247
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 22:30:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DB08D21775
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 22:30:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="De4NStt3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB08D21775
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DF744A597;
	Thu,  6 Feb 2020 17:30:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eUh2SdbmsVxq; Thu,  6 Feb 2020 17:30:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 294534A49F;
	Thu,  6 Feb 2020 17:30:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CEBF4A49F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 17:30:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OrtfvbyNGPPv for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Feb 2020 17:30:14 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81F674A49C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 17:30:14 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581028214;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=08Ua6YM4bGr29OQGZ6f7H3nnpZ7bguggvktlAX07D4M=;
 b=De4NStt3PqTnFF0GNzSOm/fpWNdIWAjMcSoqS0ThJZYX50LjDtV8mtzdDFTWhGhvSPpM6/
 +RU56B2QvOim4nSJpzz//xgZjlv0cfuGxDTrwUJuMeqgIUCNr9Uj8WerBnh2ojgBMVpv5P
 mYspZodbPP8Yx1fnTaoYBScMSNoDdfs=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-XiHY-cQsPB6yYEPaHphycw-1; Thu, 06 Feb 2020 17:30:05 -0500
Received: by mail-qt1-f199.google.com with SMTP id e37so282531qtk.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Feb 2020 14:30:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=y9cBxEKgtYZ4SHZJ2KCZ291mafsQUmmbyOmTI5C6x9c=;
 b=pNUH7yiTE0AfCgsJs24msEqv6e1Q2Rluhqw/Awu16CJjGkfwkuIwCytiWaSdmrGcX3
 /nwqcG0le3Lt2g93nbu2+T9dil5WZaYis3XPoWu2yu4xmPdhsH3lSR3++ob6/C0Z4098
 7S6blD6ZJrj4mAHhmEA61dthl6OrfrfvCMiu4rn2n9aIHRFNIlTr1jv1fuOfCcjkAcRq
 0kovFDhVbPX3DRqz4A33YxyEE9o6ibdkF11YEgRYdpHoZj7eB6P8NKN8DZMAaeiaP7ba
 2U2cYelqkIawSC3a1eBNIERlY+keFu43BWUqDVcf1Ou8G8ImrcMJ0yIqE/Os0FXZWFKN
 b/7Q==
X-Gm-Message-State: APjAAAU5UAX67gclVpdlaU6Xkze8B7rpZ2LAoZExc7GS4iqAd+djD/XX
 wHGPGZ7CuW3HwVaKLWyV8ApjBeGx9mfpt5gaxFCbFndFdLfD5abrIVBvbb/r8lzLRqnJdGGflRl
 WXRHYPdm45gqxRPcX/cgDKHAI
X-Received: by 2002:a37:7884:: with SMTP id t126mr4700934qkc.288.1581028204604; 
 Thu, 06 Feb 2020 14:30:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqzvEhS0XgXcsen5IJpPtTelaoRM0D8F8yYe4NbZxtsmBW+xmvTRWnxA6Vkem/WNxI4KksN37A==
X-Received: by 2002:a37:7884:: with SMTP id t126mr4700901qkc.288.1581028204379; 
 Thu, 06 Feb 2020 14:30:04 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
 by smtp.gmail.com with ESMTPSA id z185sm352349qkb.116.2020.02.06.14.30.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 06 Feb 2020 14:30:03 -0800 (PST)
Date: Thu, 6 Feb 2020 17:30:01 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v5 19/19] KVM: selftests: Add test for
 KVM_SET_USER_MEMORY_REGION
Message-ID: <20200206223001.GJ700495@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-20-sean.j.christopherson@intel.com>
MIME-Version: 1.0
In-Reply-To: <20200121223157.15263-20-sean.j.christopherson@intel.com>
X-MC-Unique: XiHY-cQsPB6yYEPaHphycw-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Christian Borntraeger <borntraeger@de.ibm.com>,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
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

On Tue, Jan 21, 2020 at 02:31:57PM -0800, Sean Christopherson wrote:
> Add a KVM selftest to test moving the base gfn of a userspace memory
> region.  Although the basic concept of moving memory regions is not x86
> specific, the assumptions regarding large pages and MMIO shenanigans
> used to verify the correctness make this x86_64 only for the time being.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

(I'm a bit curious why write 2 first before 1...)

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
