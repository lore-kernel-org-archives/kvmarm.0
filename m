Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB2C8C43334
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jun 2022 14:07:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C8A24B1A2;
	Thu, 16 Jun 2022 10:07:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NjxXp0FmnFd9; Thu, 16 Jun 2022 10:07:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E4A449EEE;
	Thu, 16 Jun 2022 10:07:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7EEC49EEE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 10:07:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2tqhkjF3vDjq for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jun 2022 10:07:55 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA86549EE9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 10:07:55 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1655388475;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=vj6vIUe+P865+ulNfTshQe6lyGdt3w3qdMjI5aQiat4=;
 b=TWwJ7YEJc2cyA/37kiQmk7+ROxMrYg1Z0QwM0UBm54qBGS3/cJ8yxPBMuxflXeBDUi3x2b
 dsZXuJ4BXxAvJkJv8zB0bkxQw6ukQoFaQojdA5PYxOXTCFhDPbWwuI0tJlfU6G0Fp7XFfg
 rr3bvxfppDm8tmH0KpfYzeixv1B00Dw=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-zAmFQiXHNGeZO8zhanYZKQ-1; Thu, 16 Jun 2022 10:07:54 -0400
X-MC-Unique: zAmFQiXHNGeZO8zhanYZKQ-1
Received: by mail-ej1-f69.google.com with SMTP id
 mh24-20020a170906eb9800b0070947edf692so659406ejb.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 07:07:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=vj6vIUe+P865+ulNfTshQe6lyGdt3w3qdMjI5aQiat4=;
 b=eKcuwdjxpkIjdZRx2gYXpt98dbXAYlBYKah8d7kG0FFi1GgGOSZW1/UF7IS4074b/I
 X83rNiW8O2n/THR1RS3r/5jhRLlfZ6ROVwqM/C2fgWuqhPn3cIgcov8ENlCxugrsVUJ3
 7gsMcJB8mpAtDwOhBPoDN6UcGO9obxMN2MulOAXm3hHPHRAz8N+jk9GksFeoXumeLUtQ
 tMjaxnA3cSHKI1tbKiInVGsEvlfAb18WbVEaBI5aWAnTBmEJd+RUwWxN3cBCa407Jlhd
 Shfim+DVHPAvRzcVdSFvGd6qEp/aEn1gtgMieTaXhCwVCtjDH0VL0t1h4/g1fNQUuRd5
 9mnA==
X-Gm-Message-State: AJIora8/4eVkimFmRsRJ6O1Di7zmKhMhz3cC7VcsdC6SpqbobPFUuxPz
 Bp0h/8LQyFG+r1LrYDKZhjuTHCeFFZPw1eRS82PZOebIrQGwUf8j3g+TlNRXBTp4ZTXK+C/D3Y5
 fsl2KNqLdjJV+9lZOakQR4O4Y
X-Received: by 2002:a17:906:1501:b0:715:76d0:862a with SMTP id
 b1-20020a170906150100b0071576d0862amr4631450ejd.681.1655388466612; 
 Thu, 16 Jun 2022 07:07:46 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tjkTdqr/3szBK+kh0+YeurMBpG7920Nr3gO+Ai5BarLS9mhezzaOW933L2KCBhcv/9T2taOg==
X-Received: by 2002:a17:906:1501:b0:715:76d0:862a with SMTP id
 b1-20020a170906150100b0071576d0862amr4631421ejd.681.1655388466369; 
 Thu, 16 Jun 2022 07:07:46 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
 by smtp.gmail.com with ESMTPSA id
 rh17-20020a17090720f100b006fef5088792sm812870ejb.108.2022.06.16.07.07.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 16 Jun 2022 07:07:45 -0700 (PDT)
Date: Thu, 16 Jun 2022 16:07:43 +0200
From: Andrew Jones <drjones@redhat.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 1/2] KVM: selftests: kvm_vm_elf_load() and elfhdr_get()
 should close fd
Message-ID: <20220616140743.gnokbxu67pjz6phs@gator>
References: <20220217034947.180935-1-reijiw@google.com>
MIME-Version: 1.0
In-Reply-To: <20220217034947.180935-1-reijiw@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Paolo,

Can you pick this old patch up?

Thanks,
drew

On Wed, Feb 16, 2022 at 07:49:46PM -0800, Reiji Watanabe wrote:
> kvm_vm_elf_load() and elfhdr_get() open one file each, but they
> never close the opened file descriptor.  If a test repeatedly
> creates and destroys a VM with vm_create_with_vcpus(), which
> (directly or indirectly) calls those two functions, the test
> might end up getting a open failure with EMFILE.
> Fix those two functions to close the file descriptor.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  tools/testing/selftests/kvm/lib/elf.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/lib/elf.c b/tools/testing/selftests/kvm/lib/elf.c
> index 13e8e3dcf984..9b23537a3caa 100644
> --- a/tools/testing/selftests/kvm/lib/elf.c
> +++ b/tools/testing/selftests/kvm/lib/elf.c
> @@ -91,6 +91,7 @@ static void elfhdr_get(const char *filename, Elf64_Ehdr *hdrp)
>  		"  hdrp->e_shentsize: %x\n"
>  		"  expected: %zx",
>  		hdrp->e_shentsize, sizeof(Elf64_Shdr));
> +	close(fd);
>  }
>  
>  /* VM ELF Load
> @@ -190,4 +191,5 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
>  				phdr.p_filesz);
>  		}
>  	}
> +	close(fd);
>  }
> -- 
> 2.35.1.473.g83b2b277ed-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
