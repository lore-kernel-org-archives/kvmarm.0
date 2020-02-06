Return-Path: <SRS0=Is6r=32=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5095BC3F68F
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 16:29:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CA76E2192A
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 16:29:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QjMjsppz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA76E2192A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F4D54A4AA;
	Thu,  6 Feb 2020 11:29:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4s6yWNP8nldF; Thu,  6 Feb 2020 11:29:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 585E84A536;
	Thu,  6 Feb 2020 11:29:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2D164A4AA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 11:29:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uzQzLIJlJUr1 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Feb 2020 11:29:29 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1190C4A4A9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 11:29:29 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581006568;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Ea5EidDzUS0jrns2P2Xa5IXT6fikg70+W0wKnCn2H9s=;
 b=QjMjsppzW3iCQ4b3pOSrkLlL3e9OVHE2jiCP47Sp29zPi80B7+opRz65+4u+0Hyym1YYRn
 MPKuU6810jxhO1v7Ued2PlGyXKfgb05ym42cHHdrsr/yHV//FPyEO9Qlr2WC3B5h/Vbi2l
 Xt+MbvRoCHXfVz4GRL8X49hRumhUkZ0=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-z3RF7omiPfqEiWYcamzGYw-1; Thu, 06 Feb 2020 11:29:26 -0500
Received: by mail-qk1-f200.google.com with SMTP id a132so3954458qkg.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Feb 2020 08:29:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=BT971wG6wPhX7VJFd1sOcOxmL5huobHf2O2WL2kB92A=;
 b=l3C1/pDRwfp+LxkkGDMDBrPJo06IYpmdVg2t/Z62+QAmwn4XI8zOJmwbX83xjU/Kpl
 4dliNzc6IRID2rEbKd7uKfHeuhOAUwoZnJUfayk0gxzSVOPRlPQ83Y1d5l8omYxVGTvr
 mM+ox6FbfUN5N3VF1r29pu1LuvtOvfhPk41kz2CbLe6vhNKAoBJHiWY+yX/ZeupBCawX
 n6t7zQpwXJzXf9i+Wom7XdgJ6zFwEYgPtIdf2RCJ1sdVYFFRzNJfE1m+EbdUPOLwQ38X
 t753okTbDq8soGUYnE3T5FVKvWH1SzRw9wwvvbRjN1AhYOxalpRDVD6+xZcgBalkH8QZ
 f2OQ==
X-Gm-Message-State: APjAAAWb/duwpwgEmdb0R+HByrvDqeDv+1yP3UX1Lf76E5odPrmjDgi6
 1tDm+3PhpASxdqYJqdW3hJTzJjHruWYYoKMsA3fgSnhp+T40HgMHM0WoJzdADrqlpoTPBHTOVO1
 lUTjW8Nng4FalMn1WMWxJ5ewK
X-Received: by 2002:a37:94d:: with SMTP id 74mr3342080qkj.352.1581006566410;
 Thu, 06 Feb 2020 08:29:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqw79o/OSwP8qcG9zRkYGvX/+TD2xb8/Jp5SJeC8yu8obGrRcXecqs/KUsVKwfDvaLoqKhSpHg==
X-Received: by 2002:a37:94d:: with SMTP id 74mr3342054qkj.352.1581006566202;
 Thu, 06 Feb 2020 08:29:26 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
 by smtp.gmail.com with ESMTPSA id o55sm1966271qtf.46.2020.02.06.08.29.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 06 Feb 2020 08:29:25 -0800 (PST)
Date: Thu, 6 Feb 2020 11:29:22 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v5 13/19] KVM: Simplify kvm_free_memslot() and all its
 descendents
Message-ID: <20200206162922.GD695333@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-14-sean.j.christopherson@intel.com>
MIME-Version: 1.0
In-Reply-To: <20200121223157.15263-14-sean.j.christopherson@intel.com>
X-MC-Unique: z3RF7omiPfqEiWYcamzGYw-1
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

On Tue, Jan 21, 2020 at 02:31:51PM -0800, Sean Christopherson wrote:
> Now that all callers of kvm_free_memslot() pass NULL for @dont, remove
> the param from the top-level routine and all arch's implementations.
> 
> No functional change intended.
> 
> Tested-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
