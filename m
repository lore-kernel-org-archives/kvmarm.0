Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B35C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 16:42:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1537060EE7
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 16:42:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1537060EE7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C3DE4B0C2;
	Fri, 24 Sep 2021 12:42:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q-XtV7QRIt9g; Fri, 24 Sep 2021 12:42:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D7C34B08A;
	Fri, 24 Sep 2021 12:42:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BE4D4B086
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 12:42:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cFM-jSM8A65p for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 12:42:37 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8940C4AC78
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 12:42:37 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632501757;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=SgDhT9oIEBb9h38x2W632anLjZkMC/1v2YrYWwdqtjo=;
 b=HS8Yb6JGgZDITb1E6L9dbkbWfdXE4DElZLR1+F7ockU5/LRLtN4t04+M8flI/lqHsYDXdN
 4Ain2VkcLm/egUwn/bHxUwFE405M5fLtPXddiNzUKYOfQPliJB6fDqSCmzAx0Jwc7ZUYSO
 dEiAwa68zh5nRoiBLIxc8PYZiHe4L+k=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-fgZyslD1OCOWwy44GL_W2g-1; Fri, 24 Sep 2021 12:42:34 -0400
X-MC-Unique: fgZyslD1OCOWwy44GL_W2g-1
Received: by mail-ed1-f69.google.com with SMTP id
 c36-20020a509fa7000000b003da5a9e5d68so108468edf.15
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 09:42:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=SgDhT9oIEBb9h38x2W632anLjZkMC/1v2YrYWwdqtjo=;
 b=dG0LhHJADzZUow768vcUfujCVUIaZYSi819DlseLmC6JQDpi0MET+514WgZUaeiTEM
 nD3HW553c/Pc13oPMFaqvDBn4ioR/wdObfzoj3DHTDYlkre1JhNpFzflLLssUMsyqZAE
 Y1HnjIj7Dv9BTAutkIDZEkDIvhVy2tSVDxrVJQiVywV67jh0h2ucZT6Z+pZDj/R4TvEW
 YlgnBygWbnWPD3NUViCdzceUef2qpC77sTTIjFBDFahE9cmJ6FHfVf31hxTxkuDk7DCt
 dcll7wab0CMuQqeS5ylq8pm5H6x5a4fAtGdwBvps3XjYfPwHHJsEANlM9NTWOZDj/7RW
 IeNQ==
X-Gm-Message-State: AOAM533RbJpOlkcVMgxdk1DJBc1IBiD9Rh8pRp6LcB0aGKkSeGbj8TDC
 6LK6hN+8p5PEgzWclZDi7nNrq3av73/jBJ5RFHt1QKyBhj/o9eR12jZv73hWnyycJlCNhVFiRhk
 549wx0VCgNsyIBV+I6N7gu7Oe
X-Received: by 2002:a17:906:e299:: with SMTP id
 gg25mr12401363ejb.339.1632501752939; 
 Fri, 24 Sep 2021 09:42:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7DGgQT1CNE4utgIdHx4UNlydMmiz9dbyvTw96aDiDa+sfFGPWN4xEYMtSN4Nf+fdJ7yHHsQ==
X-Received: by 2002:a17:906:e299:: with SMTP id
 gg25mr12401338ejb.339.1632501752743; 
 Fri, 24 Sep 2021 09:42:32 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id cf16sm420363edb.51.2021.09.24.09.42.27
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 24 Sep 2021 09:42:31 -0700 (PDT)
Message-ID: <e6af1bc9-6018-6fd7-fcc1-098b8af0ecdc@redhat.com>
Date: Fri, 24 Sep 2021 18:42:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v8 5/7] kvm: x86: protect masterclock with a seqcount
To: Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-6-oupton@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210916181538.968978-6-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Marc Zyngier <maz@kernel.org>,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 16/09/21 20:15, Oliver Upton wrote:
> From: Paolo Bonzini<pbonzini@redhat.com>
> 
> Protect the reference point for kvmclock with a seqcount, so that
> kvmclock updates for all vCPUs can proceed in parallel.  Xen runstate
> updates will also run in parallel and not bounce the kvmclock cacheline.
> 
> nr_vcpus_matched_tsc is updated outside pvclock_update_vm_gtod_copy
> though, so a spinlock must be kept for that one.
> 
> Signed-off-by: Paolo Bonzini<pbonzini@redhat.com>
> [Oliver - drop unused locals, don't double acquire tsc_write_lock]
> Signed-off-by: Oliver Upton<oupton@google.com>
> ---

This needs a small adjustment:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 07d00e711043..b0c21d42f453 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11289,6 +11289,7 @@ void kvm_arch_free_vm(struct kvm *kvm)
  int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
  {
  	int ret;
+	unsigned long flags;
  
  	if (type)
  		return -EINVAL;
@@ -11314,7 +11315,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
  	mutex_init(&kvm->arch.apic_map_lock);
  	seqcount_raw_spinlock_init(&kvm->arch.pvclock_sc, &kvm->arch.tsc_write_lock);
  	kvm->arch.kvmclock_offset = -get_kvmclock_base_ns();
+
+	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
  	pvclock_update_vm_gtod_copy(kvm);
+	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
  
  	kvm->arch.guest_can_read_msr_platform_info = true;
  

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
