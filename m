Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8689BC433FE
	for <kvmarm@archiver.kernel.org>; Tue, 15 Mar 2022 10:23:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED56649F1F;
	Tue, 15 Mar 2022 06:23:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zqzfwtP+cqhe; Tue, 15 Mar 2022 06:23:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D159E49EC0;
	Tue, 15 Mar 2022 06:23:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17F7E49E3F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 06:23:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DByVF7Ku5z0U for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2022 06:23:00 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1799B4291D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 06:23:00 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647339779;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=LjO2FjgMYcDXjzsWvO69h8LISgo2Po4eNzRhF4LMslU=;
 b=UxVHS6LkBAFQUm7TTvr36FB8+dlE5lMRUIh2YBraeilRam0ez/cgi9PiMYEASu0++ExOXS
 ubeakem/JLWwPL4BItcAufxWbPdi7fWAhHDm02CAX2uWRJ6F4bobrgvVtCERqx4zysQt2N
 ULf0YmL4oz+mxs2nW7+m9jOXkPXYpA4=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-316-vk41WundPgmqyVww-SUEFw-1; Tue, 15 Mar 2022 06:22:56 -0400
X-MC-Unique: vk41WundPgmqyVww-SUEFw-1
Received: by mail-pl1-f197.google.com with SMTP id
 w24-20020a170902a71800b001538d7b076dso1708439plq.16
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 03:22:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=LjO2FjgMYcDXjzsWvO69h8LISgo2Po4eNzRhF4LMslU=;
 b=2nxa27k7lfEbkkZ+6n3TK+pxgH+jUs1zfTt+z89rJHxF/knCf49a1sFwFfOgY2cqXA
 /A0U1innHUl4YsbnHQAJZOl42pi2cfMIjh8p+UJeuofpW9LI1czTSaT29cSU85tLaX7s
 OZYxHmqGcghpploivk1sG/DYV6O+ASHs6D0sDUtwk/E7NDUcg9mtSjOlykdrDDXGOtWk
 4CvT1oPge3zbNNiQdzCJD+HfZepGA2lNG20v2sP49dhFyUNg0JpO+PE+FYbrOkumlwz2
 U/JAkmDp31NZy2ExseCImhChqHF4jF1xtJEGBBFmxx+Rp6du7L5sUl9676FNKidaxtXn
 JURA==
X-Gm-Message-State: AOAM5311wjB8HHEeQe5VPrd0hroAPiaI/eQLgeuYnoZUzc08uxbGre+f
 OFDGFPCTFkYDVhsKkaab5q7jJQ2Imsis43wBiLeXyUrekcl8j+5K/IQxg+XbkgLOkZoj2BfsKC+
 zfO0vyWSqBLIBL7VGJubKh1mr
X-Received: by 2002:a05:6a00:14c2:b0:4f7:aa97:b5e with SMTP id
 w2-20020a056a0014c200b004f7aa970b5emr15093610pfu.36.1647339775632; 
 Tue, 15 Mar 2022 03:22:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxlgZBAANuQaigRsSRxv4DdK0Lzq7N0trNYqbFO7O9+WaQCS1rR26LE1oMF3KmJgCc+f7s88A==
X-Received: by 2002:a05:6a00:14c2:b0:4f7:aa97:b5e with SMTP id
 w2-20020a056a0014c200b004f7aa970b5emr15093565pfu.36.1647339775342; 
 Tue, 15 Mar 2022 03:22:55 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.43]) by smtp.gmail.com with ESMTPSA id
 o5-20020a056a00214500b004bd7036b50asm24014757pfk.172.2022.03.15.03.22.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Mar 2022 03:22:55 -0700 (PDT)
Date: Tue, 15 Mar 2022 18:22:46 +0800
From: Peter Xu <peterx@redhat.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2 10/26] KVM: x86/mmu: Use common code to free
 kvm_mmu_page structs
Message-ID: <YjBo9iuSBm1hbqXz@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-11-dmatlack@google.com>
MIME-Version: 1.0
In-Reply-To: <20220311002528.2230172-11-dmatlack@google.com>
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

On Fri, Mar 11, 2022 at 12:25:12AM +0000, David Matlack wrote:
>  static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
>  {
> -	free_page((unsigned long)sp->spt);
> -	kmem_cache_free(mmu_page_header_cache, sp);
> +	kvm_mmu_free_shadow_page(sp);
>  }

Perhaps tdp_mmu_free_sp() can be dropped altogether with this?

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
