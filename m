Return-Path: <SRS0=Hq6c=2H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C627AC43603
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 22:07:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4A07E20716
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 22:07:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DLtqyOr7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4A07E20716
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B15E54A610;
	Tue, 17 Dec 2019 17:07:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2MgcxYgZ5AT5; Tue, 17 Dec 2019 17:07:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD9A94A536;
	Tue, 17 Dec 2019 17:07:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 343CA4A52C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 17:07:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hiYHB1jNlucS for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Dec 2019 17:07:26 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FB124A389
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 17:07:26 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1576620445;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=dMNrU891HIbbCXzuvJMLqIA+nkJje43G6ahYCI5AhR8=;
 b=DLtqyOr7NW1tNXcZ0IRHbQqnk6jKLTG/WuBzfO4Vx1u9Jm7GGGu3TdjZauOb9kbEhwaP8C
 wnJgWGE8mMunvCIulNQ3/yPd3OiXVuZVmS2TaccBO/BEXSIto/U07wNqtxsgcGFhgQRaKP
 xtW/fM8CwhWFjkBNFEKSTLJYOY88ToY=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-hLR9zjytNCGxjIon7xKfEQ-1; Tue, 17 Dec 2019 17:07:21 -0500
Received: by mail-qt1-f200.google.com with SMTP id k27so128003qtu.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 14:07:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=slGVCNmnwx0F1K+nCa+cID8Tdy/RHxQkOhSUfY0VX6I=;
 b=lj5Vz9zq0TR8QSVn0IiTfI3J+2Hf1qIBfP7qUc+K4EhcUtBUE9SH6HFplLZij7lLPb
 8PN03lRdljg027W7ERUOdsRXgV9gQza9KnIMA8/lm/I7KKyJPv6bLg3BxgvIZgsAj7eQ
 JIlB6fdsK6WCstB3CWdrmZrMCX44JcUUqxsajj8E9CuyjK7si2DF7uShbb1rpWbJxEXW
 yer8RAIT+m9G48peYcnDE5L8SJaLYQdE5d4EQ36Jp65+23UBdSKQtlbDzOxA8/cunZnN
 8CO0hrlZ9APA14zxxLFeAxpMgA7nM3g/skjP+EfEZHWMiJS7JNcieKT6ZtDZowg6v2IH
 1IZg==
X-Gm-Message-State: APjAAAWVGT6Ktol3gPFr+hqE8rbBlDUhnwVuYzyfINLHWsVEH8dRYywQ
 ZOPefHq1MQm9R+jvm//NxIlssymT/iwQ95MpvY+aRriYTPrDZIRz8s7poK/ebKXh0j/nhjfZAxF
 j9GzDZhKiL5qEtu+wl/c64ggP
X-Received: by 2002:a0c:f68f:: with SMTP id p15mr6885122qvn.79.1576620441553; 
 Tue, 17 Dec 2019 14:07:21 -0800 (PST)
X-Google-Smtp-Source: APXvYqyYYchEVtwDwgk4Pr56pOeSJtWkuin1D2pVTuKZ433b4vaBfoHv6+mbPiSSnU54NveRu8NnwQ==
X-Received: by 2002:a0c:f68f:: with SMTP id p15mr6885088qvn.79.1576620441243; 
 Tue, 17 Dec 2019 14:07:21 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
 by smtp.gmail.com with ESMTPSA id o9sm7592950qko.16.2019.12.17.14.07.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 17 Dec 2019 14:07:20 -0800 (PST)
Date: Tue, 17 Dec 2019 17:07:18 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v4 05/19] KVM: x86: Allocate memslot resources during
 prepare_memory_region()
Message-ID: <20191217220718.GJ7258@xz-x1>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
 <20191217204041.10815-6-sean.j.christopherson@intel.com>
MIME-Version: 1.0
In-Reply-To: <20191217204041.10815-6-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: hLR9zjytNCGxjIon7xKfEQ-1
X-Mimecast-Spam-Score: 0
Content-Disposition: inline
Cc: Wanpeng Li <wanpengli@tencent.com>, Janosch Frank <frankja@linux.ibm.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 James Hogan <jhogan@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
 kvm-ppc@vger.kernel.org, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
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

On Tue, Dec 17, 2019 at 12:40:27PM -0800, Sean Christopherson wrote:
> Allocate the various metadata structures associated with a new memslot
> during kvm_arch_prepare_memory_region(), which paves the way for
> removing kvm_arch_create_memslot() altogether.  Moving x86's memory
> allocation only changes the order of kernel memory allocations between
> x86 and common KVM code.
> 
> No functional change intended.

(I still think it's a functional change, though...)

> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
