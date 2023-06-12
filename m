Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3204E8828
	for <kvmarm@lists.linux.dev>; Mon, 12 Jun 2023 09:20:23 +0000 (UTC)
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-3f7359a3b78so80265e9.0
        for <kvmarm@lists.linux.dev>; Mon, 12 Jun 2023 02:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686561622; x=1689153622;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=otJCdOhglUPqvCsRPiFCc48HcC5AAnpHmKD+QmYUjHs=;
        b=Dyg6HMndIPLYMWfoGxl7n7NRxVRskxhBZOR6fEyrFNYbBgYFaP4qntq25Vrz9J2cft
         zO+O4s577L+Coq4d1iky56D+LQ8F2yx6JBs25J17shPG3TcVaPhkEcCvT538duQbaOEY
         Z0Iva64KK+4dPO0/ILD3vUYguScD+An4uEzXhZN7n6oAa0FVMIRmzVR4oTMD5VMKxzWR
         FpsgzwcnpUWmZZGs0vBNVmdbIQ9ZFIq4PUHBvbwnmreK9YsSb9jjUDMYwrdEWDp3lBgV
         NT8J81CPtLdpY7RyfOJpBDMIwKj/Vgt6r1t6rN4SAddonIJk8brpu5UF4FVUoDX06gJm
         F8Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686561622; x=1689153622;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=otJCdOhglUPqvCsRPiFCc48HcC5AAnpHmKD+QmYUjHs=;
        b=iF5oou6Q61v7T2gml7MJxPQRxj8DQFWsEpx9V27iqsV/89ypu8xVzjVjqq2U1QygHA
         4Y9YKyCE4ALefOXZsYzzRAqtBJjDCPTN3l3MqPd62IjQ/fssz7qHzgM/tM21JtJBbM7z
         w1lWchjQvkqwcOwqPd8D/Plqc2v5veqNCW6CD8nYkC3zRk4UNbN2iyPFJv0FythpqGzl
         Ev1HHSdImFYZ5b9j7VaEsgDDHkWZbAkPENmOCXjadfTAcBRK/VEPw+9OXIk6Sn/K5Rnj
         IQR5fWINs/q9qItL1IHoppVInwNh7Lj2jPOtfcqrJfnU1zA9L7k31FyrE+ACMyTbfAXu
         HI9Q==
X-Gm-Message-State: AC+VfDw3iWC8xcs9fX0IN7Wtc5zIBOJii65MnhJ1ZwDe0Hl8PmL0A8rm
	DL3r7RXl41iaVjDezWc3dhb5Pg==
X-Google-Smtp-Source: ACHHUZ4mNCOxZlSL9PDghMOkP1a2TYFkupsco7D0NYsOtKN5IjO/YfGXsn81zyhwoYWot+Qg5iB49g==
X-Received: by 2002:a05:600c:3d86:b0:3f7:e463:a0d6 with SMTP id bi6-20020a05600c3d8600b003f7e463a0d6mr326701wmb.0.1686561622064;
        Mon, 12 Jun 2023 02:20:22 -0700 (PDT)
Received: from google.com (44.232.78.34.bc.googleusercontent.com. [34.78.232.44])
        by smtp.gmail.com with ESMTPSA id x2-20020adfec02000000b002ffbf2213d4sm11974482wrn.75.2023.06.12.02.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 02:20:21 -0700 (PDT)
Date: Mon, 12 Jun 2023 09:20:16 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Will Deacon <will@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, maz@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, tabba@google.com,
	kaleshsingh@google.com, catalin.marinas@arm.com,
	yuzenghui@huawei.com, suzuki.poulose@arm.com, james.morse@arm.com
Subject: Re: [PATCH] KVM: arm64: Use different pointer authentication keys
 for pKVM
Message-ID: <ZIbjULC2p5aTZu8w@google.com>
References: <20230516141531.791492-1-smostafa@google.com>
 <ZHEa+HAixbYijQTA@linux.dev>
 <ZHSJ38WATzgJF7SR@google.com>
 <20230608215525.GA2742@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608215525.GA2742@willie-the-truck>

On Thu, Jun 08, 2023 at 10:55:26PM +0100, Will Deacon wrote:
> On Mon, May 29, 2023 at 11:17:51AM +0000, Mostafa Saleh wrote:
> > On Fri, May 26, 2023 at 08:47:52PM +0000, Oliver Upton wrote:
> > > On Tue, May 16, 2023 at 02:15:31PM +0000, Mostafa Saleh wrote:
> > > > When the kernel is compiled with CONFIG_ARM64_PTR_AUTH_KERNEL, it
> > > > uses Armv8.3-Pauth for return address protection for the kernel code
> > > > including nvhe code in EL2.
> > > > 
> > > > Same keys are used in both kernel(EL1) and nvhe code(EL2), this is
> > > > fine for nvhe but not when running in protected mode(pKVM) as the host
> > > > can't be trusted.
> > > 
> > > But we trust it enough to hand pKVM a fresh set of keys before firing
> > > off? I understand there is some degree of initialization required to get
> > > pKVM off the ground, but I question in this case if key handoff is
> > > strictly necessary.
> > >
> > > There are potentially other sources of random directly available at EL2,
> > > such as the SMCCC TRNG ABI or FEAT_RNG. Should pKVM prefer one of these
> > > random implementations and only fall back to host-provided keys if
> > > absolutely necessary?
> > > 
> > According to my understanding, the kernel is still completely trusted at
> > this point (it sets the initial page table for the hypervisor), so I
> > believe it should be fine to trust it for ptrauth keys. However, I agree,
> > it would be better if the hypervisor can get its own keys through
> > firmware/hardware if supported. I will add this in V2.
> 
> I appreciate the sentiment, but I think we should avoid adding additional
> complexity here if it adds no security benefit. If nothing else, it adds
> pointless overhead, but beyond that it gives the false illusion of a
> security boundary.
> 
> Prior to deprivilege, the kernel can write to the hypervisor text, modify
> its stage-1 page-table and change its data values. I think the pointer
> auth keys are the least of our worries if it's compromised...

Thanks a lot Will for explaining this.

Oliver, what do you think for V2, about it including FEAT_RNG/TRNG in EL2?

Thanks,
Mostafa
