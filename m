Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986F0AD5E
	for <kvmarm@lists.linux.dev>; Thu,  6 Jul 2023 19:04:45 +0000 (UTC)
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-47e793ccdc7so357792e0c.1
        for <kvmarm@lists.linux.dev>; Thu, 06 Jul 2023 12:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688670284; x=1691262284;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ejQxY0gWH3zIY/UVUkHiDbx8Hs4+1qvPA8odOTbAhUs=;
        b=7XZ7FazyxzXXGNwmDQ66lbyJBkc7F7mTRjSFc4ql0j0u4dofBp4+Knh44SKAdeQK+O
         HE4YEWzI+XUsCL0lymnfhsm8WC9LOF38rldSlHwAHh8H2WlCPcV3uqJf505L30Vzk3AS
         BzwsCmodLH2V2pNq3y7y5elIWWWd1EpLyOxOGaWvSjmmKUMfpuXCoCquCy0jh5DInA5O
         8ct2eaxAR4WE9e5LmGST0io7yUaQrSn696n8KRnA7DU/WvjopJC1NvjrJL++O5VsqlQR
         ag7xZUUkQ7gPT062iaU07dlVrqmZgAvDDxqBjEATJgae55R/txRC1HvjJqZVG8yyZCfE
         IWlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688670284; x=1691262284;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ejQxY0gWH3zIY/UVUkHiDbx8Hs4+1qvPA8odOTbAhUs=;
        b=cNQzqLCKjrbBLjBtpFBLg/XWybv7ZXpO5xn2OkdT97O5LOIDLB9ZCpL9HD4hFUGcmH
         UzmZgH5R1HvJo3VOxhVVA7f4Avvl+sjBvltpfBkAAqQuQnnetlb09uMOq21ZouMi/Tha
         GdeX8SRMcPi9YqAoE8MTgeAJj0S4mQW264xLasoMIerkXclUWZeYPhAN6Bir3ravEe+L
         U7itWMUXrAkEdVt6rGbbyY2sbZC31JQ9mlTfq7fWFT/D2ExAY/LAS2vrvKk9AXVKwWRa
         m37ZIRkZZ3YCB2+LdNY00UZy3yyvhDhRk7vb9KuN/1G/8Y8JOt1fVNQqBkJreb/RDPvb
         t5YQ==
X-Gm-Message-State: ABy/qLaAgKTLyIGIs7/Mxl3He0aiIjRjBrgn7wSUAsnw4e9XFYLfIXDh
	hW61yVXL+9nKVFag+bnMYq9P7dbBF8xh/V3hu19GAQ==
X-Google-Smtp-Source: APBJJlE1uw1F7+lvu3Gx3wT/tlHa7wgJQDuaTcAPq6lhudst+4AdTOHOlOjHF4NxQYpl1/xX4JloeueaBAkjNe8iwLQ=
X-Received: by 2002:a1f:3d11:0:b0:471:875d:598e with SMTP id
 k17-20020a1f3d11000000b00471875d598emr1867792vka.14.1688670284274; Thu, 06
 Jul 2023 12:04:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-10-amoorthy@google.com>
 <ZIoe3o7JtultNWqR@google.com>
In-Reply-To: <ZIoe3o7JtultNWqR@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 6 Jul 2023 12:04:08 -0700
Message-ID: <CAF7b7mprEauG_P5KL3_-N3Bu58h0gdp3ZXSEU0EKyLmO+4N5xw@mail.gmail.com>
Subject: Re: [PATCH v4 09/16] KVM: Introduce KVM_CAP_NOWAIT_ON_FAULT without implementation
To: Sean Christopherson <seanjc@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"

> Rather than force architectures to add the extension, probably better to use a
>
>         config HAVE_KVM_NOWAIT_ON_FAULT
>                bool
>
> and select that from arch Kconfigs.  That way the enumeration can be done in
> common code, and then this can be computed at compile time doesn't need to do a
> rather weird invocation of kvm_dev_ioctl() with KVM_CHECK_EXTENSION.

Done. If I'm reading this correctly you also want me to move the logic
for checking the cap out of the arch-specific
kvm_vm_ioctl_check_extension() and into
kvm_vm_ioctl_check_extension_generic(), which I've done too.
