Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979516AAD
	for <kvmarm@lists.linux.dev>; Tue,  1 Aug 2023 09:22:10 +0000 (UTC)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-99bed101b70so659535466b.3
        for <kvmarm@lists.linux.dev>; Tue, 01 Aug 2023 02:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690881728; x=1691486528;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Myyg/9EMvFaXxS0MQuf9oic0JS5pwyGRhUlLiVOQ7cg=;
        b=DGWQ06MMOa/673UDiUbHWfvDEjjljcO9pgXIH6f6q3vLvc/6vEnY+ydAuN/HHflZw7
         AEtTWAMYn2GMKYtLMtMn0sNzJhSMyTGc72izAJnHuEBYp/kviEPOsfYW3tBXsZLz1PSf
         nBrWKS8QWxWdlC0S2oc2b2Naf7e+9rX/TpPlLu7KyDtKBI9F9Zrx84HkFyoZTBPXk8MP
         Jvt8JbrfF2AGM7+dLEe7fEc5iLz5MqPpWIp8f/uPfCunfiL1nnGJHq3jtELhLSbKLAGm
         mh24x/4jIeOLx+JlPwlkhpN6AUwtg2z4cOQAKda5EfZUA7TbLlBc8zPbXNEKZ6KENpoz
         nQIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690881728; x=1691486528;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Myyg/9EMvFaXxS0MQuf9oic0JS5pwyGRhUlLiVOQ7cg=;
        b=GQIYYedn/DLDvbLs6U6UtfDIfE3QNKJEhvMOlhtyg1btn3GV51oWtlpWioaKoRW4uu
         i3P06IFNL+PIvkH2pxXK1xeqya8FQN16891YuahTvfQ6KPPZwp3OfTsvMaOGIz0QN/di
         EglERjWdCBdj1uPHG49tt4dRHAud3xrI9fvyct9zLsd3zuhhiKoa9HGX1R6hyeb3dCOX
         tw8gPeRpYdDGyO4Xy6XAidpWPkcerst1xg9Fmg5Dftk68n+7Bq+8BzXJ3XSsgaP1T8G9
         jDfm0ejN8Eq6DYiyn5RNIkUwYasG8S0PkGf6GvNn+Q4XuDSQUbmf9vs1JQ39U8elHMxV
         kBZA==
X-Gm-Message-State: ABy/qLZOPIwqtRYiTd/DqsXrM+DAmbB9mYkrmVKofjQPdbD5et4vQO3o
	qdplY9fgWFFbmqGg0Wm8JMQrUA==
X-Google-Smtp-Source: APBJJlGm6uA+LAnVlBtxIfLwMvjWRv2Gwia6HLAVmhzKy7IakWIq/kLqxEYhBEJoOBpXfLEql9cNOA==
X-Received: by 2002:a17:906:768d:b0:993:e691:6dd5 with SMTP id o13-20020a170906768d00b00993e6916dd5mr1914773ejm.7.1690881728816;
        Tue, 01 Aug 2023 02:22:08 -0700 (PDT)
Received: from localhost (212-5-140-29.ip.btc-net.bg. [212.5.140.29])
        by smtp.gmail.com with ESMTPSA id x20-20020a1709065ad400b00988be3c1d87sm7375676ejs.116.2023.08.01.02.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 02:22:08 -0700 (PDT)
Date: Tue, 1 Aug 2023 11:22:07 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH v4.1 2/3] KVM: selftests: Add #define of expected KVM
 exit reason for ucall
Message-ID: <20230801-121c649de93d2bcd54af14c4@orel>
References: <20230731203026.1192091-1-seanjc@google.com>
 <20230731203026.1192091-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230731203026.1192091-3-seanjc@google.com>

On Mon, Jul 31, 2023 at 01:30:25PM -0700, Sean Christopherson wrote:
> Define the expected architecture specific exit reason for a successful
> ucall so that common tests can assert that a ucall occurred without the
> test needing to implement arch specific code.
> 
> Suggested-by: Andrew Jones <ajones@ventanamicro.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/include/aarch64/ucall.h | 2 ++
>  tools/testing/selftests/kvm/include/riscv/ucall.h   | 2 ++
>  tools/testing/selftests/kvm/include/s390x/ucall.h   | 2 ++
>  tools/testing/selftests/kvm/include/x86_64/ucall.h  | 2 ++
>  4 files changed, 8 insertions(+)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
