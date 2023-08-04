Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D335BA2C
	for <kvmarm@lists.linux.dev>; Fri,  4 Aug 2023 22:47:46 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-583a89cccf6so27121637b3.1
        for <kvmarm@lists.linux.dev>; Fri, 04 Aug 2023 15:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691189266; x=1691794066;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6tuWqEnyJSC5e6pWov8J90I61X00yfI6yYMjidRy0tQ=;
        b=g7Yvrn8iSMnCj4SuV2yrtZRX2OpYiJGTlIhSEmmtv8ehUJHaNA9hhBocjtXpUpgbxN
         vhFfvXm6x3FsM6AlfhY2Kwyj2q/MN9VrNdTpIKw7tIANs0Zg/j/0D1qc4t5QR8Q81FK4
         9/54nfjgATi5+rPXrlNFoaJxIjFDn2iNNZQ4qdKPShZdW7QS67Gsor8MpFhCLAm1hYAY
         acdCN9Oo9Z7LMVFmGDIkNHaZRpGT3SR370RM4nYUWvyO3cGGQcD+VmseCdnCRbNUwgNR
         n22aG/2qshigvW9vFtHcBSrIWq48Yw7Hgpkx+lbFJnrOXFpot8IRhMWuprCSU4u4wUGN
         lFNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691189266; x=1691794066;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6tuWqEnyJSC5e6pWov8J90I61X00yfI6yYMjidRy0tQ=;
        b=M55ldP5xffLEw0kF4phqRI5QnrF6LBdXkXroumqiZacG4DCMZJQ3az66TC/tRFdmam
         fd4LEjOuj4u2Jbedil3IaUxfyETJfr9gT834QdRz1dwhfMVE4KfL2E9Y3vC5Srwh+tc9
         XuDucA+K4QzW0UcVSLhNi3f1qhRz9qEdVkqG1wmy3liSsEnOxQSCntw9N34Toq+ioFq0
         kwmqTcysEWA42R+Ibgrx5gY8+nqMWacc05XRs20xdh/WamYI8lbwdaaQ19wDD6PnCcHP
         Nv6qB2c9aP9Oq6yJSsnlhb8E7/GzN8w1GwweZ+gZ4WQ+Tz8y66S0RnHz3AMbpOnG9Dou
         OHLg==
X-Gm-Message-State: AOJu0YxtoZDcazzfQXAXYfQCsdi/GS9vKZ6oSRQWMTP6Aewzf03dHJqA
	GhSm7pnEL3VHLxMnzvEpjYiTsvKltm0=
X-Google-Smtp-Source: AGHT+IEBfvSRHnqgnE9fKrdfP2e064b06EXPO0wfS8+MrpP9vX1HNlA898i1TT0tgMr1PpybIT4/siTf2gk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ca0c:0:b0:56c:e0c5:de88 with SMTP id
 p12-20020a81ca0c000000b0056ce0c5de88mr21466ywi.1.1691189265819; Fri, 04 Aug
 2023 15:47:45 -0700 (PDT)
Date: Fri, 4 Aug 2023 15:47:43 -0700
In-Reply-To: <20230704075054.3344915-1-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com>
Message-ID: <ZM2AD26Mp31tHuH9@google.com>
Subject: Re: [PATCH v7 0/8] KVM: allow mapping non-refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Cc: Marc Zyngier <maz@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, Peter Xu <peterx@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 04, 2023, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> This patch series adds support for mapping VM_IO and VM_PFNMAP memory
> that is backed by struct pages that aren't currently being refcounted
> (e.g. tail pages of non-compound higher order allocations) into the
> guest.

Aplogies for the slow review, I'm done with feedback for this version.

FWIW, it's probably too bit late to catch 6.6, especially since we need acks from
ARM and PPC, but 6.7 should be very doable unless someone outright objects.

Thanks for being persistent!
