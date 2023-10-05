Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A194343693
	for <kvmarm@lists.linux.dev>; Thu,  5 Oct 2023 23:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CtbXz72I"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3ae388eb437so1368512b6e.0
        for <kvmarm@lists.linux.dev>; Thu, 05 Oct 2023 16:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696550282; x=1697155082; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=44rKSvYUH7JAJmQ5V9S1+ZcFwK9XiGadHatQeMpWa7M=;
        b=CtbXz72Isjv/h/fOeTwSc5WeaQI82HVcQZZEeD40Z4M2uoXo5SwCaasusFnjbgpdGv
         BBZl9c9RGvsIzOSFhg2DW3t6RMiPkCdddM5Yc1k6gP5DF77Rzmzm4pohlPg08W5VxOwa
         bh4N3Dm9WP3sD1cIz1QiMU5usGD6AuY0dchyU53OccIC195d4hUnDwMCSmP/p9D9dFpi
         rjurVN+18iYp+GjQFKHmyGgLgRVOvemsiz4ML6r0vd7q2PJmVJLVEjDK+5FuRa70PUjs
         LYabTxL5spxOjKvAGAISo3RyB+8IKBkeXDTJDaRZjj9iOCv8iwlt7mRRZ8dQecHcc0+C
         8gAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696550282; x=1697155082;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=44rKSvYUH7JAJmQ5V9S1+ZcFwK9XiGadHatQeMpWa7M=;
        b=grkZlhATHrWni7hqumAC+WksAR6wYVqmupy1bcJ7npFmg5OIKq9qDLr4BcAqfuF1kT
         JPEWHXSROTRU+M1v5J+CO2wSFTl/XmINtQVCbEU7VwZ+jHniEOsYPg67cn8SOnvVD5l0
         XkeHjn/oLDh3BPaRrpZ+3+4nv6M+JDZR1L5B7efsY6zeO9STr4vp/87T1Sc5e2E4ulA+
         1dBgs9ivF7c2zAqdESqoMJC3FcymuDzDkBE6dYEJQwgZUI0PnF8dGNF9KZ7pPYBqihOc
         D7Osc84+ixzYq3itE5Uod3Eyzt3imH45YmwK3zTbaMWcTIzVH3YdZLkQNNVFEClvYa2u
         GtYw==
X-Gm-Message-State: AOJu0Yz5q7JBU6M0XttUNrUAiAYJpxJpoKu3M6RiAZv+5yXniVMrnb9T
	nTkMp9CXpjEsZGBMIRuVgNfPl//3zsRoihqHAf8YQw==
X-Google-Smtp-Source: AGHT+IHmJEBw3FEwSKl+ovMIRs4++7rLKFDnnPFE12KkBwrbdRxv2j2rQxvCOnfcPRcXdkpqGTXMw5Ql84/AguKeHyM=
X-Received: by 2002:a05:6808:15a1:b0:3a1:db91:c5ef with SMTP id
 t33-20020a05680815a100b003a1db91c5efmr1811913oiw.23.1696550282493; Thu, 05
 Oct 2023 16:58:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-7-amoorthy@google.com>
 <ZR4Qr4Yzj7nUNIT3@google.com>
In-Reply-To: <ZR4Qr4Yzj7nUNIT3@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 5 Oct 2023 16:57:26 -0700
Message-ID: <CAF7b7mp9VDu3hEFrOys9-9wfS+nKAJX7vcnBYgk_pBZ-NnJE2g@mail.gmail.com>
Subject: Re: [PATCH v5 06/17] KVM: x86: Annotate -EFAULTs from kvm_handle_error_pfn()
To: Sean Christopherson <seanjc@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 4, 2023 at 6:26=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> ...isn't helpful because it doesn't provide any
> insight into the actual impact of the change, i.e. requires the reader to=
 already
> know exactly how and when kvm_handle_error_pfn() is used.

Ah, true. Hopefully the following is better?

> KVM: x86: Annotate hva->hpa translation failures in stage-2 fault path
>
> Set up a KVM_EXIT_MEMORY_FAULT in cases where the stage-2 fault exit
> handler successfully translates a GPA to an HVA, but fails to translate
> the HVA to an HPA via GUP. This provides information to userspace which i=
t
> could potentially use, for instance to resolve the failure.

Maybe the "via GUP" isn't really doing anything there
