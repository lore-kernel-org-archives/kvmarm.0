Return-Path: <SRS0=LXG2=YP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B999ECA9EA0
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 15:53:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4481521872
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 15:53:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4481521872
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF19F4A977;
	Tue, 22 Oct 2019 11:53:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ge+Dyoj76bR3; Tue, 22 Oct 2019 11:53:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5ECCE4A973;
	Tue, 22 Oct 2019 11:53:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A54F4A960
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 11:53:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1vmpJu71bVYw for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Oct 2019 11:53:31 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 61A884A95D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 11:53:31 -0400 (EDT)
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 5166BC04AC50
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 15:53:30 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id r8so2126864wrx.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 08:53:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
 :date:user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=JG+rDaiZPjv/G30aIXSiabMNCIhXTu4D3139P64uM1U=;
 b=J4JqflbN9ocb5h1MH9kmRLTZpBUCPrq4/Ogr+r16eKnw7Xv2uxWQqLK5k1a3MveMav
 Dh7FGyrDA+J8tUrRskW4LlxpXywwxrhXaauCBI+K3Syf9pB+DoH9QIcZLlaDYLOkeNTM
 tZP5oDDWqzWfdz9VAB6c0rs1KvcYMqyAN7hoq2WJkVqlqVowlDoAec0+CVvHSyxCwdpf
 UtlHXdVsmFjcgFaTXribA4YE9eZ26XwjW1/3KsU38x2aK8M5loLG0/1CbJ1W695A99T0
 ESIWgJnvCEOqXEojUZNDxCNQuLY6zCoGCsE0IvF+3j4FuZFuxUyHP3mczjVKi5fpcFNZ
 xG6w==
X-Gm-Message-State: APjAAAXQr3sX2V8EKDuS2qo+6uHfOBxFteOm00I2xviXe66MJZqBxJfy
 Q2A5EiqY8Mqc5VZiHW1ZMt7gtx5C2B6e6vvYjcIDthOHcYTWKoIRzVEXounBlM1KgN+X+S5JPXt
 LIwVEpNbnCPLkyE6/or2JkIiz
X-Received: by 2002:a1c:c90c:: with SMTP id f12mr3515225wmb.97.1571759608921; 
 Tue, 22 Oct 2019 08:53:28 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz6V+VvQ3ZIcj/uWsxd5zvt1LhKvigbB1GL0YOeGKZ2oispvsSJTapzUQJ7s70S4Bt0HGQCSQ==
X-Received: by 2002:a1c:c90c:: with SMTP id f12mr3515188wmb.97.1571759608659; 
 Tue, 22 Oct 2019 08:53:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c0e4:dcf4:b543:ce19?
 ([2001:b07:6468:f312:c0e4:dcf4:b543:ce19])
 by smtp.gmail.com with ESMTPSA id t123sm24286579wma.40.2019.10.22.08.53.27
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 22 Oct 2019 08:53:28 -0700 (PDT)
Subject: Re: [PATCH v2 14/15] KVM: Terminate memslot walks via used_slots
To: Sean Christopherson <sean.j.christopherson@intel.com>
References: <20191022003537.13013-1-sean.j.christopherson@intel.com>
 <20191022003537.13013-15-sean.j.christopherson@intel.com>
 <642f73ee-9425-0149-f4f4-f56be9ae5713@redhat.com>
 <20191022152827.GC2343@linux.intel.com>
 <625e511f-bd35-3b92-0c6d-550c10fc5827@redhat.com>
 <20191022155220.GD2343@linux.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5c61c094-ee32-4dcf-b3ae-092eba0159c5@redhat.com>
Date: Tue, 22 Oct 2019 17:53:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191022155220.GD2343@linux.intel.com>
Content-Language: en-US
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 James Hogan <jhogan@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
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

On 22/10/19 17:52, Sean Christopherson wrote:
> 
> Anyways, I'm not at all opposed to adding comments, just want to make sure
> I'm not forgetting something.  If it's ok with you, I'll comment the code
> and/or functions and reply here to refine them without having to respin
> the whole series.

Yes, I agree this is better.

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
