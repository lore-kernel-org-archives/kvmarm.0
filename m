Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A733C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jun 2022 15:12:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0317A49E1E;
	Fri, 17 Jun 2022 11:12:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x82Znf4ZFYT3; Fri, 17 Jun 2022 11:12:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B80104B178;
	Fri, 17 Jun 2022 11:12:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 575D549E1E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 11:12:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pLu6JXroTeyD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jun 2022 11:12:09 -0400 (EDT)
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com
 [209.85.215.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4952D411C7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 11:12:09 -0400 (EDT)
Received: by mail-pg1-f169.google.com with SMTP id d129so4287319pgc.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 08:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=3mgvhKmrqaYUspBn6nABZ88HosdbgWN7FHxrlSXkE+I=;
 b=hTERR44sQ02GCKZjqwMUtxMSduYjK9pDoqnBAlk1bS16iMGjnVJpFsEEhxXsb0t1Lk
 AIdchbUIXed1op+Irh496vAc86DXlcZSXYYZUiMP0bAGwp4OABZqoEssbrcAmYwrC+KN
 2PXyVzDVabFo/w+KgK0V7Tm0go4bEd7Rres9V8lP2u0DIrrrM8q+EkUFG50Y0I9uz8WU
 KacIUUPIB1gZdjf2LexJPt8fmL3luaR9ATaG32+/B3NlZg24Q1VglatRlHZkldmJjvyk
 HTpkJ3sUqm9hzkGzzdm7Jghe0lzwpOhce2y1NHpKp7E4DQ9KhkuEvO4yu+9JNpcKR4fl
 avLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=3mgvhKmrqaYUspBn6nABZ88HosdbgWN7FHxrlSXkE+I=;
 b=5NaBSILNX5Z2ncnqhGgE/7tXWlaYLIBq2sP91a55x4lysPv6NE+XyCvL2LZDMocxxZ
 4yXCIdRx+uDaR+XQt0E3RBjujmsRZjywGSIaKfjzxFtFdpEbeumssvC38pxLbeek7FNq
 kt4HYD4PppPdffhHYXR17TSLTe/+epI16jqpSvbfiUotPSmmgcSQCq32YxqGdCnKLE4r
 trYtBzCJT4NLQwzQJ6dpNxj5g5x/5tsQeDKczaeW6d/v8VDL8U3HG4dCUNBCoqeK35B8
 1wbkg5CCszR3GH/r979GF81qCnHqqixPMvLNFpujKtITopoR79V+5xhXwPodo4fEMthj
 Poeg==
X-Gm-Message-State: AJIora9IXA8UqqGcLxt0j/yN9ksMzulLEjmXqHP/Bb4cMJ1FIm2QaR3c
 2tzwTqFfvKEjW7g5lmnD2lRCnQ==
X-Google-Smtp-Source: AGRyM1vfbbnxwQFV1uQ+YDKGOWDgTFUZzxCaEFFsVM4p7M9tq5Wv+ppIzZKQQB6z6heUAcwABxAbwg==
X-Received: by 2002:a65:404c:0:b0:3c6:4018:ffbf with SMTP id
 h12-20020a65404c000000b003c64018ffbfmr9685028pgp.408.1655478728062; 
 Fri, 17 Jun 2022 08:12:08 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 k17-20020a628e11000000b0050dc76281a2sm3808947pfe.124.2022.06.17.08.12.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Jun 2022 08:12:07 -0700 (PDT)
Date: Fri, 17 Jun 2022 15:12:04 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v6 04/22] KVM: x86/mmu: Derive shadow MMU page role from
 parent
Message-ID: <YqyZxEfxXLsHGoZ/@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-5-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220516232138.1783324-5-dmatlack@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>,
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

On Mon, May 16, 2022, David Matlack wrote:
> +static struct kvm_mmu_page *kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu,
> +						 u64 *sptep, gfn_t gfn,
> +						 bool direct, u32 access)

Please use "unsigned int" for @access, here and everywhere else, so that KVM is
consistent in how it refers to access.  @access can actually squeeze into a u8,
but it's referenced as a "unsigned int" because sp->role.access is an unsigned int.
For me at least, when I see "u<size" I always assume there is a specific reason
for using an exact size, e.g. variables/fields that track hardware state.  Whereas
"int" and "unsigned int" give the hint that the variable is KVM metadata.

@@ -2201,7 +2201,8 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
        return __kvm_mmu_get_shadow_page(vcpu->kvm, vcpu, &caches, gfn, role);
 }

-static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, u32 access)
+static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct,
+                                                 unsigned int access)
 {
        struct kvm_mmu_page *parent_sp = sptep_to_sp(sptep);
        union kvm_mmu_page_role role;
@@ -2242,7 +2243,7 @@ static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, u32 a

 static struct kvm_mmu_page *kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu,
                                                 u64 *sptep, gfn_t gfn,
-                                                bool direct, u32 access)
+                                                bool direct, unsigned int access)
 {
        union kvm_mmu_page_role role;

> +{
> +	union kvm_mmu_page_role role;
> +
> +	role = kvm_mmu_child_role(sptep, direct, access);
> +	return kvm_mmu_get_page(vcpu, gfn, role);
> +}
> +
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
