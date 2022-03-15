Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59965C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 15 Mar 2022 10:27:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6C824083E;
	Tue, 15 Mar 2022 06:27:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iF1FbpazpRFI; Tue, 15 Mar 2022 06:27:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FD7C49E0E;
	Tue, 15 Mar 2022 06:27:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC700411C7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 06:27:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a4gfKCL9+ssF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2022 06:27:24 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B79F44083E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 06:27:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647340043;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=DiRHDgSxXyEgzQ/1H6WEmoIcoAybwpIARKWXa7C6zmE=;
 b=fNjokV+U6b6n3aOktTDO8v2FbMJVtNJzrF9EQuIcrZdCI0Herjg/f3C1UQL9mQKaMGnjPj
 ny93Xc0IlFfIOYCcP0GeCILY+oKzdojYPW4DpxEeGDrX/UPOa+V9+4ipY7NZYAr+k5AoJv
 V96yE+c0ixZK65UusCNmMglcafnMINM=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-oRIX5izGPfq70yOTTi-Alw-1; Tue, 15 Mar 2022 06:27:22 -0400
X-MC-Unique: oRIX5izGPfq70yOTTi-Alw-1
Received: by mail-pf1-f199.google.com with SMTP id
 g189-20020a6252c6000000b004f6f5bbaf7cso2839378pfb.16
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 03:27:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=DiRHDgSxXyEgzQ/1H6WEmoIcoAybwpIARKWXa7C6zmE=;
 b=6A1XgLTC+/ZICVoV+HcftDdKlS6xi5AbXsdFKRkFS6nkprUcuvFpEkFzHLdJaK+ydt
 mXZ/Pr15m0kAdjiIJWxBY35UO25wyZpUq0U/igeqzgEdvbBBt7aXy2ILqpMFDC0LbrD4
 XfUwXu5EJs7ZbxVs3JGrH8YRNRmUdEihc3cgJ3100sqDpf4hVfAbmofRmfP0wdkJPtXq
 TDsvO5ze1tx8jXhbIRPvGFrYlm5kdHgY51sNaP9zRMkB6Ulvt5icE+9G2a2DfGEGLPFZ
 LnNPgggL8dgMnGpndbCNyhM5VHD9wvlnV9QYWTlNhVKiKiGXcYIlamZDw08A2OUVNhFV
 Q+lQ==
X-Gm-Message-State: AOAM53163EkK7ystYHYTGuleopw6oSRQinOlYVYt2mmysBzOEWKyUN5z
 dNY6zJSF5aBXsZWvKDt24r2fGdhP3Ipp6eh1pJa7WgxSVXpYAqQkfbPfgwiW4QZD46oyYaIlLJD
 ktebRqORyqChOCWgLvLwNIcIp
X-Received: by 2002:a17:90a:dd45:b0:1bc:9466:9b64 with SMTP id
 u5-20020a17090add4500b001bc94669b64mr3777698pjv.23.1647340041348; 
 Tue, 15 Mar 2022 03:27:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwzh2WwWxCZLGIqwAfZcs1dEgUiakwT/1eroDl5Gkt3WkAGN7vYYYLwox9cKA4UNqkAcC0R1w==
X-Received: by 2002:a17:90a:dd45:b0:1bc:9466:9b64 with SMTP id
 u5-20020a17090add4500b001bc94669b64mr3777656pjv.23.1647340041068; 
 Tue, 15 Mar 2022 03:27:21 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.43]) by smtp.gmail.com with ESMTPSA id
 j13-20020a056a00130d00b004f1025a4361sm25697622pfu.202.2022.03.15.03.27.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Mar 2022 03:27:20 -0700 (PDT)
Date: Tue, 15 Mar 2022 18:27:12 +0800
From: Peter Xu <peterx@redhat.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2 11/26] KVM: x86/mmu: Use common code to allocate
 kvm_mmu_page structs from vCPU caches
Message-ID: <YjBqAL+bPmcQpTgM@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-12-dmatlack@google.com>
MIME-Version: 1.0
In-Reply-To: <20220311002528.2230172-12-dmatlack@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=peterx@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

On Fri, Mar 11, 2022 at 12:25:13AM +0000, David Matlack wrote:
>  static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_mmu_page *sp;
> -
> -	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> -	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> -	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> -
> -	return sp;
> +	return kvm_mmu_alloc_shadow_page(vcpu, true);
>  }

Similarly I had a feeling we could drop tdp_mmu_alloc_sp() too.. anyway:

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
