Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6BA10E9
	for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 16:30:37 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id jl3so15226144plb.8
        for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 08:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WH8dogHFrbtrUPEbTBAkEB7mODqHtTEzSy6ZDTyFYCI=;
        b=WqiILCejXByq7mamwSjvTiYhIhl53/a2879xufNpHveZ8AIUNVb+4zlySeCSihVmSm
         gJf66uxD1WRxyv/4BCgTGAqbglO6dw8+pTFOPnclDIc+YSPpQB57ZAy33aD13BdzzPI1
         dInQeQMWl3qD/4PKwtrmTJa5ing9r20v+i372/Nfy49LOkBayOWmfA5WmeWivFXZxYP2
         1AHUKId0tUghQm3anOW//uwwdVWqPmqsNCcVSZ0RM2A1nFyWRQdkiGbHsSytDqdkGzUC
         3tzXB4DQntgwPvMNUXciOpDlA5KWVPh1AU9Qx3B9BYntzBmHvB5il8FiQFoj11LlVFKR
         wFZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WH8dogHFrbtrUPEbTBAkEB7mODqHtTEzSy6ZDTyFYCI=;
        b=Wm5g+ydN1oGTKK3wbZhd39MLUgoJwWWPBbQkKuHB6cSXigfoap0bQM42mYGmKxUK41
         aSAeeJjMMSu3QPaiyr2BV3Wsrso0E+PlAjJM7BHNNdffrXgIcXZE2fK/kwI8/KdUrnvf
         77Ee5/pIsGHnb9JhdYLGoatELm2PqZe4U1/mNEVoVrHRxUSN6dbc8uJlqnf3Pro/xAR8
         wDTHCvO2r8JmN1Q0gAlo2ogkGrVORLNRYYk25yyvCAXND3Enx3x9mAlaLm4SXxCnQGi+
         wIj6WY8LGweCJXI1qBsy+lUZR33ftJ+32r9xRv4llMZKNRd3EwVbane2buaFBpmaafmM
         W1Xg==
X-Gm-Message-State: AO0yUKVOrPCFbE1t9Yqh91MojsJ7+OFuQeIRoXFgk3Cm8FSGRoRGy8WE
	Q5wV+SPWDuxZS1arUOkCv3iyWA==
X-Google-Smtp-Source: AK7set9UXN5qqN6aG70o6t5zKAA4Z3NA/q+UNHRg2aZrGkThFvPzI7xb17REn2KRR4XlOebyQhldiw==
X-Received: by 2002:a17:90a:300e:b0:227:679:17df with SMTP id g14-20020a17090a300e00b00227067917dfmr231535pjb.0.1674577836722;
        Tue, 24 Jan 2023 08:30:36 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id nm1-20020a17090b19c100b0022717d8d835sm8814272pjb.16.2023.01.24.08.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 08:30:36 -0800 (PST)
Date: Tue, 24 Jan 2023 08:30:32 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Ben Gardon <bgardon@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
	yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, qperret@google.com, catalin.marinas@arm.com,
	andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com,
	suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com,
	reijiw@google.com, rananta@google.com, ricarkol@gmail.com
Subject: Re: [PATCH 1/9] KVM: arm64: Add KVM_PGTABLE_WALK_REMOVED into
 ctx->flags
Message-ID: <Y9AHqM2eYM11gIB9@google.com>
References: <20230113035000.480021-1-ricarkol@google.com>
 <20230113035000.480021-2-ricarkol@google.com>
 <CANgfPd9gMoR=F3uKhDtjsUV0efuoNvCLV0o0WoJKm9zx_PaKsQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd9gMoR=F3uKhDtjsUV0efuoNvCLV0o0WoJKm9zx_PaKsQ@mail.gmail.com>

On Mon, Jan 23, 2023 at 04:51:16PM -0800, Ben Gardon wrote:
> On Thu, Jan 12, 2023 at 7:50 PM Ricardo Koller <ricarkol@google.com> wrote:
> >
> > Add a flag to kvm_pgtable_visit_ctx, KVM_PGTABLE_WALK_REMOVED, to
> > indicate that the walk is on a removed table not accesible to the HW
> > page-table walker. Then use it to avoid doing break-before-make or
> > performing CMOs (Cache Maintenance Operations) when mapping a removed
> 
> Nit: Should this say unmapping? Or are we actually going to use this
> to map memory ?

As you mentioned in the next commit, this will be clearer if I use
"unliked" instead of "removed". Might end up rewriting this message as
well, as I will be using Oliver's suggestion of using multiple flags,
one for each operation to elide.

> 
> > table. This is safe as these removed tables are not visible to the HW
> > page-table walker. This will be used in a subsequent commit for
> ...
