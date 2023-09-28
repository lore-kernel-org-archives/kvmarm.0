Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A660118050
	for <kvmarm@lists.linux.dev>; Thu, 28 Sep 2023 21:42:40 +0000 (UTC)
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-49a885c5961so1789452e0c.3
        for <kvmarm@lists.linux.dev>; Thu, 28 Sep 2023 14:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695937359; x=1696542159; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FswnOoOXeEsalatJe5X2/JRhGy21U6wG0hXKt3mgVEk=;
        b=rnwTu05jTTpUUDeAgV3739mAmhAgrBNbmhrW9qeXmupUIEQwWtX8u3OBATdbAfw49P
         LaV3nUO9anfCFWro6278muvEJ6qHKlQj/V/jWZ6gVEtvvBFZnhNj16KexK4BdngVz0zP
         F7NmUsefAeZgUTSszAanzWywNN8jx0RLRE7LXv84LXZkSknm3uYRzqwHPAJsHANDbyy2
         xitDfpocWIeZXF9fSTd8ym/eHQ/Fiz1bhNI2iBDvzeqkVdbCgaDAnIV0D/RR4PgOPFOv
         vprIoVMA4RggC0J2bO+UYRfT75MamDMHarcwFJyv7/54ddurjrQBgXuKfJkLA7Wuhf2J
         Tnvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695937359; x=1696542159;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FswnOoOXeEsalatJe5X2/JRhGy21U6wG0hXKt3mgVEk=;
        b=BudsEbA+1uCKOQJmgsRWMLu8FshocyAaA30y0sPwQybiz8LyWeLNlFh84daB6aDBjA
         wui5N+Znc9r84IG08YP2sbO6qwh0h2Fv77qUA+0pFei2Acv+25TjE1270c4rSt3xOHEr
         pnhPqnSoeKosM/zN/CFFZjLJPozGGydoi5EMTHH74UyxbZWNFIiz4p861yAa5064+o5z
         +spGx/mOn4ym3cK/gxjYkk2cw31qA2nBxQB6SvFH2Xq99sPKm1yQZq5RbsdukudgCs7S
         LAJAQKs1AVLr6bK2kxvQA+0F0gNcwZYYH5qf310NIN8TOoOhpkh444guZdtLYLss9zoq
         NlEw==
X-Gm-Message-State: AOJu0YxEr4LdFeyKRFVHwAZ8M9rifVhYMU+wMZihy4xAbGnTe19VXUED
	WvgBTvr0AsLP9S3Gp8ivd5sxtOFt0woY9IEY+yLQ+Q==
X-Google-Smtp-Source: AGHT+IEgbHvzHg5ZQzfVuJan5OwEQ79HXtsJpgJES78QYXLN3QfZFhxwNpWsNWYVXEpEl0TpdHgTQxr9MlC2w8n4UmU=
X-Received: by 2002:a05:6122:1804:b0:49b:289a:cc3f with SMTP id
 ay4-20020a056122180400b0049b289acc3fmr2269535vkb.3.1695937359233; Thu, 28 Sep
 2023 14:42:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-8-amoorthy@google.com>
In-Reply-To: <20230908222905.1321305-8-amoorthy@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 28 Sep 2023 14:42:03 -0700
Message-ID: <CAF7b7moh_wAQ6SB8ES9=VWDeKbm_MRX40+zEyiN1xs_0hsRO=g@mail.gmail.com>
Subject: Re: [PATCH v5 07/17] KVM: arm64: Annotate -EFAULT from user_mem_abort()
To: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

> +               if (write_fault)
> +                       memory_fault_flags = KVM_MEMORY_FAULT_FLAG_EXEC;
> +               else if (exec_fault)
> +                       memory_fault_flags = KVM_MEMORY_FAULT_FLAG_EXEC;

Ugh I could have sworn I already fixed this, thanks Oliver for bringing it up
