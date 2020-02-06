Return-Path: <SRS0=Is6r=32=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44D9CC33CAC
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 16:14:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BE8EA21741
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 16:14:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Eev4oJ2/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE8EA21741
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25F524A597;
	Thu,  6 Feb 2020 11:14:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gdINePXeyJWG; Thu,  6 Feb 2020 11:14:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 063004A4CD;
	Thu,  6 Feb 2020 11:14:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7791F4A49C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 11:14:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xab4ZY3ih7eh for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Feb 2020 11:14:23 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 774CA4A319
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 11:14:23 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581005663;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=mNaIfC8axAPc5ot635/t+73YbS91NIurqIIFBQVX1is=;
 b=Eev4oJ2/oA1jm6oltAaVJi5/++2Z7WMXvF0DD11D6QnOCGUBCQ/er2mA6AvFaRC10EG3Z9
 I+6BKF2CHRAeQAgC/GGepTb3kNr/Zrkr401LCvOY+qg+HA0G8cr0Z0z+FsWbpyrkQY04Ue
 RaftIpmy5GhaPPYOP4MAobM/0AekGss=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-k17hOCbgPz-0Fo3cwNgLqA-1; Thu, 06 Feb 2020 11:14:21 -0500
Received: by mail-qv1-f69.google.com with SMTP id cn2so4009468qvb.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Feb 2020 08:14:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=zD2zZ3ak+8ZDNOjl3NQ0JmucKO3t2SwHGRlR5dLOuQs=;
 b=FdMb/iD+/dPEzLNz4OvnCEMREqfxox2/pP5UETYkhBTui6XrVSHYPWQ03+PNnPAoQ0
 Ca2hHaBnBNZVw2+qq4pt8+0Hd0Pf0G3tGQ1/yrYsNsQwGqxbrJOrnWXaiiAHHyVkE9KY
 HJ0zD+ktdHl4+oAtmEMFUMT07/3ouIhYYmSWSvbLdpSCbOAY8XMZYeqsnjEGuGDtLMTu
 N+cFDUUdQjfZnLs6dIb5c9GdVp12avlmfu0O0D5ADCy5etuUqVgBWrYS4teiWkFKah10
 xKyy6S62JD9Dd5tub0SBj5Ex3rnEjtQRJl0kkQ9nV6iqlKbZBvH7SiMRSepJ6Hjr5xG1
 JDCw==
X-Gm-Message-State: APjAAAX9/9mcco4L0ZdTprhuzYSGTZcLbFJup+6gRsq/oWAybKmAZ3Qu
 1bjPhLl1wBSiFXTpBQahowU6tzjn+h33L2LQyPxSAJgVuqTXXn1mbXZp4o3QHQrJnC6gzJBF9CI
 o2xgebAieeiSEXqvYACPuJv0C
X-Received: by 2002:ac8:6f27:: with SMTP id i7mr3235328qtv.253.1581005660655; 
 Thu, 06 Feb 2020 08:14:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqzCPmrX47EJacBvj/8AwtDA4K9i5Vm/4QY2t/yuwCUp2i98pBnWQFyP1cxUVQ9RQgxjF7p4Wg==
X-Received: by 2002:ac8:6f27:: with SMTP id i7mr3235285qtv.253.1581005660385; 
 Thu, 06 Feb 2020 08:14:20 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
 by smtp.gmail.com with ESMTPSA id 136sm1590227qkn.109.2020.02.06.08.14.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 06 Feb 2020 08:14:19 -0800 (PST)
Date: Thu, 6 Feb 2020 11:14:15 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v5 12/19] KVM: Move memslot deletion to helper function
Message-ID: <20200206161415.GA695333@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-13-sean.j.christopherson@intel.com>
MIME-Version: 1.0
In-Reply-To: <20200121223157.15263-13-sean.j.christopherson@intel.com>
X-MC-Unique: k17hOCbgPz-0Fo3cwNgLqA-1
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

On Tue, Jan 21, 2020 at 02:31:50PM -0800, Sean Christopherson wrote:
> Move memslot deletion into its own routine so that the success path for
> other memslot updates does not need to use kvm_free_memslot(), i.e. can
> explicitly destroy the dirty bitmap when necessary.  This paves the way
> for dropping @dont from kvm_free_memslot(), i.e. all callers now pass
> NULL for @dont.
> 
> Add a comment above the code to make a copy of the existing memslot
> prior to deletion, it is not at all obvious that the pointer will become
> stale during sorting and/or installation of new memslots.

Could you help explain a bit on this explicit comment?  I can follow
up with the patch itself which looks all correct to me, but I failed
to catch what this extra comment wants to emphasize...

Thanks,

> 
> Note, kvm_arch_commit_memory_region() allows an architecture to free
> resources when moving a memslot or changing its flags, e.g. x86 frees
> its arch specific memslot metadata during commit_memory_region().

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
