Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882B62EC11
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 20:11:13 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-bc97822915aso1427470276.1
        for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 13:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686773472; x=1689365472;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EcvsZOKJkqQx6/PFs9sH9n3WmNQKe57hd91ilzy0zfs=;
        b=C0pYCOUjrXEmValighI9SSwooagzRgRdEtdKIvgeQuUKWhp1bHs0AoAH2Np6I/eD2M
         MRwU1qw+zNEGspqo1Cq2DqZS/yxmFAzTvcBVjAkDLZsdg10ois3bMBqWQEjqjtBKaR3d
         uwPl/uQch9m/RpQ5NNriyRW2tkS3ByHC+H6vxz5q17tlBSO/9Vyl5+NBmfpERKVtD8IH
         S1OfgglEqgkRIQXYcHMZwx/zOqCzt9t+8MLRXtEKY6bIB/3bZPFsWfPwPkWNcQcJ7/fB
         gfPhud8gmHrUD7K62wzahhEmJ4f1lOpCwG0D+XhW7uBXR3STyEoJFuZW12XUvMF4iHSM
         yX2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686773472; x=1689365472;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EcvsZOKJkqQx6/PFs9sH9n3WmNQKe57hd91ilzy0zfs=;
        b=i7o10IHXibnpDH0VBVeIaXXSmKlQHPK/eA70WaGMMDpCBfeA3Kjjp9LalJl1CRPWj4
         U0OACyvLvBoV02puUTPTSB66qN3dAbSzQoIaClFyWbZ/abY/WFQh8SwVURpv8N2hJyXD
         GYOabZ8oskXTS+RE0ZCqfadvg+rBEpfxoUzlUkb/P1dRO2erRZR2CSKr2TbT7QDq7u5/
         /cHnxlBnCIIk12Tcs4+Bcgy9d1zxAcZLOmf2ZyvzMcdC7XVXK7U4lZTon9gxnLibYUwM
         dR6fklHMtDVD/loJvt+Y0mB64mQSdWTucS7uRnCb+zIBnAP+BhcHSJCDeo2AAHXgpas3
         L0Sw==
X-Gm-Message-State: AC+VfDw14dNm57aLgmejCeMufPtmaO+Nq/cEkvJB8B+swhCjhMmCvwXj
	WmMpAiSdf5XWPlxGO6WeeIRO2tZuVSM=
X-Google-Smtp-Source: ACHHUZ7bu8PhJlTXQ7djoUpQtUhWj2+OGlZcFl96vkCkx++1uwGk7QlpqFMzQSmVUNbJky914t7dsBBZyPg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e657:0:b0:bbb:8c13:ce26 with SMTP id
 d84-20020a25e657000000b00bbb8c13ce26mr1429852ybh.11.1686773472330; Wed, 14
 Jun 2023 13:11:12 -0700 (PDT)
Date: Wed, 14 Jun 2023 13:11:10 -0700
In-Reply-To: <20230602161921.208564-10-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-10-amoorthy@google.com>
Message-ID: <ZIoe3o7JtultNWqR@google.com>
Subject: Re: [PATCH v4 09/16] KVM: Introduce KVM_CAP_NOWAIT_ON_FAULT without implementation
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 02, 2023, Anish Moorthy wrote:
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 05d6e7e3994d..2c276d4d0821 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1527,6 +1527,9 @@ static int check_memory_region_flags(const struct kvm_userspace_memory_region *m
>  	valid_flags |= KVM_MEM_READONLY;
>  #endif
>  
> +	if (kvm_vm_ioctl_check_extension(NULL, KVM_CAP_NOWAIT_ON_FAULT))

Rather than force architectures to add the extension, probably better to use a

	config HAVE_KVM_NOWAIT_ON_FAULT
	       bool

and select that from arch Kconfigs.  That way the enumeration can be done in
common code, and then this can be computed at compile time doesn't need to do a
rather weird invocation of kvm_dev_ioctl() with KVM_CHECK_EXTENSION.

FWIW, you should be able to do 

	if (IS_ENABLED(CONFIG_HAVE_KVM_NOWAIT_ON_FAULT))

and avoid more #ifdefs.
