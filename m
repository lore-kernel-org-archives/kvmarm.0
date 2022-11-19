Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FDF7C
	for <kvmarm@lists.linux.dev>; Sat, 19 Nov 2022 05:31:28 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id k15so6796120pfg.2
        for <kvmarm@lists.linux.dev>; Fri, 18 Nov 2022 21:31:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zA4MvfCx2wJ6ZC0yAwP3Kt5ez44MPaUUZGSZKLr05qU=;
        b=OViBe7Prr+WNneb+sFV50YXvGDB4BUPrIn0sCBrBFXjV6NuqIO2ITUpTAlVzYbM7fO
         A2NsPkpnPIkVBi71AwoceBT1dirH64Fmm0AM4Nrsa+IICdwYwARgMzukzOL+fAt6Dtkm
         ksr8oomCuHB4tc4g3EtEa8lIMU6XqB00JEOmWX2+atzDS/GVF/qn2JDIiljMGhHhmOVT
         6y8QjZuX1sqbBa0vzK6yN1SMxvRYk+xaGlRfyihgQDBBDVBI+z6m4wtEBvla+Bw6Lmnw
         iNvg9CkwSxC/yrVNd4VW4qTS6S8pJoKg5vt9rUisCnSNnTyh/bah2l25GOT2XjCjt7yr
         1M5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zA4MvfCx2wJ6ZC0yAwP3Kt5ez44MPaUUZGSZKLr05qU=;
        b=7syaaSQecnSN2gYfb6XQ7ksk34XXiDs7/lasWqFGIT7+1aAgsRD0kdcbKb3nmi+J3j
         iz79b1I31deOMvKY5xLCiDIsrHev3o0Pkq9OEarofR1Gcy3pEf6VCcEYUgs/xAOwPVpP
         5BscLDsyYVKFYe29tTI+ychv37tcqDVXyhbKrgInuLFuH/oawZFYaREKnkY4PFBdR0+p
         9BWJwoKW5OxZYO+m9GAJcamWA2RF01HoE8cKnc58vc8hmtDbDMBxZy2CD7mw+QbBBQwG
         +GzlhTFpZxvkUF5DLLT6qS3iiVWmaf17qq8Qx9hApYRo8ySVIogzAcDEGNzfZg7tg26G
         XpEg==
X-Gm-Message-State: ANoB5pk9DResmHRVq1E1FBE7NozdrvOxT/0xlbjyVyoE4HQigQ57BRjj
	ySB6Zi4lZR3FsQU/GhrCVJnghUycqA9sXnMapHvYXA==
X-Google-Smtp-Source: AA0mqf6QqOtcX601H4y3vkSngjFJKCDeIT0BRH0yTFy+3iR7DMokQILefhm0heQeNptOQNwem6K9h6J9RMChIkJjll8=
X-Received: by 2002:aa7:80d8:0:b0:56d:98e3:4df8 with SMTP id
 a24-20020aa780d8000000b0056d98e34df8mr10899836pfn.37.1668835888263; Fri, 18
 Nov 2022 21:31:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org> <20221113163832.3154370-12-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-12-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Fri, 18 Nov 2022 21:31:12 -0800
Message-ID: <CAAeT=Fzn2znqPRTH6TE_NbgD+OF8oLcFX5uooZ3Svn-OgBa7Gw@mail.gmail.com>
Subject: Re: [PATCH v4 11/16] KVM: arm64: PMU: Allow ID_AA64DFR0_EL1.PMUver to
 be set from userspace
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221119053112.xeNLAYHrZSjb4RTigdKbI86_3JxegoPaPmGuR1P4DUw@z>

On Sun, Nov 13, 2022 at 8:46 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Allow userspace to write ID_AA64DFR0_EL1, on the condition that only
> the PMUver field can be altered and be at most the one that was
> initially computed for the guest.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
