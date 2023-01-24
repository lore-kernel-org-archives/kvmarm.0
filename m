Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423CF7C
	for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 00:51:30 +0000 (UTC)
Received: by mail-ed1-f52.google.com with SMTP id s3so16666712edd.4
        for <kvmarm@lists.linux.dev>; Mon, 23 Jan 2023 16:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=M2kD3GwOu1cuqUDf6v9BDb+wpn8NSWwJtfH+fWMIGrs=;
        b=TEQYkWqdmsV7t1y8yvJ2IfOpQzMb6o/P7CXThq+2vLZEIqTjY9ANhiIt4ZN75UgF2C
         xGxPUvHzVvqWxS+vETbzDygQr2QpPAx1+6BNR7Fdz4HrOxvOuoX6PhKRHZ/vqseZiJjP
         fOwlq5NoNxAf/z6tGp42Gi5zejvAW8ehUZG6l+47liPkYH2KE3KVkrqJnvPPFLSzK8he
         ZOfJ70E8RJG0D5wfccS8HETnYX/gVUBkGhsypQmNi8tg2z+kAgCpfbs/dao1EpK5fGb0
         Vi80bBcrGSiAisd87Wf1r3zHql2bMJAnWynWect2boedk+Zaf8y7rdGRRsiShs+fwvqF
         xcEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M2kD3GwOu1cuqUDf6v9BDb+wpn8NSWwJtfH+fWMIGrs=;
        b=AYBAHq+qBaPWBssGKiY3vGnwrvRzvAqVd0d4D812ZLQFpzh9co4fLdjFAMzkiHKwkq
         I7Sm1x3ObkdpQ/NoLjPxxV11muUBZEzjqvJSQ2MK/1gsE9VP76KRXiAnqiBH3eyEcbpc
         wTrgG9LLiX8qe85UV8kq3iEUnj5d5DA+FRK0LtIm8h+N0W3/dAhEAn9ca9akE4Js43yh
         jAe+RGnilOD2XbW97his7O9GIUW92/zzBIH0gwULWJaz85p9MiugSX7y1BneqnXvl+7n
         sZ5pMi88KzKCzALKfT+rCJbo+ASXtWUeBQEGAintJJpQ/p+d86eCMvLDot+W52KqBC+Z
         03PQ==
X-Gm-Message-State: AFqh2krhlNLg4BAJ0J0hSH4jJVF4izGpAf/NrWb8zXyU3wlfT7rodU6o
	r4MgENWJ4UX3HXasTKnr5Jy6rDK2ZQ5nOmYEEa/BuA==
X-Google-Smtp-Source: AMrXdXuiR2zDQjQTwOKPYxYiv6nBQxYDOm6Uo5rrXeXJwtr1kC3DgQfxY5fX74WNUq+cFZTNBOgpsUR83oMPt3dcFxI=
X-Received: by 2002:a50:ee12:0:b0:499:7efc:1d78 with SMTP id
 g18-20020a50ee12000000b004997efc1d78mr2851639eds.81.1674521488275; Mon, 23
 Jan 2023 16:51:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com> <20230113035000.480021-2-ricarkol@google.com>
In-Reply-To: <20230113035000.480021-2-ricarkol@google.com>
From: Ben Gardon <bgardon@google.com>
Date: Mon, 23 Jan 2023 16:51:16 -0800
Message-ID: <CANgfPd9gMoR=F3uKhDtjsUV0efuoNvCLV0o0WoJKm9zx_PaKsQ@mail.gmail.com>
Subject: Re: [PATCH 1/9] KVM: arm64: Add KVM_PGTABLE_WALK_REMOVED into ctx->flags
To: Ricardo Koller <ricarkol@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, qperret@google.com, catalin.marinas@arm.com, 
	andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com, 
	suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com, 
	reijiw@google.com, rananta@google.com, ricarkol@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 12, 2023 at 7:50 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> Add a flag to kvm_pgtable_visit_ctx, KVM_PGTABLE_WALK_REMOVED, to
> indicate that the walk is on a removed table not accesible to the HW
> page-table walker. Then use it to avoid doing break-before-make or
> performing CMOs (Cache Maintenance Operations) when mapping a removed

Nit: Should this say unmapping? Or are we actually going to use this
to map memory ?

> table. This is safe as these removed tables are not visible to the HW
> page-table walker. This will be used in a subsequent commit for
...
