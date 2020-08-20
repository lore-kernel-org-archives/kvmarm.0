Return-Path: <SRS0=c5RA=B6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF5EC433E1
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 07:26:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8F88522B47
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 07:26:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gdpEJOT0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F88522B47
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F24AC4B7A8;
	Thu, 20 Aug 2020 03:26:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0KS99UMdzOJn; Thu, 20 Aug 2020 03:26:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5CF94B79F;
	Thu, 20 Aug 2020 03:26:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B55994B79D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 03:26:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cmVPLrsUaQ9g for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Aug 2020 03:26:43 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA4814B79C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 03:26:43 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1597908403;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=moE59twGHKI7k28SZAbOSnFimdPydL4GY9WfrG5itmA=;
 b=gdpEJOT0k7Mk/ywh56Srj9vXHnoCnGipY6Z3DvdMTyMIY/5jUn/+rUCq7OIb2GpVIHe9yH
 Q2VToAuLXjiDxyO695Xwed7c++q06iIkSqLCZVNqrxytcEQPAcYRBwd30WsKFdLdWoxpak
 fzOvB/sf7/ws/XO23OI1wb1ak4rl45E=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-FjRQDvetOTiRJa8gGTLdcg-1; Thu, 20 Aug 2020 03:26:39 -0400
X-MC-Unique: FjRQDvetOTiRJa8gGTLdcg-1
Received: by mail-wr1-f72.google.com with SMTP id z12so325582wrl.16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 00:26:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=moE59twGHKI7k28SZAbOSnFimdPydL4GY9WfrG5itmA=;
 b=RtxjuwMZnqVoaPNSybsyF39TVTYdMNpcz3/OWo/DFtTcrOVxfijB2Rm+migyFHcIKV
 LFDa38IGGGLFnQpX1tizODAI2IzDpn11DW0v4bh7r5Xe3A3jTm8NBTcUmABe70n9qUS6
 Hx2u1WAs+JrKJsyjBASPhfHgytW8EGztFePQ7FnOHVsvxgIfS1RYdhmgsboZynr7zXlD
 B+vqdoEKxBQ6vFVNXc9eJLDx5aqPRzQ8k6hlAa0ohZcZsHvqHx/GMY9o7A4g8jeW9SFQ
 DFxuMvXt5RXWiD42FWOrGcpDmCXsN8qEUb+3XGCIEWzEASbpYkDZj/ZxyH1c3bJIsKEy
 a9HQ==
X-Gm-Message-State: AOAM532ZOyqGt5dLk9ec+T796MZHr966TIc34+6XHmnHCpt2VCHSNM6K
 tmGdiErXZUySb6absb2kI/rVYuyI6la86A48fl6H063IzK2tjJY2+7DHRdgsOFQV0DxrO/1FAeX
 F6iX/1d8ULFtKuJsOG+kW5hy1
X-Received: by 2002:adf:c789:: with SMTP id l9mr1888088wrg.41.1597908398517;
 Thu, 20 Aug 2020 00:26:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBwwkk+81R0CeVuNZYFZ/H/Iy/w3GMsVNOB7/445m84umm/A6fxcrBYXhG1+K6mO8XKIcRQA==
X-Received: by 2002:adf:c789:: with SMTP id l9mr1888078wrg.41.1597908398316;
 Thu, 20 Aug 2020 00:26:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1cc0:4e4e:f1a9:1745?
 ([2001:b07:6468:f312:1cc0:4e4e:f1a9:1745])
 by smtp.gmail.com with ESMTPSA id p25sm2494328wma.39.2020.08.20.00.26.37
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 20 Aug 2020 00:26:37 -0700 (PDT)
Subject: Re: [PATCH 0/2] KVM: arm64: Fix sleeping while atomic BUG() on OOM
To: Will Deacon <will@kernel.org>
References: <20200811102725.7121-1-will@kernel.org>
 <ff1d4de2-f3f8-eafa-6ba5-3e5bb715ae05@redhat.com>
 <20200818101607.GB15543@willie-the-truck>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3c579063-7ce8-cba6-839f-01e5a46a7b94@redhat.com>
Date: Thu, 20 Aug 2020 09:26:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200818101607.GB15543@willie-the-truck>
Content-Language: en-US
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: redhat.com
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Paul Mackerras <paulus@ozlabs.org>, kvmarm@lists.cs.columbia.edu
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

On 18/08/20 12:16, Will Deacon wrote:
> Please note that I'm planning on rewriting most of the arm64 KVM page-table
> code for 5.10, so if you can get this series in early (e.g. for -rc2), then
> it would _really_ help with managing the kvm/arm64 queue for the next merge
> window.

Yes, I plan to send it tomorrow.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
