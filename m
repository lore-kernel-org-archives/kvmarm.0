Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3773736AFE
	for <kvmarm@lists.linux.dev>; Thu,  9 Nov 2023 21:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OVC2z8bk"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-587b1231dbeso706478eaf.3
        for <kvmarm@lists.linux.dev>; Thu, 09 Nov 2023 13:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699564101; x=1700168901; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WwzUvezY0TT5a+4rjK2kfgmTX3xfdRUs3hXfF4JhRg8=;
        b=OVC2z8bkD2wyzq5En2pg6z80uqc7zynQYxsXJRPev+YVvLyQ6XQ310wND3f1gs22SF
         kEWX4G7320Cdgstc58MJKriETSd437jcr6mG2+HudNeqwXRMHSvU4UWSYEujn2m+rgLF
         B5MRoye4MFZdwmHMxWaaabTROQh21wn7sACMWPqSm1MJZQUwlVNvY+Io8fl4d5Ps9V0l
         KnwE73gyQPs/LrMlWIhAOO7TVqjqdGvT3xoyuO5MuzgJtLhsMbshG9ayzTkUofn01uLw
         Ky4UBVgKiBfsPaf1XYeEtiafZr6j1Qb12uJtmdix9cxJoDaxLwp7vIHT2Icbv+sigEhr
         d7CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699564101; x=1700168901;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WwzUvezY0TT5a+4rjK2kfgmTX3xfdRUs3hXfF4JhRg8=;
        b=o4aseNr/qDT7Zl+cXARIwqX7Wc8dSP9jBz3vo37dYhavyK4yVyTGCDPgzT97vO5FEG
         /1BZjpPBFwBSOz7eF/cp2Hz+7jyGEhThliCWKNYijpH11ZJpyPFp4b9wYfJOIopWwhU5
         ZI2NN6EJq3DiSyi/a63M72aN3Ppa+jw9N1dTV3BYGI1Qy0BA3GvKQw7n0u2GN5xC8Xt9
         fxFCbXePS9pwLt4Xow05qDhs4htKyO71bbWGcWq4syuarziSwmpIio6MzoidXrn2NoSH
         TlzwW5NfxmlSDc2dNhnW0SnRq28vVj+D/O1sh4V/y9N0okWTe9sLVCLzGDcrZt3IWJO+
         8iWg==
X-Gm-Message-State: AOJu0YyWJSDLYNwtAGEHwYISQjKd/9iCJOhAMkOIt6X1E6xdoYKcG3c1
	EIe6yaT36FmptLaXhPVsC9TTWA3ucQPoCMAzpXyBgw==
X-Google-Smtp-Source: AGHT+IFAQMNWwb3nRd/a34yxC1D05fbG/9Rr4JjxxNKqar/u/WETqb6q0Ou2d8oD2pLa9W+efKiwGneqNA5DFdUuVyI=
X-Received: by 2002:a4a:c68d:0:b0:571:aceb:26c8 with SMTP id
 m13-20020a4ac68d000000b00571aceb26c8mr5973766ooq.3.1699564101067; Thu, 09 Nov
 2023 13:08:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-9-amoorthy@google.com>
In-Reply-To: <20231109210325.3806151-9-amoorthy@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 9 Nov 2023 13:07:45 -0800
Message-ID: <CAF7b7mqDN97OM7kgS--KsDygokUHd=wiZjYPVz3yk7UB0jF_6w@mail.gmail.com>
Subject: Re: [PATCH v6 08/14] KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO
To: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, dmatlack@google.com, 
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com, 
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 9, 2023 at 1:03=E2=80=AFPM Anish Moorthy <amoorthy@google.com> =
wrote:
>
> TODO: Changelog -- and possibly just merge into the "god" arm commit?

*Facepalm*

Well as you can tell, I wasn't sure if there was anything to actually
put in the long-form log. Lmk if you have suggestions
