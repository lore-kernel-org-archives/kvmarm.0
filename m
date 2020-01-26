Return-Path: <SRS0=dTd4=3P=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A10A6C35242
	for <kvmarm@archiver.kernel.org>; Sun, 26 Jan 2020 03:02:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 20F1C20702
	for <kvmarm@archiver.kernel.org>; Sun, 26 Jan 2020 03:02:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lJIXcxbg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20F1C20702
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E8084AF2D;
	Sat, 25 Jan 2020 22:02:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sTA6xKVJJXph; Sat, 25 Jan 2020 22:02:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 480CD4AF31;
	Sat, 25 Jan 2020 22:02:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B7BB4AF2D
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Jan 2020 22:02:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EIa+PNClChcG for <kvmarm@lists.cs.columbia.edu>;
 Sat, 25 Jan 2020 22:02:29 -0500 (EST)
Received: from mail-yw1-f68.google.com (mail-yw1-f68.google.com
 [209.85.161.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 31BD74AF1F
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Jan 2020 22:02:29 -0500 (EST)
Received: by mail-yw1-f68.google.com with SMTP id u139so3032625ywf.13
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Jan 2020 19:02:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=sender:date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=tII4AVx3br1wrYA9rc56+ZdNuhnFX5KM9kteNOyiS3I=;
 b=lJIXcxbgCpGMRp6Zhvk2vdNUDh4nIe7voMjfHZxQXifoDNtapG1wg1VPXaJ/D5W50V
 q++Qs7815rrRcG1L7K91MxNz42/vCV917pKz+9tZLTxiAmjfYanj20HwdKQydpmE8KjY
 tDlpYmVMQWyr6MwKAd9+zqXhUsPdYj3bwOgycRD9kcbZ7EYqcByFtvK6zRrCsz/VBjJ4
 sLYwOcJ//TFJvb61wypLOyUvG/FePeJawpqNadA7y+xAnoGeTbtGKwBUIsWjy4E82OvC
 duMEH8TkUvPKoMimw74utO6UXNSMWYG5NgjQfg1fKhnGS4Nb7D9RTS+nENdf6YceeAf7
 20Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
 :references:mime-version:content-disposition:in-reply-to:user-agent;
 bh=tII4AVx3br1wrYA9rc56+ZdNuhnFX5KM9kteNOyiS3I=;
 b=aiWA02lOMMhYU4A/g+Sh9b74mL9qCJtRW8sif/m0E+BW3oEBAatW/N9tlbx5xbWsjF
 jlloxHLQn3RMCVSvt6FtXm2THpr4DYB+XowL11/ZT5RUL704SfZzIlal7ldtbnNgpJDa
 RQwnlWxYtgwTTF0bj+XkCyn4tupBVK4DjF6kDVf923hz4/twZIJ8UZ9YmY7u0MNd+V9m
 JRu1mCRT3CIuDS+VBiH/ryfWXQ1QZUUNaYLkjit7hX0393OPGcyRyuaThnSImjtkCgKg
 S8dgBBb5oy6ie6JfJMendNNLlCXjCeWMets6mbwWUYRWh2lwOD+A1syblwQf1phWsuWY
 Jsfw==
X-Gm-Message-State: APjAAAXUaWY046itRRocC3WKgQdFGsnfof0GRDRwzauBMZNmKtt7Aejs
 jTb0rO26ns9BUPv0MvI2a/Y=
X-Google-Smtp-Source: APXvYqxidmu1wxYikxWGAWqi1KWvgtfYYggyQy+ED7b5j1UZ0or2nxTKdnePwrdbB9N0a8F2AlDozg==
X-Received: by 2002:a0d:d8c2:: with SMTP id a185mr7623650ywe.337.1580007748730; 
 Sat, 25 Jan 2020 19:02:28 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
 by smtp.gmail.com with ESMTPSA id s3sm4845031ywf.22.2020.01.25.19.02.27
 (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
 Sat, 25 Jan 2020 19:02:28 -0800 (PST)
Date: Sat, 25 Jan 2020 19:02:26 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v2 30/45] KVM: Move vcpu alloc and init invocation to
 common code
Message-ID: <20200126030226.GA7167@roeck-us.net>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
 <20191218215530.2280-31-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191218215530.2280-31-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, James Hogan <jhogan@kernel.org>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Greg Kurz <groug@kaod.org>,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
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

On Wed, Dec 18, 2019 at 01:55:15PM -0800, Sean Christopherson wrote:
> Now that all architectures tightly couple vcpu allocation/free with the
> mandatory calls to kvm_{un}init_vcpu(), move the sequences verbatim to
> common KVM code.
> 
> Move both allocation and initialization in a single patch to eliminate
> thrash in arch specific code.  The bisection benefits of moving the two
> pieces in separate patches is marginal at best, whereas the odds of
> introducing a transient arch specific bug are non-zero.
> 
> Acked-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>

[ ... ]

> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 8543d338a06a..2ed76584ebd9 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
>  

[ ... ]

> -struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
> -				      unsigned int id)
                                      ^^^^^^^^^^^^^^^
> +int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_vcpu *vcpu;
>  	struct sie_page *sie_page;
>  	int rc;
>  
> -	rc = -ENOMEM;
> -
> -	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
> -	if (!vcpu)
> -		goto out;
> -
> -	rc = kvm_vcpu_init(vcpu, kvm, id);
> -	if (rc)
> -		goto out_free_cpu;
> -
> -	rc = -ENOMEM;
> -
>  	BUILD_BUG_ON(sizeof(struct sie_page) != 4096);
>  	sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL);
>  	if (!sie_page)
> -		goto out_uninit_vcpu;
> +		return -ENOMEM;
>  
>  	vcpu->arch.sie_block = &sie_page->sie_block;
>  	vcpu->arch.sie_block->itdba = (unsigned long) &sie_page->itdb;
> @@ -3087,15 +3070,11 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
>  		 vcpu->arch.sie_block);
>  	trace_kvm_s390_create_vcpu(id, vcpu, vcpu->arch.sie_block);
                                   ^^^

For extensive changes like this, wouldn't it be desirable to at least
compile test it ?

Guenter
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
