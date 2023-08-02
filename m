Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2D812B84
	for <kvmarm@lists.linux.dev>; Wed,  2 Aug 2023 22:13:27 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1bba5563cd6so4906675ad.3
        for <kvmarm@lists.linux.dev>; Wed, 02 Aug 2023 15:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691014407; x=1691619207;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oNrunTw9g/scAXlACL1Yy6BuHYu8UXiywBffDHO0ySM=;
        b=oRnUg49TyqQtCpG9mB1+Zt8T8V0fo6eI5r3czuLbiC4L4rdWaAvVrHBVtqTeJ90E9Y
         B5mZ5FxEswdpGVKmbD8pwI9bFz4V/mbheFZjzkgcOl/c5u2L4vsnneSqeIgWAP8/lQI3
         K34qOuv/PzRLXUwq2elOGYB7F92GhrDe+DtfEWHBkMakUjcspHZ8f6JEMNK1zQ9wuHBz
         e1B2WnP1p9aoj/wxzD9TsVHQB621qb0zo19xWV98Sv2YUL8E4eyA30M5eo4U916dAc/p
         X3aJpDamXtAC63JzSAXYnBsVQdUH92Yy4Se4/Lf7hhcWQoOgRWe+WrTk8vAfPtRpUjwE
         +ONw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691014407; x=1691619207;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oNrunTw9g/scAXlACL1Yy6BuHYu8UXiywBffDHO0ySM=;
        b=lUZvoBauMhqmApWjFbD1kXYopDM9wX2ljoO9m3gC3K34IiSZZzZtCz/AvpwvCawHAc
         eNuxnai+0QRpUFiCo+8oQy6w7leCRCRLdh1NMuDQz3vT/1mdF0KZvr2bweJEdr70wZ+A
         za1Z89q6OjhlSDQ0/VX4HyT9MKyltakcORt4ar4jM2cdBSJv4cj8aLtKMbcViHAXbGmI
         c8z2GStnSkWos0OUHatUtyjcHGVtCrb6Pgra5bkym61IvEYq5Om0oAXAQLawAZ8WcUfX
         FYNjJ3nBW8DtIfDO/yhfii67FwDZo2NDZKsEwZ3sE3knDDn6D7Q1jGO32+ZMnVAawhFP
         wksA==
X-Gm-Message-State: ABy/qLZ1cJEtSMlIEIdxvwNwY5KZAUAFaVPTaZI8k46/f9Ye+3z6e66S
	48C+tSG9/suKLnF2RCOstZJ2yntUkJ0=
X-Google-Smtp-Source: APBJJlHYYJG7D9hZiA9amsdCWObbBIYwdulg2VqDtGhU7hg3L7bAfjSx7kf9waosJHPo/esHNLPSDeRdLuI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e5c1:b0:1b7:edcd:8dcf with SMTP id
 u1-20020a170902e5c100b001b7edcd8dcfmr104418plf.4.1691014406820; Wed, 02 Aug
 2023 15:13:26 -0700 (PDT)
Date: Wed, 2 Aug 2023 15:13:25 -0700
In-Reply-To: <20230726044652.2169513-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230726044652.2169513-1-jingzhangos@google.com>
Message-ID: <ZMrVBWg+c3PSUilR@google.com>
Subject: Re: [PATCH v1] KVM: arm64: selftests: Test pointer authentication
 support in KVM guest
From: Sean Christopherson <seanjc@google.com>
To: Jing Zhang <jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 25, 2023, Jing Zhang wrote:
> Add a selftest to verify the support for pointer authentication in KVM
> guest.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>

...

> +	/* Shouldn't be here unless the pac_corruptor didn't do its work */
> +	GUEST_SYNC(FAIL);

FYI, I'm fast tracking guest printf support along with a pile of GUEST_ASSERT()
changes through kvm-x86/selftests[*].  At a glance, this test can probably use
e.g. GUEST_FAIL() to make things easier to debug.

[*] https://lore.kernel.org/all/20230729003643.1053367-1-seanjc@google.com
