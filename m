Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4951D5385
	for <kvmarm@lists.linux.dev>; Fri,  7 Jul 2023 17:42:08 +0000 (UTC)
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-47e3c76fe7fso822458e0c.0
        for <kvmarm@lists.linux.dev>; Fri, 07 Jul 2023 10:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688751728; x=1691343728;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oBBp97IJ5nf9KBuNgeMGVGX8CSgQfVZqr3i4Yqkacbo=;
        b=rvoMu04yLOtNn/6CESJMOwME8Dcw0O2f3UjvEt1QsTZR69RYWgX+107drg4dSddzE5
         R9NYxGUvfHtSD3LvqyKD3Q1WtTslVUrYbyzJgE8zPDNYSkfTpmzXoW6fYnjcs/al257o
         ERNToZPrBrGcmFSDM2nfSjb8xMdzP1WWpSO7APhWexpgJgwm+kFQChIEHYWvZ7UErRa9
         zuQ7Vf1GlPThmLhdpR/uC9fQvOS2HPgPbcw6MoQoamDYucy3KP+NocgPmRrQVInqAnE6
         +uLy3aw+o+IORLqS9uR1b9n4wPZ1+uYloLAJYTDziIkw3zU6BcnTNdfrYnB2Z9gEy5uS
         WaqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688751728; x=1691343728;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oBBp97IJ5nf9KBuNgeMGVGX8CSgQfVZqr3i4Yqkacbo=;
        b=XjRXpNpcVf8kdc+f+M+TpkD1FQGVkCOByyoGvfjeP6A85P9ZTRIh1FntFs0bDMDtRd
         bS5nJAyiYKu5Kkc2m/G1JCKZojGxW2OdsWOgqDWamyKLjcJEG59k/icP2pWMwFZTjFA9
         ocHDG81GcPScoq6JCVhshp7P3A3RURPxFQ8/Dy1QrFXuswU2FVoaKBF7ssqH5LGz7gND
         0x9u6EGxS+mbrZ9pCL98jc3xWAiao92FN2ISBhoX/FF6nepfcYA5PeFKzwFnfruPno3x
         fqpNjzuqpHI9d8BmgSuda+ySJnOuyVTNltGozRN9k1fXLKtvXrE0CETj/mpDcEx2tDCF
         W5pw==
X-Gm-Message-State: ABy/qLZkH9N8yAe73fnXfpAg9b2cB04TaVE+z3kMtlUNSueqQlHU2JI2
	YQiCU0Dner8QATg5j90f4y2X+itg/Qnkzb3PEr+UGA==
X-Google-Smtp-Source: APBJJlEOPbOEinA2SbMLKyZ96JinCbahFvj1DWsVPsF/X3Lnt5roeqZ6dujCD1qkpYtzYrJjnccgel0Rjm1nQj8eAtY=
X-Received: by 2002:a1f:c151:0:b0:47e:677a:e7fc with SMTP id
 r78-20020a1fc151000000b0047e677ae7fcmr3907044vkf.6.1688751727821; Fri, 07 Jul
 2023 10:42:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-11-amoorthy@google.com>
 <ZIoiLGotFsDDvRN3@google.com>
In-Reply-To: <ZIoiLGotFsDDvRN3@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Fri, 7 Jul 2023 10:41:32 -0700
Message-ID: <CAF7b7mpisSor9uYz4oT9b4oLpmrNL1ZEqFGQhrFgSFeeVK7VuQ@mail.gmail.com>
Subject: Re: [PATCH v4 10/16] KVM: x86: Implement KVM_CAP_NOWAIT_ON_FAULT
To: Sean Christopherson <seanjc@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 14, 2023 at 1:25=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> > -static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fa=
ult *fault)
> > +static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu,
> > +                          struct kvm_page_fault *fault,
> > +                          bool nowait)
>
> More booleans!?  Just say no!  And in this case, there's no reason to pas=
s in a
> flag, just handle this entirely in __kvm_faultin_pfn().

Ah, thanks: that extra parameter is a holdover from forever ago where
"nowait" was a special thing that was read by handle_error_pfn(). Done.
