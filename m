Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DC02F39
	for <kvmarm@lists.linux.dev>; Tue,  8 Nov 2022 05:36:53 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id l2so13193948pld.13
        for <kvmarm@lists.linux.dev>; Mon, 07 Nov 2022 21:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BySxdp/7FbkyS9rQ/+SYkYHjIbHSrwzWviAFRY2ZPdQ=;
        b=jlgow3Yb6SgeKXBbO3czTUh+xNvvjFHf5z9ViSJ61Te93gNnScVTxpPdHdT0l7k62F
         lMrHOG03BfSjw2UfLzDRH+RXS0WR4VTQobaYGOSlEeJAzgE29G9Fs3PTFtSoRNJ2lsDP
         rp0PpZoXb1pTQgLNwDewCRkXTSd0VD2UnGaEqh9OBYLx6U4QpTvTGuKtpRiWBAAdeDq6
         BupIKIXcNl5Jz9YKhzqCZK1Zqb6IeNpvb7fpbUcyQY8vS/dUjH/ef8j3NZEU1GlKSkJ5
         KtoaRb8jEUBKaeh9EDW7vyVfw83qUDyWWtZPLL7bbZyLBEvN6jw/u2ubAUqXn8x1atsw
         HieA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BySxdp/7FbkyS9rQ/+SYkYHjIbHSrwzWviAFRY2ZPdQ=;
        b=FBD9alGEue1n+SuF9QoT2xgDzmsKjw4GEVRNtEZGkQgVlvXV9LBhSozE8BPQMbPofV
         7sc9d0mFwttbqmBheYkcLdlxdCsJcn7r/+RFOGjbADG8ej90DyLfavBYPg7wdWXQNh1C
         CS6DO+Hrm8mVdZinNIrThXpSBFBqbUq8eDrUw9SmPLEfSoEChox0X6EK9wlpse1piqSX
         eNOrdTkKnXyE0fR/pXKVnYPEUbl1Fa4gabq8fPA05+jZRtEk6bs4XqcDLb1YQRAgFJyP
         XTcqqi83mnZ75pYg/ZfMN856xMXEU48wTk0qtGH/koCMQ3Dz/qu8HUJvL9pXEONcA+Xz
         PAhw==
X-Gm-Message-State: ACrzQf1rARwb23/Qvl+CvCdNywOyOwrLSvTlvT4IfgubZwhsJw/+3H40
	uqcIAsS3C/w2qios+v/+disbPo1dXJUm63KSCM/1BQ==
X-Google-Smtp-Source: AMsMyM5h/BK7dlR9tXFEYHomDewWZpzTj+DR/oCqXMDG+trxJqZakFJMlhmhsO/VcM4HGEgEalX+qA4zQQDUKnfZXJ4=
X-Received: by 2002:a17:902:7145:b0:187:2356:c29d with SMTP id
 u5-20020a170902714500b001872356c29dmr43846977plm.154.1667885812893; Mon, 07
 Nov 2022 21:36:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221028105402.2030192-1-maz@kernel.org> <20221028105402.2030192-12-maz@kernel.org>
 <CAAeT=FyiNeRun7oRL83AUkVabUSb9pxL2SS9yZwi1rjFnbhH6g@mail.gmail.com>
 <87tu3gfi8u.wl-maz@kernel.org> <CAAeT=FwViQRmyJjf3jxcWnLFQAYob8uvvx7QNhWyj6OmaYDKyg@mail.gmail.com>
 <86bkpmrjv8.wl-maz@kernel.org> <CAAeT=Fzp-7MMBJshAAQBgFwXLH2z5ASDgmDBLNJsQoFA=MSciw@mail.gmail.com>
 <87pme0fdvp.wl-maz@kernel.org>
In-Reply-To: <87pme0fdvp.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 7 Nov 2022 21:36:36 -0800
Message-ID: <CAAeT=Fzgu1iaMmGXWZcmj9ifmchKXZXG2y7ksvQzoTGAQ=G-jw@mail.gmail.com>
Subject: Re: [PATCH v2 11/14] KVM: arm64: PMU: Allow ID_AA64DFR0_EL1.PMUver to
 be set from userspace
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221108053636.4gfsDoyNZvRVw1KyLDQEFujPbpgiJ4W71l9Sc2UeJ9w@z>

Hi Marc,

> > BTW, if we have no intention of supporting a mix of vCPUs with and
> > without PMU, I think it would be nice if we have a clear comment on
> > that in the code.  Or I'm hoping to disallow it if possible though.
>
> I'm not sure we're in a position to do this right now. The current API
> has always (for good or bad reasons) been per-vcpu as it is tied to
> the vcpu initialisation.

Thank you for your comments!
Then, when a guest that has a mix of vCPUs with and without PMU,
userspace can set kvm->arch.dfr0_pmuver to zero or IMPDEF, and the
PMUVER for vCPUs with PMU will become 0 or IMPDEF as I mentioned.
For instance, on the host whose PMUVER==1, if vCPU#0 has no PMU(PMUVER==0),
vCPU#1 has PMU(PMUVER==1), if the guest is migrated to another host with
same CPU features (PMUVER==1), if SET_ONE_REG of ID_AA64DFR0_EL1 for vCPU#0
is done after for vCPU#1, kvm->arch.dfr0_pmuver will be set to 0, and
the guest will see PMUVER==0 even for vCPU1.

Should we be concerned about this case?

Thank you,
Reiji
