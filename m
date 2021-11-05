Return-Path: <SRS0=hs0s=PY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87CF3C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  5 Nov 2021 20:12:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 013FF60FC2
	for <kvmarm@archiver.kernel.org>; Fri,  5 Nov 2021 20:12:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 013FF60FC2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 783064B16E;
	Fri,  5 Nov 2021 16:12:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o6-wG0zxwx54; Fri,  5 Nov 2021 16:12:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01A5C4B10C;
	Fri,  5 Nov 2021 16:12:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACDE24B0DB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Nov 2021 16:12:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PDM+jFTV2c1S for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Nov 2021 16:12:18 -0400 (EDT)
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com
 [209.85.214.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 057044A193
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Nov 2021 16:12:17 -0400 (EDT)
Received: by mail-pl1-f178.google.com with SMTP id n8so11755594plf.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 05 Nov 2021 13:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=qri/F8nrhMHPEDYa4uQBt3JEMiHHv9C5/Jmdnno/6TE=;
 b=cIEyP8aWcsIt4l1x4nbkEBmKTwuf4VKIqebtH0CamXLLrZvDTlRgHn6uwPaIY1qdYN
 Fgiy/kNzJgL6/SmGcy37HITOWEPVyIdCiclDP5nOj+WydYi2O63mGY95RUeOrxL9PvWh
 Gfm1SPQHjJDMZsGGN4DcnnN4SM2ODaCqT/kJ/VZE7yvR3zhk2fJEFqV9YFGRTqZ+jsnj
 Pgh/W1HeccTmRVlizmn2ItiqkKcXfVUFRASIjGOCbR0SyLm177P2qgIaXEww6aWSnQar
 T5v/4lUFkU6kuCFZ6hk4p9nBXBYb6gEsGdXh01NXvay8YV3v3E29TKauFH/h+FbOOdHd
 GGHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=qri/F8nrhMHPEDYa4uQBt3JEMiHHv9C5/Jmdnno/6TE=;
 b=pZRUILnh2FcjB0gP+pRwgk3rTkJmF23RKveIUol41feIhmTfPy2xKAD9WZLuuirsyQ
 ff3UP41KBfEEGjqQoHThal499QcoB0rNq8pfo2XE1gmQ8RmuChZo0Tsf64tHJaa7M3qr
 eWIO5OAv48ncGoncR2rB7tAj1LqKT0lR2uXzoKwccUBu8WgyLpE0Suyb9Xjc3I/IW/rH
 ag7yKWXbElksy3qIxLyH2/GlDPAts/SUFXNNKoS8Ag+h7f11k9EASUID+9s3tVdmp9Qb
 aYboV9xRUS/oqinSHzLc0C85ot1KsHWC7ARq+ZnHS1r9u0CNx5ZIWkydqSfLb0h+eM/7
 iyfw==
X-Gm-Message-State: AOAM5332kvDHaTAebHIdRy+b7fXqgDJPbMspd3wRnriRmpx04vta1Nq/
 MlASTHD7++jbAKz6Iv3+rVNpoA==
X-Google-Smtp-Source: ABdhPJw8Bn6P+IE+Qzeo9KqPziiJGvYCB1J6tl8vP7MYz520ZFYD+Cv/5edLbN+g+nahR9ZSMbCUMA==
X-Received: by 2002:a17:902:758b:b0:13e:8b1:e49f with SMTP id
 j11-20020a170902758b00b0013e08b1e49fmr53627978pll.6.1636143136683; 
 Fri, 05 Nov 2021 13:12:16 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id a20sm7760762pff.57.2021.11.05.13.12.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 05 Nov 2021 13:12:16 -0700 (PDT)
Date: Fri, 5 Nov 2021 20:12:12 +0000
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/5] KVM: Move wiping of the kvm->vcpus array to common
 code
Message-ID: <YYWQHBwD4nBLo9qi@google.com>
References: <20211105192101.3862492-1-maz@kernel.org>
 <20211105192101.3862492-2-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211105192101.3862492-2-maz@kernel.org>
Cc: Juergen Gross <jgross@suse.com>, Anup Patel <anup.patel@wdc.com>,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Huacai Chen <chenhuacai@kernel.org>,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Nicholas Piggin <npiggin@gmail.com>, Atish Patra <atish.patra@wdc.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@samba.org>, Paolo Bonzini <pbonzini@redhat.com>,
 kernel-team@android.com, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 linuxppc-dev@lists.ozlabs.org, kvmarm@lists.cs.columbia.edu
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

On Fri, Nov 05, 2021, Marc Zyngier wrote:
> All architectures have similar loops iterating over the vcpus,
> freeing one vcpu at a time, and eventually wiping the reference
> off the vcpus array. They are also inconsistently taking
> the kvm->lock mutex when wiping the references from the array.

...

> +void kvm_destroy_vcpus(struct kvm *kvm)
> +{
> +	unsigned int i;
> +	struct kvm_vcpu *vcpu;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm)
> +		kvm_vcpu_destroy(vcpu);
> +
> +	mutex_lock(&kvm->lock);

But why is kvm->lock taken here?  Unless I'm overlooking an arch, everyone calls
this from kvm_arch_destroy_vm(), in which case this is the only remaining reference
to @kvm.  And if there's some magic path for which that's not true, I don't see how
it can possibly be safe to call kvm_vcpu_destroy() without holding kvm->lock, or
how this would guarantee that all vCPUs have actually been destroyed before nullifying
the array.

> +	for (i = 0; i < atomic_read(&kvm->online_vcpus); i++)
> +		kvm->vcpus[i] = NULL;
> +
> +	atomic_set(&kvm->online_vcpus, 0);
> +	mutex_unlock(&kvm->lock);
> +}
> +EXPORT_SYMBOL_GPL(kvm_destroy_vcpus);
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
