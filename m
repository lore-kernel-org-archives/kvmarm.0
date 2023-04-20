Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D90D946F
	for <kvmarm@lists.linux.dev>; Thu, 20 Apr 2023 23:35:16 +0000 (UTC)
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-2fa47de5b04so1055853f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 20 Apr 2023 16:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682033715; x=1684625715;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NUhrXhh0/hcZCWZDl1Tk2c8ju/E7pQLDIHpl+CKmb0E=;
        b=z7mogAtlJCz5lRBGK5WeqsgYonoKTQLIKI8OQw7l6SdimjW8LQSAJlWm1u+zChKKN5
         1fcooPR2ndBkEVy8Zfj9Rz1fNJunEPiV17AelmC28DrpJBm5S2uDuDuM/HuZLGWdQnp9
         ohWg+eARB6XRg4MBVIpLFiFu0iKfXrlWcYHhSjSTluVaprlO8vNsrf+aZocoFRiTOWyK
         fc5z6lhp9GPzE86BDEGiPCU+xhtikVNnIcNtamkSWQl80LqGAoY0tt3bGYueEUvV968m
         UJhGuixJitGF3NZVKUf4k2udB9lau1Eb5xdZhxLKe119FdTYZjFj2Nujl6wkPfRLYodq
         E8mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682033715; x=1684625715;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NUhrXhh0/hcZCWZDl1Tk2c8ju/E7pQLDIHpl+CKmb0E=;
        b=EyGkjDH3asJS+ypcWXw6V4lu2GBBkrvEBfa616s3p50f3GLlaCIKHVhpaYQY1oN0K/
         m4m6gvbGfKpfxHi9BxYP64RpiQoIPfFkAZP/Ugj1HLy44/nJulJPXPCsPlldACAAFYzQ
         H85PVR8CRMji388PfML+Xuii398SC4P1A3Adq20+leeEuXFoTGXt3qpmt5OLu6p4VLPW
         i64l+KoNdI5AxlnleviX75+zqPWvE1Z2PZriCsRUofjOCKyRAxTh2cX4gkQnonBwh2fI
         ERogVVHu2MQ5QA9CBe+agUYotSXutHkHmyPuPpToNB2pe9YyVDIOu9Q8nOEh/9CqA1TT
         OCtg==
X-Gm-Message-State: AAQBX9fhnjwHMIhER2cIzqE5Bs+T7Xkx4hD3zTbWxIMSJIaFZj1gA44+
	Vm6ipyOJ9tRV16J38cCppphRjrvh5wcgNfn+RQm7lA==
X-Google-Smtp-Source: AKy350bMxv6ZYG/ggLLo0tXGFwNpSPRozJLJLdxCCH5WW00BgzPcFY7p2lb1Y1GF1e11fkY+l7gMXZ8ogyL0lg/eNUg=
X-Received: by 2002:a5d:58f5:0:b0:2f9:896a:7554 with SMTP id
 f21-20020a5d58f5000000b002f9896a7554mr2496862wrd.13.1682033715155; Thu, 20
 Apr 2023 16:35:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-10-amoorthy@google.com>
 <ZEGmWrnqI3SBUW7A@x1n>
In-Reply-To: <ZEGmWrnqI3SBUW7A@x1n>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 20 Apr 2023 16:34:39 -0700
Message-ID: <CAF7b7mq-9yOqCRsJ96dm7NMFMLOYw=Q=Q5gMWukpde9ZqQCAEA@mail.gmail.com>
Subject: Re: [PATCH v3 09/22] KVM: Annotate -EFAULTs from kvm_vcpu_map()
To: Peter Xu <peterx@redhat.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	seanjc@google.com, jthoughton@google.com, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 20, 2023 at 1:53=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> Totally not familiar with nested, just a pure question on whether all the
> kvm_vcpu_map() callers will be prepared to receive this -EFAULT yet?

The return values of this function aren't being changed: I'm just
setting some extra state in the kvm_run_struct in the case where this
function already returns -EFAULT.
