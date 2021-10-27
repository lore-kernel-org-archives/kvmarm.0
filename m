Return-Path: <SRS0=suDQ=PP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B356AC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 15:30:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 31A77610C8
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 15:30:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 31A77610C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CAF94B177;
	Wed, 27 Oct 2021 11:30:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4F5+EYJjquky; Wed, 27 Oct 2021 11:30:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80FDB4B0F4;
	Wed, 27 Oct 2021 11:30:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A4624B0C0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 11:30:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M4f9fWX3h4rF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Oct 2021 11:30:40 -0400 (EDT)
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com
 [209.85.210.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2B8304B0BE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 11:30:40 -0400 (EDT)
Received: by mail-pf1-f177.google.com with SMTP id o133so3050737pfg.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 08:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=8HVWDdXXt0AD/xSFizk+AYjOVZmIDbS9XwzvKXYRSt8=;
 b=OEfG9fsgSPXFsuD00eYA/4hb/4nOJhqt3Fa3DsCVNZsfitbSN/e7Fn81m4qSyNF6U/
 mhh/R9TUBiF7pjmngLNdEADzgfxtm/aVHY0H9J+z6ozxZ49ZZu8j36ZA8vNS+jc3P4K8
 39l9ZJZa9RV8xzTd4Pq6XBto9wKnNJruu9xTNPgxAnhf+lq+LyLyNX9Nl8mvXteW2N67
 +TcMWmCTLvtk136TTAc8/TraiE87+QKjoC7eTJ2OAuWqRKMp2hqkYHzHc/UrtgHJUjNB
 S90jgPj6NxctTlEeFg16F+/ojMD4VkEXJciV+yM/BHrhD9Juzesc0Jpe/IsL5krJCSuw
 Hz+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=8HVWDdXXt0AD/xSFizk+AYjOVZmIDbS9XwzvKXYRSt8=;
 b=vbC9uQgJ7rEZ/Bk1kK/9GwXOkGnrD4R0zpQ7ujANXnWHiVYChZmIgXcxmBl9D6KKkE
 /jJUHaMYJ77OnhLdnI9lcHxr6obs35d1eqNyiQE5Stux7kaumgiPEnB69WXPtxVGUDe3
 HkSRdBLbIY4ADGekqgY2+Es9zcWJKrYIxni3XyCgnHtdEs+fd/6GIw4xfV5lVDQ8GP8y
 qdRtYTIxnInBNW8M0nXOKUM/H+1hW2v+ubGmC0OTC2KpBJUX7Ilo9H2/UYPVBsVrGY7l
 uSPt/JihlBphVBQzkMqkV4T+Py4dS2wF2XAF87P+Umm1l4SZi/uMgG6OISYmCj13ZMpi
 q9dw==
X-Gm-Message-State: AOAM531VNB5UjzdayACYUQt4Gl+CRKLIIg7r1VpPMRF0nwbp3YLjBwN8
 8DOTYX8YPsNXBOJF9PamutNZug==
X-Google-Smtp-Source: ABdhPJxZ0e6i7j4AtLY0aYMSXG5aUrKCFCUTxCqVHzekft57NleHTTPCd6QukrG2yYLrBLX5jK+rLA==
X-Received: by 2002:a63:698a:: with SMTP id
 e132mr24303698pgc.434.1635348638933; 
 Wed, 27 Oct 2021 08:30:38 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id w11sm180048pge.48.2021.10.27.08.30.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 27 Oct 2021 08:30:38 -0700 (PDT)
Date: Wed, 27 Oct 2021 15:30:34 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 40/43] KVM: VMX: Wake vCPU when delivering posted IRQ
 even if vCPU == this vCPU
Message-ID: <YXlwmrrRVIoaU2kG@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-41-seanjc@google.com>
 <a2a4e076-edb8-2cb5-5cb2-6825a1a4559a@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a2a4e076-edb8-2cb5-5cb2-6825a1a4559a@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm-ppc@vger.kernel.org,
 Paul Walmsley <paul.walmsley@sifive.com>, David Matlack <dmatlack@google.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Anup Patel <anup.patel@wdc.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Mon, Oct 25, 2021, Paolo Bonzini wrote:
> On 09/10/21 04:12, Sean Christopherson wrote:
> > 
> > Lastly, this aligns the non-nested and nested usage of triggering posted
> > interrupts, and will allow for additional cleanups.
> 
> It also aligns with SVM a little bit more (especially given patch 35),
> doesn't it?

Yes, aligning VMX and SVM APICv behavior as much as possible is definitely a goal
of this series, though I suspect I failed to state that anywhere.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
