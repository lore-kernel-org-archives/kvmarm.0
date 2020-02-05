Return-Path: <SRS0=/ADY=3Z=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B6F1C35247
	for <kvmarm@archiver.kernel.org>; Wed,  5 Feb 2020 22:08:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BB786218AC
	for <kvmarm@archiver.kernel.org>; Wed,  5 Feb 2020 22:08:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g9ITKX2G"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB786218AC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D6ED4A588;
	Wed,  5 Feb 2020 17:08:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mJfr8vU+TaLD; Wed,  5 Feb 2020 17:08:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A3B74A4A0;
	Wed,  5 Feb 2020 17:08:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD1FC4A4A0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Feb 2020 17:08:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I6CmQP28SuuP for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Feb 2020 17:08:28 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5D854A418
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Feb 2020 17:08:28 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1580940508;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=qcqAII0Mla+8J9XCC2F7t68zZyPiZF4YHjS+Fi7LYLQ=;
 b=g9ITKX2GWWs4T9/us1xD6YU0/Y1pXLnZm77QBdBMwUfuBgfTMk/mRAtxKQbq0XEdi9t8b2
 8m9a7QB3K3lS602ezvzVWBJlD/LguhOgk4eBOdprDAGR6NUfilcfwTvQNqL29N5vA4gjIz
 lWHW9QQ449FjvHAok3SJ0Md2HSY7Ii8=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-2VXK8TMWM9-XJvZiYHM7Tw-1; Wed, 05 Feb 2020 17:08:27 -0500
Received: by mail-qt1-f198.google.com with SMTP id x8so2396353qtq.14
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Feb 2020 14:08:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=6bIsTUAiuk9WkuPnamAI4/KWATTYkjxm0pqVjMTg08w=;
 b=F2MGNDFwKFdoCQXiQ5rNefX28JEA7aG5EeiH/V0JOT8vpibOAkV2antLylfIC5d8a0
 E6Of9H5txTNAUmc/8nTIFRLpFAO0YmwML2zKJDfgLebm09qm4+fTeaAkcKLM4fXnsZFJ
 fdcTKo7jYcwOA7ttzVsdrC7xUm55lDQxdMxk77UGACOIr/x+fAfZlb7FhXHS76c3JBcC
 kFD4O3bxOsseBsPcMEqGDV4jzM9AWJtOSDGaey0ERa6LFpVaSyKoLnIErSKjCR+78dM/
 p6++Q3XL/A6ICXKhs8hWOJlXDV61Qu/3R/fsdNNcqZWXPRlaAnVW82LJm4rl5ISXosuY
 5g2w==
X-Gm-Message-State: APjAAAVB8whGmYrJj2aFn+zbkTbl+s8OgVVw0Z+/gC+ZWKTkn6D44qcM
 SoN1F3/1p6q0LiPvVIQYrhKI+Eg2PnaUv5yNNaLHP8NTpry9hJRsOlh3aLIzuDK0FzLhBh17a4n
 FY63gcgJF7HTpADJxqu62KYj3
X-Received: by 2002:ac8:4e94:: with SMTP id 20mr35228154qtp.335.1580940506680; 
 Wed, 05 Feb 2020 14:08:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqxhvNH1iy5q/tis+s7hwuGT0ebc3dkr1uSM1KA4FQeWbspaaAJT384pUzbSiV9AUE83qayDAQ==
X-Received: by 2002:ac8:4e94:: with SMTP id 20mr35228131qtp.335.1580940506464; 
 Wed, 05 Feb 2020 14:08:26 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
 by smtp.gmail.com with ESMTPSA id t16sm458993qkg.96.2020.02.05.14.08.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 05 Feb 2020 14:08:25 -0800 (PST)
Date: Wed, 5 Feb 2020 17:08:22 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v5 02/19] KVM: Reinstall old memslots if arch preparation
 fails
Message-ID: <20200205220822.GE387680@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-3-sean.j.christopherson@intel.com>
MIME-Version: 1.0
In-Reply-To: <20200121223157.15263-3-sean.j.christopherson@intel.com>
X-MC-Unique: 2VXK8TMWM9-XJvZiYHM7Tw-1
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

On Tue, Jan 21, 2020 at 02:31:40PM -0800, Sean Christopherson wrote:
> Reinstall the old memslots if preparing the new memory region fails
> after invalidating a to-be-{re}moved memslot.
> 
> Remove the superfluous 'old_memslots' variable so that it's somewhat
> clear that the error handling path needs to free the unused memslots,
> not simply the 'old' memslots.
> 
> Fixes: bc6678a33d9b9 ("KVM: introduce kvm->srcu and convert kvm_set_memory_region to SRCU update")
> Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
