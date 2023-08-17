Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51405F9D5
	for <kvmarm@lists.linux.dev>; Thu, 17 Aug 2023 22:56:35 +0000 (UTC)
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-48c3033dd5dso102083e0c.1
        for <kvmarm@lists.linux.dev>; Thu, 17 Aug 2023 15:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692312994; x=1692917794;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BSLdEl6y6GOOfZPMbAm1X61Kn+8pfMiX9JSO1SZgo7o=;
        b=5NoykWtFZs/nE4I3lBUnYiw8vG/Lxi4lpTCwIXP9Vd9/i771DnYRDS2os0ZNipnaWb
         J/bV+lTxxD5zZ0tcihzv2ldNIqhf7I8rkyG8vB/xIdERHohsp4qlpS3Zg4OulgeAOkUY
         H1k4LA6D5Ik210rfMxa+bS/Ra9Wb2m81pwx1XoDYnPe0eMiF/Lvc4Y3PQl5OYEgEPkQp
         uNItNwqxL0QwwI0yS9YInv5XwOICS6srvCZH9HM1clWul02Rn0Dm7NkMQrnw8s1LW4d6
         HP9hdSNEuitv717sxOba6a4ZvRRH/74xm+2YPwWIHhAORW6Fdpspo69HaUCS21Hbf+9P
         kxzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692312994; x=1692917794;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BSLdEl6y6GOOfZPMbAm1X61Kn+8pfMiX9JSO1SZgo7o=;
        b=LUBxCd8vj9GL6MiSlFXaHLDX5OpR1VCSiETzIY6zO7bPlcSiifQhrNLOOxMvWC5NpQ
         y3ibH3CxC7NdsK58dvYowjBmJVwwIqL9RLCYqIjr+ilW8/xk2o81LkhetbdtAXZQcpWP
         eXDLy9Byx2MDcSC/HWzF5pYTgXSp/epRZEulx2vfnVKf5x5PSVM/euYd+zICRRJuvksk
         l+CQzuhhm9FFIQ7XuBnVqnlII7P2faYyQCNp21DEaXp2ZUztOqzeLvgeegGag4Qlbt3v
         GEAL1FkSxXpuLG4pm74RbqmMmNbAW1tvFbampG4U4yJtZXwDaxdM0JOtszuVPCdti3lH
         Ar+A==
X-Gm-Message-State: AOJu0Yx9a1uRLEvVXm0bc6L119Z+7hBgO/2cxV19y3weqNuNi0TktfVD
	KrLZfCDr0iiKmPWgFZCMqsBtOvTcaY2wCSpMN7srrQ==
X-Google-Smtp-Source: AGHT+IGkWl3rmU94+T9hxKzfbEmuqRQAzMVxf+uGv14pXl2VnZW9ME0ok1IGyiWl2bNae6I1GG4wPagS3SshCxRT+nY=
X-Received: by 2002:a1f:5f05:0:b0:487:1774:405e with SMTP id
 t5-20020a1f5f05000000b004871774405emr1366806vkb.11.1692312993986; Thu, 17 Aug
 2023 15:56:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-4-amoorthy@google.com>
 <ZIn6VQSebTRN1jtX@google.com>
In-Reply-To: <ZIn6VQSebTRN1jtX@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 17 Aug 2023 15:55:58 -0700
Message-ID: <CAF7b7mrDt6sPQiTenSiqTOHORo1TSPhjSC-tt8fJtuq55B86kg@mail.gmail.com>
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Documentation update for KVM_CAP_MEMORY_FAULT_INFO

> KVM_CAP_MEMORY_FAULT_INFO
> -------------------------------------------

Old:
> -The presence of this capability indicates that KVM_RUN may annotate EFAU=
LTs
> -returned by KVM_RUN in response to failed vCPU guest memory accesses whi=
ch
> -userspace may be able to resolve.

New:
> +The presence of this capability indicates that KVM_RUN may fill
> +kvm_run.memory_fault in response to failed guest memory accesses in a vC=
PU
> +context.

On Wed, Jun 14, 2023 at 10:35=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> (B) is the trickiest to defend against in the kernel, but as I mentioned =
in earlier
> versions of this series, userspace needs to guard against a vCPU getting =
stuck in
> an infinite fault anyways, so I'm not _that_ concerned with figuring out =
a way to
> address this in the kernel.  KVM's documentation should strongly encourag=
e userspace
> to take action if KVM repeatedly exits with the same info over and over, =
but beyond
> that I think anything else is nice to have, not mandatory.

In response to that, I've added the following bit as well:

+Note: Userspaces which attempt to resolve memory faults so that they can r=
etry
+KVM_RUN are encouraged to guard against repeatedly receiving the same
+error/annotated fault.
