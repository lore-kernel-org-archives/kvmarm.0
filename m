Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E773FD2F1
	for <kvmarm@lists.linux.dev>; Thu, 23 Mar 2023 22:19:22 +0000 (UTC)
Received: by mail-io1-f73.google.com with SMTP id d204-20020a6bb4d5000000b00758cfdd36c3so112342iof.0
        for <kvmarm@lists.linux.dev>; Thu, 23 Mar 2023 15:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679609962;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rxAZ+kxQPGWQc3YGGq+yage7hrM7pnvCTwm028DTm6Y=;
        b=NW0m8Ir4zOOM8A86pYqspbfj+W72uBiCxIRgqtLKK2lWS88B47VXSBzd5ZxD35rL1r
         ItLwIHZzfLaQRMyKX16p0bpW5Rz0RXbuYrnb74e+zXW9S9argS1YyJ0ccjEjQdU9lsKY
         6dlouhnggOah86WzS6fleOtxscdQNumx7N3cZTFtRdLSkpLDPsPN3fF5sjkVvhmMo0UG
         j4ZUvAGUyRWorAQzCkpMduFMSbEokIT5z5J+WmUyUd4i925biPh76p8dSry2h4pVPdhK
         grW8obmsxiqkls9II71+GorlG//Tz45R2nTon96hdQ1q93Ox8z1pCv2ClCSZ3ubRwVNk
         1VCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679609962;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rxAZ+kxQPGWQc3YGGq+yage7hrM7pnvCTwm028DTm6Y=;
        b=0p/C75/2izgKASBVscLo8C9BY05nLl22xndPkMe2OvEI3vvWifV26ZAL2vKpfA8Hxb
         kSki8vayAULt9DEbuhSqAgJC+Z9g9Mc6BHzyqxHKzugas8LUwRaiY7Y3U9FM6ajp7Zoe
         9EV1rsMBlVoxVDoJBpOPEjjpeDMUoObQz9lLz0/fRlEcYRck/Y7hCqsFegKhGpEVEPgi
         4xB2F4ZPZySVEOwhhv3WhYT4hKe9w0SoGzCrEQDFRBNE4BZYv3PPjRxKTeFPe80q1xpy
         G/8ywuriwVHbxxSHzmTwhhVr06F0AlJyCkgErrGyxoWGQ76i5IgpE+oN3OK+pVDtLsWT
         3cvw==
X-Gm-Message-State: AO0yUKXQQD1PTEqWVZ9IM1MwwUfrfbAeAtnv2bCYOo1Y7FVFcVi7yW7Y
	YV/rD0C6f2VG/Fl2D38pfk4ZYWvJc/c0vwCetQ==
X-Google-Smtp-Source: AK7set+7z+U+rkzFtkXD/4bTtoGCn6aSxcDEVTE8Vnn+drCicOJE7RRqBO7O9kzJvihAK7pbF/li/oTAcNNJVadRqw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:4984:b0:406:37fb:43eb with
 SMTP id cv4-20020a056638498400b0040637fb43ebmr5255573jab.1.1679609961976;
 Thu, 23 Mar 2023 15:19:21 -0700 (PDT)
Date: Thu, 23 Mar 2023 22:19:21 +0000
In-Reply-To: <20230313124837.2264882-1-maz@kernel.org> (message from Marc
 Zyngier on Mon, 13 Mar 2023 12:48:18 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntbkkjcdqu.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2 00/19] KVM: arm64: Rework timer offsetting for fun and profit
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, 
	ricarkol@google.com, sveith@amazon.de, reijiw@google.com, joey.gouly@arm.com, 
	dwmw2@infradead.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hello Marc,

I had thought I sent this earlier but our conversation today made me
aware I hadn't.

Marc Zyngier <maz@kernel.org> writes:

> way. Colton reported some other issues with this test, but I cannot
> reproduce them here, making me think this might be related to CNTPOFF
> (but again, I don't have such HW at hand).

I can no longer reproduce any issues on any platform with this version.

Two minor comments:

- I'm not sure you ever addressed my comment from v1 asking if you
   should add CNTPOFF_EL2 to vcpu_sysreg in
   arch/arm64/include/asm/kvm_host.h

- You left the capital O flag in your selftest changes even though it is
   no longer used.

Otherwise,

Reviewed-by: Colton Lewis <coltonlewis@google.com>
