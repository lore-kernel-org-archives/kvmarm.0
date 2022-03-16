Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D237C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 16 Mar 2022 08:44:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B7F2749F10;
	Wed, 16 Mar 2022 04:44:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Aqm+IAW0oIK3; Wed, 16 Mar 2022 04:44:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A83D49E3A;
	Wed, 16 Mar 2022 04:44:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00BF44083E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 04:44:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eroTzCJl+lUj for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Mar 2022 04:44:20 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFBB9404FA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 04:44:20 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647420260;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=1ZQesErDQxJhbNTlel7Pn8Vb/5JIOEBvnS29Fn8zDoI=;
 b=H2MR4lfETyZ8OOYqECrFoBi/8I00uXd53axbeAoRZByXwerQZQN6+jrRFng4q4OHe4Oltz
 xMh9w55zTP2Y0VZEd+nq9v9PSsGkPuG5BP3CoIGjup9r9CIJIOIr5f4AHvKjHUSpUVgV7R
 wrAfmc9d3D75CPkuSxHR1hITzI6/W4c=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-PCwoZh3IPfK-QYr4gimj4Q-1; Wed, 16 Mar 2022 04:44:19 -0400
X-MC-Unique: PCwoZh3IPfK-QYr4gimj4Q-1
Received: by mail-pl1-f198.google.com with SMTP id
 l6-20020a170903120600b0014f43ba55f3so979815plh.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 01:44:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=1ZQesErDQxJhbNTlel7Pn8Vb/5JIOEBvnS29Fn8zDoI=;
 b=2hCLQh9u/3nbbddetoopHCW4+ieVoy+d7ICShF4Jj0T2UGQ3pKfhC/blVKnqL7StQv
 VHU6FDGLUh65qhPOOoIKRhEqd6FHnP80GSjI9LmPC7R/dX4saM35INu2rI98NIieIN8k
 twude6YdLl4OSvMwXMO5SoN91mTqQLnIFNYG3MEqyNQgquxl38YvvG5E1X/qpTPTLQSP
 vPZPj65Jpse0Thvuia6JNtkg6Iey8jwbAFkzQZYqSL2EZTF5XFYzI9et2VBm0eLga50v
 gLFbxSNEfhtUMngHJSJYIRfs1HTZyX4u+3ARx5dZWdU89YyxlGbQrtshZ1vmFaBOlYeD
 EJdg==
X-Gm-Message-State: AOAM532mKpah/5+u3b7N33v7nLbTfK48NzkstCMc+WJda30swDsVU2j9
 fVRHEil+y6zJpC8eLYun8aTsg9LyY2EVV+gD3UD8s0fUSg95QHFSnMueADzLKkmiin9HtEwo6Qy
 yVFNCGn9Wtd3gWW/yMyIobKnf
X-Received: by 2002:a05:6a00:170c:b0:4f7:658d:77a2 with SMTP id
 h12-20020a056a00170c00b004f7658d77a2mr33249775pfc.60.1647420258155; 
 Wed, 16 Mar 2022 01:44:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwf5n0IdTCbTV5mIpfQa8fPfAwUPw+X6hCobMzk5jCneFEdxWl5Yk9KwxIn4gIMUVJ5GpzGRg==
X-Received: by 2002:a05:6a00:170c:b0:4f7:658d:77a2 with SMTP id
 h12-20020a056a00170c00b004f7658d77a2mr33249747pfc.60.1647420257911; 
 Wed, 16 Mar 2022 01:44:17 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.128])
 by smtp.gmail.com with ESMTPSA id
 o5-20020a056a0015c500b004f76735be68sm2185059pfu.216.2022.03.16.01.44.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Mar 2022 01:44:17 -0700 (PDT)
Date: Wed, 16 Mar 2022 16:44:09 +0800
From: Peter Xu <peterx@redhat.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2 17/26] KVM: x86/mmu: Pass access information to
 make_huge_page_split_spte()
Message-ID: <YjGjWcmn+7sZPjNX@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-18-dmatlack@google.com>
MIME-Version: 1.0
In-Reply-To: <20220311002528.2230172-18-dmatlack@google.com>
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

On Fri, Mar 11, 2022 at 12:25:19AM +0000, David Matlack wrote:
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 85b7bc333302..541b145b2df2 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1430,7 +1430,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
>  	 * not been linked in yet and thus is not reachable from any other CPU.
>  	 */
>  	for (i = 0; i < PT64_ENT_PER_PAGE; i++)
> -		sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i);
> +		sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i, ACC_ALL);

Pure question: is it possible that huge_spte is RO while we passed in
ACC_ALL here (which has the write bit set)?  Would it be better if we make
it a "bool exec" to be clearer?

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
