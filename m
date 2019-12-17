Return-Path: <SRS0=Hq6c=2H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AA46C43603
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 22:48:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8E3D021582
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 22:48:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ENPY9rmt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E3D021582
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F6854A521;
	Tue, 17 Dec 2019 17:48:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wvDI9OfsCgfH; Tue, 17 Dec 2019 17:48:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 386B24A597;
	Tue, 17 Dec 2019 17:48:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFA3D4A521
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 17:48:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n9Cm3qaDNDP3 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Dec 2019 17:48:07 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5A834A51C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 17:48:07 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1576622887;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=GUm1o1HftWcEMgvrx1o44ybgamZGXLGGPDBSRSJvzJQ=;
 b=ENPY9rmtCVRMSMGqJX0f8SJ3+u7tkrH3bCd3f9oaxwoQER/Oalxtl4WhN7Gz7EczaiVS9z
 pDY5LAlAoEwD/WaU7rt8cKf8TFb+LJJ84fXByZnyzwn0/5usOanvh6wRd9w4Qfnb91t3z4
 o7vf3hnwdrMfmJw9eXeWfP578UYsEwI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-byPeMRkLNUu1TM7QD4pjTg-1; Tue, 17 Dec 2019 17:48:05 -0500
Received: by mail-qk1-f198.google.com with SMTP id m13so67441qka.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 14:48:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=9n/i9QgxhO0hGtWuQAcaruEVu8v3TGl7tcrGGNBkk0M=;
 b=UyxYBGAXq82YTEX1DM3E5LFyJF6OHOhwVocIZ/6fb4Xu1i0NkPT8RNHG3Cvaynzo5m
 /d2SaVt+d4ggsaVVsboXYWct6szY75hckxictytBIBuvIRyObgrdhJtGYKt0vXvNYhAk
 wZYMpBQlRAAs2pGhrI0dWpEeNuwPFIgLeGPIJ30H2XSKW3M4JIsovuCKGG341STqkso2
 tq3bxRD80/l6vPzGAMNERHEE3KAmQm/9ewsc6Mpm15svrH7zQqjgqiaj2qmWZCQmQ8Jk
 ASnVxXaP6zDsnNKmM+quAJ/cgqetF2T/O8ix6V7jiBTHIachRXYmE4uirGs2Bozqq0Bs
 BCWA==
X-Gm-Message-State: APjAAAUzr4BReLBSLN7JG/MdehLBlssJNb/gjwJWFSKcLaTngDyzziqX
 OI1SzqPwhih5PhJ240O3wqg+yZgWskDRhkongIIjpOUS/YvF/UttTGwbmr42XS9I6WbVPVFPEdp
 o73CAGEJlYPtdl3j412RbhC3u
X-Received: by 2002:a37:7685:: with SMTP id r127mr461140qkc.166.1576622885312; 
 Tue, 17 Dec 2019 14:48:05 -0800 (PST)
X-Google-Smtp-Source: APXvYqzzAlgi3q/A/lG8/yssi/9qke3Y+PomWjoA6OIsiWSdyH+oKnvcw0q0J4LOd+HEQncOFra+UA==
X-Received: by 2002:a37:7685:: with SMTP id r127mr461111qkc.166.1576622885122; 
 Tue, 17 Dec 2019 14:48:05 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
 by smtp.gmail.com with ESMTPSA id 63sm15645qki.57.2019.12.17.14.48.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 17 Dec 2019 14:48:04 -0800 (PST)
Date: Tue, 17 Dec 2019 17:48:02 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v4 11/19] KVM: x86: Free arrays for old memslot when
 moving memslot's base gfn
Message-ID: <20191217224802.GA26669@xz-x1>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
 <20191217204041.10815-12-sean.j.christopherson@intel.com>
MIME-Version: 1.0
In-Reply-To: <20191217204041.10815-12-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: byPeMRkLNUu1TM7QD4pjTg-1
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

On Tue, Dec 17, 2019 at 12:40:33PM -0800, Sean Christopherson wrote:
> Explicitly free the metadata arrays (stored in slot->arch) in the old
> memslot structure when moving the memslot's base gfn is committed.  This
> eliminates x86's dependency on kvm_free_memslot() being called when a
> memlsot move is committed, and paves the way for removing the funky code
> in kvm_free_memslot() that conditionally frees structures based on its
> @dont param.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
