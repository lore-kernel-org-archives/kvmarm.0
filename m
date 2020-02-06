Return-Path: <SRS0=Is6r=32=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55DBDC33CAC
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 16:26:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0E104214AF
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 16:26:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bnu7a8Lv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E104214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B87D44A4A9;
	Thu,  6 Feb 2020 11:26:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TeVvJf7J0zhr; Thu,  6 Feb 2020 11:26:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C673C4A542;
	Thu,  6 Feb 2020 11:26:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AA034A4A9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 11:26:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Yi22ftoAXzLn for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Feb 2020 11:26:46 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FE5A4A3A3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 11:26:46 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581006406;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=pWA9L7Zc04chq1QqnWc7kHBbjNHvMkxLdbW90aT2420=;
 b=bnu7a8LvgMNmfuWnYXz3YqZlNpKVQDQZCB4oJq7bL3ylBI63CvSX0Y4YVFZrW4LGwPUhCc
 fI2zl+zDSQc8zQhe2MjW2cMkA62ZvxUzlgOQmptgeSmlJZ7v2pgkRoHTy1eEioH6gtw5fs
 2S/p3FiYk89ToPQNuYDmPKqUJ1scANI=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-Lg1wSb9oOZCIKOgtWP6yTw-1; Thu, 06 Feb 2020 11:26:44 -0500
Received: by mail-qk1-f200.google.com with SMTP id w29so3950416qkw.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Feb 2020 08:26:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=H3nLSU6aNBKxxlwzEldmN2l97fU6AU4NrctqbL5/r9Q=;
 b=VedRct6zV7HeuHCfdx958eXeHQflgK/3/XNBXk8WMzx7BefnTg9Q/nz3KAneLZLi4h
 dvLPVpVQy6i6CvlUHui8Ne1Jyp/MBjYRWfRE3P3RObR9yWrQfq+NduNHd5pOwoLsNTpS
 ZVGWLeaJJLpQYoZMq851YGQk4A3C8HqLeQX5N3HqY2j+JF1IvwUJZo5RIqErkBKsMlRe
 lS0ABQor6zO3b0Mz9X6XedzvwCP0W/dd6gjzO4vrQr6PkO+yFkdOiVQ/S57kq7oBqyb6
 YB3KvpxsxLENi3Quv/+pEy9ClL1qElQI0NTl8zbsxX+DrUKAB9HSH4k41NIs79TJdZoL
 HK5Q==
X-Gm-Message-State: APjAAAV07az5FaslHzwMC3xu0ZKg4oxO0YqRdBReiJKGWprX8GEIIqZ+
 ZhAJopt+dJNAKgyOutQIgelmzVauUXbXjiS1fhkRsLdCy8rxZ+EujAa08dIFIIcz/r/NSQGNJBG
 NEa9S2h7VrMn8i+wwjA793rny
X-Received: by 2002:ac8:1e08:: with SMTP id n8mr3297372qtl.175.1581006403784; 
 Thu, 06 Feb 2020 08:26:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqxQlIJcJ9283T0k3SJBUCagGgD/4X0S4VFGYxAKtPxVCA909nX5ytULcXgwNYLmQcG3Ogy1yQ==
X-Received: by 2002:ac8:1e08:: with SMTP id n8mr3297351qtl.175.1581006403586; 
 Thu, 06 Feb 2020 08:26:43 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
 by smtp.gmail.com with ESMTPSA id q7sm1618375qkc.43.2020.02.06.08.26.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 06 Feb 2020 08:26:42 -0800 (PST)
Date: Thu, 6 Feb 2020 11:26:39 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v5 10/19] KVM: Drop "const" attribute from old memslot in
 commit_memory_region()
Message-ID: <20200206162639.GC695333@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-11-sean.j.christopherson@intel.com>
MIME-Version: 1.0
In-Reply-To: <20200121223157.15263-11-sean.j.christopherson@intel.com>
X-MC-Unique: Lg1wSb9oOZCIKOgtWP6yTw-1
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

On Tue, Jan 21, 2020 at 02:31:48PM -0800, Sean Christopherson wrote:
> Drop the "const" attribute from @old in kvm_arch_commit_memory_region()
> to allow arch specific code to free arch specific resources in the old
> memslot without having to cast away the attribute.  Freeing resources in
> kvm_arch_commit_memory_region() paves the way for simplifying
> kvm_free_memslot() by eliminating the last usage of its @dont param.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
