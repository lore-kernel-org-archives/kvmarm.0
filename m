Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D923174D1
	for <kvmarm@lists.linux.dev>; Tue, 20 Jun 2023 21:13:39 +0000 (UTC)
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-78701841ccbso1962727241.2
        for <kvmarm@lists.linux.dev>; Tue, 20 Jun 2023 14:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687295618; x=1689887618;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tDFMiEyTFCNcCofuAvTmueHcfkEsL/r/lI8i21xCuUg=;
        b=sugIGRe+WH7wDcI50HaCXG1NCXcWDoee4nh/MGdjZ1mWd7HS8tAZkkL+zlxjWs1Yk/
         839OAG3n3dx6eHVwoOVLLPL0cdVJhEb7sRjrqK/X4x8FllcEKpBPb2DNjFEwoMUNfoh/
         1AERdyDfiv0/3K9qqebQXxfimXYobaTj8gNr+6xAnpjlQYF2vsc+2Vs3V8Fh4j9M+Iia
         XlNPm02LeR46inXW0xJamYdEiNSwx76RrRiKc4BnQJEHqo5uKAkdeYUTeHRx7SkNWPIx
         OL1QdCxV3gJ5/jDGmvK8Y3J3SkaSyWguoaAOf3NcD9Cf5CpAFd7LsaaMt0VZozpjMORW
         wXrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687295618; x=1689887618;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tDFMiEyTFCNcCofuAvTmueHcfkEsL/r/lI8i21xCuUg=;
        b=EH3d8wl56FbX8zt48lut7yDz7E8nDwAX4pWpHnG6BmIfIkHbyKNtg1M4js+Oblku71
         p/Vx3SyfDBI2CPkuGCLTvO/PCu+WxjPYxgL2M4BV/a9YyHTdgX1h2rdW5dfl8aIicua3
         GOKen6k7apTtiwX5pSC4oTPGuNeBqmcXwOGRIaLxZr00C3t26ZxunTY/VS0GAOEbMML+
         dqNjrKTBHVwA5O38TvLToMhgjwow09DK6xvqkb+S9eygatLWh17O4BX3voUm5A4uSLpq
         zH8yiN/2s2h9aR/hY/tfrxZr+N7AtCiWrOPoWOWESiQLMTcmpGbQzRLJ/78ErqzVIk1C
         DKrw==
X-Gm-Message-State: AC+VfDwMg9qhMNrdzO7dCT4XJH8Yo0tbWcyc4TWLFeKnLvWFR5MJCHIF
	2PkXaL+4qD7zqYdoMxGbdmOvBYX1timbC9xfPF69vQ==
X-Google-Smtp-Source: ACHHUZ7MGyWfvm7Qjk2VFxWWuav74M2wp1KPvukonWJsSS6eyCfFNqh93vnu/OWvy4ITzTlVmjSFtwNQuw/sTKfFkL4=
X-Received: by 2002:a1f:450e:0:b0:471:549e:c1ff with SMTP id
 s14-20020a1f450e000000b00471549ec1ffmr5615772vka.7.1687295617999; Tue, 20 Jun
 2023 14:13:37 -0700 (PDT)
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
Date: Tue, 20 Jun 2023 14:13:02 -0700
Message-ID: <CAF7b7mo-16NERWPF9ZDaX_Ao8DLPuKuQ2f99kbE5WtFf1Nvqxw@mail.gmail.com>
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
To: Sean Christopherson <seanjc@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"

Thanks for all the review Sean: I'm busy with other work at the
moment, so I can't address this all atm. But I should have a chance to
take the feedback and send up a new version before too long :)
